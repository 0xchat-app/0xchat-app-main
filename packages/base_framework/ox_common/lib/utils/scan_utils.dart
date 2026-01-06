import 'dart:async';

import 'package:cashu_dart/cashu_dart.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/utils//string_utils.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

// typedef ScanHandler = FutureOr<bool> Function(String str, BuildContext context);

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

    try {
      final uri = Uri.parse(url);
      if (uri.pathSegments.last == CustomURIHelper.nostrAction) {
        url = uri.queryParameters['value'] ?? '';
      } else {
        url = uri.pathSegments.last;
      }
    } catch (_) {
      String shareAppLinkDomain = CommonConstant.SHARE_APP_LINK_DOMAIN + '/';
      if (url.startsWith(shareAppLinkDomain)) {
        url = url.substring(shareAppLinkDomain.length);
      }
    }

    final handlers = [
      ScanAnalysisHandlerEx.scanUserHandler,
      ScanAnalysisHandlerEx.scanGroupHandler,
      ScanAnalysisHandlerEx.scanNWCHandler,
      ScanAnalysisHandlerEx.scanCashuHandler,
      ScanAnalysisHandlerEx.scanLnInvoiceHandler,
    ];
    for (var handler in handlers) {
      if (await handler.matcher(url)) {
        handler.action(url, context);
        return ;
      }
    }
  }
}

class ScanAnalysisHandler {
  ScanAnalysisHandler({required this.matcher, required this.action});
  FutureOr<bool> Function(String str) matcher;
  Function(String str, BuildContext context) action;
}

extension ScanAnalysisHandlerEx on ScanUtils {

  static FutureOr<bool> _tryHandleRelaysFromMap(Map<String, dynamic> map, BuildContext context) {
    List<String> relaysList = (map['relays'] ?? []).cast<String>();
    if (relaysList.isEmpty) return true;
    final newRelay = relaysList.first.replaceFirst(RegExp(r'/+$'), '');
    final relayAddressList = Account.sharedInstance.getMyGeneralRelayList().map((e) => e.url).toList();
    if (relayAddressList.contains(newRelay)) return true;

    final completer = Completer<bool>();
    OXCommonHintDialog.show(context,
        content: 'scan_find_not_same_hint'
            .commonLocalized()
            .replaceAll(r'${relay}', newRelay),
        isRowAction: true,
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
            completer.complete(false);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                OXNavigator.pop(context);
                await Connect.sharedInstance.connectRelays([newRelay], relayKind: RelayKind.temp);
                completer.complete(true);
              }),
        ]);
    return completer.future;
  }

  static ScanAnalysisHandler scanUserHandler = ScanAnalysisHandler(
    matcher: (String str) {
      return str.startsWith('nprofile') ||
          str.startsWith('nostr:nprofile') ||
          str.startsWith('nostr:npub') ||
          str.startsWith('npub');
    },
    action: (String str, BuildContext context) async {
      final failedHandle = () {
        CommonToast.instance.show(context, 'User not found');
      };

      final data = Account.decodeProfile(str);
      if (data == null || data.isEmpty) return failedHandle();

      if (!await _tryHandleRelaysFromMap(data, context)) return true;

      final pubkey = data['pubkey'] as String? ?? '';
      UserDBISAR? user = await Account.sharedInstance.getUserInfo(pubkey);
      if (user == null) return failedHandle();

      OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
        'pubkey': user.pubKey,
      });
    },
  );

  static ScanAnalysisHandler scanGroupHandler = ScanAnalysisHandler(
    matcher: (String str) {
      return str.startsWith('nevent') ||
          str.startsWith('nostr:nevent') ||
          str.startsWith('naddr') ||
          str.startsWith('nostr:naddr') ||
          str.startsWith('nostr:note') ||
          str.startsWith('note');
    },
    action: (String str, BuildContext context) async {
      final data = Channels.decodeChannel(str);
      final groupId = data?['channelId'];
      final relays = data?['relays'];
      final kind = data?['kind'];
      if (data == null || groupId == null || groupId is! String || groupId.isEmpty) return true;
      if (kind == 40 || kind == 41) {
        // Go to Channel
        await OXLoading.show();
        ChannelDBISAR? channelDB = await Channels.sharedInstance.searchChannel(groupId, relays);
        await OXLoading.dismiss();
        if (channelDB != null) {
          if (context.mounted) {
            OXModuleService.pushPage(context, 'ox_chat', 'ChatGroupMessagePage', {
              'chatId': groupId,
              'chatName': channelDB.name,
              'chatType': ChatType.chatChannel,
              'time': channelDB.createTime,
              'avatar': channelDB.picture,
              'groupId': channelDB.channelId,
            });
          }
        }
      } else if (kind == 39000){
        // if (!await _tryHandleRelaysFromMap(data, context)) return true;
        // Go to group page
        final author = data['author'];
        OXModuleService.invoke('ox_chat', 'groupSharePage', [
          context
        ], {
          Symbol('groupPic'): '',
          Symbol('groupName'): groupId,
          Symbol('groupId'): '${relays[0]}\'$groupId',
          Symbol('groupOwner'): author,
          Symbol('groupTypeIndex'): 0, //default openGroup
        });
      }

    },
  );

  static ScanAnalysisHandler scanNWCHandler = ScanAnalysisHandler(
    matcher: (String str) {
      return str.startsWith('nostr+walletconnect:');
    },
    action: (String nwcURI, _) async {
      NostrWalletConnection? nwc = NostrWalletConnection.fromURI(nwcURI);
      BuildContext context = OXNavigator.navigatorKey.currentContext!;
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
            },
          ),
        ],
      );
    },
  );

  static ScanAnalysisHandler scanCashuHandler = ScanAnalysisHandler(
    matcher: (String str) {
      return Cashu.isCashuToken(str);
    },
    action: (String token, BuildContext context) async {
      final response = await Cashu.redeemEcash(ecashString: token);
      if (!response.isSuccess) return ;
      final (memo, amount) = response.data;
      OXModuleService.pushPage(context, 'ox_wallet', 'WalletSuccessfulRedeemClaimedPage',{'amount':amount.toString()});
    },
  );

  static ScanAnalysisHandler scanLnInvoiceHandler = ScanAnalysisHandler(
    matcher: (String str) {
      return Cashu.isLnInvoice(str);
    },
    action: (String invoice, BuildContext context) async {
      final amount = Cashu.amountOfLightningInvoice(invoice);
      OXModuleService.pushPage(context, 'ox_wallet', 'WalletSendLightningPage', {'invoice': invoice, 'amount': amount.toString()});
    },
  );
}