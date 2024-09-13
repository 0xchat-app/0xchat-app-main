
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
import 'package:scroll_to_index/scroll_to_index.dart';

class CommonChatWidget extends StatefulWidget {

  CommonChatWidget({
    required this.handler,
    this.customTopWidget,
    this.customCenterWidget,
    this.customBottomWidget,
    this.bottomHintParam,
  });

  // Basic

  final ChatGeneralHandler handler;

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

  final pageConfig = ChatPageConfig();

  final AutoScrollController scrollController = AutoScrollController();

  @override
  void initState() {
    tryInitDraft();
    super.initState();

    mentionStateInitialize();
    PromptToneManager.sharedInstance.isCurrencyChatPage = dataController.isInCurrentSession;
    OXChatBinding.sharedInstance.msgIsReaded = dataController.isInCurrentSession;
  }

  void tryInitDraft() {
    final draft = session.draft ?? '';
    if (draft.isNotEmpty) {
      handler.inputController.text = draft;
      ChatDraftManager.shared.updateTempDraft(session.chatId, draft);
    }
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
    return ValueListenableBuilder(
      valueListenable: dataController.messageValueNotifier,
      builder: (BuildContext context, messages, Widget? child) {
        return Chat(
          scrollController: scrollController,
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
          customMessageBuilder: ChatMessageBuilder.buildCustomMessage,
          imageMessageBuilder: ChatMessageBuilder.buildImageMessage,
          inputOptions: handler.inputOptions,
          inputBottomView: handler.replyHandler.buildReplyMessageWidget(),
          bottomHintParam: widget.bottomHintParam,
          onFocusNodeInitialized: handler.replyHandler.focusNodeSetter,
          repliedMessageBuilder: (types.Message message, {required int messageWidth}) =>
              ChatMessageBuilder.buildRepliedMessageView(
                message,
                messageWidth: messageWidth,
                onTap: (repliedMessageId) async {
                  if (repliedMessageId.isEmpty) return ;
                  await dataController.replaceWithNearbyMessage(targetMessageId: repliedMessageId);
                  final index = dataController.getMessageIndex(repliedMessageId);
                  if (index > -1) {
                    scrollController.scrollToIndex(
                      index,
                      preferPosition: AutoScrollPosition.middle,
                    );
                  }
                },
              ),
          reactionViewBuilder: (types.Message message, {required int messageWidth}) =>
              ChatMessageBuilder.buildReactionsView(
                message,
                messageWidth: messageWidth,
                itemOnTap: (reaction) => handler.reactionPressHandler(context, message, reaction.content),
              ),
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
            if (dataController.hasMoreNewMessage) {
              dataController.insertFirstPageMessages(
                firstPageMessageCount: ChatPageConfig.messagesPerPage,
                scrollAction: () async {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInQuad,
                  );
                },
              );
            } else {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInQuad,
              );
            }
          }
        );
      }
    );
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    PreviewData previewData,
  ) {
    final targetMessage = dataController.getMessage(message.id);
    if (targetMessage is! types.TextMessage) return ;

    final updatedMessage = targetMessage.copyWith(
      previewData: previewData,
    );
    dataController.updateMessage(updatedMessage);
  }
}