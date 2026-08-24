
import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';

import 'log_util.dart';

typedef SendErrorFunction = Function(Object? data);
typedef MessageHandler = Function(dynamic data);
typedef MainMessageHandler = FutureOr Function(
    dynamic data, SendPort isolateSendPort);
typedef IsolateMessageHandler = FutureOr Function(
    dynamic data, SendPort mainSendPort, SendErrorFunction onSendError);

class IsolateWorker {

  static IsolateWorker cashuWorker = IsolateWorker();

  late Isolate _isolate;

  late ReceivePort _mainReceivePort;

  late SendPort _isolateSendPort;

  final RootIsolateToken? _rootIsolateToken = RootIsolateToken.instance;

  static Future<void> _isolateInitializer(SendPort sendPort) async {
    final isolateReceiverPort = ReceivePort();
    sendPort.send(isolateReceiverPort.sendPort);
    isolateReceiverPort.listen((message) async {
      if (message is List && message.length == 3) {
        final task = message[0] as Future Function();
        final replyPort = message[1] as SendPort;
        final rootIsolateToken = message[2] as RootIsolateToken;
        try {
          // Attach root isolate token to the current isolate
          BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
          final result = await task();
          replyPort.send(result);
        } catch (e, stackTrace) {
          LogUtils.e(() => '_isolateEntry Error: $e\n$stackTrace');
          replyPort.send(e);
        }
      }
    });
  }

  Future<IsolateWorker> init([String isolateName = '']) async {
    final completer = Completer<IsolateWorker>();

    _mainReceivePort = ReceivePort(isolateName);

    _isolate = await Isolate.spawn(
      _isolateInitializer,
      _mainReceivePort.sendPort,
    );

    _mainReceivePort.listen((message) async {
      if (message is SendPort) {
        _isolateSendPort = message;
        completer.complete(this);
      }
    });

    return completer.future;
  }

  void dispose({bool immediate = false}) {
    _mainReceivePort.close();
    _isolate.kill(
      priority: immediate ? Isolate.immediate : Isolate.beforeNextEvent,
    );
  }

  Future<T> run<T>(Future<T> Function() fn) {
    final completer = Completer<T>();
    final receivePort = ReceivePort();
    _isolateSendPort.send([
      fn,
      receivePort.sendPort,
      _rootIsolateToken,
    ]);
    receivePort.listen((message) {
      receivePort.close();
      if (message is T) {
        completer.complete(message);
      } else if (message is Exception) {
        throw message;
      } else {
        LogUtils.e(() => '[IsolateWorker - run] error type: ${message.runtimeType}, expect: $T');
      }
    });
    return completer.future;
  }
}
