import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ox_common/navigator/dialog_router.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_text.dart';
import 'package:ox_localizable/ox_localizable.dart';

enum HintIconType { prompt }

extension Ex on HintIconType {
  String get imageName {
    switch (this) {
      case HintIconType.prompt:
        return 'icon_hint_prompt.png';
    }
  }
}

enum OXHintActionStyle {
  theme, // Background color: theme color
  gray, //  Background color: gray
  clear, // No background color.
  red,
}

class OXCommonHintAction {
  OXCommonHintAction({required this.text, this.value = '', this.style = OXHintActionStyle.theme, this.onTap});

  final String Function() text;
  final String value;
  final OXHintActionStyle style;
  final Function? onTap;

  factory OXCommonHintAction.cancel({Function? onTap}) => OXCommonHintAction(
        text: () => Localized.text('ox_common.cancel'),
        style: OXHintActionStyle.gray,
        onTap: onTap,
      );

  factory OXCommonHintAction.sure({required String text, Function? onTap}) => OXCommonHintAction(
        text: () => text,
        style: OXHintActionStyle.theme,
        onTap: onTap,
      );
}

class OXCommonHintDialog extends StatelessWidget {
  OXCommonHintDialog({this.title, this.content, this.contentView, this.icon, this.bgImage, this.isRowAction = false, required this.actionList})
      : assert(content == null || contentView == null, 'content and contentView cannot be used together');

  /// Title text
  final String? title;

  /// Content text
  final String? content;

  /// Content View
  final Widget? contentView;

  /// icon type
  final HintIconType? icon;

  /// Action List
  final List<OXCommonHintAction> actionList;

  /// Popup background image
  final AssetImage? bgImage;

  /// Whether it's a horizontal button layout
  bool isRowAction = false;

  /// Layout logic:
  /// Utilize a flexible composition approach, where each section has its own padding
  /// Overall - Width 300, height auto-adjusted, top padding 24, bottom padding 14
  /// Big Title - topPadding 4, bottomPadding 8
  /// ICON - topPadding 0, bottomPadding 14,
  /// Small Title - topPadding 4,  bottomPadding 0,
  /// Button overall area - topPadding 16, bottomPadding 14,
  /// Button - topPadding0, bottomPadding10,
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
            color: Colors.transparent,
            child: Container(
                width: Adapt.px(300.0),
                decoration: BoxDecoration(
                    color: bgImage == null ? ThemeColor.color180 : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    image: bgImage == null ? null : DecorationImage(image: bgImage!, fit: BoxFit.fill)),
                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[_buildTextArea(), _buildButtonArea(context)])),
        ));
  }

  Widget _buildTextArea() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          _buildIcon(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    var title = this.title;
    if (title == null || title.isEmpty) return Container(height: Adapt.px(12),);
    return Container(
      height: Adapt.px(48),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          fontSize: Adapt.px(15),
          fontWeight: FontWeight.w400,
          color: ThemeColor.color0,
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon == null) return SizedBox();
    return Container(
        padding: EdgeInsets.only(
          bottom: Adapt.px(14),
        ),
        child: CommonImage(
          iconName: icon!.imageName,
          height: Adapt.px(40),
          width: Adapt.px(40),
        ));
  }

  Widget _buildContent() {
    if (content == null && contentView == null) return SizedBox(height: Adapt.px(12),);
    return Container(
        padding: EdgeInsets.only(top: Adapt.px(12), left: Adapt.px(16), right: Adapt.px(16), bottom: Adapt.px(24)),
        child: contentView ??
            Text(
              content ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Adapt.px(14),
                fontWeight: FontWeight.w400,
                color: ThemeColor.white02,
              ),
            ));
  }

  Widget _buildButtonArea(BuildContext context) {
    bool isRowAction = (icon != null && actionList.length == 2) || this.isRowAction;
    Widget view = isRowAction ? _buildRowButtonArea(context, actionList) : _buildColumnButtonArea(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: Adapt.px(0.5),
            color: ThemeColor.color160,
          ),
          view,
        ],
      ),
    );
  }

  Widget _buildRowButtonArea(BuildContext context, List<OXCommonHintAction> actions,) {
    final aButtonAction = actions.length > 0 ? actions[0] : null;
    final bButtonAction = actions.length > 1 ? actions[1] : null;
    final aButton = aButtonAction != null ? _buildActionButton(context, aButtonAction) : null;
    final bButton = bButtonAction != null ? _buildActionButton(context, bButtonAction) : null;
    var widgetList = [aButton, bButton]
        .where((e) => e != null).cast<Widget>()
        .map((e) => Expanded(flex: 1,child: e,))
        .expand((e) => [e, Container(width: Adapt.px(0.5),color: ThemeColor.color160,)]).toList()
        ..removeLast();
    return Container(
      height: Adapt.px(56),
      child: Row(
        children: widgetList,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, OXCommonHintAction action) {
    final isThemeButton = action.style == OXHintActionStyle.theme;
    final text = action.text();
    final textColor = isThemeButton ? null : action.style == OXHintActionStyle.red ? ThemeColor.red1 : null;
    final textStyle = TextStyle(
      fontSize: Adapt.px(16),
      color: textColor,
    );
    final textWidget = isThemeButton
        ? OXText.themeText(text, style: textStyle,)
        : Text(text, style: textStyle,);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (action.onTap == null) {
          OXNavigator.pop(context);
        } else {
          action.onTap!();
        }
      },
      child: Container(
        child: Center(
          child: textWidget,
        ),
      ),
    );
  }

  Widget _buildColumnButtonArea(BuildContext context) {
    return Column(
      children: actionList.map((action) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: Adapt.px(10)),
          child: _buildButton(context, action),
        );
      }).toList(),
    );
  }

  Widget _buildButton(BuildContext context, OXCommonHintAction action) {
    switch (action.style) {
      case OXHintActionStyle.theme:
        return _buildThemeButton(context, action);
      case OXHintActionStyle.gray:
        return _buildGrayButton(context, action);
      case OXHintActionStyle.clear:
        return _buildClearButton(context, action);
      case OXHintActionStyle.red:
        return _buildRedButton(context, action);
    }
  }

  Widget _buildThemeButton(BuildContext context, OXCommonHintAction action) {
    if (action.style == OXHintActionStyle.theme) {
      return GestureDetector(
        onTap: () {
          if (action.onTap == null) {
            OXNavigator.pop(context);
          } else {
            action.onTap!();
          }
        },
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                ThemeColor.gradientMainEnd,
                ThemeColor.gradientMainStart,
              ],
            ).createShader(Offset.zero & bounds.size);
          },
          child: Container(
            padding: EdgeInsets.only(top: Adapt.px(17),bottom: Adapt.px(7)),
            child: Center(
              child: Text(
                action.text(),
                style: TextStyle(
                  fontSize: Adapt.px(16),
                  color: action.style == OXHintActionStyle.red
                      ? ThemeColor.red1
                      : null,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return CommonButton(
        content: action.text(),
        backgroundColor: Colors.transparent,
        borderSideColor: Colors.transparent,
        onPressed: () {
          if (action.onTap == null) {
            OXNavigator.pop(context);
          } else {
            action.onTap!();
          }
        });
  }

  Widget _buildGrayButton(BuildContext context, OXCommonHintAction action) {
    return CommonButton(
        content: action.text(),
        backgroundColor: ThemeColor.dark04,
        fontColor: ThemeColor.white01,
        borderSideColor: ThemeColor.dark04,
        onPressed: () {
          if (action.onTap == null) {
            OXNavigator.pop(context);
          } else {
            action.onTap!();
          }
        });
  }

  Widget _buildRedButton(BuildContext context, OXCommonHintAction action) {
    return CommonButton(
        content: action.text(),
        backgroundColor: Colors.transparent,
        fontColor: ThemeColor.red1,
        borderSideColor: Colors.transparent,
        onPressed: () {
          if (action.onTap == null) {
            OXNavigator.pop(context);
          } else {
            action.onTap!();
          }
        });
  }

  Widget _buildClearButton(BuildContext context, OXCommonHintAction action) {
    return CommonButton(
        content: action.text(),
        backgroundColor: Colors.transparent,
        fontColor: ThemeColor.main,
        borderSideColor: Colors.transparent,
        onPressed: () {
          if (action.onTap == null) {
            OXNavigator.pop(context);
          } else {
            action.onTap!();
          }
        });
  }

  /// Display a prompt dialog with an icon
  static Future<T?> showWithIcon<T extends Object?>(
    BuildContext context, {
    HintIconType icon = HintIconType.prompt,
    String? content,
    Widget? contentView,
    List<OXCommonHintAction>? actionList,
    Function? cancelOnTap,
    Function? sureOnTap,
    String? sureText,
    AssetImage? bgImage,
    bool isRowAction = false,
  }) async {
    assert(content == null || contentView == null, '"content" and "contentView" cannot be used simultaneously');
    actionList ??= [
      OXCommonHintAction.cancel(onTap: cancelOnTap),
      OXCommonHintAction.sure(text: sureText ?? Localized.text('ox_common.confirm'), onTap: sureOnTap)
    ];
    return showYLEDialogUntilAnimateFinish<T>(
        context: context,
        builder: (BuildContext context) => OXCommonHintDialog(
              icon: icon,
              content: content,
              contentView: contentView,
              actionList: actionList!,
              bgImage: bgImage,
              isRowAction: isRowAction,
            ));
  }

  /// Display a prompt dialog with an icon.
  static Future<bool> showDefaultWithIcon(
    BuildContext context, {
    HintIconType icon = HintIconType.prompt,
    String? content,
    Widget? contentView,
  }) async {
    assert(content == null || contentView == null, 'content and contentView cannot be used together');
    return await showWithIcon<bool>(
          context,
          content: content,
          contentView: contentView,
          actionList: [
            OXCommonHintAction.cancel(onTap: () => OXNavigator.pop(context, false)),
            OXCommonHintAction.sure(text: Localized.text('ox_common.confirm'), onTap: () => OXNavigator.pop(context, true))
          ],
        ) ??
        false;
  }

  /// Display a prompt dialog with a title
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    String? content,
    Widget? contentView,
    bool showCancelButton = false,
    List<OXCommonHintAction>? actionList,
    Function? sureOnTap,
    bool? barrierDismissible,
    RouteTransitionsBuilder? transitionBuilder,
    AssetImage? bgImage,
    bool isRowAction = false,
  }) {
    actionList ??= [
      OXCommonHintAction.sure(
          text: Localized.text('ox_common.complete'), onTap: sureOnTap)
    ];
    if (showCancelButton) {
      actionList.insert(0, OXCommonHintAction.cancel());
    }
    return showYLEDialogUntilAnimateFinish<T>(
      context: context,
      builder: (BuildContext context) => OXCommonHintDialog(
        title: title,
        contentView: contentView,
        content: content,
        actionList: actionList!,
        bgImage: bgImage,
        isRowAction: isRowAction,
      ),
      barrierDismissible: barrierDismissible,
      transitionBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2, Widget child) {
        return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animation1,
            curve: Curves.fastOutSlowIn,
          )),
          child: child,
        );
      },
    );
  }

  /// Display a prompt dialog with a title
  static Future<bool> showConfirmDialog(
      BuildContext context, {
        String? title,
        String? content,
      }) {
    final completer = Completer<bool>();
    OXCommonHintDialog.show(
      context,
      title: title,
      content: content,
      isRowAction: true,
      showCancelButton: true,
      sureOnTap: () {
        completer.complete(true);
      },
    ).then((value) {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
     });
    return completer.future;
  }
}
