
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
      url = await NetworkTool.instance.dnsReplaceIp(url, domain);
    }
    return (url: url, headers: headers);
  }
}