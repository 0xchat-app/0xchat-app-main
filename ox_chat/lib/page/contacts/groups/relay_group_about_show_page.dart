import 'package:flutter/material.dart';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/page/contacts/groups/relay_group_edit_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: relay_group_notice_show_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/7/8 11:06
class RelayGroupAboutShowPage extends StatefulWidget {
  final String groupId;

  RelayGroupAboutShowPage({
    super.key,
    required this.groupId,
  });

  @override
  State<StatefulWidget> createState() {
    return _RelayGroupAboutShowPageState();
  }
}

class _RelayGroupAboutShowPageState extends State<RelayGroupAboutShowPage> {
  late RelayGroupDB? _groupDBInfo;
  bool _hasEditMetadataPermission = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _groupDBInfo = RelayGroup.sharedInstance.myGroups[widget.groupId];
    UserDB? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    if (userDB != null && _groupDBInfo != null && _groupDBInfo!.admins != null && _groupDBInfo!.admins!.length > 0) {
      List<GroupActionKind>? userPermissions;
      try {
        userPermissions = _groupDBInfo!.admins!.firstWhere((admin) => admin.pubkey == userDB.pubKey).permissions;
      } catch (e) {
        userPermissions = [];
        LogUtil.e('No admin found with pubkey: ${userDB.pubKey}');
      }
      _hasEditMetadataPermission = userPermissions.contains(GroupActionKind.editMetadata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: 'str_group_about'.localized(),
        backgroundColor: ThemeColor.color190,
        actions: [
          Visibility(
            visible: _hasEditMetadataPermission,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: Adapt.px(24)),
                child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [
                          ThemeColor.gradientMainEnd,
                          ThemeColor.gradientMainStart,
                        ],
                      ).createShader(Offset.zero & bounds.size);
                    },
                    child: Text(Localized.text('ox_common.edit'))),
              ),
              onTap: _changeGroupAboutFn,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText('str_group_about'.localized(), 16.px, ThemeColor.color0),
          SizedBox(height: 24.px),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.px),
              color: ThemeColor.color180,
            ),
            constraints: BoxConstraints(
              minWidth: Adapt.screenW(),
              minHeight: 128.px,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px),
            child: MyText(_groupDBInfo?.about ?? '', 14.px, ThemeColor.color0),
          ),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 30.px, vertical: 24.px)),
    );
  }

  void _changeGroupAboutFn() {
    OXNavigator.pushPage(
            context, (context) => RelayGroupEditPage(groupId: widget.groupId, pageType: EGroupEditType.about))
        .then((value) {
      if (value != null && value is bool) {
        setState(() {
          _loadData();
        });
      }
    });
  }
}
