
import 'package:chatcore/chat-core.dart';
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
      case EcashValidDuration.permanent: return 'Permanent';
      case EcashValidDuration.hour1: return '1 Hour';
      case EcashValidDuration.day1: return '1 Day';
      case EcashValidDuration.day7: return '7 Day';
      case EcashValidDuration.day30: return '30 Day';
    }
  }
}

class EcashCondition {

  List<UserDB> receiver = [];
  EcashValidDuration validDuration = EcashValidDuration.permanent;
  List<UserDB> signees = [];

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

  static String pubkeyWithUser(UserDB user) => '02${user.pubKey}';
}