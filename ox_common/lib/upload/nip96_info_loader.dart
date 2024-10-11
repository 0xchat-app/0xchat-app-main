import 'dart:convert';

import 'package:ox_common/log_util.dart';
import 'package:ox_common/network/network_general.dart';
import 'package:ox_network/network_manager.dart';
import 'nip96_server_adaptation.dart';
import 'package:http/http.dart' as http;

class NIP96InfoLoader {
  static NIP96InfoLoader? _nip96infoLoader;

  static NIP96InfoLoader getInstance() {
    _nip96infoLoader ??= NIP96InfoLoader();

    return _nip96infoLoader!;
  }

  Map<String, Nip96ServerAdaptation> serverAdaptations = {};

  Future<Nip96ServerAdaptation?> getServerAdaptation(String url) async {
    var sa = serverAdaptations[url];
    sa ??= await pullServerAdaptation(url);

    if (sa != null) {
      serverAdaptations[url] = sa;
    }

    return sa;
  }

  Future<Nip96ServerAdaptation?> pullServerAdaptation(String url) async {
    var uri = Uri.parse(url);
    var newUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: "/.well-known/nostr/nip96.json");

    // var jsonMap = await dioGet(newUri.toString());
    // if (jsonMap != null) {
    //   return Nip96ServerAdaptation.fromJson(jsonMap);
    // }

    try {
      final response = await http
          .get(Uri.parse(newUri.toString()));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return Nip96ServerAdaptation.fromJson(result);
      } else {
        return null;
      }
    } catch (e, s) {
      LogUtil.e("Get NIP-96 Server failed: $e\r\n$s");
      return null;
    }
  }
}
