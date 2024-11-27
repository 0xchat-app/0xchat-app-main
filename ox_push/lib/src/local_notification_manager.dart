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

AndroidNotificationChannel? messageChannel;
AndroidNotificationChannel? callChannel;

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
    initAndroidNotificationMsgChannel();
    initAndroidNotificationCallChannel();

    await flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(messageChannel!);
    await flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(callChannel!);
  }

  void initAndroidNotificationMsgChannel() {
    messageChannel = AndroidNotificationChannel(
      '10000',
      'Chat Notification',
      description: 'This Channel is 0xchat App Chat push notification',
      importance: Importance.high,
    );
  }

  void initAndroidNotificationCallChannel() {
    callChannel = const AndroidNotificationChannel(
      '10001',
      'Call Notifications',
      description: 'This channel is used for call invitations',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('classiccalling'),
      playSound: true,
      enableVibration: true,
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    LogUtil.e('Push: Notification Clicked with payload: $payload');
    openAppByClick();
  }

  Future<void> onNewEndpoint(String endpoint, String instance) async {
    LogUtil.e('Jeff: ---onNewEndpoint---instance =$instance； endpoint =$endpoint');
    await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageSettingKey.KEY_PUSH_TOKEN.name, endpoint);
    OXUserInfoManager.sharedInstance.setNotification();
  }

  void onMessage(Uint8List message, String instance) async {
    int notificationID = message.hashCode;
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

    if (msgType == PushMsgType.call.text) {
      showLocalNotification(notificationID, showTitle, showContent, isCall: true);
    } else {
      showLocalNotification(notificationID, showTitle, showContent);
    }
  }

  void showLocalNotification(int notificationID, String showTitle, String showContent, {bool isCall = false}) async {
    if (flutterLocalNotificationsPlugin == null) await LocalNotificationManager.instance.initFlutterLocalNotificationsPlugin();
    if (messageChannel == null) LocalNotificationManager.instance.initAndroidNotificationMsgChannel();
    if (callChannel == null) LocalNotificationManager.instance.initAndroidNotificationCallChannel();
    flutterLocalNotificationsPlugin?.show(
      notificationID,
      showTitle,
      showContent,
      NotificationDetails(
        android: isCall ? AndroidNotificationDetails(
          callChannel?.id ?? '',
          callChannel?.name ?? '',
          channelDescription: callChannel?.description ?? '',
          importance: Importance.max,
          priority: Priority.high,
          sound: const RawResourceAndroidNotificationSound('classiccalling'),
          fullScreenIntent: true,
        ) : AndroidNotificationDetails(
          messageChannel?.id ?? '',
          messageChannel?.name ?? '',
          channelDescription: messageChannel?.description ?? '',
          icon: '@mipmap/ic_notification',
        ),
      ),
    );
  }
}
