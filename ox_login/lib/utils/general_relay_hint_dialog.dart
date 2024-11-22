import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

class GeneralRelayHintDialog {
  static show(BuildContext context) async {
    if (Account.sharedInstance.getMyGeneralRelayList().isEmpty) {
      await WidgetsBinding.instance.waitUntilFirstFrameRasterized;
      final ctx = OXNavigator.navigatorKey.currentContext!;
      await OXCommonHintDialog.show(
        context,
        content: 'General Relay is not yet set. Would you like to set it up?',
        actionList: [
          OXCommonHintAction(
            text: () => Localized.text('ox_chat.str_go_to_settings'),
            onTap: () {
              OXNavigator.pop(ctx);
              OXModuleService.invoke('ox_usercenter', 'showRelayPage', [ctx]);
            },
          ),
        ],
        isRowAction: true,
        showCancelButton: true,
      );
    }
  }
}
