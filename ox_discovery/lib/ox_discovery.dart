
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:ox_discovery/page/discovery_page.dart';
import 'package:ox_discovery/page/moments/personal_moments_page.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';

class OXDiscovery  extends OXFlutterModule {

  @override
  Future<void> setup() async {
    await super.setup();
    OXMomentManager.sharedInstance.init();
    // ChatBinding.instance.setup();
  }

  @override
  // TODO: implement moduleName
  String get moduleName => 'ox_discovery';

  @override
  Map<String, Function> get interfaces => {
    'discoveryPageWidget': discoveryPageWidget,
  };

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'UserCenterPage':
        return OXNavigator.pushPage(
          context,
              (context) => const DiscoveryPage(),
        );
      case 'PersonMomentsPage':
        return OXNavigator.pushPage(
            context, (context) => PersonMomentsPage(userDB: params?['userDB'],));
    }
    return null;
  }

  Widget discoveryPageWidget(BuildContext context,{PageController? pageController}) {
    return DiscoveryPage(pageController:pageController);
  }
}
