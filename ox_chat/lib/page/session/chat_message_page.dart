
import 'dart:ui';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/model/constant.dart';
import 'package:ox_chat/page/session/chat_channel_message_page.dart';
import 'package:ox_chat/page/session/chat_group_message_page.dart';
import 'package:ox_chat/page/session/chat_relay_group_msg_page.dart';
import 'package:ox_chat/page/session/chat_secret_message_page.dart';
import 'package:ox_chat/widget/common_chat_widget.dart';
import 'package:ox_chat/widget/not_contact_top_widget.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_localizable/ox_localizable.dart';

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
  }) async {

    final handler = ChatGeneralHandler(
      session: communityItem,
      anchorMsgId: anchorMsgId,
      unreadMessageCount: unreadMessageCount ?? 0,
    );
    await handler.initializeMessage();

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
      handler.enableBottomWidget = false;
      return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.transparent,
        transitionBuilder: (context, animation1, animation2, child) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              OXNavigator.pop(context);
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
                ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation1,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 20.px, top: Adapt.screenH * 0.1, right: 20.px, bottom: 24.px),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: Adapt.screenH * 0.6,
                          child: pageWidget,
                        ),
                        SizedBox(height: 8.px),
                        Container(
                          width: 180.px,
                          height: Adapt.screenH * 0.2,
                          alignment: Alignment.bottomRight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.px),
                            color: ThemeColor.color180.withOpacity(0.72),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, animation1, animation2) => Container(),
      );
    }
    if (isPushWithReplace) {
      return OXNavigator.pushReplacement(context, pageWidget);
    }
    return OXNavigator.pushPage(context, (context) => pageWidget!);
  }
}

class _ChatMessagePageState extends State<ChatMessagePage> {

  ChatGeneralHandler get handler => widget.handler;
  ChatSessionModelISAR get session => handler.session;
  UserDBISAR? get otherUser => handler.otherUser;
  final _controller = ScrollController();
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
    if (!handler.enableBottomWidget){
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.px),
        child: CommonChatWidget(
          handler: handler,
          customTopWidget: CommonAppBarNoPreferredSize(
            useLargeTitle: false,
            centerTitle: true,
            canBack: false,
            title: otherUser?.getUserShowName() ?? '',
            backgroundColor: ThemeColor.color200,
            leading: SizedBox(),
            actions: [
              OXUserAvatar(
                chatId: session.chatId,
                user: otherUser,
                size: Adapt.px(36),
                isClickable: true,
                onReturnFromNextPage: () {
                  setState(() { });
                },
              ),
              // SizedBox(
              //   width: 16.px,
              // ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: otherUser?.getUserShowName() ?? '',
        backgroundColor: ThemeColor.color200,
        actions: [
          Container(
            alignment: Alignment.center,
            child: OXUserAvatar(
              chatId: session.chatId,
              user: otherUser,
              size: Adapt.px(36),
              isClickable: true,
              onReturnFromNextPage: () {
                setState(() { });
              },
            ),
          ).setPadding(EdgeInsets.only(right: Adapt.px(24))),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body(){
   return CommonChatWidget(
      handler: handler,
      customTopWidget: isShowContactMenu
          ? NotContactTopWidget(
        chatSessionModel: session,
        onTap: _hideContactMenu,
      ) : null,
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
