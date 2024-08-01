import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/date_utils.dart';

///Title: user_request_info
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/6/24 21:21
class JoinRequestInfo {
  final String createTime;
  final String userName;
  final String groupName;
  final String userPic;
  bool isShowMore;
  final JoinRequestDBISAR joinRequestDB;

  JoinRequestInfo({
    required this.userName,
    required this.groupName,
    required this.createTime,
    required this.userPic,
    required this.joinRequestDB,
    this.isShowMore = false,
  });

  static Future<JoinRequestInfo> toUserRequestInfo(JoinRequestDBISAR joinRequest) async {
    RelayGroupDB? groupDB = RelayGroup.sharedInstance.groups[joinRequest.groupId];
    String time = OXDateUtils.convertTimeFormatString2(joinRequest.createdAt * 1000, pattern: 'MM-dd');
    UserDBISAR? userDB = await Account.sharedInstance.getUserInfo(joinRequest.author);
    return JoinRequestInfo(
      userName: userDB?.name ?? '--',
      createTime: time,
      groupName: groupDB?.name ?? '--',
      userPic: userDB?.picture ?? '',
      isShowMore: false,
      joinRequestDB: joinRequest,
    );
  }
}

enum RequestOption { accept, ignore }
