import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'preview_data.g.dart';

/// A class that represents data obtained from the web resource (link preview).
///
/// See https://github.com/flyerhq/flutter_link_previewer
@JsonSerializable()
@immutable
abstract class PreviewData extends Equatable {
  /// Creates preview data.
  const PreviewData._({
    this.description,
    this.image,
    this.link,
    this.title,
  });

  const factory PreviewData({
    String? description,
    PreviewDataImage? image,
    String? link,
    String? title,
  }) = _PreviewData;

  /// Creates preview data from a map (decoded JSON).
  factory PreviewData.fromJson(Map<String, dynamic> json) =>
      _$PreviewDataFromJson(json);

  /// Link description (usually og:description meta tag).
  final String? description;

  /// See [PreviewDataImage].
  final PreviewDataImage? image;

  /// Remote resource URL.
  final String? link;

  /// Link title (usually og:title meta tag).
  final String? title;

  /// Equatable props.
  @override
  List<Object?> get props => [description, image, link, title];

  /// Creates a copy of the preview data with an updated data.
  PreviewData copyWith({
    String? description,
    PreviewDataImage? image,
    String? link,
    String? title,
  });

  /// Converts preview data to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$PreviewDataToJson(this);
}

/// A utility class to enable better copyWith.
class _PreviewData extends PreviewData {
  const _PreviewData({
    super.description,
    super.image,
    super.link,
    super.title,
  }) : super._();

  @override
  PreviewData copyWith({
    dynamic description = _Unset,
    dynamic image = _Unset,
    dynamic link = _Unset,
    dynamic title = _Unset,
  }) =>
      _PreviewData(
        description:
            description == _Unset ? this.description : description as String?,
        image: image == _Unset ? this.image : image as PreviewDataImage?,
        link: link == _Unset ? this.link : link as String?,
        title: title == _Unset ? this.title : title as String?,
      );
}

class _Unset {}

/// A utility class that forces image's width and height to be stored
/// alongside the url.
///
/// See https://github.com/flyerhq/flutter_link_previewer
@JsonSerializable()
@immutable
class PreviewDataImage extends Equatable {
  /// Creates preview data image.
  const PreviewDataImage({
    required this.height,
    required this.url,
    required this.width,
  });

  /// Creates preview data image from a map (decoded JSON).
  factory PreviewDataImage.fromJson(Map<String, dynamic> json) =>
      _$PreviewDataImageFromJson(json);

  /// Image height in pixels.
  final double height;

  /// Remote image URL.
  final String url;

  /// Image width in pixels.
  final double width;

  /// Equatable props.
  @override
  List<Object> get props => [height, url, width];

  /// Converts preview data image to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$PreviewDataImageToJson(this);
}
