import 'package:flutter/material.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/alpha.dart';
import 'package:ox_chat/widget/group_member_item.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:lpinyin/lpinyin.dart';

class UserSelectionPage extends StatefulWidget {
  final String title;
  final List<UserDB> userList;
  final List<UserDB> defaultSelected;
  final bool isMultiSelect;
  final bool Function(List<UserDB> userList)? shouldPop;

  const UserSelectionPage({
    super.key,
    required this.title,
    required this.userList,
    this.defaultSelected = const [],
    this.isMultiSelect = false,
    this.shouldPop,
  });

  @override
  State<StatefulWidget> createState() => UserSelectionPageState();

  static Future<List<UserDB>?> showWithGroupMember({
    String? title,
    required String groupId,
    bool excludeSelf = false,
  }) async {
    List<UserDB> groupMembers = await Groups.sharedInstance.getAllGroupMembers(groupId);
    if (excludeSelf) {
      groupMembers = groupMembers.where((user) => user != OXUserInfoManager.sharedInstance.currentUserInfo).toList();
    }

    return OXNavigator.presentPage(
      null,
      (context) => UserSelectionPage(title: title ?? 'group_member'.localized(), userList: groupMembers,)
    );
  }
}

class UserSelectionPageState<T extends UserSelectionPage> extends State<T> {

  List<UserDB> userList = [];
  List<UserDB> selectedUserList = [];
  Map<String, List<UserDB>> _groupedUserList = {};

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    prepareData();
    _searchController.addListener(() {
      updateUserList();
    });
  }

  prepareData() {
    userList = [...widget.userList];
    selectedUserList = [...widget.defaultSelected];
    updateGroupedUserList();
  }

  updateGroupedUserList() {
    ALPHAS_INDEX.forEach((v) {
      _groupedUserList[v] = [];
    });
    Map<UserDB, String> pinyinMap = Map<UserDB, String>();
    for (var user in userList) {
      String nameToConvert = user.nickName != null && user.nickName!.isNotEmpty ? user.nickName! : (user.name ?? '');
      String pinyin = PinyinHelper.getFirstWordPinyin(nameToConvert);
      pinyinMap[user] = pinyin;
    }
    userList.sort((v1, v2) {
      return pinyinMap[v1]!.compareTo(pinyinMap[v2]!);
    });

    userList.forEach((item) {
      var firstLetter = pinyinMap[item]![0].toUpperCase();
      if (!ALPHAS_INDEX.contains(firstLetter)) {
        firstLetter = '#';
      }
      _groupedUserList[firstLetter]?.add(item);
    });

    _groupedUserList.removeWhere((key, value) => value.isEmpty);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color190,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Adapt.px(20)),
          topLeft: Radius.circular(Adapt.px(20)),
        ),
      ),
      child: Column(
        children: [
          _buildNavBar().setPadding(EdgeInsets.symmetric(horizontal: 10.px)),
          Expanded(
            child: Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: ListView.separated(
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildUserItem(userList[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: 10.px,),
                  ),
                ),
              ],
            ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar() =>
      CommonAppBar(
        title: widget.title,
        backgroundColor: Colors.transparent,
        actions: [
          if (widget.isMultiSelect)
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: CommonImage(
                iconName: 'icon_done.png',
                size: 24.px,
                useTheme: true,
              ),
              onPressed: () => popAction(selectedUserList),
            ).setPaddingOnly(right: 5.px),
        ],
      );

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ThemeColor.color180,
      ),
      height: Adapt.px(48),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
      margin: EdgeInsets.symmetric(vertical: Adapt.px(16)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
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
                hintText: 'search'.localized(),
                hintStyle: TextStyle(
                  fontSize: Adapt.px(16),
                  fontWeight: FontWeight.w400,
                  height: Adapt.px(22.4) / Adapt.px(16),
                  color: ThemeColor.color160,),
                border: InputBorder.none,
                suffix: _searchController.text.isEmpty
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () => _searchController.clear(),
                        behavior: HitTestBehavior.translucent,
                        child: CommonImage(
                          iconName: 'icon_textfield_close.png',
                          size: 16.px,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(UserDB user){
    bool isSelected = selectedUserList.contains(user);
    return GroupMemberItem(
      user: user,
      titleColor: isSelected ? ThemeColor.color0 : ThemeColor.color100,
      action: widget.isMultiSelect? CommonImage(
        width: Adapt.px(24),
        height: Adapt.px(24),
        iconName: isSelected ? 'icon_select_follows.png' : 'icon_unSelect_follows.png',
        package: 'ox_chat',) : SizedBox(),
      onTap: () {
        if (!widget.isMultiSelect) {
          popAction([user]);
          return ;
        }
        setState(() {
          if (isSelected) {
            selectedUserList.remove(user);
          } else {
            selectedUserList.add(user);
          }
        });
      },
    );
  }

  void popAction(List<UserDB> selectedUserList) {
    if (widget.shouldPop?.call(selectedUserList) ?? true) {
      OXNavigator.pop(context, selectedUserList);
    }
  }

  void updateUserList() {
    final searchText = _searchController.text.toLowerCase();
    if (searchText.isNotEmpty) {
      userList = widget.userList.where((user) {
        final nameMatch = user.name?.toLowerCase().contains(searchText) ?? false;
        final nickNameMatch = user.nickName?.toLowerCase().contains(searchText) ?? false;
        final pubkeyMatch = user.pubKey.toLowerCase().contains(searchText);
        return nameMatch || nickNameMatch || pubkeyMatch;
      }).toList();
    } else {
      userList = widget.userList;
    }

    updateGroupedUserList();

    setState(() { });
  }
}

