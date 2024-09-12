
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_draft_manager.dart';
import 'package:ox_chat/manager/chat_message_builder.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/utils/chat_voice_helper.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/utils/general_handler/chat_mention_handler.dart';
import 'package:ox_chat/utils/general_handler/message_data_controller.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
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

  ChatSessionModelISAR get session => widget.handler.session;

  MessageDataController get dataController => widget.handler.dataController;

  final pageConfig = ChatPageConfig();

  @override
  void initState() {
    tryInitDraft();
    super.initState();

    PromptToneManager.sharedInstance.isCurrencyChatPage = dataController.isInCurrentSession;
    OXChatBinding.sharedInstance.msgIsReaded = dataController.isInCurrentSession;
  }

  void tryInitDraft() {
    final draft = session.draft ?? '';
    if (draft.isNotEmpty) {
      widget.handler.inputController.text = draft;
      ChatDraftManager.shared.updateTempDraft(session.chatId, draft);
    }
  }

  @override
  void dispose() {
    PromptToneManager.sharedInstance.isCurrencyChatPage = null;
    OXChatBinding.sharedInstance.msgIsReaded = null;
    ChatDraftManager.shared.updateSessionDraft(session.chatId);
    widget.handler.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Chat(
      chatId: widget.handler.session.chatId,
      theme: pageConfig.pageTheme,
      anchorMsgId: widget.anchorMsgId,
      messages: widget.messages,
      isLastPage: !widget.handler.hasMoreMessage,
      onEndReached: () => dataController.loadMoreMessage(
        loadMsgCount: ChatPageConfig.messagesPerPage,
        isLoadBeforeData: true,
      ),
      onHeaderReached: () async {
        dataController.loadMoreMessage(
          loadMsgCount: ChatPageConfig.messagesPerPage,
          isLoadBeforeData: false,
        );
      },
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
      reactionViewBuilder: (types.Message message, {required int messageWidth}) =>
          ChatMessageBuilder.buildReactionsView(
            message,
            messageWidth: messageWidth,
            itemOnTap: (reaction) => widget.handler.reactionPressHandler(context, message, reaction.content),
          ),
      mentionUserListWidget: widget.handler.mentionHandler?.buildMentionUserList(),
      onAudioDataFetched: (message) async {
        final (sourceFile, duration) = await ChatVoiceMessageHelper.populateMessageWithAudioDetails(
          session: widget.handler.session,
          message: message,
        );
        if (duration != null) {
          dataController.updateMessage(
            message.copyWith(
              audioFile: sourceFile,
              duration: duration,
            ),
          );
        }
      },
      onInsertedContent: (KeyboardInsertedContent insertedContent) =>
          widget.handler.sendInsertedContentMessage(context, insertedContent),
    );
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
    dataController.updateMessage(updatedMessage);
  }
}