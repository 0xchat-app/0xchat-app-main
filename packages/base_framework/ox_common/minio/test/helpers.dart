import 'dart:math';

import 'package:minio/minio.dart';

/// Initializes an instance of [Minio] with per default valid configuration.
///
/// Don't worry, these credentials for MinIO are publicly available and
/// connect only to the MinIO demo server at `play.minio.io`.
Minio getMinioClient({
  String endpoint = 'play.minio.io',
  int? port = 443,
  bool useSSL = true,
  String accessKey = 'Q3AM3UQ867SPQQA43P2F',
  String secretKey = 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG',
  String sessionToken = '',
  String region = 'us-east-1',
  bool enableTrace = false,
}) =>
    Minio(
      endPoint: endpoint,
      port: port,
      useSSL: useSSL,
      accessKey: accessKey,
      secretKey: secretKey,
      sessionToken: sessionToken,
      region: region,
      enableTrace: enableTrace,
    );

/// Generates a random name for a bucket or object.
String uniqueName() {
  final random = Random();
  final now = DateTime.now();
  final name = 'id-${now.microsecondsSinceEpoch}-${random.nextInt(8192)}';
  return name;
}
