import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/network/network_general.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_network/network_manager.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/const/common_constant.dart';

class BootConfig {

  static final BootConfig _instance = BootConfig._internal();

  BootConfig._internal();

  static BootConfig get instance => _instance;

  void batchUpdateUserBadges(){
    if (OXUserInfoManager.sharedInstance.isLogin) {
      _getUserGrantBadges().then((value){
        _syncBadgesToUserDB(value);
      }).catchError((onError) {
        print('batch sync badges to UserDB failed');
      });
    }
  }

  Future<Map<String, List<String>>> _getUserGrantBadges() async {
    final int? lastTime = await OXCacheManager.defaultOXCacheManager.getForeverData('lastTime');
    Map<String, dynamic>? params = lastTime != null ? {'lastTime': lastTime} : null;

    try {
      OXResponse response = await OXNetwork.instance.doRequest(
          null,
          url: '${CommonConstant.baseUrl}/nostrchat/badges/getBadgeGrantUserList',
          type: RequestType.GET,
          params: params,
          needRSA: false,
          needCommonParams: false);

      Map<String, List<String>> userToBadges = {};

      Map<String, dynamic> data = response.data;
      int? obtainTime = data['obtainTime'];
      Map<String, dynamic>? badgeList = data['list'];

      if (badgeList != null && badgeList.isNotEmpty) {
        badgeList.forEach((badge, users) {
          for (String user in users) {
            userToBadges.putIfAbsent(user, () => []).add(badge);
          }
        });
      }

      if (obtainTime != null) {
        OXCacheManager.defaultOXCacheManager.saveForeverData('lastTime', obtainTime);
      }
      return userToBadges;
    } catch (error) {
      print('Failed to batch obtain badge request: $error');
      return {};
    }
  }

  Future<void> _syncBadgesToUserDB(Map<String, List<String>> userToBadges) async {
    userToBadges.forEach((userPubkey, badges) async {
      UserDB? userDB = await Account.sharedInstance.getUserInfo(userPubkey);
      if (userDB != null) {
        userDB.badgesList = badges;
        await DB.sharedInstance.update<UserDB>(userDB);
      }else{
        userDB = UserDB(pubKey: userPubkey,badgesList: badges);
        await DB.sharedInstance.insert<UserDB>(userDB);
      }
    });
  }
}
