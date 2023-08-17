
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_data_cache.dart';

class MessageContentModel{
  MessageType? contentType;
  String? content;
  String? mid;
  int? duration;

  MessageContentModel({this.contentType, this.content, this.mid, this.duration});

  factory MessageContentModel.fromJson(Map<String, dynamic> json) {
    return MessageContentModel(
      contentType: json['contentType'] != null
          ? messageTypeFromString(json['contentType'])
          : null,
      content: json['content'],
      mid: json['mid'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contentType'] = contentType?.toString().split('.').last;
    data['content'] = content;
    data['mid'] = mid;
    data['duration'] = duration;
    return data;
  }

  static messageTypeFromString(String value) {
    switch (value) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'audio':
        return MessageType.audio;
      case 'file':
        return MessageType.file;
      case 'template':
        return MessageType.template;
      default:
        throw ArgumentError('Invalid message type: $value');
    }
  }
}


