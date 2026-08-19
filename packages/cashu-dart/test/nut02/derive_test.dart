import 'package:cashu_dart/core/nuts/define.dart';
import 'package:cashu_dart/core/nuts/v1/nut_02.dart';
import 'package:flutter_test/flutter_test.dart';

/// Minimal valid secp256k1 compressed pubkey (66 hex chars) for deterministic tests.
const String _pubkey1 =
    '020000000000000000000000000000000000000000000000000000000000000001';
const String _pubkey2 =
    '020000000000000000000000000000000000000000000000000000000000000002';

MintKeys get _fixedKeys => {'1': _pubkey1, '2': _pubkey2};

void main() {
  group('Nut2.deriveKeysetIdV1', () {
    test('fixed keys produce fixed 16-char id with prefix 00', () {
      final id = Nut2.deriveKeysetIdV1(_fixedKeys);
      expect(id.length, 16);
      expect(id.startsWith('00'), isTrue);
      expect(Nut2.isHexKeysetId(id), isTrue);
      expect(Nut2.isKeysetIdV2(id), isFalse);
    });

    test('same keys produce same id (deterministic)', () {
      final id1 = Nut2.deriveKeysetIdV1(_fixedKeys);
      final id2 = Nut2.deriveKeysetIdV1(_fixedKeys);
      expect(id1, id2);
    });

    test('different key order does not change id (sorted by amount)', () {
      final keysReversed = {'2': _pubkey2, '1': _pubkey1};
      expect(
        Nut2.deriveKeysetIdV1(keysReversed),
        Nut2.deriveKeysetIdV1(_fixedKeys),
      );
    });
  });

  group('Nut2.deriveKeysetIdV2', () {
    test('fixed keys + unit produce fixed 66-char id with prefix 01', () {
      final id = Nut2.deriveKeysetIdV2(_fixedKeys, unit: 'sat');
      expect(id.length, 66);
      expect(id.startsWith('01'), isTrue);
      expect(Nut2.isHexKeysetId(id), isTrue);
      expect(Nut2.isKeysetIdV2(id), isTrue);
    });

    test('same inputs produce same id (deterministic)', () {
      final id1 = Nut2.deriveKeysetIdV2(_fixedKeys, unit: 'sat');
      final id2 = Nut2.deriveKeysetIdV2(_fixedKeys, unit: 'sat');
      expect(id1, id2);
    });

    test('fee=0 and fee=null both omit from preimage (same id)', () {
      final idNull = Nut2.deriveKeysetIdV2(
        _fixedKeys,
        unit: 'sat',
        inputFeePpk: null,
      );
      final idZero = Nut2.deriveKeysetIdV2(
        _fixedKeys,
        unit: 'sat',
        inputFeePpk: 0,
      );
      expect(idNull, idZero);
    });

    test('expiry=0 and expiry=null both omit from preimage (same id)', () {
      final idNull = Nut2.deriveKeysetIdV2(
        _fixedKeys,
        unit: 'sat',
        finalExpiry: null,
      );
      final idZero = Nut2.deriveKeysetIdV2(
        _fixedKeys,
        unit: 'sat',
        finalExpiry: 0,
      );
      expect(idNull, idZero);
    });

    test('different unit produces different id', () {
      final idSat = Nut2.deriveKeysetIdV2(_fixedKeys, unit: 'sat');
      final idUsd = Nut2.deriveKeysetIdV2(_fixedKeys, unit: 'usd');
      expect(idSat, isNot(idUsd));
    });

    test('non-zero fee and expiry change id', () {
      final idBase = Nut2.deriveKeysetIdV2(_fixedKeys, unit: 'sat');
      final idWithFee = Nut2.deriveKeysetIdV2(
        _fixedKeys,
        unit: 'sat',
        inputFeePpk: 100,
      );
      final idWithExpiry = Nut2.deriveKeysetIdV2(
        _fixedKeys,
        unit: 'sat',
        finalExpiry: 2059210353,
      );
      expect(idWithFee, isNot(idBase));
      expect(idWithExpiry, isNot(idBase));
      expect(idWithFee, isNot(idWithExpiry));
    });
  });
}
