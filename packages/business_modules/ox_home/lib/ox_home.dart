
import 'package:flutter/cupertino.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/scheme/scheme_helper.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';
import 'package:ox_common/utils/scan_utils.dart';
import 'package:ox_home/page/home_tabbar.dart';
import 'package:ox_home/page/launch_page_view.dart';
import 'package:ox_module_service/ox_module_service.dart';

class OxChatHome extends OXFlutterModule {

  @override
  String get moduleName => 'ox_home';

  @override
  Future<void> setup() async {
    await super.setup();
    SchemeHelper.defaultHandler = nostrHandler;
    SchemeHelper.register(CustomURIHelper.nostrAction, nostrHandler);
  }

  @override
  Future<T?>? navigateToPage<T>(BuildContext context, String pageName, Map<String, dynamic>? params) {
    switch (pageName) {
      case 'HomeTabBarPage':
        return Navigator.of(context).pushReplacement<T, T>(CustomRouteFadeIn<T>(const HomeTabBarPage()));
    }
    return null;
  }

  nostrHandler(String scheme, String action, Map<String, String> queryParameters) {
    BuildContext? context = OXNavigator.navigatorKey.currentContext;
    if(context == null) return;

    String nostrString = '';
    if (action == CustomURIHelper.nostrAction) {
      nostrString = queryParameters['value'] ?? '';
    } else {
      nostrString = action;
    }
    if (nostrString.isEmpty) return ;

    ScanUtils.analysis(context, nostrString);
  }
}
