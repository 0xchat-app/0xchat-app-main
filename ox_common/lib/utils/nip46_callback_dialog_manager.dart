import 'package:flutter/material.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

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
    BuildContext? tempObject = _dialogContexts[nip46Result.id];
    if (tempObject !=null) {
      Navigator.pop(tempObject);
      _dialogContexts.remove(nip46Result.id);
      return;
    }
    if(nip46Result.result != 'auth_url'){
      return;
    }
    String command = nip46Result.command == null ? '' : ' ${nip46Result.command.toString()}';
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          _dialogContexts[nip46Result.id] = dialogContext;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300.px,
                decoration: BoxDecoration(
                  color: ThemeColor.color180,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.px),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: Adapt.px(36),
                      ),
                      child: Text(
                        'Please waiting for${command} authorization',
                        style: TextStyle(
                          fontSize: Adapt.px(15),
                          fontWeight: FontWeight.w400,
                          color: ThemeColor.color0,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: Adapt.px(24)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nip46Result.result.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.px,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 24.px),
                      width: double.infinity,
                      height: Adapt.px(0.5),
                      color: ThemeColor.color160,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        BuildContext? tempObject = _dialogContexts[nip46Result.id];
                        LogUtil.e('Michael:--nip46commandResultCallback--ok----tempObject = ${tempObject.hashCode}; nip46Result.id = ${nip46Result.id}');
                        if (tempObject !=null) {
                          OXNavigator.pop(tempObject);
                          _dialogContexts.remove(nip46Result.id);
                          return;
                        }
                      },
                      child: Container(
                        height: 56.px,
                        alignment: Alignment.center,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                ThemeColor.gradientMainEnd,
                                ThemeColor.gradientMainStart,
                              ],
                            ).createShader(Offset.zero & bounds.size);
                          },
                          child: Text(Localized.text('ox_common.ok'),
                              style: TextStyle(
                                fontSize: Adapt.px(16),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });

  }

  static void closeDialogById(String id) {
    BuildContext? tempObject = _dialogContexts[id];
    if (tempObject !=null) {
      Navigator.pop(tempObject);
      _dialogContexts.remove(id);
      return;
    }
  }

  static void closeAllDialogs() {
    for (final ctx in _dialogContexts.values) {
      Navigator.pop(ctx);
    }
    _dialogContexts.clear();
  }
}
