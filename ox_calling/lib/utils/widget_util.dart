import 'package:chatcore/chat-core.dart';

///Title: widget_util
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/7/27 17:30
extension UserDBToUIEx on UserDB {
  String getUserShowName() {
    final nickName = (this.nickName ?? '').trim();
    final name = (this.name ?? '').trim();
    if (nickName.isNotEmpty) return nickName;
    if (name.isNotEmpty) return name;
    return 'unknown';
  }
}
