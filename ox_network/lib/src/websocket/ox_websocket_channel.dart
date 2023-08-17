// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:async/async.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ox_network/src/websocket/ox_sink_completer.dart';

abstract class OXWSConnectStateObserver {
  void onOpen(WebSocket webSocket, int state);
  void onMessage(dynamic data);
  void onDone();
  void onError(String msg);
}

/// A [WebSocketChannel] that communicates using a `dart:io` [WebSocket].
class OXWebSocketChannel extends StreamChannelMixin
    implements WebSocketChannel {
  /// The underlying `dart:io` [WebSocket].
  ///
  /// If the channel was constructed with [OXWebSocketChannel.connect], this is
  /// `null` until the [WebSocket.connect] future completes.
  WebSocket? _webSocket;

  @override
  String? get protocol => _webSocket?.protocol;

  @override
  int? get closeCode => _webSocket?.closeCode;

  @override
  String? get closeReason => _webSocket?.closeReason;

  @override
  final Stream stream;
  @override
  final WebSocketSink sink;

  /// The underlying [WebSocket], if this channel has connected.
  ///
  /// If the future returned from [WebSocket.connect] has not yet completed, or
  /// completed as an error, this will be null.
  WebSocket? get innerWebSocket => _webSocket;

  OXWSConnectStateObserver? _oxWSConnectStateObserver;

  addConnectStateObserver(OXWSConnectStateObserver? observer) {
    this._oxWSConnectStateObserver = observer;
  }

  removeConnectStateObserver() {
    this._oxWSConnectStateObserver = null;
  }

  /// Creates a new WebSocket connection.
  ///
  /// Connects to [url] using [WebSocket.connect] and returns a channel that can
  /// be used to communicate over the resulting socket. The [url] may be either
  /// a [String] or a [Uri]. The [protocols] and [headers] parameters are the
  /// same as [WebSocket.connect].
  ///
  /// [pingInterval] controls the interval for sending ping signals. If a ping
  /// message is not answered by a pong message from the peer, the WebSocket is
  /// assumed disconnected and the connection is closed with a `goingAway` code.
  /// When a ping signal is sent, the pong message must be received within
  /// [pingInterval]. It defaults to `null`, indicating that ping messages are
  /// disabled.
  ///
  /// If there's an error connecting, the channel's stream emits a
  /// [WebSocketChannelException] wrapping that error and then closes.
  factory OXWebSocketChannel.connect(
    OXWSConnectStateObserver observer,
    Object url, {
    Iterable<String>? protocols,
    Map<String, dynamic>? headers,
    Duration? pingInterval,
  }) {
    late OXWebSocketChannel channel;
    final sinkCompleter = WebSocketSinkCompleter();
    print("******* connect url $url");

    final stream = StreamCompleter.fromFuture(
      WebSocket.connect(
        url.toString(),
        headers: headers,
        protocols: protocols,
      ).then((webSocket) {
        webSocket.pingInterval = pingInterval;
        channel._webSocket = webSocket;
        sinkCompleter.setDestinationSink(_IOWebSocketSink(webSocket));
        channel.initObserverListener(channel, observer);
        channel._oxWSConnectStateObserver!
            .onOpen(webSocket, webSocket.readyState);
        return webSocket;
      }).catchError(
        (Object error) {
          channel.initObserverListener(channel, observer);
          throw WebSocketChannelException.from(error);
        },
      ),
    );
    channel = OXWebSocketChannel._withoutSocket(stream, sinkCompleter.sink);
    return channel;
  }

  void initObserverListener(
      OXWebSocketChannel channel, OXWSConnectStateObserver observer) {
    channel.addConnectStateObserver(observer);
    channel.stream.listen(channel._oxWSConnectStateObserver!.onMessage,
        onDone: () {
      channel._oxWSConnectStateObserver!.onDone();
    }, onError: (error) {
      channel._oxWSConnectStateObserver!.onError(error.toString());
    }, cancelOnError: true);
  }

  /// Creates a channel wrapping [socket].
  OXWebSocketChannel(WebSocket socket)
      : _webSocket = socket,
        stream = socket.handleError(
            (error) => throw WebSocketChannelException.from(error)),
        sink = _IOWebSocketSink(socket);

  /// Creates a channel without a socket.
  ///
  /// This is used with `connect` to synchronously provide a channel that later
  /// has a socket added.
  OXWebSocketChannel._withoutSocket(Stream stream, this.sink)
      : _webSocket = null,
        stream = stream.handleError(
            (error) => throw WebSocketChannelException.from(error));

  @override
  // TODO: implement ready
  Future<void> get ready => throw UnimplementedError();
}

/// A [WebSocketSink] that forwards [close] calls to a `dart:io` [WebSocket].
class _IOWebSocketSink extends DelegatingStreamSink implements WebSocketSink {
  /// The underlying socket.
  final WebSocket _webSocket;

  _IOWebSocketSink(WebSocket webSocket)
      : _webSocket = webSocket,
        super(webSocket);

  @override
  Future close([int? closeCode, String? closeReason]) =>
      _webSocket.close(closeCode, closeReason);
}
