import 'dart:convert';
import 'package:nostr_core_dart/nostr.dart';

/// Nostr Wallet Connect
/// https://github.com/nostr-protocol/nips/blob/master/47.md
class Nip47 {
  static Future<Event> request(
      String invoice, String receiver, String privkey) async {
    String sender = Keychain.getPublicKey(privkey);
    Map request = {
      'method': 'pay_invoice',
      'params': {'invoice': invoice}
    };
    String content = jsonEncode(request);
    String enContent =
        await Nip4.encryptContent(content, receiver, sender, privkey);
    return await Event.from(
        kind: 23194,
        tags: [
          ['p', receiver]
        ],
        content: enContent,
        pubkey: sender,
        privkey: privkey);
  }

  static Future<PayInvoiceResult?> response(
      Event event, String sender, String receiver, String privkey) async {
    if (event.kind == 23195) {
      String? requestId, p;
      for (var tag in event.tags) {
        if (tag[0] == "p") p = tag[1];
        if (tag[0] == "e") requestId = tag[1];
      }
      if (requestId == null || p != receiver) return null;
      String content =
          await Nip4.decryptContent(event.content, receiver, sender, privkey);
      Map map = jsonDecode(content);
      String? preimage = map['result']?['preimage'];
      String? code = map['error']?['code'];
      String? message = map['error']?['message'];
      bool result = preimage != null;
      return PayInvoiceResult(requestId, result, preimage, code, message);
    }
    return null;
  }
}

class PayInvoiceResult {
  String requestId;
  bool result;
  String? preimage;
  String? code;
  String? message;

  PayInvoiceResult(
      this.requestId, this.result, this.preimage, this.code, this.message);
}
