import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

class SatsAmountTextField extends StatefulWidget {
  final bool enable;
  final TextEditingController controller;

  const SatsAmountTextField({
    super.key,
    bool? enable,
    required this.controller
  }) : enable = enable ?? true;

  @override
  State<SatsAmountTextField> createState() => _SatsAmountTextFieldState();
}

class _SatsAmountTextFieldState extends State<SatsAmountTextField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    if(widget.enable){
      _controller.text = '0';
    }
    _focusNode.addListener(() {
      if(_focusNode.hasFocus && widget.enable){
        if(_controller.text == '0'){
          _controller.text = '';
        }
      }else{
        if(_controller.text.isEmpty){
          _controller.text = '0';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth * 0.88;
      return SizedBox(
        width: totalWidth,
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) {
              final width = _getTextFieldWidth(_controller.text,maxWidth: totalWidth) + 2;
              return Container(
                constraints: BoxConstraints(
                  minWidth: 0,
                  maxWidth: totalWidth,
                ),
                width: width,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  showCursor: true,
                  maxLines: 1,
                  enabled: widget.enable,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  scrollPadding: EdgeInsets.zero,
                  style: TextStyle(fontSize: 24.px,color: ThemeColor.color0,height: 34.px / 24.px),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  double _getTextWidth(TextStyle textStyle, String value, {double maxWidth = double.infinity}) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: value, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: maxWidth);

    return textPainter.size.width;
  }

  double _getTextFieldWidth(String value,{double maxWidth = double.infinity}){
    TextStyle textFieldStyle = TextStyle(fontSize: 24.px,color: ThemeColor.color0,height: 34.px / 24.px);
    double textFieldWidth = _getTextWidth(textFieldStyle, value,maxWidth: maxWidth);

    return textFieldWidth;
  }
}
