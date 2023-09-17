
import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';

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

  static Map<String, dynamic> callMetaData({
    required String text,
    required CallMessageType type,
  }) {
    return {
      'type': CustomMessageType.call.value,
      'content': {
        'text': text,
        'type': type.value,
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
  String get zapper => metadata?['content']?['zapper'] ?? '';
  String get invoice => metadata?['content']?['invoice'] ?? '';
  int get amount => int.tryParse(metadata?['content']?['amount'] ?? '') ?? 0;
  String get description => metadata?['content']?['description'] ?? '';
}

extension CallMessageEx on types.CustomMessage {
  String get callText => metadata?['content']?['text'] ?? '';
  CallMessageType? get callType => CallMessageTypeEx.fromValue(metadata?['content']?['type']);
}
