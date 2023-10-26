import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:flutter/services.dart';
import 'package:chatcore/chat-core.dart';

class GroupJoinRequests extends StatefulWidget {

  final String groupId;

  GroupJoinRequests({required this.groupId});
  @override
  _GroupJoinRequestsState createState() => new _GroupJoinRequestsState();
}

class _GroupJoinRequestsState extends State<GroupJoinRequests> {
  @override
  void initState() {
    super.initState();
    _getRequestList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getRequestList() async{
    print('====widget.groupId===${widget.groupId}');
    List<MessageDB> requestJoinList = await Groups.sharedInstance.getRequestList(groupId: widget.groupId);
    print('====requestJoinList=====$requestJoinList');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: 'Join Requests',
        backgroundColor: ThemeColor.color190,
      ),
      body: Container(
        child: Column(
          children: [
            _userRequestItem(),
          ],
        ),
      ),
    );
  }

  Widget _userRequestItem() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Adapt.px(12),
        horizontal: Adapt.px(24),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: CommonImage(
              iconName: 'user_image.png',
              width: Adapt.px(60),
              height: Adapt.px(60),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: Adapt.px(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Elon Musk request jion',
                    style: TextStyle(
                      color: ThemeColor.color0,
                      fontSize: Adapt.px(16),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Adapt.px(4),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Group Name',
                          style: TextStyle(
                            color: ThemeColor.color0,
                            fontSize: Adapt.px(16),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '12:12',
                          style: TextStyle(
                            color: ThemeColor.color120,
                            fontSize: Adapt.px(14),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  ),
                  _userRequestInfoWidget(),
                  _optionBtnWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userRequestInfoWidget() {
    return Container(
      padding: EdgeInsets.only(
        bottom: Adapt.px(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'This is join rasdfsadfeason.asdfasf..',
            style: TextStyle(
              color: ThemeColor.color120,
              fontSize: Adapt.px(14),
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            child: Container(
              child: Text(
                'Show more',
                style: TextStyle(
                  color: ThemeColor.purple1,
                  fontSize: Adapt.px(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionBtnWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ThemeColor.color180,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Adapt.px(24),
                  ),
                ),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                vertical: Adapt.px(5),
              ),
              child: Text(
                'Ignore',
              ),
            ),
          ),
          SizedBox(
            width: Adapt.px(24),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    ThemeColor.gradientMainEnd.withOpacity(0.24),
                    ThemeColor.gradientMainStart.withOpacity(0.24),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                vertical: Adapt.px(5),
              ),
              child: Text(
                'Accept',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
