import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ox_calling_method_channel.dart';

abstract class OxCallingPlatform extends PlatformInterface {
  /// Constructs a OxCallingPlatform.
  OxCallingPlatform() : super(token: _token);

  static final Object _token = Object();

  static OxCallingPlatform _instance = MethodChannelOxCalling();

  /// The default instance of [OxCallingPlatform] to use.
  ///
  /// Defaults to [MethodChannelOxCalling].
  static OxCallingPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OxCallingPlatform] when
  /// they register themselves.
  static set instance(OxCallingPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> setSpeakerStatus(bool isSpeakerOn) {
    throw UnimplementedError('setSpeakerStatus() has not been implemented.');
  }
}
