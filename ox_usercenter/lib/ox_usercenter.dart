import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_usercenter/model/request_verify_dns.dart';
import 'package:ox_usercenter/page/badge/usercenter_badge_wall_page.dart';
import 'package:ox_usercenter/page/set_up/avatar_preview_page.dart';
import 'package:ox_usercenter/page/set_up/relays_page.dart';
import 'package:ox_usercenter/page/set_up/relays_selector_dialog.dart';
import 'package:ox_usercenter/page/set_up/zaps_invoice_dialog.dart';
import 'package:ox_usercenter/page/usercenter_page.dart';
import 'package:chatcore/chat-core.dart';

class OXUserCenter extends OXFlutterModule {

  static String get loginPageId => "usercenter_page";

  @override
  Future<void> setup() async {
    // TODO: implement setup
    super.setup();
    OXModuleService.registerFlutterModule(moduleName, this);
    // ChatBinding.instance.setup();
  }

  @override
  // TODO: implement moduleName
  String get moduleName => 'ox_usercenter';

  @override
  Map<String, Function> get interfaces => {
        'showRelayPage': showRelayPage,
        'showRelaySelectorDialog': showRelaySelectorDialog,
        'requestVerifyDNS': requestVerifyDNS,
        'userCenterPageWidget': userCenterPageWidget,
        'showZapsInvoiceDialog': _showZapsInvoiceDialog,
      };

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'UserCenterPage':
        return OXNavigator.pushPage(
          context,
          (context) => UserCenterPage(),
        );
      case 'UsercenterBadgeWallPage':
        UserDB? userDB = params?['userDB'];
        return OXNavigator.pushPage(context, (context) => UsercenterBadgeWallPage(userDB: userDB,));
      case 'AvatarPreviewPage':
        UserDB? userDB = params?['userDB'];
        LogUtil.e('Michael: ');
        return OXNavigator.pushPage(context, (context) => AvatarPreviewPage(userDB: userDB),);
    }
    return null;
  }

  void showRelayPage(BuildContext context) {
    OXNavigator.pushPage(context, (context) => RelaysPage());
  }

  void showRelaySelectorDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return RelaysSelectorPage();
        });
  }

  Future<Map<String, dynamic>?> requestVerifyDNS(Map<String, dynamic>? params, BuildContext? context, bool? showErrorToast, bool? showLoading) async {
    return await registerNip05(context: context, params: params, showLoading: showLoading, showErrorToast: showErrorToast);
  }

  Widget userCenterPageWidget(BuildContext context) {
    return UserCenterPage();
  }


  void _showZapsInvoiceDialog(BuildContext context,String invoice) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ZapsInvoiceDialog(invoice: invoice);
        });
  }
}
