
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../log_util.dart';
import 'network_interceptor.dart';
import 'request_data.dart';
import 'response.dart';

export 'response.dart';

class HTTPClient {
  static final HTTPClient shared = HTTPClient._internal();
  HTTPClient._internal();

  NetworkInterceptor? interceptor;

  static Future<CashuResponse<T>> get<T>(
      String url, {
        Map<String, String>? query,
        T? Function(dynamic json)? modelBuilder,
        int? timeOut = 15,
      }) async {
    return HTTPClient.shared._get(
      url,
      query: query,
      modelBuilder: modelBuilder,
      timeOut: timeOut,
    );
  }

  static Future<CashuResponse<T>> post<T>(
      String url, {
        Map<String, String>? query,
        Map<String, dynamic>? params,
        T? Function(dynamic json)? modelBuilder,
        int? timeOut = 15,
      }) async {
    return HTTPClient.shared._post(
      url,
      query: query,
      params: params,
      modelBuilder: modelBuilder,
      timeOut: timeOut,
    );
  }

  Future<CashuResponse<T>> _get<T>(
      String url, { 
        Map<String, String>? query, 
        T? Function(dynamic json)? modelBuilder,
        int? timeOut,
      }) async {

    final requestData = await createRequestData(
      url: url,
      method: RequestMethod.get,
      query: query,
    );

    try {
      final logPrefix = '[http - ${requestData.method.text}] uri: ${requestData.uri}';
      LogUtils.i(() => '$logPrefix, request: ${requestData.body}');
      final response = await request(requestData, timeOut: timeOut);
      return handleWithResponse(
        requestData: requestData,
        response: response,
        modelBuilder: modelBuilder,
      );
    } catch(e, stackTrace) {
      LogUtils.e(() => '[http - error] uri: ${requestData.uri}, e: $e, $stackTrace');
      return CashuResponse.fromErrorMsg(e.toString());
    }
  }

  Future<CashuResponse<T>> _post<T>(
      String url, {
        Map<String, String>? query,
        Map<String, dynamic>? params,
        T? Function(dynamic json)? modelBuilder,
        int? timeOut,
      }) async {

    final requestData = await createRequestData(
      url: url,
      method: RequestMethod.post,
      query: query,
      params: params,
    );

    try {
      final logPrefix = '[http - ${requestData.method.text}] uri: ${requestData.uri}';
      LogUtils.i(() => '$logPrefix, request: ${requestData.body}');
      final response = await request(requestData, timeOut: timeOut);
      return handleWithResponse(
        requestData: requestData,
        response: response,
        modelBuilder: modelBuilder,
      );
    } catch(e, stackTrace) {
      LogUtils.e(() => '[http - error] uri: ${requestData.uri}, e: $e, $stackTrace');
      return CashuResponse.fromErrorMsg(e.toString());
    }
  }

  Future<RequestData> createRequestData({
    required String url,
    required RequestMethod method,
    Map<String, String>? query,
    Map<String, dynamic>? params,
  }) async {
    var requestData = RequestData(
      url: url,
      method: method,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      queryParams: query,
      body: params,
    );

    final interceptor = this.interceptor;
    if (interceptor != null) {
      requestData = await interceptor.modifyRequest.call(requestData);
    }

    return requestData;
  }

  Future<http.Response> request(RequestData requestData, {int? timeOut,}) {
    Future<http.Response> request;
    switch (requestData.method) {
      case RequestMethod.get:
        request = http.get(
          requestData.uri,
          headers: requestData.headers,
        );
        break ;
      case RequestMethod.post:
        request = http.post(
          requestData.uri,
          body: jsonEncode(requestData.body),
          headers: requestData.headers,
        );
        break ;
    }
    if (timeOut != null) {
      request = request.timeout(Duration(seconds: timeOut), onTimeout: () {
        throw TimeoutException('The connection has timed out, Please try again!');
      });
    }

    return request;
  }

  Future<CashuResponse<T>> handleWithResponse<T>({
    required RequestData requestData,
    required http.Response response,
    T? Function(dynamic json)? modelBuilder,
  }) async {
    final logPrefix = '[http - ${requestData.method.text}] uri: ${requestData.uri}';
    LogUtils.i(() => '$logPrefix, response: ${response.body}, status: ${response.statusCode}');

    if (response.statusCode == HttpStatus.ok) {
      final bodyJson = jsonDecode(response.body);
      final data = modelBuilder?.call(bodyJson);
      if (data != null) {
        return CashuResponse(
          code: ResponseCode.success,
          data: data,
        );
      }
    } else if (response.statusCode == HttpStatus.badRequest) {
      final bodyJson = jsonDecode(response.body);
      if (bodyJson is Map) {
        final code = bodyJson['code'];
        final detail = bodyJson['detail'];
        if (code != null) {
          return CashuResponse.fromErrorMap(bodyJson);
        } else if (detail != null) {
          final code = ResponseCodeEx.tryGetCodeWithErrorMsg(detail);
          if (code != null) {
            return CashuResponse(
              code: code,
              errorMsg: detail,
            );
          }
        }
      }
    }

    return CashuResponse.generalError();
  }
}