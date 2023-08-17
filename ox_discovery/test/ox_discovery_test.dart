import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ox_discovery/ox_discovery.dart';


void main() {
  const MethodChannel channel = MethodChannel('ox_discovery');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
