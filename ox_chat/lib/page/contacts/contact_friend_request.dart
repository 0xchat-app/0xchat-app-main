
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/model/friend_request_history_model.dart';
import 'package:ox_chat/page/contacts/contact_friend_user_info_page.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ContactFriendRequest extends StatefulWidget {
  ContactFriendRequest({Key? key}) : super(key: key);

  @override
  _ContactFriendRequestState createState() => _ContactFriendRequestState();
}

class _ContactFriendRequestState extends State<ContactFriendRequest> with CommonStateViewMixin, OXChatObserver {
  @override
  void initState() {
    super.initState();
    OXChatBinding.sharedInstance.addObserver(this);
    _getFriendRequest();
  }

  @override
  void dispose() {
    OXChatBinding.sharedInstance.removeObserver(this);
    super.dispose();
  }

  void _getFriendRequest() async {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (isLogin == false) {
      updateStateView(CommonStateView.CommonStateView_NotLogin);
      setState(() {});
      return;
    }
    if (OXChatBinding.sharedInstance.friendRequestMap.length == 0) {
      updateStateView(CommonStateView.CommonStateView_NoData);
    }
    OXChatBinding.sharedInstance.historyList.sort((a, b) => b.requestTime.compareTo(a.requestTime));
    setState(() {});
    OXChatBinding.sharedInstance.setAllFriendRequestAsRead();
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
        title: Localized.text('ox_chat.friend_request_title'),
        useLargeTitle: false,
        centerTitle: true,
        canBack: false,
        backgroundColor: ThemeColor.color200,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: CommonImage(
            iconName: "icon_back_left_arrow.png",
            width: Adapt.px(24),
            height: Adapt.px(24),
          ),
          onPressed: () {
            OXNavigator.pop(context);
          },
        ),
      ),
      body: commonStateViewWidget(
        context,
        Container(
          child: CustomScrollView(
            slivers: [
              SliverFixedExtentList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (OXChatBinding.sharedInstance.historyList.length < 1) {
                      return Container();
                    }
                    FriendRequestHistoryModel _reqModel = OXChatBinding.sharedInstance.historyList[index];
                    return Container(
                      height: Adapt.px(98),
                      margin: EdgeInsets.only(
                        left: Adapt.px(20),
                        right: Adapt.px(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildFriendAvatar(_reqModel),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _reqModel.name ?? '',
                                        style: TextStyle(
                                          fontSize: Adapt.px(16),
                                          color: ThemeColor.color10,
                                          letterSpacing: Adapt.px(0.4),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      OXDateUtils.convertTimeFormatString3(
                                        _reqModel.requestTime,
                                      ),
                                      style: TextStyle(
                                          fontSize: Adapt.px(14), color: ThemeColor.color100, letterSpacing: Adapt.px(0.4), fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                // Text(
                                //   "From Wallet Address",
                                //   style: TextStyle(fontSize: Adapt.px(14), color: ThemeColor.color120, fontWeight: FontWeight.w400),
                                // ),
                                _reqModel.status == 0
                                    ? _buildNotAddStatus(_reqModel)
                                    : _buildOperateButton(
                                        _reqModel.status == 1 ? "ox_chat.friend_request_added" : "ox_chat.friend_request_rejected",
                                        height: Adapt.px(30),
                                        textColor: ThemeColor.color100,
                                        bgColor: ThemeColor.color190,
                                        onTap: () {},
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: OXChatBinding.sharedInstance.historyList.length),
                  itemExtent: 98),
            ],
          ),
        ),
      ),
    );
  }

  //Unadded status
  Widget _buildNotAddStatus(FriendRequestHistoryModel item) {
    return Row(
      children: [
        _buildOperateButton(
          "ox_chat.add_friend_confirm",
          width: Adapt.px(131),
          height: Adapt.px(30),
          linearGradient: LinearGradient(
            colors: [
              ThemeColor.gradientMainEnd,
              ThemeColor.gradientMainStart,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          onTap: () {
            _confirmOnTap(item);
          },
        ),
        SizedBox(
          width: Adapt.px(12),
        ),
        Expanded(
          child: _buildOperateButton(
            "ox_chat.add_friend_reject",
            width: Adapt.px(131),
            height: Adapt.px(30),
            onTap: () {
              _rejectOnTap(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFriendAvatar(FriendRequestHistoryModel reqModel) {
    Image _placeholderImage = Image.asset(
      'assets/images/user_image.png',
      fit: BoxFit.cover,
      width: Adapt.px(76),
      height: Adapt.px(76),
      package: 'ox_chat',
    );

    return InkWell(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Adapt.px(60)),
        child: CachedNetworkImage(
          imageUrl: reqModel.picture ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => _placeholderImage,
          errorWidget: (context, url, error) => _placeholderImage,
          width: Adapt.px(60),
          height: Adapt.px(60),
        ),
      ),
      onTap: () {
        OXNavigator.pushPage(
            context,
            (context) => ContactFriendUserInfoPage(
                    userDB: UserDB(
                  pubKey: reqModel.pubKey,
                  name: reqModel.name,
                  aliasPubkey: reqModel.aliasPubkey,
                  picture: reqModel.picture,
                  badges: reqModel.badges,
                )));
      },
    ).setPadding(
      EdgeInsets.only(
        right: Adapt.px(16),
      ),
    );
  }

  Widget _buildOperateButton(String title,
      {double? width, double? height, Color? textColor, Color? bgColor, VoidCallback? onTap, LinearGradient? linearGradient}) {
    return GestureDetector(
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        alignment: Alignment.center,
        child: Text(
          Localized.text(title),
          style: TextStyle(fontSize: Adapt.px(15), color: textColor),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(8)),
          color: bgColor ?? ThemeColor.color180,
          gradient: linearGradient,
        ),
      ),
      onTap: onTap,
    );
  }

  void _confirmOnTap(FriendRequestHistoryModel item) async {
    await OXLoading.show();
    final OKEvent okEvent = await Friends.sharedInstance.acceptFriend(item.pubKey!, item.aliasPubkey!);
    await OXLoading.dismiss();
    if (okEvent.status) {
      item.status = 1;
      item.isRead = 1;
      OXChatBinding.sharedInstance.updateFriendRequestHistory(item);
      ///local accept friend req，notice others page refresh
      OXChatBinding.sharedInstance.friendAcceptCallBack(null);
      CommonToast.instance.show(context, Localized.text('ox_chat.added_successfully'));
      setState(() {});
    } else {
      CommonToast.instance.show(context, okEvent.message);
    }
  }

  void _rejectOnTap(FriendRequestHistoryModel item) async {
    await OXLoading.show();
    final OKEvent okEvent = await Friends.sharedInstance.rejectFriend(item.pubKey!, item.aliasPubkey!);
    await OXLoading.dismiss();
    if (okEvent.status) {
      item.status = 2;
      item.isRead = 1;
      OXChatBinding.sharedInstance.updateFriendRequestHistory(item);
      CommonToast.instance.show(context, Localized.text('ox_chat.rejected_successfully'));
      setState(() {});
    } else {
      CommonToast.instance.show(context, okEvent.message);
    }
  }

  @override
  void didFriendRequestCallBack() {
    OXChatBinding.sharedInstance.historyList.sort((a, b) => b.requestTime.compareTo(a.requestTime));
    setState(() {});
  }
}
