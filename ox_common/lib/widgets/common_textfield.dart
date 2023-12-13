import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';

import 'common_network_image.dart';

enum TextFieldType { normal, phone, email, password }

class CommonTextField extends StatefulWidget {
  //Overall layout UI
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final TextFieldType type;

  //Top UI
  final String? title;
  final String? helpTips;
  final String? errorTips;
  final String? actionTitle;
  final VoidCallback? actionOnPressed;
  final bool canHiddenInput;
  final bool isHiddenInput;

  // InputView
  final String? countryCode;
  final String? countryImage;
  final Widget? palceholderName;
  final VoidCallback? countryCodeOnPressed;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final bool autofocus;
  final bool obscureText;
  final bool? inputEnabled;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  final bool needCaptchaButton;
  final String? captchaButtonTitle;
  final VoidCallback? captachaOnPressed;
  final bool captchaButtonEnable;
  final InputDecoration? decoration;
  final Widget? leftWidget;

  /// Bottom tip
  CommonTextField({
    Key? key,
    this.width,
    this.height,
    this.margin,
    this.type = TextFieldType.normal,
    this.title,
    this.helpTips,
    this.errorTips,
    this.actionTitle,
    this.actionOnPressed,
    this.canHiddenInput = false,
    this.isHiddenInput = false,
    this.countryCode,
    this.countryImage,
    this.palceholderName,
    this.countryCodeOnPressed,
    this.hintText,
    this.keyboardType,
    required this.controller,
    this.autofocus = false,
    this.obscureText = false,
    this.inputEnabled,
    this.onSubmitted,
    this.onChanged,
    this.inputFormatters,
    this.focusNode,
    this.decoration,
    this.needCaptchaButton = false,
    this.captchaButtonEnable = false,
    this.captchaButtonTitle,
    this.captachaOnPressed,
    this.leftWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CommonTextFieldState();
  }
}

class CommonTextFieldState<T extends CommonTextField> extends State<T> {
  bool _showClearButton = false;
  bool _obscureText = false;
  bool? _captchaButtonEnable = false;
  bool isHiddenInput = false;
  String? _captchaButtonTitle = '';
  String? _errorTips = '';
  String? _helpTips = '';
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText || widget.type == TextFieldType.password;
    _captchaButtonEnable = widget.captchaButtonEnable;
    _captchaButtonTitle = widget.captchaButtonTitle;
    _errorTips = widget.errorTips;
    _helpTips = widget.helpTips;
    isHiddenInput = widget.isHiddenInput;
    _focusNode = widget.focusNode ?? FocusNode();
    widget.controller.addListener(textEidtingListener);
    _focusNode!.addListener(() {
      _showClearButton = widget.controller.text.length > 0 && _focusNode!.hasFocus;
    });
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void textEidtingListener() {
    if (_showClearButton == widget.controller.text.length > 0) {
      return;
    }
    if (this.mounted) {
      setState(() {
        _showClearButton = !_showClearButton && _focusNode!.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildTopView(context),
          !isHiddenInput ? (widget.type == TextFieldType.phone ? buildPhoneInputView(context) : buildInputView(context)) : Container(),
          !isHiddenInput ? buildBootomView(context) : Container()
        ],
      ),
    );
  }

  Widget buildTopView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (widget.canHiddenInput && isHiddenInput)
              ? () {
                  setState(() {
                    isHiddenInput = !isHiddenInput;
                  });
                }
              : null,
          child: Container(
            child: Text(
              widget.title ?? "",
              maxLines: 3,
              style: Styles.titleStyles(),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        widget.canHiddenInput
            ? Container(
                margin: EdgeInsets.only(left: 2),
                child: OXButton(
                  onPressed: () {
                    setState(() {
                      isHiddenInput = !isHiddenInput;
                    });
                  },
                  minWidth: 1.0,
                  height: 1.0,
                  color: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: CommonImage(
                    iconName: !isHiddenInput ? 'icon_arrow_up.png' : 'icon_arrow_bottom.png',
                    width: Adapt.px(16),
                    height: Adapt.px(16),
                  ),
                ),
              )
            : Container(),
        Expanded(child: Container()),
        GestureDetector(
            onTap: widget.actionOnPressed ?? () {}, child: Text(widget.actionTitle ?? "", textAlign: TextAlign.right, style: Styles.actionViewStyles()))
      ],
    );
  }

  Widget buildInputView(BuildContext context) {
    return Container(
      height: Adapt.px(48),
      margin: EdgeInsets.only(top: Adapt.px(12)),
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.all(Radius.circular(Adapt.px(16))),
      ),
      child: Row(
        children: [
          widget.leftWidget ?? SizedBox(),
          Expanded(
            child: TextField(
                enabled: widget.inputEnabled,
                autofocus: widget.autofocus,
                style: Styles.textFieldStyles(),
                controller: widget.controller,
                obscureText: _obscureText,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                keyboardType: widget.keyboardType,
                textAlign: TextAlign.start,
                decoration: _defaultDecoration(),
                focusNode: _focusNode,
                inputFormatters: widget.inputFormatters,
                cursorColor: ThemeColor.red),
          ),
          _buildToolsView(context),
        ],
      ),
    );
  }

  Widget buildPhoneInputView(BuildContext context) {
    return Container(
      height: Adapt.px(48),
      margin: EdgeInsets.only(top: Adapt.px(6)),
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.all(Radius.circular(Adapt.px(4))),
      ),
      child: Row(
        children: [
          buildCodeView(context),
          Expanded(
            child: TextField(
                enabled: widget.inputEnabled,
                autofocus: widget.autofocus,
                style: Styles.textFieldStyles(),
                controller: widget.controller,
                obscureText: widget.obscureText,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                keyboardType: widget.keyboardType,
                textAlign: TextAlign.start,
                decoration: _defaultDecoration(),
                focusNode: widget.focusNode ?? FocusNode(),
                inputFormatters: widget.inputFormatters,
                cursorColor: ThemeColor.red),
          ),
          _buildToolsView(context),
        ],
      ),
    );
  }

  Widget buildCodeView(BuildContext context) {
    double wh = ((widget.countryImage != null && widget.countryImage!.isNotEmpty) || widget.palceholderName != null) ? 20 : 0;
    return GestureDetector(
      onTap: widget.countryCodeOnPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(left: 10),
              child: ClipOval(
                child: OXCachedNetworkImage(
                  imageUrl: widget.countryImage ?? "",
                  placeholder: (context, url) => widget.palceholderName ?? palceholder('', wh: wh),
                  errorWidget: (context, url, error) => widget.palceholderName ?? palceholder('', wh: wh),
                  width: Adapt.px(wh),
                  height: Adapt.px(wh),
                ),
              )),
          Container(
            margin: EdgeInsets.only(left: 4),
            child: Text(
              widget.countryCode ?? "+86",
              style: Styles.codeStyles(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 4),
            width: 16,
            child: CommonImage(
              iconName: 'icon_arrow_bottom.png',
              width: Adapt.px(16),
              height: Adapt.px(16),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 4),
            width: 1,
            height: 16,
            color: ThemeColor.gray02,
          ),
        ],
      ),
    );
  }

  Widget _buildToolsView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(margin: EdgeInsets.only(right: 4), child: _showClearButton ? buildClearButton(context) : emptyView(context)),
        widget.type == TextFieldType.password || widget.obscureText == true
            ? Container(
                margin: EdgeInsets.only(right: 4),
                child: widget.type == TextFieldType.password || widget.obscureText == true ? buildObscureView(context) : Container())
            : Container(),
        widget.needCaptchaButton
            ? Container(
                margin: EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: _captchaButtonEnable != null && _captchaButtonEnable! ? widget.captachaOnPressed : () {},
                  child: Text(
                    _captchaButtonTitle ?? "",
                    style: _captchaButtonEnable != null && _captchaButtonEnable! ? Styles.buttonNormalTextStyle() : Styles.buttonDisableTextStyle(),
                  ),
                ))
            : Container(
                margin: EdgeInsets.only(right: 6),
                child: emptyView(context),
              )
      ],
    );
  }

  Widget buildBootomView(BuildContext context) {
    String? tips = _helpTips ?? _errorTips;
    return tips != null
        ? Container(
            margin: EdgeInsets.only(top: 2),
            child: Text(
              tips,
              style: _errorTips != null ? Styles.errorStyle() : Styles.helpStyle(),
            ))
        : emptyView(context);
  }

  Widget buildObscureView(BuildContext context) {
    return OXButton(
        onPressed: () {
          setObscureText(!_obscureText);
        },
        color: Colors.transparent,
        splashColor: Colors.transparent,
        child: CommonImage(iconName: _obscureText ? 'icon_obscure.png' : 'icon_obscure_close.png', width: Adapt.px(24), height: Adapt.px(24)),
        minWidth: 1.0,
        height: 1.0);
  }

  Widget palceholder(String iconName, {double wh = 20}) {
    return CommonImage(
      iconName: iconName,
      width: Adapt.px(wh),
      height: Adapt.px(wh),
      package: 'ox_common',
    );
  }

  Widget buildClearButton(BuildContext context) {
    return OXButton(
        onPressed: () {
          setState(() {
            widget.controller.clear();
          });
        },
        color: Colors.transparent,
        splashColor: Colors.transparent,
        child: CommonImage(iconName: 'icon_clearbutton.png', width: Adapt.px(24), height: Adapt.px(24)),
        minWidth: 1.0,
        height: 1.0);
  }

  Widget emptyView(BuildContext context) {
    return Container();
  }

  InputDecoration? _defaultDecoration() {
    if (widget.decoration == null) {
      return InputDecoration(
          contentPadding: EdgeInsets.only(left: 16, right: 16), border: InputBorder.none, hintText: widget.hintText ?? "", hintStyle: Styles.hintStyles());
    }
    return widget.decoration;
  }

  setCaptchaButtonTitle(String title) {
    setState(() {
      _captchaButtonTitle = title;
    });
  }

  setCaptchaButtonEnable(bool enable) {
    setState(() {
      _captchaButtonEnable = enable;
    });
  }

  setObscureText(bool enable) {
    setState(() {
      _obscureText = enable;
    });
  }

  setErrorTips(String errorTips) {
    setState(() {
      _errorTips = errorTips;
      _helpTips = null;
    });
  }

  setHelpTips(String helpTips) {
    setState(() {
      _errorTips = null;
      _helpTips = helpTips;
    });
  }
}

class Styles {
  static TextStyle textFieldStyles() {
    return TextStyle(
      color: ThemeColor.color0,
      fontSize: Adapt.px(16),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle codeStyles() {
    return TextStyle(color: ThemeColor.white01, fontSize: Adapt.px(16), fontWeight: FontWeight.w500);
  }

  static TextStyle titleStyles() {
    return TextStyle(color: ThemeColor.color0, fontSize: Adapt.px(16), fontWeight: FontWeight.w600);
  }

  static TextStyle actionViewStyles() {
    return TextStyle(color: ThemeColor.red, fontSize: Adapt.px(14), fontWeight: FontWeight.w500);
  }

  static TextStyle hintStyles() {
    return TextStyle(color: ThemeColor.color100, fontSize: Adapt.px(16), fontWeight: FontWeight.w400);
  }

  static TextStyle buttonNormalTextStyle() {
    return TextStyle(color: ThemeColor.red, fontSize: Adapt.px(16), fontWeight: FontWeight.w500);
  }

  static TextStyle buttonDisableTextStyle() {
    return TextStyle(color: ThemeColor.gray02, fontSize: Adapt.px(16), fontWeight: FontWeight.w500);
  }

  static TextStyle errorStyle() {
    return TextStyle(color: ThemeColor.red, fontSize: Adapt.px(12));
  }

  static TextStyle helpStyle() {
    return TextStyle(color: ThemeColor.gray02, fontSize: Adapt.px(12));
  }
}
