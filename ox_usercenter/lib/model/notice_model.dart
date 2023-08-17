///Title: NoticeModel
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/6/7 16:51
class NoticeModel {
  int id; // 0 Push Notifications, 1 Private Messages, 2 Channels, 3 Zaps
  String name; /// {Notifications, Private Messages, Channels, Zaps}
  String description;
  bool isSelected;

  NoticeModel(this.id, this.name, this.description, this.isSelected);

  NoticeModel noticeModelFomJson(Map<String, dynamic> json) {
    return NoticeModel(
      json['id'] ?? -1,
      json['name'] ?? '',
      json['description'] ?? '',
      json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> noticeModelToMap(NoticeModel model) {
    return <String, dynamic>{
      'id': model.id,
      'name': model.name,
      'description': model.description,
      'isSelected': model.isSelected ,
    };
  }
}

