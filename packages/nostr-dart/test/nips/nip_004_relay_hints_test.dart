import 'package:test/test.dart';

// Inline implementation of toTags for testing without Flutter dependencies
// This mirrors the logic in lib/src/nips/nip_004.dart
List<List<String>> toTagsTestImpl(String p, String q, String qPubkey, int? expiration,
    {List<String>? members, Map<String, String>? relayHints}) {
  List<List<String>> result = [];
  if (p.isNotEmpty) {
    String? hint = relayHints?[p];
    result.add(hint != null ? ["p", p, hint] : ["p", p]);
  }
  for (var m in members ?? []) {
    if (m != p) {
      String? hint = relayHints?[m];
      result.add(hint != null ? ["p", m, hint] : ["p", m]);
    }
  }
  if (q.isNotEmpty) result.add(["e", q, '']);
  if (expiration != null) result.add(['expiration', expiration.toString()]);
  return result;
}

void main() {
  group('toTagsTestImpl relay hints', () {
    test('creates p-tag without relay hint when relayHints is null', () {
      final tags = toTagsTestImpl('pubkey123', '', '', null);

      expect(tags.length, 1);
      expect(tags[0], ['p', 'pubkey123']);
    });

    test('creates p-tag without relay hint when relayHints is empty', () {
      final tags = toTagsTestImpl('pubkey123', '', '', null, relayHints: {});

      expect(tags.length, 1);
      expect(tags[0], ['p', 'pubkey123']);
    });

    test('creates p-tag with relay hint when available', () {
      final relayHints = {'pubkey123': 'wss://relay.example.com'};
      final tags = toTagsTestImpl('pubkey123', '', '', null, relayHints: relayHints);

      expect(tags.length, 1);
      expect(tags[0], ['p', 'pubkey123', 'wss://relay.example.com']);
    });

    test('creates p-tag without relay hint when pubkey not in relayHints', () {
      final relayHints = {'otherpubkey': 'wss://relay.example.com'};
      final tags = toTagsTestImpl('pubkey123', '', '', null, relayHints: relayHints);

      expect(tags.length, 1);
      expect(tags[0], ['p', 'pubkey123']);
    });

    test('handles multiple members with mixed relay hints', () {
      final relayHints = {
        'pubkey1': 'wss://relay1.com',
        'pubkey3': 'wss://relay3.com',
      };
      final tags = toTagsTestImpl(
        'pubkey1', '', '', null,
        members: ['pubkey2', 'pubkey3'],
        relayHints: relayHints,
      );

      expect(tags.length, 3);
      expect(tags[0], ['p', 'pubkey1', 'wss://relay1.com']); // has hint
      expect(tags[1], ['p', 'pubkey2']); // no hint
      expect(tags[2], ['p', 'pubkey3', 'wss://relay3.com']); // has hint
    });

    test('does not duplicate p-tag for member matching primary receiver', () {
      final relayHints = {'pubkey1': 'wss://relay1.com'};
      final tags = toTagsTestImpl(
        'pubkey1', '', '', null,
        members: ['pubkey1', 'pubkey2'],
        relayHints: relayHints,
      );

      expect(tags.length, 2);
      expect(tags[0], ['p', 'pubkey1', 'wss://relay1.com']);
      expect(tags[1], ['p', 'pubkey2']);
    });

    test('includes e-tag for replies', () {
      final tags = toTagsTestImpl('pubkey1', 'eventid123', '', null);

      expect(tags.length, 2);
      expect(tags[0], ['p', 'pubkey1']);
      expect(tags[1], ['e', 'eventid123', '']);
    });

    test('includes expiration tag when provided', () {
      final tags = toTagsTestImpl('pubkey1', '', '', 1234567890);

      expect(tags.length, 2);
      expect(tags[0], ['p', 'pubkey1']);
      expect(tags[1], ['expiration', '1234567890']);
    });
  });
}
