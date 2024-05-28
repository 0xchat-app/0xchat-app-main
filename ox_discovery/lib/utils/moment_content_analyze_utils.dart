import 'package:chatcore/chat-core.dart';

class MomentContentAnalyzeUtils {
  final String content;
  MomentContentAnalyzeUtils(this.content);

  static Map<String, RegExp> regexMap = {
    'hashRegex': RegExp(r"#(\S+)"),
    'urlExp': RegExp(r"(https?:\/\/[^\s]+)"),
    'nostrExp': RegExp(r'\bnostr:(npub|note|nprofile|nevent|nrelay|naddr)[0-9a-zA-Z]{8,}\b'),
    'noteExp': RegExp(r"nostr:note1\S+|nostr:nevent1\S+"),
    'imgExp': RegExp(r'\bhttps?://\S+\.(?:png|jpg|jpeg|gif)\b\S*', caseSensitive: false),
    'audioExp': RegExp(r'\bhttps?://\S+\.(?:mp3|wav|aac|m4a|mp4|avi|mov|wmv)\b\S*', caseSensitive: false),
    'youtubeExp': RegExp(r'(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/[^\s]*'),
    'lineFeed': RegExp(r"\n"),
    'showMore': RegExp(r"show more$"),
  };

  Future<Map<String,UserDB?>> get getUserInfoMap async{
    Map<String,UserDB?> userDBList = {};
    final RegExp nostrExp = regexMap['nostrExp'] as RegExp;
    final Iterable<RegExpMatch> matches = nostrExp.allMatches(content);

    final List<String> pubKey = matches.map((m) => m.group(0)!).toList();
    for(String key in pubKey){
      Map<String, dynamic>? userMap = Account.decodeProfile(key);
      if(userMap == null) break;
      final pubkey = userMap['pubkey'] as String? ?? '';
      UserDB? user = await Account.sharedInstance.getUserInfo(pubkey);
      if(user != null){
        userDBList[key] = user;
      }
    }
    return userDBList;
  }

  List<String> get getQuoteUrlList {
    final RegExp noteExp = regexMap['noteExp'] as RegExp;
    final Iterable<RegExpMatch> matches = noteExp.allMatches(content);
    final List<String> noteList = matches.map((m) => m.group(0)!).toList();
    return noteList;
  }

  // type = 1 image 2 video
  List<String> getMediaList(int type){
    final RegExp imgExp = regexMap['imgExp'] as RegExp;
    final RegExp audioExp = regexMap['audioExp'] as RegExp;
    final RegExp youtubeExp = regexMap['youtubeExp'] as RegExp;
    RegExp getRegExp = type == 1 ? imgExp : RegExp('${audioExp.pattern}|${youtubeExp.pattern}', caseSensitive: false);
    final Iterable<RegExpMatch> matches = getRegExp.allMatches(content);

    final List<String> filesList = matches.map((m) => m.group(0)!).toList();
    return filesList;
  }

  List<String> get getMomentExternalLink {
    final RegExp urlExp = regexMap['urlExp'] as RegExp;
    final Iterable<RegExpMatch> matches = urlExp.allMatches(content);
    final List<String> urlList = matches.map((m) => m.group(0)!).toList();
    return urlList;
  }

   String get getMomentShowContent {
     final RegExp imgExp = regexMap['imgExp'] as RegExp;
     final RegExp audioExp = regexMap['audioExp'] as RegExp;
     final RegExp youtubeExp = regexMap['youtubeExp'] as RegExp;
     final RegExp noteExp = regexMap['noteExp'] as RegExp;

      final RegExp contentExp = RegExp('${imgExp.pattern}|${audioExp.pattern}|${noteExp.pattern}|${youtubeExp.pattern}', caseSensitive: false);
     final String cleanedText = content.replaceAll(contentExp, '');
     return cleanedText.trim();
  }

  String get getMomentPlainText {
    final RegExp imgExp = regexMap['imgExp'] as RegExp;
    final RegExp audioExp = regexMap['audioExp'] as RegExp;
    final RegExp noteExp = regexMap['noteExp'] as RegExp;
    final RegExp nostrExp = regexMap['nostrExp'] as RegExp;
    final RegExp youtubeExp = regexMap['youtubeExp'] as RegExp;

    final RegExp contentExp = RegExp('${imgExp.pattern}|${audioExp.pattern}|${noteExp.pattern}|${nostrExp.pattern}|${youtubeExp.pattern}', caseSensitive: false);
    final String cleanedText = content.replaceAll(contentExp, '');
    return cleanedText.trim();
  }

  List<String> get getMomentHashTagList {
    final RegExp hashRegex = regexMap['hashRegex'] as RegExp;
    final Iterable<RegExpMatch> matches = hashRegex.allMatches(content);
    final List<String> hashList = matches.map((m) => m.group(0)!).toList();
    return hashList;
  }
}

