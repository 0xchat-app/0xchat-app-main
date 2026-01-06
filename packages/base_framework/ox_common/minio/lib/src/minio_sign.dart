import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:minio/minio.dart';
import 'package:minio/src/minio_client.dart';
import 'package:minio/src/minio_helpers.dart';
import 'package:minio/src/utils.dart';

const signV4Algorithm = 'AWS4-HMAC-SHA256';

String signV4(
  Minio minio,
  MinioRequest request,
  DateTime requestDate,
  String region,
) {
  final signedHeaders = getSignedHeaders(request.headers.keys);
  final hashedPayload = request.headers['x-amz-content-sha256'];
  final canonicalRequest =
      getCanonicalRequest(request, signedHeaders, hashedPayload!);
  final stringToSign = getStringToSign(canonicalRequest, requestDate, region);
  final signingKey = getSigningKey(requestDate, region, minio.secretKey);
  final credential = getCredential(minio.accessKey, region, requestDate);
  final signature = hex.encode(
    Hmac(sha256, signingKey).convert(stringToSign.codeUnits).bytes,
  );
  return '$signV4Algorithm Credential=$credential, SignedHeaders=${signedHeaders.join(';').toLowerCase()}, Signature=$signature';
}

List<String> getSignedHeaders(Iterable<String> headers) {
  const ignored = {
    'authorization',
    'content-length',
    'content-type',
    'user-agent'
  };
  final result = headers.where((header) => !ignored.contains(header)).toList();
  result.sort();
  return result;
}

String getCanonicalRequest(
  MinioRequest request,
  List<String> signedHeaders,
  String hashedPayload,
) {
  final requestResource = encodePath(request.url);
  final headers = signedHeaders.map(
    (header) => '${header.toLowerCase()}:${request.headers[header]}',
  );

  final queryKeys = request.url.queryParameters.keys.toList();
  queryKeys.sort();
  final requestQuery = queryKeys.map((key) {
    final value = request.url.queryParameters[key];
    final hasValue = value != null;
    final valuePart = hasValue ? encodeCanonicalQuery(value!) : '';
    return encodeCanonicalQuery(key) + '=' + valuePart;
  }).join('&');

  final canonical = [];
  canonical.add(request.method.toUpperCase());
  canonical.add(requestResource);
  canonical.add(requestQuery);
  canonical.add(headers.join('\n') + '\n');
  canonical.add(signedHeaders.join(';').toLowerCase());
  canonical.add(hashedPayload);
  return canonical.join('\n');
}

String getStringToSign(
  String canonicalRequest,
  DateTime requestDate,
  String region,
) {
  final hash = sha256Hex(canonicalRequest);
  final scope = getScope(region, requestDate);
  final stringToSign = [];
  stringToSign.add(signV4Algorithm);
  stringToSign.add(makeDateLong(requestDate));
  stringToSign.add(scope);
  stringToSign.add(hash);
  return stringToSign.join('\n');
}

String getScope(String region, DateTime date) {
  return '${makeDateShort(date)}/$region/s3/aws4_request';
}

List<int> getSigningKey(DateTime date, String region, String secretKey) {
  final dateLine = makeDateShort(date);
  final key1 = ('AWS4' + secretKey).codeUnits;
  final hmac1 = Hmac(sha256, key1).convert(dateLine.codeUnits).bytes;
  final hmac2 = Hmac(sha256, hmac1).convert(region.codeUnits).bytes;
  final hmac3 = Hmac(sha256, hmac2).convert('s3'.codeUnits).bytes;
  return Hmac(sha256, hmac3).convert('aws4_request'.codeUnits).bytes;
}

String getCredential(String accessKey, String region, DateTime requestDate) {
  return '$accessKey/${getScope(region, requestDate)}';
}

// returns a presigned URL string
String presignSignatureV4(
  Minio minio,
  MinioRequest request,
  String region,
  DateTime requestDate,
  int expires,
) {
  if (expires < 1) {
    throw MinioExpiresParamError('expires param cannot be less than 1 seconds');
  }
  if (expires > 604800) {
    throw MinioExpiresParamError('expires param cannot be greater than 7 days');
  }

  final iso8601Date = makeDateLong(requestDate);
  final signedHeaders = getSignedHeaders(request.headers.keys);
  final credential = getCredential(minio.accessKey, region, requestDate);

  final requestQuery = <String, String?>{};
  requestQuery['X-Amz-Algorithm'] = signV4Algorithm;
  requestQuery['X-Amz-Credential'] = credential;
  requestQuery['X-Amz-Date'] = iso8601Date;
  requestQuery['X-Amz-Expires'] = expires.toString();
  requestQuery['X-Amz-SignedHeaders'] = signedHeaders.join(';').toLowerCase();
  if (minio.sessionToken != null) {
    requestQuery['X-Amz-Security-Token'] = minio.sessionToken;
  }

  request = request.replace(
    url: request.url.replace(queryParameters: {
      ...request.url.queryParameters,
      ...requestQuery,
    }),
  );

  final canonicalRequest =
      getCanonicalRequest(request, signedHeaders, 'UNSIGNED-PAYLOAD');

  final stringToSign = getStringToSign(canonicalRequest, requestDate, region);
  final signingKey = getSigningKey(requestDate, region, minio.secretKey);
  final signature = sha256HmacHex(stringToSign, signingKey);
  final presignedUrl = request.url.toString() + '&X-Amz-Signature=$signature';

  return presignedUrl;
}

// calculate the signature of the POST policy
String postPresignSignatureV4(
  String region,
  DateTime date,
  String secretKey,
  String policyBase64,
) {
  final signingKey = getSigningKey(date, region, secretKey);
  return sha256HmacHex(policyBase64, signingKey);
}
