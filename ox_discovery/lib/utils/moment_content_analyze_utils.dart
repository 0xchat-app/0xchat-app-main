import 'package:chatcore/chat-core.dart';

class MomentContentAnalyzeUtils{
  final String content;
  MomentContentAnalyzeUtils(this.content);

  Future<Map<String,UserDB?>> get getUserInfoMap async{
    Map<String,UserDB?> userDBList = {};
    final RegExp nostrExp = RegExp(r"nostr:npub\w+");
    final Iterable<RegExpMatch> matches = nostrExp.allMatches(content);

    final List<String> pubKey = matches.map((m) => m.group(0)!).toList();
    for(String key in pubKey){
      String? pubkey = UserDB.decodePubkey(key.substring(6));
      if(pubkey == null) break;
      UserDB? user = await Account.sharedInstance.getUserInfo(pubkey);
      if(user == null) break;
      userDBList[key] = user;
    }
    return userDBList;
  }

  String? get getQuoteUrl {
    final RegExp noteExp = RegExp(r"nostr:note1\w+");
    final Iterable<RegExpMatch> matches = noteExp.allMatches(content);
    final List<String> noteList = matches.map((m) => m.group(0)!).toList();
    return noteList.isEmpty ? null : noteList[0];
  }

  // type = 1 image 2 video
  List<String> getMediaList(int type){
    final RegExp imgExp = RegExp(r'\b\w+\.(png|jpg|jpeg|gif)\b', caseSensitive: false);
    final RegExp audioExp = RegExp(r'\b\w+\.(mp3|wav|aac|m4a｜mp4｜avi｜mov｜wmv)\b', caseSensitive: false);
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
         r'\b\w+\.(jpg|jpeg|png|gif|mp3|wav|aac|m4a|mp4|avi|mov|wmv)\b',
         caseSensitive: false
     );
     final String cleanedText = content.replaceAll(mediaExp, '');
     return cleanedText;
  }

}