import 'package:flutter/material.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image_gallery.dart';
import 'package:chatcore/chat-core.dart';

class MediaMessageViewer extends StatelessWidget {
  final List<MessageDBISAR> messages;
  final int initialIndex;

  const MediaMessageViewer({
    super.key,
    required this.messages,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CommonImageGallery(
      imageList: messages.map((e) => ImageEntry(
          id: initialIndex.toString(),
          url: e.decryptContent,
          decryptedKey: e.decryptSecret),
      ).toList(),
      initialPage: initialIndex,
      extraMenus: _buildShowInChatButton(context, messages[initialIndex]),
    );
  }

  Widget _buildShowInChatButton(BuildContext context,MessageDBISAR message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new GestureDetector(
          onTap: () async {
            _showInChatMessagePage(context,message);
            OXNavigator.pop(context);
          },
          child: Container(
            height: 48.px,
            padding: EdgeInsets.all(8.px),
            alignment: FractionalOffset.center,
            decoration: new BoxDecoration(
              color: ThemeColor.color180,
            ),
            child: Text(
              'Show in Chat',
              style: new TextStyle(
                color: ThemeColor.gray02,
                fontSize: 16.px,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        Container(
          height: 2.px,
          color: ThemeColor.dark01,
        ),
      ],
    );
  }

  void _showInChatMessagePage(
      BuildContext context,
      MessageDBISAR message,
      ) {
    final type = message.chatType;
    String chatId = '';
    switch (type) {
      case ChatType.chatSingle:
        chatId = message.sender;
        break;
      case ChatType.chatSecret:
        chatId = message.sessionId;
        break;
      case ChatType.chatGroup:
      case ChatType.chatRelayGroup:
      case ChatType.chatChannel:
        chatId = message.groupId;
        break;
    }
    final sessionModel = OXChatBinding.sharedInstance.sessionMap[chatId];
    if (sessionModel == null) return;
    switch (type) {
      case ChatType.chatSingle:
      case ChatType.chatChannel:
      case ChatType.chatSecret:
      case ChatType.chatGroup:
      case ChatType.chatRelayGroup:
        ChatMessagePage.open(
          context: context,
          communityItem: sessionModel,
          anchorMsgId: message.messageId,
        );
        break;
    }
  }
}