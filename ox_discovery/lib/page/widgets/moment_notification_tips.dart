import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_network_image.dart';

enum NotificationType { post, reply }

class MomentNotificationTips extends StatefulWidget {
  final VoidCallback? onTap;
  final NotificationType? type;

  const MomentNotificationTips({super.key, this.onTap, this.type = NotificationType.post});

  @override
  State<MomentNotificationTips> createState() => _MomentNotificationTipsState();
}

class _MomentNotificationTipsState extends State<MomentNotificationTips> with OXMomentObserver {

  List<NoteDB> _notes = [];
  List<NotificationDB> _notification = [];
  List<String> _postAvatarList = [];
  List<String> _replyAvatarList = [];

  @override
  void initState() {
    super.initState();
    OXMomentManager.sharedInstance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final tips = widget.type == NotificationType.post
        ? '${_notes.length} new post'
        : '${_notification.length} replies';

    return _notes.isNotEmpty ? GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 40.px,
        padding: EdgeInsets.symmetric(
          horizontal: 12.px,
        ),
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.circular(22.px),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _memberAvatarWidget(),
            SizedBox(
              width: 8.px,
            ),
            Text(
              tips,
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: 14.px,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    ) : Container();
  }

  Widget _memberAvatarWidget() {
    final minWidth = 26.px;
    List<String> avatars = widget.type == NotificationType.post
        ? _postAvatarList
        : _replyAvatarList;
    int groupMemberNum = avatars.length;
    if (groupMemberNum == 0) return Container();
    int renderCount = groupMemberNum > 4 ? 4 : groupMemberNum;

    List<ImageProvider<Object>> _showMemberAvatarWidget() {
      List<ImageProvider<Object>> avatarList = [];
      for (var n = 0; n < avatars.length; n++) {
        String pic = avatars[n];
        avatarList.add(OXCachedNetworkImageProviderEx.create(
          context,
          pic,
        ));
      }
      return avatarList;
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: renderCount > 1 ? (6.px * renderCount + minWidth) : minWidth,
        minWidth: minWidth,
      ),
      child: AvatarStack(
        settings: RestrictedPositions(
          align: StackAlign.left,
          laying: StackLaying.first,
        ),
        borderColor: ThemeColor.color180,
        height: minWidth,
        avatars: _showMemberAvatarWidget(),
      ),
    );
  }

  Future<String> _getAvatar(String pubkey) async {
    UserDB? user = await Account.sharedInstance.getUserInfo(pubkey);
    return user?.picture ?? '';
  }

  Future<List<String>> _getAvatarBatch(List<String> pubkeys) async {
    List<String> avatars = [];
    for (var element in pubkeys) {
      String avatar = await _getAvatar(element);
      avatars.add(avatar);
    }
    return avatars;
  }

  @override
  didNewNotesCallBackCallBack(List<NoteDB> notes) async {
    List<String> avatars = await _getAvatarBatch(notes.map((e) => e.author).toSet().toList());
    setState(() {
      _notes = notes;
      _postAvatarList = avatars;
    });
  }

  @override
  didNewNotificationCallBack(List<NotificationDB> notifications) async {
    List<String> avatars = await _getAvatarBatch(notifications.map((e) => e.author).toSet().toList());
    setState(() {
      _notification = notifications;
      _replyAvatarList = avatars;
    });
  }

  @override
  void dispose() {
    OXMomentManager.sharedInstance.removeObserver(this);
    super.dispose();
  }
}
