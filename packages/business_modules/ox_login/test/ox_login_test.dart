import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ox_login/ox_login.dart';

void main() {
  const MethodChannel channel = MethodChannel('ox_login');

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
    expect(await OXLogin.platformVersion, '42');
  });
}
