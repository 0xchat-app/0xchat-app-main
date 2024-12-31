// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'dart:ui';
import 'package:ox_theme/ox_theme.dart';

const double CommonBarHeight = 56.0;

const double LargeTitleHeight = 62.0;
// marked by ccso
const double MediumTitleHeight = 31.0;

class LargeTitle extends StatefulWidget implements PreferredSizeWidget {
  final Size preferredSize;
  final String title;

  LargeTitle(
      {this.title = ""})
      : preferredSize = Size.fromHeight(LargeTitleHeight);

  @override
  State<StatefulWidget> createState() {
    return LargeTitleState();
  }
}

// marked by ccso
class MediumTitle extends StatefulWidget implements PreferredSizeWidget {
  final Size preferredSize;
  final String title;

  MediumTitle(
      {this.title = ""})
      : preferredSize = Size.fromHeight(MediumTitleHeight);

  @override
  State<StatefulWidget> createState() {
    return MediumTitleState();
  }
}

class MediumTitleState extends State<MediumTitle> {
  @override
  Widget build(BuildContext context) {
    return buildMediumTitle();
  }

  Widget buildMediumTitle() {
    return Container(
      margin: new EdgeInsets.only(
          left: Adapt.px(15),
          top: kToolbarHeight + MediaQueryData.fromView(window).padding.top),
      child: new Text(
        widget.title,
        style: TextStyle(
          color: ThemeColor.white01,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
      ),
    );
  }
}

class LargeTitleState extends State<LargeTitle> {
  @override
  Widget build(BuildContext context) {
    return buildLargeTitle();
  }

  Widget buildLargeTitle() {
    return Container(
      margin: new EdgeInsets.only(
          left: Adapt.px(15),
          top: kToolbarHeight + MediaQueryData.fromView(window).padding.top),
      child: new Text(
        widget.title,
        style: TextStyle(
          color: ThemeColor.white01,
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
      ),
    );
  }
}

// marked by ccso
class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool canBack;
  final bool isClose;
  final VoidCallback? backCallback;
  final Brightness? brightness;
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleTextColor;
  final Widget? titleWidget;
  final Widget? leading;
  final double elevation;
  final bool centerTitle;
  final bool useLargeTitle;
  final Size preferredSize;
  final double titleSpacing;
  final double? leadingWidth;
  final bool useMediumTitle;

  CommonAppBar({
    this.isClose = false,
    this.canBack = true,
    this.backCallback,
    this.brightness,
    this.title = "",
    this.elevation = 0,
    this.titleWidget,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.titleTextColor,
    this.useLargeTitle = false,
    this.useMediumTitle = false,
    this.centerTitle = true,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.leadingWidth,
    Size? preferredSize,
     }) : preferredSize = preferredSize ?? Size.fromHeight(CommonBarHeight +
            (useLargeTitle == true
                ? LargeTitleHeight
                : useMediumTitle == true
                    ? MediumTitleHeight
                    : 0));

  @override
  State<StatefulWidget> createState() {
    return BaseAppBarState();
  }
}

class BaseAppBarState extends State<CommonAppBar> {
  @override
  void initState() {
    super.initState();
  }

  // marked by ccso
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        color: _defaultBackgroundColor(),
        padding: EdgeInsets.symmetric(horizontal: 24.px),
        child: AppBar(
          // brightness: _defaultBrightness(),
          title: widget.useLargeTitle || widget.useMediumTitle
              ? null
              : (widget.titleWidget ??
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.titleTextColor ?? ThemeColor.color0,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
          titleSpacing: widget.titleSpacing,
          backgroundColor: _defaultBackgroundColor(),
          surfaceTintColor: Colors.transparent,
          centerTitle: widget.centerTitle,
          elevation: widget.elevation,
          leading: _buildLeading(),
          actions: _buildActions(widget.actions),
          flexibleSpace: widget.useLargeTitle
              ? Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.042),
                  child: LargeTitle(
                    title: widget.title,
                  ),
                )
              : (widget.useLargeTitle == false && widget.useMediumTitle == true)
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.051),
                      child: MediumTitle(
                        title: widget.title,
                      ),
                    )
                  : null,
          leadingWidth: widget.leadingWidth,
        ),
      ),
    );
  }

  Color _defaultBackgroundColor() {
    return widget.backgroundColor ?? ThemeColor.color190;
  }

  // Brightness _defaultBrightness() {
  //   return widget.brightness ?? ThemeManager.brightness();
  // }

  List<Widget>? _buildActions(List<Widget>? actions) {
    if (actions == null) return null;
    return actions;
  }

  Widget? _buildLeading() {
    if (widget.leading != null) {
      return Align(
        alignment: Localized.getTextDirectionForLang() == TextDirection.ltr ?  Alignment.centerLeft : Alignment.centerRight,
        child: widget.leading,
      );
    }
    if (widget.isClose) {
      return Builder(
        builder: (BuildContext content) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Align(
              alignment: Localized.getTextDirectionForLang() == TextDirection.ltr ?  Alignment.centerLeft : Alignment.centerRight,
              child: CommonImage(
                iconName: "title_close.png",
                size:  24.px,
                useTheme: true,
              ),
            ),
            onTap: widget.backCallback ??
                () {
                  OXNavigator.pop(context);
                },
          );
        },
      );
    }
    if (widget.canBack) {
      return Builder(
        builder: (BuildContext content) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Align(
              alignment: Localized.getTextDirectionForLang() == TextDirection.ltr ?  Alignment.centerLeft : Alignment.centerRight,
              child: CommonImage(
                iconName: "icon_back_left_arrow.png",
                size: 24.px,
                useTheme: true,
              ),
            ),
            onTap: widget.backCallback ??
                () {
                  OXNavigator.pop(context);
                },
          );
        },
      );
    }
    return SizedBox();
  }
}


class CommonAppBarNoPreferredSize extends StatefulWidget{
  final bool canBack;
  final bool isClose;
  final VoidCallback? backCallback;
  final Brightness? brightness;
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleTextColor;
  final Widget? titleWidget;
  final Widget? leading;
  final double elevation;
  final bool centerTitle;
  final bool useLargeTitle;
  final double titleSpacing;
  final double? leadingWidth;
  final bool useMediumTitle;
  final bool isMute;

  CommonAppBarNoPreferredSize({
    this.isClose = false,
    this.canBack = true,
    this.backCallback,
    this.brightness,
    this.title = "",
    this.elevation = 0,
    this.titleWidget,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.titleTextColor,
    this.useLargeTitle = false,
    this.useMediumTitle = false,
    this.centerTitle = true,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.leadingWidth,
    this.isMute = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _CommonAppBarNoPreferredSizeState();
  }
}

class _CommonAppBarNoPreferredSizeState extends State<CommonAppBarNoPreferredSize> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.px,
      color: _defaultBackgroundColor(),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildLeading() ?? SizedBox(width: 24.px),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              widget.title,
              style: TextStyle(
                color: widget.titleTextColor ?? ThemeColor.color0,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.actions != null)
                  for (Widget actionView in widget.actions!) actionView,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _defaultBackgroundColor() {
    return widget.backgroundColor ?? ThemeColor.color190;
  }

  Widget? _buildLeading() {
    if (widget.leading != null) {
      return widget.leading;
    }
    if (widget.isClose) {
      return Builder(
        builder: (BuildContext content) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CommonImage(
                iconName: "title_close.png",
                size:  24.px,
                useTheme: true,
              ),
            ).setPaddingOnly(left: 24.px),
            onTap: widget.backCallback ??
                    () {
                  OXNavigator.pop(context);
                },
          );
        },
      );
    }
    if (widget.canBack) {
      return Builder(
        builder: (BuildContext content) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CommonImage(
                iconName: "icon_back_left_arrow.png",
                size: 24.px,
                useTheme: true,
              ),
            ).setPaddingOnly(left: 24.px),
            onTap: widget.backCallback ??
                    () {
                  OXNavigator.pop(context);
                },
          );
        },
      );
    }
    return null;
  }
}