import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../message.dart';
import '../user.dart' show User;
import 'partial_file.dart';

part 'file_message.g.dart';

/// A class that represents file message.
@JsonSerializable()
@immutable
abstract class FileMessage extends Message {
  /// Creates a file message.
  const FileMessage._({
    required super.author,
    required super.createdAt,
    required super.id,
    super.sourceKey,
    this.isLoading,
    super.metadata,
    this.mimeType,
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
    super.expiration,
  }) : super(type: type ?? MessageType.file);

  const factory FileMessage({
    required User author,
    required int createdAt,
    required String id,
    bool? isLoading,
    Map<String, dynamic>? metadata,
    String? mimeType,
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
    int? expiration,
  }) = _FileMessage;

  /// Creates a file message from a map (decoded JSON).
  factory FileMessage.fromJson(Map<String, dynamic> json) =>
      _$FileMessageFromJson(json);

  /// Creates a full file message from a partial one.
  factory FileMessage.fromPartial({
    required User author,
    required int createdAt,
    required String id,
    bool? isLoading,
    required PartialFile partialFile,
    String? remoteId,
    String? roomId,
    bool? showStatus,
    Status? status,
    int? updatedAt,
    int? expiration,
  }) =>
      _FileMessage(
        author: author,
        createdAt: createdAt,
        id: id,
        isLoading: isLoading,
        metadata: partialFile.metadata,
        mimeType: partialFile.mimeType,
        name: partialFile.name,
        remoteId: remoteId,
        repliedMessage: partialFile.repliedMessage,
        roomId: roomId,
        showStatus: showStatus,
        size: partialFile.size,
        status: status,
        type: MessageType.file,
        updatedAt: updatedAt,
        uri: partialFile.uri,
        expiration: expiration,
      );

  /// Specify whether the message content is currently being loaded.
  final bool? isLoading;

  /// Media type.
  final String? mimeType;

  /// The name of the file.
  final String name;

  /// Size of the file in bytes.
  final num size;

  /// The file source (either a remote URL or a local resource).
  final String uri;

  @override
  String get content => '';

  /// Equatable props.
  @override
  List<Object?> get props => [
        author,
        createdAt,
        id,
        isLoading,
        metadata,
        mimeType,
        name,
        remoteId,
        repliedMessage,
        roomId,
        showStatus,
        size,
        status,
        updatedAt,
        uri,
        expiration,
      ];

  @override
  Message copyWith({
    User? author,
    int? createdAt,
    String? id,
    dynamic sourceKey,
    bool? isLoading,
    Map<String, dynamic>? metadata,
    String? mimeType,
    String? name,
    String? remoteId,
    Message? repliedMessage,
    String? roomId,
    bool? showStatus,
    num? size,
    Status? status,
    int? updatedAt,
    String? uri,
    EncryptionType? fileEncryptionType,
    int? expiration,
  });

  /// Converts a file message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$FileMessageToJson(this);
}

/// A utility class to enable better copyWith.
class _FileMessage extends FileMessage {
  const _FileMessage({
    required super.author,
    required super.createdAt,
    required super.id,
    super.sourceKey,
    super.isLoading,
    super.metadata,
    super.mimeType,
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
    super.expiration,
  }) : super._();

  @override
  Message copyWith({
    User? author,
    int? createdAt,
    dynamic height = _Unset,
    String? id,
    dynamic sourceKey,
    dynamic isLoading = _Unset,
    dynamic metadata = _Unset,
    dynamic mimeType = _Unset,
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
    EncryptionType? fileEncryptionType,
    int? expiration,
  }) =>
      _FileMessage(
        author: author ?? this.author,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        sourceKey: sourceKey ?? this.sourceKey,
        isLoading: isLoading == _Unset ? this.isLoading : isLoading as bool?,
        metadata: metadata == _Unset
            ? this.metadata
            : metadata as Map<String, dynamic>?,
        mimeType: mimeType == _Unset ? this.mimeType : mimeType as String?,
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
        expiration: expiration ?? this.expiration,
      );
}

class _Unset {}
