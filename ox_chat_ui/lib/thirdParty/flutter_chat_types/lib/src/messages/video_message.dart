import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../message.dart';
import '../user.dart' show User;
import 'partial_video.dart';

part 'video_message.g.dart';

/// A class that represents video message.
@JsonSerializable()
@immutable
abstract class VideoMessage extends Message {
  /// Creates a video message.
  const VideoMessage._({
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
    super.expiration,
  }) : super(
    type: type ?? MessageType.video,
    fileEncryptionType: fileEncryptionType ?? EncryptionType.none,
  );

  const factory VideoMessage({
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
    int? expiration,
  }) = _VideoMessage;

  /// Creates a video message from a map (decoded JSON).
  factory VideoMessage.fromJson(Map<String, dynamic> json) =>
      _$VideoMessageFromJson(json);

  /// Creates a full video message from a partial one.
  factory VideoMessage.fromPartial({
    required User author,
    required int createdAt,
    required String id,
    dynamic sourceKey,
    required PartialVideo partialVideo,
    String? remoteId,
    String? roomId,
    bool? showStatus,
    Status? status,
    int? updatedAt,
    EncryptionType fileEncryptionType = EncryptionType.none,
    int? expiration,
  }) =>
      _VideoMessage(
        author: author,
        createdAt: createdAt,
        height: partialVideo.height,
        id: id,
        sourceKey: sourceKey,
        metadata: partialVideo.metadata,
        name: partialVideo.name,
        remoteId: remoteId,
        repliedMessage: partialVideo.repliedMessage,
        roomId: roomId,
        showStatus: showStatus,
        size: partialVideo.size,
        status: status,
        type: MessageType.video,
        updatedAt: updatedAt,
        uri: partialVideo.uri,
        width: partialVideo.width,
        fileEncryptionType: fileEncryptionType,
        expiration: expiration,
      );

  /// Video height in pixels.
  final double? height;

  /// The name of the video.
  final String name;

  /// Size of the video in bytes.
  final num size;

  /// The video source (either a remote URL or a local resource).
  final String uri;

  /// Video width in pixels.
  final double? width;

  @override
  String get content => metadata?['videoUrl'] as String ?? '';

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
    int? expiration,
  });

  /// Converts an video message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$VideoMessageToJson(this);
}

/// A utility class to enable better copyWith.
class _VideoMessage extends VideoMessage {
  const _VideoMessage({
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
    super.expiration,
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
    dynamic roomId,
    dynamic showStatus = _Unset,
    num? size,
    dynamic status = _Unset,
    dynamic updatedAt = _Unset,
    String? uri,
    dynamic width = _Unset,
    dynamic fileEncryptionType = _Unset,
    int? expiration,
  }) =>
      _VideoMessage(
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
        roomId: roomId == _Unset ? this.roomId : roomId as String?,
        showStatus:
            showStatus == _Unset ? this.showStatus : showStatus as bool?,
        size: size ?? this.size,
        status: status == _Unset ? this.status : status as Status?,
        updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt as int?,
        uri: uri ?? this.uri,
        width: width == _Unset ? this.width : width as double?,
        fileEncryptionType: fileEncryptionType == _Unset ? this.fileEncryptionType : fileEncryptionType,
        expiration: expiration ?? this.expiration,
      );
}

class _Unset {}
