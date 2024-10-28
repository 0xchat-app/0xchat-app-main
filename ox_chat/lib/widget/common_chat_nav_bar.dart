import 'package:flutter/material.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';

class CommonChatNavBar extends StatelessWidget implements PreferredSizeWidget {
  CommonChatNavBar({
    super.key,
    required this.handler,
    this.title = '',
    this.titleWidget,
    this.actions,
  });

  final ChatGeneralHandler handler;
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    Widget content = buildContent(context);
    if (handler.isPreviewMode) {
      content = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: content,
      );
    }
    return content;
  }

  Widget buildContent(BuildContext context) {
    return CommonAppBar(
      canBack: !handler.isPreviewMode,
      title: title,
      titleWidget: titleWidget,
      backgroundColor: ThemeColor.color200,
      backCallback: () {
        OXNavigator.popToRoot(context);
      },
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(CommonBarHeight);
}
