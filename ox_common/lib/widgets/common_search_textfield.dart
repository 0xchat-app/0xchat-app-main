
/// Title: search_textfield
/// Copyright: Copyright (c) 2023
///
/// @author George
/// @CheckItem Fill in by oneself
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../base.dart';

typedef InputCallBack = void Function(String value);

class CommonSearchTextField extends StatefulWidget {
  final String text;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final Widget? leftWidget; //Left widget, hidden by default
  final Widget? rightWidget; //Right widget, hidden by default
  final int maxLength; //The default value is 20
  final bool isShowDeleteBtn;
  final List<TextInputFormatter>? inputFormatters;
  final InputCallBack? inputCallBack;
  final bool isDense;
  final Color contentBgColor;
  final Color fillBgColor;
  final double? frameWidth;
  final ValueChanged<String>? onSubmitted;
  final bool? textFieldEnable;

  const CommonSearchTextField({
    Key? key,
    this.text = '',
    this.keyboardType = TextInputType.text,
    this.hintText = '',
    this.controller,
    this.focusNode,
    this.leftWidget,
    this.rightWidget,
    this.maxLength = 15,
    this.isShowDeleteBtn = false,
    this.inputFormatters,
    this.inputCallBack,
    this.contentBgColor = Colors.transparent,
    this.fillBgColor = Colors.black26,
    this.isDense= false,
    this.frameWidth,
    this.onSubmitted,
    this.textFieldEnable = true,
  }) : super(key: key);

  @override
  _CommonSearchTextFieldState createState() => _CommonSearchTextFieldState();
}

class _CommonSearchTextFieldState extends State<CommonSearchTextField> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late bool _isShowDelete;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textController = widget.controller != null ? widget.controller! : TextEditingController();
    _textController.text = widget.text;
    _focusNode = widget.focusNode != null ? widget.focusNode! : FocusNode();

    _isShowDelete = _focusNode.hasFocus && _textController.text.isNotEmpty;
    _textController.addListener(() {
      setState(() {
        _isShowDelete = _textController.text.isNotEmpty && _focusNode.hasFocus;
      });
    });
    _focusNode.addListener(() {
      setState(() {
        _isShowDelete = _textController.text.isNotEmpty && _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Adapt.px(48),
      decoration: BoxDecoration(
          color: widget.contentBgColor,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(16))),
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: Adapt.px(14), right: Adapt.px(8)),
                    child: _leftWidget(),
                  ),
                  Expanded(
                    child: TextField(
                      enabled: widget.textFieldEnable,
                      textAlignVertical: TextAlignVertical.center,
                      focusNode: _focusNode,
                      controller: _textController,
                      keyboardType: widget.keyboardType,
                      style: TextStyle(fontSize: Adapt.px(14),fontWeight: FontWeight.w500, color: ThemeColor.white01),
                      // style: TextStyle(fontSize: Adapt.px(14),fontWeight: Platform.isAndroid ? FontWeight.w600 : FontWeight.w500, color: ThemeColor.white01),
                      textInputAction: TextInputAction.done,
                      inputFormatters: widget.inputFormatters != null ? widget.inputFormatters : [LengthLimitingTextInputFormatter(widget.maxLength)],
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(fontSize: Adapt.px(17),fontWeight: FontWeight.w500, color: ThemeColor.color160),
                        // hintStyle: TextStyle(fontSize: Adapt.px(14),fontWeight: Platform.isAndroid ? FontWeight.w600 : FontWeight.w500, color: ThemeColor.dark06),
                        isDense: widget.isDense,
                        filled: false,
                        contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
//          suffixIcon:
                      ),
                      obscureText: false,
                      onChanged: (value) {
                        if (widget.inputCallBack != null) {
                          widget.inputCallBack!(_textController.text);
                        }
                      },
                      onSubmitted: widget.onSubmitted,
                    ),
                  ),
                  Offstage(
                    offstage: !widget.isShowDeleteBtn,
                    child: _isShowDelete
                        ? GestureDetector(
                            child: Container(
                              padding: EdgeInsets.only(right: Adapt.px(10)),
                              child: CommonImage(
                                iconName: 'icon_input_delete.png',
                                width: Adapt.px(24),
                                height: Adapt.px(24),
                                package: 'ox_common',
                              ),
                            ),
                            onTap: () {
                              _textController.text = "";
                              if (widget.inputCallBack != null) {
                                widget.inputCallBack!(_textController.text);
                              }
                            })
                        : Text(""),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: Adapt.px(32),
            alignment: Alignment.centerRight,
            child: widget.rightWidget != null ? widget.rightWidget! : Container(),
          )
        ],
      ),
    );
  }

  Widget _leftWidget() {
    return widget.leftWidget != null
        ? widget.leftWidget!
        : Image.asset(
            '${Config.imagePath}icon_chat_search.png',
            width: Adapt.px(20),
            height: Adapt.px(22),
          );
  }
}
