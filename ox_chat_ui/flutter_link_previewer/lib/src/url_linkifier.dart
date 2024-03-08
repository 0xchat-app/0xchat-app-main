import 'package:linkify/linkify.dart';
import 'package:meta/meta.dart';

final _urlRegex = RegExp(
  r'^(.*?)((?:https?:\/\/|www\.)[^\s/$.?#].[^\s]*)',
  caseSensitive: false,
  dotAll: true,
);

final _looseUrlRegex = RegExp(
  r'^(.*?)((https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*))',
  caseSensitive: false,
  dotAll: true,
);

final _protocolIdentifierRegex = RegExp(
  r'^(https?:\/\/)',
  caseSensitive: false,
);

/// Utility class that implements [Linkifier.parse] method.
/// Used to find links in the text.
class UrlLinkifier extends Linkifier {
  /// Default constructor.
  const UrlLinkifier();

  /// Parses text to find all links inside it.
  @override
  List<LinkifyElement> parse(
    List<LinkifyElement> elements,
    LinkifyOptions options,
  ) {
    final list = <LinkifyElement>[];

    for (final element in elements) {
      if (element is TextElement) {
        var loose = false;
        var match = _urlRegex.firstMatch(element.text);

        if (match?.group(1)?.isNotEmpty == true) {
          final looseMatch = _looseUrlRegex.firstMatch(match!.group(1)!);
          if (looseMatch != null) {
            match = looseMatch;
            loose = true;
          }
        }

        if (match == null && options.looseUrl) {
          match = _looseUrlRegex.firstMatch(element.text);
          loose = true;
        }

        if (match == null) {
          list.add(element);
        } else {
          final text = element.text.replaceFirst(match.group(0)!, '');

          if (match.group(1)?.isNotEmpty == true) {
            list.add(TextElement(match.group(1)!));
          }

          if (match.group(2)?.isNotEmpty == true) {
            var originalUrl = match.group(2)!;
            String? end;

            if (options.excludeLastPeriod &&
                originalUrl[originalUrl.length - 1] == '.') {
              end = '.';
              originalUrl = originalUrl.substring(0, originalUrl.length - 1);
            }

            final url = originalUrl;

            if (loose || !originalUrl.startsWith(_protocolIdentifierRegex)) {
              originalUrl = (options.defaultToHttps ? 'https://' : 'http://') +
                  originalUrl;
            }

            list.add(
              UrlElement(
                originalUrl,
                url,
              ),
            );

            if (end != null) {
              list.add(TextElement(end));
            }
          }

          if (text.isNotEmpty) {
            list.addAll(parse([TextElement(text)], options));
          }
        }
      } else {
        list.add(element);
      }
    }

    return list;
  }
}

/// Represents an element containing a link.
@immutable
class UrlElement extends LinkableElement {
  /// Creates [UrlElement].
  UrlElement(String url, [String? text]) : super(text, url);

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) => equals(other);

  @override
  // ignore: type_annotate_public_apis
  bool equals(other) => other is UrlElement && super.equals(other);

  @override
  String toString() => "LinkElement: '$url' ($text)";
}
