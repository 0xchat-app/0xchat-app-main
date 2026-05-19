// Unit tests for the Namecoin script encoder/parser used by the
// ElectrumX `name_show` flow.

import 'dart:convert';

import 'package:chatcore/chat-core.dart'
    show buildNameIndexScript, electrumScriptHash, parseNameScript;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildNameIndexScript', () {
    test('produces OP_NAME_UPDATE <push(name)> <push()> OP_2DROP OP_DROP OP_RETURN',
        () {
      final script = buildNameIndexScript(utf8.encode('d/alice'));
      // 0x53 OP_NAME_UPDATE, 0x07 = len("d/alice"), then "d/alice",
      // 0x00 empty push, 0x6d OP_2DROP, 0x75 OP_DROP, 0x6a OP_RETURN.
      expect(script[0], 0x53);
      expect(script[1], 0x07);
      expect(utf8.decode(script.sublist(2, 9)), 'd/alice');
      expect(script[9], 0x00);
      expect(script[10], 0x6d);
      expect(script[11], 0x75);
      expect(script[12], 0x6a);
    });
  });

  group('electrumScriptHash', () {
    test('reverses the SHA-256 byte order, hex-encoded', () {
      final script = buildNameIndexScript(utf8.encode('d/mstrofnone'));
      final h = electrumScriptHash(script);
      // 64 hex chars (= 32 bytes), all lowercase hex.
      expect(h.length, 64);
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(h), isTrue);
    });

    test('different names produce different hashes', () {
      final h1 = electrumScriptHash(buildNameIndexScript(utf8.encode('d/a')));
      final h2 = electrumScriptHash(buildNameIndexScript(utf8.encode('d/b')));
      expect(h1, isNot(equals(h2)));
    });
  });

  group('parseNameScript', () {
    test('decodes a NAME_UPDATE script', () {
      // OP_3 + push("d/foo") + push("{}") + OP_2DROP + OP_DROP
      final script = <int>[
        0x53,
        0x05, ...utf8.encode('d/foo'),
        0x02, ...utf8.encode('{}'),
        0x6d, 0x75,
      ];
      final parsed = parseNameScript(script);
      expect(parsed, isNotNull);
      expect(parsed!.name, 'd/foo');
      expect(parsed.value, '{}');
    });

    test('decodes a NAME_FIRSTUPDATE script (skips the rand push)', () {
      // OP_2 + push("d/foo") + push(rand=8 bytes) + push("{}") + OP_2DROP + OP_2DROP
      final script = <int>[
        0x52,
        0x05, ...utf8.encode('d/foo'),
        0x08, 1, 2, 3, 4, 5, 6, 7, 8,
        0x02, ...utf8.encode('{}'),
        0x6d, 0x6d,
      ];
      final parsed = parseNameScript(script);
      expect(parsed, isNotNull);
      expect(parsed!.name, 'd/foo');
      expect(parsed.value, '{}');
    });

    test('returns null for non-name scripts', () {
      expect(parseNameScript([]), isNull);
      // P2PKH-style: OP_DUP OP_HASH160 ...
      expect(parseNameScript([0x76, 0xa9, 0x14, 0, 0, 0, 0]), isNull);
    });
  });
}
