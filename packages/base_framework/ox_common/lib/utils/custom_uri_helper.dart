
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_module_service/ox_module_service.dart';

extension CustomURIHelper on String {

  static const scheme = 'oxChat';
  static const moduleAction = 'moduleAction';
  static const nostrAction = 'nostr';

  bool get isOXChatURI => Uri.parse(this).scheme == scheme.toLowerCase();

  bool get isModuleActionURI {
    final uri = Uri.parse(this);
    return isOXChatURI && uri.host == moduleAction.toLowerCase();
  }

  ({String module, String action, Map<String, dynamic> params})? getModuleActionValue() {
    if (!isModuleActionURI) return null;

    final uri = Uri.parse(this);
    final query = uri.queryParameters;
    final moduleValue = query['module'] ?? '';
    final actionValue = query['action'] ?? '';
    Map<String, dynamic> paramsValue = {};
    try {
      paramsValue = json.decode(Uri.decodeFull(query['params'] ?? ''));
    } catch(_) { }

    if (moduleValue.isEmpty || actionValue.isEmpty) {
      return null;
    }
    return (module: moduleValue, action: actionValue, params: paramsValue);
  }

  static String createModuleActionURI({
    required String module,
    required String action,
    Map<String, dynamic> params = const {},
  }) {
    final queryParameters = {
      'module': module,
      'action': action,
    };

    if (params.isNotEmpty) {
      final paramsJsonString = Uri.encodeFull(json.encode(params));
      queryParameters['params'] = paramsJsonString;
    }
    return _createURI(host: moduleAction, queryParameters: queryParameters);
  }

  static String createNostrURI(String content) {
    final shareURI = Uri.parse(CommonConstant.SHARE_APP_LINK_DOMAIN);
    return Uri(
      scheme: shareURI.scheme,
      host: shareURI.host,
      pathSegments: [
        ...shareURI.pathSegments,
        nostrAction,
      ],
      queryParameters: {
        'value': content,
      },
    ).toString();
  }

  static String _createURI({required String host, Map<String, String>? queryParameters}) {
    return Uri(scheme: scheme, host: host, queryParameters: queryParameters).toString();
  }
}

extension CustomURIActionEx on String {
  dynamic tryHandleCustomUri({BuildContext? context}) {
    if (isModuleActionURI) {
      return _doModuleAction(context: context);
    }
  }

  dynamic _doModuleAction({BuildContext? context}) {
    final result = getModuleActionValue();
    if (result == null) {
      LogUtil.e('【Error】CustomURIActionEx tryAction error: result is null.');
      return;
    }
    final module = result.module;
    final action = result.action;
    final params = result.params.map((key, value) => MapEntry(Symbol(key), value));
    try {
      return OXModuleService.invoke(module, action, [context], params);
    } catch(e) {
      LogUtil.e('【Error】CustomURIActionEx tryAction error: $e.');
    }
  }
}