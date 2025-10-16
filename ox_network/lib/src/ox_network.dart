import 'dart:collection';
import 'dart:io';

// import 'package:dio/adapter.dart';
import 'package:dio/io.dart';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ox_network/network_manager.dart';
import 'package:ox_network/src/db_tools.dart';
import 'package:ox_network/src/utils/log_util.dart';
import 'package:ox_network/src/widgets/common_loading.dart';
import 'package:chatcore/chat-core.dart';
import 'dart:convert' as convert;

import 'package:ox_network/src/widgets/common_toast.dart';

///Network status codes
class NetworkCode {
  ///Network error
  static const NETWORK_ERROR = -1;

  ///Network timeout
  static const NETWORK_TIMEOUT = -2;

  ///Network JSON data formatting once
  static const NETWORK_JSON_EXCEPTION = -3;

  ///Network request parameter error
  static const NETWORK_PARAMS_EXCEPTION = -4;

  static const SUCCESS = 200;

  static errorHandleFunction(code, message, noTip) {
    if (noTip) {
      return message;
    }
    return message;
  }
}

enum RequestType {
  GET,
  POST,
  UPLOAD,
}

String _getRequestTypeString(RequestType type) {
  switch (type) {
    case RequestType.GET:
      return 'GET';
      break;
    case RequestType.POST:
      return 'POST';
      break;
    case RequestType.UPLOAD:
      return 'UPLOAD';
      break;
    default:
      return 'POST';
      break;
  }
}

///Title: ox_network
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2023
///@author George
class OXNetwork {
  static const String CONTENT_TYPE_JSON = 'application/json; charset=utf-8';
  static const String CONTENT_TYPE_FORM = "multipart/form-data";
  static const String CONTENT_TYPE_FORM_URLENCODED = "application/x-www-form-urlencoded; charset=utf-8";
  static const DEFAULT_TIMEOUT = 60 * 1000;

  static OXNetwork get instance => _singleton;

  static final OXNetwork _singleton = OXNetwork._init();
  late Dio _dio;
  late Options _option;

  factory OXNetwork() {
    return _singleton;
  }

  OXNetwork._init() {
    _dio = Dio();
    _option = Options(
      sendTimeout: Duration(seconds:60),
      receiveTimeout: Duration(seconds:60),
    );
  }

  void setupDio(String proxyAddress) {
    if (proxyAddress.length == 0) {
      return;
    }
    // Setting The proxy dio version 5.0.1 setting method is supported
    IOHttpClientAdapter adapter = IOHttpClientAdapter();
    adapter.onHttpClientCreate = (HttpClient client) {
      client.findProxy = (Uri url) {
        return HttpClient.findProxyFromEnvironment(url, environment: {
          'http_proxy': proxyAddress,
          'https_proxy': proxyAddress,
        });
      };
      client.authenticateProxy = (String host, int port, String scheme, String? realm) => Future.value(true);
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return null;
    };
    _dio.httpClientAdapter = adapter;
  }

  /// Setup Dio with Tor proxy support
  void setupDioWithTor(String url) {
    final torManager = TorNetworkManager.instance;
    if (!torManager.shouldUseTor(url)) {
      return;
    }

    IOHttpClientAdapter adapter = IOHttpClientAdapter();
    adapter.onHttpClientCreate = (HttpClient client) {
      client.findProxy = (Uri uri) {
        final proxyConfig = torManager.getProxyConfig(uri.toString());
        return proxyConfig ?? 'DIRECT';
      };
      client.authenticateProxy = (String host, int port, String scheme, String? realm) => Future.value(true);
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return null;
    };
    _dio.httpClientAdapter = adapter;
  }


  /// Initiates a network request
  ///
  /// url: Request URL
  /// data: Request parameters
  /// header: Request headers
  /// contentType: Content type
  /// requestType: Request method
  /// showLoading: Display loading indicator
  /// showError: Display error messages
  /// useCache: Whether to use caching, used in conjunction with useCacheCallback
  /// useCacheCallback: Callback after fetching local network cache
  Future<NetworkResponse> request(
    BuildContext? context, {
    String host = '',
    String method = '',
    String url = '',
    data,
    Map<String, dynamic>? header,
    String contentType = CONTENT_TYPE_FORM_URLENCODED,
    RequestType requestType = RequestType.POST,
    bool useCache = false,
    bool showLoading = true,
    bool showError = true,
    bool canceledOnTouchOutside = false,
    Function(NetworkResponse response)? useCacheCallback,
  }) async {
    if ((url.isEmpty) && (host.isEmpty) && (method.isEmpty)) {
      NetworkError error = new NetworkError(
        errorCode: NetworkCode.NETWORK_PARAMS_EXCEPTION,
        message: 'Request params error',
      );
      return Future.error(error);
    }
    if (url.isEmpty) {
      url = host + method;
    }
    String cacheKey = method;
    if (method.isEmpty) {
      cacheKey = url;
    }
    if (useCache && useCacheCallback != null) {
      // Get local cache network data
      _getDataFromCache(cacheKey, useCacheCallback);
    }
    String address = await OXNetworkPlugin.getProxyAddress(url);
    if (address.isNotEmpty || Platform.isMacOS) {
      setupDio(address);
    }
    
    // Setup Tor proxy if needed
    setupDioWithTor(url);

    final _showLoading = showLoading && (context != null);
    final _showError = showError && (context != null);
    // Determine network status
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      NetworkError error = new NetworkError(
        errorCode: NetworkCode.NETWORK_ERROR,
        message: '',
      );
      if (_showError) CommonToast.instance.show(context, 'Network Error');
      return Future.error(error);
    }
    if (_showLoading) {
      Navigator.push(context, DialogRouter(CommonLoading(canceledOnTouchOutside: canceledOnTouchOutside)));
    }
    Map<String, dynamic> headers = new HashMap();
    if (header != null) {
      headers = header;
    } else {
      headers['Content-Type'] = contentType;
    }

    if (requestType == RequestType.GET) {
      String fullUrl = '';
      if (data != null) {
        fullUrl += '?';
        data.forEach((key, value) {
          fullUrl += (key.toString() + '=' + value.toString());
          fullUrl += '&';
        });
        fullUrl = fullUrl.substring(0, fullUrl.length - 1);
      }
      url = url + fullUrl;
    }

    _option.headers = headers;
    if(requestType == RequestType.GET){
      _option.contentType = null;
    } else {
      _option.contentType = contentType;
    }
    _option.method = _getRequestTypeString(requestType);
    late Response response;
    try {
      response = await _dio.request(url, data: data, options: _option);
      LogUtil.log(key:'NetWork Request ==>>', content:'url: $url');
      // LogUtil.log(key:'NetWork Request ==>>', content:'data: $data');
      // LogUtil.log(key:'NetWork Request ==>>', content:'response: $response');
    } on DioError catch (e) {
      if (_showLoading) Navigator.pop(context);
      NetworkError error = handleError(e);
      if (_showError) CommonToast.instance.show(context, error.message);
      if (_showLoading) Navigator.pop(context);
      return NetworkResponse(
        NetworkCode.NETWORK_ERROR,
        '',
        error.message,
      );
    }
    if (useCache) {
      _saveDataToCache(cacheKey, response);
    }
    if (_showLoading) Navigator.pop(context);
    return NetworkResponse(
      response.statusCode ?? NetworkCode.NETWORK_ERROR,
      response.statusMessage ?? '',
      response.data,
    );
  }

  void _saveDataToCache(String cacheKey, Response response) async {
    if (!DBTools.instance.isOpen()) {
      await DBTools.instance.openDataDB(DBTools.instance.path, DBTools.instance.tableName);
    }
    DBTools.instance.createTable('cacheKey', 'cacheContent');
    Map<String, dynamic> responseJson = Map<String, dynamic>.from(response.data);
    String jsonString = convert.jsonEncode(responseJson);
    Map<String, dynamic> dataMap = {'cacheKey': cacheKey, 'cacheContent': jsonString};
    DBTools.instance.insert(DBTools.instance.tableName, dataMap);
  }

  void _getDataFromCache(String cacheKey, Function(NetworkResponse response) useCacheCallback) {
    try {
      new Future(() async {
        await DBTools.instance.openDataDB(DBTools.instance.path, DBTools.instance.tableName);
        DBTools.instance.createTable('cacheKey', 'cacheContent');
        List<Map<String, Object?>> result = await DBTools.instance.query(DBTools.instance.tableName, 'cacheKey', 'cacheContent', cacheKey);
        if (result.length > 0) {
          Map<String, dynamic> tempMap = result[0];
          String cacheData = tempMap['cacheContent'];
          Map<String, dynamic> cacheJson = convert.jsonDecode(cacheData);
          NetworkResponse cacheResponse = NetworkResponse(
            NetworkCode.SUCCESS,
            '',
            cacheJson,
          );
          useCacheCallback(cacheResponse);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  /// fileList The parameter is the entity class FileModule
  Future<NetworkResponse> upload(
    BuildContext? context,
    String url,
    List<FileModule> fileList, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? header,
    String contentType = CONTENT_TYPE_FORM_URLENCODED,
    RequestType requestType = RequestType.POST,
    bool useCache = false,
    bool showLoading = true,
    bool showError = true,
    bool canceledOnTouchOutside = false,
    Function(NetworkResponse response)? useCacheCallback,
   ProgressCallback? progressCallback
  }) async {
    if (url.isEmpty) {
      NetworkError error = new NetworkError(
        errorCode: NetworkCode.NETWORK_PARAMS_EXCEPTION,
        message: 'Request params error',
      );
      return Future.error(error);
    }
    String address = await OXNetworkPlugin.getProxyAddress(url);
    if (address.isNotEmpty || Platform.isMacOS) {
      setupDio(address);
    }
    
    // Setup Tor proxy if needed
    setupDioWithTor(url);

    final _showLoading = showLoading && (context != null);
    final _showError = showError && (context != null);
    // Determine network status
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      NetworkError error = new NetworkError(
        errorCode: NetworkCode.NETWORK_ERROR,
        message: '',
      );
      if (_showError) CommonToast.instance.show(context, 'Network Error');
      return Future.error(error);
    }
    if (_showLoading) {
      Navigator.push(context, DialogRouter(CommonLoading(canceledOnTouchOutside: canceledOnTouchOutside)));
    }
    Map<String, dynamic> headers = new HashMap();
    if (header != null) {
      headers = header;
    } else {
      headers['Content-Type'] = contentType;
    }
    List<MapEntry<String, MultipartFile>> listMapEntry = [];
    for (int i = 0; i < fileList.length; i++) {
      FileModule element = fileList[i];
      if (element.fileName.isNotEmpty && element.filePath.isNotEmpty) {
        String fileExt = element.fileName.substring(element.fileName.indexOf('.'));
        var file = MultipartFile.fromFileSync(
          element.filePath,
          filename: element.fileName,
          contentType: getMediaType(fileExt),
        );
        String fileKey = '';
        if (element.fileKey.isNotEmpty) {
          fileKey = element.fileKey;
        } else {
          fileKey = '_fma.pu._0.ima';
        }
        listMapEntry.add(MapEntry(
          fileKey,
          file,
        ));
      }
    }
    if (data == null) data = {};

    FormData formData = FormData.fromMap(data);
    formData.files.addAll(listMapEntry);
    _option.headers = headers;
    _option.contentType = contentType;
    _option.method = _getRequestTypeString(requestType);
    late Response response;
    try {
      response = await _dio.request(url, data: formData, options: _option, onSendProgress: (int count, int data) {
        progressCallback!(count, data);
      });
    } on DioError catch (e) {
      if (_showLoading) Navigator.pop(context);
      NetworkError error = handleError(e);
      if (_showError) CommonToast.instance.show(context, error.message);
      if (_showLoading) Navigator.pop(context);
      return NetworkResponse(
        NetworkCode.NETWORK_ERROR,
        '',
        error.message,
      );
    }

    if (_showLoading) Navigator.pop(context);

    return NetworkResponse(
      response.statusCode ?? NetworkCode.NETWORK_ERROR,
      response.statusMessage ?? '',
      response.data,
    );
  }

  // Request error handling
  static NetworkError handleError(DioError error) {
    String message = 'unknow error';
    num errorCode = 999999;
    if (error.response != null) {
      Map<String, dynamic> map = Map<String, dynamic>.from(error.response!.data);
      var errorResponse = map['resMsg'];
      if (errorResponse != null) {
        if (errorResponse is Map) {
          errorCode = errorResponse['code'] as num;
          message = errorResponse['message'].toString();
        } else if (errorResponse is String) {
          errorCode = error.response!.statusCode!;
          message = errorResponse;
        }
      }
    } else    message = error.toString();
  
    return NetworkError(
      errorCode: errorCode,
      message: message,
    );
  }

  Future<Response?> downLoad(String urlPath, String savePath,
      {BuildContext? context, ProgressCallback? progressCallback}) async {

    try {
      Response result = await _dio.download(urlPath, savePath, onReceiveProgress: (int count, int total) {
        if (progressCallback != null) {
          progressCallback(count, total);
        }
      });

      return result;
    } on DioError catch (e) {
      return e.response;
    }
  }

  //fileExt File suffix
  MediaType getMediaType(final String fileExt) {
    switch (fileExt.toLowerCase()) {
      case ".jpg":
      case ".jpeg":
      case ".jpe":
        return new MediaType("image", "jpeg");
      case ".png":
        return new MediaType("image", "png");
      case ".bmp":
        return new MediaType("image", "bmp");
      case ".gif":
        return new MediaType("image", "gif");
      case ".json":
        return new MediaType("application", "json");
      case ".svg":
      case ".svgz":
        return new MediaType("image", "svg+xml");
      case ".mp3":
        return new MediaType("audio", "mpeg");
      case ".mp4":
        return new MediaType("video", "mp4");
      case ".mov":
        return new MediaType("video", "mov");
      case ".htm":
      case ".html":
        return new MediaType("text", "html");
      case ".css":
        return new MediaType("text", "css");
      case ".csv":
        return new MediaType("text", "csv");
      case ".txt":
      case ".text":
      case ".conf":
      case ".def":
      case ".log":
      case ".in":
        return new MediaType("text", "plain");
    }
    return new MediaType("image", "png");
  }
}

class NetworkResponse {
  int code; // Business Status Code
  String message; // Business message
  dynamic data; // Business data result

  NetworkResponse([
    this.code = 200,
    this.message = '',
    this.data,
  ]);

  @override
  String toString() => 'code: $code, message: $message, data: $data';
}

class NetworkError extends Error {
  num errorCode; // error code
  String message; // Business message

  NetworkError({
    this.errorCode = 99999,
    this.message = '',
  });

  @override
  String toString() => 'code: $errorCode, message: $message';
}

class FileModule {
  String fileKey;
  String filePath;
  String fileName;

  // String mimeType;

  FileModule({
    required this.fileKey,
    required this.filePath,
    required this.fileName,
  });

  ///             "fileKey": 'file',
  ///             "filePath": _imgFile.path,
  ///             "fileName": "video.mp4"
  ///             "mimeType": "mp4"
}
