import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:nostr_core_dart/nostr.dart';

///Title: nip46_callback_dialog_manager
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2024
///@author Michael
///CreateTime: 2024/12/20 09:43
class Nip46CallbackDialogManager {
  static final Map<String, BuildContext> _dialogContexts = {};

  static Future<void> showDialogWithId({
    required BuildContext context,
    required NIP46CommandResult nip46Result,
  }) async {
    if (_dialogContexts.containsKey(nip46Result.id)) {
      String? errorStr = nip46Result.error;
      if (errorStr == null || errorStr.isEmpty) {
        OXNavigator.pop(_dialogContexts[nip46Result.id]);
        _dialogContexts.remove(nip46Result.id);
      }
      return; //Don't create when ID exist
    }
    await OXCommonHintDialog.show(
      context,
      title: 'Please waiting for authorization',
      contentView: Text(
        nip46Result.result.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.px,
        ),
      ),
      onDialogContextCreated: (BuildContext dialogContext) {
        _dialogContexts[nip46Result.id] = dialogContext;
      },
      actionList: [
        OXCommonHintAction(
          text: () => Localized.text('ox_common.ok'),
          onTap: () {
            OXNavigator.pop(_dialogContexts[nip46Result.id]);
          },
        ),
      ],
    ).then((_) {
      _dialogContexts.remove(nip46Result.id);
    });

  }

  static void closeDialogById(String id) {
    if (_dialogContexts.containsKey(id)) {
      OXNavigator.pop(_dialogContexts[id]);
      _dialogContexts.remove(id);
    }
  }

  static void closeAllDialogs() {
    for (final context in _dialogContexts.values) {
      OXNavigator.pop(context);
    }
    _dialogContexts.clear();
  }
}
