## 3.6.0

- Add audio message type. Thanks @marinkobabic for the PR!
- Add video message type
- Update dependencies. Requires Dart >= 2.18.0.

## 3.5.0

- Update to Flutter 3.3.3

## 3.4.5

- Exported system message type. Thanks @felixgabler for the PR!

## 3.4.4

- Add system message type. Thanks @felixgabler for the PR!
- Update dependencies

## 3.4.3

- Code refactor

## 3.4.2

- Fix partial message constructors

## 3.4.1

- Downgrade meta to support flutter test

## 3.4.0

- Update to Flutter 3. Thanks @felixgabler for the PR!
- Fix `copyWith` for all message types. Thanks @felixgabler for the PR!

## 3.3.4

- Add `isLoading` to the file message. Thanks @felixgabler for the PR!

## 3.3.3

- Add `author` and `createdAt` to the `copyWith` method. Thanks @felixgabler for the PR!

## 3.3.2

- Add `showStatus` to all messages. Thanks @arsamme for the PR!
- Update to Flutter 2.10.4

## 3.3.1

- Update to Flutter 2.10.2

## 3.3.0

- Do not include null values in JSON. Thanks @felixgabler for the PR!
- Update to Flutter 2.10

## 3.2.2

- Update dependencies. Requires Dart >= 2.15.1.

## 3.2.1

- Update dependencies

## 3.2.0

- Update dependencies
- Remove `unsupported` room type

## 3.1.4

- Add `remoteId` to equatable props

## 3.1.3

- Add `remoteId` message property

## 3.1.2

- Additionally, revert `json_annotation` upgrade

## 3.1.1

- Revert `meta` upgrade, because `pub.dev` is analyzing code with an old Flutter version

## 3.1.0

- Update to Flutter 2.5

## 3.0.2

- Use `num` instead of `int` for sizes

## 3.0.1

- Fix missing `type`

## 3.0.0

- Migrate to `json_serializable`

## 2.4.3

- Export partial custom message

## 2.4.2

- Add `metadata` to partial messages
- Add `previewData` to the partial text message

## 2.4.1

- Fix issue where `lastMessages` can be null

## 2.4.0

- Add `updatedAt` to the message, room and user

## 2.3.0

- Add `lastMessages` to the room

## 2.2.0

This release marks a major chat architecture overhaul based on a community feedback. In the future we don't expect such big changes in one release and will try to do backwards compatible code as much as possible.

- **BREAKING CHANGE**: [FileMessage] `fileName` is renamed to `name`
- **BREAKING CHANGE**: [ImageMessage] `imageName` is renamed to `name`
- **BREAKING CHANGE**: [Messages] `authorId` is replaced with `author` to support avatars and names inside the chat
- **BREAKING CHANGE**: [Messages] `timestamp` is renamed to `createdAt`. All timestamps are in `ms` now. 
- **BREAKING CHANGE**: [Status] `read` is renamed to `seen`
- **BREAKING CHANGE**: [User] `avatarUrl` is renamed to `imageUrl`
- New `custom` and `unsupported` message types. First one is used to build any message you want, second one is to support backwards compatibility
- `copyWith` text option for the `TextMessage`
- Exported `utils`
- Some additional fields like user's role for the future features

## 2.1.5

- Revert meta upgrade

## 2.1.4

- Update dependencies

## 2.1.3

- Update to Flutter 2.2

## 2.1.2

- Add equatable to every type

## 2.1.1

- Fix bug with empty preview data

## 2.1.0

- Add `copyWith` to the message

## 2.0.9

- Add custom metadata to message and user classes

## 2.0.8

- Add custom metadata to the room class. Thanks @alihen for the PR!

## 2.0.7

- Update homepage

## 2.0.6

- Update README

## 2.0.5

- Update types

## 2.0.4

- Add Room type

## 2.0.3

- Fix null status

## 2.0.2

- Add CI

## 2.0.1

- Update to null safety

## 2.0.0

- Update to Flutter 2

## 1.1.1

- Finish documentation
- Rename URL to URI

## 1.1.0

- Add partial classes

## 1.0.9

- Add null checking

## 1.0.8

- Fix TextMessage mapping

## 1.0.7

- Fix PreviewData mapping

## 1.0.6

- Code cleanup

## 1.0.5

- Export PreviewDatImage type

## 1.0.4

- Add PreviewData type

## 1.0.3

- Make timestamp optional

## 1.0.2

- Add toJson method

## 1.0.1

- Fix file message type

## 1.0.0

- Add file message type

## 0.0.1

- Initial release
