import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  // showFlutterNotification(message);
  if (message.data.isNotEmpty) {
    String msgType = message.data['msgType'];
    if (msgType == PushMsgType.call.text) {
      PromptToneManager.sharedInstance.playCalling();
      Future.delayed(Duration(seconds: 10), () {
        PromptToneManager.sharedInstance.stopPlay();
      });
    }
  }
}

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

AndroidNotificationChannel? channel;

void openAppByClick(RemoteMessage message) {
  LogUtil.e('Push: background -openAppByClick--');
  PromptToneManager.sharedInstance.stopPlay();
}

void showFlutterNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    if (flutterLocalNotificationsPlugin == null)
      await FirebaseMessageManager.instance.initFlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.show(
      notification.hashCode,
      notification.title,
      notification.body,
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

class FirebaseMessageManager {

  static Future<void> initFirebase() async {
    await Firebase.initializeApp();
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    await FirebaseCrashlytics.instance.recordError(
        'error',
        null,
        reason: 'a fatal error',
        // Pass in 'fatal' argument
        fatal: true
    );
  }

  static FirebaseMessageManager get instance => _instance;

  static final FirebaseMessageManager _instance = FirebaseMessageManager._init();

  late FirebaseMessaging messaging;

  FirebaseMessageManager._init(){
    messaging = FirebaseMessaging.instance;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initFlutterLocalNotificationsPlugin();
    requestPermission();
    setToken();
  }

  void loadListener(){
    initMessage();
    onBackgroundMessage();
  }

  Future<void> setToken() async {
    String? fcmToken = await messaging.getToken();
    await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUSH_TOKEN, fcmToken);
    OXUserInfoManager.sharedInstance.setNotification();
    LogUtil.e('Push: PushToken: $fcmToken');
  }

  //Android 13.0  req Permission
  Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    LogUtil.e('Push: auth permission :${settings.authorizationStatus}');
  }

  Future<void> initFlutterLocalNotificationsPlugin() async {
    channel = AndroidNotificationChannel(
      '10000',
      'Chat Notification',
      description: 'This Channel is 0xchat App Chat push notification',
      importance: Importance.high,
    );
    
    await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel!);
  }


  void initMessage() {
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(openAppByClick);
  }

  //background
  void onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

}
