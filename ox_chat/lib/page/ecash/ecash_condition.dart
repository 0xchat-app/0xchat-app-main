
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

enum EcashValidDuration {
  permanent(null),
  hour1(const Duration(hours: 1)),
  day1(const Duration(days: 1)),
  day7(const Duration(days: 7)),
  day30(const Duration(days: 30));

  final Duration? duration;

  const EcashValidDuration(this.duration);

  String get text {
    switch (this) {
      case EcashValidDuration.permanent: return 'ecash_permanent'.localized();
      case EcashValidDuration.hour1: return 'ecash_1_hour'.localized();
      case EcashValidDuration.day1: return 'ecash_1_day'.localized();
      case EcashValidDuration.day7: return 'ecash_7_day'.localized();
      case EcashValidDuration.day30: return 'ecash_30_day'.localized();
    }
  }
}

class EcashCondition {

  List<UserDBISAR> receiver = [];
  EcashValidDuration validDuration = EcashValidDuration.permanent;
  List<UserDBISAR> signees = [];

  List<String> get receiverPubkey =>
      receiver.map((user) => pubkeyWithUser(user)).toList();

  String? get refundPubkey {
    final user = OXUserInfoManager.sharedInstance.currentUserInfo;
    if (user == null) return null;
    return pubkeyWithUser(user);
  }

  int? get lockTimeFromNow {
    final duration = validDuration.duration;
    if (duration == null) return null;
    return DateTime.now().add(duration).millisecondsSinceEpoch ~/ 1000;
  }

  static String pubkeyWithUser(UserDBISAR user) => '02${user.pubKey}';
}