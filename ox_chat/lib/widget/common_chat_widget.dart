
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_draft_manager.dart';
import 'package:ox_chat/manager/chat_message_builder.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/manager/chat_page_config.dart';
import 'package:ox_chat/utils/chat_voice_helper.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/widget/chat_highlight_message_widget.dart';
import 'package:ox_chat/utils/general_handler/chat_mention_handler.dart';
import 'package:ox_chat/utils/general_handler/message_data_controller.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/web_url_helper.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../utils/general_handler/chat_highlight_message_handler.dart';

class CommonChatWidget extends StatefulWidget {

  CommonChatWidget({
    required this.handler,
    this.navBar,
    this.customTopWidget,
    this.customCenterWidget,
    this.customBottomWidget,
    this.bottomHintParam,
  });

  // Basic

  final ChatGeneralHandler handler;
  final PreferredSizeWidget? navBar;

  // Custom

  final Widget? customTopWidget;
  final Widget? customCenterWidget;
  final Widget? customBottomWidget;
  final ChatHintParam? bottomHintParam;

  @override
  State<StatefulWidget> createState() => CommonChatWidgetState();
}

class CommonChatWidgetState extends State<CommonChatWidget> {

  ChatGeneralHandler get handler => widget.handler;
  ChatSessionModelISAR get session => handler.session;
  MessageDataController get dataController => handler.dataController;
  ChatHighlightMessageHandler get highlightMessageHandler => handler.highlightMessageHandler;

  final pageConfig = ChatPageConfig();

  final GlobalKey<ChatState> chatWidgetKey = GlobalKey<ChatState>();
  final AutoScrollController scrollController = AutoScrollController();
  Duration scrollDuration = const Duration(milliseconds: 100);

  bool isShowScrollToBottomWidget = false;

  @override
  void initState() {
    super.initState();

    tryInitDraft();
    tryInitReply();
    mentionStateInitialize();
    if (!handler.isPreviewMode) {
      PromptToneManager.sharedInstance.isCurrencyChatPage = dataController.isInCurrentSession;
      OXChatBinding.sharedInstance.msgIsReaded = dataController.isInCurrentSession;
    }
  }

  void tryInitDraft() {
    final draft = session.draft ?? '';
    if (draft.isEmpty) return ;

    handler.inputController.text = draft;
    ChatDraftManager.shared.updateTempDraft(session.chatId, draft);
  }

  void tryInitReply() async {
    final replyMessageId = session.replyMessageId ?? '';
    if (replyMessageId.isEmpty) return ;

    final message = (await dataController.getLocalMessageWithIds([replyMessageId])).firstOrNull;
    if (message == null) return ;

    handler.replyHandler.updateReplyMessage(message);
  }

  void mentionStateInitialize() {
    if (session.isMentioned) {
      OXChatBinding.sharedInstance.updateChatSession(session.chatId, isMentioned: false);
    }
  }

  @override
  void dispose() {
    PromptToneManager.sharedInstance.isCurrencyChatPage = null;
    OXChatBinding.sharedInstance.msgIsReaded = null;
    ChatDraftManager.shared.updateSessionDraft(session.chatId);
    handler.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.handler.isPreviewMode) {
      return Column(
        children: [
          widget.navBar ?? const SizedBox(),
          Expanded(child: buildChatContentWidget()),
        ],
      );
    }

    return Scaffold(
      backgroundColor: ThemeColor.color200,
      resizeToAvoidBottomInset: false,
      appBar: widget.navBar,
      body: buildChatContentWidget(),
    );
  }

  Widget buildChatContentWidget() {
    return ValueListenableBuilder(
        valueListenable: dataController.messageValueNotifier,
        builder: (BuildContext context, messages, Widget? child) {
          return Chat(
            key: chatWidgetKey,
            scrollController: scrollController,
            isContentInteractive: !handler.isPreviewMode,
            chatId: handler.session.chatId,
            theme: pageConfig.pageTheme,
            anchorMsgId: handler.anchorMsgId,
            messages: messages,
            isFirstPage: !dataController.hasMoreNewMessage,
            isLastPage: !dataController.canLoadMoreMessage,
            onEndReached: () async {
              if (dataController.isMessageLoading) return ;
              dataController.loadMoreMessage(
                loadMsgCount: ChatPageConfig.messagesPerPage,
                isLoadOlderData: true,
              );
            },
            onHeaderReached: () async {
              if (dataController.isMessageLoading) return ;
              dataController.loadMoreMessage(
                loadMsgCount: ChatPageConfig.messagesPerPage,
                isLoadOlderData: false,
              );
            },
            onMessageTap: handler.messagePressHandler,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: (msg) => handler.sendTextMessage(context, msg.text),
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
                  handler.mentionHandler?.addMentionText(user);
              },
            ),
            showUserNames: handler.session.showUserNames,
            //Group chat display nickname
            user: handler.author,
            useTopSafeAreaInset: true,
            inputMoreItems: pageConfig.inputMoreItemsWithHandler(handler),
            onVoiceSend: (String path, Duration duration) => handler.sendVoiceMessage(context, path, duration),
            onGifSend: (GiphyImage image) => handler.sendGifImageMessage(context, image),
            onAttachmentPressed: () {},
            longPressWidgetBuilder: (context, message, controller) => pageConfig.longPressWidgetBuilder(
              context: context,
              message: message,
              controller: controller,
              handler: handler,
            ),
            onMessageStatusTap: handler.messageStatusPressHandler,
            textMessageOptions: handler.textMessageOptions(context),
            imageGalleryOptions: pageConfig.imageGalleryOptions,
            customTopWidget: widget.customTopWidget,
            customCenterWidget: widget.customCenterWidget,
            customBottomWidget: widget.customBottomWidget,
            customMessageBuilder: ({
              required types.CustomMessage message,
              required int messageWidth,
              required Widget reactionWidget,
            }) => ChatMessageBuilder.buildCustomMessage(
              message: message,
              messageWidth: messageWidth,
              reactionWidget: reactionWidget,
              receiverPubkey: handler.otherUser?.pubKey,
              messageUpdateCallback: (newMessage) {
                dataController.updateMessage(newMessage);
              },
            ),
            imageMessageBuilder: ChatMessageBuilder.buildImageMessage,
            inputOptions: handler.inputOptions,
            enableBottomWidget: !handler.isPreviewMode,
            inputBottomView: handler.replyHandler.buildReplyMessageWidget(),
            bottomHintParam: widget.bottomHintParam,
            onFocusNodeInitialized: handler.replyHandler.focusNodeSetter,
            repliedMessageBuilder: (types.Message message, {required int messageWidth}) =>
                ChatMessageBuilder.buildRepliedMessageView(
                  message,
                  messageWidth: messageWidth,
                  onTap: (message) async {
                    scrollToMessage(message?.id);
                  },
                ),
            reactionViewBuilder: (types.Message message, {required int messageWidth}) =>
                ChatMessageBuilder.buildReactionsView(
                  message,
                  messageWidth: messageWidth,
                  itemOnTap: (reaction) => handler.reactionPressHandler(context, message, reaction),
                ),
            highlightMessageWidget: ChatHighlightMessageWidget(
              handler: highlightMessageHandler,
              anchorMessageOnTap: scrollToMessage,
              scrollToBottomOnTap: scrollToNewestMessage,
              showScrollToBottomItem: isShowScrollToBottomWidget,
            ),
            isShowScrollToBottomButton: dataController.hasMoreNewMessage,
            isShowScrollToBottomButtonUpdateCallback: (value) {
              setState(() {
                isShowScrollToBottomWidget = value || dataController.hasMoreNewMessage;
              });
            },
            mentionUserListWidget: handler.mentionHandler?.buildMentionUserList(),
            onAudioDataFetched: (message) async {
              final (sourceFile, duration) = await ChatVoiceMessageHelper.populateMessageWithAudioDetails(
                session: handler.session,
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
                handler.sendInsertedContentMessage(context, insertedContent),
            textFieldHasFocus: () async {
              scrollToNewestMessage();
            },
            messageHasBuilder: (message, index) async {
              if (index == null) return ;

              highlightMessageHandler.tryRemoveMessageHighlightState(message.id);
            },
            replySwipeTriggerCallback: (message) {
              handler.replyHandler.quoteMenuItemPressHandler(message);
            },
          );
        }
    );
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    PreviewData previewData,
  ) {
    final messageId = message.remoteId ?? '';
    if (messageId.isEmpty) return ;

    final targetMessage = dataController.getMessage(messageId);
    if (targetMessage is! types.TextMessage) return ;

    // Update Mem
    final updatedMessage = targetMessage.copyWith(
      previewData: previewData,
    );
    dataController.updateMessage(updatedMessage);

    // Update DB
    ChatMessageHelper.updateMessageWithMessageId(
      messageId: messageId,
      previewData: previewData,
    );
  }

  void scrollToMessage(String? messageId) async {
    if (messageId == null || messageId.isEmpty) return ;

    var index = dataController.getMessageIndex(messageId);
    if (index > -1) {
      // Anchor message in cache
      await chatWidgetKey.currentState?.scrollToMessage(messageId);
    } else {
      // Anchor message not in cache
      await dataController.replaceWithNearbyMessage(targetMessageId: messageId);
      await Future.delayed(Duration(milliseconds: 300));
      index = dataController.getMessageIndex(messageId);
      if (index > -1) {
        await chatWidgetKey.currentState?.scrollToMessage(messageId);
      }
    }
  }

  void scrollToNewestMessage() {
    if (dataController.hasMoreNewMessage) {
      dataController.insertFirstPageMessages(
        firstPageMessageCount: ChatPageConfig.messagesPerPage,
        scrollAction: () async {
          scrollTo(0.0);
        },
      );
    } else {
      scrollTo(0.0);
    }
  }

  void scrollTo(double offset) async {
    if (!scrollController.hasClients) return ;

    await scrollController.animateTo(
      offset,
      duration: scrollDuration,
      curve: Curves.easeInQuad,
    );

    if (mounted) {
      setState(() {
        isShowScrollToBottomWidget = false;
      });
    }
  }
}