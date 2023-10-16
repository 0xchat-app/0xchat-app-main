import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:flutter_callkeep/flutter_callkeep.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:uuid/uuid.dart';

///Title: ox_call_keep_manager
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/10/13 17:10
class OXCalllKeepManager{

  static Uuid? uuid;

  static String? currentUuid;

  static Future<void> displayIncomingCall(String uuid) async {
    LogUtil.e('Push: background displayIncomingCall uuid =${uuid}');
    final config = CallKeepIncomingConfig(
      uuid: uuid,
      callerName: 'Hien Nguyen',
      appName: 'OxChat',
      avatar: 'https://i.pravatar.cc/100',
      handle: '0123456789',
      hasVideo: false,
      duration: 30000,
      acceptText: 'Accept',
      declineText: 'Decline',
      missedCallText: 'Missed call',
      callBackText: 'Call back',
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      androidConfig: CallKeepAndroidConfig(
        logo: "ic_logo",
        showCallBackAction: true,
        showMissedCallNotification: true,
        ringtoneFileName: 'system_ringtone_default',
        accentColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        incomingCallNotificationChannelName: 'Incoming Calls',
        missedCallNotificationChannelName: 'Missed Calls',
      ),
      iosConfig: CallKeepIosConfig(
        iconName: 'CallKitLogo',
        handleType: CallKitHandleType.generic,
        isVideoSupported: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtoneFileName: 'system_ringtone_default',
      ),
    );
    await CallKeep.instance.displayIncomingCall(config);
  }

  static Future<CallKeepCallData?> getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await CallKeep.instance.activeCalls();
    if (calls.isNotEmpty) {
      print('DATA: $calls');
      currentUuid = calls[0].uuid;
      return calls[0];
    } else {
      currentUuid = "";
      return null;
    }
  }

  static checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    print('not answered call ${currentCall?.toMap()}');
    if (currentCall != null && OXNavigator.navigatorKey.currentContext != null) {
      OXModuleService.pushPage(
        OXNavigator.navigatorKey.currentContext!,
        'ox_calling',
        'CallPage',
        {
          'userDB': UserDB(pubKey: 'b493c4dad3e8809eac6729e7868cc68426d250e51f7e01430065d9b80ba3f04d',  name: '633d'),
          'media': CallMessageType.video.text,
        },
      );
    }
  }

}