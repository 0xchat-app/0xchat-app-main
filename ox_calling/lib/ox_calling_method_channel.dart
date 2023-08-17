import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ox_calling_platform_interface.dart';

/// An implementation of [OxCallingPlatform] that uses method channels.
class MethodChannelOxCalling extends OxCallingPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ox_calling');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> setSpeakerStatus(bool isSpeakerOn) async {
    final setResult = await methodChannel.invokeMethod<bool>('setSpeakerStatus', {'isSpeakerOn' :  isSpeakerOn}) ?? false;
    return setResult;
  }
}
