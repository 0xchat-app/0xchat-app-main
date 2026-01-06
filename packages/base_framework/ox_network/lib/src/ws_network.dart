import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:ox_network/src/utils/log_util.dart';
import 'package:ox_network/src/websocket/ox_websocket_channel.dart';

abstract class OXWSDataObserver {
  void onWebSocketMessage(OXWSResponse response);

  ///Page observer binding unique identity
  String get wsObserverKey => this.runtimeType.toString();
}

abstract class OXWSStateObserver {
  void onConnect();
  void onDisconnect();
  void onReconnect();
  void onReceiveData(Map<String, dynamic> data) {}
}

///WebSocket Connection state
enum WsStatus {
  open,
  connecting,
  closed,
  closing,
}

///WebSocket Link class
class WsNetwork extends OXWSConnectStateObserver {
  String tag = 'WebSocket=====>';

  factory WsNetwork() => _getInstance();

  ///initialize
  WsNetwork._init();

  static WsNetwork _getInstance() {
    return WsNetwork._init();
  }

  OXWebSocketChannel? _channel;

  ///Global observer (unique key, repeatable value)
  Map<String, List<OXWSDataObserver>> _observerMap =
      Map<String, List<OXWSDataObserver>>();

  ///All subscriptions (key only)
  Map<String, OXWSChannel> _channelMap = new Map<String, OXWSChannel>();

  ///Global message subscription format set (key unique)
  List<OXWSResponse> _responseList = [];

  ///Connection address
  String _address = '';

  ///wss link host
  String? _host;

  ///Connection state
  WsStatus wsStatus = WsStatus.closed;

  OXWSStateObserver? _oxWSStateObserver;

  ///Whether reconnection is possible
  bool reconnectFlag = false;

  addConnectStateObserver(OXWSStateObserver? observer) {
    this._oxWSStateObserver = observer;
  }

  removeConnectStateObserver(OXWSStateObserver observer) {
    if (_oxWSStateObserver == observer) {
      this._oxWSStateObserver = null;
    }
  }

  ///Added global message subscription format
  void addResponse(OXWSResponse response) {
    if (_responseList.length > 0) {
      for (var i = 0; i < _responseList.length; ++i) {
        if (_responseList[i].channelName == response.channelName) {
          break;
        }
        if (i == _responseList.length - 1) {
          // LogUtil.log(key: tag,content:'addResponse：' + response.channelName.toString());
          _responseList.add(response);
        }
      }
    } else {
      // LogUtil.log(key: tag,content:'addResponse：' + response.channelName.toString());
      _responseList.add(response);
    }
  }


  void removeResponse(OXWSResponse response) {
    for (var i = 0; i < _responseList.length; ++i) {
      if (_responseList[i].channelName == response.channelName) {
        _responseList.removeAt(i);
        // LogUtil.log(key: tag,content:'removeResponse：' + response.channelName.toString());
        break;
      }
    }
  }

  Future<void> initWs({
    required String address,
    String? host,
  }) async {
    await closeWebSocket();
    LogUtil.log(key: tag, content: 'initWs-address:' + address.toString());
    _address = address;
    _host = host;
    reconnectFlag = true;
    print("****** ws _address $_address _host $_host");
    _connect();
  }

  ///Connecting WebSocket
  void _connect() async {
    if (wsStatus == WsStatus.closed) {
      wsStatus = WsStatus.connecting;
      Map<String, dynamic>? headers;
      if (_host != null && _host!.isNotEmpty) {
        headers = {
          'Host': _host,
        };
      }
      _channel = OXWebSocketChannel.connect(this, Uri.parse(_address),
          headers: headers);
      print("****** ws _channel $_address");
    }
  }

  ///Refresh connection status
  void refreshWsStatus(int state) {
    // print('refreshWsStatus' + state.toString());

    switch (state) {
      case WebSocket.connecting:
        wsStatus = WsStatus.connecting;
        break;
      case WebSocket.open:
        wsStatus = WsStatus.open;
        break;
      case WebSocket.closing:
        wsStatus = WsStatus.closing;
        break;
      case WebSocket.closed:
        wsStatus = WsStatus.closed;
        break;
      default:
        wsStatus = WsStatus.closed;
        break;
    }
  }

  ///Send a message
  sendMessage(OXWSChannel oxWSChannel) {
    //get parameter data // activityPeriodId...
    String jsonValue = json.encode(oxWSChannel.getData());
    // print("***** sendMessage jsonValue: $jsonValue");
    // print("***** sendMessage oxWSChannel.channelName: ${oxWSChannel.getData()}");
    if (wsStatus == WsStatus.open) {
      _channel?.sink.add(jsonValue);
      if (!oxWSChannel.getData().values.contains('ping')) {
        // LogUtil.log(key: tag,content: '-sendMessage:' + jsonValue);
      }
    } else {
      _channelMap[oxWSChannel.channelName] = oxWSChannel;
    }
  }

  ///Bind subscription
  void addChannel(OXWSDataObserver observer, OXWSChannel channel) async {
    addResponse(channel.getOXWSResponse());
    String channelName = channel.channelName;

    ///Merge subscription messages
    OXWSChannel? mergeChannel;
    if (!_channelMap.containsKey(channelName)) {
      _channelMap[channelName] = channel;
    } else {
      OXWSChannel oldChannel = _channelMap[channelName]!;
      mergeChannel = oldChannel.withAddChannel(channel);
      if (mergeChannel != null) {
        OXWSChannel? removeEventChannel = oldChannel.getRemoveEventChannel();
        // LogUtil.log(key: tag,content: 'Send unbinding for old subscription message-channel:' + removeEventChannel.getData().toString());
        ///Send the delete old subscription message first
        sendMessage(removeEventChannel);
      }
    }
    List<OXWSDataObserver> observerList = _observerMap[channelName] ?? [];
    if (observerList.length > 0) {
      int existIndex = -1;
      // LogUtil.log(key: tag,content: 'addChannel-observer-wsObserverKey：' + observer.wsObserverKey.toString());
      for (var i = 0; i < observerList.length; ++i) {
        if (observerList[i].wsObserverKey == observer.wsObserverKey) {
          existIndex = i;
          break;
        }
      }
      if (existIndex == -1) {
        ///Different service subscription
        ///Add multiple observers to the same channel
        observerList.add(observer);
      } else {
        ///When the same service is subscribed repeatedly, only one observer is reserved
        observerList[existIndex] = observer;
      }
      _observerMap[channelName] = observerList;
    } else {
      _observerMap[channelName] = []..add(observer);
      if (mergeChannel == null) {
        sendMessage(channel);
      }
    }
    if (mergeChannel != null) {
      // LogUtil.log(key: tag,content: 'Send merge subscription message-channel:'+mergeChannel.getData().toString());
      ///Then send the merge subscription message
      sendMessage(mergeChannel);

      ///Update subscription cache choose
      _channelMap[channelName] = mergeChannel;
    }
  }

  ///Unbind subscription
  void removeChannel(OXWSDataObserver observer, OXWSChannel channel) {
    String channelName = channel.channelName;
    if (_observerMap[channelName] == null || _channelMap[channelName] == null) {
      return;
    }
    List<OXWSDataObserver> channelObservers = _observerMap[channelName]!;
    // LogUtil.log(key: tag,content: 'removeChannel-observer-wsObserverKey：' + observer.wsObserverKey.toString());
    ///Remove observer
    for (var i = 0; i < channelObservers.length; ++i) {
      if (channelObservers[i].wsObserverKey == observer.wsObserverKey) {
        channelObservers.removeAt(i);
        break;
      }
    }

    ///Delete cache subscription
    if (channelObservers.isEmpty) {
      removeResponse(channel.getOXWSResponse());
      if (_channelMap.containsKey(channelName)) {
        _channelMap.remove(channelName);
      }
      sendMessage(channel);
    } else {
      OXWSChannel? resultChannel;
      OXWSChannel oldChannel = _channelMap[channelName]!;
      resultChannel = oldChannel.withRemoveChannel(channel);

      if (resultChannel != null) {
        ///Send the unbind subscription message first
        // LogUtil.log(key: tag,content: 'Send the unbind subscription message first-channel:'+channel.getData().toString());
        sendMessage(channel);
        OXWSChannel? addEventChannel = resultChannel.getAddEventChannel();

        ///The result binding subscription message is then sent
        // LogUtil.log(key: tag,content: 'The result binding subscription message is then sent-channel:'+addEventChannel.getData().toString());
        sendMessage(addEventChannel);

        ///Update the subscription cache as a result of deletion
        _channelMap[channelName] = resultChannel;
      }
    }
  }

  ///reconnection
  void reconnect() async {
    LogUtil.log(key: tag, content: 'Disconnection reconnects-reconnect-address:' + _address);
    if (_address != '') {
      await initWs(address: _address, host: _host);
    }
  }

  Future<void> closeWebSocket() async {
    if (wsStatus != WsStatus.closed) {
      // LogUtil.log(key: tag,content: 'closeWebSocket');
      wsStatus = WsStatus.closing;
      await _channel?.sink.close();
      wsStatus = WsStatus.closed;
      _oxWSStateObserver?.onDisconnect();
    }
  }

  Future<void> closeWS() async {
    if (reconnectFlag) {
      // LogUtil.log(key: tag,content: 'closeWS');
      await closeWebSocket();
      reconnectFlag = false;
    }
  }

  @override
  void onOpen(WebSocket webSocket, int state) {
    ///The ws connection status is updated
    refreshWsStatus(state);
    _oxWSStateObserver?.onConnect();

    ///After the first WS connection is successful, subscribe to the first cache information
    ///The subscription binding is automatically restored after each reconnection
    if (_channelMap.isNotEmpty) {
      for (OXWSChannel channel in _channelMap.values) {
        sendMessage(channel);
      }
    }
  }

  @override
  void onMessage(data) {
    Map<String, dynamic> map = {};
    if (data.runtimeType == String) {
      map = jsonDecode(data);
      LogUtil.log(key: tag, content: 'onMessage(String):' + map.toString());
      // print("********* **** object $map");
    } else if (data.runtimeType.toString() == '_Uint8ArrayView') {
      Uint8List bytes = Uint8List.fromList(data);
      var gzipBytes = GZipDecoder().decodeBytes(bytes);
      String str = utf8.decode(gzipBytes);
      map = jsonDecode(str);
      //  print("*******  data map $map");
      // LogUtil.log(key: tag,content: 'onMessage(_Uint8ArrayView):' + map.toString());
    }

    _oxWSStateObserver?.onReceiveData(map);

    ///Same message format, same channel, different observers sending messages
    for (int i = 0; i < _responseList.length; i++) {

      OXWSResponse response = _responseList[i];
      if (response.isMatchStyle(map)) {
        OXWSResponse oxWSResponse = response.createResponse(map);
        List<OXWSDataObserver>? resultObserverList =
            _observerMap[oxWSResponse.channelName];
        if (resultObserverList != null && resultObserverList.length > 0) {
          resultObserverList.forEach((element) {
            element.onWebSocketMessage(oxWSResponse);
          });
        }
      }
    }
  }

  @override
  void onDone() {
    refreshWsStatus(WebSocket.closed);
    // LogUtil.log(key: tag,content: 'onDone:' + wsStatus.toString());
    if (reconnectFlag) {
      _oxWSStateObserver?.onReconnect();
    } else {
      // LogUtil.log(key: tag,content: 'onDone-ws Closed, no reconnection.');
      reconnectFlag = true;
    }
  }

  void removeAllChannel() {
    _channelMap.clear();
    _observerMap.clear();
  }

  @override
  void onError(String msg) {
    refreshWsStatus(WebSocket.closed);
    // LogUtil.log(key: tag,content: 'onError:' + wsStatus.toString());
    if (reconnectFlag) {
      _oxWSStateObserver?.onReconnect();
    } else {
      // LogUtil.log(key: tag,content: 'onError-ws Closed, no reconnection.');
      reconnectFlag = true;
    }
  }
}

abstract class OXWSResponse {
  String channelName = '';

  Map<String, dynamic> data = {};

  Map<String, dynamic> getData() => data;

  OXWSResponse createResponse(Map<String, dynamic> data);

  String getChannelName(Map<String, dynamic> data);

  bool isMatchStyle(Map<String, dynamic> data);
}

abstract class OXWSChannel {
  String channelName = '';
  Map<String, dynamic> channelData = {};

  Map<String, dynamic> getData() => channelData;

  void addData(Map<String, dynamic> data) {
    channelData.addAll(data);
  }

  OXWSResponse getOXWSResponse();

  OXWSChannel? withAddChannel(OXWSChannel newValue) => null;

  OXWSChannel? withRemoveChannel(OXWSChannel newValue) => null;

  OXWSChannel getAddEventChannel() => this;

  OXWSChannel getRemoveEventChannel() => this;
}
