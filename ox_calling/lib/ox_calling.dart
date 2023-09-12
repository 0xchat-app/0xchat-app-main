import 'package:flutter/src/widgets/framework.dart';
import 'package:ox_calling/manager/call_manager.dart';
import 'package:ox_calling/page/call_page.dart';
import 'package:ox_calling/manager/signaling.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';

import 'ox_calling_platform_interface.dart';
import 'package:ox_module_service/ox_module_service.dart';

class OxCalling extends OXFlutterModule {
  Future<String?> getPlatformVersion() {
    return OxCallingPlatform.instance.getPlatformVersion();
  }

  @override
  String get moduleName => 'ox_calling';

  @override
  Map<String, Function> get interfaces => {
        'initRTC': initRTC,
        'closeRTC': closeRTC,
      };

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'CallPage':
        CallManager.instance.callState = CallState.CallStateInvite;
        String mediaType = params?['media'] ?? 'video';
        LogUtil.e('Michael: OxCalling navigateToPage called CallPage ----mediaType =${mediaType}');
        if (mediaType == CallMessageType.audio.text) {
          CallManager.instance.callType = CallMessageType.audio;
        } else if (mediaType == CallMessageType.video.text) {
          CallManager.instance.callType = CallMessageType.video;
        }
        return OXNavigator.pushPage(context, (context) => CallPage(params?['userDB'], mediaType));
    }
    return null;
  }

  void initRTC() {
    LogUtil.e('Michael: OxCalling interfaces initRTC');
    CallManager.instance.initRTC();
  }

  void closeRTC(BuildContext context) {
    LogUtil.e('Michael: OxCalling interfaces closeRTC');
    CallManager.instance.closeRTC();
  }
}
