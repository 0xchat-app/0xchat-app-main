// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioMessage _$AudioMessageFromJson(Map<String, dynamic> json) => AudioMessage(
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as int,
      duration: json['duration'] == null ? null: Duration(microseconds: json['duration'] as int),
      id: json['id'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      mimeType: json['mimeType'] as String?,
      name: json['name'] as String,
      remoteId: json['remoteId'] as String?,
      repliedMessage: json['repliedMessage'] == null
          ? null
          : Message.fromJson(json['repliedMessage'] as Map<String, dynamic>),
      roomId: json['roomId'] as String?,
      showStatus: json['showStatus'] as bool?,
      size: json['size'] as num,
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      updatedAt: json['updatedAt'] as int?,
      uri: json['uri'] as String,
      waveForm: (json['waveForm'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$AudioMessageToJson(AudioMessage instance) =>
    <String, dynamic>{
      'author': instance.author,
      'createdAt': instance.createdAt,
      'id': instance.id,
      'metadata': instance.metadata,
      'remoteId': instance.remoteId,
      'repliedMessage': instance.repliedMessage,
      'roomId': instance.roomId,
      'showStatus': instance.showStatus,
      'status': _$StatusEnumMap[instance.status],
      'type': _$MessageTypeEnumMap[instance.type]!,
      'updatedAt': instance.updatedAt,
      'duration': instance.duration?.inMicroseconds,
      'mimeType': instance.mimeType,
      'name': instance.name,
      'size': instance.size,
      'uri': instance.uri,
      'waveForm': instance.waveForm,
    };

const _$StatusEnumMap = {
  Status.delivered: 'delivered',
  Status.error: 'error',
  Status.seen: 'seen',
  Status.sending: 'sending',
  Status.sent: 'sent',
};

const _$MessageTypeEnumMap = {
  MessageType.audio: 'audio',
  MessageType.custom: 'custom',
  MessageType.file: 'file',
  MessageType.image: 'image',
  MessageType.system: 'system',
  MessageType.text: 'text',
  MessageType.unsupported: 'unsupported',
  MessageType.video: 'video',
};
