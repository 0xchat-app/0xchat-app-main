

import '../const/common_constant.dart';
import '../log_util.dart';
import '../ox_common.dart';

typedef SchemeHandler = Function(String scheme, String action, Map<String, String> queryParameters);

class SchemeHelper {

  static SchemeHandler? defaultHandler;
  static Map<String, SchemeHandler> schemeAction = {};

  static register(String action, SchemeHandler handler) {
    schemeAction[action.toLowerCase()] = handler;
  }

  static tryHandlerForOpenAppScheme() async {
    String scheme = await OXCommon.channelPreferences.invokeMethod(
      'getAppOpenURL',
    );
    LogUtil.d("App open URL: $scheme");

    if (scheme.isEmpty) return ;

    String action = '';
    Map<String, String> query = <String, String>{};

    try {
      final uri = Uri.parse(scheme);
      if (uri.scheme != CommonConstant.APP_SCHEME) return ;

      action = uri.host.toLowerCase();
      query = uri.queryParameters;
    } catch (_) {
      final appScheme = '${CommonConstant.APP_SCHEME}://';
      if (scheme.startsWith(appScheme)) {
        action = scheme.replaceFirst(appScheme, '');
        scheme = appScheme;
      }
    }
    defaultHandler?.call(scheme, action, query);
  }
}