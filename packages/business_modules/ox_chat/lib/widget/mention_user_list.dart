
import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/avatar.dart';

class MentionUserList extends StatelessWidget {

  MentionUserList(this.userList, this.itemOnPressed,);

  final ValueNotifier<List<UserDBISAR>> userList;

  final Function(UserDBISAR item) itemOnPressed;

  final double itemHeight = Adapt.px(44);
  final double dividerHeight = 1;
  final int maxItemCount = 5;

  @override
  Widget build(BuildContext context) {
    final double maxContainerHeight = (itemHeight + dividerHeight) * maxItemCount;
    return ValueListenableBuilder(
      valueListenable: this.userList,
      child: SizedBox(),
      builder: (context, userList, child) {
        return Visibility(
          visible: userList.isNotEmpty,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: maxContainerHeight,
            ),
            decoration: BoxDecoration(
              color: ThemeColor.color180,
              borderRadius: BorderRadius.circular(Adapt.px(16)),
            ),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: userList.length,
              itemBuilder: (_, index) => _buildUserItem(userList[index]),
              separatorBuilder: (BuildContext context, int index) => Divider(height: dividerHeight),
            ),
          ),
        );
      }
    );
  }

  Widget _buildUserItem(UserDBISAR user) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => itemOnPressed(user),
      child: Container(
        height: itemHeight,
        child: Row(
          children: [
            OXUserAvatar(
              user: user,
              size: Adapt.px(24),
            ).setPadding(EdgeInsets.only(left: Adapt.px(16))),
            Text(
              user.getUserShowName(),
              style: TextStyle(
                fontSize: 14,
                color: ThemeColor.color0,
              ),
            ).setPadding(EdgeInsets.only(left: Adapt.px(12), right: Adapt.px(8))),
            Flexible(
              child: Text(
                user.dns ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeColor.color100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

