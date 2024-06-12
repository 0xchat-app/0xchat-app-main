import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/utils/discovery_utils.dart';
import 'package:ox_localizable/ox_localizable.dart';

class MomentNewPostTips extends StatefulWidget {
  final double? tipsHeight;
  final ValueSetter<List<NoteDB>>? onTap;
  const MomentNewPostTips({super.key, this.onTap, this.tipsHeight});

  @override
  State<MomentNewPostTips> createState() => _MomentNewPostTipsState();
}

class _MomentNewPostTipsState extends State<MomentNewPostTips>
    with OXMomentObserver {
  List<NoteDB> _notes = [];
  List<String> _avatarList = [];

  @override
  void initState() {
    super.initState();
    OXMomentManager.sharedInstance.addObserver(this);
    _updateNotes(OXMomentManager.sharedInstance.notes);
  }

  @override
  Widget build(BuildContext context) {
    return _notes.isNotEmpty
        ? Container(
            height: (widget.tipsHeight ?? 52).px,
            padding: EdgeInsets.only(top: 12.px),
            child: MomentTips(
              title: '${_notes.length} ${Localized.text('ox_discovery.new_post')}',
              avatars: _avatarList,
              onTap: () {
                OXMomentManager.sharedInstance.clearNewNotes();
                setState(() {
                  widget.onTap?.call(_notes);
                  _notes.clear();
                });
              },
            ),
          )
        : Container();
  }

  _updateNotes(List<NoteDB> notes) async {
    List<String> avatars = await DiscoveryUtils.getAvatarBatch(
        notes.map((e) => e.author).toSet().toList());
    if (avatars.length > 3) avatars = avatars.sublist(0, 3);
    setState(() {
      _notes = notes;
      _avatarList = avatars;
    });
  }

  @override
  didNewNotesCallBackCallBack(List<NoteDB> notes) async {
    await _updateNotes(notes);
  }

  @override
  void dispose() {
    OXMomentManager.sharedInstance.removeObserver(this);
    super.dispose();
  }
}

class MomentNotificationTips extends StatefulWidget {
  final double? tipsHeight;
  final ValueSetter<List<NotificationDB>>? onTap;
  const MomentNotificationTips({super.key, this.onTap, this.tipsHeight});

  @override
  State<MomentNotificationTips> createState() => _MomentNotificationTipsState();
}

class _MomentNotificationTipsState extends State<MomentNotificationTips>
    with OXMomentObserver {
  List<NotificationDB> _notifications = [];
  List<String> _avatarList = [];

  @override
  void initState() {
    super.initState();
    OXMomentManager.sharedInstance.addObserver(this);
    _updateNotifications(OXMomentManager.sharedInstance.notifications);
  }

  @override
  Widget build(BuildContext context) {
    return _notifications.isNotEmpty
        ? Container(
            height: (widget.tipsHeight ?? 52).px,
            padding: EdgeInsets.only(top: 12.px),
            child: MomentTips(
              title: '${_notifications.length} ${Localized.text('ox_discovery.reactions')}',
              avatars: _avatarList,
              onTap: () {
                OXMomentManager.sharedInstance.clearNewNotifications();
                setState(() {
                  _notifications.clear();
                });
                widget.onTap?.call(_notifications);
              },
            ),
          )
        : Container();
  }

  _updateNotifications(List<NotificationDB> notifications) async {
    List<String> avatars = await DiscoveryUtils.getAvatarBatch(
        notifications.map((e) => e.author).toSet().toList());
    if (avatars.length > 3) avatars = avatars.sublist(0, 3);
    setState(() {
      _notifications = notifications;
      _avatarList = avatars;
    });
  }

  @override
  didNewNotificationCallBack(List<NotificationDB> notifications) async {
    await _updateNotifications(notifications);
  }

  @override
  void dispose() {
    OXMomentManager.sharedInstance.removeObserver(this);
    super.dispose();
  }
}

class MomentTips extends StatelessWidget {
  final String title;
  final List<String> avatars;
  final VoidCallback? onTap;

  const MomentTips(
      {super.key, required this.title, required this.avatars, this.onTap});

  @override
  Widget build(BuildContext context) {
    return avatars.isNotEmpty
        ? GestureDetector(
            onTap: onTap,
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
                  _memberAvatarWidget(context),
                  SizedBox(
                    width: 8.px,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: ThemeColor.color0,
                      fontSize: 14.px,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Widget _memberAvatarWidget(BuildContext context) {
    final minWidth = 26.px;
    int groupMemberNum = avatars.length;
    if (groupMemberNum == 0) return Container();
    int renderCount = groupMemberNum > 4 ? 4 : groupMemberNum;

    List<ImageProvider<Object>> _showMemberAvatarWidget() {
      List<ImageProvider<Object>> avatarList = [];
      for (var n = 0; n < avatars.length; n++) {
        String pic = avatars[n];
        if (pic.isNotEmpty) {
          avatarList.add(
            OXCachedNetworkImageProviderEx.create(
              context,
              pic,
            ),
          );
        } else {
          avatarList.add(
            const AssetImage(
              'assets/images/user_image.png',
              package: 'ox_common',
            ),
          );
        }
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
}
