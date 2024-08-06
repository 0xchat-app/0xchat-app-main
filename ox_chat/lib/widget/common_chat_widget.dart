
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_message_builder.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/utils/chat_voice_helper.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/utils/general_handler/chat_mention_handler.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/web_url_helper.dart';
import 'package:ox_common/widgets/avatar.dart';

class CommonChatWidget extends StatefulWidget {

  CommonChatWidget({
    required this.handler,
    required this.messages,
    this.anchorMsgId,
    this.customTopWidget,
    this.customCenterWidget,
    this.customBottomWidget,
    this.bottomHintParam,
  });

  // Basic

  final ChatGeneralHandler handler;

  final List<types.Message> messages;

  // Custom

  final String? anchorMsgId;
  final Widget? customTopWidget;
  final Widget? customCenterWidget;
  final Widget? customBottomWidget;
  final ChatHintParam? bottomHintParam;

  @override
  State<StatefulWidget> createState() => CommonChatWidgetState();
}

class CommonChatWidgetState extends State<CommonChatWidget> {

  final pageConfig = ChatPageConfig();
  
  @override
  Widget build(BuildContext context) {
    return Chat(
      chatId: widget.handler.session.chatId,
      theme: pageConfig.pageTheme,
      anchorMsgId: widget.anchorMsgId,
      messages: widget.messages,
      isLastPage: !widget.handler.hasMoreMessage,
      onEndReached: loadMoreMessages,
      onMessageTap: widget.handler.messagePressHandler,
      onPreviewDataFetched: _handlePreviewDataFetched,
      onSendPressed: (msg) => widget.handler.sendTextMessage(context, msg.text),
      avatarBuilder: (message) => OXUserAvatar(
        user: message.author.sourceObject,
        size: 40.px,
        isCircular: false,
        isClickable: true,
        onReturnFromNextPage: () {
          setState(() { });
        },
        onLongPress: () {
          final user = message.author.sourceObject;
          if (user != null)
            widget.handler.mentionHandler?.addMentionText(user);
        },
      ),
      showUserNames: widget.handler.session.showUserNames,
      //Group chat display nickname
      user: widget.handler.author,
      useTopSafeAreaInset: true,
      inputMoreItems: pageConfig.inputMoreItemsWithHandler(widget.handler),
      onVoiceSend: (String path, Duration duration) => widget.handler.sendVoiceMessage(context, path, duration),
      onGifSend: (GiphyImage image) => widget.handler.sendGifImageMessage(context, image),
      onAttachmentPressed: () {},
      longPressWidgetBuilder: (context, message, controller) => pageConfig.longPressWidgetBuilder(
        context: context,
        message: message,
        controller: controller,
        handler: widget.handler,
      ),
      onMessageStatusTap: widget.handler.messageStatusPressHandler,
      textMessageOptions: widget.handler.textMessageOptions(context),
      imageGalleryOptions: pageConfig.imageGalleryOptions,
      customTopWidget: widget.customTopWidget,
      customCenterWidget: widget.customCenterWidget,
      customBottomWidget: widget.customBottomWidget,
      customMessageBuilder: ChatMessageBuilder.buildCustomMessage,
      imageMessageBuilder: ChatMessageBuilder.buildImageMessage,
      inputOptions: widget.handler.inputOptions,
      inputBottomView: widget.handler.replyHandler.buildReplyMessageWidget(),
      bottomHintParam: widget.bottomHintParam,
      onFocusNodeInitialized: widget.handler.replyHandler.focusNodeSetter,
      repliedMessageBuilder: ChatMessageBuilder.buildRepliedMessageView,
      reactionViewBuilder: ChatMessageBuilder.buildReactionsView,
      mentionUserListWidget: widget.handler.mentionHandler?.buildMentionUserList(),
      onAudioDataFetched: (message) => ChatVoiceMessageHelper.populateMessageWithAudioDetails(
        session: widget.handler.session,
        message: message,
      ),
      onInsertedContent: (KeyboardInsertedContent insertedContent) =>
          widget.handler.sendInsertedContentMessage(context, insertedContent),
      galleryCallback: (gallery) => widget.handler.gallery = gallery,
    );
  }

  Future<void> loadMoreMessages() async {
    await widget.handler.loadMoreMessage(widget.messages);
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    PreviewData previewData,
  ) {
    final messageList = [...widget.messages];
    final targetMessage = messageList.where((element) => element.id == message.id).firstOrNull;
    if (targetMessage is! types.TextMessage) return ;

    final updatedMessage = targetMessage.copyWith(
      previewData: previewData,
    );
    ChatDataCache.shared.updateMessage(session: widget.handler.session, message: updatedMessage);
  }
}

extension CommonChatSessionEx on ChatSessionModelISAR {
  bool get showUserNames => chatType != 0;
}