
import 'common_constant_interface.dart';

class OXConstantImpl implements ConstantInterface {

  const OXConstantImpl();

  ///db version
  final int dbVersion = 1;

  /// 0xchat relay
  final String oxChatRelay = '';

  /// Aliyun OSS EndPoint
  final String ossEndPoint = '';

  /// Aliyun OSS BucketName
  final String ossBucketName = '';

  final String serverPubkey = '';
  final String serverSignKey = '';

  /// nprofile: (0)User QRCode；
  final int qrCodeUser = 0;
  ///nevent: (1) Channel QRCode;
  final int qrCodeChannel = 1;

  final String baseUrl = '';

  /// ios Bundle id
  final bundleId = '';

  /// Push Notifications
  final int NOTIFICATION_PUSH_NOTIFICATIONS = 0;
  /// Private Messages
  final int NOTIFICATION_PRIVATE_MESSAGES = 1;
  /// Channels
  final int NOTIFICATION_CHANNELS = 2;
  /// Zaps
  final int NOTIFICATION_ZAPS = 3;

  final String giphyApiKey = '';
}
