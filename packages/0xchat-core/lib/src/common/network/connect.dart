import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// notice callback
typedef NoticeCallBack = void Function(String notice, String relay);

/// send event callback
typedef OKCallBack = void Function(OKEvent ok, String relay);

/// request callback
typedef EventCallBack = void Function(Event event, String relay);
typedef EOSECallBack = void Function(
    String requestId, OKEvent ok, String relay, List<String> unCompletedRelays);

/// connect callback
typedef ConnectStatusCallBack = void Function(String relay, int status, List<RelayKind> relayKinds);

class Sends {
  String sendsId;
  List<String> relays;
  int sendsTime;
  String eventId;
  OKCallBack? okCallBack;
  String eventString;

  Sends(this.sendsId, this.relays, this.sendsTime, this.eventId, this.okCallBack, this.eventString);
}

class Requests {
  String requestId;
  List<String> relays;
  int requestTime;
  Map<String, String> subscriptions;
  EventCallBack? eventCallBack;
  EOSECallBack? eoseCallBack;
  String subscriptionString;
  bool closeSubscription;

  Requests(this.requestId, this.relays, this.requestTime, this.subscriptions, this.eventCallBack,
      this.eoseCallBack, this.subscriptionString, this.closeSubscription);
}

class AuthData {
  String challenge;
  String eventId;
  List<String> resendDatas;

  AuthData(this.challenge, this.eventId, this.resendDatas);
}

class ISocket {
  WebSocket? socket;

  /// connecting = 0;
  /// open = 1;
  /// closing = 2;
  /// closed = 3;
  int connectStatus;
  List<RelayKind> relayKinds = [];

  ISocket(this.socket, this.connectStatus, this.relayKinds);
}

enum RelayKind {
  general,
  dm,
  inbox,
  outbox,
  relayGroup,
  secretChat,
  nwc,
  remoteSigner,
  circleRelay,
  temp,
  search,
}

class Connect {
  Connect._internal() {
    startHeartBeat();
    listenConnectivity();
  }
  factory Connect() => sharedInstance;
  static final Connect sharedInstance = Connect._internal();

  static final int timeout = 10;
  static final int MAX_SUBSCRIPTIONS_COUNT = 15;

  NoticeCallBack? noticeCallBack;
  StreamSubscription? _connectivitySubscription;

  /// sockets
  Map<String, ISocket> webSockets = {};

  // subscriptionId+relay, Requests
  Map<String, Requests> requestsMap = {};
  // send event callback
  Map<String, Sends> sendsMap = {};
  // ConnectStatus listeners
  List<ConnectStatusCallBack> connectStatusListeners = [];
  // for timeout
  Timer? timer;
  // relay AUTH
  Map<String, AuthData> auths = {};

  Map<String, List<Future<bool>>> eventCheckerFutures = {};

  Map<String, List<String>> subscriptionsWaitingQueue = {};

  void startHeartBeat() {
    if (timer == null || timer!.isActive == false) {
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
        _checkTimeout();
      });
    }
    resetConnection(force: false);
  }

  Future<void> resetConnection({bool force = true}) async {
    for (var relay in webSockets.keys) {
      if (webSockets[relay]?.connectStatus != 3 && force) {
        webSockets[relay]?.connectStatus = 3;
        await webSockets[relay]?.socket?.close();
      }
      for (var relayKind in webSockets[relay]?.relayKinds ?? []) {
        connect(relay, relayKind: relayKind);
      }
    }
  }

  void listenConnectivity() {
    _connectivitySubscription ??=
        Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      if (results.any((result) => result != ConnectivityResult.none)) {
        resetConnection(force: false);
      }
    });
  }

  // void _stopCheckTimeOut() {
  //   if (timer != null && timer!.isActive) {
  //     timer!.cancel();
  //   }
  // }

  void _checkTimeout() {
    var now = DateTime.now().millisecondsSinceEpoch;
    Iterable<String> okMapKeys = List<String>.from(sendsMap.keys);
    for (var eventId in okMapKeys) {
      var start = sendsMap[eventId]!.sendsTime;
      if (now - start > timeout * 1000) {
        // ok timeout
        OKEvent ok = OKEvent(eventId, false, 'Time Out');
        Iterable<String> relays = List<String>.from(sendsMap[eventId]!.relays);
        for (var relay in relays) {
          _handleOk(ok, relay);
        }
      }
    }
    Iterable<String> requestMapKeys = List<String>.from(requestsMap.keys);
    for (var requestMapKey in requestMapKeys) {
      var request = requestsMap[requestMapKey];
      if (request != null) {
        // call closeSubscription type eoseCallBack only once
        if (request.closeSubscription == false && request.eoseCallBack == null) continue;
        var start = request.requestTime;
        if (start > 0 && now - start > timeout * 1000) {
          // request timeout
          String relay = requestMapKey.substring(64);
          _handleEOSE(jsonEncode([request.requestId]), relay, true);
        }
      }
    }
  }

  void _setConnectStatus(String relay, int status) {
    webSockets[relay]?.connectStatus = status;
    for (var callBack in connectStatusListeners) {
      callBack(relay, status, webSockets[relay]?.relayKinds ?? []);
    }
  }

  void addConnectStatusListener(ConnectStatusCallBack callBack) {
    if (!connectStatusListeners.contains(callBack)) {
      connectStatusListeners.add(callBack);
    }
  }

  void removeConnectStatusListener(ConnectStatusCallBack callBack) {
    if (connectStatusListeners.contains(callBack)) {
      connectStatusListeners.remove(callBack);
    }
  }

  List<String> relays({List<RelayKind> relayKinds = const [RelayKind.general]}) {
    List<String> result = [];
    for (var relay in webSockets.keys) {
      if (webSockets[relay]?.connectStatus == 1 &&
          webSockets[relay]!.relayKinds.any((e) => relayKinds.contains(e))) {
        result.add(relay);
      }
    }
    return result;
  }

  Future<void> connect(String relay, {RelayKind relayKind = RelayKind.general}) async {
    LogUtils.v(() => 'connect to $relay, kind: ${relayKind.name}');
    if (relay.isEmpty) return;

    List<RelayKind> relayKinds = webSockets[relay]?.relayKinds ?? [relayKind];
    if (!relayKinds.contains(relayKind)) {
      relayKinds.add(relayKind);
    }
    webSockets[relay]?.relayKinds = relayKinds;
    // connecting or open
    if (webSockets[relay]?.connectStatus == 0 || webSockets[relay]?.connectStatus == 1) return;
    LogUtils.v(() => "connecting... $relay");
    webSockets[relay] = ISocket(null, 0, relayKinds);
    try {
      WebSocket? socket;
      socket = await _connectWs(relay);
      if (socket != null) {
        socket.done.then((dynamic _) => _onDisconnected(relay, relayKind));
        _listenEvent(socket, relay, relayKind);
        webSockets[relay] = ISocket(socket, 1, relayKinds);
        LogUtils.v(() => "$relay connection initialized");
        _setConnectStatus(relay, 1);
      }
    } catch (_) {
      _onDisconnected(relay, relayKind);
    }
  }

  Future<bool> connectRelays(List<String> relays, {RelayKind relayKind = RelayKind.general}) async {
    final completer = Completer<bool>();
    if (relays.isEmpty && !completer.isCompleted) completer.complete(true);
    if (relayKind == RelayKind.temp) {
      // timeout for temp relays
      Timer(Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          completer.complete(false);
          closeConnects(relays, relayKind);
        }
      });
    }
    for (String relay in relays) {
      connect(relay, relayKind: relayKind).then((value) {
        if (!completer.isCompleted) completer.complete(true);
      });
    }
    return completer.future;
  }

  Future closeConnects(List<String> relays, RelayKind relayKind) async {
    await Future.forEach(relays, (relay) async {
      webSockets[relay]?.relayKinds.removeWhere((e) => (e == RelayKind.temp || e == relayKind));
      if (webSockets[relay]?.relayKinds.isEmpty == true) {
        await closeConnect(relay);
      }
    });
  }

  Future closeTempConnects(List<String> relays) async {
    await closeConnects(relays, RelayKind.temp);
  }

  Future closeAllConnects() async {
    await Future.forEach(List.from(webSockets.keys), (relay) async {
      await closeConnect(relay);
    });
    sendsMap.clear();
    requestsMap.clear();
    auths.clear();
    eventCheckerFutures.clear();
    subscriptionsWaitingQueue.clear();
  }

  Future closeConnect(String relay) async {
    LogUtils.v(() => 'closeConnect ${webSockets[relay]?.socket}');
    final socket = webSockets[relay]?.socket;
    webSockets.remove(relay);
    await socket?.close();
  }

  String addSubscription(List<Filter> filters,
      {EventCallBack? eventCallBack,
      EOSECallBack? eoseCallBack,
      List<String>? relays,
      List<RelayKind> relayKinds = const [RelayKind.general, RelayKind.circleRelay],
      bool closeSubscription = true}) {
    Map<String, List<Filter>> result = {};
    List<String> rs = [];
    if (relays != null) {
      rs = List.from(relays
          .where((relay) =>
              relay.isNotEmpty && (relay.startsWith('ws://') || relay.startsWith('wss://')))
          .toList());
    }
    List<String> subscriptionRelays =
        rs.isNotEmpty == true ? rs : Connect.sharedInstance.relays(relayKinds: relayKinds);
    if (subscriptionRelays.isEmpty) {
      eoseCallBack?.call('', OKEvent('', false, 'no relays connected'), '', []);
      return '';
    }
    for (var relay in subscriptionRelays) {
      result[relay] = filters;
    }
    return addSubscriptions(result,
        eventCallBack: eventCallBack,
        eoseCallBack: eoseCallBack,
        closeSubscription: closeSubscription);
  }

  String addSubscriptions(Map<String, List<Filter>> filters,
      {EventCallBack? eventCallBack, EOSECallBack? eoseCallBack, bool closeSubscription = true}) {
    /// Create a subscription message request with one or many filters
    String requestsId = generate64RandomHexChars();
    for (String relay in filters.keys) {
      Request requestWithFilter = Request(requestsId, filters[relay]!);
      String subscriptionString = requestWithFilter.serialize();

      /// add request to request map
      Requests requests = Requests(requestsId, filters.keys.toList(), 0, {}, eventCallBack,
          eoseCallBack, subscriptionString, closeSubscription);
      requests.subscriptions[relay] = requestWithFilter.subscriptionId;
      requestsMap[requestWithFilter.subscriptionId + relay] = requests;

      /// Send a request message to the WebSocket server
      _addSubscriptionToQueue(requestsId, relay);

      LogUtils.v(() => '$subscriptionString, $relay');
    }
    return requestsId;
  }

  void _addSubscriptionToQueue(String subscriptionId, String relay) {
    var waitingQueue = subscriptionsWaitingQueue[relay] ?? [];
    if (!waitingQueue.contains(subscriptionId)) {
      waitingQueue.add(subscriptionId);
      subscriptionsWaitingQueue[relay] = waitingQueue;
    }
    _sendSubscription(relay);
  }

  void _sendSubscription(String relay) {
    var sendingQueue = 0;
    for (var key in requestsMap.keys) {
      if (key.contains(relay) &&
          requestsMap[key]!.relays.contains(relay) &&
          requestsMap[key]!.requestTime > 0) {
        ++sendingQueue;
      }
    }
    var waitingQueue = subscriptionsWaitingQueue[relay] ?? [];

    if (sendingQueue < MAX_SUBSCRIPTIONS_COUNT && waitingQueue.isNotEmpty) {
      String subscriptionId = waitingQueue.removeAt(0);
      var request = requestsMap[subscriptionId + relay];
      if (request != null) {
        requestsMap[subscriptionId + relay]!.requestTime = DateTime.now().millisecondsSinceEpoch;
        _send(request.subscriptionString, toRelays: [relay]);
      }
    } else {
      LogUtils.v(
          () => 'sendingQueue: ${sendingQueue}, waitingQueue: ${waitingQueue.length}, $relay');
    }
  }

  Future _closeSubscription(String subscriptionId, String relay) async {
    LogUtils.v(() => 'send ${Close(subscriptionId).serialize()}, $relay');
    if (subscriptionId.isNotEmpty) {
      _send(Close(subscriptionId).serialize(), toRelays: [relay]);
      // remove the mapping
      requestsMap.remove(subscriptionId + relay);
      _sendSubscription(relay);
    }
  }

  Future closeRequests(String requestId, {String? relay}) async {
    Iterable<String> requestsMapKeys = List<String>.from(requestsMap.keys);

    // Find all entries with matching requestId (there may be multiple entries, one per relay)
    List<MapEntry<String, Requests>> matchingEntries = [];
    for (var key in requestsMapKeys) {
      var requests = requestsMap[key];
      if (requests!.requestId == requestId) {
        matchingEntries.add(MapEntry(key, requests));
      }
    }
    
    if (matchingEntries.isEmpty) {
      return;
    }
    
    // Close subscriptions for all matching entries
    for (var entry in matchingEntries) {
      var requests = entry.value;
      
      if (relay != null) {
        // Close specific relay subscription if it exists in this entry
        if (requests.subscriptions.containsKey(relay) && requests.subscriptions[relay] != null) {
          await _closeSubscription(requests.subscriptions[relay]!, relay);
        }
      } else {
        // Close all subscriptions for this entry
        for (var subscriptionRelay in requests.subscriptions.keys) {
          if (requests.subscriptions[subscriptionRelay] != null) {
            await _closeSubscription(requests.subscriptions[subscriptionRelay]!, subscriptionRelay);
          } 
        }
      }
    }
  }

  /// send an event to relay/relays
  void sendEvent(Event event,
      {OKCallBack? sendCallBack,
      List<String>? toRelays,
      List<RelayKind> relayKinds = const [
        RelayKind.general,
        RelayKind.outbox,
        RelayKind.circleRelay
      ]}) {
    String eventString = event.serialize();
    List<String> rs;
    bool useExplicitRelays = false;
    
    if (toRelays != null && toRelays.isNotEmpty) {
      // User explicitly provided relay list
      rs = List.from(toRelays);
      useExplicitRelays = true;
    } else {
      // Get relays based on relayKinds
      rs = relays(relayKinds: relayKinds);
      // Only add circleRelay if it's included in the requested relayKinds
      // This allows users to explicitly choose which relay types to use
      if (relayKinds.contains(RelayKind.circleRelay)) {
        rs.addAll(relays(relayKinds: [RelayKind.circleRelay]));
      }
      // If relayKinds is not the default (contains only general, outbox, circleRelay),
      // then user explicitly chose, so don't fallback to all relays
      final defaultKinds = [RelayKind.general, RelayKind.outbox, RelayKind.circleRelay];
      useExplicitRelays = !_listEquals(relayKinds, defaultKinds);
    }
    
    LogUtils.v(() => 'send event toRelays: ${jsonEncode(rs)}, relayKinds: ${relayKinds.map((e) => e.name)}, useExplicitRelays: $useExplicitRelays');
    Sends sends = Sends(generate64RandomHexChars(), rs, DateTime.now().millisecondsSinceEpoch,
        event.id, sendCallBack, eventString);
    sendsMap[event.id] = sends;
    // If user explicitly chose relayKinds but no relays are available, don't fallback to all relays
    _send(eventString, toRelays: rs, eventId: event.id, allowFallbackToAll: !useExplicitRelays);
  }
  
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _send(String data, {List<String>? toRelays, String? eventId, String? subscriptionId, bool allowFallbackToAll = true}) {
    if (toRelays != null) {
      // If toRelays is an empty list and allowFallbackToAll is false, don't send to any relay
      if (toRelays.isEmpty && !allowFallbackToAll) {
        if (eventId != null) {
          _handleOk(OKEvent(eventId, false, 'no relays available'), '');
        }
        return;
      }
      
      if (toRelays.isNotEmpty) {
        toRelays = Set.from(toRelays).cast<String>().toList();
        for (var relay in toRelays) {
          if (webSockets.containsKey(relay)) {
            var socket = webSockets[relay]?.socket;
            if (webSockets[relay]?.connectStatus == 1 && socket != null) {
              socket.add(data);
            } else if (eventId != null) {
              _handleOk(OKEvent(eventId, false, 'not connect to relay'), relay);
            } else if (subscriptionId != null) {
              _handleCLOSED(Closed(subscriptionId), relay);
            }
          } else if (eventId != null) {
            _handleOk(OKEvent(eventId, false, 'not connect to relay'), relay);
          } else if (subscriptionId != null) {
            _handleCLOSED(Closed(subscriptionId), relay);
          }
        }
        return;
      }
    }
    
    // Fallback to all connected relays only if allowFallbackToAll is true
    if (allowFallbackToAll) {
      bool hasConnectedRelay = false;
      webSockets.forEach((url, socket) {
        if (webSockets[url]?.connectStatus == 1 && socket.socket != null) {
          socket.socket?.add(data);
          hasConnectedRelay = true;
        } else if (eventId != null) {
          _handleOk(OKEvent(eventId, false, 'not connect to relay'), url);
        } else if (subscriptionId != null) {
          _handleCLOSED(Closed(subscriptionId), url);
        }
      });
      // If no connected relays and eventId is set, handle as failure
      if (!hasConnectedRelay && eventId != null && webSockets.isEmpty) {
        _handleOk(OKEvent(eventId, false, 'no relays available'), '');
      }
    } else if (eventId != null) {
      _handleOk(OKEvent(eventId, false, 'no relays available'), '');
    }
  }

  static Future<Message> _deserializeMessage(String message) async {
    return await Message.deserialize(message);
  }

  Future<void> _handleMessage(String message, String relay) async {
    var m = await ThreadPoolManager.sharedInstance.runOtherTask(() => _deserializeMessage(message));
    switch (m.type) {
      case "EVENT":
        _handleEvent(m.message, relay);
        break;
      case "EOSE":
        _handleEOSE(m.message, relay, false);
        break;
      case "CLOSED":
        _handleCLOSED(m.message, relay);
        break;
      case "NOTICE":
      case "NOTIFY":
        _handleNotice(m.message, relay);
        break;
      case "OK":
        _handleOk(m.message, relay);
        break;
      case "AUTH":
        _handleAuth(m.message, relay);
        break;
      default:
        LogUtils.v(() => 'Received message not supported: $message');
        break;
    }
  }

  Future<bool> _checkValidEvent(Event event, String relay) async {
    String? subscriptionId = event.subscriptionId;
    if (subscriptionId != null) {
      String requestsMapKey = subscriptionId + relay;
      if (subscriptionId.isNotEmpty && requestsMap.containsKey(requestsMapKey)) {
        // reset requestTime
        requestsMap[requestsMapKey]!.requestTime = DateTime.now().millisecondsSinceEpoch;
        EventCallBack? callBack = requestsMap[requestsMapKey]!.eventCallBack;
        if (callBack != null) {
          EventCache.sharedInstance.receiveEvent(event, relay);
          // check sign
          if (await event.isValid() == false) {
            return false;
          }
          callBack(event, relay);
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _handleEvent(Event event, String relay) async {
    LogUtils.v(() => 'Received event, subscriptionId: ${event.subscriptionId}, ${event.toJson()}');
    if (EventCache.sharedInstance.cacheIds.contains(event.id)) {
      return;
    }
    // ignore the expired event
    if (Nip40.expired(event)) {
      EventCache.sharedInstance.receiveEvent(event, relay);
      return;
    }

    Future<bool> future = _checkValidEvent(event, relay);
    if (event.subscriptionId != null && event.subscriptionId!.isNotEmpty) {
      eventCheckerFutures[event.subscriptionId! + relay] ??= [];
      eventCheckerFutures[event.subscriptionId! + relay]?.add(future);
    }
  }

  Future<void> _handleEOSE(String eose, String relay, bool timeout) async {
    LogUtils.v(() => 'receive EOSE: $eose, $relay, timeout: $timeout');
    String subscriptionId = jsonDecode(eose)[0];
    String requestsMapKey = subscriptionId + relay;
    if (subscriptionId.isNotEmpty && requestsMap.containsKey(requestsMapKey)) {
      if (eventCheckerFutures.containsKey(requestsMapKey)) {
        await Future.wait(eventCheckerFutures[requestsMapKey]!);
        eventCheckerFutures.remove(requestsMapKey);
      }
      _removeRequestsMapRelay(subscriptionId, relay, timeout);
    }
  }

  void _handleCLOSED(Closed closed, String relay) {
    LogUtils.v(() => 'receive closed: ${closed.serialize()}, $relay');
    String subscriptionId = closed.subscriptionId;
    String requestsMapKey = subscriptionId + relay;
    if (subscriptionId.isNotEmpty && requestsMap.containsKey(requestsMapKey)) {
      // check auth
      if (Nip42.authRequired(closed.message)) {
        String subscriptionString = requestsMap[requestsMapKey]!.subscriptionString;
        if (auths[relay]?.resendDatas.contains(subscriptionString) == false) {
          auths[relay]?.resendDatas.add(subscriptionString);
        }
        _sendAuth(relay);
        return;
      }
      _removeRequestsMapRelay(subscriptionId, relay, true);
    }
  }

  void _handleNotice(String notice, String relay) {
    LogUtils.v(() => 'receive notice: $notice, $relay');
    String n = jsonDecode(notice)[0];

    List<String> requestsMapKeys =
        requestsMap.keys.where((element) => element.contains(relay)).toList();
    for (var requestsMapKey in requestsMapKeys) {
      _removeRequestsMapRelay(requestsMapKey.replaceAll(relay, ''), relay, true);
    }

    noticeCallBack?.call(n, relay);
  }

  Future<void> _handleOk(OKEvent ok, String relay) async {
    LogUtils.v(() => 'receive ok: ${ok.serialize()}, $relay');
    // check auth response
    if (auths[relay]?.eventId == ok.eventId) {
      if (ok.status) {
        for (var data in auths[relay]?.resendDatas ?? []) {
          LogUtils.v(() => 're-send: $data');
          _send(data, toRelays: [relay]);
        }
      }
      auths.remove(relay);
      return;
    }
    
    // Update eventSendStatus in EventDBISAR
    if (ok.eventId.isNotEmpty) {
      EventCache.sharedInstance.updateEventSendStatus(ok.eventId, relay, ok.status, ok.message);
    }
    
    if (sendsMap.containsKey(ok.eventId)) {
      // check need auth
      if (!ok.status && Nip42.authRequired(ok.message)) {
        String eventString = sendsMap[ok.eventId]!.eventString;
        if (auths[relay]?.resendDatas.contains(eventString) == false) {
          auths[relay]?.resendDatas.add(eventString);
        }
        _sendAuth(relay);
        return;
      }
      // callback
      if (sendsMap[ok.eventId]!.okCallBack != null) {
        var relays = sendsMap[ok.eventId]!.relays;
        relays.remove(relay);
        // If event succeeded, call callback immediately
        // If event failed, call callback only when all relays have been tried (relays.isEmpty)
        // This ensures callback is always called, even if all relays fail
        if (ok.status || relays.isEmpty) {
          sendsMap[ok.eventId]!.okCallBack!(ok, relay);
          sendsMap.remove(ok.eventId);
        } else if (!ok.status && ok.eventId.isEmpty) {
          List<String> requestsMapKeys =
              requestsMap.keys.where((element) => element.contains(relay)).toList();
          for (var requestsMapKey in requestsMapKeys) {
            _removeRequestsMapRelay(requestsMapKey.replaceAll(relay, ''), relay, true);
          }
        }
      } else {
        var relays = sendsMap[ok.eventId]!.relays;
        relays.remove(relay);
        if (relays.isEmpty) sendsMap.remove(ok.eventId);
      }
    }
  }

  void _handleAuth(Auth auth, String relay) {
    LogUtils.v(() => 'receive auth: ${auth.challenge}');
    if (!auths.containsKey(relay)) {
      auths[relay] = AuthData(auth.challenge, '', []);
    } else if (auths[relay]?.challenge != auth.challenge) {
      auths[relay]?.challenge = auth.challenge;
      auths[relay]?.eventId = '';
    }
  }

  void _removeRequestsMapRelay(String subscriptionId, String removeRelay, bool error) {
    var requestsMapKey = subscriptionId + removeRelay;
    var request = requestsMap[requestsMapKey];
    if (request == null) return;
    request.relays.remove(removeRelay);
    // remove others relay
    for (var r in requestsMap.values) {
      if (r.requestId == request.requestId) {
        r.relays.remove(removeRelay);
      }
    }
    // all relays have EOSE
    EOSECallBack? callBack = request.eoseCallBack;
    OKEvent ok = OKEvent(subscriptionId, !error, '');
    if (callBack != null) callBack(subscriptionId, ok, removeRelay, request.relays);
    requestsMap[requestsMapKey]?.eoseCallBack = null;
    if (request.closeSubscription) _closeSubscription(subscriptionId, removeRelay);
  }

  Future<void> _sendAuth(String relay) async {
    String? challenge = auths[relay]?.challenge;
    if (challenge == null || challenge.isEmpty) return;
    String? eventId = auths[relay]?.eventId;
    if (eventId?.isNotEmpty == true) return;
    auths[relay]!.eventId = 'sending...';
    Event event = await Nip42.encode(challenge, relay, Account.sharedInstance.currentPubkey,
        Account.sharedInstance.currentPrivkey);
    var authJson = Nip42.authString(event);
    auths[relay]!.eventId = event.id;
    LogUtils.v(() => 'send auth: $authJson');
    _send(authJson, toRelays: [relay]);
  }

  Future<void> _reConnectToRelay(String relay, RelayKind relayKind) async {
    _setConnectStatus(relay, 3); // closed
    await Future.delayed(Duration(milliseconds: 3000));
    if (webSockets.containsKey(relay)) {
      await connect(relay, relayKind: relayKind);
    }
  }

  void _listenEvent(WebSocket socket, String relay, RelayKind relayKind) {
    socket.listen((message) async {
      await _handleMessage(message, relay);
    }, onDone: () async {
      LogUtils.v(() => "connect aborted");
      await _reConnectToRelay(relay, relayKind);
    }, onError: (e) async {
      LogUtils.v(() => 'Server error: $e');
      await _reConnectToRelay(relay, relayKind);
    });
  }

  Future _connectWs(String relay) async {
    try {
      _setConnectStatus(relay, 0); // connecting
      return await _connectWsSetting(relay);
    } catch (e) {
      LogUtils.v(() => "Error! can not connect WS connectWs $e relay:$relay");
      _setConnectStatus(relay, 3); // closed

      // Check if error is "was not upgraded to websocket, HTTP status code: 200"
      // If so, don't retry connection
      String errorStr = e.toString();
      if (errorStr.contains('was not upgraded to websocket') && 
          errorStr.contains('HTTP status code: 200')) {
        LogUtils.v(() => "WebSocket upgrade failed with HTTP 200, skipping retry for relay:$relay");
        return;
      }

      List<RelayKind>? relayKinds = webSockets[relay]?.relayKinds;
      bool hasNonTempKind = relayKinds?.any((kind) => kind != RelayKind.temp) ?? false;
      if (hasNonTempKind) {
        await Future.delayed(Duration(milliseconds: 3000));
        if (webSockets.containsKey(relay)) {
          return await _connectWs(relay);
        }
      }
    }
  }

  Future _connectWsSetting(String relay) async {
    String? host = Config.sharedInstance.hostConfig[relay];
    if (host != null && host.isNotEmpty) {
      relay = host;
    }

    return await WebSocket.connect(relay);
  }

  Future<void> _onDisconnected(String relay, RelayKind relayKind) async {
    LogUtils.v(() => "_onDisconnected");
    return await _reConnectToRelay(relay, relayKind);
  }

  /// Wait for a relay connection to be established
  /// Returns true if connection succeeds, false if connection fails
  /// Either relay or relayKind must be provided
  Future<bool> waitForRelayConnection({
    String? relay,
    RelayKind? relayKind,
  }) async {
    // Determine relay URL and relayKind
    String? targetRelay = relay;
    RelayKind? targetRelayKind = relayKind;

    // If relay is not provided, get it from relayKind
    if (targetRelay == null || targetRelay.isEmpty) {
      if (targetRelayKind == null) {
        return false; // Both relay and relayKind are null
      }

      if (targetRelayKind == RelayKind.circleRelay) {
        final relays = this.relays(relayKinds: [RelayKind.circleRelay]);
        if (relays.isEmpty) return false;
        targetRelay = relays.first;
      } else {
        // For other relay kinds, get from connected relays
        final connectedRelays = this.relays(relayKinds: [targetRelayKind]);
        if (connectedRelays.isEmpty) return false;
        targetRelay = connectedRelays.first;
      }
    }

    // At this point, targetRelay should not be null or empty
    if (targetRelay.isEmpty) return false;

    // If relayKind is not provided, try to infer from existing connection
    if (targetRelayKind == null) {
      final webSocket = webSockets[targetRelay];
      targetRelayKind = webSocket?.relayKinds.isNotEmpty == true
          ? webSocket!.relayKinds.first
          : RelayKind.general;
    }

    // Check if already connected
    // connectStatus: 0=connecting, 1=open, 2=closing, 3=closed
    final webSocket = webSockets[targetRelay];
    if (webSocket != null &&
        webSocket.connectStatus == 1 &&
        webSocket.relayKinds.contains(targetRelayKind)) {
      return true;
    }

    // If relay is not in webSockets or not connecting, start connection
    if (webSocket == null || webSocket.connectStatus == 3) {
      connect(targetRelay, relayKind: targetRelayKind);
    }

    // Create completer to wait for connection
    final completer = Completer<bool>();
    ConnectStatusCallBack? connectionListener;

    // Setup connection status listener
    connectionListener = (String statusRelay, int status, List<RelayKind> relayKinds) {
      if (statusRelay != targetRelay) return;

      // Connection succeeded (status 1 = open)
      if (status == 1 && relayKinds.contains(targetRelayKind)) {
        removeConnectStatusListener(connectionListener!);
        if (!completer.isCompleted) {
          completer.complete(true);
        }
        return;
      }

      // Connection failed (status 3 = closed and no longer in webSockets, meaning no retry)
      if (status == 3 && !webSockets.containsKey(targetRelay)) {
        removeConnectStatusListener(connectionListener!);
        if (!completer.isCompleted) {
          completer.complete(false);
        }
        return;
      }
    };

    // Add listener to wait for connection
    addConnectStatusListener(connectionListener);

    // Wait for connection result
    return completer.future;
  }
}