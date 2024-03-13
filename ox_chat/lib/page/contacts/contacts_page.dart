import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_channel_create.dart';
import 'package:ox_chat/page/contacts/contact_view_channels.dart';
import 'package:ox_chat/page/contacts/contact_qrcode_add_friend.dart';
import 'package:ox_chat/page/contacts/contact_request.dart';
import 'package:ox_chat/page/contacts/contact_view_friends.dart';
import 'package:ox_chat/page/contacts/contact_view_groups.dart';
import 'package:ox_chat/page/session/search_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/categoryView/common_category_title_view.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

import 'contact_add_follows.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({Key? key}) : super(key: key);

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage>
    with
        SingleTickerProviderStateMixin,
        OXUserInfoObserver,
        WidgetsBindingObserver {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  bool _isShowTools = false;
  final tabItems = [
    CommonCategoryTitleItem(title: Localized.text('ox_chat.str_title_contacts')),
    CommonCategoryTitleItem(title: Localized.text('ox_chat.str_title_groups')),
    CommonCategoryTitleItem(title: Localized.text('ox_chat.str_title_channels')),
  ];

  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    WidgetsBinding.instance.addObserver(this);
    _isShowTools = OXUserInfoManager.sharedInstance.isLogin;
  }

  @override
  void dispose() {
    OXUserInfoManager.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: AppBar(
        backgroundColor: ThemeColor.color200,
        elevation: 0,
        titleSpacing: 0.0,
        //Title widget without any spacing on both sides
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: CommonCategoryTitleView(
            bgColor: Colors.transparent,
            selectedGradientColors: [
              ThemeColor.gradientMainStart,
              ThemeColor.gradientMainEnd
            ],
            unselectedGradientColors: [ThemeColor.color120, ThemeColor.color120],
            selectedFontSize: Adapt.sp(20),
            unSelectedFontSize: Adapt.sp(20),
            items: tabItems,
            onTap: (int value) {
              setState(() {
                _selectedIndex = value;
              });
              _pageController.animateToPage(
                _selectedIndex,
                duration: const Duration(milliseconds: 2),
                curve: Curves.linear,
              );
            },
            selectedIndex: _selectedIndex,
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: Adapt.px(16), top: Adapt.px(0)),
            color: Colors.transparent,
            child: OXButton(
              highlightColor: Colors.transparent,
              color: Colors.transparent,
              minWidth: Adapt.px(44),
              height: Adapt.px(44),
              child: CommonImage(
                iconName: "add_icon.png",
                width: Adapt.px(18),
                height: Adapt.px(18),
                package: 'ox_chat',
              ),
              onPressed: () {
                _gotoAddFriend();
              },
            ),
          ),
        ],
      ),
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          ContractViewFriends(
            physics: BouncingScrollPhysics(),
            shrinkWrap: false,
            topWidget: _topSearch(),
          ),
          ContactViewGroups(
            physics: BouncingScrollPhysics(),
            shrinkWrap: false,
            topWidget: _topSearch(),
          ),
          ContactViewChannels(
            physics: BouncingScrollPhysics(),
            shrinkWrap: false,
            topWidget: _topSearch(),
          ),
        ],
      ),
    );
  }


  Widget _inkWellWidget(
      {required String content, required GestureTapCallback onTap,bool isShowCount = true}) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(
            top: Adapt.px(14), bottom: Adapt.px(14), right: Adapt.px(12)),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
        height: Adapt.px(40),
        child: Row(
          children: [
            Text(
              content,
              style: TextStyle(
                  fontSize: 14,
                  color: ThemeColor.color10,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(width: Adapt.px(6)),
            isShowCount ? _unReadCount() : Container(),
          ],
        ),
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(20))),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _unReadCount() {
    int _unReadStrangerSessionCount =
        OXChatBinding.sharedInstance.unReadStrangerSessionCount;
    if (_unReadStrangerSessionCount > 0 && _unReadStrangerSessionCount < 10) {
      return ClipOval(
        child: Container(
          alignment: Alignment.center,
          color: ThemeColor.red1,
          width: Adapt.px(17),
          height: Adapt.px(17),
          child: Text(
            _unReadStrangerSessionCount.toString(),
            style: _Style.read(),
          ),
        ),
      );
    } else if (_unReadStrangerSessionCount >= 10 &&
        _unReadStrangerSessionCount < 100) {
      return Container(
        alignment: Alignment.center,
        width: Adapt.px(22),
        height: Adapt.px(20),
        decoration: BoxDecoration(
          color: ThemeColor.red1,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(13.5))),
        ),
        padding: EdgeInsets.symmetric(
            vertical: Adapt.px(3), horizontal: Adapt.px(3)),
        child: Text(
          _unReadStrangerSessionCount.toString(),
          style: _Style.read(),
        ),
      );
    } else if (_unReadStrangerSessionCount >= 100) {
      return Container(
        alignment: Alignment.center,
        width: Adapt.px(28),
        height: Adapt.px(20),
        decoration: BoxDecoration(
          color: ThemeColor.red1,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(13.5))),
        ),
        padding: EdgeInsets.symmetric(
            vertical: Adapt.px(3), horizontal: Adapt.px(3)),
        child: Text(
          '99+',
          style: _Style.read(),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _topSearch() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            SearchPage(searchPageType: SearchPageType.all).show(context);
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              horizontal: Adapt.px(24),
              vertical: Adapt.px(6),
            ),
            height: Adapt.px(48),
            decoration: BoxDecoration(
              color: ThemeColor.color190,
              borderRadius: BorderRadius.all(Radius.circular(Adapt.px(16))),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(left: Adapt.px(18)),
                  child: assetIcon(
                    'icon_chat_search.png',
                    24,
                    24,
                  ),
                ),
                SizedBox(
                  width: Adapt.px(8),
                ),
                MyText(
                  'search'.localized(),
                  15,
                  ThemeColor.color150,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ),
        if (_isShowTools)
          Container(
            alignment: Alignment.centerLeft,
            height: Adapt.px(68),
            color: ThemeColor.color200,
            child: ListView.builder(
                padding: EdgeInsets.only(left: Adapt.px(24)),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _getButtonCount(),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _inkWellWidget(
                        content: Localized.text('ox_chat.string_request_title'),
                        onTap: () {
                          OXNavigator.pushPage(
                            context,
                                (context) => ContactRequest(),
                          );
                        });
                  }
                  return _inkWellWidget(
                    content: Localized.text('ox_chat.import_follows'),
                    isShowCount: false,
                    onTap: () async {
                      var result = await OXNavigator.pushPage(
                        context,
                            (context) => ContactAddFollows(),
                      );
                      if (result == true) {
                        OXCommonHintDialog.show(
                          context,
                          content: Localized.text('ox_chat.import_follows_success_dialog'),
                        );
                      }
                    },
                  );

                  return Container();
                }),
          ),
      ],
    );
  }

  void _gotoAddFriend() {
    OXNavigator.pushPage(context, (context) => CommunityQrcodeAddFriend());
  }

  int _getButtonCount(){
    return _selectedIndex == 0 ? 2 : _selectedIndex == 1 ?  1 : 0;
  }

  @override
  void didLoginSuccess(UserDB? userInfo) {
    setState(() {
      _isShowTools = true;
    });
  }

  @override
  void didLogout() {
    setState(() {
      _isShowTools = false;
    });
  }

  @override
  void didSwitchUser(UserDB? userInfo) {
    // TODO: implement didSwitchUser
  }

}

class _Style {
  static TextStyle read() {
    return new TextStyle(
      fontSize: Adapt.px(12),
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
  }
}
