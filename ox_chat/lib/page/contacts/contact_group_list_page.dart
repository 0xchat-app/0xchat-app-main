import 'package:flutter/material.dart';
import 'package:ox_chat/widget/alpha.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:lpinyin/lpinyin.dart';

enum GroupListAction {
  view,
  select
}

class ContactGroupListPage extends StatefulWidget {
  final List<UserDB> userList;
  final GroupListAction? groupListAction;
  final String title;
  final bool? isShowUserCount;

  const ContactGroupListPage(
      {super.key,
      required this.userList,
      required this.title,
      this.groupListAction = GroupListAction.view,
      this.isShowUserCount = true});

  @override
  State<ContactGroupListPage> createState() => _ContactGroupListPageState();
}

class _ContactGroupListPageState extends State<ContactGroupListPage> {

  List<UserDB> _userList = [];
  List<UserDB> _selectedUserList = [];
  ValueNotifier<int> _selectedUserCount = ValueNotifier(0);
  ValueNotifier<bool> _isClear = ValueNotifier(false);
  TextEditingController _controller = TextEditingController();
  Map<String, List<UserDB>> _groupedUserList = {};

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
      child: Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
          useLargeTitle: false,
          centerTitle: true,
          titleWidget: ValueListenableBuilder(
            valueListenable: _selectedUserCount,
            builder: (context,value,child) {
              return Text(
                "${widget.title} ${_selectedUserCount.value == 0 ? '' : ' (${_selectedUserCount.value})'}",
                  style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(17),
                  fontWeight: FontWeight.bold,
                ),
              );
            }
          ),
          backgroundColor: ThemeColor.color190,
          actions: [
            _buildEditButton(),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildEditButton() {
    return Container(
      margin: EdgeInsets.only(right: Adapt.px(24)),
      child: IconButton(
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
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        buildSearchBar(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(24),vertical: Adapt.px(16)),
          child: widget.groupListAction == GroupListAction.select
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: _groupedUserList.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = _groupedUserList.keys.elementAt(index);
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
                        )),
                        ..._groupedUserList[key]!.map((user) => _buildUserItem(user)),
                      ],
                    );
                  },
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.userList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildUserItem(widget.userList[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget buildSearchBar() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ThemeColor.color180,
        ),
        height: Adapt.px(38),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(12)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    icon: Container(
                      child: CommonImage(
                        iconName: 'icon_search.png',
                        width: Adapt.px(24),
                        height: Adapt.px(24),
                        fit: BoxFit.fill,
                      ),
                    ),
                    hintText: 'Search Member',
                    hintStyle: TextStyle(
                        fontSize: Adapt.px(14),
                        fontWeight: FontWeight.w400,
                        height: Adapt.px(22) / Adapt.px(14),
                        color: ThemeColor.color100),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: Adapt.px(13))),
              ),
            ),
            ValueListenableBuilder(
              builder: (context, value, child) {
                return _isClear.value
                    ? GestureDetector(
                        onTap: () {
                          _controller.clear();
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
        )).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24)));
  }

  Widget _buildUserItem(UserDB user){
    bool isSelected = _selectedUserList.contains(user);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (widget.groupListAction == GroupListAction.select) {
          if (!isSelected) {
            _selectedUserList.add(user);
            _selectedUserCount.value = _selectedUserList.length;
          } else {
            _selectedUserList.remove(user);
            _selectedUserCount.value = _selectedUserList.length;
          }
          setState(() {
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildUserAvatar(user.picture ?? ''),
          _buildUserInfo(user),
          const Spacer(),
          widget.groupListAction == GroupListAction.select ? CommonImage(
            width: Adapt.px(24),
            height:  Adapt.px(24),
            iconName: isSelected ? 'icon_select_follows.png' : 'icon_unSelect_follows.png',
            package: 'ox_chat',
          ): Container(),
        ],
      ).setPadding(EdgeInsets.only(bottom: Adapt.px(8))),
    );
  }

  Widget _buildUserAvatar(String picture) {
    Image placeholderImage = Image.asset(
      'assets/images/user_image.png',
      fit: BoxFit.cover,
      width: Adapt.px(76),
      height: Adapt.px(76),
      package: 'ox_common',
    );

    return ClipOval(
      child: Container(
        width: Adapt.px(40),
        height: Adapt.px(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(40)),
        ),
        child: CachedNetworkImage(
          imageUrl: picture,
          fit: BoxFit.cover,
          placeholder: (context, url) => placeholderImage,
          errorWidget: (context, url, error) => placeholderImage,
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserDB user) {
    String? nickName = user.nickName;
    String name = (nickName != null && nickName.isNotEmpty) ? nickName : user.name ?? '';
    String encodedPubKey = user.encodedPubkey;
    int pubKeyLength = encodedPubKey.length;
    String encodedPubKeyShow = '${encodedPubKey.substring(0, 10)}...${encodedPubKey.substring(pubKeyLength - 10, pubKeyLength)}';

    return Container(
      padding: EdgeInsets.only(
        left: Adapt.px(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            encodedPubKeyShow,
            style: TextStyle(
              color: ThemeColor.color120,
              fontSize: Adapt.px(14),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
