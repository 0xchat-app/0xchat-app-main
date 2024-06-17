
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/utils/ox_relay_manager.dart';

class ZapsHelper {

  static Future<Map<String, String>> getInvoice({
    required int sats,
    required String recipient,
    required String otherLnurl,
    String? content,
    String? eventId,
    bool privateZap = false,
  }) async {

    final result = {
      'zapper': '',
      'invoice': '',
      'message': '',
    };

    final relayNameList = OXRelayManager.sharedInstance.relayAddressList;
    if(!relayNameList.contains(CommonConstant.oxChatRelay)) relayNameList.add(CommonConstant.oxChatRelay);

    if (recipient.isEmpty) {
      result['message'] = 'Recipient is empty';
      return result;
    }

    if (relayNameList.isEmpty) {
      result['message'] = 'Relay is empty';
      return result;
    }

    if (otherLnurl.isEmpty || otherLnurl == 'null') {
      result['message'] = 'The receiver\'s lightning address has not been set up';
      return result;
    }

    if (otherLnurl.contains('@')) {
      try {
        otherLnurl = await Zaps.getLnurlFromLnaddr(otherLnurl);
      } catch (error) {
        result['message'] = 'Error, check if the lightning address is correct';
        return result;
      }
    }
    final resultMap = await Zaps.getInvoice(
      relayNameList,
      sats,
      otherLnurl,
      recipient,
      content: content,
      privateZap: privateZap,
      eventId: eventId
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

    if (zapsDB.nostrPubkey.isEmpty) {
      result['message'] = 'error nostrPubkey: ${zapsDB.nostrPubkey}';
      return result;
    }

    result['zapper'] = zapsDB.nostrPubkey;
    result['invoice'] = invoice;
    return result;
  }
}