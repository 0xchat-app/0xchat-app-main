import 'package:minio/models.dart';
import 'package:minio/src/minio_client.dart';
import 'package:minio/src/minio_helpers.dart';

class MinioError {
  MinioError(this.message);

  final String? message;

  @override
  String toString() {
    return 'MinioError: $message';
  }
}

class MinioAnonymousRequestError extends MinioError {
  MinioAnonymousRequestError(String message) : super(message);
}

class MinioInvalidArgumentError extends MinioError {
  MinioInvalidArgumentError(String message) : super(message);
}

class MinioInvalidPortError extends MinioError {
  MinioInvalidPortError(String message) : super(message);
}

class MinioInvalidEndpointError extends MinioError {
  MinioInvalidEndpointError(String message) : super(message);
}

class MinioInvalidBucketNameError extends MinioError {
  MinioInvalidBucketNameError(String message) : super(message);

  static void check(String bucket) {
    if (isValidBucketName(bucket)) return;
    throw MinioInvalidBucketNameError('Invalid bucket name: $bucket');
  }
}

class MinioInvalidObjectNameError extends MinioError {
  MinioInvalidObjectNameError(String message) : super(message);

  static void check(String object) {
    if (isValidObjectName(object)) return;
    throw MinioInvalidObjectNameError('Invalid object name: $object');
  }
}

class MinioAccessKeyRequiredError extends MinioError {
  MinioAccessKeyRequiredError(String message) : super(message);
}

class MinioSecretKeyRequiredError extends MinioError {
  MinioSecretKeyRequiredError(String message) : super(message);
}

class MinioExpiresParamError extends MinioError {
  MinioExpiresParamError(String message) : super(message);
}

class MinioInvalidDateError extends MinioError {
  MinioInvalidDateError(String message) : super(message);
}

class MinioInvalidPrefixError extends MinioError {
  MinioInvalidPrefixError(String message) : super(message);

  static void check(String prefix) {
    if (isValidPrefix(prefix)) return;
    throw MinioInvalidPrefixError('Invalid prefix: $prefix');
  }
}

class MinioInvalidBucketPolicyError extends MinioError {
  MinioInvalidBucketPolicyError(String message) : super(message);
}

class MinioIncorrectSizeError extends MinioError {
  MinioIncorrectSizeError(String message) : super(message);
}

class MinioInvalidXMLError extends MinioError {
  MinioInvalidXMLError(String message) : super(message);
}

class MinioS3Error extends MinioError {
  MinioS3Error(String? message, [this.error, this.response]) : super(message);

  Error? error;

  MinioResponse? response;
}
