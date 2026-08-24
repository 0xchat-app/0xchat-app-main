
import 'request_data.dart';

abstract mixin class NetworkInterceptor {
  Future<RequestData> modifyRequest(RequestData requestData) async =>
      requestData;
}