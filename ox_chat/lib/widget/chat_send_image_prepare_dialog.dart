
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ChatSendImagePrepareDialog {
  static Future<bool> show(BuildContext context, File imageFile) async {
    final result = await OXCommonHintDialog.show(
      context,
      contentView: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 355.px,
        ),
        child: Image.file(
          imageFile,
          fit: BoxFit.cover,
        ),
      ),
      actionList: [
        OXCommonHintAction.cancel(
          onTap: () => OXNavigator.pop(context, false),
        ),
        OXCommonHintAction.sure(
          text: Localized.text('ox_chat.send'),
          onTap: () => OXNavigator.pop(context, true),
        ),
      ],
      isRowAction: true,
    );
    return result ?? false;
  }
}