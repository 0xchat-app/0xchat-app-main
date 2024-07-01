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
  final List<UserDB>? userList;
  final List<UserDB> defaultSelected;
  final List<UserDB> additionalUserList;
  final bool isMultiSelect;
  final bool allowFetchUserFromRelay;
  final bool Function(List<UserDB> userList)? shouldPop;

  const UserSelectionPage({
    super.key,
    required this.title,
    this.userList,
    this.defaultSelected = const [],
    this.additionalUserList = const [],
    this.isMultiSelect = false,
    this.allowFetchUserFromRelay = false,
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

  List<UserDB> allUser = [];
  List<UserDB> userList = [];
  List<UserDB> selectedUserList = [];

  UserDB? userFromRemote;
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
    final allUser = widget.userList ?? Contacts.sharedInstance.allContacts.values.toList();
    this.allUser = [
      ...widget.additionalUserList,
      ...allUser,
    ];
    userList = [...this.allUser];
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
    final data = <UserDB>[
      if (userFromRemote != null) userFromRemote!,
      ...userList,
    ];
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
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildUserItem(data[index]);
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
              onSubmitted: searchTextOnSubmitted,
              controller: _searchController,
              style: TextStyle(
                fontSize: Adapt.px(16),
                fontWeight: FontWeight.w600,
                height: Adapt.px(22.4) / Adapt.px(16),
                color: ThemeColor.color0,
              ),
              decoration: InputDecoration(
                hintText: widget.allowFetchUserFromRelay
                    ? 'please_enter_user_address'.localized()
                    : 'search'.localized(),
                hintStyle: TextStyle(
                  fontSize: Adapt.px(16),
                  fontWeight: FontWeight.w400,
                  height: Adapt.px(22.4) / Adapt.px(16),
                  color: ThemeColor.color160,),
                border: InputBorder.none,
                suffix: _buildClearIcon(),
              ),
            ),
          ),
          _buildSearchIcon(),
        ],
      ),
    );
  }

  Widget _buildClearIcon() {
    return  _searchController.text.isEmpty
        ? SizedBox()
        : GestureDetector(
      onTap: () => _searchController.clear(),
      behavior: HitTestBehavior.translucent,
      child: CommonImage(
        iconName: 'icon_textfield_close.png',
        size: 16.px,
      ).setPaddingOnly(left: 8.px, right: 8.px)
    );
  }

  Widget _buildSearchIcon() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: searchIconOnTap,
      child: CommonImage(
        iconName: 'icon_search.png',
        size: 24.px,
        fit: BoxFit.fill,
      ).setPaddingOnly(left: 8.px),
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
      userList = allUser.where((user) {
        final nameMatch = user.name?.toLowerCase().contains(searchText) ?? false;
        final nickNameMatch = user.nickName?.toLowerCase().contains(searchText) ?? false;
        final pubkeyMatch = user.pubKey.toLowerCase().contains(searchText);
        return nameMatch || nickNameMatch || pubkeyMatch;
      }).toList();
    } else {
      userList = allUser;
    }

    updateGroupedUserList();

    setState(() { });
  }

  void searchTextOnSubmitted(String text) {
    if (!widget.allowFetchUserFromRelay) return ;
    if (isValidNPubString(text) || isNIP05AddressString(text)) {
      searchIconOnTap();
    }
  }

  void searchIconOnTap() async {
    if (!widget.allowFetchUserFromRelay) return ;
    setState(() {
      userFromRemote = null;
    });
    final text = _searchController.text;
    var pubkey = '';
    if (isValidNPubString(text)) {
      pubkey = UserDB.decodePubkey(text) ?? '';
    } else if (isNIP05AddressString(text)) {
      final name = text.substring(0, text.indexOf('@'));
      final domain = text.substring(text.indexOf('@') + 1);
      pubkey = await Account.getDNSPubkey(name, domain) ?? '';
    }

    if (pubkey.isEmpty) return ;

    UserDB? user = await Account.sharedInstance.getUserInfo(pubkey);
    if (user != null) {
      setState(() {
        userFromRemote = user;
      });
    }
  }

  bool isValidNPubString(String input) {
    final regex = RegExp(r'^npub[a-zA-Z0-9]+$');
    return regex.hasMatch(input);
  }

  bool isNIP05AddressString(String input) {
    return input.contains('@');
  }
}

