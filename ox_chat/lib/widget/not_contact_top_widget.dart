import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

///Title: not_contact_top_widget
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/8/23 14:42
class NotContactTopWidget extends StatefulWidget {
  final ChatSessionModel chatSessionModel;
  final GestureTapCallback? onTap;

  const NotContactTopWidget({Key? key, required this.chatSessionModel, required this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotContactTopWidgetState();
}

class _NotContactTopWidgetState extends State<NotContactTopWidget> {
  double buttonWidth = (Adapt.screenW() - Adapt.px(16 + 12 + 12 + 16 + 16)) / 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Adapt.px(36),
      child: Row(
        children: [
          Expanded(
            child: _buildNotAddStatus(widget.chatSessionModel),
          ),
          SizedBox(
            width: Adapt.px(8),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            onTap: widget.onTap,
            child: CommonImage(
              iconName: 'icon_clearbutton.png',
              fit: BoxFit.fill,
              width: Adapt.px(20),
              height: Adapt.px(20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotAddStatus(ChatSessionModel item) {
    return Row(
      children: [
        Expanded(
          child: _buildOperateButton(
            "ox_chat.add_contact_block",
            width: buttonWidth,
            height: Adapt.px(28),
            onTap: () {
              _blockOnTap(item);
            },
          ),
        ),
        SizedBox(
          width: Adapt.px(12),
        ),
        _buildOperateButton(
          "ox_chat.add_contact_confirm",
          width: buttonWidth,
          height: Adapt.px(28),
          linearGradient: LinearGradient(
            colors: [
              ThemeColor.gradientMainEnd.withOpacity(0.24),
              ThemeColor.gradientMainStart.withOpacity(0.24),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          onTap: () {
            _confirmOnTap(item);
          },
        ),
      ],
    );
  }

  Widget _buildOperateButton(String title,
      {double? width, double? height, Color? textColor, Color? bgColor, VoidCallback? onTap, LinearGradient? linearGradient}) {
    return GestureDetector(
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        alignment: Alignment.center,
        child: Text(
          Localized.text(title),
          style: TextStyle(fontSize: Adapt.px(15), color: textColor),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(24)),
          color: bgColor ?? ThemeColor.color180,
          gradient: linearGradient,
        ),
      ),
      onTap: onTap,
    );
  }

  void _confirmOnTap(ChatSessionModel item) async {
    await OXLoading.show();
    final OKEvent okEvent = await Contacts.sharedInstance.addToContact([item.chatId!]);
    await OXLoading.dismiss();
    if (okEvent.status) {
      OXChatBinding.sharedInstance.contactUpdatedCallBack();
      String pubkey = (item.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey ? item.sender : item.receiver) ?? '';
      OXChatBinding.sharedInstance.changeChatSessionTypeAll(pubkey, true);
      CommonToast.instance.show(context, Localized.text('ox_chat.added_successfully'));
      setState(() {});
    } else {
      CommonToast.instance.show(context, okEvent.message);
    }
  }

  void _blockOnTap(ChatSessionModel item) async {
    await OXLoading.show();
    final OKEvent okEvent = await Contacts.sharedInstance.addToBlockList(item.chatId!);
    await OXLoading.dismiss();
    if (okEvent.status) {
      OXChatBinding.sharedInstance.deleteSession(item);
      CommonToast.instance.show(context, Localized.text('ox_chat.rejected_successfully'));
      setState(() {});
    } else {
      CommonToast.instance.show(context, okEvent.message);
    }
  }
}
