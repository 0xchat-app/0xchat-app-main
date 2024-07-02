
import 'package:chatcore/chat-core.dart';

extension UserDBChatEx on UserDB {
  String getUserShowName() {
    final nickName = (this.nickName ?? '').trim();
    final name = (this.name ?? '').trim();
    if (nickName.isNotEmpty) return nickName;
    if (name.isNotEmpty) return name;
    return 'unknown';
  }

  updateWith(UserDB user) {
    name = user.name;
    picture = user.picture;
    about = user.about;
    lnurl = user.lnurl;
    gender = user.gender;
    area = user.area;
    dns = user.dns;
  }
}