import 'package:chatcore/chat-core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_module_service/ox_module_service.dart';

class ReplyContactWidget extends StatelessWidget {
  final UserDB? userDB;
  const ReplyContactWidget({super.key, required this.userDB});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: TextSpan(
        style: TextStyle(
          color: ThemeColor.color0,
          fontSize: 14.px,
          fontWeight: FontWeight.w400,
        ),
        children: [
          const TextSpan(text: 'Reply to'),
          TextSpan(
            text: ' @${userDB?.name}',
            style: TextStyle(
              color: ThemeColor.purple2,
              fontSize: 12.px,
              fontWeight: FontWeight.w400,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
                  'pubkey': userDB?.pubKey,
                });
              },
          ),
        ],
      ),
    );;
  }
}
