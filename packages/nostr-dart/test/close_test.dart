import 'package:nostr_core_dart/nostr.dart';
import 'package:test/test.dart';

void main() {
  group('Close', () {
    test('Constructor', () {
      String subscriptionId = generate64RandomHexChars();
      var close = Close(subscriptionId);
      expect(close.subscriptionId, subscriptionId);
    });

    test('Close.serialize', () {
      String subscriptionId = generate64RandomHexChars();
      String serialized = '["CLOSE","$subscriptionId"]';
      var close = Close(subscriptionId);
      expect(close.serialize(), serialized);
    });

    test('Request.deserialize', () {
      String subscriptionId = generate64RandomHexChars();
      var serialized = ["CLOSE", subscriptionId];
      var close = Close.deserialize(serialized);
      expect(close.subscriptionId, subscriptionId);
    });
  });
}
