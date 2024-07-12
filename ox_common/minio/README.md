<p align="center">
  <h1 align="center">MinIO Dart</h1>
</p>

This is the _unofficial_ MinIO Dart Client SDK that provides simple APIs to access any Amazon S3 compatible object storage server.

<p align="center">
  <a href="https://github.com/xtyxtyx/minio-dart/actions/workflows/dart.yml">
    <img src="https://github.com/xtyxtyx/minio-dart/workflows/Dart/badge.svg">
  </a>
  <a href="https://pub.dev/packages/minio">
    <img src="https://img.shields.io/pub/v/minio">
  </a>
  <a href="https://ko-fi.com/F1F61K6BL">
    <img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-F16061?style=flat&logo=buy-me-a-coffee&logoColor=white&labelColor=555555">
  </a>
</p>


## API

| Bucket operations       | Object operations        | Presigned operations  | Bucket Policy & Notification operations |
| ----------------------- | ------------------------ | --------------------- | --------------------------------------- |
| [makeBucket]            | [getObject]              | [presignedUrl]        | [getBucketNotification]                 |
| [listBuckets]           | [getPartialObject]       | [presignedGetObject]  | [setBucketNotification]                 |
| [bucketExists]          | [fGetObject]             | [presignedPutObject]  | [removeAllBucketNotification]           |
| [removeBucket]          | [putObject]              | [presignedPostPolicy] | [listenBucketNotification]              |
| [listObjects]           | [fPutObject]             |                       | [getBucketPolicy]                       |
| [listObjectsV2]         | [copyObject]             |                       | [setBucketPolicy]                       |
| [listIncompleteUploads] | [statObject]             |                       |                                         |
| [listAllObjects]        | [removeObject]           |                       |                                         |
| [listAllObjectsV2]      | [removeObjects]          |                       |                                         |
|                         | [removeIncompleteUpload] |                       |                                         |


## Usage

### Initialize MinIO Client

**MinIO**

```dart
final minio = Minio(
  endPoint: 'play.min.io',
  accessKey: 'Q3AM3UQ867SPQQA43P2F',
  secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG',
);
```

**AWS S3**

```dart
final minio = Minio(
  endPoint: 's3.amazonaws.com',
  accessKey: 'YOUR-ACCESSKEYID',
  secretKey: 'YOUR-SECRETACCESSKEY',
);
```

**Filebase**

```dart
final minio = Minio(
  endPoint: 's3.filebase.com',
  accessKey: 'YOUR-ACCESSKEYID',
  secretKey: 'YOUR-SECRETACCESSKEY',
  useSSL: true,
);
```

**File upload**
```dart
import 'package:minio/io.dart';
import 'package:minio/minio.dart';

void main() async {
  final minio = Minio(
    endPoint: 'play.min.io',
    accessKey: 'Q3AM3UQ867SPQQA43P2F',
    secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG',
  );

  await minio.fPutObject('mybucket', 'myobject', 'path/to/file');
}
```

For complete example, see: [example]

> To use `fPutObject()` and `fGetObject`, you have to `import 'package:minio/io.dart';`

**Upload with progress**
```dart
import 'package:minio/minio.dart';

void main() async {
  final minio = Minio(
    endPoint: 'play.min.io',
    accessKey: 'Q3AM3UQ867SPQQA43P2F',
    secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG',
  );

  await minio.putObject(
    'mybucket', 
    'myobject', 
    Stream<Uint8List>.value(Uint8List(1024)),
    onProgress: (bytes) => print('$bytes uploaded'),
  );
}
```

**Get object**

```dart
import 'dart:io';
import 'package:minio/minio.dart';

void main() async {
  final minio = Minio(
    endPoint: 's3.amazonaws.com',
    accessKey: 'YOUR-ACCESSKEYID',
    secretKey: 'YOUR-SECRETACCESSKEY',
  );

  final stream = await minio.getObject('BUCKET-NAME', 'OBJECT-NAME');

  // Get object length
  print(stream.contentLength);

  // Write object data stream to file
  await stream.pipe(File('output.txt').openWrite());
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

Contributions to this repository are welcome.

## License

MIT

[tracker]: https://github.com/xtyxtyx/minio-dart/issues
[example]: https://pub.dev/packages/minio#-example-tab-
[link text itself]: http://www.reddit.com

[makeBucket]: https://pub.dev/documentation/minio/latest/minio/Minio/makeBucket.html
[listBuckets]: https://pub.dev/documentation/minio/latest/minio/Minio/listBuckets.html
[bucketExists]: https://pub.dev/documentation/minio/latest/minio/Minio/bucketExists.html
[removeBucket]: https://pub.dev/documentation/minio/latest/minio/Minio/removeBucket.html
[listObjects]: https://pub.dev/documentation/minio/latest/minio/Minio/listObjects.html
[listObjectsV2]: https://pub.dev/documentation/minio/latest/minio/Minio/listObjectsV2.html
[listIncompleteUploads]: https://pub.dev/documentation/minio/latest/minio/Minio/listIncompleteUploads.html
[listAllObjects]: https://pub.dev/documentation/minio/latest/minio/Minio/listAllObjects.html
[listAllObjectsV2]: https://pub.dev/documentation/minio/latest/minio/Minio/listAllObjectsV2.html

[getObject]: https://pub.dev/documentation/minio/latest/minio/Minio/getObject.html
[getPartialObject]: https://pub.dev/documentation/minio/latest/minio/Minio/getPartialObject.html
[putObject]: https://pub.dev/documentation/minio/latest/minio/Minio/putObject.html
[copyObject]: https://pub.dev/documentation/minio/latest/minio/Minio/copyObject.html
[statObject]: https://pub.dev/documentation/minio/latest/minio/Minio/statObject.html
[removeObject]: https://pub.dev/documentation/minio/latest/minio/Minio/removeObject.html
[removeObjects]: https://pub.dev/documentation/minio/latest/minio/Minio/removeObjects.html
[removeIncompleteUpload]: https://pub.dev/documentation/minio/latest/minio/Minio/removeIncompleteUpload.html

[fGetObject]: https://pub.dev/documentation/minio/latest/io/MinioX/fGetObject.html
[fPutObject]: https://pub.dev/documentation/minio/latest/io/MinioX/fPutObject.html

[presignedUrl]: https://pub.dev/documentation/minio/latest/minio/Minio/presignedUrl.html
[presignedGetObject]: https://pub.dev/documentation/minio/latest/minio/Minio/presignedGetObject.html
[presignedPutObject]: https://pub.dev/documentation/minio/latest/minio/Minio/presignedPutObject.html
[presignedPostPolicy]: https://pub.dev/documentation/minio/latest/minio/Minio/presignedPostPolicy.html

[getBucketNotification]: https://pub.dev/documentation/minio/latest/minio/Minio/getBucketNotification.html
[setBucketNotification]: https://pub.dev/documentation/minio/latest/minio/Minio/setBucketNotification.html
[removeAllBucketNotification]: https://pub.dev/documentation/minio/latest/minio/Minio/removeAllBucketNotification.html
[listenBucketNotification]: https://pub.dev/documentation/minio/latest/minio/Minio/listenBucketNotification.html

[getBucketPolicy]: https://pub.dev/documentation/minio/latest/minio/Minio/getBucketPolicy.html
[setBucketPolicy]: https://pub.dev/documentation/minio/latest/minio/Minio/setBucketPolicy.html
