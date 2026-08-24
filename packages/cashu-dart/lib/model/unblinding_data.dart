
import 'dart:convert';

import 'package:cashu_dart/model/unblinding_data_isar.dart';

import '../core/nuts/nut_00.dart';
import '../utils/database/db.dart';
import '../utils/database/db_object.dart';
import '../utils/tools.dart';

@reflector
class UnblindingData extends DBObject {

  UnblindingData({
    required this.mintURL,
    required this.unit,
    required this.actionType,
    required this.actionValue,
    required this.id,
    required this.amount,
    required this.C_,
    this.dleq,
    required this.r,
    required this.secret,
  }) : actionTypeRaw = actionType.value;

  factory UnblindingData.fromSignature({
    required BlindedSignature signature,
    required String mintURL,
    required ProofBlindingAction action,
    required String actionValue,
    required String unit,
    required String r,
    required String secret,
  }) => UnblindingData(
    mintURL: mintURL,
    unit: unit,
    actionType: action,
    actionValue: actionValue,
    id: signature.id,
    amount: signature.amount,
    C_: signature.C_,
    dleq: signature.dleq,
    r: r,
    secret: secret,
  );

  final String mintURL;
  final String unit;
  final ProofBlindingAction actionType;
  final int actionTypeRaw;

  final String actionValue;

  // BlindedSignature
  final String id;
  final String amount;
  final String C_;
  final Map? dleq;
  final String dleqPlainText = '';

  BlindedSignature get signature => BlindedSignature(
    id: id,
    amount: amount,
    C_: C_,
    dleq: dleq,
  );

  // Unbinding
  final String r;
  final String secret;

  @override
  Map<String, Object?> toMap() => {
    'mintURL': mintURL,
    'unit': unit,
    'actionTypeRaw': actionType.value,
    'actionValue': actionValue,
    'id': id,
    'amount': amount,
    'C_': C_,
    'dleqPlainText': jsonEncode(dleq),
    'r': r,
    'secret': secret,
  };

  static UnblindingData fromMap(Map<String, Object?> map) {

    final dleqPlainText = map['dleqPlainText'];
    Map<String, dynamic>? dleq;
    if (dleqPlainText is String && dleqPlainText.isNotEmpty) {
      try {
        dleq = jsonDecode(dleqPlainText);
      } catch(_) { }
    }

    return UnblindingData(
      mintURL: Tools.getValueAs<String>(map, 'mintURL', ''),
      unit: Tools.getValueAs<String>(map, 'unit', ''),
      actionType: ProofBlindingAction.fromValue(
        Tools.getValueAs<int>(map, 'actionTypeRaw', ProofBlindingAction.unknown.value),
      ),
      actionValue: Tools.getValueAs<String>(map, 'actionValue', ''),
      id: Tools.getValueAs<String>(map, 'id', ''),
      amount: Tools.getValueAs<String>(map, 'amount', '0'),
      C_: Tools.getValueAs<String>(map, 'C_', ''),
      dleq: dleq,
      r: Tools.getValueAs<String>(map, 'r', ''),
      secret: Tools.getValueAs<String>(map, 'secret', ''),
    );
  }

  static String? tableName() {
    return "UnblindingData";
  }

  static List<String?> primaryKey() {
    return ['id', 'secret'];
  }

  static List<String?> ignoreKey() {
    return ['dleq'];
  }

  static Map<String, String?> updateTable() {
    return {
      "4":
      '''alter table UnblindingData add actionTypeRaw INT; alter table UnblindingData add actionValue TEXT;''',
    };
  }

  @override
  String toString() {
    return '${super.toString()}, id: $id, amount: $amount, secret: $secret';
  }
}