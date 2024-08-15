
import 'package:flutter/material.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:chatcore/chat-core.dart';

class OXCallingInterface {

  static const moduleName = 'ox_calling';

  static void pushCallingPage(BuildContext context, UserDBISAR user, CallMessageType type) {
    OXModuleService.pushPage(
      context,
      moduleName,
      'CallPage',
      {
        'userDB': user,
        'media': type.text,
      },
    );
  }
}