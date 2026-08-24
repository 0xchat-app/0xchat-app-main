
import '../utils/network/http_client.dart';
import '../utils/network/network_interceptor.dart';

class CashuConfig {
  static addNetworkInterceptor(NetworkInterceptor interceptor) {
    HTTPClient.shared.interceptor = interceptor;
  }
}