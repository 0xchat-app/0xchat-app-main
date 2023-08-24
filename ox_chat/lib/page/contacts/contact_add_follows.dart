import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_localizable/ox_localizable.dart';

import 'package:chatcore/chat-core.dart';

import 'package:ox_chat/utils/widget_tool.dart';


enum FollowsFriendStatus {
  hasFollows,
  selectFollows,
  unSelectFollows,
}

extension GetFollowsFriendStatusPic on FollowsFriendStatus{
  String get picName {
    switch(this) {
      case FollowsFriendStatus.hasFollows:
        return 'icon_has_follows.png';
      case FollowsFriendStatus.selectFollows:
        return 'icon_select_follows.png';
      case FollowsFriendStatus.unSelectFollows:
        return 'icon_unSelect_follows.png';
    }
  }
}

class ContactAddFollows extends StatefulWidget {
  @override
  _ContactAddFollowsState createState() => new _ContactAddFollowsState();
}


class _ContactAddFollowsState extends State<ContactAddFollows>  {

  @override
  void initState() {
    super.initState();
    _getFollowList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //
  void _getFollowList() async{
    final userMap = await Account.syncFollowListFromRelay(UserDB.decodePubkey('npub10td4yrp6cl9kmjp9x5yd7r8pm96a5j07lk5mtj2kw39qf8frpt8qm9x2wl') ?? '');
    print('userMap=====>$userMap');
  }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_chat.import_follows'),
        backgroundColor: ThemeColor.color190,
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Adapt.px(24),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          Localized.text('ox_chat.import_follows_tips'),
                          style: TextStyle(
                            color: ThemeColor.color0,
                            fontSize: Adapt.px(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      _followsFriendWidget(),
                      // Expanded(child:  _delOrAddFriendBtnView(),)
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: Adapt.px(37),
                child: _addContactBtnView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _followsFriendWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Adapt.px(4),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  Container(
                    child: assetIcon(
                      'icon_remark.png',
                      40.0,
                      40.0,
                      useTheme: false,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: Adapt.px(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Text(
                          'asdfasdfasdfasdfasdf',
                          style: TextStyle(
                            color: ThemeColor.color100,
                            fontSize: Adapt.px(16),
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                        Container(
                          child: Text(
                            'asdfasdfasdfasdfasdf',
                            style: TextStyle(
                              color: ThemeColor.color120,
                              fontSize: Adapt.px(14),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _followsStatusView(FollowsFriendStatus.hasFollows),
          ],
        ),
      ),
    );
  }

  Widget _addContactBtnView() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Adapt.px(24),
        ),
        width: double.infinity,
        height: Adapt.px(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ThemeColor.color180,
          gradient: LinearGradient(
            colors: [
              ThemeColor.gradientMainEnd,
              ThemeColor.gradientMainStart,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
                fontSize: Adapt.px(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(5)),
              child: Text(
                '5',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Adapt.px(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              'Contacts',
              style: TextStyle(
                color: Colors.white,
                fontSize: Adapt.px(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      onTap: () => {},
    );
  }

  Widget _followsStatusView(FollowsFriendStatus status){
    return  assetIcon(
      status.picName,
      24.0,
      24.0,
      useTheme: false,
    );
  }
}
