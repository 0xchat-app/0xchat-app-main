import 'package:flutter/material.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/alpha.dart';
import 'package:ox_chat/widget/group_member_item.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:lpinyin/lpinyin.dart';

enum GroupListAction {
  view,
  select
}

class ContactGroupListPage extends StatefulWidget {
  final List<UserDB> userList;
  final GroupListAction? groupListAction;
  final String? title;
  final String? searchBarHintText;

  const ContactGroupListPage(
      {super.key,
      required this.userList,
      required this.title,
      this.groupListAction = GroupListAction.view,
      this.searchBarHintText});

  @override
  State<ContactGroupListPage> createState() => ContactGroupListPageState();
}

class ContactGroupListPageState<T extends ContactGroupListPage> extends State<T> {

  List<UserDB> _userList = [];
  List<UserDB> _selectedUserList = [];
  ValueNotifier<bool> _isClear = ValueNotifier(false);
  TextEditingController _controller = TextEditingController();
  Map<String, List<UserDB>> _groupedUserList = {};
  Map<String, List<UserDB>> _filteredUserList = {};

  List<UserDB> get selectedUserList=> _selectedUserList;
  List<UserDB> get userList=> _userList;

  @override
  void initState() {
    super.initState();
    _userList = widget.userList;
    _groupedUser();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        _isClear.value = true;
      } else {
        _isClear.value = false;
      }
    });
  }

  _groupedUser(){
    ALPHAS_INDEX.forEach((v) {
      _groupedUserList[v] = [];
    });

    _userList.sort((v1, v2) {
      return _getFirstWord(v1).compareTo(_getFirstWord(v2));
    });

    _userList.forEach((item) {
      var firstLetter = _getFirstWord(item)[0].toUpperCase();
      if (!ALPHAS_INDEX.contains(firstLetter)) {
        firstLetter = '#';
      }
      _groupedUserList[firstLetter]?.add(item);
    });

    _groupedUserList.removeWhere((key, value) => value.isEmpty);
    _filteredUserList = _groupedUserList;
  }

  String _getFirstWord(UserDB user){
    return PinyinHelper.getFirstWordPinyin((user.nickName != null && user.nickName!.isNotEmpty) ? user.nickName! : user.name!).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColor.color190,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Adapt.px(20)),
            topLeft: Radius.circular(Adapt.px(20)),
          ),
        ),
        child: Container(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildAppBar(),
        _buildSearchBar(),
        Expanded(
          child: widget.groupListAction == GroupListAction.select
              ? ListView.builder(
                  itemCount: _filteredUserList.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = _filteredUserList.keys.elementAt(index);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Text(
                          key,
                          style: TextStyle(
                              color: ThemeColor.color0,
                              fontSize: Adapt.px(16),
                              fontWeight: FontWeight.w600),
                        ),margin: EdgeInsets.only(bottom: Adapt.px(4)),),
                        ..._filteredUserList[key]!.map((user) => _buildUserItem(user)),
                      ],
                    );
                  },
                )
              : ListView.builder(
                  itemCount: widget.userList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildUserItem(widget.userList[index]);
                  },
                ),
        ),
      ],
    ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24)));
  }

  String buildTitle() {
    return widget.title ?? '';
  }

  Widget _buildTitleWidget() {
    return Text(
      buildTitle(),
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: Adapt.px(16),
          color: ThemeColor.color0),
    );
  }

  Widget buildEditButton() {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: widget.groupListAction == GroupListAction.select
          ? CommonImage(
        iconName: 'title_done.png',
        width: Adapt.px(24),
        height: Adapt.px(24),
      )
          : CommonImage(
        iconName: 'add_icon.png',
        width: Adapt.px(24),
        height: Adapt.px(24),
        package: 'ox_chat',
      ),
      onPressed: () {
      },
    );
  }

  Widget _buildAppBar(){
    return Container(
      height: Adapt.px(57),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: CommonImage(
              iconName: "icon_back_left_arrow.png",
              width: Adapt.px(24),
              height: Adapt.px(24),
              useTheme: true,
            ),
            onTap: () {
              OXNavigator.pop(context);
            },
          ),
          _buildTitleWidget(),
          buildEditButton(),
        ],
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
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
        margin: EdgeInsets.symmetric(vertical: Adapt.px(16)),
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
                    hintText: widget.searchBarHintText ?? 'search'.localized(),
                    hintStyle: TextStyle(
                        fontSize: Adapt.px(16),
                        fontWeight: FontWeight.w400,
                        height: Adapt.px(22.4) / Adapt.px(16),
                        color: ThemeColor.color160,),
                    border: InputBorder.none,),
                onChanged: _handlingSearch,
              ),
            ),
            ValueListenableBuilder(
              builder: (context, value, child) {
                return _isClear.value
                    ? GestureDetector(
                        onTap: () {
                          _controller.clear();
                          setState(() {
                            _filteredUserList = _groupedUserList;
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

  Widget _buildUserItem(UserDB user){
    bool isSelected = _selectedUserList.contains(user);

    return GroupMemberItem(
      user: user,
      action: widget.groupListAction == GroupListAction.select
          ? CommonImage(
              width: Adapt.px(24),
              height: Adapt.px(24),
              iconName: isSelected ? 'icon_select_follows.png' : 'icon_unSelect_follows.png',
              package: 'ox_chat',) : Container(),
      titleColor: isSelected ? ThemeColor.color0 : ThemeColor.color100,
      onTap: () {
        if (widget.groupListAction == GroupListAction.select) {
          if (!isSelected) {
            _selectedUserList.add(user);
          } else {
            _selectedUserList.remove(user);
          }
          setState(() {});
        }
      },
    );
  }

  void _handlingSearch(String searchQuery){
    setState(() {
      Map<String, List<UserDB>> searchResult = {};
      _groupedUserList.forEach((key, value) {
        List<UserDB> tempList = value.where((item) => item.name!.toLowerCase().contains(searchQuery.toLowerCase())).toList();
        searchResult[key] = tempList;
      });
      searchResult.removeWhere((key, value) => value.isEmpty);
      _filteredUserList = searchResult;
    });
  }
}
