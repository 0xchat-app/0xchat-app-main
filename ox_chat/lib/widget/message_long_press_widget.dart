
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/model/constant.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/widget/reaction_input_widget.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/list_extension.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ItemModel {
  String title;
  AssetImageData icon;
  MessageLongPressEventType type;
  ItemModel(this.title, this.icon, this.type);
}

class AssetImageData {
  String path;
  String? package;
  AssetImageData(this.path, { this. package });
}

class MessageLongPressWidget extends StatefulWidget {

  final BuildContext pageContext;
  final types.Message message;
  final CustomPopupMenuController controller;
  final ChatGeneralHandler handler;

  MessageLongPressWidget({
    required this.pageContext,
    required this.message,
    required this.controller,
    required this.handler,
  });

  @override
  State<StatefulWidget> createState() => MessageLongPressWidgetState();
}

class _Layout {
  static get horizontalPadding => 8.px;
  static get verticalPadding => 16.px;
  static get menuItemWidth => 61.pxWithTextScale;
  static get menuIconSize => 24.pxWithTextScale;
}

class MessageLongPressWidgetState extends State<MessageLongPressWidget> {

  types.Message get message => widget.message;
  List<ItemModel> menuList = [];

  final maxCountOfRow = 5;

  bool onlyShowEmoji = false;

  @override
  void initState() {
    super.initState();
    prepareMenuItems();
  }

  void prepareMenuItems() {
    menuList.clear();
    // Base
    final message = this.message;
    menuList.addAll([
      if (message is types.TextMessage || message.isSingleEcashMessage || (message is types.CustomMessage && message.customType == CustomMessageType.imageSending))
        ItemModel(
          Localized.text('ox_chat.message_menu_copy'),
          AssetImageData('icon_copy.png', package: 'ox_chat'),
          MessageLongPressEventType.copy,
        ),
      // ItemModel(
      //   Localized.text('ox_chat.message_menu_report'),
      //   AssetImageData('icon_report.png', package: 'ox_chat'),
      //   MessageLongPressEventType.report,
      // ),
      ItemModel(
        Localized.text('ox_chat.message_menu_quote'),
        AssetImageData('icon_quote.png', package: 'ox_chat'),
        MessageLongPressEventType.quote,
      ),
      if (message is types.TextMessage)
        ItemModel(
          Localized.text('ox_chat.message_menu_translate'),
          AssetImageData('icon_settings_language.png', package: 'ox_usercenter'),
          MessageLongPressEventType.translate,
        ),
      ItemModel(
        Localized.text('ox_chat_ui.input_more_zaps'),
        AssetImageData('icon_zaps.png', package: 'ox_chat'),
        MessageLongPressEventType.zaps,
      ),
      // Show info option for private chat messages
      if (widget.handler.session.chatType == ChatType.chatSingle || widget.handler.session.chatType == ChatType.chatStranger)
        ItemModel(
          Localized.text('ox_chat.message_menu_info'),
          AssetImageData('icon_report.png', package: 'ox_chat'),
          MessageLongPressEventType.info,
        ),
      if (widget.handler.session.chatType == ChatType.chatRelayGroup || OXUserInfoManager.sharedInstance.isCurrentUser(message.author.id))
        ItemModel(
          Localized.text('ox_chat.message_menu_delete'),
          AssetImageData('icon_delete.png', package: 'ox_common'),
          MessageLongPressEventType.delete,
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = _Layout.horizontalPadding * 2 +
        _Layout.menuItemWidth * maxCountOfRow;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _Layout.horizontalPadding,
          vertical: _Layout.verticalPadding,
        ),
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: 300.px,
          minHeight: 131.px,
        ),
        color: ThemeColor.color180,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReactionInputWidget(
                expandedOnChange: (isExpended) => setState(() {
                  onlyShowEmoji = isExpended;
                }),
                reactionOnTap: (emojiEntry) {
                  widget.handler.reactionPressHandler(
                    widget.pageContext,
                    widget.message,
                    types.Reaction(content: emojiEntry.emoji)
                  );
                  widget.controller.hideMenu();
                },
              ),
              if (!onlyShowEmoji)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSeparator(),
                    buildMenuItemGrid(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSeparator() => Divider(height: 1, color: ThemeColor.color160,)
      .setPadding(EdgeInsets.symmetric(vertical: 12.px));

  Widget buildMenuItemGrid() {
    return Wrap(
      runSpacing: 16.px,
      children: menuList
          .map((item) => buildMenuItem(item))
          .toList()
          .insertEveryN(maxCountOfRow, buildSeparator()),
    );
  }

  Widget buildMenuItem(ItemModel item) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        widget.handler.menuItemPressHandler(widget.pageContext, widget.message, item.type);
        widget.controller.hideMenu();
      },
      child: Container(
        width: _Layout.menuItemWidth,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CommonImage(
              iconName: item.icon.path,
              size: _Layout.menuIconSize,
              color: ThemeColor.color0,
              package: item.icon.package,
            ),
            Text(
              item.title,
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ).setPaddingOnly(top: 6.px),
          ],
        ),
      ),
    );
  }
}