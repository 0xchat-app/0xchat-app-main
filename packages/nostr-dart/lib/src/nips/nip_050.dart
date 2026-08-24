import 'package:nostr_core_dart/nostr.dart';

/// NIP-50: Search Capability
/// 
/// Reference: https://github.com/nostr-protocol/nips/blob/master/50.md
/// 
/// Many Nostr use cases require some form of general search feature, 
/// in addition to structured queries by tags or ids.
/// 
/// This NIP describes a general extensible framework for performing such queries.
class Nip50 {
  /// Create a Filter with search capability
  /// 
  /// ```dart
  /// // Simple search
  /// Filter filter = Nip50.encode(
  ///   search: "best nostr apps",
  ///   kinds: [1],
  ///   limit: 50,
  /// );
  /// 
  /// // Search with extensions
  /// Filter filter = Nip50.encode(
  ///   search: "nostr development",
  ///   kinds: [1],
  ///   limit: 50,
  ///   language: "en",
  ///   nsfw: false,
  /// );
  /// 
  /// // Search only by language (no search text)
  /// Filter filter = Nip50.encode(
  ///   kinds: [1],
  ///   limit: 50,
  ///   language: "zh",
  /// );
  /// ```
  static Filter encode({
    String? search,
    List<int>? kinds,
    int? limit,
    bool? includeSpam,
    String? domain,
    String? language,
    String? sentiment,
    bool? nsfw,
  }) {
    String searchQuery = _buildSearchQuery(
      search,
      includeSpam: includeSpam,
      domain: domain,
      language: language,
      sentiment: sentiment,
      nsfw: nsfw,
    );

    return Filter(
      kinds: kinds,
      search: searchQuery.isNotEmpty ? searchQuery : null,
      limit: limit,
    );
  }

  /// Build search query string with extensions
  static String _buildSearchQuery(
    String? search, {
    bool? includeSpam,
    String? domain,
    String? language,
    String? sentiment,
    bool? nsfw,
  }) {
    List<String> parts = [];

    if (search != null && search.isNotEmpty) {
      parts.add(search.trim());
    }

    if (includeSpam == true) {
      parts.add('include:spam');
    }

    if (domain != null && domain.isNotEmpty) {
      parts.add('domain:$domain');
    }

    if (language != null && language.isNotEmpty) {
      parts.add('language:${language.toLowerCase()}');
    }

    if (sentiment != null && sentiment.isNotEmpty) {
      final validSentiments = ['negative', 'neutral', 'positive'];
      final lowerSentiment = sentiment.toLowerCase();
      if (validSentiments.contains(lowerSentiment)) {
        parts.add('sentiment:$lowerSentiment');
      }
    }

    if (nsfw != null) {
      parts.add('nsfw:$nsfw');
    }

    return parts.join(' ');
  }
}

