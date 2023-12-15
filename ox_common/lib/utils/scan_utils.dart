import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/model/relay_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_relay_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/utils//string_utils.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_common/event_bus.dart';

///Title: scan_utils
///Description: TODO()
///Copyright: Copyright (c) 2021
///@author George
///CreateTime: 2021/5/31 3:03 PM
class ScanUtils {
  static Future<void> analysis(BuildContext context, String url) async {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (!isLogin) {
      CommonToast.instance.show(context, 'please_sign_in'.commonLocalized());
      return;
    }

    String shareAppLinkDomain = CommonConstant.SHARE_APP_LINK_DOMAIN;
    if (url.startsWith(shareAppLinkDomain)) {
      url = url.substring(shareAppLinkDomain.length);
    }

    Map<String, dynamic>? tempMap;
    int type = CommonConstant.qrCodeUser;
    if (url.startsWith('nprofile') ||
        url.startsWith('nostr:nprofile') ||
        url.startsWith('nostr:npub') ||
        url.startsWith('npub')) {
      tempMap = Account.decodeProfile(
          url); //return {'pubkey': pubkey, 'relays': relays};
    } else if (url.startsWith('nevent') ||
        url.startsWith('nostr:nevent') ||
        url.startsWith('nostr:note') ||
        url.startsWith('note')) {
      tempMap = Channels.decodeChannel(url);
      type = Groups.sharedInstance.groups.containsKey(tempMap?['channelId']) ? CommonConstant.qrCodeGroup : CommonConstant.qrCodeChannel;
    } else if (url.startsWith('nostr+walletconnect:')) {
      tempMap = {'nwc': url};
      type = CommonConstant.qrCodeNWC;
    }
    if (tempMap == null) {
      return;
    }
    List<String> relaysList =
        (tempMap['relays'] ?? []).cast<String>();
    String willAddRelay = '';
    if (relaysList.isNotEmpty) {
      willAddRelay = OXRelayManager.sharedInstance.relayAddressList
                  .contains(relaysList[0]) ==
              false
          ? relaysList[0]
          : '';
    }
    if (willAddRelay.isNotEmpty) {
      OXCommonHintDialog.show(context,
          content: 'scan_find_not_same_hint'
              .commonLocalized()
              .replaceAll(r'${relay}', willAddRelay),
          isRowAction: true,
          actionList: [
            OXCommonHintAction.cancel(onTap: () {
              OXNavigator.pop(context);
            }),
            OXCommonHintAction.sure(
                text: Localized.text('ox_common.confirm'),
                onTap: () async {
                  OXNavigator.pop(context);
                  RelayModel _tempRelayModel = RelayModel(
                    relayName: willAddRelay,
                    canDelete: true,
                    connectStatus: 0,
                  );
                  await OXRelayManager.sharedInstance
                      .addRelaySuccess(_tempRelayModel);
                  if (type == CommonConstant.qrCodeUser) {
                    _showFriendInfo(context, tempMap!['pubkey']);
                  } else if (type == CommonConstant.qrCodeChannel) {
                    _gotoChannel(context, tempMap!['channelId']);
                  } else if (type == CommonConstant.qrCodeGroup) {
                    _gotoGroup(
                        context, tempMap!['channelId'], tempMap['author']);
                  }
                }),
          ]);
    } else {
      if (type == CommonConstant.qrCodeUser) {
        _showFriendInfo(context, tempMap['pubkey']);
      } else if (type == CommonConstant.qrCodeChannel) {
        _gotoChannel(context, tempMap['channelId']);
      } else if (type == CommonConstant.qrCodeGroup) {
        _gotoGroup(context, tempMap['channelId'], tempMap['author']);
      } else if (type == CommonConstant.qrCodeNWC) {
        _gotoNWC(context, tempMap['nwc']);
      }
    }
  }

  static Future<void> _showFriendInfo(
      BuildContext context, String pubkey) async {
    UserDB? user = await Account.sharedInstance.getUserInfo(pubkey);
    if (user == null) {
      CommonToast.instance.show(context, 'User not found');
    } else {
      if (context.mounted) {
        OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
          'pubkey': user.pubkey,
        });
      }
    }
  }

  static Future<void> _gotoGroup(
      BuildContext context, String groupId, String author) async {
    // TODO: goto group
    OXModuleService.invoke('ox_chat', 'groupSharePage', [
      context
    ], {
      Symbol('groupPic'): '',
      Symbol('groupName'): groupId,
      Symbol('groupOwner'): author,
      Symbol('groupId'): groupId,
      Symbol('inviterPubKey'): '--',
    });
  }

  static Future<void> _gotoChannel(
      BuildContext context, String channelID) async {
    await OXLoading.show();
    List<ChannelDB> channelsList = [];
    ChannelDB? c = Channels.sharedInstance.channels[channelID];
    if (c == null) {
      channelsList = await Channels.sharedInstance
          .getChannelsFromRelay(channelIds: [channelID]);
    } else {
      channelsList = [c];
    }
    await OXLoading.dismiss();
    if (channelsList.isNotEmpty) {
      ChannelDB channelDB = channelsList[0];
      if (context.mounted) {
        OXModuleService.pushPage(context, 'ox_chat', 'ChatGroupMessagePage', {
          'chatId': channelID,
          'chatName': channelDB.name,
          'chatType': ChatType.chatChannel,
          'time': channelDB.createTime,
          'avatar': channelDB.picture,
          'groupId': channelDB.channelId,
        });
      }
    }
  }

  static Future<void> _gotoNWC(BuildContext context, String nwcURI) async {
    NostrWalletConnection? nwc = NostrWalletConnection.fromURI(nwcURI);
    OXCommonHintDialog.show(context,
        title: 'scan_find_nwc_hint'.commonLocalized(),
        content: '${nwc?.relays[0]}\n${nwc?.lud16}',
        isRowAction: true,
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                Zaps.sharedInstance.updateNWC(nwcURI);
                await OXCacheManager.defaultOXCacheManager
                    .saveForeverData('${Account.sharedInstance.me?.pubKey}.isShowWalletSelector', false);
                await OXCacheManager.defaultOXCacheManager
                    .saveForeverData('${Account.sharedInstance.me?.pubKey}.defaultWallet', 'NWC');
                OXNavigator.pop(context);
                CommonToast.instance.show(context, 'Success');
              }),
        ]);
  }
}
