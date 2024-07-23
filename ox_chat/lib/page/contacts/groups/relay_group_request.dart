import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/model/join_request_info.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_appbar.dart';

import 'package:ox_chat/utils/widget_tool.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: relay_group_request
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/6/24 16:24
class RelayGroupRequestsPage extends StatefulWidget {

  RelayGroupRequestsPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _RelayGroupRequestsPageState();
  }
}

class _RelayGroupRequestsPageState extends State<RelayGroupRequestsPage> with CommonStateViewMixin {
  Map<String, JoinRequestInfo> _requestMap = {};
  Map<String, BadgeDB> _badgeCache = {};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _initData() async {
    List<JoinRequestDB> allRequestJoinList = [];
    if(RelayGroup.sharedInstance.myGroups.length>0) {
      List<RelayGroupDB> tempGroups = RelayGroup.sharedInstance.myGroups.values.toList();
      await Future.forEach(tempGroups, (element) async {
        List<JoinRequestDB> requestJoinList = await RelayGroup.sharedInstance.getRequestList(element.groupId);
        allRequestJoinList.addAll(requestJoinList);
      });
    }
    if (allRequestJoinList.isNotEmpty) {
      allRequestJoinList.sort((request1, request2) {
        var joinRequest2Time = request2.createdAt;
        var joinRequest1Time = request1.createdAt;
        return joinRequest2Time.compareTo(joinRequest1Time);
      });
      await Future.forEach(allRequestJoinList, (joinRequestDB) async {
        _requestMap[joinRequestDB.requestId] = await JoinRequestInfo.toUserRequestInfo(joinRequestDB);
      });
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
      });
    } else {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_NoData);
      });
    }
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        title: 'str_group_join_requests'.localized(),
        useLargeTitle: false,
        centerTitle: true,
        backgroundColor: ThemeColor.color200,
      ),
      body: commonStateViewWidget(
        context,
        CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (_requestMap.length < 1) {
                  return SizedBox();
                }
                JoinRequestInfo item = _requestMap.values.elementAt(index);
                return _buildItemView(item, index);
              }, childCount: _requestMap.length),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemView(JoinRequestInfo item, int index) {
    return Slidable(
      key: ValueKey("$index"),
      endActionPane: ActionPane(
        extentRatio: 0.23,
        motion: const ScrollMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (BuildContext _) async {
              OXCommonHintDialog.show(context,
                  content: 'str_group_join_request_msg_delete_tips'.localized(),
                  actionList: [
                    OXCommonHintAction.cancel(onTap: () {
                      OXNavigator.pop(context);
                    }),
                    OXCommonHintAction.sure(
                        text: Localized.text('ox_common.confirm'),
                        onTap: () async {
                          OXNavigator.pop(context);
                          final int count = await RelayGroup.sharedInstance.ignoreJoinRequest(item.joinRequestDB);
                          if (count > 0) {
                            _initData();
                          }
                        }),
                  ],
                  isRowAction: true);
            },
            backgroundColor: ThemeColor.red1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                assetIcon('icon_chat_delete.png', 32, 32),
                Text(
                  'delete'.localized(),
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 24.px,
          vertical: 12.px,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(item),
            SizedBox(width: Adapt.px(16),),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyText('str_group_request_join_hint'.localized({r'${userName}': item.userName, r'${groupName}': item.groupName}), 16.sp, ThemeColor.color0),
                  SizedBox(
                    height: Adapt.px(2),
                  ),
                  _userRequestInfoWidget(item),
                  _optionBtnWidget(item),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool checkIfTextOverflows(String text, TextStyle style, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }

  TextStyle _contentTextStyle(){
    return TextStyle(
      color: ThemeColor.color120,
      fontSize: Adapt.px(14),
      fontWeight: FontWeight.w400,
    );
  }

  Widget _userRequestInfoWidget(JoinRequestInfo userInfo) {
    return Container(
      padding: EdgeInsets.only(
        bottom: Adapt.px(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: userInfo.isShowMore ? Adapt.px(250) : Adapt.px(180),
            child: Text(
              userInfo.joinRequestDB.content,
              softWrap: userInfo.isShowMore,
              overflow: userInfo.isShowMore ? null : TextOverflow.ellipsis,
              style: _contentTextStyle(),
            ),
          ),
          _showMoreBtnWidget(userInfo),
        ],
      ),
    );
  }

  Widget _showMoreBtnWidget(JoinRequestInfo requestInfo){
    if(requestInfo.isShowMore) return Container();
    return GestureDetector(
      onTap: (){
        _requestMap[requestInfo.joinRequestDB.requestId]?.isShowMore = true;
        setState(() {});
      },
      child: Container(
        child: Text(
          Localized.text('ox_chat.request_join_show_more'),
          style: TextStyle(
            color: ThemeColor.purple2,
            fontSize: Adapt.px(14),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(JoinRequestInfo item) {
    UserDB? otherDB = Account.sharedInstance.userCache[item.joinRequestDB.author]?.value;
    String showPicUrl = otherDB?.picture ?? '';
    return SizedBox(
      width: 60.px,
      height: 60.px,
      child: Stack(
        children: [
          OXUserAvatar(
            user: otherDB,
            imageUrl: showPicUrl,
            size: Adapt.px(60),
            isClickable: true,
            onReturnFromNextPage: () {
              setState(() { });
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FutureBuilder<BadgeDB?>(
              initialData: _badgeCache[item.joinRequestDB.requestId],
              builder: (context, snapshot) {
                return (snapshot.data != null)
                    ? OXCachedNetworkImage(
                  imageUrl: snapshot.data!.thumb,
                  width: Adapt.px(24),
                  height: Adapt.px(24),
                  fit: BoxFit.cover,
                )
                    : Container();
              },
              future: _getUserSelectedBadgeInfo(item, otherDB),
            ),
          )
        ],
      ),
    );
  }

  Future<BadgeDB?> _getUserSelectedBadgeInfo(JoinRequestInfo item, UserDB? otherDB) async {
    if (otherDB == null) return null;
    String badges = otherDB.badges ?? '';
    if (badges.isNotEmpty) {
      List<dynamic> badgeListDynamic = jsonDecode(badges);
      List<String> badgeList = badgeListDynamic.cast();
      BadgeDB? badgeDB;
      try {
        List<BadgeDB?> badgeDBList = await BadgesHelper.getBadgeInfosFromDB(badgeList);
        badgeDB = badgeDBList.first;
      } catch (error) {
        LogUtil.e("user selected badge info fetch failed: $error");
      }
      if (badgeDB != null) {
        _badgeCache[item.joinRequestDB.requestId] = badgeDB;
      }
      return badgeDB;
    }
    return null;
  }

  Widget _optionBtnWidget(JoinRequestInfo userInfo) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  _userRequestDialog(
                    Localized.text('ox_chat.request_join_ignore_member'),
                        () =>
                        _requestJoinOption(
                            userInfo.joinRequestDB, RequestOption.ignore),
                  ),
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
                  Localized.text('ox_chat.ignore_text'),
                ),
              ),
            ),
          ),
          SizedBox(
            width: Adapt.px(24),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  _userRequestDialog(
                    Localized.text('ox_chat.request_join_accept_member'),
                        () =>
                        _requestJoinOption(
                            userInfo.joinRequestDB, RequestOption.accept),
                  ),
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
                  Localized.text('ox_chat.accept_text'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _userRequestDialog(String content, Function callback) async {
    OXCommonHintDialog.show(
      context,
      title: '',
      content: content,
      actionList: [
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context);
        }),
        OXCommonHintAction.sure(text: Localized.text('ox_common.confirm'), onTap: callback),
      ],
      isRowAction: true,
    );
  }

  void _requestJoinOption(JoinRequestDB joinRequestDB, RequestOption type) async {
    if (RequestOption.accept == type) {
      await RelayGroup.sharedInstance..acceptJoinRequest(joinRequestDB);
    }

    if (RequestOption.ignore == type) {
      await RelayGroup.sharedInstance.ignoreJoinRequest(joinRequestDB);
    }
    _requestMap.remove(joinRequestDB.requestId);
    CommonToast.instance.show(context, Localized.text('ox_chat.group_mute_operate_success_toast'));
    OXNavigator.pop(context);
    setState(() {});
  }
}
