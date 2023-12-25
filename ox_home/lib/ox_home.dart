
import 'package:flutter/cupertino.dart';
import 'package:ox_home/page/home_tabbar.dart';
import 'package:ox_home/page/launch_page_view.dart';
import 'package:ox_module_service/ox_module_service.dart';

class OxChatHome extends OXFlutterModule {

  @override
  String get moduleName => 'ox_home';

  @override
  Future<void> setup() async {
    super.setup();
  }

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'HomeTabBarPage':
        return Navigator.of(context).pushReplacement(CustomRouteFadeIn(const HomeTabBarPage()));
    }
    return null;
  }
}
