import 'package:flutter_test/flutter_test.dart';
import 'package:ox_calling/ox_calling.dart';
import 'package:ox_calling/ox_calling_platform_interface.dart';
import 'package:ox_calling/ox_calling_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOxCallingPlatform
    with MockPlatformInterfaceMixin
    implements OxCallingPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> setSpeakerStatus(bool isSpeakerOn) {
    // TODO: implement setSpeakerStatus
    throw UnimplementedError();
  }
}

void main() {
  final OxCallingPlatform initialPlatform = OxCallingPlatform.instance;

  test('$MethodChannelOxCalling is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOxCalling>());
  });

  test('getPlatformVersion', () async {
    OxCalling oxCallingPlugin = OxCalling();
    MockOxCallingPlatform fakePlatform = MockOxCallingPlatform();
    OxCallingPlatform.instance = fakePlatform;

    expect(await oxCallingPlugin.getPlatformVersion(), '42');
  });
}
