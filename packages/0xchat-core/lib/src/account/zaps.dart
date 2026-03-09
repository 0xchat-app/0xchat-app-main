import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';
import 'package:bolt11_decoder/bolt11_decoder.dart';
import 'package:decimal/decimal.dart';

typedef ZapRecordsCallBack = void Function(ZapRecordsDBISAR);

enum ZapType {
  normal,
  privateChat,
  channelChat,
  privateGroup,
  relayGroup,
  donate,
}

class Zaps {
  /// singleton
  Zaps._internal();
  factory Zaps() => sharedInstance;
  static final Zaps sharedInstance = Zaps._internal();

  Map<String, ZapRecordsDBISAR> zapRecords = {};
  ZapRecordsCallBack? zapRecordsCallBack;
  Map<String, bool> offlineZapRecordFinish = {};
  NostrWalletConnection? nwc;
  String zapsSubscription = '';
  String currentPubkey = '';

  void _connectToRelays(List<String> relays) {
    for (var relay in relays) {
      if (relay.isNotEmpty &&
          !Connect.sharedInstance
              .relays(relayKinds: [RelayKind.nwc])
              .contains(relay)) {
        Connect.sharedInstance.connect(relay, relayKind: RelayKind.nwc);
      }
    }
  }

  Future<void> init() async {
    currentPubkey = Account.sharedInstance.me!.pubKey;
    updateNWC(null);
    updateZapsSubscription();
    Connect.sharedInstance
        .addConnectStatusListener((relay, status, relayKinds) async {
      if (status == 1 &&
          Account.sharedInstance.me != null &&
          relayKinds.contains(RelayKind.general)) {
        updateZapsSubscription(relay: relay);
      }
    });
  }

  void disconnectNWC() {
    Account.sharedInstance.me?.nwcURI = null;
    Account.sharedInstance.syncMe();
  }

  NostrWalletConnection? updateNWC(String? nwcURI) {
    if (nwcURI != null && nwcURI != Account.sharedInstance.me?.nwcURI) {
      Account.sharedInstance.me?.nwcURI = nwcURI;
      Account.sharedInstance.syncMe();
    }
    nwc = Account.sharedInstance.me?.nwc;
    if (nwc != null) {
      _connectToRelays(nwc!.relays);
    }
    return nwc;
  }

  Future<OKEvent> requestNWC(String invoice) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    if (nwc == null) {
      completer.complete(OKEvent(invoice, false, 'nwc not exit'));
    }
    Event event = await Nip47.request(invoice, nwc!.server, nwc!.secret);
    Connect.sharedInstance.sendEvent(event, toRelays: nwc!.relays,
        sendCallBack: (ok, relay) {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  void updateZapsSubscription({String? relay}) {
    if (zapsSubscription.isNotEmpty) {
      Connect.sharedInstance.closeRequests(zapsSubscription, relay: relay);
    }
    Map<String, List<Filter>> subscriptions = {};
    if (relay == null) {
      for (String relayURL in Connect.sharedInstance.relays()) {
        int zapRecordUntil = Relays.sharedInstance.getZapRecordUntil(relayURL);
        Filter f1 =
            Filter(kinds: [1, 6, 7, 9735], p: [currentPubkey], since: zapRecordUntil);
        Filter f2 =
            Filter(kinds: [9735], P: [currentPubkey], since: zapRecordUntil);
        subscriptions[relayURL] = [f1, f2];
      }
    } else {
      int zapRecordUntil = Relays.sharedInstance.getZapRecordUntil(relay);
      Filter f1 =
          Filter(kinds: [1, 6, 7, 9735], p: [currentPubkey], since: zapRecordUntil);
      Filter f2 =
          Filter(kinds: [9735], P: [currentPubkey], since: zapRecordUntil);
      subscriptions[relay] = [f1, f2];
    }

    zapsSubscription = Connect.sharedInstance.addSubscriptions(subscriptions, closeSubscription: false,
        eventCallBack: (event, relay) async {
      updateZapRecordTime(event.createdAt, relay);
      if (Contacts.sharedInstance.inBlockList(event.pubkey)) return;
      switch (event.kind) {
        case 1:
          Moment.sharedInstance.handleNoteEvent(event, relay, false);
          break;
        case 6:
          Moment.sharedInstance.handleRepostsEvent(event, relay, false);
          break;
        case 7:
          Moment.sharedInstance.handleReactionEvent(event, relay, false);
          break;
        case 9735:
          Zaps.handleZapRecordEvent(event);
          break;
        default:
          LogUtils.v(() => 'moment unhandled message ${event.toJson()}');
          break;
      }
    }, eoseCallBack: (requestId, ok, relay, unCompletedRelays) {
      offlineZapRecordFinish[relay] = true;
      if (ok.status) {
        updateZapRecordTime(currentUnixTimestampSeconds() - 1, relay);
      }
    });
  }

  void updateZapRecordTime(int eventTime, String relay) {
    /// set friendMessageUntil friendMessageSince
    if (Relays.sharedInstance.relays.containsKey(relay)) {
      Relays.sharedInstance.setZapRecordSince(eventTime, relay);
      Relays.sharedInstance.setZapRecordUntil(eventTime, relay);
    } else {
      Relays.sharedInstance.relays[relay] = RelayDBISAR(
          url: relay, zapRecordSince: eventTime, zapRecordUntil: eventTime);
    }
    if (offlineZapRecordFinish[relay] == true) {
      Relays.sharedInstance.syncRelaysToDB(r: relay);
    }
  }

  static Future<String> getLnurlFromLnaddr(String lnaddr) async {
    try {
      List<dynamic> parts = lnaddr.split('@');
      String name = parts[0];
      String domain = parts[1];
      if (name.isEmpty || domain.isEmpty) {
        throw Exception('invalid lnaddr');
      }
      String url = 'https://$domain/.well-known/lnurlp/$name';
      List<int> bytes = utf8.encode(url);
      String hex = bytesToHex(Uint8List.fromList(bytes));
      return bech32Encode('lnurl', hex, maxLength: 200);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<ZapsDBISAR?> getZapsInfoFromDB(String lnurl) async {
    final isar = DBISAR.sharedInstance.isar;
    return await isar.zapsDBISARs.filter().lnURLEqualTo(lnurl).findFirst();
  }

  static Future<ZapsDBISAR?> getZapsInfoFromLnurl(String lnurl) async {
    ZapsDBISAR? zapsDB = await getZapsInfoFromDB(lnurl);
    if (zapsDB != null) return zapsDB;
    Map map = bech32Decode(lnurl, maxLength: lnurl.length);
    if (map['prefix'] == 'lnurl') {
      String hexURL = map['data'];
      String url = utf8.decode(hexToBytes(hexURL));
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        zapsDB = ZapsDBISAR.fromMap(jsonDecode(response.body));
        zapsDB.lnURL = lnurl;
        // cache to DB
        await DBISAR.sharedInstance.saveToDB(zapsDB);
        return zapsDB;
      } else {
        throw Exception(response.toString());
      }
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>> getInvoice(
      ZapType zapType, int sats, String lnurl, String recipient,
      {String? eventId,
      String? coordinate,
      String? content,
      bool? privateZap,
      String? receiver,
      String? groupId}) async {
    Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();
    ZapsDBISAR? zapsDB = await getZapsInfoFromLnurl(lnurl);
    if (zapsDB != null) {
      String url =
          '${zapsDB.callback}?amount=${sats * 1000}&lnurl=${zapsDB.lnURL}';
      if (zapsDB.allowsNostr == true) {
        List<String> toRelays = [];
        switch (zapType) {
          case ZapType.normal:
          case ZapType.channelChat:
            toRelays.addAll(
                Connect.sharedInstance.relays(relayKinds: [RelayKind.general]));
            break;
          case ZapType.privateChat:
          case ZapType.privateGroup:
            UserDBISAR? toUser =
                await Account.sharedInstance.getUserInfo(recipient);
            toRelays.addAll(
                Connect.sharedInstance.relays(relayKinds: [RelayKind.general]));
            toRelays.addAll(toUser?.dmRelayList ?? []);
            break;
          case ZapType.relayGroup:
            RelayGroupDBISAR? relayGroupDB =
                RelayGroup.sharedInstance.groups[groupId]?.value;
            if (relayGroupDB != null) {
              toRelays.addAll(
                  Connect.sharedInstance.relays(relayKinds: [RelayKind.general]));
              toRelays.add(relayGroupDB.relay);
            } else {
              return {"invoice": '', "zapsDB": zapsDB};
            }
            break;
          case ZapType.donate:
            toRelays.addAll(
                Connect.sharedInstance.relays(relayKinds: [RelayKind.general]));
            toRelays.add(Config.sharedInstance.wssHost);
            break;
        }

        Event event = await Nip57.zapRequest(
            toRelays,
            (sats * 1000).toString(),
            lnurl,
            recipient,
            Account.sharedInstance.currentPubkey,
            Account.sharedInstance.currentPrivkey,
            privateZap ?? false,
            eventId: eventId,
            coordinate: coordinate,
            content: content);
        String encodedUri = Uri.encodeFull(jsonEncode(event));
        url = '$url&nostr=$encodedUri';
      }
      final result = await http.get(Uri.parse(url));
      if (result.statusCode == 200) {
        try {
          String pr = jsonDecode(result.body)['pr'];
          if (!completer.isCompleted) {
            completer.complete({"invoice": pr, "zapsDB": zapsDB});
          }
        } catch (_) {
          if (!completer.isCompleted) {
            completer.complete({"invoice": '', "zapsDB": zapsDB});
          }
        }
      } else {
        if (!completer.isCompleted) {
          completer.complete({"invoice": '', "zapsDB": zapsDB});
        }
      }
    } else {
      if (!completer.isCompleted) {
        completer.complete({"invoice": '', "zapsDB": zapsDB});
      }
    }
    return completer.future;
  }

  static Bolt11PaymentRequest getPaymentRequestInfo(String invoice) {
    return Bolt11PaymentRequest(invoice);
  }

  static int getPaymentRequestAmount(String invoice) {
    final requestInfo = getPaymentRequestInfo(invoice);
    return (requestInfo.amount * Decimal.fromInt(100000000)).toDouble().toInt();
  }

  static Future<List<ZapRecordsDBISAR>> getZapReceiptFromLocal(
      String invoice) async {
    // load from cache
    if (Zaps.sharedInstance.zapRecords.containsKey(invoice)) {
      var db = Zaps.sharedInstance.zapRecords[invoice];
      return [db!];
    } else {
      // load from db
      List<ZapRecordsDBISAR?> maps =
          await Zaps.searchZapRecordsFromDB(bolt11: invoice);
      if (maps.isNotEmpty) {
        var db = maps.first;
        if (db != null) {
          Zaps.sharedInstance.zapRecords[db.bolt11] = db;
          return [db];
        }
      }
    }
    return [];
  }

  static Future<List<ZapRecordsDBISAR>> getZapReceipt(String zapper,
      {String? recipient, String? eventId, String? invoice}) async {
    if (invoice != null) {
      // load from cache
      if (Zaps.sharedInstance.zapRecords.containsKey(invoice)) {
        var db = Zaps.sharedInstance.zapRecords[invoice];
        return [db!];
      } else {
        // load from db
        List<ZapRecordsDBISAR?> maps =
            await Zaps.searchZapRecordsFromDB(bolt11: invoice);
        if (maps.isNotEmpty) {
          var db = maps.first;
          if (db != null) {
            Zaps.sharedInstance.zapRecords[db.bolt11] = db;
            return [db];
          }
        }
      }
    }
    // load from relay
    Completer<List<ZapRecordsDBISAR>> completer =
        Completer<List<ZapRecordsDBISAR>>();
    Filter f = Filter(kinds: [9735], authors: [zapper]);
    if (recipient != null) {
      f = Filter(kinds: [9735], authors: [zapper], p: [recipient]);
    }
    if (eventId != null) {
      f = Filter(kinds: [9735], authors: [zapper], e: [eventId]);
    }
    if (invoice != null) {
      f = Filter(kinds: [9735], bolt11: [invoice]);
    }
    List<Event> zapReceiptList = [];
    Connect.sharedInstance.addSubscription([f],
        eventCallBack: (event, relay) async {
      zapReceiptList.add(event);
    }, eoseCallBack: (requestId, status, relay, unRelays) async {
      if (zapReceiptList.isNotEmpty) {
        List<ZapRecordsDBISAR> result = [];
        for (var event in zapReceiptList) {
          ZapRecordsDBISAR zapRecordsDB = await handleZapRecordEvent(event);
          result.add(zapRecordsDB);
        }
        if (!completer.isCompleted) completer.complete(result);
      }
      if (unRelays.isEmpty && !completer.isCompleted) completer.complete([]);
    });
    return completer.future;
  }

  static Future<List<ZapRecordsDBISAR?>> searchZapRecordsFromDB(
      {String? bolt11,
      String? sender,
      String? recipient,
      int limit = 1000}) async {
    if (bolt11 == null && sender == null && recipient == null) return [];
    final isar = DBISAR.sharedInstance.isar;
    var queryBuilder = isar.zapRecordsDBISARs.filter();
    List<ZapRecordsDBISAR?> maps = [];
    if (bolt11 != null) {
      maps = await queryBuilder.bolt11EqualTo(bolt11).sortByPaidAtDesc().limit(limit).findAll();
    }
    if (sender != null) {
      maps = await queryBuilder.senderEqualTo(sender).sortByPaidAtDesc().limit(limit).findAll();
    }
    if (recipient != null) {
      maps =
          await queryBuilder.recipientEqualTo(recipient).sortByPaidAtDesc().limit(limit).findAll();
    }

    for (ZapRecordsDBISAR? records in maps) {
      if (records != null) {
        Zaps.sharedInstance.zapRecords[records.bolt11] = records;
      }
    }
    return maps;
  }

  static Future<void> saveZapRecordToDB(ZapRecordsDBISAR zapRecordsDB) async {
    await DBISAR.sharedInstance.saveToDB(zapRecordsDB);
  }

  static Future<ZapRecordsDBISAR> handleZapRecordEvent(Event event) async {
    ZapReceipt zapReceipt = await Nip57.getZapReceipt(
        event,
        Account.sharedInstance.currentPubkey,
        Account.sharedInstance.currentPrivkey);
    ZapRecordsDBISAR zapRecordsDB =
        ZapRecordsDBISAR.zapReceiptToZapRecordsDB(zapReceipt);
    //add to zap records
    await saveZapRecordToDB(zapRecordsDB);
    Zaps.sharedInstance.zapRecords[zapRecordsDB.bolt11] = zapRecordsDB;
    Zaps.sharedInstance.zapRecordsCallBack?.call(zapRecordsDB);
    //add to moment notifications
    Moment.sharedInstance.handleZapNotification(zapRecordsDB, event);
    return zapRecordsDB;
  }

  static bool isLightningInvoice(String input) {
    RegExp regExp = RegExp(r'^\s*(lnbc|lntb)[0-9a-zA-Z]+\s*$');
    return regExp.hasMatch(input);
  }

  static Map<String, String> decodeInvoice(String invoice) {
    Bolt11PaymentRequest req = Bolt11PaymentRequest(invoice);
    return {
      'amount': (req.amount * Decimal.fromInt(100000000)).toString(),
      'timestamp': req.timestamp.toString()
    };
  }
}
