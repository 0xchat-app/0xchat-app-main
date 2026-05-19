// Unit tests for the Namecoin `.bit` identifier parser used by the
// `.bit` NIP-05 verification branch added to 0xchat-core.

import 'package:chatcore/chat-core.dart'
    show isBitIdentifier, isBitDomain, parseNamecoinIdentifier;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isBitIdentifier', () {
    test('matches plain .bit, user@.bit, d/, id/', () {
      expect(isBitIdentifier('alice.bit'), isTrue);
      expect(isBitIdentifier('alice@example.bit'), isTrue);
      expect(isBitIdentifier('Alice@Example.BIT'), isTrue);
      expect(isBitIdentifier('d/alice'), isTrue);
      expect(isBitIdentifier('id/alice'), isTrue);
      expect(isBitIdentifier('nostr:alice@example.bit'), isTrue);
    });

    test('rejects DNS-only identifiers and empties', () {
      expect(isBitIdentifier(null), isFalse);
      expect(isBitIdentifier(''), isFalse);
      expect(isBitIdentifier('alice@example.com'), isFalse);
      expect(isBitIdentifier('example.com'), isFalse);
    });
  });

  group('isBitDomain', () {
    test('only the domain part needs to end in .bit', () {
      expect(isBitDomain('example.bit'), isTrue);
      expect(isBitDomain('Example.BIT'), isTrue);
      expect(isBitDomain('example.com'), isFalse);
      expect(isBitDomain(null), isFalse);
      expect(isBitDomain(''), isFalse);
    });
  });

  group('parseNamecoinIdentifier', () {
    test('parses bare <name>.bit as d/<name> with localpart _', () {
      final r = parseNamecoinIdentifier('mstrofnone.bit')!;
      expect(r.namecoinName, 'd/mstrofnone');
      expect(r.localPart, '_');
      expect(r.isDomain, isTrue);
    });

    test('parses alice@example.bit', () {
      final r = parseNamecoinIdentifier('Alice@Example.bit')!;
      expect(r.namecoinName, 'd/example');
      expect(r.localPart, 'alice');
      expect(r.isDomain, isTrue);
    });

    test('parses d/<name> verbatim', () {
      final r = parseNamecoinIdentifier('d/mstrofnone')!;
      expect(r.namecoinName, 'd/mstrofnone');
      expect(r.localPart, '_');
      expect(r.isDomain, isTrue);
    });

    test('parses id/<name> as identity namespace', () {
      final r = parseNamecoinIdentifier('id/alice')!;
      expect(r.namecoinName, 'id/alice');
      expect(r.isDomain, isFalse);
    });

    test('strips an optional nostr: URI prefix', () {
      final r = parseNamecoinIdentifier('nostr:alice@example.bit')!;
      expect(r.namecoinName, 'd/example');
      expect(r.localPart, 'alice');
    });

    test('returns null for non-Namecoin identifiers', () {
      expect(parseNamecoinIdentifier('alice@example.com'), isNull);
      expect(parseNamecoinIdentifier(''), isNull);
      expect(parseNamecoinIdentifier('@.bit'), isNull);
    });
  });
}
