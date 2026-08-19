import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:kepler/kepler.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:pointycastle/digests/sha256.dart';

/// Encrypted Direct Message
/// https://github.com/nostr-protocol/nips/pull/715///
class Nip44 {
  /// Returns the EDMessage Encrypted Direct Message event (kind=44)
  static Future<EDMessage?> decode(Event event, String myPubkey, String privkey) async {
    if (event.kind == 44 || event.kind == 14) {
      return await _toEDMessage(event, myPubkey, privkey);
    }
    return null;
  }

  /// Returns EDMessage from event
  static Future<EDMessage> _toEDMessage(Event event, String myPubkey, String privkey) async {
    String sender = event.pubkey;
    int createdAt = event.createdAt;
    String receiver = "";
    String replyId = "";
    String content = "";
    String subContent = event.content;
    String? expiration;
    for (var tag in event.tags) {
      if (tag[0] == "p") receiver = tag[1];
      if (tag[0] == "e") replyId = tag[1];
      if (tag[0] == "subContent") subContent = tag[1];
      if (tag[0] == "expiration") expiration = tag[1];
    }

    if (receiver.compareTo(myPubkey) == 0) {
      content = await decryptContent(subContent, sender, myPubkey, privkey);
    } else if (sender.compareTo(myPubkey) == 0) {
      content = await decryptContent(subContent, receiver, myPubkey, privkey);
    } else {
      throw Exception("not correct receiver, is not nip44 compatible");
    }

    return EDMessage(sender, receiver, createdAt, content, replyId, expiration);
  }

  static Future<String> decryptContent(
      String content, String peerPubkey, String myPubkey, String privkey,
      {String encodeType = 'base64', String? prefix}) async {
    try {
      if (SignerHelper.needSigner(privkey)) {
        return await SignerHelper.decryptNip44(content, peerPubkey, myPubkey, privkey) ?? '';
      }
      Uint8List? decodeContent;
      if (encodeType == 'base64') {
        decodeContent = base64Decode(content);
      } else if (encodeType == 'bech32') {
        Map map = bech32Decode(content, maxLength: content.length);
        assert(map['prefix'] == prefix);
        decodeContent = hexToBytes(map['data']);
      }
      final v = decodeContent![0];
      final nonce = decodeContent.sublist(1, 25);
      final cipherText = decodeContent.sublist(25);
      if (v == 1) {
        final algorithm = Xchacha20(macAlgorithm: MacAlgorithm.empty);
        final secretKey = shareSecret(privkey, peerPubkey);
        SecretBox secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac.empty);
        final result = await algorithm.decrypt(secretBox, secretKey: SecretKey(secretKey));
        return utf8.decode(result);
      } else if (v == 2) {
        Uint8List shareKey = Nip44v2.shareSecret(privkey, peerPubkey);
        return await Nip44v2.decrypt(content, shareKey);
      } else {
        print("nip44: decryptContent error: unknown algorithm version: $v");
        return "";
      }
    } catch (e) {
      print("nip44: decryptContent error: $e");
      return "";
    }
  }

  static Future<Event> encode(String sender, String receiver, String content, String replyId,
      String replyUser, String privkey,
      {String? subContent, int? expiration}) async {
    String enContent = await encryptContent(content, receiver, sender, privkey);
    List<List<String>> tags = Nip4.toTags(receiver, replyId, replyUser, expiration);
    if (subContent != null && subContent.isNotEmpty) {
      String enSubContent = await encryptContent(subContent, receiver, sender, privkey);
      tags.add(['subContent', enSubContent]);
    }
    Event event = await Event.from(
        kind: 44, tags: tags, content: enContent, pubkey: sender, privkey: privkey);
    return event;
  }

  static Future<String> encryptContent(
      String plainText, String peerPubkey, String myPubkey, String privkey) async {
    if (SignerHelper.needSigner(privkey)) {
      return await SignerHelper.encryptNip44(plainText, peerPubkey, myPubkey, privkey) ?? '';
    } else {
      return await encrypt(privkey, peerPubkey, plainText);
    }
  }

  static List<List<String>> toTags(String p, String e) {
    List<List<String>> result = [];
    result.add(["p", p]);
    if (e.isNotEmpty) result.add(["e", e, '', 'reply']);
    return result;
  }

  static Future<String> encrypt(String privateString, String publicString, String content) async {
    Uint8List shareKey = Nip44v2.shareSecret(privateString, publicString);
    return await Nip44v2.encrypt(content, shareKey);
  }

  static Uint8List shareSecret(String privateString, String publicString) {
    final secretIV = Kepler.byteSecret(privateString, '02$publicString');
    final key = Uint8List.fromList(secretIV[0]);
    return SHA256Digest().process(key);
  }

  static List<int> generate24RandomBytes() {
    final random = Random.secure();
    return List<int>.generate(24, (i) => random.nextInt(256));
  }
}
