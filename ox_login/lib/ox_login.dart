
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_login/page/login_page.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_login/utils/fade_animations_custom.dart';
import 'package:ox_module_service/ox_module_service.dart';

class OXLogin extends OXFlutterModule {
  static const MethodChannel channel = const MethodChannel('ox_login');
  static String get loginPageId  => "login_page";
  static Future<String> get platformVersion async {
    final String version = await channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  Future<void> setup() async {
    super.setup();
  }

  @override
  // TODO: implement moduleName
  String get moduleName => 'ox_login';

  @override
  Map<String, Function> get interfaces => {
    'loginWidget': loginWidget,
  };

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'LoginPage':
        bool isLoginShow = params?['isLoginShow'] ?? false;

       return Navigator.push(context, FadeRouteCustom(page: LoginPage(isLoginShow: isLoginShow)));
    }
    return null;
  }



  Widget loginWidget(BuildContext context, bool? isLoginShow) {
    return LoginPage(isLoginShow: isLoginShow);
  }
}




