
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
}

extension ZapsMessageEx on types.CustomMessage {
  int get amount => int.tryParse(metadata?['amount'] ?? '') ?? 0;
  String get description => metadata?['description'] ?? '';
  String get invoice => metadata?['invoice'] ?? '';
}
