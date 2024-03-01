// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviewData _$PreviewDataFromJson(Map<String, dynamic> json) => PreviewData(
      description: json['description'] as String?,
      image: json['image'] == null
          ? null
          : PreviewDataImage.fromJson(json['image'] as Map<String, dynamic>),
      link: json['link'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$PreviewDataToJson(PreviewData instance) =>
    <String, dynamic>{
      'description': instance.description,
      'image': instance.image,
      'link': instance.link,
      'title': instance.title,
    };

PreviewDataImage _$PreviewDataImageFromJson(Map<String, dynamic> json) =>
    PreviewDataImage(
      height: (json['height'] as num).toDouble(),
      url: json['url'] as String,
      width: (json['width'] as num).toDouble(),
    );

Map<String, dynamic> _$PreviewDataImageToJson(PreviewDataImage instance) =>
    <String, dynamic>{
      'height': instance.height,
      'url': instance.url,
      'width': instance.width,
    };
