import 'package:flutter/src/widgets/framework.dart';
import 'package:ox_calling/manager/call_manager.dart';
import 'package:ox_calling/page/call_page.dart';
import 'package:ox_calling/manager/signaling.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/permission_utils.dart';

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
  Future<T?>? navigateToPage<T>(BuildContext context, String pageName, Map<String, dynamic>? params) async {
    switch (pageName) {
      case 'CallPage':
        bool cmPermission = await PermissionUtils.getCallPermission(context);
        if (!cmPermission) return null;
        String mediaType = params?['media'] ?? 'video';
        if (CallManager.instance.callState == null ) {
          CallManager.instance.connectServer();
          CallManager.instance.callState = CallState.CallStateInvite;
          if (mediaType == CallMessageType.audio.text) {
            CallManager.instance.callType = CallMessageType.audio;
          } else if (mediaType == CallMessageType.video.text) {
            CallManager.instance.callType = CallMessageType.video;
          }
        } else {
          mediaType = CallManager.instance.callType?.text ?? mediaType;
        }
        return OXNavigator.pushPage(context, (context) => CallPage(params?['userDB'], mediaType));
    }
    return null;
  }

  void initRTC() {
    CallManager.instance.initRTC();
  }

  void closeRTC(BuildContext context) {
    CallManager.instance.closeRTC();
  }
}
