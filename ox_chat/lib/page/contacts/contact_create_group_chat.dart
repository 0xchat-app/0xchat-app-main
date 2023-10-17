import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_group_list_page.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ContactCreateGroupChat extends ContactGroupListPage {
  const ContactCreateGroupChat({super.key, required super.userList, super.title,super.groupListAction,super.searchBarHintText});

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
    return Center(
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
