import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_group_chat_create_page.dart';
import 'package:ox_chat/page/contacts/contact_group_list_page.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ContactGroupChatCreatePage extends ContactGroupListPage {
  const ContactGroupChatCreatePage({super.key, required super.userList, super.title,super.groupListAction,super.searchBarHintText});

  @override
  _ContactCreateGroupChatState createState() => _ContactCreateGroupChatState();
}

class _ContactCreateGroupChatState extends ContactGroupListPageState {

  @override
  String buildTitle() {
    return "${Localized.text('ox_chat.str_new_group')} (${selectedUserList.length}/${userList.length})";
  }

  @override
  Widget buildEditButton() {
    final height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return GestureDetector(
      onTap: (){
        OXNavigator.presentPage(
          context,
          (context) => ContactGroupChatChoosePage(
            userList: selectedUserList,
          ),
        );
      },
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
          Localized.text('ox_chat.next'),
          style: TextStyle(
            fontSize: Adapt.px(16),
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
