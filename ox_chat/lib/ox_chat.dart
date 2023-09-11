import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/page/contacts/contact_user_info_page.dart';
import 'package:ox_chat/page/contacts/contacts_page.dart';
import 'package:ox_chat/page/contacts/my_idcard_dialog.dart';
import 'package:ox_chat/page/session/chat_group_message_page.dart';
import 'package:ox_chat/page/session/chat_session_list_page.dart';
import 'package:ox_chat/page/session/search_page.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_module_service/ox_module_service.dart';

class OXChat extends OXFlutterModule {

  @override
  Future<void> setup() async {
    super.setup();
    OXModuleService.registerFlutterModule(moduleName, this);
    OXUserInfoManager.sharedInstance.initDataActions.add(() {
      OXChatBinding.sharedInstance.initLocalSession();
      ChatDataCache.shared.setup();
    });
  }

  @override
  Map<String, Function> get interfaces => {
    'showMyIdCardDialog': _showMyIdCardDialog,
    'chatSessionListPageWidget': _chatSessionListPageWidget,
    'contractsPageWidget': _contractsPageWidget,
    'sendCallMessage': _sendCallMessage,
  };

  @override
  String get moduleName => OXChatInterface.moduleName;

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'ChatGroupMessagePage':
        return OXNavigator.pushPage(
          context,
              (context) => ChatGroupMessagePage(
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
      case 'ContactFriendUserInfoPage':
        return OXNavigator.pushPage(
          context,
              (context) => ContactUserInfoPage(
            userDB: params?['userDB'],
          ),
        );
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

  void _sendCallMessage(ChatSessionModel session, String text, CallMessageType type) {

  }
}
