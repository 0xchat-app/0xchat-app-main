import 'dart:convert';

import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

import '../ox_chat_ui.dart';

class GiphyUsageRecorder {

  static final pubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';

  static const String giphyCollectKey = 'giphy_collect';

  static Future<void> recordGiphyUsage(GiphyImage giphyImage) async {
    var usedGiphyImageList = await getUsedGiphyList();
    final usedGiphyImageSet = usedGiphyImageList.toSet();
    final result = usedGiphyImageSet.add(giphyImage);
    if (result) {
      usedGiphyImageList = usedGiphyImageSet.toList();
      final jsonString = jsonEncode(usedGiphyImageList.map((giphyImage) => giphyImage.toJson(giphyImage)).toList());
      await OXCacheManager.defaultOXCacheManager.saveData('${giphyCollectKey}_${pubKey}', jsonString);
    }
  }

  static Future<List<GiphyImage>> getUsedGiphyList() async {
    final String jsonString = await OXCacheManager.defaultOXCacheManager.getData('${giphyCollectKey}_${pubKey}');
    if(jsonString.isEmpty){
      return [];
    }
    final usedGiphyImageJsonList = jsonDecode(jsonString);

    final usedGiphyImageList = [
      for (var json in usedGiphyImageJsonList) GiphyImage.fromJson(json)
    ];

    return usedGiphyImageList;
  }
}