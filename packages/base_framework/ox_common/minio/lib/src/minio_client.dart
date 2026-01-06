import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:minio/minio.dart';
import 'package:minio/src/minio_helpers.dart';
import 'package:minio/src/minio_s3.dart';
import 'package:minio/src/minio_sign.dart';
import 'package:minio/src/utils.dart';

class MinioRequest extends BaseRequest {
  MinioRequest(String method, Uri url, {this.onProgress}) : super(method, url);

  dynamic body;

  final void Function(int)? onProgress;

  @override
  ByteStream finalize() {
    super.finalize();

    if (body == null) {
      return const ByteStream(Stream.empty());
    }

    late Stream<Uint8List> stream;

    if (body is Stream<Uint8List>) {
      stream = body;
    } else if (body is String) {
      final data = Utf8Encoder().convert(body);
      headers['content-length'] = data.length.toString();
      stream = Stream<Uint8List>.value(data);
    } else if (body is Uint8List) {
      stream = Stream<Uint8List>.value(body);
      headers['content-length'] = body.length.toString();
    } else {
      throw UnsupportedError('Unsupported body type: ${body.runtimeType}');
    }

    if (onProgress == null) {
      return ByteStream(stream);
    }

    var bytesRead = 0;

    stream = stream.transform(MaxChunkSize(1 << 16));

    return ByteStream(
      stream.transform(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add(data);
            bytesRead += data.length;
            onProgress!(bytesRead);
          },
        ),
      ),
    );
  }

  MinioRequest replace({
    String? method,
    Uri? url,
    Map<String, String>? headers,
    body,
  }) {
    final result = MinioRequest(method ?? this.method, url ?? this.url);
    result.body = body ?? this.body;
    result.headers.addAll(headers ?? this.headers);
    return result;
  }
}

/// An HTTP response where the entire response body is known in advance.
class MinioResponse extends BaseResponse {
  /// The bytes comprising the body of this response.
  final Uint8List bodyBytes;

  /// Body of s3 response is always encoded as UTF-8.
  String get body => utf8.decode(bodyBytes);

  /// Create a new HTTP response with a byte array body.
  MinioResponse.bytes(
    this.bodyBytes,
    int statusCode, {
    BaseRequest? request,
    Map<String, String> headers = const {},
    bool isRedirect = false,
    bool persistentConnection = true,
    String? reasonPhrase,
  }) : super(statusCode,
            contentLength: bodyBytes.length,
            request: request,
            headers: headers,
            isRedirect: isRedirect,
            persistentConnection: persistentConnection,
            reasonPhrase: reasonPhrase);

  static Future<MinioResponse> fromStream(StreamedResponse response) async {
    final body = await response.stream.toBytes();
    return MinioResponse.bytes(body, response.statusCode,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase);
  }
}

class MinioClient {
  MinioClient(this.minio) {
    anonymous = minio.accessKey.isEmpty && minio.secretKey.isEmpty;
    enableSHA256 = !anonymous && !minio.useSSL;
    port = minio.port;
  }

  final Minio minio;
  final String userAgent = 'MinIO (Unknown; Unknown) minio-dart/2.0.0';

  late bool enableSHA256;
  late bool anonymous;
  late final int port;

  Future<StreamedResponse> _request({
    required String method,
    String? bucket,
    String? object,
    String? region,
    String? resource,
    dynamic payload = '',
    Map<String, dynamic>? queries,
    Map<String, String>? headers,
    void Function(int)? onProgress,
  }) async {
    if (bucket != null) {
      region ??= await minio.getBucketRegion(bucket);
    }

    region ??= 'us-east-1';

    final request = getBaseRequest(
        method, bucket, object, region, resource, queries, headers, onProgress);
    request.body = payload;

    final date = DateTime.now().toUtc();
    final sha256sum = enableSHA256 ? sha256Hex(payload) : 'UNSIGNED-PAYLOAD';
    request.headers.addAll({
      'user-agent': userAgent,
      'x-amz-date': makeDateLong(date),
      'x-amz-content-sha256': sha256sum,
    });

    final authorization = signV4(minio, request, date, region);
    request.headers['authorization'] = authorization;

    logRequest(request);
    final response = await request.send();
    return response;
  }

  Future<MinioResponse> request({
    required String method,
    String? bucket,
    String? object,
    String? region,
    String? resource,
    dynamic payload = '',
    Map<String, dynamic>? queries,
    Map<String, String>? headers,
    void Function(int)? onProgress,
  }) async {
    final stream = await _request(
      method: method,
      bucket: bucket,
      object: object,
      region: region,
      payload: payload,
      resource: resource,
      queries: queries,
      headers: headers,
      onProgress: onProgress,
    );

    final response = await MinioResponse.fromStream(stream);
    logResponse(response);

    return response;
  }

  Future<StreamedResponse> requestStream({
    required String method,
    String? bucket,
    String? object,
    String? region,
    String? resource,
    dynamic payload = '',
    Map<String, dynamic>? queries,
    Map<String, String>? headers,
  }) async {
    final response = await _request(
      method: method,
      bucket: bucket,
      object: object,
      region: region,
      payload: payload,
      resource: resource,
      queries: queries,
      headers: headers,
    );

    logResponse(response);
    return response;
  }

  MinioRequest getBaseRequest(
    String method,
    String? bucket,
    String? object,
    String region,
    String? resource,
    Map<String, dynamic>? queries,
    Map<String, String>? headers,
    void Function(int)? onProgress,
  ) {
    final url = getRequestUrl(bucket, object, resource, queries);
    final request = MinioRequest(method, url, onProgress: onProgress);
    request.headers['host'] = url.authority;

    if (headers != null) {
      request.headers.addAll(headers);
    }

    return request;
  }

  Uri getRequestUrl(
    String? bucket,
    String? object,
    String? resource,
    Map<String, dynamic>? queries,
  ) {
    var host = minio.endPoint.toLowerCase();
    var path = '/';

    if (isAmazonEndpoint(host)) {
      host = getS3Endpoint(minio.region!);
    }

    if (isVirtualHostStyle(host, minio.useSSL, bucket)) {
      if (bucket != null) host = '$bucket.$host';
      if (object != null) path = '/$object';
    } else {
      if (bucket != null) path = '/$bucket';
      if (object != null) path = '/$bucket/$object';
    }

    final query = StringBuffer();
    if (resource != null) {
      query.write(resource);
    }
    if (queries != null) {
      if (query.isNotEmpty) query.write('&');
      query.write(encodeQueries(queries));
    }

    return Uri(
      scheme: minio.useSSL ? 'https' : 'http',
      host: host,
      port: minio.port,
      pathSegments: path.split('/'),
      query: query.toString(),
    );
  }

  void logRequest(MinioRequest request) {
    if (!minio.enableTrace) return;

    final buffer = StringBuffer();
    buffer.writeln('REQUEST: ${request.method} ${request.url}');
    for (var header in request.headers.entries) {
      buffer.writeln('${header.key}: ${header.value}');
    }

    if (request.body is List<int>) {
      buffer.writeln('List<int> of size ${request.body.length}');
    } else {
      buffer.writeln(request.body);
    }

    print(buffer.toString());
  }

  void logResponse(BaseResponse response) {
    if (!minio.enableTrace) return;

    final buffer = StringBuffer();
    buffer.writeln('RESPONSE: ${response.statusCode} ${response.reasonPhrase}');
    for (var header in response.headers.entries) {
      buffer.writeln('${header.key}: ${header.value}');
    }

    if (response is Response) {
      buffer.writeln(response.body);
    } else if (response is StreamedResponse) {
      buffer.writeln('STREAMED BODY');
    }

    print(buffer.toString());
  }
}
