
import 'dart:async';

import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

enum _MessageType {
  private,
  secret,
  channel,
}

class AppInitializationManager with OXChatObserver {

  static final AppInitializationManager shared = AppInitializationManager._internal();

  AppInitializationManager._internal();

  var _messageFinishFlags = {
    _MessageType.private: false,
    _MessageType.secret: false,
    _MessageType.channel: false,
  };

  bool get isReceiveMessageFinish => _messageFinishFlags.values.every((v) => v);

  bool isDismissLoading = true;

  Completer<bool> shouldShowLoadingCompleter = Completer();

  void setup() {
    OXChatBinding.sharedInstance.addObserver(this);
  }

  void reset() {
    setDefaultValue();
  }
  
  void setDefaultValue() {
    _messageFinishFlags = _messageFinishFlags.map((key, value) => MapEntry(key, false));
    isDismissLoading = true;
    shouldShowLoadingCompleter = Completer();
  }

  @override
  void didOfflinePrivateMessageFinishCallBack() {
    _offlineMessageFinishHandler(_MessageType.private);
  }

  @override
  void didOfflineSecretMessageFinishCallBack() {
    _offlineMessageFinishHandler(_MessageType.secret);
  }

  @override
  void didOfflineChannelMessageFinishCallBack() {
    _offlineMessageFinishHandler(_MessageType.channel);
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
    return ;
    await OXLoading.initComplete;
    final shouldShowLoading = await shouldShowLoadingCompleter.future;
    if (!shouldShowLoading) return ;
    if (isReceiveMessageFinish) return ;
    isDismissLoading = false;
    OXLoading.show(maskType: EasyLoadingMaskType.black);
    Future.delayed(const Duration(minutes: 1), () {
      if (!isDismissLoading) {
        _dismissInitializationLoading();
      }
    });
  }

  void tryDismissInitializationLoading() {
    if (isReceiveMessageFinish && !isDismissLoading) {
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