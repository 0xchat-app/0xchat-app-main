import 'dart:convert';
import 'package:nostr_core_dart/nostr.dart';

/// Nut Zaps
class Nip61 {
  static Future<Event> encodeNutZapInfo(List<String> relays,
      List<NutZapMint> mints, String pubkey, String privkey,
      {String? p2pk}) async {
    List<List<String>> tags = [];
    for (var relay in relays) {
      tags.add(['relay', relay]);
    }
    for (var mint in mints) {
      tags.add(['mint', mint.url, ...mint.units]);
    }
    if (p2pk != null) {
      tags.add(['pubkey', p2pk]);
    }
    return await Event.from(
        kind: 10019, tags: tags, content: '', pubkey: pubkey, privkey: privkey);
  }

  static NutZapInfo decodeNutZapInfo(Event event) {
    List<String> relays = [];
    List<NutZapMint> mints = [];
    String? p2pk;
    for (var tag in event.tags) {
      if (tag[0] == 'relay') relays.add(tag[1]);
      if (tag[0] == 'mint' && tag.length > 2) {
        List<String> units = tag.sublist(2);
        mints.add(NutZapMint(tag[1], units));
      }
      if (tag[0] == 'pubkey') p2pk = tag[1];
    }
    return NutZapInfo(event.pubkey, event.createdAt, relays, mints, p2pk);
  }

  static Future<Event> encodeNutZap(
      List<String> tokens,
      String amount,
      String unit,
      String comment,
      String mint,
      String eventId,
      String eventRelay,
      String toPubkey,
      String pubkey,
      String privkey) async {
    List<List<String>> tags = [];
    tags.add(['amount', amount, unit]);
    tags.add(['comment', comment]);
    tags.add(['u', mint]);
    tags.add(['e', eventId, eventRelay]);
    tags.add(['p', toPubkey]);
    return await Event.from(
        kind: 7337,
        tags: tags,
        content: jsonEncode(tokens),
        pubkey: pubkey,
        privkey: privkey);
  }

  static NutZap decodeNutZap(Event event) {
    String amount = '',
        unit = '',
        comment = '',
        mint = '',
        eventId = '',
        eventRelay = '',
        toPubkey = '';
    for (var tag in event.tags) {
      if (tag[0] == 'amount' && tag.length > 2) {
        amount = tag[1];
        unit = tag[2];
      }
      if (tag[0] == 'comment') comment = tag[1];
      if (tag[0] == 'u') mint = tag[1];
      if (tag[0] == 'e') {
        eventId = tag[1];
        eventRelay = tag.length > 2 ? tag[2] : '';
      }
      if (tag[0] == 'p') toPubkey = tag[1];
    }
    List<String> tokens = jsonDecode(event.content);
    return NutZap(event.pubkey, toPubkey, event.createdAt, tokens, amount, unit,
        comment, mint, eventId, eventRelay);
  }

  static Future<Event> encodeNutZapClaim(String? walletTag, String eventId,
      String eventRelay, String sender, String pubkey, String privkey) async {
    List<List<String>> tags = [];
    if (walletTag != null) {
      tags.add(['a', walletTag]);
    }
    tags.add(['e', eventId, eventRelay, 'redeemed']);
    tags.add(['p', sender]);
    return await Event.from(
        kind: 7376, tags: tags, content: '', pubkey: pubkey, privkey: privkey);
  }
}

class NutZap {
  String fromPubkey;
  String toPubkey;
  int createdAt;
  List<String> tokens;
  String amount;
  String unit;
  String comment;
  String mint;
  String eventId;
  String eventRelay;

  NutZap(
      this.fromPubkey,
      this.toPubkey,
      this.createdAt,
      this.tokens,
      this.amount,
      this.unit,
      this.comment,
      this.mint,
      this.eventId,
      this.eventRelay);
}

class NutZapInfo {
  String pubkey;
  int createdAt;
  List<String> relays;
  List<NutZapMint> mints;
  String? p2pk;

  NutZapInfo(this.pubkey, this.createdAt, this.relays, this.mints, this.p2pk);
}

class NutZapMint {
  String url;
  List<String> units;

  NutZapMint(this.url, this.units);
}
