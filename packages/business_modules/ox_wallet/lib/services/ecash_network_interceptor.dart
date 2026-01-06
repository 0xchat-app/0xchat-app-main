
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_common/network/network_interceptor.dart' as common;

class EcashNetworkInterceptor with NetworkInterceptor {
  @override
  Future<RequestData> modifyRequest(RequestData requestData) async {
    final modifyResult = await common.NetworkInterceptor.modifyRequest(
      url: requestData.url,
      headers: requestData.headers,
    );
    return requestData.copyWith(
      url: modifyResult.url,
      headers: modifyResult.headers,
    );
  }
}