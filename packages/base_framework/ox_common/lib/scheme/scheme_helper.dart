

import '../const/common_constant.dart';
import '../log_util.dart';
import '../ox_common.dart';
import '../utils/platform_utils.dart';

typedef SchemeHandler = Function(String uri, String action, Map<String, String> queryParameters);

class SchemeHelper {

  static SchemeHandler? defaultHandler;
  static Map<String, SchemeHandler> schemeAction = {};

  static register(String action, SchemeHandler handler) {
    schemeAction[action.toLowerCase()] = handler;
  }

  static tryHandlerForOpenAppScheme() async {
    if(!PlatformUtils.isMobile) return;
    String url = await OXCommon.channelPreferences.invokeMethod(
      'getAppOpenURL',
    );
    LogUtil.d("App open URL: $url");

    handleAppURI(url);
  }

  static handleAppURI(String uri) async {
    if (uri.isEmpty) return ;

    String action = '';
    Map<String, String> query = <String, String>{};

    try {
      final uriObj = Uri.parse(uri);
      if (uriObj.scheme != CommonConstant.APP_SCHEME) return ;

      action = uriObj.host.toLowerCase();
      query = uriObj.queryParameters;
    } catch (_) {
      final appScheme = '${CommonConstant.APP_SCHEME}://';
      if (uri.startsWith(appScheme)) {
        action = uri.replaceFirst(appScheme, '');
        uri = appScheme;
      }
    }

    final handler = schemeAction[action];
    if (handler != null) {
      handler(uri, action, query);
      return;
    }

    defaultHandler?.call(uri, action, query);
  }
}

enum SchemeShareType {
  text,
  image,
  video,
  file,
}

extension SchemeShareTypeEx on SchemeShareType{

  String get typeText{
    switch(this){
      case SchemeShareType.text:
        return 'text';
      case SchemeShareType.image:
        return 'image';
      case SchemeShareType.video:
        return 'video';
      case SchemeShareType.file:
        return 'file';
    }
  }
}