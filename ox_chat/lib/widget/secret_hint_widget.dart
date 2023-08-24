import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/widget/rich_text_color.dart';
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
      decoration: BoxDecoration(
        color: ThemeColor.color190,
        borderRadius: BorderRadius.circular(Adapt.px(12)),
      ),
      width: Adapt.px(266),
      height: Adapt.px(243),
      padding: EdgeInsets.only(
        top: Adapt.px(16),
      ),
      child: Column(
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
          Container(
            height: Adapt.px(119),
            child: SingleChildScrollView(
              child: RichTextColor(
                text: Localized.text('ox_chat.str_secret_center_hint'),
                highlightTextList: ['Nip 44', 'Nip 59'],
                maxLines: 8,
              ).setPadding(
                EdgeInsets.symmetric(
                  horizontal: Adapt.px(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Adapt.px(15),
          ),
          Container(
            width: double.infinity,
            height: Adapt.px(1),
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
                Text(
                  _ssDB?.relay ?? 'wss://relay.0xchat.com',
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
    );
  }
}
