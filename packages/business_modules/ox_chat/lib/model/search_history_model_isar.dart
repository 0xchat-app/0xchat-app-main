
import 'package:chatcore/chat-core.dart';
import 'package:isar/isar.dart';

part 'search_history_model_isar.g.dart';

@collection
class SearchHistoryModelISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? searchTxt;

  String? pubKey;
  String? name;
  String? picture;

  SearchHistoryModelISAR({this.searchTxt, this.pubKey, this.name, this.picture});

  static SearchHistoryModelISAR fromMap(Map<String, Object?> map) {
    return _searchHistoryModelFromMap(map);
  }
}

SearchHistoryModelISAR _searchHistoryModelFromMap(Map<String, dynamic> map) {
  return SearchHistoryModelISAR(
    searchTxt: map['searchTxt'],
    pubKey: map['pubKey'],
    name: map['name'],
    picture: map['picture'],
  );
}

