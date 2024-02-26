
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_module_service/ox_module_service.dart';

const EventChannel ChatEventChannel = const EventChannel('oxchat_event_channel');

const String CODE_SHARE_NEW_MSG_TO_CHAT = "shareNewMessageToChat";

class ChatMainEventChanel {
  factory ChatMainEventChanel() {
    return instance;
  }

  ChatMainEventChanel._internal() {
    ChatEventChannel.receiveBroadcastStream()
        .listen(_onEvent, onError: _onError);
  }

  static final ChatMainEventChanel instance = new ChatMainEventChanel._internal();


  setup(){

  }

  void _onEvent(dynamic event) {
    final Map<dynamic, dynamic> eventMap = event;
    LogUtil.e("Michael: ---eventMap[type] =" + eventMap["type"]);
    if (eventMap['type'] == CODE_SHARE_NEW_MSG_TO_CHAT) {
      String shareUrl = eventMap['data'];
      handleShareNewMessageToChat(shareUrl);
    }
  }

  void _onError(Object event) {}


  void handleShareNewMessageToChat(String shareUrl) {
    OXModuleService.pushPage(OXNavigator.navigatorKey.currentContext!, 'ox_chat', 'ChatChooseSharePage', {
      'url': shareUrl,
    });
  }
}
