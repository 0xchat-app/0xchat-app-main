import 'package:flutter/material.dart';
import 'package:ox_chat/page/session/chat_group_message_page.dart';
import 'package:ox_chat/widget/group_member_item.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';

class ContactGroupChatCreatePage extends StatefulWidget {
  final List<UserDB> userList;
  const ContactGroupChatCreatePage({super.key, required this.userList});

  @override
  State<ContactGroupChatCreatePage> createState() => _ContactGroupChatCreatePageState();
}

class _ContactGroupChatCreatePageState extends State<ContactGroupChatCreatePage> {

  TextEditingController _controller = TextEditingController();

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
      '${Localized.text('ox_chat.str_new_group')} (${widget.userList.length})',
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

  Widget _buildGroupMemberList() {
    return Expanded(
      child: _buildItem(
        itemName: Localized.text("ox_chat.group_member"),
        itemContent: Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GroupMemberItem(user: widget.userList[index]);
            },
            itemCount: widget.userList.length,
          ),
        ),
      ),
    );
  }

  Future<void> _createGroup() async {
    String name = _controller.text;
    if(name.isEmpty) {
      CommonToast.instance.show(context, Localized.text("ox_chat.group_enter_hint_text"));
      return;
    };
    List<String> members = widget.userList.map((user) => user.pubKey).toList();
    GroupDB? groupDB = await Groups.sharedInstance.createGroup(name, members);
    if (groupDB != null) {
      OXNavigator.pushReplacement(
        context,
        ChatGroupMessagePage(
          communityItem: ChatSessionModel(
            groupId: groupDB.groupId,
            chatType: ChatType.chatGroup,
            chatName: groupDB.name,
            createTime: groupDB.updateTime,
            avatar: groupDB.picture,
          ),
        ),
      );
    }else{
      CommonToast.instance.show(context, 'create group failed');
    }
  }
}
