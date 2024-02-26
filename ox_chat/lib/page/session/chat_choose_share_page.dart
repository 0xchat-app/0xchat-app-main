import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/widget/group_member_item.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_chat/page/contacts/contact_group_list_page.dart';
import 'package:ox_chat/utils/chat_send_invited_template_helper.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/alpha.dart';
import 'package:lpinyin/lpinyin.dart';

class ChatChooseSharePage extends StatefulWidget {
  final Key? key;
  final String? title;
  final String? msg;

  ChatChooseSharePage({this.key, this.title, this.msg}) : super(key: key);

  @override
  _ChatChooseSharePageState createState() => _ChatChooseSharePageState();
}

class _ChatChooseSharePageState extends State<ChatChooseSharePage> {
  List<UserDB> userList = [];
  List<UserDB> _selectedUserList = [];
  ValueNotifier<bool> _isClear = ValueNotifier(false);
  TextEditingController _controller = TextEditingController();
  Map<String, List<UserDB>> _groupedUserList = {};
  Map<String, List<UserDB>> _filteredUserList = {};
  String _ShareToName = 'xxx';

  @override
  void initState() {
    super.initState();
    _fetchUserListAsync();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        _isClear.value = true;
      } else {
        _isClear.value = false;
      }
    });
  }

  Future<void> _fetchUserListAsync() async {
    List<UserDB> users = await fetchUserList();
    setState(() {
      userList = users;
    });
  }

  Future<List<UserDB>> fetchUserList() async {
    List<UserDB> allContacts = Contacts.sharedInstance.allContacts.values.toList();
    return allContacts;
  }

  String buildTitle() {
    return '${Localized.text('ox_chat.select_chat')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: buildTitle(),
        actions: [
          IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: CommonImage(
                iconName: 'icon_done.png',
                width: 24.px,
                height: 24.px,
                useTheme: true,
              ),
              onPressed: () {
                buildSendPressed();
              }
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: ListView.builder(
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
        ),
      ],
    ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24)));
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
                  hintText: 'search'.localized(),
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
      action: CommonImage(
        width: Adapt.px(24),
        height: Adapt.px(24),
        iconName: isSelected ? 'icon_select_follows.png' : 'icon_unSelect_follows.png',
        package: 'ox_chat',) ,
      titleColor: isSelected ? ThemeColor.color0 : ThemeColor.color100,
      onTap: () {
        if (!isSelected) {
          _selectedUserList.add(user);
        } else {
          _selectedUserList.remove(user);
        }
        setState(() {});
      },
    );
  }

  groupedUser(){
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
    _filteredUserList = _groupedUserList;
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

  buildSendPressed() {
    OXCommonHintDialog.show(context,
        title: Localized.text('ox_common.tips'),
        content: 'ox_chat.str_share_msg_confirm_content'.localized({r'${name}': _ShareToName}),
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context, false);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.str_share'),
              onTap: () async {
                OXNavigator.pop(context, true);
                ChatSendInvitedTemplateHelper.sendMsgToOther(_selectedUserList[0], widget.title ?? '');
                OXNavigator.pop(context, true);
              }),
        ],
        isRowAction: true);
  }
}
