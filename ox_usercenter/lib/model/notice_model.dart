///Title: NoticeModel
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/6/7 16:51
class NoticeModel {
  int id; // 0 Push Notifications, 1 Private Messages, 2 Channels, 3 Zaps
  bool isSelected;

  NoticeModel({this.id = 0, this.isSelected = false});

  NoticeModel noticeModelFomJson(Map<String, dynamic> json) {
    return NoticeModel(
      id : json['id'],
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> noticeModelToMap(NoticeModel model) {
    return <String, dynamic>{
      'id': model.id,
      'isSelected': model.isSelected ,
    };
  }

  @override
  String toString() {
    return 'NoticeModel{id: $id, isSelected: $isSelected}';
  }
}

