import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../message.dart';
import '../preview_data.dart' show PreviewData;
import 'text_message.dart';

part 'partial_text.g.dart';

/// A class that represents partial text message.
@JsonSerializable()
@immutable
class PartialText {
  /// Creates a partial text message with all variables text can have.
  /// Use [TextMessage] to create a full message.
  /// You can use [TextMessage.fromPartial] constructor to create a full
  /// message from a partial one.
  const PartialText({
    this.metadata,
    this.previewData,
    this.repliedMessage,
    required this.text,
  });

  /// Creates a partial text message from a map (decoded JSON).
  factory PartialText.fromJson(Map<String, dynamic> json) =>
      _$PartialTextFromJson(json);

  /// Additional custom metadata or attributes related to the message.
  final Map<String, dynamic>? metadata;

  /// See [PreviewData].
  final PreviewData? previewData;

  /// Message that is being replied to with the current message.
  final Message? repliedMessage;

  /// User's message.
  final String text;

  /// Converts a partial text message to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$PartialTextToJson(this);
}
