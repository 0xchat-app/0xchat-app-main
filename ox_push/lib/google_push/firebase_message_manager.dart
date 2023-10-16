import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/ox_call_keep_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:firebase_core/firebase_core.dart';



@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  LogUtil.e('Push: background receive msg message =${message.toString()}');
  LogUtil.e('Push: background receive msg body =${message.notification?.body??'null body'}');
  await FirebaseMessageManager.initFirebase();
  showFlutterNotification(message);
  // String uuid_v4 = await OXCacheManager.defaultOXCacheManager.getData('uuid_v4', defaultValue: '');
  // LogUtil.e('Michael: uuid_v4 =${uuid_v4}');/// Michael: OXCalllKeepManager.instance.uuid.v4() =5374ec5d-d47a-47ec-8345-135a0a1cc9e2
  // OXCalllKeepManager.displayIncomingCall(uuid_v4);
}

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

AndroidNotificationChannel? channel;

void showFlutterNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    LogUtil.e('Michael:showFlutterNotification ---flutterLocalNotificationsPlugin =${flutterLocalNotificationsPlugin}');
    if (flutterLocalNotificationsPlugin == null){
      await FirebaseMessageManager.instance.initFlutterLocalNotificationsPlugin();
    }
    LogUtil.e('Michael:showFlutterNotification ---flutterLocalNotificationsPlugin =${flutterLocalNotificationsPlugin}； body =${notification.body}');
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
    LogUtil.e('Push: Push _init = ${OXCalllKeepManager.uuid}');
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
  }

  //background
  void onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

}
