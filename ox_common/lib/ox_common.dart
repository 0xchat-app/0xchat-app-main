import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/app_initialization_manager.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:uuid/uuid.dart';

const CommonModule = 'ox_common';

class OXCommon extends OXFlutterModule {
  @override
  // TODO: implement moduleName
  String get moduleName => CommonModule;


  @override
  // TODO: implement dbSchemes
  List<Type> get dbSchemes => [
    UserDB,
    ZapsDB,
    BadgeAwardDB,
    BadgeDB,
    RelayDB,
    ChatSessionModel,
    MessageDB,
  ];

  @override
  Future<void> setup() async {
    await super.setup();
    PromptToneManager.sharedInstance.setup();
    AppInitializationManager.shared.setup();
  }

  @override
  Map<String, Function> get interfaces =>{
    "gotoWebView": gotoWebView,
    'saveImageToGallery':saveImageToGallery
  };

  static const MethodChannel channel = const MethodChannel('$CommonModule');

  static Future<String> get platformVersion async {
    final String version = await channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> callSysShare(String filePath) async {
    await channel.invokeMethod('callSysShare', {'filePath' :  filePath});
  }

  static Future<void> callIOSSysShare(Uint8List? uint8List) async {
    await channel.invokeMethod('callIOSSysShare', {'imageBytes' :  uint8List});
  }

  static void backToDesktop() async {
    await channel.invokeMethod('backToDesktop',);
  }

  static Future<String> getDeviceId() async {
    final String deviceId = await channel.invokeMethod('getDeviceId');
    return deviceId;
  }

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    // TODO: implement navigateToPage
    return null;
  }


  void gotoWebView(BuildContext context,String url){
    OXNavigator.pushPage(context, (context) => CommonWebView(url));
  }

  Future<String?> saveImageToGallery(Map<String,dynamic> params) async{
    return await ImagePickerUtils.saveImageToGallery(imageBytes: params["imageBytes"]);
  }
}