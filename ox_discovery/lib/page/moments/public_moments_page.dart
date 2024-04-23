import 'dart:ui';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';

import '../../utils/moment_widgets_utils.dart';
import '../widgets/moment_widget.dart';
import 'moments_page.dart';
import 'notifications_moments_page.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';

class PublicMomentsPage extends StatefulWidget {
  const PublicMomentsPage({Key? key}) : super(key: key);

  @override
  State<PublicMomentsPage> createState() => _PublicMomentsPageState();
}

class _PublicMomentsPageState extends State<PublicMomentsPage> with OXMomentObserver {
  List<NoteDB> notesList = [];

  @override
  void initState() {
    super.initState();
    _getDataList();
  }

  void _getDataList() async {
    String? pukbey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    // List<NoteDB>? noteLst = await Moment.sharedInstance.loadFriendNotes(pukbey ?? '7adb520c3ac7cb6dc8253508df0ce1d975da49fefda9b5c956744a049d230ace');
    List<NoteDB>? noteLst = await Moment.sharedInstance.loadAllNotesFromDB();
    Map<String, NoteDB> list = OXMomentManager.sharedInstance.privateNotesMap;
    if(noteLst != null){
      notesList = NoteDBEx.getNoteToMomentList(noteLst);
    }
    setState(() {});
  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.px,
        ),
        margin: EdgeInsets.only(
          bottom: 100.px,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _newMomentTipsWidget(),
            _getMomentListWidget(),
          ],
        ),
      ),
    );
  }

  Widget _getMomentListWidget() {
    return ListView.builder(
      primary: false,
      controller: null,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        NoteDB note = notesList[index];
        return MomentWidget(
          noteDB: note,
          clickMomentCallback: () async{
           await OXNavigator.pushPage(context, (context) => MomentsPage(noteDB: note));

          },
        );
      },
    );
  }

  Widget _newMomentTipsWidget() {
    Widget _wrapContainerWidget({
      required Widget leftWidget,
      required String rightContent,
      required GestureTapCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40.px,
          padding: EdgeInsets.symmetric(
            horizontal: 12.px,
          ),
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.all(
              Radius.circular(
                Adapt.px(22),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftWidget,
              SizedBox(
                width: 8.px,
              ),
              Text(
                rightContent,
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: 14.px,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _wrapContainerWidget(
            onTap: () {
              OXNavigator.pushPage(
                  context, (context) => NotificationsMomentsPage());
            },
            leftWidget: _memberAvatarWidget(),
            rightContent: '10 new pots',
          ),
          SizedBox(
            width: 20.px,
          ),
          _wrapContainerWidget(
            onTap: () {
              OXNavigator.pushPage(
                  context, (context) => NotificationsMomentsPage());
            },
            leftWidget: MomentWidgetsUtils.clipImage(
              imageName: 'moment_avatar.png',
              borderRadius: 26.px,
              imageSize: 26.px,
            ),
            rightContent: '2 replies',
          ),
        ],
      ),
    );
  }

  Widget _memberAvatarWidget() {
    int groupMemberNum = 4;
    if (groupMemberNum == 0) return Container();
    int renderCount = groupMemberNum > 8 ? 8 : groupMemberNum;
    return Container(
      margin: EdgeInsets.only(
        right: Adapt.px(0),
      ),
      constraints: BoxConstraints(
        maxWidth: Adapt.px(8 * renderCount + 8),
        minWidth: Adapt.px(26),
      ),
      child: AvatarStack(
        settings: RestrictedPositions(
          // maxCoverage: 0.1,
          // minCoverage: 0.2,
          align: StackAlign.left,
          laying: StackLaying.first,
        ),
        borderColor: ThemeColor.color180,
        height: Adapt.px(26),
        avatars: _showMemberAvatarWidget(3),
      ),
    );
  }

  List<ImageProvider<Object>> _showMemberAvatarWidget(int renderCount) {
    List<ImageProvider<Object>> avatarList = [];
    for (var n = 0; n < renderCount; n++) {
      avatarList.add(
        const AssetImage(
          'assets/images/moment_avatar.png',
          package: 'ox_discovery',
        ),
      );
    }
    return avatarList;
  }

  @override
  didNewPrivateNotesCallBack(NoteDB noteDB) {
    _getDataList();
  }

  @override
  didNewContactsNotesCallBack(NoteDB noteDB) {
    _getDataList();
  }

  @override
  didNewUserNotesCallBack(NoteDB noteDB) {
    _getDataList();
  }
}
