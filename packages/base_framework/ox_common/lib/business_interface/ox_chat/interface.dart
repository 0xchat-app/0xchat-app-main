
import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_module_service/ox_module_service.dart';

class OXChatInterface {

  static const moduleName = 'ox_chat';

  static bool sendEncryptedFileMessage(BuildContext? context, {
    required String url,
    required String receiverPubkey,
    required String key,
    String title = '',
    String subtitle = '',
  }) {
    OXChatInterface.sendTemplateMessage(
      context,
      receiverPubkey: receiverPubkey,
      title: title,
      subTitle: subtitle,
      link: CustomURIHelper.createModuleActionURI(
        module: OXChatInterface.moduleName,
        action: 'openWebviewForEncryptedFile',
        params: {
          'url': url,
          'key': key,
        },
      ),
    );
    return true;
  }

  static void sendTemplateMessage(
    BuildContext? context, {
      String receiverPubkey = '',
      String title = '',
      String subTitle = '',
      String icon = '',
      String link = '',
      int chatType = ChatType.chatSingle,
    }) {
    OXModuleService.invoke(
      moduleName,
      'sendTemplateMessage',
      [context],
      {
        #receiverPubkey: receiverPubkey,
        #title: title,
        #subTitle: subTitle,
        #icon: icon,
        #link: link,
        #chatType: chatType,
      },
    );
  }

  static Future<String?> tryDecodeNostrScheme(String content) async {
    String? result = await OXModuleService.invoke<Future<String?>>(
      moduleName,
      'getTryDecodeNostrScheme',
      [content],
    );
    return result;
  }

  static Future<List<UserDBISAR>?> pushUserSelectionPage({
    required BuildContext context,
    List<UserDBISAR>? userList,
    String? title,
    List<UserDBISAR>? defaultSelected,
    List<UserDBISAR>? additionalUserList,
    bool isMultiSelect = false,
    bool allowFetchUserFromRelay = false,
    bool Function(List<UserDBISAR> userList)? shouldPop,
  }) async {
    return OXModuleService.pushPage<List<UserDBISAR>?>(
      context,
      moduleName,
      'UserSelectionPage',
      {
        'title': title,
        'userList': userList,
        'defaultSelected': defaultSelected,
        'additionalUserList': additionalUserList,
        'isMultiSelect': isMultiSelect,
        'allowFetchUserFromRelay': allowFetchUserFromRelay,
        'shouldPop': shouldPop,
      },
    );
  }

  static Future<bool?> showCashuOpenDialog(String cashuToken) async {
    return OXModuleService.invoke<Future<bool?>>(
      moduleName,
      'showCashuOpenDialog',
      [cashuToken],
    );
  }

  static Widget showRelayInfoWidget({bool showRelayIcon = true}) {
    return OXModuleService.invoke(moduleName, 'showRelayInfoWidget', [showRelayIcon]);
  }

  static void addContact(BuildContext context) {
    OXModuleService.invoke(
      moduleName,
      'addContact',
      [context],
    );
  }

  static void addGroup(BuildContext context) {
    OXModuleService.invoke(
      moduleName,
      'addGroup',
      [context],
    );
  }
}
