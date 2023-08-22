
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/utils/ox_relay_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class ZapsHelper {

  static Future<Map<String, String>> getInvoice({required int sats, required String otherLnurl}) async {

    final result = {
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
    final invoice = await Zaps.getInvoice(relayNameList, sats, otherLnurl, recipient, privkey) ?? '';
    result['invoice'] = invoice;
    return result;
  }
}