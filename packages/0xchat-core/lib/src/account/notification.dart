import 'dart:async';
import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

class NotificationHelper {
  /// singleton
  NotificationHelper._internal();
  factory NotificationHelper() => sharedInstance;
  static final NotificationHelper sharedInstance = NotificationHelper._internal();

  // memory storage
  String serverPubkey = '';
  Timer? timer;
  List<String> toRelays = Relays.sharedInstance.recommendGeneralRelays;

  Event? unSendNotification;

  // key: private key
  // serverkey: server pubkey
  Future<void> init(String serverKey) async {
    serverPubkey = serverKey;
    if(serverPubkey.isEmpty) return;

    startHeartBeat();
    _heartBeat(serverPubkey);

    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) async {
      if (status == 1 && toRelays.contains(relay)) {
        _heartBeat(serverPubkey, relay: [relay]);
        if (unSendNotification != null) {
          Connect.sharedInstance.sendEvent(unSendNotification!, sendCallBack: (ok, relay) {
            if (ok.status) unSendNotification = null;
          }, toRelays: toRelays);
        } else {
          _heartBeat(serverPubkey);
        }
      }
    });
  }

  void startHeartBeat() {
    if (timer == null || timer!.isActive == false) {
      timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
        _heartBeat(serverPubkey);
      });
    }
  }

  void _stopHeartBeat() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  Future<Event> _encode(String receiver, String content, String replyId) async {
    String enContent = await Nip4.encryptContent(content, receiver,
        Account.sharedInstance.currentPubkey, Account.sharedInstance.currentPrivkey);
    List<List<String>> tags = Nip4.toTags(receiver, replyId, '', null);
    Event event = await Event.from(
        kind: 22456,
        tags: tags,
        content: enContent,
        pubkey: Account.sharedInstance.currentPubkey,
        privkey: Account.sharedInstance.currentPrivkey);
    return event;
  }

  Future<void> _heartBeat(String serverPubkey, {List<String>? relay}) async {
    if(serverPubkey.isEmpty) return;

    Map map = {'online': 1};
    Event event = await _encode(serverPubkey, jsonEncode(map), '');
    Connect.sharedInstance.sendEvent(event, toRelays: relay ?? toRelays);
  }

  Future<void> setOffline() async {
    if(serverPubkey.isEmpty) return;

    Map map = {'online': 0};
    Event event = await _encode(serverPubkey, jsonEncode(map), '');
    Connect.sharedInstance.sendEvent(event, toRelays: toRelays);

    _stopHeartBeat();
  }

  void setOnline() {
    if(serverPubkey.isEmpty) return;

    _heartBeat(serverPubkey);
    startHeartBeat();
  }

  Future<OKEvent> logout() async {
    Map map = {'online': 0, 'deviceId': ''};
    Event event = await _encode(serverPubkey, jsonEncode(map), '');
    Completer<OKEvent> completer = Completer<OKEvent>();
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (!completer.isCompleted) {
        completer.complete(ok);
        _stopHeartBeat();
      }
    }, toRelays: toRelays);
    return completer.future;
  }

  // call setNotification when online or updating notification
  Future<OKEvent> setNotification(String deviceId, List<int> kinds, List<String> relays) async {
    if (serverPubkey.isEmpty) return OKEvent('', false, 'not init');

    Completer<OKEvent> completer = Completer<OKEvent>();
    List<String> channels = Channels.sharedInstance.getAllUnMuteChannels();
    List<String> groups = RelayGroup.sharedInstance.getAllUnMuteGroups();
    var authors = Contacts.sharedInstance.allContacts.keys.toList();
    var ptags = [Account.sharedInstance.currentPubkey];
    // List<SecretSessionDB> secretSessions =
    // Contacts.sharedInstance.secretSessionMap.values.toList();
    // for (var session in secretSessions) {
    //   if (Contacts.sharedInstance.allContacts.containsKey(session.toPubkey)) {
    //     /// in contacts list
    //     var sharePubkey = session.sharePubkey;
    //     if (sharePubkey != null && sharePubkey.isNotEmpty) {
    //       pubKeys.add(sharePubkey);
    //     }
    //   }
    // }
    Map map = {
      'authors': authors,
      'kinds': kinds,
      'deviceId': deviceId,
      'relays': relays,
      '#e': [...channels, ...groups],
      '#p': ptags
    };
    Event event = await _encode(serverPubkey, jsonEncode(map), '');
    unSendNotification = event;
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (!completer.isCompleted) {
        if (ok.status) unSendNotification = null;
        completer.complete(ok);
      }
    }, toRelays: toRelays);
    return completer.future;
  }
}
