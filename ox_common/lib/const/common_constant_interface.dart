
abstract class ConstantInterface {
  ///db version
  int get dbVersion;

  /// 0xchat relay
  String get oxChatRelay;

  /// Aliyun OSS EndPoint
  String get ossEndPoint;

  /// Aliyun OSS BucketName
  String get ossBucketName;

  String get serverPubkey;
  String get serverSignKey;

  /// nprofile: (0)User QRCode；
  int get qrCodeUser;
  /// nevent: (1) Channel QRCode;
  int get qrCodeChannel;

  String get baseUrl;

  /// ios Bundle id
  String get bundleId;

  /// Push Notifications
  int get NOTIFICATION_PUSH_NOTIFICATIONS;
  /// Private Messages
  int get NOTIFICATION_PRIVATE_MESSAGES;
  /// Channels
  int get NOTIFICATION_CHANNELS;
  /// Zaps
  int get NOTIFICATION_ZAPS;

  /// Giphy API Key
  String get giphyApiKey;
}