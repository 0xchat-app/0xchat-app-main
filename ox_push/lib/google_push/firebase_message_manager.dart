import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:firebase_core/firebase_core.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  LogUtil.e('Push: background receive msg');
  await FirebaseMessageManager.initFirebase();
  FirebaseMessageManager.instance;
  showFlutterNotification(message);
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

late AndroidNotificationChannel channel;

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
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
    initMessage();
    onBackgroundMessage();
    LogUtil.e('Push: Push _init');
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
    
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }


  void initMessage() {
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  //background
  void onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
