import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_chat_project/main.dart';
import 'package:ox_home/page/launch_page_view.dart';

///Title: multi_route_utils
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author George
///CreateTime: 6/11/21 3:11 PM
class MultiRouteUtils {
  static Widget widgetForRoute(String route, BuildContext context) {
    if (route != '/') {
      String pageName = _getPageName(route);
      String moduleName = _getModuleName(pageName);
      Map<String, dynamic> pageParams = _parseNativeParams(route);
      LogUtil.e("pageName: ${pageName.toString()} pageParams:" + pageParams.toString());
      Widget pathWidget = Scaffold(
        backgroundColor: ThemeColor.dark02,
        body: Container(),
      );
      switch (moduleName) {
        case 'default':
          break;
      }
      return pathWidget;
    } else {
      return LaunchPageView();
    }
  }

  static String _getPageName(String route) {
    String pageName = route;
    if (route.indexOf("?") != -1) pageName = route.substring(0, route.indexOf("?"));
    return pageName;
  }

  static String _getModuleName(String pageName) {
    String moduleName = pageName;
    if (pageName.indexOf("/") != -1) moduleName = pageName.substring(0, pageName.indexOf("/"));
    return moduleName;
  }

  static String _getPagePath(String pageName) {
    String path = '';
    if (pageName.indexOf("/") != -1) {
      path = pageName.substring(pageName.indexOf("/") + 1);
    }
    return path;
  }

  /// Parse native parameters and perform initialization operations
  static Map<String, dynamic> _parseNativeParams(String route) {
    Map<String, dynamic> nativeParams = {};
    if (route.indexOf("?") != -1) {
      nativeParams = json.decode(route.substring(route.indexOf("?") + 1));
    }
    return nativeParams['pageParams'] ?? {};
  }

  static void newFlutterActivity(String route, String params) {
    channel.invokeMethod('showFlutterActivity', {
      'route': route,
      'params': params,
    });
  }
}
