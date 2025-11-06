import 'dart:async';
import 'dart:io';
import 'package:chatcore/chat-core.dart' hide ProxySettings;
import 'package:ox_common/log_util.dart';
import 'package:tor/tor.dart';
import 'package:socks5_proxy/socks.dart';

class OXHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context)
      ..badCertificateCallback = badCertificateHandler
      ..connectionFactory = (uri, proxyHost, proxyPort) async {
        ProxySettings? proxy = getProxySetting(uri, context);
        final socket = createSocket(uri: uri, proxy: proxy, context: context);
        return ConnectionTask.fromSocket(socket, () async => (await socket).close().ignore());
      };
    return client;
  }

  bool badCertificateHandler(X509Certificate cert, String host, int port) => true;

  ProxySettings? getProxySetting(Uri uri, SecurityContext? context) {
    final settings = Config.sharedInstance.getProxy();
    final shouldUseTor = settings.turnOnTor || TorNetworkHelper.shouldUseTor(uri.toString());
    if (shouldUseTor) {
      LogUtil.d('[OXHttpOverrides] Using Tor proxy');
      return getTorProxy(context);
    } else if (settings.turnOnProxy) {
      if (settings.useSystemProxy) {
        LogUtil.d('[OXHttpOverrides] Using system proxy');
        return getSystemProxy(context);
      } else {
        LogUtil.d('[OXHttpOverrides] Using custom proxy');
        return ProxySettings(
            InternetAddress(settings.socksProxyHost),
            settings.socksProxyPort,
            context: context
        );
      }
    }
    LogUtil.d('[OXHttpOverrides] Using direct');
    return null;
  }

  ProxySettings? getTorProxy(SecurityContext? context) {
    if (!TorNetworkHelper.isTorEnabled) {
      LogUtil.d('[OXHttpOverrides] Tor not enabled');
      return null;
    }

    return ProxySettings(
      TorNetworkHelper.torProxyHost,
      TorNetworkHelper.torProxyPort,
      context: context,
    );
  }

  ProxySettings? getSystemProxy(SecurityContext? context) {
    final systemProxy = Tor.instance.currentSystemProxy();
    if (systemProxy == null) return null;

    return ProxySettings(
      InternetAddress(systemProxy.address),
      systemProxy.port,
      context: context,
    );
  }

  Future<Socket> createSocket({
    required Uri uri,
    required ProxySettings? proxy,
    SecurityContext? context,
  }) async {
    final isSecure = uri.scheme == 'https';
    var uriPort = uri.port;
    if (uriPort == 0) {
      uriPort = isSecure ? 443 : 80;
    }

    if (proxy != null) {
      final client = await SocksTCPClient.connect(
        [proxy],
        InternetAddress(uri.host, type: InternetAddressType.unix),
        uriPort,
      );

      // Secure connection after establishing Socks connection
      if (isSecure) {
        return client.secure(
          uri.host,
          context: context,
          onBadCertificate: (cer) => badCertificateHandler(cer, uri.host, uriPort),
        );
      }

      return client;
    }

    if (isSecure) {
      return SecureSocket.connect(
        uri.host,
        uriPort,
        context: context,
        onBadCertificate: (cer) => badCertificateHandler(cer, uri.host, uriPort),
      );
    }

    return Socket.connect(uri.host, uriPort);
  }
}