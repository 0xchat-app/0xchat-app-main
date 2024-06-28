import 'dart:io';
import 'dart:typed_data';

import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:minio/src/minio_models_generated.dart';
import 'package:minio/src/utils.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  testConstruct();
  testListBuckets();
  testBucketExists();
  testFPutObject();
  testGetObjectACL();
  testSetObjectACL();
  testGetObject();
  testPutObject();
  testGetBucketNotification();
  testSetBucketNotification();
  testRemoveAllBucketNotification();
  testListenBucketNotification();
  testStatObject();
  testMakeBucket();
  testRemoveBucket();
  testRemoveObject();
  testListObjects();
}

void testConstruct() {
  test('Minio() implies http port', () {
    final client = getMinioClient(port: null, useSSL: false);
    expect(client.port, equals(80));
  });

  test('Minio() implies https port', () {
    final client = getMinioClient(port: null, useSSL: true);
    expect(client.port, equals(443));
  });

  test('Minio() overrides port with http', () {
    final client = getMinioClient(port: 1234, useSSL: false);
    expect(client.port, equals(1234));
  });

  test('Minio() overrides port with https', () {
    final client = getMinioClient(port: 1234, useSSL: true);
    expect(client.port, equals(1234));
  });

  test('Minio() throws when endPoint is url', () {
    expect(
      () => getMinioClient(endpoint: 'http://play.min.io'),
      throwsA(isA<MinioError>()),
    );
  });

  test('Minio() throws when port is invalid', () {
    expect(
      () => getMinioClient(port: -1),
      throwsA(isA<MinioError>()),
    );

    expect(
      () => getMinioClient(port: 65536),
      throwsA(isA<MinioError>()),
    );
  });
}

void testListBuckets() {
  test('listBuckets() succeeds', () async {
    final minio = getMinioClient();

    expect(() async => await minio.listBuckets(), returnsNormally);
  });

  test('listBuckets() can list buckets', () async {
    final minio = getMinioClient();
    final bucketName1 = uniqueName();
    await minio.makeBucket(bucketName1);

    final bucketName2 = uniqueName();
    await minio.makeBucket(bucketName2);

    final buckets = await minio.listBuckets();
    expect(buckets.any((b) => b.name == bucketName1), isTrue);
    expect(buckets.any((b) => b.name == bucketName2), isTrue);

    await minio.removeBucket(bucketName1);
    await minio.removeBucket(bucketName2);
  });

  test('listBuckets() fails due to wrong access key', () async {
    final minio = getMinioClient(accessKey: 'incorrect-access-key');

    expect(
      () async => await minio.listBuckets(),
      throwsA(
        isA<MinioS3Error>().having(
          (e) => e.error!.code,
          'code',
          isIn(['AccessDenied', 'InvalidAccessKeyId']),
        ),
      ),
    );
  });

  test('listBuckets() fails due to wrong secret key', () async {
    final minio = getMinioClient(secretKey: 'incorrect-secret-key');

    expect(
      () async => await minio.listBuckets(),
      throwsA(
        isA<MinioS3Error>().having(
          (e) => e.error!.code,
          'code',
          isIn(['AccessDenied', 'SignatureDoesNotMatch']),
        ),
      ),
    );
  });
}

void testBucketExists() {
  group('bucketExists', () {
    final bucketName = uniqueName();

    setUpAll(() async {
      final minio = getMinioClient();
      await minio.makeBucket(bucketName);
    });

    tearDownAll(() async {
      final minio = getMinioClient();
      await minio.removeBucket(bucketName);
    });

    test('bucketExists() returns true for an existing bucket', () async {
      final minio = getMinioClient();
      expect(await minio.bucketExists(bucketName), equals(true));
    });

    test('bucketExists() returns false for a non-existent bucket', () async {
      final minio = getMinioClient();
      expect(
          await minio.bucketExists('non-existing-bucket-name'), equals(false));
    });

    test('bucketExists() fails due to wrong access key', () async {
      final minio = getMinioClient(accessKey: 'incorrect-access-key');
      expect(
        () async => await minio.bucketExists(bucketName),
        throwsA(
          isA<MinioError>().having(
            (e) => e.message,
            'message',
            'Forbidden',
          ),
        ),
      );
    });

    test('bucketExists() fails due to wrong secret key', () async {
      final minio = getMinioClient(secretKey: 'incorrect-secret-key');
      expect(
        () async => await minio.bucketExists(bucketName),
        throwsA(
          isA<MinioError>().having(
            (e) => e.message,
            'message',
            'Forbidden',
          ),
        ),
      );
    });
  });
}

void testFPutObject() {
  group('fPutObject', () {
    final bucketName = uniqueName();
    late Directory tempDir;
    late File testFile;
    final objectName = 'a.jpg';

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp();
      testFile = await File('${tempDir.path}/$objectName').create();
      await testFile.writeAsString('random bytes');

      final minio = getMinioClient();
      await minio.makeBucket(bucketName);
    });

    tearDownAll(() async {
      final minio = getMinioClient();
      await minio.removeObject(bucketName, objectName);
      await tempDir.delete(recursive: true);
    });

    test('fPutObject() inserts content-type to metadata', () async {
      final minio = getMinioClient();
      await minio.fPutObject(bucketName, objectName, testFile.path);

      final stat = await minio.statObject(bucketName, objectName);
      expect(stat.metaData!['content-type'], equals('image/jpeg'));
    });

    test('fPutObject() adds user-defined object metadata w/ prefix', () async {
      final prefix = 'x-amz-meta-';
      final userDefinedMetadataKey = '${prefix}user-defined-metadata-key-1';
      final userDefinedMetadataValue = 'custom value 1';
      final metadata = {
        userDefinedMetadataKey: userDefinedMetadataValue,
      };

      final minio = getMinioClient();
      await minio.fPutObject(bucketName, objectName, testFile.path, metadata);

      final stat = await minio.statObject(bucketName, objectName);
      expect(
        stat.metaData![userDefinedMetadataKey.substring(prefix.length)],
        equals(userDefinedMetadataValue),
      );
    });

    test('fPutObject() adds user-defined object metadata w/o prefix', () async {
      final userDefinedMetadataKey = 'user-defined-metadata-key-2';
      final userDefinedMetadataValue = 'custom value 2';
      final metadata = {
        userDefinedMetadataKey: userDefinedMetadataValue,
      };

      final minio = getMinioClient();
      await minio.fPutObject(bucketName, objectName, testFile.path, metadata);

      final stat = await minio.statObject(bucketName, objectName);
      expect(stat.metaData![userDefinedMetadataKey],
          equals(userDefinedMetadataValue));
    });

    test('fPutObject() with empty file', () async {
      final objectName = 'empty.txt';
      final emptyFile = await File('${tempDir.path}/$objectName').create();
      await emptyFile.writeAsString('');

      final minio = getMinioClient();
      await minio.fPutObject(bucketName, objectName, emptyFile.path);

      final stat = await minio.statObject(bucketName, objectName);
      expect(stat.size, equals(0));
    });
  });
}

void testSetObjectACL() {
  group('setObjectACL', () {
    late String bucketName;
    late Directory tempDir;
    File testFile;
    final objectName = 'a.jpg';

    setUpAll(() async {
      bucketName = uniqueName();

      tempDir = await Directory.systemTemp.createTemp();
      testFile = await File('${tempDir.path}/$objectName').create();
      await testFile.writeAsString('random bytes');

      final minio = getMinioClient();
      await minio.makeBucket(bucketName);

      await minio.fPutObject(bucketName, objectName, testFile.path);
    });

    tearDownAll(() async {
      await tempDir.delete(recursive: true);
    });

    test('setObjectACL() set objects acl', () async {
      final minio = getMinioClient();
      await minio.setObjectACL(bucketName, objectName, 'public-read');
    });
  });
}

void testGetObjectACL() {
  group('getObjectACL', () {
    late String bucketName;
    late Directory tempDir;
    File testFile;
    final objectName = 'a.jpg';

    setUpAll(() async {
      bucketName = uniqueName();

      tempDir = await Directory.systemTemp.createTemp();
      testFile = await File('${tempDir.path}/$objectName').create();
      await testFile.writeAsString('random bytes');

      final minio = getMinioClient();
      await minio.makeBucket(bucketName);

      await minio.fPutObject(bucketName, objectName, testFile.path);
    });

    tearDownAll(() async {
      await tempDir.delete(recursive: true);
    });

    test('getObjectACL() fetch objects acl', () async {
      final minio = getMinioClient();
      var acl = await minio.getObjectACL(bucketName, objectName);
      expect(acl.grants!.permission, equals(null));
    });
  });
}

void testGetObject() {
  group('getObject()', () {
    final minio = getMinioClient();
    final bucketName = uniqueName();
    final object = uniqueName();
    final objectUtf8 = uniqueName() + '/あるところ/某个文件.🦐';
    final objectData = Uint8List.fromList([1, 2, 3]);

    setUpAll(() async {
      await minio.makeBucket(bucketName);
      await minio.putObject(bucketName, object, Stream.value(objectData));
      await minio.putObject(bucketName, objectUtf8, Stream.value(objectData));
    });

    tearDownAll(() async {
      await minio.removeObject(bucketName, object);
      await minio.removeObject(bucketName, objectUtf8);
      await minio.removeBucket(bucketName);
    });

    test('succeeds', () async {
      final stream = await minio.getObject(bucketName, object);
      final buffer = BytesBuilder();
      await stream.forEach((data) => buffer.add(data));
      expect(stream.contentLength, equals(objectData.length));
      expect(buffer.takeBytes(), equals(objectData));
    });

    test('succeeds with utf8 object name', () async {
      final stream = await minio.getObject(bucketName, object);
      final buffer = BytesBuilder();
      await stream.forEach((data) => buffer.add(data));
      expect(stream.contentLength, equals(objectData.length));
      expect(buffer.takeBytes(), equals(objectData));
    });

    test('fails on invalid bucket', () {
      expect(
        () async => await minio.getObject('$bucketName-invalid', object),
        throwsA(isA<MinioError>()),
      );
    });

    test('fails on invalid object', () {
      expect(
        () async => await minio.getObject(bucketName, '$object-invalid'),
        throwsA(isA<MinioError>()),
      );
    });
  });
}

void testPutObject() {
  group('putObject()', () {
    final minio = getMinioClient();
    final bucketName = uniqueName();
    final objectData = Uint8List.fromList([1, 2, 3]);

    setUpAll(() async {
      await minio.makeBucket(bucketName);
    });

    tearDownAll(() async {
      await minio.removeBucket(bucketName);
    });

    test('succeeds', () async {
      final objectName = uniqueName();
      await minio.putObject(bucketName, objectName, Stream.value(objectData));
      final stat = await minio.statObject(bucketName, objectName);
      expect(stat.size, equals(objectData.length));
      await minio.removeObject(bucketName, objectName);
    });

    test('works with object names with symbols', () async {
      final objectName = uniqueName() + r'-._~,!@#$%^&*()';
      await minio.putObject(bucketName, objectName, Stream.value(objectData));
      final stat = await minio.statObject(bucketName, objectName);
      expect(stat.size, equals(objectData.length));
      await minio.removeObject(bucketName, objectName);
    });

    test('progress report works', () async {
      final objectName = uniqueName();
      int? progress;
      await minio.putObject(
        bucketName,
        objectName,
        Stream.value(objectData),
        onProgress: (bytes) => progress = bytes,
      );
      await minio.removeObject(bucketName, objectName);
      expect(progress, equals(objectData.length));
    });

    test('medium size file upload works', () async {
      final objectName = uniqueName();
      final dataLength = 1024 * 1024;
      final data = Uint8List.fromList(List<int>.generate(dataLength, (i) => i));
      await minio.putObject(bucketName, objectName, Stream.value(data));
      final stat = await minio.statObject(bucketName, objectName);
      await minio.removeObject(bucketName, objectName);
      expect(stat.size, equals(dataLength));
    });

    test('stream upload works', () async {
      final objectName = uniqueName();
      final dataLength = 1024 * 1024;
      final data = Uint8List.fromList(List<int>.generate(dataLength, (i) => i));
      await minio.putObject(
        bucketName,
        objectName,
        Stream.value(data).transform(MaxChunkSize(123)),
      );
      final stat = await minio.statObject(bucketName, objectName);
      await minio.removeObject(bucketName, objectName);
      expect(stat.size, equals(dataLength));
    });

    test('empty stream upload works', () async {
      final objectName = uniqueName();
      await minio.putObject(bucketName, objectName, Stream.empty());
      final stat = await minio.statObject(bucketName, objectName);
      await minio.removeObject(bucketName, objectName);
      expect(stat.size, equals(0));
    });

    test('zero byte stream upload works', () async {
      final objectName = uniqueName();
      await minio.putObject(bucketName, objectName, Stream.value(Uint8List(0)));
      final stat = await minio.statObject(bucketName, objectName);
      await minio.removeObject(bucketName, objectName);
      expect(stat.size, equals(0));
    });

    test('multipart file upload works', () async {
      final objectName = uniqueName();
      final dataLength = 12 * 1024 * 1024;
      final data = Uint8List.fromList(List<int>.generate(dataLength, (i) => i));
      await minio.putObject(
        bucketName,
        objectName,
        Stream.value(data),
        chunkSize: 5 * 1024 * 1024,
      );
      final stat = await minio.statObject(bucketName, objectName);
      await minio.removeObject(bucketName, objectName);
      expect(stat.size, equals(dataLength));
    });
  });
}

void testGetBucketNotification() {
  group('getBucketNotification()', () {
    final minio = getMinioClient();
    final bucketName = uniqueName();

    setUpAll(() async {
      await minio.makeBucket(bucketName);
    });

    tearDownAll(() async {
      await minio.removeBucket(bucketName);
    });

    test('succeeds', () async {
      await minio.getBucketNotification(bucketName);
    });
  });
}

void testSetBucketNotification() {
  group('setBucketNotification()', () {
    final minio = getMinioClient();
    final bucketName = uniqueName();

    setUpAll(() async {
      await minio.makeBucket(bucketName);
    });

    tearDownAll(() async {
      await minio.removeBucket(bucketName);
    });

    test('succeeds', () async {
      await minio.setBucketNotification(
        bucketName,
        NotificationConfiguration(null, null, null),
      );
    });
  });
}

void testRemoveAllBucketNotification() {
  group('removeAllBucketNotification()', () {
    final minio = getMinioClient();
    final bucketName = uniqueName();

    setUpAll(() async {
      await minio.makeBucket(bucketName);
    });

    tearDownAll(() async {
      await minio.removeBucket(bucketName);
    });

    test('succeeds', () async {
      await minio.removeAllBucketNotification(bucketName);
    });
  });
}

void testListenBucketNotification() {
  group('listenBucketNotification()', () {
    final minio = getMinioClient();
    final bucketName = uniqueName();
    // final objectName = uniqueName();

    setUpAll(() async {
      await minio.makeBucket(bucketName);
    });

    tearDownAll(() async {
      await minio.removeBucket(bucketName);
    });

    test('succeeds', () async {
      final poller = minio.listenBucketNotification(bucketName);
      expect(poller.isStarted, isTrue);
      poller.stop();
    });

    // test('can receive notification', () async {
    //   final poller = minio.listenBucketNotification(
    //     bucketName,
    //     events: ['s3:ObjectCreated:*'],
    //   );

    //   final receivedEvents = [];
    //   poller.stream.listen((event) => receivedEvents.add(event));
    //   expect(receivedEvents, isEmpty);

    //   await minio.putObject(bucketName, objectName, Stream.value([0]));
    //   await minio.removeObject(bucketName, objectName);

    //   // FIXME: Needs sleep here
    //   expect(receivedEvents, isNotEmpty);

    //   poller.stop();
    // });
  });
}

void testStatObject() {
  group('statObject()', () {
    final minio = getMinioClient();
    final bucketName = uniqueName();
    final object = uniqueName();
    final objectUtf8 = uniqueName() + 'オブジェクト。📦';
    final data = Uint8List.fromList([1, 2, 3, 4, 5]);

    setUpAll(() async {
      await minio.makeBucket(bucketName);
      await minio.putObject(bucketName, object, Stream.value(data));
      await minio.putObject(bucketName, objectUtf8, Stream.value(data));
    });

    tearDownAll(() async {
      await minio.removeObject(bucketName, object);
      await minio.removeObject(bucketName, objectUtf8);
      await minio.removeBucket(bucketName);
    });

    test('succeeds', () async {
      final stats = await minio.statObject(bucketName, object);
      expect(stats.lastModified, isNotNull);
      expect(stats.lastModified!.isBefore(DateTime.now()), isTrue);
      expect(stats.size, isNotNull);
      expect(stats.size, equals(data.length));
    });

    test('succeeds with utf8 object name', () async {
      final stats = await minio.statObject(bucketName, objectUtf8);
      expect(stats.lastModified, isNotNull);
      expect(stats.lastModified!.isBefore(DateTime.now()), isTrue);
      expect(stats.size, isNotNull);
      expect(stats.size, equals(data.length));
    });

    test('fails on invalid bucket', () {
      expect(
        () async => await minio.statObject('$bucketName-invalid', object),
        throwsA(isA<MinioError>()),
      );
    });

    test('fails on invalid object', () {
      expect(
        () async => await minio.statObject(bucketName, '$object-invalid'),
        throwsA(isA<MinioError>()),
      );
    });
  });
}

void testMakeBucket() {
  group('makeBucket()', () {
    final minio = getMinioClient();
    final bucketName = uniqueName();

    setUpAll(() async {
      await minio.makeBucket(bucketName);
    });

    tearDownAll(() async {
      await minio.removeBucket(bucketName);
    });

    test('succeeds', () async {
      final buckets = await minio.listBuckets();
      final bucketNames = buckets.map((b) => b.name).toList();
      expect(bucketNames, contains(bucketName));
    });
  });
}

void testRemoveBucket() {
  group('removeBucket()', () {
    final minio = getMinioClient();
    final bucketName = uniqueName();

    test('succeeds', () async {
      await minio.makeBucket(bucketName);
      await minio.removeBucket(bucketName);
    });

    test('fails on invalid bucket name', () {
      expect(
        () async => await minio.removeBucket('$bucketName-invalid'),
        throwsA(isA<MinioError>()),
      );
    });
  });
}

void testRemoveObject() {
  group('removeObject()', () {
    final minio = getMinioClient();
    final bucketName = uniqueName();
    final objectName = uniqueName();
    final data = Uint8List.fromList([1, 2, 3, 4, 5]);

    setUpAll(() async {
      await minio.makeBucket(bucketName);
    });

    tearDownAll(() async {
      await minio.removeBucket(bucketName);
    });

    test('succeeds', () async {
      await minio.putObject(bucketName, objectName, Stream.value(data));
      await minio.removeObject(bucketName, objectName);

      await for (var chunk in minio.listObjects(bucketName)) {
        expect(chunk.objects.contains(objectName), isFalse);
      }
    });

    test('fails on invalid bucket', () {
      expect(
        () async => await minio.removeObject('$bucketName-invalid', objectName),
        throwsA(isA<MinioError>()),
      );
    });

    test('does not throw on invalid object', () async {
      await minio.removeObject(bucketName, '$objectName-invalid');
    });
  });
}

void testListObjects() {
  group('listAllObjects()', () {
    final minio = getMinioClient();
    final bucketName = uniqueName();
    final objectName = uniqueName();
    final objectNameUtf8 = uniqueName() + '文件ファイル。ㄴㅁㄴ';
    final data = Uint8List.fromList([1, 2, 3, 4, 5]);

    setUpAll(() async {
      await minio.makeBucket(bucketName);
      await minio.putObject(bucketName, objectName, Stream.value(data));
      await minio.putObject(bucketName, objectNameUtf8, Stream.value(data));
    });

    tearDownAll(() async {
      await minio.removeObject(bucketName, objectName);
      await minio.removeObject(bucketName, objectNameUtf8);
      await minio.removeBucket(bucketName);
    });

    test('succeeds', () async {
      final result = await minio.listAllObjects(bucketName);
      print(result);
      expect(result.objects.map((e) => e.key).contains(objectName), isTrue);
      expect(result.objects.map((e) => e.key).contains(objectNameUtf8), isTrue);
    });

    test('fails on invalid bucket', () {
      expect(
        () async => await minio.listAllObjects('$bucketName-invalid'),
        throwsA(isA<MinioError>()),
      );
    });
  });

  group('listAllObjects() works when prefix contains spaces', () {
    final minio = getMinioClient();
    final bucket = uniqueName();
    final object = 'new  folder/new file.txt';
    final data = Uint8List.fromList([1, 2, 3, 4, 5]);

    setUpAll(() async {
      await minio.makeBucket(bucket);
      await minio.putObject(bucket, object, Stream.value(data));
    });

    tearDownAll(() async {
      await minio.removeObject(bucket, object);
      await minio.removeBucket(bucket);
    });

    test('succeeds', () async {
      final result = await minio.listAllObjects(bucket, prefix: 'new  folder/');
      expect(result.objects.map((e) => e.key).contains(object), isTrue);
    });
  });

  group('listAllObjects() works when prefix contains utf-8 characters', () {
    final minio = getMinioClient();
    final bucket = uniqueName();
    final prefix = '🍎🌰🍌🍓/文件夹　1 2/';
    final object = '${prefix}new file.txt';
    final data = Uint8List.fromList([1, 2, 3, 4, 5]);

    setUpAll(() async {
      await minio.makeBucket(bucket);
      await minio.putObject(bucket, object, Stream.value(data));
    });

    tearDownAll(() async {
      await minio.removeObject(bucket, object);
      await minio.removeBucket(bucket);
    });

    test('succeeds', () async {
      final result = await minio.listAllObjects(bucket, prefix: prefix);
      print(result);
      expect(result.objects.map((e) => e.key).contains(object), isTrue);
    });
  });
}
