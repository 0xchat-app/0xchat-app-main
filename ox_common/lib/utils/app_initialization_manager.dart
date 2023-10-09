
import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

enum _MessageType {
  private,
  secret,
  channel,
}

class AppInitializationManager {

  static final AppInitializationManager shared = AppInitializationManager._internal();

  AppInitializationManager._internal();

  var _messageFinishFlags = {
    _MessageType.private: false,
    _MessageType.secret: false,
    _MessageType.channel: false,
  };

  bool get isReceiveMessageFinish => _messageFinishFlags.values.every((v) => v);

  bool isDismissLoading = false;

  Completer<bool> shouldShowLoadingCompleter = Completer();

  void setup() {
    Contacts.sharedInstance.offlinePrivateMessageFinishCallBack =
        () => _offlineMessageFinishHandler(_MessageType.private);
    Contacts.sharedInstance.offlineSecretMessageFinishCallBack =
        () => _offlineMessageFinishHandler(_MessageType.secret);
    Channels.sharedInstance.offlineChannelMessageFinishCallBack =
        () => _offlineMessageFinishHandler(_MessageType.channel);
  }

  void reset() {
    setDefaultValue();
  }
  
  void setDefaultValue() {
    _messageFinishFlags = _messageFinishFlags.map((key, value) => MapEntry(key, false));
    isDismissLoading = false;
    shouldShowLoadingCompleter = Completer();
  }

  set shouldShowInitializationLoading(bool value) {
    if (!shouldShowLoadingCompleter.isCompleted) {
      shouldShowLoadingCompleter.complete(value);
    } else {
      shouldShowLoadingCompleter = Completer();
      shouldShowLoadingCompleter.complete(value);
    }
  }

  void showInitializationLoading() async {
    await OXLoading.initComplete;
    final shouldShowLoading = await shouldShowLoadingCompleter.future;
    if (!shouldShowLoading) return ;
    if (isReceiveMessageFinish) return ;
    OXLoading.show(maskType: EasyLoadingMaskType.black);
    Future.delayed(const Duration(minutes: 1), () {
      if (!isDismissLoading) {
        _dismissInitializationLoading();
      }
    });
  }

  void tryDismissInitializationLoading() {
    if (isReceiveMessageFinish) {
      _dismissInitializationLoading();
    }
  }

  void _dismissInitializationLoading() {
    isDismissLoading = true;
    OXLoading.dismiss();
  }

  void _offlineMessageFinishHandler(_MessageType type) {
    _messageFinishFlags[type] = true;
    tryDismissInitializationLoading();
  }
}