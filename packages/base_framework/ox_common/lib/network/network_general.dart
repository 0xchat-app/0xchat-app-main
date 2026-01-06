import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/network/network_interceptor.dart';
import 'package:ox_common/utils/encrypt_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_network/network_manager.dart';
import './network_adapter.dart';

// General
const RESPONSE_CODE_SUCCESS = '000000';
const RESPONSE_CODE_ERROR = '900001';

const String ErrorGeneralHint = 'Network connection failed, please try again later!';

extension General on OXNetwork {
  /// key: Specifies that the back end returns code, value: processing operations
  static Map<String, VoidCallback> proxyMap = {};

  void addProxy({required String code, required VoidCallback fn}) {
    proxyMap[code] = fn;
  }


  Future<OXResponse> doRequest(
    BuildContext? context, {
    String url = '',
    Map<String, String>? header,
    RequestType type = RequestType.POST,
    Map<String, dynamic>? params,
    bool useCache = false,
    bool showLoading = false,
    bool showErrorToast = false,
    bool showMessageToast = false,
    bool canceledOnTouchOutside = false,
    bool needRSA = false,
    bool useCodeHandleProxy = true,
    bool needCommonParams = true,
    bool needHost = true,
    String? contentType,
    Function(NetworkResponse response)? useCacheCallback,
  }) async {
    final _showLoading = showLoading && context != null;
    final _showErrorToast = showErrorToast && context != null;
    final _showMessageToast = showMessageToast && context != null;

    params ??= {};

    if(contentType == null) {
      if(type == RequestType.POST) {
        contentType = OXNetwork.CONTENT_TYPE_JSON;
      } else {
        contentType = OXNetwork.CONTENT_TYPE_FORM_URLENCODED;
      }
    }

    if (needCommonParams) {
      // Request parameter, preprocessing
      if ((params['token'] ?? '').length == 0) {
        params['token'] = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
      }
      if ((params['userId'] ?? '').length == 0) {
        params['userId'] =
            OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
      }
    }
    if (_showLoading) {
      OXLoading.show(status: Localized.text('ox_common.loading'));
    }
    try {
      if (needHost) {
        if (url.isNotEmpty) {
          final result = await NetworkInterceptor.modifyRequest(url: url, headers: header);
          url = result.url;
          header = result.headers;
        }
      }
      NetworkResponse result = await OXNetwork.instance.request(context,
          url: url,
          header: await getRequestHeaders(params, header),
          data: params,
          requestType: type,
          showLoading: false,
          showError: false,
          useCache: useCache,
          contentType: contentType,
          useCacheCallback: useCacheCallback);
      dynamic data;
      if (result.data is String) {
        // The contentType of some interfaces is faulty, causing the data processed by the core layer to be String
        try {
          data = convert.jsonDecode(result.data);
        } catch (e) {
          data = result.data;
        }
      }
      if (result.data is Map) {
        data = result.data;
      }
      late OXResponse response;
      if (result.code != NetworkCode.SUCCESS || data == null) {
        response = generalErrorResponse(data);
      } else {
        response = OXNetworkResponseAdapter.responseModelWithInfo(data);
      }
      if (useCodeHandleProxy) {
        proxyMap.forEach((code, handle) {
          if (response.code == code) handle();
        });
      }

      if (response.code == RESPONSE_CODE_SUCCESS) {
        if (_showLoading) OXLoading.dismiss();
        if (_showMessageToast)
          CommonToast.instance.show(context, response.message);
        return response;
      } else {
        throw response;
      }
    } catch (error) {

      if (_showLoading) OXLoading.dismiss();

      OXNetworkError networkError = handleError(error: error);

      if (_showErrorToast || _showMessageToast)
        CommonToast.instance.show(context, networkError.message);

      return Future.error(networkError);
    }
  }

  /// [Usage]:
  /// OXNetwork.instance.doUpload(
  /// context,
  /// url: '',
  /// fileList: List<FileModule>
  /// method: '',
  /// params: {
  /// 'uniqueId': length,
  /// 'type': '2',
  /// }
  /// ).then((OXResponse response) {
  /// }
  /// }).catchError((e) {
  /// });
  Future<OXResponse> doUpload(
    BuildContext? context, {
    String method = '',
    String url = '',
    required List<FileModule> fileList,
    RequestType type = RequestType.POST,
    Map<String, dynamic>? params,
    bool useCache = false,
    bool showLoading = false,
    bool showErrorToast = false,
    bool showMessageToast = false,
    bool canceledOnTouchOutside = false,
    bool needRSA = false,
    Function(NetworkResponse response)? useCacheCallback,
      ProgressCallback? progressCallback
  }) async {
    final _showLoading = showLoading && context != null;
    final _showErrorToast = showErrorToast && context != null;
    final _showMessageToast = showMessageToast && context != null;

    params ??= {};

    // Request parameter , preprocessing
    if ((params['token'] ?? '').length == 0) {
      params['token'] = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    }
    if ((params['userId'] ?? '').length == 0) {
      params['userId'] =
          OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    }
    if (_showLoading) {
      OXLoading.show();
    }
    try {
      NetworkResponse result = await OXNetwork.instance.upload(
          context, url, fileList,
          header: await getRequestHeaders(params),
          data: params,
          requestType: type,
          showLoading: false,
          showError: false,
          useCache: useCache,
          useCacheCallback: useCacheCallback,
        progressCallback: progressCallback
      );

      dynamic data;
      if (result.data is String) {
        // The contentType of some interfaces is faulty, causing the data processed by the core layer to be String
        try {
          data = convert.jsonDecode(result.data);
        } catch (e) {
          data = result.data;
        }
      }
      if (result.data is Map) {
        data = result.data;
      }

      late OXResponse response;
      if (result.code != NetworkCode.SUCCESS || data == null) {
        response = generalErrorResponse(data);
      } else {
        response = OXNetworkResponseAdapter.responseModelWithInfo(data);
      }

      if (response.code == RESPONSE_CODE_SUCCESS) {
        if (_showLoading) OXLoading.dismiss();
        if (_showMessageToast)
          CommonToast.instance.show(context, response.message);
        return response;
      } else {
        throw response;
      }
    } catch (error) {
      if (_showLoading) OXLoading.dismiss();

      OXNetworkError networkError = handleError(error: error);

      if (_showErrorToast || _showMessageToast)
        CommonToast.instance.show(context, networkError.message);

      return Future.error(networkError);
    }
  }

  Future<Response?> doDownload(String urlPath, String savePath,
      {bool showLoading = true,
      bool showError = true,
      BuildContext? context,
      String? downloadText,
      ProgressCallback? progressCallback}) async {
    final _showLoading = showLoading && (context != null);
    final _showError = showError && (context != null);

    try {
      if (_showLoading) {
        OXLoading.showProgress(
            status: downloadText ??
                "${Localized.text('ox_common.downloading')}...");
      }
      Response? result = await OXNetwork.instance.downLoad(urlPath, savePath,
          progressCallback: (count, total) {
        if (_showLoading) {
          OXLoading.showProgress(
              process: count / total,
              status: downloadText ??
                  "${Localized.text('ox_common.downloading')}${((count / total) * 100).toInt()}%...");
        }
        if (progressCallback != null) {
          progressCallback(count, total);
        }
      });

      if (_showLoading) OXLoading.dismiss();
      return result;
    } on DioError catch (e) {
      if (_showError)
        CommonToast.instance
            .show(context, Localized.text('ox_common.download_fail'));
      if (_showLoading) OXLoading.dismiss();
      return e.response;
    }
  }

  OXResponse generalErrorResponse(data) => OXResponse(
      code: RESPONSE_CODE_ERROR,
      message: Localized.text('ox_common.network_connect_fail'),
      data: data);

  OXNetworkError handleError({dynamic error}) {
    OXResponse response =
        error is OXResponse ? error : generalErrorResponse(null);
    return OXNetworkError(
        code: response.code,
        message: response.message,
        data: response.data,
        error: error is! OXResponse ? error : null);
  }

  Future<Map<String, dynamic>> getRequestHeaders(Map<String, dynamic>? params, [Map<String, dynamic>? headers]) async {

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final defaultHeaders = {
      'version': packageInfo.version,
      'osType': Platform.isAndroid ? '1' : '2',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    final Map<String, dynamic> allParams = {}
      ..addAll(params ?? {});
    allParams.addAll(defaultHeaders);
    // Sign
    final keys = allParams.keys.toList()..sort();
    final keyValues = keys.map((key) {
      final value = allParams[key];
      var valueString = '';
      if (value is List || value is Map) {
        valueString = convert.jsonEncode(value);
      } else {
        valueString = value.toString();
      }
      return '$key=$valueString';
    }).toList()..add(CommonConstant.serverSignKey);
    final string = keyValues.join('&');
    String sign = EncryptUtils.generateMd5(string);

    final Map<String, dynamic> result = {}..addAll(defaultHeaders);
    result['sign'] = sign;
    result..addAll(headers ?? {});
    return result;
  }
}

class OXResponse {
  OXResponse({required this.code, this.message = '', this.data});

  String code; // Business Status Code
  String message; // Business message
  dynamic data; // Business data result(jsomMap)
  bool get isSuccess => code == RESPONSE_CODE_SUCCESS;

  OXResponse.fromJson(Map<String, dynamic> jsonMap)
      : code = jsonMap['code'],
        message = jsonMap['message'],
        data = jsonMap['data'];

  @override
  String toString() =>
      ' code: $code, message: $message, data: ${data.toString()}';
}

class OXNetworkError extends Error {
  OXNetworkError({
    required this.code,
    this.data,
    this.message = '',
    this.error,
  });

  String code; // Business Status Code
  String message; // Business message
  dynamic data; // Business data result(jsomMap)
  dynamic error;

  @override
  String toString() =>
      ' code: $code, message: $message, data: ${data.toString()}, error: $error';
}
