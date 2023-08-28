
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/utils/ox_relay_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class ZapsHelper {

  static Future<Map<String, String>> getInvoice({
    required int sats,
    required String otherLnurl,
    String? content,
    bool privateZap = false,
  }) async {

    final result = {
      'zapper': '',
      'invoice': '',
      'message': '',
    };

    final recipient = CommonConstant.serverPubkey;
    final privkey = OXUserInfoManager.sharedInstance.currentUserInfo?.privkey ?? '';
    final relayNameList = OXRelayManager.sharedInstance.relayAddressList;

    if (recipient.isEmpty) {
      result['message'] = 'recipient is empty';
      return result;
    }

    if (privkey.isEmpty) {
      result['message'] = 'privkey is empty';
      return result;
    }

    if (relayNameList.isEmpty) {
      result['message'] = 'relay is empty';
      return result;
    }

    if (otherLnurl.isEmpty) {
      result['message'] = 'other lnurl is empty';
      return result;
    }

    if (otherLnurl.contains('@')) {
      try {
        otherLnurl = await Zaps.getLnurlFromLnaddr(otherLnurl);
      } catch (error) {
        result['message'] = 'get lnurl from lnaddr error';
        return result;
      }
    }
    final resultMap = await Zaps.getInvoice(
      relayNameList,
      sats,
      otherLnurl,
      recipient,
      privkey,
      content: content,
      privateZap: privateZap,
    );
    final invoice = resultMap['invoice'];
    final zapsDB = resultMap['zapsDB'];
    if (invoice is! String || invoice.isEmpty) {
      result['message'] = 'error invoice: $invoice';
      return result;
    }

    if (zapsDB is! ZapsDB ) {
      result['message'] = 'error zaps info: $zapsDB';
      return result;
    }

    if (zapsDB.nostrPubkey == null || zapsDB.nostrPubkey!.isEmpty) {
      result['message'] = 'error nostrPubkey: ${zapsDB.nostrPubkey}';
      return result;
    }

    result['zapper'] = zapsDB.nostrPubkey!;
    result['invoice'] = invoice;
    return result;
  }
}