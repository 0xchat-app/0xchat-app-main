
import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';
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

  static Future<List<UserDB>?> pushUserSelectionPage({
    required BuildContext context,
    List<UserDB>? userList,
    String? title,
    List<UserDB>? defaultSelected,
    List<UserDB>? additionalUserList,
    bool isMultiSelect = false,
    bool allowFetchUserFromRelay = false,
    bool Function(List<UserDB> userList)? shouldPop,
  }) async {
    return OXModuleService.pushPage<List<UserDB>?>(
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
}
