import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Recording state machine.
enum VoiceRecordingState {
  /// Mic button visible, nothing happening.
  idle,

  /// Finger held down, audio is being captured. Swipe hints visible.
  recording,

  /// Recording locked (user swiped up). Continues without holding.
  locked,

  /// Recording discarded (user swiped left or tapped trash).
  cancelled,
}

/// A WhatsApp / Telegram-style press-and-hold voice-message recorder.
///
/// Place this widget wherever you need a microphone button.  All recording
/// state, gestures, and the animated overlay are managed internally.
///
/// ```dart
/// VoiceMessageRecorder(
///   size: 24,
///   onSend: (path, duration) => handleVoiceMessage(path, duration),
/// )
/// ```
class VoiceMessageRecorder extends StatefulWidget {
  const VoiceMessageRecorder({
    super.key,
    required this.onSend,
    this.size = 24.0,
    this.padding = EdgeInsets.zero,
  });

  /// Called when the user finishes recording (release or stop-tap in locked
  /// mode).  [path] is a local file path; [duration] is the recorded length.
  final void Function(String path, Duration duration) onSend;

  /// Size of the microphone icon.  Defaults to 24.
  final double size;

  /// Padding around the mic button.
  final EdgeInsets padding;

  @override
  State<VoiceMessageRecorder> createState() => VoiceMessageRecorderState();
}

class VoiceMessageRecorderState extends State<VoiceMessageRecorder>
    with TickerProviderStateMixin {
  // ── Config ──────────────────────────────────────────────────────────────
  static const double _cancelThresholdPx = 80.0;
  static const double _lockThresholdPx = 80.0;
  static const int _maxDurationMs = 180 * 1000; // 3 minutes
  static const int _minDurationMs = 1000; // 1 second

  // ── State ────────────────────────────────────────────────────────────────
  VoiceRecordingState _state = VoiceRecordingState.idle;
  final Record _recorder = Record();
  String _filePath = '';
  int _elapsedMs = 0;
  Timer? _elapsedTimer;
  StreamSubscription? _ampSub;

  // Waveform: 30 bars, values 0.0–1.0 (newest is last).
  final List<double> _waveformBars = List.filled(30, 0.0);
  double _latestAmplitude = 0.0;
  final _rng = math.Random();

  // ── Gesture tracking ────────────────────────────────────────────────────
  // Progress values 0.0→1.0 used for hint colour feedback.
  double _cancelProgress = 0.0;
  double _lockProgress = 0.0;

  // ── Animations ───────────────────────────────────────────────────────────
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  // ── Overlay ──────────────────────────────────────────────────────────────
  OverlayEntry? _overlay;

  /// [LayerLink] lets the lock-hint bubble follow the mic button exactly.
  final LayerLink _layerLink = LayerLink();

  // ── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _removeOverlay();
    _pulseCtrl.dispose();
    _ampSub?.cancel();
    _elapsedTimer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String get _timerText {
    final m = (_elapsedMs ~/ 60000).toString().padLeft(2, '0');
    final s = ((_elapsedMs ~/ 1000) % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Recording core ────────────────────────────────────────────────────────

  Future<void> _startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Microphone permission required'),
          duration: Duration(seconds: 2),
        ));
      }
      _removeOverlay();
      if (mounted) setState(() => _state = VoiceRecordingState.idle);
      return;
    }

    final dir = await getTemporaryDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final useAac =
        !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
    _filePath = '${dir.path}/$ts.${useAac ? 'm4a' : 'wav'}';

    try {
      await _recorder.start(
        path: _filePath,
        encoder: useAac ? AudioEncoder.aacLc : AudioEncoder.wav,
        bitRate: 64000,
        samplingRate: 16000,
        numChannels: 1,
      );
    } catch (e) {
      debugPrint('VoiceMessageRecorder: start error: $e');
      _removeOverlay();
      if (mounted) setState(() => _state = VoiceRecordingState.idle);
      return;
    }

    // Best-effort amplitude subscription.
    try {
      _ampSub = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 100))
          .listen((amp) {
        if (!mounted) return;
        // amp.current is dBFS; map -60..0 dBFS → 0.05..1.0
        _latestAmplitude = ((amp.current + 60.0) / 60.0).clamp(0.05, 1.0);
      });
    } catch (_) {}

    // 100 ms tick drives both timer and waveform animation.
    _elapsedMs = 0;
    _elapsedTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      _elapsedMs += 100;
      if (_elapsedMs >= _maxDurationMs) {
        _elapsedTimer?.cancel();
        _finishRecording();
        return;
      }
      // Advance waveform bars.
      final double ampVal = _latestAmplitude > 0.02
          ? (_latestAmplitude * (0.75 + _rng.nextDouble() * 0.5))
              .clamp(0.05, 1.0)
              .toDouble()
          : (0.05 + _rng.nextDouble() * 0.2); // quiet shimmer
      _waveformBars.removeAt(0);
      _waveformBars.add(ampVal);
      _overlay?.markNeedsBuild();
    });
  }

  Future<void> _stopRecorder() async {
    _elapsedTimer?.cancel();
    _elapsedTimer = null;
    _ampSub?.cancel();
    _ampSub = null;
    try {
      if (await _recorder.isRecording()) await _recorder.stop();
    } catch (_) {}
  }

  Future<void> _finishRecording() async {
    if (_state == VoiceRecordingState.idle ||
        _state == VoiceRecordingState.cancelled) return;
    final path = _filePath;
    final duration = Duration(milliseconds: _elapsedMs);
    await _stopRecorder();
    _removeOverlay();
    if (mounted) setState(() => _state = VoiceRecordingState.idle);
    if (duration.inMilliseconds >= _minDurationMs) {
      widget.onSend(path, duration);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Recording too short'),
          duration: Duration(seconds: 1),
        ));
      }
    }
  }

  Future<void> _cancelRecording() async {
    if (_state == VoiceRecordingState.idle ||
        _state == VoiceRecordingState.cancelled) return;
    if (mounted) setState(() => _state = VoiceRecordingState.cancelled);
    await _stopRecorder();
    try {
      final f = File(_filePath);
      if (await f.exists()) await f.delete();
    } catch (_) {}
    _removeOverlay();
    if (mounted) setState(() => _state = VoiceRecordingState.idle);
  }

  void _lockRecording() {
    if (_state != VoiceRecordingState.recording) return;
    if (mounted) setState(() => _state = VoiceRecordingState.locked);
    _overlay?.markNeedsBuild();
  }

  // ── Overlay ───────────────────────────────────────────────────────────────

  void _showOverlay() {
    _removeOverlay();
    _overlay = OverlayEntry(builder: _buildOverlayContent);
    Overlay.of(context).insert(_overlay!);
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  Widget _buildOverlayContent(BuildContext context) {
    final mq = MediaQuery.of(context);
    final safeBottom = mq.padding.bottom;
    return Stack(
      children: [
        // ── Recording/locked bar that visually replaces the input bar ──────
        Positioned(
          left: 0,
          right: 0,
          bottom: safeBottom,
          child: Material(
            color: Colors.transparent,
            child: _state == VoiceRecordingState.locked
                ? _buildLockedBar()
                : _buildRecordingBar(),
          ),
        ),
        // ── Lock-hint bubble floating above the mic button ─────────────────
        if (_state == VoiceRecordingState.recording)
          CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: Alignment.topCenter,
            followerAnchor: Alignment.bottomCenter,
            offset: const Offset(0, -6),
            child: Material(
              color: Colors.transparent,
              child: _buildLockHint(),
            ),
          ),
      ],
    );
  }

  // ── Recording bar (press-and-hold state) ─────────────────────────────────

  Widget _buildRecordingBar() {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, _) {
        final isCancelling = _cancelProgress > 0.3;
        final cancelColor =
            isCancelling ? Colors.red : ThemeColor.color100;

        return Container(
          height: 56,
          margin: EdgeInsets.fromLTRB(
              Adapt.px(12), 0, Adapt.px(12), Adapt.px(10)),
          decoration: BoxDecoration(
            color: ThemeColor.color190,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: Adapt.px(14)),
              // Pulsing red recording dot
              _PulsingDot(animation: _pulseCtrl),
              SizedBox(width: Adapt.px(8)),
              // Timer
              Text(
                _timerText,
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: Adapt.px(10)),
              // Waveform fills remaining space
              Expanded(
                child: _VoiceWaveform(
                  bars: List<double>.unmodifiable(_waveformBars),
                  color: ThemeColor.gradientMainStart,
                  progress: 1.0, // always "filled" while recording
                ),
              ),
              SizedBox(width: Adapt.px(8)),
              // Cancel swipe hint
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left, color: cancelColor, size: 14),
                  Icon(Icons.chevron_left, color: cancelColor, size: 14),
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      'Slide to cancel',
                      style: TextStyle(
                        color: cancelColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              // Invisible mic placeholder keeps the button area blank while
              // the CompositedTransformFollower floats above it.
              SizedBox(width: widget.size + Adapt.px(24)),
            ],
          ),
        );
      },
    );
  }

  // ── Locked bar ────────────────────────────────────────────────────────────

  Widget _buildLockedBar() {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, _) {
        return Container(
          height: 56,
          margin: EdgeInsets.fromLTRB(
              Adapt.px(12), 0, Adapt.px(12), Adapt.px(10)),
          decoration: BoxDecoration(
            color: ThemeColor.color190,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: Adapt.px(10)),
              // Trash / cancel tap target
              GestureDetector(
                onTap: _cancelRecording,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: ThemeColor.color100,
                    size: 22,
                  ),
                ),
              ),
              SizedBox(width: Adapt.px(8)),
              // Pulsing dot
              _PulsingDot(animation: _pulseCtrl),
              SizedBox(width: Adapt.px(8)),
              // Timer
              Text(
                _timerText,
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: Adapt.px(10)),
              // Waveform
              Expanded(
                child: _VoiceWaveform(
                  bars: List<double>.unmodifiable(_waveformBars),
                  color: ThemeColor.gradientMainStart,
                  progress: 1.0,
                ),
              ),
              SizedBox(width: Adapt.px(6)),
              // Stop / send button
              GestureDetector(
                onTap: _finishRecording,
                child: Container(
                  margin: EdgeInsets.only(right: Adapt.px(10)),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ThemeColor.gradientMainStart,
                        ThemeColor.gradientMainEnd,
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Lock hint bubble ──────────────────────────────────────────────────────

  Widget _buildLockHint() {
    final nearLock = _lockProgress > 0.4;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      decoration: BoxDecoration(
        color: ThemeColor.color190,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: nearLock ? ThemeColor.gradientMainStart : ThemeColor.color180,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            nearLock ? Icons.lock : Icons.lock_outline,
            size: 16,
            color: nearLock ? ThemeColor.gradientMainStart : ThemeColor.color100,
          ),
          const SizedBox(height: 2),
          Icon(
            Icons.keyboard_arrow_up_rounded,
            size: 14,
            color: nearLock ? ThemeColor.gradientMainStart : ThemeColor.color120,
          ),
        ],
      ),
    );
  }

  // ── Gesture handlers ──────────────────────────────────────────────────────

  void _onLongPressStart(LongPressStartDetails d) async {
    if (_state != VoiceRecordingState.idle) return;
    _cancelProgress = 0.0;
    _lockProgress = 0.0;
    setState(() => _state = VoiceRecordingState.recording);
    _showOverlay();
    await _startRecording();
  }

  void _onLongPressMove(LongPressMoveUpdateDetails d) {
    if (_state == VoiceRecordingState.idle ||
        _state == VoiceRecordingState.cancelled ||
        _state == VoiceRecordingState.locked) return;

    // offsetFromOrigin is displacement from long-press origin in global coords.
    final dx = d.offsetFromOrigin.dx; // negative = swiping left
    final dy = d.offsetFromOrigin.dy; // negative = swiping up

    _cancelProgress = (-dx / _cancelThresholdPx).clamp(0.0, 1.0);
    _lockProgress = (-dy / _lockThresholdPx).clamp(0.0, 1.0);

    if (-dx >= _cancelThresholdPx) {
      _cancelRecording();
      return;
    }
    if (-dy >= _lockThresholdPx) {
      _lockRecording();
      return;
    }

    _overlay?.markNeedsBuild();
  }

  void _onLongPressEnd(LongPressEndDetails d) {
    if (_state == VoiceRecordingState.locked ||
        _state == VoiceRecordingState.idle ||
        _state == VoiceRecordingState.cancelled) return;
    _finishRecording();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onLongPressStart: _onLongPressStart,
          onLongPressMoveUpdate: _onLongPressMove,
          onLongPressEnd: _onLongPressEnd,
          child: CommonIconButton(
            iconName: 'chat_voice_icon.png',
            size: widget.size,
            package: 'ox_chat_ui',
            onPressed: () {}, // long press handled above; tap is a no-op
          ),
        ),
      ),
    );
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────

/// Animated red dot that pulses while recording is active.
class _PulsingDot extends AnimatedWidget {
  const _PulsingDot({required Animation<double> animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final t = (listenable as Animation<double>).value;
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.lerp(Colors.red.shade400, Colors.red.shade700, t),
      ),
    );
  }
}

/// Animated waveform bar visualizer.
///
/// [bars]     – list of amplitudes 0.0–1.0 (left = oldest, right = newest).
/// [progress] – 0.0–1.0; bars to the left of [progress] are fully opaque.
/// [color]    – accent color.
class _VoiceWaveform extends StatelessWidget {
  const _VoiceWaveform({
    required this.bars,
    required this.color,
    this.progress = 0.0,
  });

  final List<double> bars;
  final Color color;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter: _WaveformPainter(
          bars: bars,
          color: color,
          progress: progress,
        ),
        size: const Size(double.infinity, 32),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  const _WaveformPainter({
    required this.bars,
    required this.color,
    this.progress = 0.0,
  });

  final List<double> bars;
  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;
    final count = bars.length;
    final barW = size.width / count * 0.55;
    final slot = size.width / count;

    for (int i = 0; i < count; i++) {
      final x = i * slot;
      final barH = math.max(2.0, bars[i] * size.height);
      final top = (size.height - barH) / 2;

      // Bars that have "been played" are fully opaque; future bars are faded.
      final barMidFrac = (i + 0.5) / count;
      final isPlayed = barMidFrac <= progress;
      final opacity = isPlayed ? 1.0 : 0.25 + (i / count) * 0.25;

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = color.withOpacity(opacity.clamp(0.0, 1.0));

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, top, barW, barH),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.bars != bars || old.color != color || old.progress != progress;
}
