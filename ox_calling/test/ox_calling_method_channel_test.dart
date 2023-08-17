import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ox_calling/ox_calling_method_channel.dart';

void main() {
  MethodChannelOxCalling platform = MethodChannelOxCalling();
  const MethodChannel channel = MethodChannel('ox_calling');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
