
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart' hide Element;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' as parser show parse;
import 'package:http/http.dart' as http show head, get;

class PreviewDataImage {
  PreviewDataImage({
    required this.url,
    required this.height,
    required this.width,
  });

  /// Remote image URL.
  final String url;

  /// Image height in pixels.
  final double height;

  /// Image width in pixels.
  final double width;

  factory PreviewDataImage.fromJson(Map<String, dynamic> json) =>
      PreviewDataImage(
        height: (json['height'] as num).toDouble(),
        url: json['url'] as String,
        width: (json['width'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'height': height,
        'url': url,
        'width': width,
      };
}

class PreviewData {

  const PreviewData({
    this.description,
    this.image,
    this.link,
    this.title,
  });

  /// Link title (usually og:title meta tag).
  final String? title;

  /// See [PreviewDataImage].
  final PreviewDataImage? image;

  /// Remote resource URL.
  final String? link;

  /// Link description (usually og:description meta tag).
  final String? description;

  bool get hasTitle => title != null && title!.isNotEmpty;
  bool get hasLink => link != null && link!.isNotEmpty;

  factory PreviewData.fromJson(Map<String, dynamic> json) => PreviewData(
    description: json['description'] as String?,
    image: json['image'] == null
        ? null
        : PreviewDataImage.fromJson(json['image'] as Map<String, dynamic>),
    link: json['link'] as String?,
    title: json['title'] as String?,
  );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'description': description,
        'image': image?.toJson(),
        'link': link,
        'title': title,
      };
  @override
  String toString() {
    return '${super.toString()}, title: $title, link: $link, description: $description';
  }
}

class WebURLHelper {

  /// Regex to check if text is email.
  static const regexEmail = r'([a-zA-Z0-9+._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)';

  /// Regex to check if content type is an image.
  static const regexImageContentType = r'image/.*';

  static const regexHTMLContentType = r'^text\/html(;.*)?$';

  /// Regex to find all links in the text.
  static const regexLink =
      r'((http|ftp|https):\/\/)?([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?';

  static const regexNostr = r'nostr:(npub|nsec|note|nprofile|nevent|nrelay|naddr)[0-9a-zA-Z]{8,}(?=\s|$)';

  static String _calculateUrl(String baseUrl, String? proxy) {
    if (proxy != null) {
      return '$proxy$baseUrl';
    }

    return baseUrl;
  }

  static String? _getMetaContent(Document document, String propertyValue) {
    final meta = document.getElementsByTagName('meta');
    final element = meta.firstWhere(
          (e) => e.attributes['property'] == propertyValue,
      orElse: () => meta.firstWhere(
            (e) => e.attributes['name'] == propertyValue,
        orElse: () => Element.tag(null),
      ),
    );

    return element.attributes['content']?.trim();
  }

  static bool _hasUTF8Charset(Document document) {
    final emptyElement = Element.tag(null);
    final meta = document.getElementsByTagName('meta');
    final element = meta.firstWhere(
          (e) => e.attributes.containsKey('charset'),
      orElse: () => emptyElement,
    );
    if (element == emptyElement) return true;
    return element.attributes['charset']!.toLowerCase() == 'utf-8';
  }

  static String? _getTitle(Document document) {
    return document.getElementsByTagName('title').firstOrNull?.text;
  }

  static String? _getShareTitle(Document document) {
    return _getMetaContent(document, 'og:title') ??
        _getMetaContent(document, 'twitter:title') ??
        _getMetaContent(document, 'og:site_name');
  }

  static String? _getDescription(Document document) =>
      _getMetaContent(document, 'og:description') ??
          _getMetaContent(document, 'description') ??
          _getMetaContent(document, 'twitter:description');

  static List<String> _getImageUrls(Document document, String baseUrl) {
    final meta = document.getElementsByTagName('meta');
    var attribute = 'content';
    var elements = meta
        .where(
          (e) =>
      e.attributes['property'] == 'og:image' ||
          e.attributes['property'] == 'twitter:image',
    )
        .toList();

    if (elements.isEmpty) {
      elements = document.getElementsByTagName('img');
      attribute = 'src';
    }

    return elements.fold<List<String>>([], (previousValue, element) {
      final actualImageUrl = _getActualImageUrl(
        baseUrl,
        element.attributes[attribute]?.trim(),
      );

      return actualImageUrl != null
          ? [...previousValue, actualImageUrl]
          : previousValue;
    });
  }

  static String? _getActualImageUrl(String baseUrl, String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty || imageUrl.startsWith('data')) {
      return null;
    }

    if (imageUrl.contains('.svg') || imageUrl.contains('.gif')) return null;

    if (imageUrl.startsWith('//')) imageUrl = 'https:$imageUrl';

    if (!imageUrl.startsWith('http')) {
      if (baseUrl.endsWith('/') && imageUrl.startsWith('/')) {
        imageUrl = '${baseUrl.substring(0, baseUrl.length - 1)}$imageUrl';
      } else if (!baseUrl.endsWith('/') && !imageUrl.startsWith('/')) {
        imageUrl = '$baseUrl/$imageUrl';
      } else {
        imageUrl = '$baseUrl$imageUrl';
      }
    }

    return imageUrl;
  }

  static Future<Size> _getImageSize(String url) async {
    final completer = Completer<Size>();
    final stream = Image.network(url).image.resolve(ImageConfiguration.empty);
    late ImageStreamListener streamListener;

    void onError(Object error, StackTrace? stackTrace) {
      completer.completeError(error, stackTrace);
    }

    void listener(ImageInfo info, bool _) {
      if (!completer.isCompleted) {
        completer.complete(
          Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          ),
        );
      }
      stream.removeListener(streamListener);
    }

    streamListener = ImageStreamListener(listener, onError: onError);

    stream.addListener(streamListener);
    return completer.future;
  }

  static Future<String> _getBiggestImageUrl(
      List<String> imageUrls,
      String? proxy,
      ) async {
    if (imageUrls.length > 5) {
      imageUrls.removeRange(5, imageUrls.length);
    }

    var currentUrl = imageUrls[0];
    var currentArea = 0.0;

    await Future.forEach(imageUrls, (String url) async {
      final size = await _getImageSize(_calculateUrl(url, proxy));
      final area = size.width * size.height;
      if (area > currentArea) {
        currentArea = area;
        currentUrl = _calculateUrl(url, proxy);
      }
    });

    return currentUrl;
  }

  /// Parses provided text and returns [PreviewData] for the first found link.
  static Future<PreviewData?> getPreviewData(
      String text, {
        String? proxy,
        Duration? requestTimeout,
        String? userAgent,
        bool isShare = false,
      }) async {
    const previewData = PreviewData();

    String? previewDataDescription;
    PreviewDataImage? previewDataImage;
    String? previewDataTitle;
    String? previewDataUrl;

    try {
      final emailRegexp = RegExp(regexEmail, caseSensitive: false);
      final textWithoutEmails = text
          .replaceAllMapped(
        emailRegexp,
            (match) => '',
      )
          .trim();
      if (textWithoutEmails.isEmpty) return previewData;

      final urlRegexp = RegExp(regexLink, caseSensitive: false);
      final matches = urlRegexp.allMatches(textWithoutEmails);
      if (matches.isEmpty) return previewData;

      var url = textWithoutEmails.substring(
        matches.first.start,
        matches.first.end,
      );

      if (!url.toLowerCase().startsWith('http')) {
        url = 'https://$url';
      }
      previewDataUrl = _calculateUrl(url, proxy);
      final uri = Uri.parse(previewDataUrl);
      
      final headResponse = await http.head(uri);
      final contentType = headResponse.headers['content-type'] ?? '';

      final imageRegexp = RegExp(regexImageContentType);
      if (imageRegexp.hasMatch(contentType)) {
        final imageSize = await _getImageSize(previewDataUrl);
        previewDataImage = PreviewDataImage(
          height: imageSize.height,
          url: previewDataUrl,
          width: imageSize.width,
        );
        return PreviewData(
          image: previewDataImage,
          link: previewDataUrl,
        );
      }

      final htmlReg = RegExp(r'^text\/html(;.*)?$', caseSensitive: false);
      final isHtmlContent = htmlReg.hasMatch(contentType);
      if (!isHtmlContent) return null;

      final response = await http.get(uri, headers: {
        'User-Agent': userAgent ?? 'WhatsApp/2',
      }).timeout(requestTimeout ?? const Duration(seconds: 5));

      final document = parser.parse(utf8.decode(response.bodyBytes));

      if (!_hasUTF8Charset(document)) {
        return previewData;
      }

      final title = isShare ? _getShareTitle(document) : _getTitle(document);
      if (title != null) {
        previewDataTitle = title.trim();
      }

      final description = _getDescription(document);
      if (description != null) {
        previewDataDescription = description.trim();
      }

      final imageUrls = _getImageUrls(document, url);

      Size imageSize;
      String imageUrl;

      if (imageUrls.isNotEmpty) {
        imageUrl = imageUrls.length == 1
            ? _calculateUrl(imageUrls[0], proxy)
            : await _getBiggestImageUrl(imageUrls, proxy);

        imageSize = await _getImageSize(imageUrl);
        previewDataImage = PreviewDataImage(
          height: imageSize.height,
          url: imageUrl,
          width: imageSize.width,
        );
      }
      return PreviewData(
        description: previewDataDescription,
        image: previewDataImage,
        link: previewDataUrl,
        title: previewDataTitle,
      );
    } catch (e) {
      return PreviewData(
        description: previewDataDescription,
        image: previewDataImage,
        link: previewDataUrl,
        title: previewDataTitle,
      );
    }
  }
}