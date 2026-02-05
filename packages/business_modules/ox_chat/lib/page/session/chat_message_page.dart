import 'dart:io' show Platform, File, FileMode;

import 'package:chatcore/chat-core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ox_chat/model/constant.dart';
import 'package:ox_chat/page/session/chat_channel_message_page.dart';
import 'package:ox_chat/page/session/chat_group_message_page.dart';
import 'package:ox_chat/page/session/chat_relay_group_msg_page.dart';
import 'package:ox_chat/page/session/chat_secret_message_page.dart';
import 'package:ox_chat/widget/common_chat_nav_bar.dart';
import 'package:ox_chat/widget/common_chat_widget.dart';
import 'package:ox_chat/widget/contact_longpress_menu_dialog.dart';
import 'package:ox_chat/widget/not_contact_top_widget.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/widget/session_longpress_menu_dialog.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_localizable/ox_localizable.dart';

// #region agent log
void _debugLog(String location, String message, [Map<String, dynamic>? data]) {
  final now = DateTime.now();
  final ts = '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}.${now.millisecond.toString().padLeft(3,'0')}';
  debugPrint('[DEBUG][$ts] $location: $message ${data != null ? data.toString() : ''}');
}
// #endregion

class ChatMessagePage extends StatefulWidget {

  final ChatGeneralHandler handler;

  const ChatMessagePage({
    super.key,
    required this.handler,
  });

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();

  static open({
    required BuildContext context,
    required ChatSessionModelISAR communityItem,
    String? anchorMsgId,
    int? unreadMessageCount,
    bool isPushWithReplace = false,
    bool isLongPressShow = false,
    int fromWhere = 0,//0 session; 1 contacts.
  }) async {
    // #region agent log
    _debugLog('ChatMessagePage.open:START', 'open called', {'chatId': communityItem.chatId, 'chatType': communityItem.chatType});
    final openStartTime = DateTime.now().millisecondsSinceEpoch;
    // #endregion

    // #region agent log
    _debugLog('ChatMessagePage.open:BEFORE_HANDLER', 'creating ChatGeneralHandler');
    final handlerStartTime = DateTime.now().millisecondsSinceEpoch;
    // #endregion

    final handler = ChatGeneralHandler(
      session: communityItem,
      anchorMsgId: anchorMsgId,
      unreadMessageCount: unreadMessageCount ?? 0,
    );

    // #region agent log
    _debugLog('ChatMessagePage.open:AFTER_HANDLER', 'handler created', {'durationMs': DateTime.now().millisecondsSinceEpoch - handlerStartTime});
    // #endregion

    // #region agent log
    _debugLog('ChatMessagePage.open:BEFORE_INIT_MSG', 'calling initializeMessage');
    // #endregion

    handler.initializeMessage();

    Widget? pageWidget;
    final sessionType = communityItem.chatType;
    switch (sessionType) {
      case ChatType.chatSingle:
      case ChatType.chatStranger:
        pageWidget = ChatMessagePage(
          handler: handler,
        );
        break ;
      case ChatType.chatSecret:
        pageWidget = ChatSecretMessagePage(
          handler: handler,
        );
        break ;
      case ChatType.chatChannel:
        pageWidget = ChatChannelMessagePage(
          handler: handler,
        );
        break ;
      case ChatType.chatGroup:
        pageWidget = ChatGroupMessagePage(
          handler: handler,
        );
        break ;
      case ChatType.chatRelayGroup:
        pageWidget = ChatRelayGroupMsgPage(
          handler: handler,
        );
        break ;
    }

    if (pageWidget == null) return ;
    if (isLongPressShow){
      handler.isPreviewMode = true;
      if (fromWhere == 1){
        return ContactLongPressMenuDialog.showDialog(context: context, communityItem: communityItem, pageWidget: pageWidget);
      }
      return SessionLongPressMenuDialog.showDialog(context: context, communityItem: communityItem, pageWidget: pageWidget);
    }
    if (isPushWithReplace) {
      return OXNavigator.pushReplacement(context, pageWidget);
    }
    // #region agent log
    _debugLog('ChatMessagePage.open:BEFORE_PUSH', 'about to pushPage', {'totalSetupMs': DateTime.now().millisecondsSinceEpoch - openStartTime});
    final pushStartTime = DateTime.now().millisecondsSinceEpoch;
    // #endregion
    if (Platform.isLinux && kDebugMode) {
      debugPrint('[LINUX_DIAG] ChatMessagePage.open: about to push, chatId=${communityItem.chatId}');
    }
    final result = await OXNavigator.pushPage(context, (context) => pageWidget!);
    // #region agent log
    _debugLog('ChatMessagePage.open:AFTER_PUSH', 'pushPage returned', {'pushDurationMs': DateTime.now().millisecondsSinceEpoch - pushStartTime});
    // #endregion
    return result;
  }
}

class _ChatMessagePageState extends State<ChatMessagePage> {

  ChatGeneralHandler get handler => widget.handler;
  ChatSessionModelISAR get session => handler.session;
  UserDBISAR? get otherUser => handler.otherUser;
  bool isShowContactMenu = true;

  @override
  void initState() {
    super.initState();

    prepareData();
  }

  void prepareData() {
    _updateChatStatus();
    _handleAutoDelete();
    _handelDMRelay();
  }

  @override
  void dispose() {
    // close other uer dm relays
    Contacts.sharedInstance.closeUserDMRelays(session.chatId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonChatWidget(
      handler: handler,
      navBar: buildNavBar(),
      customTopWidget: isShowContactMenu
          ? NotContactTopWidget(
        chatSessionModel: session,
        onTap: _hideContactMenu,
      ) : null,
    );
  }

  PreferredSizeWidget buildNavBar() {
    return CommonChatNavBar(
      handler: handler,
      title: otherUser?.getUserShowName() ?? '',
      actions: [
        Container(
          alignment: Alignment.center,
          child: OXUserAvatar(
            chatId: session.chatId,
            user: otherUser,
            size: Adapt.px(36),
            isClickable: true,
            onReturnFromNextPage: () {
              if (!mounted) return ;
              setState(() { });
            },
          ),
        ),
      ],
    );
  }

  void _hideContactMenu() {
    setState(() {
      isShowContactMenu = false;
    });
  }

  void _updateChatStatus() {
    final userId = otherUser?.pubKey ?? '';
    if (userId.isEmpty) return ;

    final isContact = Contacts.sharedInstance.allContacts.containsKey(userId);
    isShowContactMenu = !isContact;
  }

  void _handleAutoDelete() {
    int? time = session.expiration;
    String timeStr = '';
    if(time != null && time > 0){
      if(time >= 24 * 3600){
        timeStr = (time ~/ (24*3600)).toString() + ' ' + Localized.text('ox_chat.day');
      } else if (time >= 3600){
        timeStr = '${(time ~/ 3600).toString()} ${Localized.text('ox_chat.hours')} ${Localized.text('ox_chat.and')} ${((time % 3600) ~/ 60).toString()} ${Localized.text('ox_chat.minutes')}';
      } else {
        timeStr = (time ~/ 60).toString() + ' ' + Localized.text('ox_chat.minutes');
      }
      handler.sendSystemMessage(
        Localized.text('ox_chat.str_dm_auto_delete_hint').replaceAll(r'${time}', timeStr),
        context: context,
        sendingType: ChatSendingType.memory,
      );
    }
  }

  Future<void> _handelDMRelay() async {
    Contacts.sharedInstance.connectUserDMRelays(session.chatId);
    await Account.sharedInstance.reloadProfileFromRelay(otherUser?.pubKey ?? '');
    if (otherUser?.dmRelayList?.isNotEmpty == false) {
      handler.sendSystemMessage(
        Localized.text('ox_chat.user_dmrelay_not_set_hint_message'),
        context: context,
        sendingType: ChatSendingType.memory,
      );
    } else {
      // connect to other uer dm relays
      Contacts.sharedInstance.connectUserDMRelays(session.chatId).then((result) {
         if (!result && mounted) {
           handler.sendSystemMessage(
             Localized.text('ox_chat.user_dmrelay_not_connect_hint_message'),
             context: context,
             sendingType: ChatSendingType.memory,
           );
         }
      });
      // check my dm relay
      if (handler.author.sourceObject?.dmRelayList?.isNotEmpty == false) {
        handler.sendSystemMessage(
          Localized.text('ox_chat.my_dmrelay_not_set_hint_message'),
          context: context,
          sendingType: ChatSendingType.memory,
        );
      }
    }
  }
}
