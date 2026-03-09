import 'dart:async';
import 'dart:io';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/foundation.dart';
import 'package:tor/proxy_support.dart';
import 'package:tor/tor.dart';

class TorNetworkHelper {

  static bool get isTorEnabled => Tor.instance.started && Tor.instance.bootstrapped;

  static InternetAddress get torProxyHost => InternetAddress.loopbackIPv4;
  static int get torProxyPort => Tor.instance.port;

  static Future<void> initialize() async {
    try {
      await Tor.init(enabled: true);
    } catch (e) {
      if (kDebugMode) {
        LogUtils.e('Failed to initialize Tor: $e');
      }
      rethrow;
    }
  }

  static Future<void> start() async {
    try {
      await Tor.instance.start();
    } catch (e) {
      if (kDebugMode) {
        LogUtils.e('Failed to start Tor: $e');
      }
      rethrow;
    }
  }

  static Future<void> stop() async {
    await Tor.instance.stop();
  }

  static bool shouldUseTor(String url) {
    if (!isTorEnabled) return false;

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    // Always use Tor for .onion addresses
    if (uri.host.contains('.onion')) {
      return true;
    }

    // For other addresses, check if Tor is enabled globally
    return false;
  }

  static void updateCustomProxy(String address, int port) {
    Tor.instance.updateCustomProxy(
      ProxyInfo(
        address: address,
        port: port,
        type: ProxyType.socks5,
      ),
    );
  }

  static void clearCustomProxy() {
    Tor.instance.updateCustomProxy(null);
  }
}