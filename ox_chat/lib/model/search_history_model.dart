
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/model/search_history_model_isar.dart';

///Title: search_history_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/25 14:36

@reflector
class SearchHistoryModel extends DBObject {
  String? searchTxt;
  String? pubKey;
  String? name;
  String? picture;

  SearchHistoryModel({this.searchTxt, this.pubKey, this.name, this.picture});

  static List<String?> primaryKey() {
    return ['searchTxt'];
  }

  @override
  Map<String, Object?> toMap() {
    return _searchHistoryModelToMap(this);
  }

  static SearchHistoryModel fromMap(Map<String, Object?> map) {
    return _searchHistoryModelFromMap(map);
  }

  static Future<void> migrateToISAR() async {
    List<SearchHistoryModel> searchHistoryModels = await DB.sharedInstance.objects<SearchHistoryModel>();
    await Future.forEach(searchHistoryModels, (searchHistoryModel) async {
      await DBISAR.sharedInstance.isar.writeTxn(() async {
        await DBISAR.sharedInstance.isar.searchHistoryModelISARs
            .put(SearchHistoryModelISAR.fromMap(searchHistoryModel.toMap()));
      });
    });
  }
}

Map<String, dynamic> _searchHistoryModelToMap(SearchHistoryModel instance){
  return <String, dynamic>{
    'searchTxt': instance.searchTxt,
    'pubKey': instance.pubKey,
    'name': instance.name,
    'picture': instance.picture,
  };
}

SearchHistoryModel _searchHistoryModelFromMap(Map<String, dynamic> map) {
  return SearchHistoryModel(
    searchTxt: map['searchTxt'],
    pubKey: map['pubKey'],
    name: map['name'],
    picture: map['picture'],
  );
}

