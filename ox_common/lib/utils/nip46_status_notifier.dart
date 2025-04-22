import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../navigator/navigator.dart';
import '../widgets/common_hint_dialog.dart';
import '../widgets/common_toast.dart';

extension NIP46ConnectionStatusEx on NIP46ConnectionStatus {
  String get text {
    switch (this) {
      case NIP46ConnectionStatus.connected:
        return Localized.text('ox_common.signer_connected');
      case NIP46ConnectionStatus.disconnected:
        return Localized.text('ox_common.signer_disconnected');
      case NIP46ConnectionStatus.connecting:
        return Localized.text('ox_common.signer_connecting');
      case NIP46ConnectionStatus.waitingForSigning:
        return Localized.text('ox_common.signer_waiting');
      case NIP46ConnectionStatus.approvedSigning:
        return Localized.text('ox_common.signer_signature');
    }
  }
}

class NIP46StatusNotifier {
  factory NIP46StatusNotifier() => sharedInstance;
  static final NIP46StatusNotifier sharedInstance = NIP46StatusNotifier._internal();
  NIP46StatusNotifier._internal();

  NIP46ConnectionStatus? _lastStatus;
  NIP46ConnectionStatus? _previousStatus;
  String? _currentUserPubkey;
  bool _isDialogShowing = false;
  Timer? _debounceTimer;

  void notify(NIP46ConnectionStatus status, UserDBISAR user) {

    if (_currentUserPubkey != null && _currentUserPubkey != user.pubKey) {
      _resetStatus();
    }
    _currentUserPubkey = user.pubKey;
    if (user.remoteSignerURI == null) return;
    final isSigningState = _isSigningStatus(status);
    if (!isSigningState && _lastStatus == status) return;
    _lastStatus = status;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _showStatusDialog(status);
    });
  }

  Future<void> _showStatusDialog(NIP46ConnectionStatus status) async {
    final context = OXNavigator.navigatorKey.currentContext;
    if (context == null) return;

    if (status == NIP46ConnectionStatus.connected &&
        _previousStatus != NIP46ConnectionStatus.disconnected) {
      _previousStatus = status;
      return;
    }

    _previousStatus = status;

    _dismissCurrentDialogIfNeeded(context);

    _isDialogShowing = true;

    if (_shouldAutoToast(status)) {
      CommonToast.instance.show(context, status.text, duration: 3000);
      _isDialogShowing = false;
      return;
    }

    await _showAutoDismissDialog(context: context, status: status, duration: const Duration(seconds: 3));
    _isDialogShowing = false;
  }

  Future<void> _showAutoDismissDialog({
    required BuildContext context,
    required NIP46ConnectionStatus status,
    Duration duration = const Duration(seconds: 3),
  }) async {
    final completer = Completer<void>();

    OXCommonHintDialog.show(
      context,
      title: Localized.text('ox_common.tips'),
      content: status.text,
      actionList: [
        OXCommonHintAction.sure(
          text: Localized.text('ox_common.confirm'),
          onTap: () {
            if (!completer.isCompleted) {
              completer.complete();
            }
            _isDialogShowing = false;
            OXNavigator.pop(context, true);
          },
        ),
      ],
      isRowAction: true,
      barrierDismissible: false,
    );

    Future.delayed(duration, () {
      if (!completer.isCompleted) {
        completer.complete();
        _isDialogShowing = false;
        if (Navigator.of(context).canPop()) {
          OXNavigator.pop(context);
        }
      }
    });

    await completer.future;
  }

  void _dismissCurrentDialogIfNeeded(BuildContext context) {
    if (_isDialogShowing) {
      if (Navigator.of(context).canPop()) {
        OXNavigator.pop(context);
      }
      _isDialogShowing = false;
    }
  }

  void _resetStatus() {
    _lastStatus = null;
    _previousStatus = null;
  }

  bool _isSigningStatus(NIP46ConnectionStatus status) {
    return status == NIP46ConnectionStatus.approvedSigning ||
        status == NIP46ConnectionStatus.waitingForSigning;
  }

  bool _shouldAutoToast(NIP46ConnectionStatus status) {
    return status == NIP46ConnectionStatus.connected ||
        status == NIP46ConnectionStatus.connecting ||
        status == NIP46ConnectionStatus.approvedSigning;
  }

  void dispose() {
    _debounceTimer?.cancel();
    _resetStatus();
    _isDialogShowing = false;
  }

  static Future<bool> remoteSignerTips(String content) async {
    final context = OXNavigator.navigatorKey.currentContext;
    if (context == null) return false;

    return await OXCommonHintDialog.show(
      context,
      title: Localized.text('ox_common.tips'),
      content: content,
      actionList: [
        OXCommonHintAction.cancel(
          onTap: () => OXNavigator.pop(context, false),
        ),
        OXCommonHintAction.sure(
          text: Localized.text('ox_common.confirm'),
          onTap: () => OXNavigator.pop(context, true),
        ),
      ],
      isRowAction: true,
      barrierDismissible: false,
    );
  }
}