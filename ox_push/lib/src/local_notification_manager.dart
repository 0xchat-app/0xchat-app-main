import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';

enum PushMsgType { call, other }

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

  LocalNotificationManager._init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    initFlutterLocalNotificationsPlugin();
  }

  Future<void> initFlutterLocalNotificationsPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ox_logo_launcher");
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin?.initialize(initializationSettings);
    channel = AndroidNotificationChannel(
      '10000',
      'Chat Notification',
      description: 'This Channel is 0xchat App Chat push notification',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    LogUtil.e('Push: Notification Clicked with payload: $payload');
    openAppByClick();
  }

  Future<void> onNewEndpoint(String endpoint, String instance) async {
    await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUSH_TOKEN, endpoint);
    OXUserInfoManager.sharedInstance.setNotification();
  }

  void onMessage(Uint8List message, String instance) async {
    int notificationID = 0;
    String showTitle = '';
    String showContent = '';
    String msgType = '0';
    try {
      String result = utf8.decode(message);
      LogUtil.d("Push: LocalNotificationManager--onMessage--result=${result}");
      Map<String, dynamic> jsonMap = json.decode(result);
      notificationID = jsonMap.hashCode;
      showTitle = jsonMap['notification']?['title'] ?? '';
      showContent = jsonMap['notification']?['body'] ?? 'default';
      msgType = jsonMap['data']?['msgType'] ?? '0';
    } catch (e) {
      showContent = 'You’ve received a message ';
      print(e.toString());
    }
    showLocalNotification(notificationID, showTitle, showContent);
    if (msgType == PushMsgType.call.text) {
      PromptToneManager.sharedInstance.playCalling();
      Future.delayed(const Duration(seconds: 10), () {
        PromptToneManager.sharedInstance.stopPlay();
      });
    }
  }

  void showLocalNotification(int notificationID, String showTitle, String showContent) async {
    if (flutterLocalNotificationsPlugin == null) await LocalNotificationManager.instance.initFlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.show(
      notificationID,
      showTitle,
      showContent,
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
