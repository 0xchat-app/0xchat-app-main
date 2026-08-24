//nostr: URI scheme
class Nip21 {
  static String? decode(String content) {
    var regExp = RegExp(r'nostr:');
    var match = regExp.matchAsPrefix(content);
    if(match != null){
      return content.substring(match.end, null);
    }
    return null;
  }

  static String encode(String content){
    return 'nostr:$content';
  }
}