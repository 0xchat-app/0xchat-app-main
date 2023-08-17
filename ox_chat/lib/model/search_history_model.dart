import 'dart:convert';

import 'package:chatcore/chat-core.dart';

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

