import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/page/contacts/contact_channel_detail_page.dart';
import 'package:ox_chat/page/contacts/contact_user_info_page.dart';
import 'package:ox_chat/page/contacts/contacts_page.dart';
import 'package:ox_chat/page/contacts/groups/group_info_page.dart';
import 'package:ox_chat/page/contacts/groups/group_share_page.dart';
import 'package:ox_chat/page/contacts/groups/relay_group_info_page.dart';
import 'package:ox_chat/page/contacts/my_idcard_dialog.dart';
import 'package:ox_chat/page/session/chat_channel_message_page.dart';
import 'package:ox_chat/page/session/chat_choose_share_page.dart';
import 'package:ox_chat/page/session/chat_session_list_page.dart';
import 'package:ox_chat/page/session/chat_video_play_page.dart';
import 'package:ox_chat/page/session/search_page.dart';
import 'package:ox_chat/utils/general_handler/chat_general_handler.dart';
import 'package:ox_chat/utils/general_handler/chat_nostr_scheme_handler.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/business_interface/ox_usercenter/interface.dart';
import 'package:ox_common/business_interface/ox_usercenter/zaps_detail_model.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/network/network_general.dart';
import 'package:ox_common/scheme/scheme_helper.dart';
import 'package:ox_common/utils/aes_encrypt_utils.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';
import 'package:ox_network/network_manager.dart';
import 'package:path_provider/path_provider.dart';

class OXChat extends OXFlutterModule {
  @override
  Future<void> setup() async {
    super.setup();
    OXUserInfoManager.sharedInstance.initDataActions.add(() async {
      await OXChatBinding.sharedInstance.initLocalSession();
      await ChatDataCache.shared.setup();
    });
    OXChatBinding.sharedInstance.sessionMessageTextBuilder = ChatMessageDBToUIHelper.sessionMessageTextBuilder;
    SchemeHelper.register('shareLinkWithScheme', shareLinkWithScheme);
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
    'relayGroupInfoPage': _relayGroupInfoPage,
    'groupInfoPage': _groupInfoPage,
    'commonWebview': _commonWebview,
    'zapsRecordDetail' : _zapsRecordDetail,
    'sendTextMsg': _sendTextMsg,
    'sendTemplateMessage': _sendTemplateMessage,
    'openWebviewForEncryptedFile': openWebviewForEncryptedFile,
    'getTryDecodeNostrScheme': getTryDecodeNostrScheme
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
        return SearchPage().show(context);
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
      case 'RelayGroupInfoPage':
        return OXNavigator.pushPage(
          context,
              (context) => RelayGroupInfoPage(
            groupId: params?['groupId'],
          ),
        );
      case 'ChatChooseSharePage':
        return OXNavigator.pushPage(context, (context) => ChatChooseSharePage(
          msg: params?['url'] ?? '',
        ));
      case 'ChatVideoPlayPage':
        return OXNavigator.presentPage(context, (context) => ChatVideoPlayPage(
          videoUrl: params?['videoUrl'] ?? '',
        ),fullscreenDialog:true);

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
      channelDB = await Channels.sharedInstance.searchChannel(channelId, null);
      await OXLoading.dismiss();
    }
    OXNavigator.pushPage(context!, (context) => ContactChanneDetailsPage(channelDB: channelDB ?? ChannelDB(channelId: channelId)));
  }

  Future<void> _relayGroupInfoPage(BuildContext? context,{required String groupId}) async {
    OXNavigator.pushPage(context!, (context) => RelayGroupInfoPage(groupId: groupId));
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

  void _sendTemplateMessage(
    BuildContext? context, {
      String receiverPubkey = '',
      String title = '',
      String subTitle = '',
      String icon = '',
      String link = '',
      int chatType = ChatType.chatSingle,
  }) {
    ChatMessageSendEx.sendTemplateMessage(
      receiverPubkey: receiverPubkey,
      title: title,
      subTitle: subTitle,
      icon: icon,
      link: link,
      chatType: chatType,
    );
  }

  void openWebviewForEncryptedFile(
    BuildContext context, {
      String url = '',
      String key = '',
  }) async {

    if (url.isEmpty || key.isEmpty) return ;

    // Download
    final uri = Uri.parse(url);
    final dir = await getTemporaryDirectory();
    final encryptedFile = File('${dir.path}/Tmp/${uri.pathSegments.lastOrNull}');
    final response = await OXNetwork.instance.doDownload(
      url,
      encryptedFile.path,
      showLoading: true,
      context: context,
    );

    if (response == null || response.statusCode != 200) {
      CommonToast.instance.show(context, 'File download failure.');
      return;
    }

    // Decrypt
    final decryptedFile = File('${dir.path}/Tmp/tmp-${uri.pathSegments.lastOrNull}');
    AesEncryptUtils.decryptFile(encryptedFile, decryptedFile, key);

    if (Platform.isAndroid){
      String fileContent = await loadFileByAndroid(decryptedFile);
      await OXNavigator.pushPage(context, (context) => CommonWebView(fileContent, isLocalHtmlResource: true,));
    } else {
      // Open on page
      var fileURL = decryptedFile.path;
      if (fileURL.isEmpty || fileURL.isRemoteURL) return ;
      if (!fileURL.isFileURL) {
        fileURL = 'file://$fileURL';
      }
      await OXNavigator.pushPage(context, (context) => CommonWebView(fileURL));
    }
    encryptedFile.delete();
    decryptedFile.delete();
  }

  Future<String> loadFileByAndroid(File file) async {
    String fileContent = '';
    final content = await file.readAsString();
    fileContent = Uri.dataFromString(
      content,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();
    return fileContent;
  }

  void shareLinkWithScheme(String scheme, String action, Map<String, String> queryParameters) {
    final text = queryParameters['text'] ?? '';
    if (text.isEmpty) return ;
    OXNavigator.pushPage(null, (context) => ChatChooseSharePage(
      msg: text,
    ));
  }

  Future<String?> getTryDecodeNostrScheme(String content)async {
    String? result = await ChatNostrSchemeHandle.tryDecodeNostrScheme(content);
    return result;
  }
}
