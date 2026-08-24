import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCashuDartPlatform
    with MockPlatformInterfaceMixin {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  // final CashuDartPlatform initialPlatform = CashuDartPlatform.instance;
  //
  // test('$MethodChannelCashuDart is the default instance', () {
  //   expect(initialPlatform, isInstanceOf<MethodChannelCashuDart>());
  // });
  //
  // test('getPlatformVersion', () async {
  //   CashuDart cashuDartPlugin = CashuDart();
  //   MockCashuDartPlatform fakePlatform = MockCashuDartPlatform();
  //   CashuDartPlatform.instance = fakePlatform;
  //
  //   expect(await cashuDartPlugin.getPlatformVersion(), '42');
  // });
}
