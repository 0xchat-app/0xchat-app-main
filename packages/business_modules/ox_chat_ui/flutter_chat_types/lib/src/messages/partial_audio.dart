import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../message.dart';

part 'partial_audio.g.dart';

/// A class that represents partial audio message.
@JsonSerializable()
@immutable
class PartialAudio {
  /// Creates a partial audio message with all variables audio can have.
  /// Use [AudioMessage] to create a full message.
  /// You can use [AudioMessage.fromPartial] constructor to create a full
  /// message from a partial one.
  const PartialAudio({
    this.isPlaying,
    required this.duration,
    this.metadata,
    this.mimeType,
    required this.name,
    this.repliedMessage,
    this.repliedMessageId,
    required this.size,
    required this.uri,
    this.waveForm,
  });

  /// Creates a partial audio message from a map (decoded JSON).
  factory PartialAudio.fromJson(Map<String, dynamic> json) =>
      _$PartialAudioFromJson(json);

  /// The length of the audio.
  final Duration duration;

  /// Additional custom metadata or attributes related to the message.
  final Map<String, dynamic>? metadata;

  /// Media type of the audio file.
  final String? mimeType;

  /// The name of the audio.
  final String name;

  /// Message that is being replied to with the current message.
  final Message? repliedMessage;
  final String? repliedMessageId;

  /// Size of the audio in bytes.
  final num size;

  /// The audio file source (either a remote URL or a local resource).
  final String uri;

  /// Wave form represented as a list of decibel levels.
  final List<double>? waveForm;

  final bool? isPlaying;

  /// Converts a partial audio message to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$PartialAudioToJson(this);
}
