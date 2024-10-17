import 'package:chatcore/chat-core.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'messages/audio_message.dart';
import 'messages/custom_message.dart';
import 'messages/file_message.dart';
import 'messages/image_message.dart';
import 'messages/system_message.dart';
import 'messages/text_message.dart';
import 'messages/unsupported_message.dart';
import 'messages/video_message.dart';
import 'user.dart' show User;

/// All possible message types.
enum MessageType {
  audio,
  custom,
  file,
  image,
  system,
  text,
  unsupported,
  video,
}

/// All possible statuses message can have.
enum Status { delivered, warning, error, seen, sending, sent }

/// File encryption type.
enum EncryptionType {
  none,
  encrypted,
}

class Reaction {
  String content = '';
  List<String> authors;
  Reaction({
    required this.content,
    List<String>? authors
  }) : authors = authors ?? [];
}

class ZapsInfo {
  UserDBISAR author;
  String amount;
  String unit;
  ZapsInfo({required this.author, required this.amount, required this.unit});
}

/// An abstract class that contains all variables and methods
/// every message will have.
@immutable
abstract class Message extends Equatable {
  const Message({
    required this.author,
    required this.createdAt,
    required String id,
    required this.sourceKey,
    this.metadata,
    this.remoteId,
    this.repliedMessage,
    this.repliedMessageId,
    this.roomId,
    this.showStatus,
    this.status,
    required this.type,
    this.updatedAt,
    this.fileEncryptionType = EncryptionType.none,
    this.decryptKey,
    this.decryptNonce,
    this.expiration,
    this.reactions = const [],
    this.zapsInfoList = const [],
  }) : _id = id;

  /// Creates a particular message from a map (decoded JSON).
  /// Type is determined by the `type` field.
  factory Message.fromJson(Map<String, dynamic> json) {
    final type = MessageType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => MessageType.unsupported,
    );

    switch (type) {
      case MessageType.audio:
        return AudioMessage.fromJson(json);
      case MessageType.custom:
        return CustomMessage.fromJson(json);
      case MessageType.file:
        return FileMessage.fromJson(json);
      case MessageType.image:
        return ImageMessage.fromJson(json);
      case MessageType.system:
        return SystemMessage.fromJson(json);
      case MessageType.text:
        return TextMessage.fromJson(json);
      case MessageType.unsupported:
        return UnsupportedMessage.fromJson(json);
      case MessageType.video:
        return VideoMessage.fromJson(json);
    }
  }

  /// User who sent this message.
  final User author;

  /// Created message timestamp, in ms.
  final int createdAt;

  /// Unique ID of the message.
  final String _id;
  String get id => _id;

  /// Additional custom metadata or attributes related to the message.
  final Map<String, dynamic>? metadata;

  /// Unique ID of the message received from the backend.
  final String? remoteId;

  /// Message that is being replied to with the current message.
  final Message? repliedMessage;
  final String? repliedMessageId;

  /// ID of the room where this message is sent.
  final String? roomId;

  /// Show status or not.
  final bool? showStatus;

  /// Message [Status].
  final Status? status;

  /// [MessageType].
  final MessageType type;

  /// Updated message timestamp, in ms.
  final int? updatedAt;

  /// The encryption type of the file
  final EncryptionType fileEncryptionType;

  final String? decryptKey;
  final String? decryptNonce;

  final dynamic sourceKey;

  String get content;

  final int? expiration;

  final List<Reaction> reactions;
  final List<ZapsInfo> zapsInfoList;

  bool get hasReactions => reactions.isNotEmpty || zapsInfoList.isNotEmpty;

  bool get viewWithoutBubble => false;


  /// Creates a copy of the message with an updated data.
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

  /// Converts a particular message to the map representation, serializable to JSON.
  Map<String, dynamic> toJson();

  @override
  String toString() => 'Message{'
      'author: $author, '
      'createdAt: $createdAt, '
      'id: $id, '
      'metadata: $metadata, '
      'remoteId: $remoteId, '
      'repliedMessage: $repliedMessage, '
      'repliedMessageId: $repliedMessageId, '
      'roomId: $roomId, '
      'showStatus: $showStatus, '
      'status: $status, '
      'type: $type, '
      'updatedAt: $updatedAt, '
      'fileEncryptionType: $fileEncryptionType, '
      'sourceKey: $sourceKey, '
      'expiration: $expiration, '
      'reactions: $reactions, '
      'zaps: $zapsInfoList'
      '}';
}
