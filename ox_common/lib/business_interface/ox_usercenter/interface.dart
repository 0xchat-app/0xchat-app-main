
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_module_service/ox_module_service.dart';

import 'zaps_detail_model.dart';

class OXUserCenterInterface {

  static const moduleName = 'ox_usercenter';

  static Future? jumpToZapsRecordPage(BuildContext context, ZapsRecordDetail detail) {
    return OXModuleService.pushPage(context, moduleName, 'ZapsRecordPage', {
      'zapsDetail': detail,
    });
  }

  static Future<Map<String, String>> getInvoice({
    required int sats,
    required String recipient,
    required String otherLnurl,
    String? content,
    String? eventId,
    ZapType? zapType,
    String? receiver,
    String? groupId,
    bool privateZap = false,
  }) async {
    return await OXModuleService.invoke<Future<Map<String, String>>>(
      moduleName,
      'getInvoice',
      [],
      {
        #sats: sats,
        #recipient: recipient,
        #otherLnurl: otherLnurl,
        #content: content,
        #eventId: eventId,
        #zapType: zapType,
        #receiver: receiver,
        #groupId: groupId,
        #privateZap: privateZap,
      },) ?? {};
  }
}