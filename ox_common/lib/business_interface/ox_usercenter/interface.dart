
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
}