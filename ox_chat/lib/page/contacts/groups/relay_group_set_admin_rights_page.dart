import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_appbar.dart';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_menu_dialog.dart';
import 'package:ox_common/widgets/common_toast.dart';

///Title: relay_group_set_admin_rights_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/7/4 07:38
class RelayGroupSetAdminRightsPage extends StatefulWidget {
  final RelayGroupDB relayGroupDB;
  final UserDB? userDB;
  final GroupAdmin? groupAdmin;

  RelayGroupSetAdminRightsPage({super.key, required this.relayGroupDB, required this.userDB, this.groupAdmin});

  @override
  State<StatefulWidget> createState() {
    return _RelayGroupSetAdminRightsPageState();
  }
}

class _RelayGroupSetAdminRightsPageState extends State<RelayGroupSetAdminRightsPage> {
  List<GroupActionKind> _showPermissions = [];
  Set<int> _currentPermissionKinds = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _showPermissions = GroupActionKind.values;
    _currentPermissionKinds = _showPermissions.map((e) => e.kind).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'str_group_admin_right_title'.localized(),
      ),
      backgroundColor: ThemeColor.color190,
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 24.px,
          vertical: 12.px,
        ),
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildAdminInfo(),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.px),
                  color: ThemeColor.color180,
                ),
                margin: EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px),
                child: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildListViewItem(context, index);
                    },
                    childCount: _showPermissions.length,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 50.px),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminInfo() {
    return Container(
      height: 72.px,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OXUserAvatar(
            user: widget.userDB,
            imageUrl: widget.userDB?.picture ?? '',
            size: 48.px,
            isClickable: true,
            onReturnFromNextPage: () {
              setState(() {});
            },
          ),
          SizedBox(width: 16.px),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(widget.userDB?.name ?? '', 16.px, ThemeColor.color0, fontWeight: FontWeight.w600),
                SizedBox(height: 2.px),
                MyText(OXDateUtils.convertTimeFormatString2((widget.userDB?.lastUpdatedTime ?? 0) * 1000, pattern: 'MM-dd'), 14.px, ThemeColor.color120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListViewItem(BuildContext context, int index) {
    GroupActionKind groupActionKind = _showPermissions.elementAt(index);
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: Adapt.px(48),
          alignment: Alignment.center,
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
              title: Text(
                groupActionKind.name,
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(16),
                ),
              ),
              trailing: Switch(
                value: _currentPermissionKinds.contains(groupActionKind.kind),
                activeColor: Colors.white,
                activeTrackColor: ThemeColor.gradientMainStart,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: ThemeColor.color160,
                onChanged: (value) async {
                  await OXLoading.show();
                  final okEvent = value ? await RelayGroup.sharedInstance.addPermission(widget.relayGroupDB.groupId, widget.userDB?.pubKey ?? '', groupActionKind.name, '')
                      :  await RelayGroup.sharedInstance.removePermission(widget.relayGroupDB.groupId, widget.userDB?.pubKey ?? '', groupActionKind.name, '');
                  await OXLoading.dismiss();
                  if (okEvent.status) {
                    setState(() {
                      _currentPermissionKinds.add(groupActionKind.kind);
                    });
                  } else {
                    CommonToast.instance.show(context, okEvent.message);
                  }
                },
                materialTapTargetSize: MaterialTapTargetSize.padded,
              )
          ),
        ),
        Visibility(
          visible: index < _showPermissions.length,
          child: Divider(
            height: Adapt.px(0.5),
            color: ThemeColor.color160,
          ),
        ),
      ],
    );
  }

}
