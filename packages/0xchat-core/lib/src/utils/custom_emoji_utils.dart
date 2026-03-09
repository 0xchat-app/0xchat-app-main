// Custom Emoji Utils for NIP-30 support
// Provides utilities for extracting and processing custom emojis in content

class CustomEmojiUtils {
  // Extract emoji shortcodes from content
  // Returns a map of shortcode to URL (empty URLs, to be filled by caller)
  static Set<String> extractEmojiShortcodes(String content) {
    // Match :shortcode: pattern (alphanumeric and underscore only per NIP-30)
    final regex = RegExp(r':([a-zA-Z0-9_]+):');
    final matches = regex.allMatches(content);
    
    Set<String> shortcodes = {};
    for (var match in matches) {
      final shortcode = match.group(1);
      if (shortcode != null && shortcode.isNotEmpty) {
        shortcodes.add(shortcode);
      }
    }
    
    return shortcodes;
  }

  // Replace emoji shortcodes in content with actual emoji images
  // Used for rendering content with custom emojis
  static String replaceEmojisInContent(
    String content,
    Map<String, String> emojiMap,
  ) {
    if (emojiMap.isEmpty) return content;
    
    String result = content;
    emojiMap.forEach((shortcode, url) {
      // Replace :shortcode: with the URL or keep as is
      result = result.replaceAll(':$shortcode:', ':$shortcode:');
    });
    
    return result;
  }

  // Get emoji URLs from content for rendering
  // Returns list of objects with shortcode and URL
  static List<EmojiInfo> getEmojisForRendering(
    String content,
    Map<String, String> emojiMap,
  ) {
    if (emojiMap.isEmpty) return [];
    
    final regex = RegExp(r':([a-zA-Z0-9_]+):');
    final matches = regex.allMatches(content);
    
    List<EmojiInfo> emojis = [];
    Set<String> processedShortcodes = {};
    
    for (var match in matches) {
      final shortcode = match.group(1);
      if (shortcode != null && 
          emojiMap.containsKey(shortcode) &&
          !processedShortcodes.contains(shortcode)) {
        emojis.add(EmojiInfo(
          shortcode: shortcode,
          url: emojiMap[shortcode]!,
        ));
        processedShortcodes.add(shortcode);
      }
    }
    
    return emojis;
  }
}

class EmojiInfo {
  final String shortcode;
  final String url;

  EmojiInfo({
    required this.shortcode,
    required this.url,
  });
}

