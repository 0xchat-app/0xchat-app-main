import 'package:flutter/foundation.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';

///Title: network_tool
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/2/19 17:39
class NetworkTool {
  static NetworkTool get instance => _getInstance();
  static NetworkTool? _instance;

  static NetworkTool _getInstance() {
    if (_instance == null) {
      _instance = new NetworkTool._internal();
    }
    return _instance!;
  }

  NetworkTool._internal();

  String urlProtocol() {
    String urlProtocol = "";
    if (kDebugMode) {
      urlProtocol = 'http://';
    } else {
      urlProtocol = 'https://';
    }
    return urlProtocol;
  }

  String version() {
    String version = '';
    if (kDebugMode) {
      version = 'V1_3';
    } else {
      version = 'V1_2';
    }
    return version;
  }

  Future<String> getDomainSymbol() async {
    if (kDebugMode) {
      return '100-196.net';
    } else {
      String domain = await OXCacheManager.defaultOXCacheManager
          .getForeverData(StorageKeyTool.APP_DOMAIN_NAME, defaultValue: '');
      return domain;
    }
  }


  Future<String> dnsReplaceIp(String url) async {
    String? server = await getUrlServer(url);
    if (server != null) {
      String ip = await OXCacheManager.defaultOXCacheManager
          .getForeverData(server, defaultValue: '');
      String? domain = await getUrlDomain(url);
      if (ip != null && ip.isNotEmpty && domain != null) {
        String replaceUrl = url.replaceFirst(domain, ip);
        return replaceUrl;
      }
    }
    return url;
  }

  Future<String?> getUrlServer(String url) async {
    RegExp regExp = new RegExp(r"^.*?://(.*?)\..*?$");
    RegExpMatch? match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  Future<String?> getUrlDomain(String url) async {
    RegExp regExp = new RegExp(r"^.*?://(.*?)/.*?$");
    RegExpMatch? match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }
}