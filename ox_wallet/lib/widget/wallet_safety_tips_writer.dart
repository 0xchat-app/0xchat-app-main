
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class TypewriterAnimatedText extends AnimatedText {
  // The text length is padded to cause extra cursor blinking after typing.
  static const extraLengthForBlinks = 8;

  /// The [Duration] of the delay between the apparition of each characters
  ///
  /// By default it is set to 30 milliseconds.
  final Duration speed;

  /// The [Curve] of the rate of change of animation over time.
  ///
  /// By default it is set to Curves.linear.
  final Curve curve;

  /// Cursor text. Defaults to underscore.
  final String cursor;

  final TextSpan? textSpan;

  TypewriterAnimatedText({
    String? text,
    this.textSpan,
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    this.speed = const Duration(milliseconds: 30),
    this.curve = Curves.linear,
    this.cursor = '_',
  }) : super(
    text: textSpan?.toPlainText() ?? text ?? '',
    textAlign: textAlign,
    textStyle: textStyle,
    duration: speed * ((textSpan?.toPlainText() ?? text ?? '').characters.length + extraLengthForBlinks),
  );

  late Animation<double> _typewriterText;

  @override
  Duration get remaining =>
      speed *
          (textCharacters.length + extraLengthForBlinks - _typewriterText.value);

  @override
  void initAnimation(AnimationController controller) {
    _typewriterText = CurveTween(
      curve: curve,
    ).animate(controller);
  }

  @override
  Widget completeText(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          textSpan ?? TextSpan(text: text),
          TextSpan(
            text: cursor,
            style: const TextStyle(color: Colors.transparent),
          )
        ],
        style: DefaultTextStyle.of(context).style.merge(textStyle),
      ),
      textAlign: textAlign,
    );
  }

  /// Widget showing partial text
  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    /// Output of CurveTween is in the range [0, 1] for majority of the curves.
    /// It is converted to [0, textCharacters.length + extraLengthForBlinks].
    final textLen = textCharacters.length;
    final typewriterValue = (_typewriterText.value.clamp(0, 1) *
        (textCharacters.length + extraLengthForBlinks))
        .round();

    var showCursor = true;
    if (typewriterValue == 0) {
      showCursor = false;
    } else if (typewriterValue > textLen) {
      showCursor = (typewriterValue - textLen) % 2 == 0;
    }

    return RichText(
      text: TextSpan(
        children: [
          textSpan != null
              ? _buildAnimatedTextSpan(textSpan!, typewriterValue)
              : TextSpan(
            text: text,
            style: DefaultTextStyle.of(context).style.merge(textStyle),
          ),
          TextSpan(
            text: cursor,
            style: showCursor ? null : const TextStyle(color: Colors.transparent),
          ),
        ],
        style: DefaultTextStyle.of(context).style.merge(textStyle),
      ),
      textAlign: textAlign,
    );
  }

  TextSpan _buildAnimatedTextSpan(TextSpan span, int value) {

    List<InlineSpan> spans = [];
    int currentLength = 0;

    void visitTextSpan(TextSpan span) {
      final String text = span.text ?? '';
      final int spanLength = text.length;

      if (currentLength + spanLength <= value) {
        spans.add(span);
        currentLength += spanLength;
      } else if (currentLength < value) {
        final int remainingLength = value - currentLength;
        spans.add(
          TextSpan(
            text: text.substring(0, remainingLength),
            style: span.style,
          ),
        );
        currentLength += remainingLength;
      }
    }

    for (final InlineSpan child in span.children ?? []) {
      if (child is TextSpan) {
        visitTextSpan(child);
        if (currentLength >= value) {
          break;
        }
      }
    }

    return TextSpan(
      style: span.style,
      children: spans,
    );
  }
}
