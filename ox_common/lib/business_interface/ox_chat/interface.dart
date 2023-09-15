
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_module_service/ox_module_service.dart';

import 'call_message_type.dart';

class OXChatInterface {

  static const moduleName = 'ox_chat';

  static void sendCallMessage(ChatSessionModel session, String text, CallMessageType type) {
    OXModuleService.invoke(
      moduleName,
      'sendCallMessage',
      [],
      {
        #session: session,
        #text: text,
        #type: type,
      },);
  }
}