import 'dart:convert';
import 'dart:typed_data';
import 'package:bip340/bip340.dart' as bip340;
import 'package:nostr_core_dart/nostr.dart';
import 'package:pointycastle/digests/sha256.dart';

class Nip57 {
  static Future<ZapReceipt> getZapReceipt(
      Event event, String myPubkey, String privkey) async {
    if (event.kind == 9735) {
      String? bolt11,
          preimage,
          description,
          recipient,
          eventId,
          content,
          sender,
          anon;
      for (var tag in event.tags) {
        if (tag[0] == 'bolt11') bolt11 = tag[1];
        if (tag[0] == 'preimage') preimage = tag[1];
        if (tag[0] == 'description') description = tag[1];
        if (tag[0] == 'p') recipient = tag[1];
        if (tag[0] == 'e') eventId = tag[1];
        if (tag[0] == 'anon') anon = tag[1];
      }
      if (description != null) {
        try {
          Map map = jsonDecode(description);
          content = map['content'];
          sender = map['pubkey'];
        } catch (_) {
          content = '';
        }
      }
      List<String>? splitStrings = anon?.split('_');
      if (splitStrings != null && splitStrings.length == 2) {
        // /// recipient decrypt
        // try {
        //   String contentBech32 = splitStrings[0];
        //   String ivBech32 = splitStrings[1];
        //   String? encryptedContent = bech32Decode(contentBech32,
        //       maxLength: contentBech32.length)['data'];
        //   String? iv =
        //       bech32Decode(ivBech32, maxLength: ivBech32.length)['data'];
        //
        //   String encryptedContentBase64 =
        //       base64Encode(hexToBytes(encryptedContent!));
        //   String ivBase64 = base64Encode(hexToBytes(iv!));
        //
        //   String eventString = await Nip4.decryptContent(
        //       '$encryptedContentBase64?iv=$ivBase64',
        //       recipient!,
        //       myPubkey,
        //       privkey);
        //
        //   /// try to use sender decrypt
        //   if (eventString.isEmpty) {
        //     String derivedPrivkey =
        //         generateKeyPair(recipient, event.createdAt, privkey);
        //     eventString = await Nip4.decryptContent('$encryptedContent?iv=$iv',
        //         recipient, bip340.getPublicKey(derivedPrivkey), derivedPrivkey);
        //   }
        //   if (eventString.isNotEmpty) {
        //     Event privEvent = await Event.fromJson(jsonDecode(eventString));
        //     sender = privEvent.pubkey;
        //     content = privEvent.content;
        //   }
        // } catch (_) {}
      }

      ZapReceipt zapReceipt = ZapReceipt(
          event.createdAt,
          event.pubkey,
          bolt11 ?? '',
          preimage ?? '',
          description ?? '',
          recipient ?? '',
          eventId,
          content,
          sender);
      return zapReceipt;
    } else {
      throw Exception("${event.kind} is not nip57 compatible");
    }
  }

  static Future<Event> zapRequest(
      List<String> relays,
      String amount,
      String lnurl,
      String recipient,
      String myPubkey,
      String privkey,
      bool privateZap,
      {String? eventId,
      String? coordinate,
      String? content}) async {
    List<String> r = ['relays'];
    r.addAll(relays);
    List<List<String>> tags = [
      r,
      ['amount', amount],
      ['lnurl', lnurl],
      ['p', recipient]
    ];
    if (eventId != null) {
      tags.add(['e', eventId]);
    }
    if (coordinate != null) {
      tags.add(['a', coordinate]);
    }

    int createAt = currentUnixTimestampSeconds();

    // String derivedPrivkey = privkey;
    // if (privateZap) {
    //   derivedPrivkey = generateKeyPair(recipient, createAt, privkey);
    //   String privreq = await privateRequest(
    //       recipient, myPubkey, privkey, derivedPrivkey,
    //       eventId: eventId, coordinate: coordinate, content: content);
    //   tags.add(['anon', privreq]);
    // }

    return await Event.from(
        kind: 9734,
        tags: tags,
        content: privateZap ? '' : content ?? '',
        pubkey: myPubkey,
        privkey: privkey,
        createdAt: createAt);
  }

  static String generateKeyPair(String receiver, int createAt, String privkey) {
    Uint8List derivedPrivateKey =
        tweakAdd(hexToBytes(privkey), hexToBytes(receiver), salt: createAt);
    Uint8List sha256Key = SHA256Digest().process(derivedPrivateKey);
    return bytesToHex(sha256Key);
  }

  static Future<String> privateRequest(
      String recipient, String myPubkey, String privkey, String derivedPrivkey,
      {String? eventId, String? coordinate, String? content}) async {
    List<List<String>> tags = [
      ['p', recipient]
    ];
    if (eventId != null) {
      tags.add(['e', eventId]);
    }
    if (coordinate != null) {
      tags.add(['a', coordinate]);
    }

    Event event = await Event.from(
        kind: 9733,
        tags: tags,
        content: content ?? '',
        pubkey: myPubkey,
        privkey: privkey);

    String eventString = jsonEncode(event);

    String encryptedContent =
        await Nip4.encryptContent(eventString, recipient, myPubkey, privkey);
    int ivIndex = encryptedContent.indexOf("?iv=");

    String iv = encryptedContent.substring(
        ivIndex + "?iv=".length, encryptedContent.length);
    List<int> bytesIv = base64.decode(iv);
    String hexstringIv =
        bytesIv.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    String ivBech32 =
        bech32Encode('iv', hexstringIv, maxLength: hexstringIv.length + 90);

    String encString = encryptedContent.substring(0, ivIndex);
    List<int> bytesContent = base64.decode(encString);
    String hexstringContent = bytesContent
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    String contentBech32 = bech32Encode('pzap', hexstringContent,
        maxLength: hexstringContent.length + 90);
    return '${contentBech32}_$ivBech32';
  }
}

class ZapReceipt {
  int paidAt;
  String zapper;
  String bolt11;
  String preimage;
  String description;
  String recipient;
  String? eventId;
  String? content;
  String? sender;

  ZapReceipt(
      this.paidAt,
      this.zapper,
      this.bolt11,
      this.preimage,
      this.description,
      this.recipient,
      this.eventId,
      this.content,
      this.sender);
}
