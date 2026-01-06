import 'package:ox_chat/widget/report_dialog.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/widgets/common_loading.dart';

class UserReportTarget implements ReportTarget{

  final String pubKey;

  UserReportTarget({required this.pubKey});

  @override
  Future<String> reportAction(String reason) async {
    await OXLoading.show();
    final OKEvent okEvent = await Channels.sharedInstance.muteUser(pubKey,reason);
    await OXLoading.dismiss();
    if (okEvent.status) {
      return '';
    } else {
      return 'Unable to report user';
    }
  }
}