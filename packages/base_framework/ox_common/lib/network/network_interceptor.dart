import 'package:ox_common/network/network_tool.dart';

class NetworkInterceptor {
  static Future<({String url, Map<String, String> headers})> modifyRequest({
    required String url,
    Map<String, String>? headers,
  }) async {
    headers ??= {};
    String? domain = await NetworkTool.instance.getUrlDomain(url);
    if (domain != null) {
      headers["host"] = domain;
      // The URL used to be rewritten to a fixed IP for 0xchat's own hosts.
      // Those servers are shut down, so requests go to the URL as given.
    }
    return (url: url, headers: headers);
  }
}