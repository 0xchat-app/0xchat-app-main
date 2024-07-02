import 'package:flutter/material.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/page/contacts/contact_relay_page.dart';
import 'package:ox_chat/page/session/chat_relay_group_msg_page.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/widgets/common_loading.dart';

///Title: relay_group_create_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/7/1 16:59
class RelayGroupCreatePage extends StatefulWidget {
  final GroupType groupType;

  const RelayGroupCreatePage({
    super.key,
    required this.groupType,
  });

  @override
  State<StatefulWidget> createState() {
    return _RelayGroupCreatePageState();
  }
}

class _RelayGroupCreatePageState extends State<RelayGroupCreatePage> {
  TextEditingController _controller = TextEditingController();
  String _chatRelay = 'wss://group.0xchat.com';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_chat.str_new_group'),
        actions: [
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 24.px),
              child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        ThemeColor.gradientMainEnd,
                        ThemeColor.gradientMainStart,
                      ],
                    ).createShader(Offset.zero & bounds.size);
                  },
                  child: Text(Localized.text('ox_common.create'), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),)),
            ),
            onTap: () {
              _createGroup();
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.px),
          child: Column(
            children: [
              SizedBox(height: 16.px),
              _buildGroupNameEditText(),
              SizedBox(height: 16.px),
              _buildGroupRelayEditText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupNameEditText() {
    return _buildItem(
      itemName: Localized.text("ox_chat.group_name_item"),
      itemContent: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ThemeColor.color180,
        ),
        height: Adapt.px(48),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  fontSize: Adapt.px(16),
                  fontWeight: FontWeight.w600,
                  height: Adapt.px(22.4) / Adapt.px(16),
                  color: ThemeColor.color0,
                ),
                decoration: InputDecoration(
                  hintText: Localized.text("ox_chat.group_enter_hint_text"),
                  hintStyle: TextStyle(
                    fontSize: Adapt.px(16),
                    fontWeight: FontWeight.w400,
                    height: Adapt.px(22.4) / Adapt.px(16),
                    color: ThemeColor.color160,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupRelayEditText() {
    return _labelWidget(
      title: Localized.text('ox_chat.relay'),
      content: _chatRelay,
      onTap: () async {
        var result = await OXNavigator.presentPage(context, (context) => ContactRelayPage(defaultRelayList: ['wss://group.0xchat.com', 'wss://group.fiatjaf.com', 'ws://192.168.1.25:5577', 'ws://127.0.0.1:5577']));
        if (result != null) {
          _chatRelay = result as String;
          setState(() {});
        }
      },
    );
  }

  Widget _labelWidget({
    required String title,
    required String content,
    required GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Adapt.px(52),
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Adapt.px(16),
                fontWeight: FontWeight.w400,
                color: ThemeColor.color0,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _ellipsisText(content),
                    style: TextStyle(
                      fontSize: Adapt.px(16),
                      fontWeight: FontWeight.w400,
                      color: ThemeColor.color100,
                    ),
                  ),
                  CommonImage(
                    iconName: 'icon_arrow_more.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _ellipsisText(String text) {
    if (text.length > 30) {
      return text.substring(0, 10) + '...' + text.substring(text.length - 10, text.length);
    }
    return text;
  }

  Widget _buildItem({required String itemName, required Widget itemContent}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemName,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: Adapt.px(16),
            color: ThemeColor.color0,
          ),
        ),
        SizedBox(
          height: Adapt.px(12),
        ),
        itemContent,
      ],
    ).setPadding(EdgeInsets.only(bottom: Adapt.px(12)));
  }

  Future<void> _createGroup() async {
    String name = _controller.text;
    if (name.isEmpty) {
      CommonToast.instance.show(context, Localized.text("ox_chat.group_enter_hint_text"));
      return;
    }
    ;
    await OXLoading.show();
    if (widget.groupType == GroupType.openGroup || widget.groupType == GroupType.closeGroup) {
      var uri = Uri.parse(_chatRelay);
      var hostWithPort = uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
      RelayGroupDB? relayGroupDB = await RelayGroup.sharedInstance.createGroup(hostWithPort, name);
      await OXLoading.dismiss();
      if (relayGroupDB != null) {
        OXNavigator.pushReplacement(
          context,
          ChatRelayGroupMsgPage(
            communityItem: ChatSessionModel(
              chatId: relayGroupDB.groupId,
              groupId: relayGroupDB.groupId,
              chatType: ChatType.chatRelayGroup,
              chatName: relayGroupDB.name,
              createTime: relayGroupDB.lastUpdatedTime,
              avatar: relayGroupDB.picture,
            ),
          ),
        );
      } else {
        CommonToast.instance.show(context, Localized.text('ox_chat.create_group_fail_tips'));
      }
    }
  }
}
