import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

extension Nuts on Zaps {
  Future<OKEvent> sendNutZapInfoToRelay(
      List<String> relays, List<NutZapMint> mints,
      {String? p2pk}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event = await Nip61.encodeNutZapInfo(
        relays, mints, currentPubkey, Account.sharedInstance.currentPrivkey,
        p2pk: p2pk);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (!completer.isCompleted) {
        completer.complete(ok);
      }
    });
    return completer.future;
  }

  Future<OKEvent> sendNutZapToRelay(
      List<String> tokens,
      String amount,
      String unit,
      String comment,
      String mint,
      String eventId,
      String eventRelay,
      String toPubkey) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event = await Nip61.encodeNutZap(
        tokens,
        amount,
        unit,
        comment,
        mint,
        eventId,
        eventRelay,
        toPubkey,
        currentPubkey,
        Account.sharedInstance.currentPrivkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (!completer.isCompleted) {
        completer.complete(ok);
      }
    });
    return completer.future;
  }

  Future<OKEvent> sendNutZapClaimToRelay(String? walletTag, String eventId,
      String eventRelay, String sender) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event = await Nip61.encodeNutZapClaim(walletTag, eventId, eventRelay,
        sender, currentPubkey, Account.sharedInstance.currentPrivkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (!completer.isCompleted) {
        completer.complete(ok);
      }
    });
    return completer.future;
  }

  void handleNutZapInfo(Event event) {}
  void handleNutZap(Event event) {}
  void handleNutZapClaim(Event event) {}
}
