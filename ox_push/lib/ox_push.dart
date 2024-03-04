import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_push/push/unifiedpush.dart';

class OXPush extends OXFlutterModule {

  static bool hasSetNotification = false;

  static const MethodChannel pushChannel = const MethodChannel('ox_push');

  @override
  // TODO: implement moduleName
  String get moduleName => 'ox_push';

  @override
  Future<void> setup() async {
    // TODO: implement setup
    await super.setup();
    if (Platform.isIOS) {
      pushChannel.setMethodCallHandler(_platformCallHandler);
      OXUserInfoManager.sharedInstance.initDataActions.add(_setNotification);
    } else if (Platform.isAndroid) {
      UnifiedPush.initialize();
    }
  }

  static Future<dynamic> _platformCallHandler(MethodCall call) async {
    // Map<String, dynamic> callMap = Map<String, dynamic>.from(call.arguments);
    switch (call.method) {
      case 'savePushToken':
        String token = call.arguments;
        requestRegistrationID(token);
        break;
    }
  }

  @protected
  /// External interface method
  Map<String, Function> get interfaces => {
    "unPushId": unPushId,
  };

  void unPushId(String userId) {
    pushChannel.invokeMethod('unPushId', {'userId': userId});
  }

  //Set the push ID
  static Future<void> requestRegistrationID(String registrationID) async {
    if(Platform.isIOS) {
      await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_PUSH_TOKEN, '${CommonConstant.bundleId}$registrationID');
      _setNotification();
    }
  }

  static _setNotification() async {
    if (hasSetNotification) return ;
    hasSetNotification = await OXUserInfoManager.sharedInstance.setNotification();
  }

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    return null;
  }
}
