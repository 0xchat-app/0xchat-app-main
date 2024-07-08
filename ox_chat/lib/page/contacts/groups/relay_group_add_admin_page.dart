import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/groups/relay_group_set_admin_rights_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
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
import 'package:ox_common/widgets/common_menu_dialog.dart';

///Title: relay_group_add_admin_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/7/4 07:38
class RelayGroupAddAdminPage extends StatefulWidget {
  final RelayGroupDB relayGroupDB;


  RelayGroupAddAdminPage({super.key, required this.relayGroupDB});

  @override
  State<StatefulWidget> createState() {
    return _RelayGroupAddAdminPageState();
  }
}

class _RelayGroupAddAdminPageState extends State<RelayGroupAddAdminPage> {
  List<UserDB> _groupMembers = [];
  List<UserDB> _filterGroupMembers = [];
  ValueNotifier<bool> _isClear = ValueNotifier(false);
  TextEditingController _controller = TextEditingController();
  List<GroupAdmin> _groupAdmins = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        _isClear.value = true;
      } else {
        _isClear.value = false;
      }
    });
    fetchUserList();
  }

  void fetchUserList() async {
    List<UserDB> localGroupMembers = await RelayGroup.sharedInstance.getGroupMembersFromLocal(widget.relayGroupDB.groupId);
    List<GroupAdmin>? loadAdmins = RelayGroup.sharedInstance.getGroupAdminsFromLocal(widget.relayGroupDB.groupId);
    if (loadAdmins != null){
      Set<String> adminPubkeys = loadAdmins.map((admin) => admin.pubkey).toSet();
      _groupMembers = localGroupMembers.where((member) => !adminPubkeys.contains(member.pubKey)).toList();
      _filterGroupMembers = _groupMembers;
      _groupAdmins = loadAdmins;
      setState(() {});
    }
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
              child: _buildSearchBar(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildListViewItem(context, index);
                },
                childCount: _filterGroupMembers.length,
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

  Widget _buildSearchBar() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ThemeColor.color180,
        ),
        height: Adapt.px(48),
        padding: EdgeInsets.symmetric(horizontal: 16.px),
        margin: EdgeInsets.symmetric(vertical: 16.px),
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
                  icon: Container(
                    child: CommonImage(
                      iconName: 'icon_search.png',
                      width: Adapt.px(24),
                      height: Adapt.px(24),
                      fit: BoxFit.fill,
                    ),
                  ),
                  hintText: 'str_add_admin_search_hint'.localized(),
                  hintStyle: TextStyle(
                    fontSize: Adapt.px(16),
                    fontWeight: FontWeight.w400,
                    height: Adapt.px(22.4) / Adapt.px(16),
                    color: ThemeColor.color160,),
                  border: InputBorder.none,),
                onChanged: _inputTxtChange,
              ),
            ),
            ValueListenableBuilder(
              builder: (context, value, child) {
                return _isClear.value
                    ? GestureDetector(
                  onTap: () {
                    _controller.clear();
                    setState(() {
                      _filterGroupMembers = _groupMembers;
                    });
                  },
                  child: CommonImage(
                    iconName: 'icon_textfield_close.png',
                    width: Adapt.px(16),
                    height: Adapt.px(16),
                  ),
                )
                    : Container();
              },
              valueListenable: _isClear,
            ),
          ],
        ));
  }

  Widget _buildListViewItem(BuildContext context, int index) {
    UserDB userDB = _groupMembers.elementAt(index);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _gotoAdminRightsFn(userDB);
      },
      child: Container(
        height: 72.px,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OXUserAvatar(
              user: userDB,
              imageUrl: userDB.picture ?? '',
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
                  MyText(userDB.name ?? '', 16.px, ThemeColor.color0, fontWeight: FontWeight.w600),
                  SizedBox(height: 2.px),
                  MyText(OXDateUtils.convertTimeFormatString2(userDB.lastUpdatedTime* 1000, pattern: 'MM-dd'), 14.px, ThemeColor.color120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _inputTxtChange(String searchQuery){
    setState(() {
      _filterGroupMembers = _groupMembers.where((item) => item.name!.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    });
  }

  void _gotoAdminRightsFn(UserDB userDB) {
    OXNavigator.pop(context);
    OXNavigator.pushPage(context, (context) => RelayGroupSetAdminRightsPage(relayGroupDB: widget.relayGroupDB, userDB: userDB));
  }
}
