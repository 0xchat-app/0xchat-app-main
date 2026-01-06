import 'package:flutter/material.dart';
// common
import 'package:ox_common/utils/theme_color.dart';

class CommonInput extends StatelessWidget {
  final String? hintText;
  final TextEditingController? textController;
  final int? maxLines;
  final TextInputAction? inputAction;
  final ValueChanged<String>? onSubmitted;

  CommonInput({this.hintText, this.textController, this.maxLines, this.inputAction, this.onSubmitted});

  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        isCollapsed: true,
        hintStyle: TextStyle(
          color: ThemeColor.color100,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
      ),
      controller: textController,
      keyboardType: TextInputType.multiline,
      textInputAction: inputAction,
      style: TextStyle(
        color: ThemeColor.color40,
        fontWeight: FontWeight.w400,
      ),
      maxLines: maxLines,
      onSubmitted: onSubmitted,
    );
  }
}
