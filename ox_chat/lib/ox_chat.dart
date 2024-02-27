import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/page/contacts/contact_channel_detail_page.dart';
import 'package:ox_chat/page/contacts/contact_user_info_page.dart';
import 'package:ox_chat/page/contacts/contacts_page.dart';
import 'package:ox_chat/page/contacts/groups/group_info_page.dart';
import 'package:ox_chat/page/contacts/groups/group_share_page.dart';
import 'package:ox_chat/page/contacts/my_idcard_dialog.dart';
import 'package:ox_chat/page/session/chat_channel_message_page.dart';
import 'package:ox_chat/page/session/chat_choose_share_page.dart';
import 'package:ox_chat/page/session/chat_session_list_page.dart';
import 'package:ox_chat/page/session/search_page.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/business_interface/ox_usercenter/interface.dart';
import 'package:ox_common/business_interface/ox_usercenter/zaps_detail_model.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';




class OXChat extends OXFlutterModule {

  @override
  Future<void> setup() async {
    super.setup();
    OXUserInfoManager.sharedInstance.initDataActions.add(() async {
      await OXChatBinding.sharedInstance.initLocalSession();
      await ChatDataCache.shared.setup();
    });
    OXChatBinding.sharedInstance.sessionMessageTextBuilder = ChatMessageDBToUIHelper.sessionMessageTextBuilder;
  }

  @override
  Map<String, Function> get interfaces => {
    'showMyIdCardDialog': _showMyIdCardDialog,
    'chatSessionListPageWidget': _chatSessionListPageWidget,
    'contractsPageWidget': _contractsPageWidget,
    'groupSharePage': _jumpGroupSharePage,
    'sendSystemMsg': _sendSystemMsg,
    'contactUserInfoPage': _contactUserInfoPage,
    'contactChanneDetailsPage': _contactChanneDetailsPage,
    'groupInfoPage': _groupInfoPage,
    'commonWebview': _commonWebview,
    'zapsRecordDetail' : _zapsRecordDetail,
    'sendTextMsg': _sendTextMsg
  };

  @override
  String get moduleName => OXChatInterface.moduleName;

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'ChatGroupMessagePage':
        return OXNavigator.pushPage(
          context,
              (context) => ChatChannelMessagePage(
            communityItem: ChatSessionModel(
              chatId: params?['chatId'] ?? '',
              chatName: params?['chatName'] ?? '',
              chatType: params?['chatType'] ?? 0,
              createTime: params?['time'] ?? '',
              avatar: params?['avatar'] ?? '',
              groupId: params?['groupId'] ?? '',
            ),
          ),
        );
      case 'SearchPage':
        return SearchPage(
          searchPageType: SearchPageType.discover,
        ).show(context);
      case 'ContactUserInfoPage':
        return OXNavigator.pushPage(
          context,
          (context) => ContactUserInfoPage(
            pubkey: params?['pubkey'],
            chatId: params?['chatId'],
            isSecretChat: params?['isSecretChat'] ?? false,
          ),
        );
      case 'ContactChanneDetailsPage':
        return OXNavigator.pushPage(
          context,
          (context) => ContactChanneDetailsPage(
            channelDB: params?['channelDB'],
          ),
        );
      case 'GroupInfoPage':
        return OXNavigator.pushPage(
          context,
              (context) => GroupInfoPage(
            groupId: params?['groupId'],
          ),
        );
      case 'ChatChooseSharePage':
        return OXNavigator.pushPage(context, (context) => ChatChooseSharePage(
          msg: params?['url'] ?? '',
        ));
    }
    return null;
  }

  void _showMyIdCardDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MyIdCardDialog();
        });
  }

  Widget _chatSessionListPageWidget(BuildContext context) {
    return ChatSessionListPage();
  }

  Widget _contractsPageWidget(BuildContext context) {
    return ContractsPage();
  }

  void _jumpGroupSharePage(BuildContext? context,{required String groupPic, required String groupName, required String groupOwner, required String groupId, required String inviterPubKey}){
    OXNavigator.pushPage(context!, (context) => GroupSharePage(groupPic:groupPic,groupName:groupName,groupId: groupId,groupOwner:groupOwner,inviterPubKey:inviterPubKey));
  }

  void _contactUserInfoPage(BuildContext? context,{required String pubkey}){
    OXNavigator.pushPage(context!, (context) => ContactUserInfoPage(pubkey: pubkey));
  }

  Future<void> _contactChanneDetailsPage(BuildContext? context,{required String channelId}) async {
    ChannelDB? channelDB = Channels.sharedInstance.channels[channelId];
    if(channelDB == null){
      await OXLoading.show();
      List<ChannelDB> channels = await Channels.sharedInstance.getChannelsFromRelay(channelIds: [channelId]);
      await OXLoading.dismiss();
      channelDB = channels.length > 0 ? channels.first : null;
    }
    OXNavigator.pushPage(context!, (context) => ContactChanneDetailsPage(channelDB: channelDB ?? ChannelDB(channelId: channelId)));
  }

  Future<void> _groupInfoPage(BuildContext? context,{required String groupId}) async {
    OXNavigator.pushPage(context!, (context) => GroupInfoPage(groupId: groupId));
  }

  Future<void> _commonWebview(BuildContext? context,{required String url}) async {
    OXNavigator.presentPage(context!, allowPageScroll: true, (context) => CommonWebView(url), fullscreenDialog: true);
  }

  Future<void> _zapsRecordDetail(BuildContext? context,{required String invoice, required String amount, required String zapsTime}) async {
    final zapsDetail = ZapsRecordDetail(
      invoice: invoice,
      amount: int.parse(amount),
      fromPubKey: '',
      toPubKey: '',
      zapsTime: zapsTime,
      description: '',
      isConfirmed: false,
    );

    OXUserCenterInterface.jumpToZapsRecordPage(context!, zapsDetail);
  }

  void _sendSystemMsg(BuildContext context,{required String chatId,required String content, required String localTextKey}){
    UserDB? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;

    ChatSessionModel? sessionModel = OXChatBinding.sharedInstance.sessionMap[chatId];
    if(sessionModel == null) return;

    ChatGeneralHandler chatGeneralHandler = ChatGeneralHandler(
      author: types.User(
        id: userDB!.pubKey,
        sourceObject: userDB,
      ),
      session: sessionModel,
    );

    chatGeneralHandler.sendSystemMessage(
        context,
        content,
        localTextKey:localTextKey,
    );
  }

  void _sendTextMsg(BuildContext context, String chatId, String content) {
    ChatMessageSendEx.sendTextMessageHandler(chatId, content);
  }
}
