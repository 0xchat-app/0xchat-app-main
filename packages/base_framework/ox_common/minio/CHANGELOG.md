# 3.5.0
- Fix listObject with utf-8 prefix

# 3.4.0-pre
- Better upload progress on web
# 3.3.3
- Fix empty upload error
- Update README.md

# 3.3.3-pre
- Update stream file upload

# 3.3.2-pre
- Add tests

# 3.3.1-pre
- Improve upload progress granularity
- Fix broken test

# 3.3.0-pre
- Support listening upload progress

# 3.2.0
- Fix response body utf-8 encoding [#14]

# 3.1.0
- Add `listAllObjects` and `listAllObjectsV2`
- Fix signing error in `listObjects` when prefix contains spaces [#34]
- Improved compatibility with Filebase [#31]

# 3.0.0
- Fixes signing error in case object name contains symbols [#29]

# 2.1.0-pre
- `getObject` now returns `MinioByteStream` with an additional `contentLength` field.

## 2.0.0-pre

- Migrate to NNBD

## 1.4.0-pre

- Object's ACL Query; Include object's ACL in stat [#23](https://github.com/xtyxtyx/minio-dart/pull/23), thanks [@rtgnx](https://github.com/rtgnx)

## 1.3.0
- fix HTTP header for user-defined object metadata [#17](https://github.com/xtyxtyx/minio-dart/issues/17), thanks [@philenius](https://github.com/philenius)

## 1.2.0

- fix [#15](https://github.com/xtyxtyx/minio-dart/issues/15) fPutObject content-type: 'image/jpeg' is ignored

## 1.1.0

## 1.1.0-pre

- fix bucketExists is true when bucket doesn't exist #13


## 1.0.2-pre

- Replace static region 'us-east-1' in method listBuckets() with variable's value

## 1.0.1-pre

- Updated dependencies
- Fixed Malformed XML error
- Fixed Types incompatibility in minio_uploader stream subscription queries
- Temporarily closed call for search of unfinished uploads (Causes Signature Error)

## 0.1.8

- Update dependency

## 0.1.7

- Fix region issue, thanks @ivoryxiong

## 0.1.6

- support policy apis

## 0.1.5

- support notification apis

## 0.1.4

- support presignedPostPolicy

## 0.1.3

- support presignedGetObject and presignedPutObject

## 0.1.2

- support presignedUrl

## 0.1.1

- update dependency

## 0.1.0+2

- try to fix table display

## 0.1.0+1

- update README

## 0.1.0

- Initial version, created by Stagehand

[#34]: https://github.com/xtyxtyx/minio-dart/issues/34
[#31]: https://github.com/xtyxtyx/minio-dart/issues/31
[#29]: https://github.com/xtyxtyx/minio-dart/issues/29
[#14]: https://github.com/xtyxtyx/minio-dart/issues/14