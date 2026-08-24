import 'dart:convert';
import 'dart:io';

import 'package:cashu_dart/business/proof/keyset_helper.dart';
import 'package:cashu_dart/core/nuts/v1/nut_02.dart';
import 'package:cashu_dart/model/keyset_info_isar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

const String _mintURL = 'https://mint.example.com';

List<KeysetInfoIsar> _keysetsFromFixture(Map<String, dynamic> json) {
  final list = json['keysets'] as List<dynamic>? ?? [];
  return list
      .map((e) => KeysetInfoIsar.fromServerMap(
            Map<String, dynamic>.from(e as Map),
            _mintURL,
          ))
      .toList();
}

/// Path to test/fixtures/nut02. Prefer CWD (package root when running `flutter test`).
String _fixturePath(String filename) {
  final cwd = Directory.current.path;
  final fromCwd = p.join(cwd, 'test', 'fixtures', 'nut02', filename);
  if (File(fromCwd).existsSync()) return fromCwd;
  final fromScript = p.join(
    File(Platform.script.toFilePath()).parent.parent.path,
    'fixtures',
    'nut02',
    filename,
  );
  return fromScript;
}

void main() {
  group('KeysetHelper.findBetterKeyset (fixture-driven)', () {
    test('V1-only fixture: selects first valid V1 keyset', () {
      final path = _fixturePath('keysets_v1.json');
      final json = jsonDecode(File(path).readAsStringSync())
          as Map<String, dynamic>;
      final list = _keysetsFromFixture(json);
      final selected = KeysetHelper.findBetterKeyset(list);
      expect(selected, isNotNull);
      expect(selected!.keysetId, '009a1f293253e41e');
      expect(Nut2.isKeysetIdV2(selected.keysetId), isFalse);
    });

    test('V2-only fixture: selects first valid V2 keyset', () {
      final path = _fixturePath('keysets_v2.json');
      final json = jsonDecode(File(path).readAsStringSync())
          as Map<String, dynamic>;
      final list = _keysetsFromFixture(json);
      final selected = KeysetHelper.findBetterKeyset(list);
      expect(selected, isNotNull);
      expect(selected!.keysetId,
          '015ba18a8adcd02e715a58358eb618da4a4b3791151a4bee5e968bb88406ccf76a');
      expect(Nut2.isKeysetIdV2(selected.keysetId), isTrue);
    });

    test('mixed fixture: prefers V2 over V1', () {
      final path = _fixturePath('keysets_mixed.json');
      final json = jsonDecode(File(path).readAsStringSync())
          as Map<String, dynamic>;
      final list = _keysetsFromFixture(json);
      final selected = KeysetHelper.findBetterKeyset(list);
      expect(selected, isNotNull);
      expect(selected!.keysetId,
          '015ba18a8adcd02e715a58358eb618da4a4b3791151a4bee5e968bb88406ccf76a');
      expect(Nut2.isKeysetIdV2(selected.keysetId), isTrue);
    });

    test('empty list returns null', () {
      final selected = KeysetHelper.findBetterKeyset(<KeysetInfoIsar>[]);
      expect(selected, isNull);
    });

    test('all invalid ids: returns null (no valid hex id)', () {
      final json = jsonDecode(
        '''
        {
          "keysets": [
            {"id": "00invalid!!", "unit": "sat", "active": true, "input_fee_ppk": 0, "final_expiry": null},
            {"id": "nothex", "unit": "sat", "active": true, "input_fee_ppk": 0, "final_expiry": null}
          ]
        }
        ''',
      ) as Map<String, dynamic>;
      final list = _keysetsFromFixture(json);
      final selected = KeysetHelper.findBetterKeyset(list);
      expect(selected, isNull);
    });
  });
}
