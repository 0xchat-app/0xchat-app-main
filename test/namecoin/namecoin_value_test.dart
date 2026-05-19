// Unit tests for the Namecoin name-value JSON extractor.
//
// Covers the three `nostr` value shapes documented in the `.bit`
// NIP-05 draft plus minimal `import` walking per ifa-0001.

import 'package:chatcore/chat-core.dart'
    show parseNamecoinIdentifier, extractNostrFromValue;
import 'package:flutter_test/flutter_test.dart';

const String _pkA =
    '43185edecb675892824b1a37a57f3e407fbde2eda7201a3829b8cf4ba7c5b4f0';
const String _pkB =
    '0000000000000000000000000000000000000000000000000000000000000001';

void main() {
  group('extractNostrFromValue (simple form)', () {
    test('simple "nostr": "hex" resolves the root', () async {
      final parsed = parseNamecoinIdentifier('alice.bit')!;
      final entry = await extractNostrFromValue(
        '{"nostr":"$_pkA"}',
        parsed,
      );
      expect(entry, isNotNull);
      expect(entry!.pubkey, _pkA);
      expect(entry.relays, isEmpty);
    });

    test('simple form refuses non-root localparts', () async {
      final parsed = parseNamecoinIdentifier('bob@example.bit')!;
      final entry = await extractNostrFromValue(
        '{"nostr":"$_pkA"}',
        parsed,
      );
      expect(entry, isNull);
    });
  });

  group('extractNostrFromValue (names map)', () {
    test('picks the exact localpart from `names`', () async {
      final parsed = parseNamecoinIdentifier('bob@example.bit')!;
      final entry = await extractNostrFromValue(
        '{"nostr":{"names":{"bob":"$_pkA","alice":"$_pkB"}}}',
        parsed,
      );
      expect(entry!.pubkey, _pkA);
    });

    test('returns relays keyed by the matched pubkey', () async {
      final parsed = parseNamecoinIdentifier('bob@example.bit')!;
      final entry = await extractNostrFromValue(
        '{"nostr":{"names":{"bob":"$_pkA"},"relays":{"$_pkA":["wss://r1","wss://r2"]}}}',
        parsed,
      );
      expect(entry!.pubkey, _pkA);
      expect(entry.relays, ['wss://r1', 'wss://r2']);
    });

    test('falls back to `_` for the root', () async {
      final parsed = parseNamecoinIdentifier('example.bit')!;
      final entry = await extractNostrFromValue(
        '{"nostr":{"names":{"_":"$_pkA"}}}',
        parsed,
      );
      expect(entry!.pubkey, _pkA);
    });

    test('returns null when localpart is missing', () async {
      final parsed = parseNamecoinIdentifier('eve@example.bit')!;
      final entry = await extractNostrFromValue(
        '{"nostr":{"names":{"bob":"$_pkA"}}}',
        parsed,
      );
      expect(entry, isNull);
    });

    test('refuses to fall back to root when localpart is present but malformed',
        () async {
      // Anti-leak rule: when `names["alice"]` is present but does not
      // hold a valid pubkey, return null instead of silently handing
      // out the root operator's identity.
      final parsed = parseNamecoinIdentifier('alice@example.bit')!;
      final entry = await extractNostrFromValue(
        '{"nostr":{"names":{"alice":"not-hex","_":"$_pkA"}}}',
        parsed,
      );
      expect(entry, isNull);
    });
  });

  group('extractNostrFromValue (single-identity form)', () {
    test('`{ "pubkey": "hex", "relays": [...] }` resolves the root',
        () async {
      final parsed = parseNamecoinIdentifier('mstrofnone.bit')!;
      final entry = await extractNostrFromValue(
        '{"nostr":{"pubkey":"$_pkA","relays":["wss://relay.example/"]}}',
        parsed,
      );
      expect(entry!.pubkey, _pkA);
      expect(entry.relays, ['wss://relay.example/']);
    });
  });

  group('extractNostrFromValue (id/ namespace)', () {
    test('`id/<name>` returns the canonical pubkey field', () async {
      final parsed = parseNamecoinIdentifier('id/alice')!;
      final entry = await extractNostrFromValue(
        '{"nostr":{"pubkey":"$_pkA"}}',
        parsed,
      );
      expect(entry!.pubkey, _pkA);
    });
  });

  group('extractNostrFromValue (malformed)', () {
    test('returns null on malformed JSON', () async {
      final parsed = parseNamecoinIdentifier('alice.bit')!;
      expect(await extractNostrFromValue('not-json', parsed), isNull);
    });

    test('returns null when no `nostr` field is present', () async {
      final parsed = parseNamecoinIdentifier('alice.bit')!;
      expect(await extractNostrFromValue('{}', parsed), isNull);
    });

    test('returns null on non-hex pubkey', () async {
      final parsed = parseNamecoinIdentifier('alice.bit')!;
      expect(
        await extractNostrFromValue('{"nostr":"not-a-pubkey"}', parsed),
        isNull,
      );
    });
  });

  group('extractNostrFromValue (import walking)', () {
    test('walks `import` and merges the imported record', () async {
      final parsed = parseNamecoinIdentifier('alice.bit')!;
      Future<String?> fetcher(String name) async {
        if (name == 'd/parent') return '{"nostr":"$_pkA"}';
        return null;
      }

      final entry = await extractNostrFromValue(
        '{"import":"d/parent"}',
        parsed,
        fetcher: fetcher,
      );
      expect(entry!.pubkey, _pkA);
    });

    test('importing object overrides imported one', () async {
      final parsed = parseNamecoinIdentifier('alice.bit')!;
      Future<String?> fetcher(String name) async {
        if (name == 'd/parent') return '{"nostr":"$_pkA"}';
        return null;
      }

      final entry = await extractNostrFromValue(
        '{"import":"d/parent","nostr":"$_pkB"}',
        parsed,
        fetcher: fetcher,
      );
      expect(entry!.pubkey, _pkB);
    });
  });
}
