
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_chat/widget/reply_message_widget.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/num_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';

class ChatMessageBuilder {

  static Widget buildRepliedMessageView(types.Message message, {required int messageWidth}) {
    final repliedMessage = message.repliedMessage;
    if (repliedMessage == null) return SizedBox();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: messageWidth.toDouble(),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(12)),
          color: ThemeColor.color190,
        ),
        margin: EdgeInsets.only(top: Adapt.px(2)),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(12), vertical: Adapt.px(4)),
        child: Text(
          repliedMessage.replyDisplayContent,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: ThemeColor.color120,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  static Widget buildCustomMessage(types.CustomMessage message, {required int messageWidth}) {

    final type = message.customType;

    switch (type) {
      case CustomMessageType.zaps:
        return _buildZapsMessage(message);
    }

    return SizedBox();
  }

  static Widget _buildZapsMessage(types.CustomMessage message) {
    final amount = message.amount.formatWithCommas();
    final description = message.description;
    return Container(
      width: Adapt.px(240),
      height: Adapt.px(86),
      child: Column(
        children: [
          Expanded(child: Row(
            children: [
              CommonImage(
                iconName: 'icon_zaps_logo.png',
                package: 'ox_chat',
                size: Adapt.px(32),
              ).setPadding(EdgeInsets.only(right: Adapt.px(10))),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$amount Sats', style: TextStyle(color: ThemeColor.white, fontSize: 14, fontWeight: FontWeight.bold),),
                  Text(description, style: TextStyle(color: ThemeColor.white, fontSize: 12),),
                ],
              ))
            ],
          )),
          Container(
            color: ThemeColor.white.withOpacity(0.5),
            height: 0.5,
          ),
          Container(
            height: Adapt.px(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lightning Invoice', style: TextStyle(color: ThemeColor.white, fontSize: 12),),
                CommonImage(iconName: 'icon_zaps_0xchat.png', package: 'ox_chat', size: Adapt.px(16),)
              ],
            ),
          )
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(10))),
    );
  }
}