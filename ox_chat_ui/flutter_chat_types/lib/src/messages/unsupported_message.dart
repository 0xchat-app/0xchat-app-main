import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../message.dart';
import '../user.dart' show User;

part 'unsupported_message.g.dart';

/// A class that represents unsupported message. Used for backwards
/// compatibility. If chat's end user doesn't update to a new version
/// where new message types are being sent, some of them will result
/// to unsupported.
@JsonSerializable()
@immutable
abstract class UnsupportedMessage extends Message {
  /// Creates an unsupported message.
  const UnsupportedMessage._({
    required super.author,
    required super.createdAt,
    required super.id,
    super.sourceKey,
    super.metadata,
    super.remoteId,
    super.repliedMessage,
    super.repliedMessageId,
    super.roomId,
    super.showStatus,
    super.status,
    MessageType? type,
    super.updatedAt,
    super.expiration,
    super.reactions,
    super.zapsInfoList,
  }) : super(type: type ?? MessageType.unsupported);

  const factory UnsupportedMessage({
    required User author,
    required int createdAt,
    required String id,
    dynamic sourceKey,
    Map<String, dynamic>? metadata,
    String? remoteId,
    Message? repliedMessage,
    String? repliedMessageId,
    String? roomId,
    bool? showStatus,
    Status? status,
    MessageType? type,
    int? updatedAt,
    int? expiration,
    List<Reaction> reactions,
    List<ZapsInfo> zapsInfoList,
  }) = _UnsupportedMessage;

  /// Creates an unsupported message from a map (decoded JSON).
  factory UnsupportedMessage.fromJson(Map<String, dynamic> json) =>
      _$UnsupportedMessageFromJson(json);

  /// Equatable props.
  @override
  List<Object?> get props => [
        author,
        createdAt,
        id,
        metadata,
        remoteId,
        repliedMessage,
        roomId,
        showStatus,
        status,
        updatedAt,
        expiration,
      ];

  @override
  Message copyWith({
    User? author,
    int? createdAt,
    String? id,
    dynamic sourceKey,
    Map<String, dynamic>? metadata,
    String? remoteId,
    Message? repliedMessage,
    String? repliedMessageId,
    String? roomId,
    bool? showStatus,
    Status? status,
    int? updatedAt,
    EncryptionType? fileEncryptionType,
    String? decryptKey,
    int? expiration,
    List<Reaction>? reactions,
    List<ZapsInfo>? zapsInfoList,
  });

  /// Converts an unsupported message to the map representation,
  /// encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$UnsupportedMessageToJson(this);
}

/// A utility class to enable better copyWith.
class _UnsupportedMessage extends UnsupportedMessage {

  const _UnsupportedMessage({
    required super.author,
    required super.createdAt,
    required super.id,
    super.sourceKey,
    super.metadata,
    super.remoteId,
    super.repliedMessage,
    super.repliedMessageId,
    super.roomId,
    super.showStatus,
    super.status,
    super.type,
    super.updatedAt,
    super.expiration,
    super.reactions,
    super.zapsInfoList,
  }) : super._();

  @override
  String get content => '';

  @override
  Message copyWith({
    User? author,
    int? createdAt,
    String? id,
    dynamic sourceKey,
    dynamic metadata = _Unset,
    dynamic remoteId = _Unset,
    dynamic repliedMessage = _Unset,
    String? repliedMessageId,
    dynamic roomId,
    dynamic showStatus = _Unset,
    dynamic status = _Unset,
    dynamic updatedAt = _Unset,
    EncryptionType? fileEncryptionType,
    String? decryptKey,
    int? expiration,
    List<Reaction>? reactions,
    List<ZapsInfo>? zapsInfoList,
  }) =>
      _UnsupportedMessage(
        author: author ?? this.author,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        sourceKey: sourceKey ?? this.sourceKey,
        metadata: metadata == _Unset
            ? this.metadata
            : metadata as Map<String, dynamic>?,
        remoteId: remoteId == _Unset ? this.remoteId : remoteId as String?,
        repliedMessage: repliedMessage == _Unset
            ? this.repliedMessage
            : repliedMessage as Message?,
        repliedMessageId: repliedMessageId ?? this.repliedMessageId,
        roomId: roomId == _Unset ? this.roomId : roomId as String?,
        showStatus:
            showStatus == _Unset ? this.showStatus : showStatus as bool?,
        status: status == _Unset ? this.status : status as Status?,
        updatedAt: updatedAt == _Unset ? this.updatedAt : updatedAt as int?,
        expiration: expiration ?? this.expiration,
      );
}

class _Unset {}
