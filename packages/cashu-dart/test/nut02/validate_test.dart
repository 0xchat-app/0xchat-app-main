import 'package:cashu_dart/core/nuts/v1/nut_02.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Nut2.isHexKeysetId', () {
    test('accepts valid V1 keyset id (16 hex chars, prefix 00)', () {
      expect(Nut2.isHexKeysetId('009a1f293253e41e'), isTrue);
      expect(Nut2.isKeysetIdV2('009a1f293253e41e'), isFalse);
    });

    test('accepts valid V2 keyset id (66 hex chars, prefix 01)', () {
      const v2Id =
          '015ba18a8adcd02e715a58358eb618da4a4b3791151a4bee5e968bb88406ccf76a';
      expect(Nut2.isHexKeysetId(v2Id), isTrue);
      expect(Nut2.isKeysetIdV2(v2Id), isTrue);
    });

    test('rejects empty string', () {
      expect(Nut2.isHexKeysetId(''), isFalse);
      expect(Nut2.isKeysetIdV2(''), isFalse);
    });

    test('rejects non-hex character in id', () {
      expect(Nut2.isHexKeysetId('009a1f293253e41g'), isFalse);
      expect(Nut2.isHexKeysetId('01' + 'f' * 63 + 'z'), isFalse);
    });

    test('rejects wrong length (not 16 or 66)', () {
      expect(Nut2.isHexKeysetId('009a1f293253e41'), isFalse);
      expect(Nut2.isHexKeysetId('009a1f293253e41ef'), isFalse);
      expect(Nut2.isHexKeysetId('01' + 'a' * 63), isFalse);
      expect(Nut2.isHexKeysetId('01' + 'a' * 65), isFalse);
    });

    test('rejects wrong version prefix', () {
      expect(Nut2.isHexKeysetId('019a1f293253e41e'), isFalse);
      expect(Nut2.isHexKeysetId('00' + 'a' * 64), isFalse);
    });
  });
}
