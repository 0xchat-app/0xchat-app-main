
import 'dart:convert';

extension CustomURIHelper on String {

  static const scheme = 'oxChat';
  static const moduleAction = 'moduleAction';

  bool get isOXChatURI => Uri.parse(this).scheme == scheme.toLowerCase();

  bool get isModuleActionURI {
    final uri = Uri.parse(this);
    return isOXChatURI && uri.host == moduleAction.toLowerCase();
  }

  ({String module, String action, Map<String, String> params})? getModuleActionValue() {
    if (!isModuleActionURI) return null;

    final uri = Uri.parse(this);
    final query = uri.queryParameters;
    final moduleValue = query['module'] ?? '';
    final actionValue = query['action'] ?? '';
    Map<String, String> paramsValue = {};
    try {
      paramsValue = json.decode(Uri.decodeFull(query['params'] ?? ''));
    } catch(_) { }

    if (moduleValue.isEmpty || actionValue.isEmpty) {
      return null;
    }
    return (module: moduleValue, action: actionValue, params: paramsValue);
  }

  static createModuleActionURI({
    required String module,
    required String action,
    Map<String, String> params = const {},
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

  static _createURI({required String host, Map<String, String>? queryParameters}) {
    return Uri(scheme: scheme, host: host, queryParameters: queryParameters);
  }
}