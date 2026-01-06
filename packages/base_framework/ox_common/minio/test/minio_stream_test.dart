import 'dart:typed_data';

import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  group('MinioByteStream', () {
    final bucketName = uniqueName();
    final objectName = 'content-length-test';
    final testData = Uint8List.fromList([1, 2, 3, 4, 5]);

    setUpAll(() async {
      final minio = getMinioClient();
      await minio.makeBucket(bucketName);
      await minio.putObject(bucketName, objectName, Stream.value(testData));
    });

    tearDownAll(() async {
      final minio = getMinioClient();
      await minio.removeObject(bucketName, objectName);
      await minio.removeBucket(bucketName);
    });

    test('contains content length', () async {
      final minio = getMinioClient();
      final stream = await minio.getObject(bucketName, objectName);
      expect(stream.contentLength, equals(testData.length));
      await stream.drain();
    });
  });
}
