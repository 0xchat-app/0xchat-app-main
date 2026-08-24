import 'dart:convert';
import 'package:bip340/bip340.dart' as bip340;

import 'package:nostr_core_dart/nostr.dart';

/// Gift Wrap
/// https://github.com/v0l/nips/blob/59/59.md
class Nip59 {
  static Future<Event> encode(Event event, String receiver,
      {String? sealedPrivkey,
      String? kind,
      int? expiration,
      int? createAt}) async {
    String encodedEvent = jsonEncode(event);
    if (sealedPrivkey == null) {
      Keychain keychain = Keychain.generate();
      sealedPrivkey = keychain.private;
    }
    String myPubkey = bip340.getPublicKey(sealedPrivkey);
    String content = await Nip44.encryptContent(
        encodedEvent, receiver, myPubkey, sealedPrivkey);
    List<List<String>> tags = [
      ["p", receiver]
    ];
    if (kind != null) tags.add(['k', kind]);
    if (expiration != null) tags.add(['expiration', '$expiration']);
    return await Event.from(
        kind: 1059,
        tags: tags,
        content: content,
        pubkey: myPubkey,
        privkey: sealedPrivkey,
        createdAt: createAt ?? 0);
  }

  static Future<Event> decode(
      Event event, String myPubkey, String privkey) async {
    if (event.kind == 1059) {
      String content = await Nip44.decryptContent(
          event.content, event.pubkey, myPubkey, privkey);
      Map<String, dynamic> map = jsonDecode(content);
      return Event.fromJson(map, verify: false);
    }
    throw Exception("${event.kind} is not nip59 compatible");
  }
}
