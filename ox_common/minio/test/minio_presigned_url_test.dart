import 'package:minio/minio.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  test('Minio.presignedGetObject() works', () async {
    final minio = getMinioClient();
    await minio.presignedGetObject('bucket', 'object');
  });

  test('Minio.presignedGetObject() throws when [expires] < 0', () async {
    final minio = getMinioClient();
    expect(
      () => minio.presignedGetObject('bucket', 'object', expires: -1),
      throwsA(isA<MinioError>()),
    );
  });

  test('Minio.presignedPutObject() works', () async {
    final minio = getMinioClient();
    await minio.presignedPutObject('bucket', 'object');
  });

  test('Minio.presignedPutObject() throws when [expires] < 0', () async {
    final minio = getMinioClient();
    expect(
      () => minio.presignedPutObject('bucket', 'object', expires: -1),
      throwsA(isA<MinioError>()),
    );
  });
}
