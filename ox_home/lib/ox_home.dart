
import 'package:flutter/cupertino.dart';
import 'package:ox_module_service/ox_module_service.dart';

class OxChatHome extends OXFlutterModule {

  @override
  String get moduleName => 'ox_home';

  @override
  Future<void> setup() async {
    super.setup();
    OXModuleService.registerFlutterModule(moduleName, this);
  }

  @override
  navigateToPage(BuildContext context, String pageName, Map<String, dynamic>? params) {

  }
}
