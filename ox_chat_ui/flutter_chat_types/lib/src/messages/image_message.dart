import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../message.dart';
import '../user.dart' show User;
import 'partial_image.dart';

part 'image_message.g.dart';

/// A class that represents image message.
@JsonSerializable()
@immutable
abstract class ImageMessage extends Message {
  /// Creates an image message.
  const ImageMessage._({
    required super.author,
    required super.createdAt,
    this.height,
    required super.id,
    super.sourceKey,
    super.metadata,
    required this.name,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    required this.size,
    super.status,
    MessageType? type,
    super.updatedAt,
    required this.uri,
    this.width,
    EncryptionType? fileEncryptionType,
    super.decryptKey,
    super.expiration,
    super.reactions,
    super.zapsInfoList,
  }) : super(
    type: type ?? MessageType.image,
    fileEncryptionType: fileEncryptionType ?? EncryptionType.none,
  );

  const factory ImageMessage({
    required User author,
    required int createdAt,
    double? height,
    required String id,
    dynamic sourceKey,
    Map<String, dynamic>? metadata,
    required String name,
    String? remoteId,
    Message? repliedMessage,
    String? roomId,
    bool? showStatus,
    required num size,
    Status? status,
    MessageType? type,
    int? updatedAt,
    required String uri,
    double? width,
    EncryptionType? fileEncryptionType,
    String? decryptKey,
    int? expiration,
    List<Reaction> reactions,
    List<ZapsInfo> zapsInfoList,
  }) = _ImageMessage;

  /// Creates an image message from a map (decoded JSON).
  factory ImageMessage.fromJson(Map<String, dynamic> json) =>
      _$ImageMessageFromJson(json);

  /// Creates a full image message from a partial one.
  factory ImageMessage.fromPartial({
    required User author,
    required int createdAt,
    required String id,
    required PartialImage partialImage,
    String? remoteId,
    String? roomId,
    bool? showStatus,
    Status? status,
    int? updatedAt,
    EncryptionType fileEncryptionType = EncryptionType.none,
    int? expiration,
    List<Reaction>? reactions,
    List<ZapsInfo>? zapsInfoList,
  }) =>
      _ImageMessage(
        author: author,
        createdAt: createdAt,
        height: partialImage.height,
        id: id,
        metadata: partialImage.metadata,
        name: partialImage.name,
        remoteId: remoteId,
        repliedMessage: partialImage.repliedMessage,
        roomId: roomId,
        showStatus: showStatus,
        size: partialImage.size,
        status: status,
        type: MessageType.image,
        updatedAt: updatedAt,
        uri: partialImage.uri,
        width: partialImage.width,
        fileEncryptionType: fileEncryptionType,
        expiration: expiration,
      );

  /// Image height in pixels.
  final double? height;

  /// The name of the image.
  final String name;

  /// Size of the image in bytes.
  final num size;

  /// The image source (either a remote URL or a local resource).
  final String uri;

  /// Image width in pixels.
  final double? width;

  @override
  String get content => uri;

  /// Equatable props.
  @override
  List<Object?> get props => [
        author,
        createdAt,
        height,
        id,
        metadata,
        name,
        remoteId,
        repliedMessage,
        roomId,
        showStatus,
        size,
        status,
        updatedAt,
        uri,
        width,
        fileEncryptionType,
        expiration,
      ];

  @override
  Message copyWith({
    User? author,
    int? createdAt,
    double? height,
    String? id,
    dynamic sourceKey,
    Map<String, dynamic>? metadata,
    String? name,
    String? remoteId,
    Message? repliedMessage,
    String? roomId,
    bool? showStatus,
    num? size,
    Status? status,
    int? updatedAt,
    String? uri,
    double? width,
    EncryptionType? fileEncryptionType,
    String? decryptKey,
    int? expiration,
    List<Reaction>? reactions,
    List<ZapsInfo>? zapsInfoList,
  });

  /// Converts an image message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$ImageMessageToJson(this);
}

/// A utility class to enable better copyWith.
class _ImageMessage extends ImageMessage {

  bool get viewWithoutBubble => reactions.isEmpty;

  const _ImageMessage({
    required super.author,
    required super.createdAt,
    super.height,
    required super.id,
    super.sourceKey,
    super.metadata,
    required super.name,
    super.remoteId,
    super.repliedMessage,
    super.roomId,
    super.showStatus,
    required super.size,
    super.status,
    super.type,
    super.updatedAt,
    required super.uri,
    super.width,
    super.fileEncryptionType,
    super.decryptKey,
    super.expiration,
    super.reactions,
    super.zapsInfoList,
  }) : super._();

  @override
  Message copyWith({
    User? author,
    int? createdAt,
    dynamic height = _Unset,
    String? id,
    dynamic sourceKey,
    dynamic metadata = _Unset,
    String? name,
    dynamic remoteId = _Unset,
    dynamic repliedMessage = _Unset,
    String? roomId,
    dynamic showStatus = _Unset,
    num? size,
    dynamic status = _Unset,
    dynamic updatedAt = _Unset,
    String? uri,
    dynamic width = _Unset,
    dynamic fileEncryptionType = _Unset,
    String? decryptKey,
    int? expiration,
    List<Reaction>? reactions,
    List<ZapsInfo>? zapsInfoList,
  }) =>
      _ImageMessage(
        author: author ?? this.author,
        createdAt: createdAt ?? this.createdAt,
        height: height == _Unset ? this.height : height as double?,
        id: id ?? this.id,
        sourceKey: sourceKey ?? this.sourceKey,
        metadata: metadata == _Unset
            ? this.metadata
            : metadata as Map<String, dynamic>?,
        name: name ?? this.name,
        remoteId: remoteId == _Unset ? this.remoteId : remoteId as String?,
        repliedMessage: repliedMessage == _Unset
            ? this.repliedMessage
            : repliedMessage as Message?,
        roomId: roomId ?? this.roomId,
        showStatus:
            showStatus == _Unset ? this.showStatus : showStatus as bool?,
        size: size ?? this.size,
        status: status == _Unset ? this.status : status as Status?,
        updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt as int?,
        uri: uri ?? this.uri,
        width: width == _Unset ? this.width : width as double?,
        fileEncryptionType: fileEncryptionType == _Unset ? this.fileEncryptionType : fileEncryptionType,
        decryptKey: decryptKey ?? this.decryptKey,
        expiration: expiration ?? this.expiration,
        reactions: reactions ?? this.reactions,
        zapsInfoList: zapsInfoList ?? this.zapsInfoList,
      );
}

class _Unset {}
