
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/widget/report_dialog.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

class MessageReportTarget implements ReportTarget {

  MessageReportTarget(this.message);

  final types.Message message;

  Future<String> reportAction(String reason) async {
    var messageId = message.remoteId;
    if (messageId == null)
      return 'message not found';
    OKEvent event = await Channels.sharedInstance.hideMessage(messageId, reason,);
    if (event.status) {
      return '';
    } else {
      return event.message;
    }
  }
}