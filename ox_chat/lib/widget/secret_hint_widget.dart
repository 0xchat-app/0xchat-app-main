import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/widget/rich_text_color.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: secret_hint_widget
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/8/24 10:37
class SecretHintWidget extends StatefulWidget {
  final ChatSessionModel chatSessionModel;

  const SecretHintWidget({Key? key, required this.chatSessionModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SecretHintWidgetState();
}

class _SecretHintWidgetState extends State<SecretHintWidget> {
  SecretSessionDB? _ssDB;

  @override
  void initState() {
    super.initState();
    _ssDB = Contacts.sharedInstance.secretSessionMap[widget.chatSessionModel.chatId!];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Adapt.screenH()/9),
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColor.color190,
          borderRadius: BorderRadius.circular(Adapt.px(12)),
        ),
        constraints: BoxConstraints(maxHeight: Adapt.px(300)),
        width: Adapt.screenW() * 0.71,
        padding: EdgeInsets.only(
          top: Adapt.px(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.chatSessionModel.content ?? '',
              style: TextStyle(
                color: ThemeColor.color120,
                fontSize: Adapt.px(14),
                fontWeight: FontWeight.w600,
              ),
            ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(12))),
            SizedBox(
              height: Adapt.px(12),
            ),
            RichTextColor(
              text: Localized.text('ox_chat.str_secret_center_hint'),
              highlightTextList: ['Nip 44', 'Nip 59', 'Nip 101'],
              maxLines: 12,
            ).setPadding(
              EdgeInsets.symmetric(
                horizontal: Adapt.px(12),
              ),
            ),
            SizedBox(
              height: Adapt.px(15),
            ),
            Container(
              width: double.infinity,
              height: Adapt.px(1),
              alignment: Alignment.bottomLeft,
              color: ThemeColor.color200,
            ),
            Container(
              width: double.infinity,
              height: Adapt.px(44),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonImage(
                    iconName: 'icon_secret_relay.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                    package: 'ox_chat',
                  ),
                  SizedBox(
                    width: Adapt.px(8),
                  ),
                  Text(
                    (_ssDB == null || _ssDB!.relay == null || _ssDB!.relay == 'null' || _ssDB!.relay!.isEmpty) ? '' : _ssDB!.relay!,
                    style: TextStyle(
                      color: ThemeColor.color100,
                      fontSize: Adapt.px(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
