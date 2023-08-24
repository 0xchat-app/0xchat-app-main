
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class ChatUserCache {

  static final ChatUserCache shared = ChatUserCache._internal();

  ChatUserCache._internal();

  Map<String, UserDB> userCache = {};

  Future<UserDB> getUserDB(String pubKey) async {

    UserDB? userDB = userCache[pubKey];
    if (userDB != null) return userDB;

    if (pubKey == OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey) {
      userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    } else {
      userDB = Contacts.sharedInstance.allContacts[pubKey];
    }

    if(userDB == null) {
      userDB = await Account.getUserFromDB(pubkey: pubKey);
    }

    if(userDB == null) {
      userDB = UserDB(
        pubKey: pubKey,
        name: null,
        picture: null,
      );
    }

    userCache[pubKey] = userDB;

    return userDB;
  }

  void updateUserInfo(UserDB user) {

    final pubKey = user.pubKey;

    if (pubKey == null || pubKey.isEmpty) return ;

    final originUser = userCache[pubKey];

    if (identical(originUser, user)) return ;

    if (originUser == null) {
      userCache[pubKey] = user;
      return ;
    }

    originUser.updateWith(user);
  }
}