import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../state/inherited_chat_theme.dart';
import '../state/inherited_l10n.dart';

/// A class that represents send button widget.
class SendButton extends StatelessWidget {
  /// Creates send button widget.
  const SendButton({
    super.key,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
    required this.size,
  });

  /// Callback for send button tap event.
  final VoidCallback onPressed;

  /// Padding around the button.
  final EdgeInsets padding;

  final double size;

  @override
  Widget build(BuildContext context) => Container(
        child: CommonIconButton(
          iconName: 'chat_send.png',
          size: size,
          package: 'ox_chat_ui',
          color: InheritedChatTheme.of(context).theme.inputTextColor,
          onPressed: onPressed,
          padding: padding,
        ),
      );
}
