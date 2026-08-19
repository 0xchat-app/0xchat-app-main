
import 'dart:convert';

import '../utils/database/db.dart';
import '../utils/database/db_object.dart';
import '../utils/tools.dart';

@reflector
class KeysetInfo extends DBObject {
  KeysetInfo({
    required this.id,
    required this.mintURL,
    required this.unit,
    required this.active,
    Map<String, String>? keyset,
    this.inputFeePPK = 0,
  }) : keyset = keyset ?? {};

  String id;
  String mintURL;
  String unit;
  bool active;
  Map<String, String> keyset = {};
  int inputFeePPK;

  // for db column
  String keysetRaw = '';

  factory KeysetInfo.fromServerMap(Map jsonMap, String mintURL) {
    return KeysetInfo(
      id: Tools.getValueAs<String>(jsonMap, 'id', ''),
      mintURL: mintURL,
      unit: Tools.getValueAs<String>(jsonMap, 'unit', ''),
      active: Tools.getValueAs(jsonMap, 'active', false),
      inputFeePPK: Tools.getValueAs(jsonMap, 'input_fee_ppk', 0),
    );
  }

  @override
  String toString() {
    return '${super.toString()}, id: $id, unit: $unit, active: $active';
  }

  @override
  Map<String, Object?> toMap() => {
    'id': id,
    'mintURL': mintURL,
    'unit': unit,
    'active': active,
    'keysetRaw': json.encode(keyset),
    'inputFeePPK': inputFeePPK,
  };

  static KeysetInfo fromMap(Map<String, Object?> map) {
    Map<String, String> keyset = {};
    try {
      final decoded = json.decode(Tools.getValueAs(map, 'keysetRaw', '')) as Map;
      keyset = decoded.map((key, value) => MapEntry(key.toString(), value.toString()));
    } catch (_) {}

    return KeysetInfo(
      id: Tools.getValueAs(map, 'id', ''),
      mintURL: Tools.getValueAs(map, 'mintURL', ''),
      unit: Tools.getValueAs(map, 'unit', ''),
      active: Tools.getValueAs(map, 'active', 0) == 1,
      keyset: keyset,
      inputFeePPK: Tools.getValueAs(map, 'inputFeePPK', 0),
    );
  }

  static String? tableName() {
    return "KeysetInfo";
  }

  static List<String?> primaryKey() {
    return ['id', 'mintURL'];
  }

  static List<String?> ignoreKey() {
    return ['keyset'];
  }

  static Map<String, String?> updateTable() {
    return {
      "5": '''alter table ${tableName()} add inputFeePPK INT DEFAULT 0;'''
    };
  }
}