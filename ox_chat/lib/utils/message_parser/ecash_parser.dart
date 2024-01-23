
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';

class EcashParser {
  static String? tryEncoder(types.Message message) {
    if (message is types.CustomMessage && message.customType == CustomMessageType.ecash) {
      return EcashMessageEx(message).token;
    }
    return null;
  }
}