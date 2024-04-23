import 'package:chatcore/chat-core.dart';

class MomentContentAnalyzeUtils{
  final String content;
  MomentContentAnalyzeUtils(this.content);

  Future<Map<String,UserDB?>> get getUserInfoMap async{
    Map<String,UserDB?> userDBList = {};
    final RegExp nostrExp = RegExp(r"nostr:npub\w+|npub\w+");
    final Iterable<RegExpMatch> matches = nostrExp.allMatches(content);

    final List<String> pubKey = matches.map((m) => m.group(0)!).toList();
    for(String key in pubKey){
      Map<String, dynamic>? userMap = Account.decodeProfile(key);
      if(userMap == null) break;
      final pubkey = userMap['pubkey'] as String? ?? '';
      UserDB? user = await Account.sharedInstance.getUserInfo(pubkey);
      if(user == null) break;
      userDBList[key] = user;
    }
    return userDBList;
  }

  List<String> get getQuoteUrlList {
    final RegExp noteExp = RegExp(r"nostr:note1\w+");
    final Iterable<RegExpMatch> matches = noteExp.allMatches(content);
    final List<String> noteList = matches.map((m) => m.group(0)!).toList();
    return noteList;
  }

  // type = 1 image 2 video
  List<String> getMediaList(int type){
    final RegExp imgExp = RegExp(r'(\S+\/)?\w+\.(png|jpg|jpeg|gif)', caseSensitive: false);
    final RegExp audioExp = RegExp(r'(\S+\/)?\w+\.(mp3|wav|aac|m4a|mp4|avi|mov|wmv)', caseSensitive: false);
    RegExp getRegExp = type == 1 ? imgExp : audioExp;
    final Iterable<RegExpMatch> matches = getRegExp.allMatches(content);

    final List<String> filesList = matches.map((m) => m.group(0)!).toList();
    return filesList;
  }

  List<String> get getMomentExternalLink {
    final RegExp urlExp = RegExp(r"(https?:\/\/[^\s]+)");
    final Iterable<RegExpMatch> matches = urlExp.allMatches(content);
    final List<String> urlList = matches.map((m) => m.group(0)!).toList();
    return urlList;
  }

   String get getMomentShowContent {
    final RegExp mediaExp = RegExp(
         r'(\S+\/)?\w+\.(mp3|wav|aac|m4a|mp4|avi|mov|wmv|png|jpg|jpeg|gif)\b|nostr:note1(\w+)',
         caseSensitive: false
     );
     final String cleanedText = content.replaceAll(mediaExp, '');
     return cleanedText;
  }
}

