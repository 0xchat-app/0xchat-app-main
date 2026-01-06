
import 'dart:async';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

typedef MessageContentParser = String? Function(types.Message);

abstract class MessageTransfer {

  bool isMatch(String text);

  FutureOr<types.Message> transferFromText(String text);
}
