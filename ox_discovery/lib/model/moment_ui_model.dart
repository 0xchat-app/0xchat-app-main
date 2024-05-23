import 'package:chatcore/chat-core.dart';

import '../enum/moment_enum.dart';
import '../utils/discovery_utils.dart';
import '../utils/moment_content_analyze_utils.dart';

class NotedUIModel {
  NoteDB noteDB;
  late Map<String, UserDB?> getUserInfoMap;
  late List<String> getQuoteUrlList;
  late List<String> getImageList;
  late List<String> getVideoList;
  late List<String> getMomentExternalLink;
  late String getMomentShowContent;
  late List<String> getMomentHashTagList;
  late String createAtStr;
  late String getMomentPlainText;
  NotedUIModel({required this.noteDB}){
    loadInitialData(noteDB);
  }

  Future<void> loadInitialData(NoteDB noteDB) async {
    MomentContentAnalyzeUtils analyzer = MomentContentAnalyzeUtils(noteDB.content);
    // getUserInfoMap = await mediaAnalyzer.getUserInfoMap;
    getQuoteUrlList = analyzer.getQuoteUrlList;
    getImageList = analyzer.getMediaList(1);
    getVideoList = analyzer.getMediaList(2);
    getMomentExternalLink = analyzer.getMomentExternalLink;
    getMomentShowContent = analyzer.getMomentShowContent;
    getMomentHashTagList = analyzer.getMomentHashTagList;
    getMomentPlainText = analyzer.getMomentPlainText;
    createAtStr = DiscoveryUtils.formatTimeAgo(noteDB.createAt);
  }
}
