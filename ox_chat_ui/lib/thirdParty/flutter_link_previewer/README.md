# Flutter Link Previewer

[![Pub](https://img.shields.io/pub/v/flutter_link_previewer)](https://pub.dartlang.org/packages/flutter_link_previewer)
[![build](https://github.com/flyerhq/flutter_link_previewer/workflows/build/badge.svg)](https://github.com/flyerhq/flutter_link_previewer/actions?query=workflow%3Abuild)
[![CodeFactor](https://www.codefactor.io/repository/github/flyerhq/flutter_link_previewer/badge)](https://www.codefactor.io/repository/github/flyerhq/flutter_link_previewer)

Customizable link and URL preview extracted from the provided text with the ability to render from the cache. Ideal for chat applications.

<br>

<p align="center">
  🇺🇦🇺🇦 We are Ukrainians. If you enjoy our work, please <a href="https://u24.gov.ua">consider donating</a> to help save our country. 🇺🇦🇺🇦
</p>

<br>

<img src="https://user-images.githubusercontent.com/14123304/193461843-6ec34142-dc2a-428d-9b11-9b3a35f265c6.png" width="430" height="932">

## Getting Started

```dart
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

LinkPreview(
  enableAnimation: true,
  onPreviewDataFetched: (data) {
    setState(() {
      // Save preview data to the state              
    });
  },
  previewData: _previewData, // Pass the preview data from the state
  text: 'https://flyer.chat',
  width: MediaQuery.of(context).size.width,
)
```

## Customization

```dart
final style = TextStyle(
  color: Colors.red,
  fontSize: 16,
  fontWeight: FontWeight.w500,
  height: 1.375,
);


LinkPreview(
  linkStyle: style,
  metadataTextStyle: style.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  metadataTitleStyle: style.copyWith(
    fontWeight: FontWeight.w800,
  ),
  padding: EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 16,
  ),
  onPreviewDataFetched: _onPreviewDataFetched,
  previewData: _previewData,
  text: 'https://flyer.chat',
  textStyle: style,
  width: width,
);
```

## License

[MIT](LICENSE)
