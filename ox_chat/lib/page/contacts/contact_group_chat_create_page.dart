import 'package:flutter/material.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/page/contacts/contact_relay_page.dart';
import 'package:ox_chat/page/session/chat_group_message_page.dart';
import 'package:ox_chat/page/session/chat_relay_group_msg_page.dart';
import 'package:ox_chat/utils/chat_send_invited_template_helper.dart';
import 'package:ox_chat/widget/group_member_item.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/widgets/common_loading.dart';

class ContactGroupChatCreatePage extends StatefulWidget {
  final List<UserDBISAR> userList;
  final GroupType groupType;

  const ContactGroupChatCreatePage({
    super.key,
    required this.userList,
    required this.groupType,
  });

  @override
  State<ContactGroupChatCreatePage> createState() => _ContactGroupChatCreatePageState();
}

class _ContactGroupChatCreatePageState extends State<ContactGroupChatCreatePage> {

  TextEditingController _controller = TextEditingController();

  List<UserDBISAR> userList = [];

  String _chatRelay = 'wss://relay.0xchat.com';

  @override
  void initState() {
    super.initState();
    _initUserList();
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
        _buildGroupNameEditText(),
        // _buildGroupRelayEditText(),
        SizedBox(height: 12.px),
        _buildGroupMemberList(),
      ],
    ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24)));
  }

  Widget _buildAppBar(){
    return Container(
      height: Adapt.px(57),
      margin: EdgeInsets.only(bottom: Adapt.px(16)),
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
          _buildCreateButton(),
        ],
      ),
    );
  }

  Widget _buildTitleWidget() {
    return Text(
      '${Localized.text('ox_chat.str_new_group')} (${userList.length})',
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: Adapt.px(16),
          color: ThemeColor.color0),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: () async => await _createGroup(),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [
              ThemeColor.gradientMainEnd,
              ThemeColor.gradientMainStart,
            ],
          ).createShader(Offset.zero & bounds.size);
        },
        child: Text(
          Localized.text('ox_common.create'),
          style: TextStyle(
            fontSize: Adapt.px(16),
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildItem({required String itemName,required Widget itemContent}){
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
        SizedBox(height: Adapt.px(12),),
        itemContent,
      ],
    ).setPadding(EdgeInsets.only(bottom: Adapt.px(12)));
  }

  Widget _buildGroupNameEditText(){
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

  Widget _buildGroupRelayEditText(){
    return _labelWidget(
      title:  Localized.text('ox_chat.relay'),
      content: _chatRelay,
      onTap: () async {
        var result = await OXNavigator.presentPage(
          context,
              (context) => ContactRelayPage(),
        );
        if (result != null && _isWssWithValidURL(result as String)) {
          _chatRelay = result;
          setState(() {});
        }
      },
    );
  }

  bool _isWssWithValidURL(String input) {
    RegExp regex = RegExp(
        r'^wss:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(:[0-9]{1,5})?(\/\S*)?$');
    return regex.hasMatch(input);
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
      return text.substring(0, 10) +
          '...' +
          text.substring(text.length - 10, text.length);
    }
    return text;
  }

  Widget _buildGroupMemberList() {
    return Expanded(
      child: _buildItem(
        itemName: Localized.text("ox_chat.group_member"),
        itemContent: Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GroupMemberItem(user: userList[index]);
            },
            itemCount: userList.length,
          ),
        ),
      ),
    );
  }

  void _initUserList(){
    UserDBISAR? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    userList = widget.userList;
    if(userDB != null && !userList.contains(userDB)) userList.add(userDB);
    setState(() {});
  }


  Future<void> _createGroup() async {
    String name = _controller.text;
    if(name.isEmpty) {
      CommonToast.instance.show(context, Localized.text("ox_chat.group_enter_hint_text"));
      return;
    };
    await OXLoading.show();
    List<String> members = userList.map((user) => user.pubKey).toList();
    GroupDBISAR? groupDB = await Groups.sharedInstance
        .createPrivateGroup(OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey, '', name, members);
    await OXLoading.dismiss();
    if (groupDB != null) {
      OXNavigator.pop(context);
      OXNavigator.pushReplacement(
        context,
        ChatGroupMessagePage(
          communityItem: ChatSessionModelISAR(
            chatId: groupDB.groupId,
            groupId: groupDB.groupId,
            chatType: ChatType.chatGroup,
            chatName: groupDB.name,
            createTime: groupDB.updateTime,
            avatar: groupDB.picture,
          ),
        ),
      );
      // ChatSendInvitedTemplateHelper.sendGroupInvitedTemplate(userList,groupDB.groupId);
    } else {
      CommonToast.instance.show(context, Localized.text('ox_chat.create_group_fail_tips'));
    }
  }
}
