
import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

enum CustomMessageType {
  zaps,
}

extension CustomMessageTypeEx on CustomMessageType {
  String get value {
    switch (this) {
      case CustomMessageType.zaps:
        return '1';
      default:
        return '-1';
    }
  }

  static CustomMessageType? fromValue(dynamic value) {
    try {
      return CustomMessageType.values.firstWhere((e) => e.value == value);
    } catch(e) {
      return null;
    }
  }
}

extension CustomMessageEx on types.CustomMessage {
  CustomMessageType? get customType =>
      CustomMessageTypeEx.fromValue(metadata?['type']);

  static Map<String, dynamic> zapsMetaData({
    required String zapper,
    required String invoice,
    required String amount,
    required String description,
  }) {
    return {
      'type': CustomMessageType.zaps.value,
      'content': {
        'zapper': zapper,
        'invoice': invoice,
        'amount': amount,
        'description': description,
      },
    };
  }

  String get customContentString {
    try {
      return jsonEncode(metadata ?? {});
    } catch(e) {
      return '';
    }
  }
}

extension ZapsMessageEx on types.CustomMessage {
  int get amount => int.tryParse(metadata?['content']?['amount'] ?? '') ?? 0;
  String get description => metadata?['content']?['description'] ?? '';
  String get invoice => metadata?['content']?['invoice'] ?? '';
}
