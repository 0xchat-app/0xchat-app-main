import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_channel_create.dart';
import 'package:ox_chat/page/contacts/contact_view_channels.dart';
import 'package:ox_chat/page/contacts/contact_qrcode_add_friend.dart';
import 'package:ox_chat/page/contacts/contact_request.dart';
import 'package:ox_chat/page/contacts/contact_view_friends.dart';
import 'package:ox_chat/page/session/search_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/log_util.dart';
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
        WidgetsBindingObserver,
        OXChatObserver {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();
  Widget? _cursorContactsWidget;
  Widget? _cursorChannelsWidget;
  bool _isShowTools = true;

  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _loadData() {
  }

  @override
  Widget build(BuildContext context) {
    final tabItems = [
      CommonCategoryTitleItem(
        title: Localized.text('ox_chat.contract_title_msg'),
        selectedIconName: '',
        unSelectedIconName: '',
      ),
      CommonCategoryTitleItem(
        title: Localized.text('ox_chat.contract_title_channels'),
        selectedIconName: '',
        unSelectedIconName: '',
      ),
    ];
    num itemHeight = (_selectedIndex == 0 ? Contacts.sharedInstance.allContacts.values.length : Channels.sharedInstance.myChannels.length) * Adapt.px(96);
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
            selectedFontSize: Adapt.px(20),
            unSelectedFontSize: Adapt.px(20),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                _topSearch(),
                if (_isShowTools)
                  Container(
                    alignment: Alignment.centerLeft,
                    height: Adapt.px(68),
                    color: ThemeColor.color200,
                    child: ListView.builder(
                        padding: EdgeInsets.only(left: Adapt.px(24)),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
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
                Container(
                  height: itemHeight > 0 ? Adapt.px(128) + itemHeight : Adapt.screenH(),
                  child: PageView(
                    physics: const BouncingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: [
                      ContractViewFriends(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: false,
                        scrollController: _scrollController,
                        onCursorContactsChanged: _setCursorContactsWidget,
                      ),
                      ContactViewChannels(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: false,
                        scrollController: _scrollController,
                        onCursorChannelsChanged: _setCursorChannelsWidget,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isShowTools && (_cursorContactsWidget != null || _cursorChannelsWidget != null))
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _selectedIndex == 0 ? _cursorContactsWidget : _cursorChannelsWidget,
            ),
        ],
      ),
    );
  }

  void _setCursorContactsWidget(Widget widget) {
    setState(() {
      _cursorContactsWidget = widget;
    });
  }

  void _setCursorChannelsWidget(Widget widget) {
    setState(() {
      _cursorChannelsWidget = widget;
    });
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
    return InkWell(
      onTap: () {
        if (_selectedIndex == 0) {
          SearchPage(
            searchPageType: SearchPageType.singleFriend,
          ).show(context);
        } else if (_selectedIndex == 1) {
          SearchPage(
            searchPageType: SearchPageType.singleChannel,
          ).show(context);
        }
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
              'search'.localized() +
                  (_selectedIndex == 0 ? 'search_tips_suffix_friend'.localized() : 'search_tips_suffix_channel'.localized()),
              15,
              ThemeColor.color150,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  void _gotoAddFriend() {
    OXNavigator.pushPage(context, (context) => CommunityQrcodeAddFriend());
  }

  void _gotoCreateGroup() {
    OXNavigator.pushPage(context, (context) => ChatChannelCreate());
  }

  @override
  void didLoginSuccess(UserDB? userInfo) {
    _loadData();
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

  @override
  void didSessionUpdate() {
    _isShowTools = true;
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (!isLogin) {
      _isShowTools = false;
    }
    setState(() {});
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
