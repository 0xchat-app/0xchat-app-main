
abstract class ConstantInterface {

  const ConstantInterface();

  ///db version
  int get dbVersion => 4;

  /// 0xchat relay
  String get oxChatRelay => 'wss://relay.0xchat.com';

  /// nprofile: (0)User QRCode；
  int get qrCodeUser => 0;
  /// nevent: (1) Channel QRCode;
  int get qrCodeChannel => 1;

  String get baseUrl => 'https://www.0xchat.com';

  /// Push Notifications
  int get NOTIFICATION_PUSH_NOTIFICATIONS => 0;
  /// Private Messages
  int get NOTIFICATION_PRIVATE_MESSAGES => 1;
  /// Channels
  int get NOTIFICATION_CHANNELS => 2;
  /// Zaps
  int get NOTIFICATION_ZAPS => 3;

  /// Aliyun OSS EndPoint
  String get ossEndPoint;

  /// Aliyun OSS BucketName
  String get ossBucketName;

  String get serverPubkey;
  String get serverSignKey;

  /// ios Bundle id
  String get bundleId;

  /// Giphy API Key
  String get giphyApiKey;
}