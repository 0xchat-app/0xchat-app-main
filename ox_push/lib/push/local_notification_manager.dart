import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';

enum PushMsgType{
  call,
  other
}

extension PushMsgTypeEx on PushMsgType {
  String get text {
    switch (this) {
      case PushMsgType.call:
        return '1';
      case PushMsgType.other:
        return '0';
      default:
        return 'unknow';
    }
  }
}


FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

AndroidNotificationChannel? channel;

void openAppByClick() {
  LogUtil.e('Push: background -openAppByClick--');
  PromptToneManager.sharedInstance.stopPlay();
}

class LocalNotificationManager {

  static LocalNotificationManager get instance => _instance;

  static final LocalNotificationManager _instance = LocalNotificationManager._init();

  LocalNotificationManager._init(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    initFlutterLocalNotificationsPlugin();
  }

  Future<void> initFlutterLocalNotificationsPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ox_logo_launcher");
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin?.initialize(initializationSettings);
    channel = AndroidNotificationChannel(
      '10000',
      'Chat Notification',
      description: 'This Channel is 0xchat App Chat push notification',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel!);
  }

  Future<void> onNewEndpoint(String endpoint, String instance) async {
    LogUtil.d("John: --LocalNotificationManager--OnNewEndpoint----instance =${instance}---endpoint =${endpoint}");
    if (instance == 'com.oxchat.nostr') {
      Uri uri = Uri.parse(endpoint);
      String? fcmToken = uri.queryParameters['token'];
      LogUtil.d("John: --LocalNotificationManager--OnNewEndpoint----fcmToken =${fcmToken}");
      await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUSH_TOKEN, fcmToken);
      OXUserInfoManager.sharedInstance.setNotification();
      LogUtil.e('Push: PushToken: $fcmToken');
    }
  }


  void onMessage(Uint8List message, String instance) async {
    String result = '';
    try {
      result = utf8.decode(message);
    } catch (e) {
      print(e.toString());
    }
    LogUtil.d("John: --LocalNotificationManager--onMessage----message result=${result}");
    if (flutterLocalNotificationsPlugin == null) await LocalNotificationManager.instance.initFlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.show(
      0,//notification.hashCode, notificationID
      'title',
      'content',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel?.id ?? '',
          channel?.name ?? '',
          channelDescription: '',
          icon: '@mipmap/ic_notification',
        ),
      ),
    );

  }
}
