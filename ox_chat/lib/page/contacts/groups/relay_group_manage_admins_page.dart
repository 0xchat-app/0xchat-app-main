import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/groups/relay_group_add_admin_page.dart';
import 'package:ox_chat/page/contacts/groups/relay_group_set_admin_rights_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_appbar.dart';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_menu_dialog.dart';

///Title: relay_group_manage_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/6/25 15:10
class RelayGroupManageAdminsPage extends StatefulWidget {
  final RelayGroupDB relayGroupDB;
  List<GroupAdmin> admins;

  RelayGroupManageAdminsPage({super.key, required this.relayGroupDB, required this.admins});

  @override
  State<StatefulWidget> createState() {
    return _RelayGroupManageAdminsPageState();
  }
}

class _RelayGroupManageAdminsPageState extends State<RelayGroupManageAdminsPage> {
  final Map<int, GlobalKey> _moreGlobalKeyMap = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'str_group_administrators'.localized(),
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
              child: _topView(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildListViewItem(context, index);
                },
                childCount: _itemCount(),
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: _addAdminFn,
                child: Container(
                  height: 50.px,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.px),
                    color: ThemeColor.color180,
                  ),
                  alignment: Alignment.center,
                  child:
                      MyText('str_group_add_admin'.localized(), 15.sp, ThemeColor.purple1, fontWeight: FontWeight.w600),
                ),
              ).setPadding(EdgeInsets.symmetric(vertical: 12.px)),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 50.px),
            ),
          ],
        ),
      ),
    );
  }

  int _itemCount() {
    return widget.admins.length;
  }

  Widget _topView() {
    return Container(
      child: MyText('str_group_admin_manage_hint'.localized(), 12.sp, ThemeColor.color100, textAlign: TextAlign.left),
    );
  }

  Widget _buildListViewItem(BuildContext context, int index) {
    GlobalKey indexContenKey = GlobalKey();
    _moreGlobalKeyMap[index] = indexContenKey;
    GroupAdmin groupAdmin = widget.admins.elementAt(index);
    UserDB? userDB = Account.sharedInstance.userCache[groupAdmin.pubkey]?.value;
    return Container(
      height: 72.px,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OXUserAvatar(
            user: userDB,
            imageUrl: userDB?.picture ?? '',
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
                MyText(userDB?.name ?? '', 16.px, ThemeColor.color0, fontWeight: FontWeight.w600),
                SizedBox(height: 2.px),
                MyText(groupAdmin.role, 14.px, ThemeColor.color120),
              ],
            ),
          ),
          if (widget.relayGroupDB.author == groupAdmin.pubkey)
            Container(
              key: indexContenKey,
              width: 24.px,
              height: 24.px,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _editAdminPermissionFn(index, groupAdmin, userDB);
                },
                child: CommonImage(iconName: 'icon_admin_permission_more.png', size: 24.px, package: 'ox_chat'),
              ),
            ),
        ],
      ),
    );
  }

  void _editAdminPermissionFn(int index, GroupAdmin groupAdmin, UserDB? userDB) async {
    GlobalKey? globalKey = _moreGlobalKeyMap[index];
    if (globalKey == null) return;
    BuildContext? keyBuildContext = globalKey.currentContext;
    if (keyBuildContext == null) return;
    final RenderBox renderBox = keyBuildContext.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    List<OXMenuItem> menuList = [
      OXMenuItem(
        identify: 0,
        text: 'str_group_edit_admin_right'.localized(),
      ),
      OXMenuItem(
        identify: 1,
        text: 'str_group_dismiss_admin'.localized(),
      ),
    ];
    final oxMenuItem = await OXMenuDialog.show(
      context,
      data: menuList,
      width: 160.px,
      left: offset.dx + size.width - 160.px,
      top: offset.dy + size.height + 10.px,
    );
    if (oxMenuItem != null){
      if (oxMenuItem.identify == 0){
        OXNavigator.pushPage(context, (context) => RelayGroupSetAdminRightsPage(relayGroupDB: widget.relayGroupDB, userDB: userDB, groupAdmin: groupAdmin));
      }
    }
  }

  void _addAdminFn() {
    OXNavigator.pushPage(context, (context) => RelayGroupAddAdminPage(relayGroupDB: widget.relayGroupDB)).then((value){
      setState(() {
       final tempAdmins = RelayGroup.sharedInstance.getGroupAdminsFromLocal(widget.relayGroupDB.groupId) ;
       if (tempAdmins != null){
         widget.admins = tempAdmins;
       }
      });
    });
  }
}
