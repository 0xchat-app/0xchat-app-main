import 'dart:convert';
import 'dart:io';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ox_chat/model/community_menu_option_model.dart';
import 'package:ox_chat/model/message_content_model.dart';
import 'package:ox_chat/page/contacts/contact_request.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/page/session/chat_new_message_page.dart';
import 'package:ox_chat/page/session/search_page.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/utils/chat_session_utils.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/scheme/scheme_helper.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/throttle_utils.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/base_page_state.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_common/widgets/highlighted_clickable_text.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';

part 'chat_session_list_page_ui.dart';

const ListViewHorizontalPadding = 20.0;
final String ServiceListItemCreateTime = 'ServiceListItemCreateTime';
const tabBarName = "announcement";

class ChatSessionListPage extends StatefulWidget {
  ChatSessionListPage({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => new ChatSessionListPageState();
}

class ChatSessionListPageState extends BasePageState<ChatSessionListPage>
    with AutomaticKeepAliveClientMixin, CommonStateViewMixin, OXUserInfoObserver, WidgetsBindingObserver, OXChatObserver, SingleTickerProviderStateMixin{
  final _controller = ScrollController();

  ChatSessionListPageState();

  RefreshController _refreshController = new RefreshController();
  List<ChatSessionModelISAR> _msgDatas = []; // Message List
  int _allUnreadCount = 0;
  List<ValueNotifier<double>> _scaleList = [];
  Map<String, BadgeDBISAR> _badgeCache = {};
  Map<String, bool> _muteCache = {};
  Map<String, List<String>> _groupMembersCache = {};
  bool _isLogin = false;
  GlobalKey? _latestGlobalKey;
  double _nameMaxW = Adapt.screenW - (48 + 60 + 36 + 50).px;
  double _subTitleMaxW = Adapt.screenW - (48 + 60 + 36 + 30).px;
  bool addAutomaticKeepAlives = true;
  bool addRepaintBoundaries = true;
  final _throttle = ThrottleUtils(delay: Duration(milliseconds: 3000));

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      addAutomaticKeepAlives = false;
      addRepaintBoundaries = false;
    }
    OXChatBinding.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    WidgetsBinding.instance.addObserver(this);
    OXUserInfoManager.sharedInstance.addObserver(this);
    Localized.addLocaleChangedCallback(onLocaleChange); //fetchNewestNotice
    _merge();
    SchemeHelper.tryHandlerForOpenAppScheme();
  }

  onLocaleChange() {
    _onRefresh();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _refreshController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    OXUserInfoManager.sharedInstance.removeObserver(this);
    super.dispose();
  }

  @override
  String get routeName => 'CommunityMessageView';

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _dismissSlidable();
        break;
      default:
        break ;
    }
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    ChatLogUtils.info(className: 'ChatSessionListPage', funcName: 'didLoginSuccess', message: '');
    updateStateView(CommonStateView.CommonStateView_None);
    if (this.mounted) {
      ChatLogUtils.info(className: 'ChatSessionListPage', funcName: 'didLoginSuccess', message: 'mounted');
      setState(() {
        ChatLogUtils.info(className: 'ChatSessionListPage', funcName: 'didLoginSuccess', message: 'setState');
        _merge();
      });
    }
  }

  @override
  void didLogout() {
    _merge();
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    if (this.mounted) {
      setState(() {
        _merge();
      });
    }
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        // TODO: Handle this case.
        break;
      case CommonStateView.CommonStateView_NetworkError:
      case CommonStateView.CommonStateView_NoData:
        _onRefresh();
        break;
      case CommonStateView.CommonStateView_NotLogin:
        // TODO: Handle this case.
        break;
    }
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  void didPromptToneCallBack(MessageDBISAR message, int type) async {
    if (PromptToneManager.sharedInstance.isCurrencyChatPage != null && PromptToneManager.sharedInstance.isCurrencyChatPage!(message)) return;
    bool isMute = ChatSessionUtils.checkIsMute(message, type);
    if (!isMute && OXUserInfoManager.sharedInstance.canSound && !PromptToneManager.sharedInstance.isAppPaused)
      _throttle(() {
        PromptToneManager.sharedInstance.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        if (OXLoading.isShow) {
          await OXLoading.dismiss();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: ThemeColor.color200,
          elevation: 0,
          titleSpacing: 0.0,
          title: Container(
              margin: EdgeInsets.only(left: Adapt.px(24)),
              child: Container(
                width: Adapt.px(103),
                height: Adapt.px(24),
                child: CommonImage(
                  iconName: '0xchat_title_icon.png',
                  useTheme: true,
                ),
              )),
          actions: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: CommonImage(
                iconName: 'icon_home_add.png',
                size: 24.px,
                useTheme: true,
                package: 'ox_chat',
              ),
              onTap: () {
                if (_isLogin) {
                  OXNavigator.pushPage(context, (context) => ChatNewMessagePage(), fullscreenDialog: true);
                } else {
                  OXModuleService.pushPage(context, "ox_login", "LoginPage", {});
                }
              },
            ),
            SizedBox(
              width: Adapt.px(24),
            ),
          ],
        ),
        backgroundColor: ThemeColor.color200,
        body: OXSmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: _onRefresh,
          onLoading: null,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            controller: _controller,
            slivers: [
              SliverToBoxAdapter(
                child: _topSearch(),
              ),
              _isLogin && _msgDatas.length > 0
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildListViewItem(context, index);
                        },
                        childCount: itemCount(),
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: commonStateViewWidget(context, Container()),
                    ),
              SliverToBoxAdapter(
                child: SizedBox(height: 120.px),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int itemCount() {
    return _msgDatas.length;
  }

  void _onRefresh() async {
    _isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (!_isLogin) {
      if (this.mounted) {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_NotLogin);
        });
      }
    } else {
      _merge();
    }
    _refreshController.refreshCompleted();
  }

  void _merge() {
    _msgDatas.clear();
    _scaleList.clear();
    _isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (!_isLogin) {
      if (this.mounted) {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_NotLogin);
        });
      }
      return;
    }
    _msgDatas = OXChatBinding.sharedInstance.sessionList;
    _getMergeStrangerSession();

    _msgDatas.sort((session1, session2) {
      var session2CreatedTime = session2.createTime;
      var session1CreatedTime = session1.createTime;
      return session2CreatedTime.compareTo(session1CreatedTime);
    });
    _getGroupMembers(_msgDatas);
    if (this.mounted) {
      setState(() {});
    }
    if (_msgDatas.length > 0) {
      _scaleList = List.generate(_msgDatas.length, (index) => ValueNotifier(1.0));
      updateStateView(CommonStateView.CommonStateView_None);
      _updateReadStatus();
    } else {
      bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
      if (isLogin == false) {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_NotLogin);
        });
      } else {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_NoData);
        });
      }
    }
  }

  @override
  void didUpdateUserInfo() {}

  @override
  void didSessionUpdate() {
    _merge();
  }

  void _setReadBySession(ChatSessionModelISAR item) {
    setState(() {
      _allUnreadCount = _allUnreadCount - item.unreadCount;
      item.unreadCount = 0;
      MsgNotification(msgNum: _allUnreadCount).dispatch(context);
    });
    OXChatBinding.sharedInstance.updateChatSession(item.chatId ?? '', unreadCount: 0);
  }

  void _updateReadStatus() {
    int readCount = 0;
    for (ChatSessionModelISAR i in _msgDatas) {
      if (i.unreadCount > 0) {
        readCount += i.unreadCount;
      }
    }
    _allUnreadCount = readCount;
    if (mounted) {
      MsgNotification(msgNum: readCount).dispatch(context);
    }
  }

  @override
  renderNoDataView(BuildContext context, {String? errorTip}) {
    String addfriendStr = 'str_add_a_friend'.localized();
    String johnchannelStr = 'str_john_a_channel'.localized();
    return Container(
      padding: EdgeInsets.only(
        top: Adapt.px(80.0),
      ),
      child: Column(
        children: <Widget>[
          CommonImage(
            iconName: 'icon_no_data.png',
            width: Adapt.px(90),
            height: Adapt.px(90),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(24.0)),
            child: HighlightedClickableText(
              text: 'str_no_chats_hint'.localized({r'${addfriend}': addfriendStr,r'${johnchannel}': johnchannelStr}),
              highlightWords: [addfriendStr, johnchannelStr],
              onWordTap: (word) async {
                if (word == addfriendStr) {
                   CommunityMenuOptionModel.gotoAddFriend(context);
                } else if (word == johnchannelStr) {
                  OXNavigator.pushPage(
                      context,
                      (context) => SearchPage(
                            searchPageType: SearchPageType.discover,
                          ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<BadgeDBISAR?> _getUserSelectedBadgeInfo(ChatSessionModelISAR announceListItem) async {
    final chatId = announceListItem.chatId ?? '';
    UserDBISAR? friendUserDB = await Account.sharedInstance.getUserInfo(chatId);
    if (friendUserDB == null) {
      return null;
    }
    String badges = friendUserDB.badges ?? '';
    if (badges.isNotEmpty) {
      List<dynamic> badgeListDynamic = jsonDecode(badges);
      List<String> badgeList = badgeListDynamic.cast();
      BadgeDBISAR? badgeDB;
      try {
        List<BadgeDBISAR?> badgeDBList = await BadgesHelper.getBadgeInfosFromDB(badgeList);
        badgeDB = badgeDBList.firstOrNull;
      } catch (error) {
        LogUtil.e("user selected badge info fetch failed: $error");
      }
      if (badgeDB != null) {
        _badgeCache[chatId] = badgeDB;
      }
      return badgeDB;
    }
    return null;
  }

  void updateState(Function function) {
    setState(() {
      function.call();
    });
  }

  void _dismissSlidable() {
    if (_latestGlobalKey != null && _latestGlobalKey!.currentContext != null) {
      Slidable.of(_latestGlobalKey!.currentContext!)!.close();
    }
  }

  void _getGroupMembers(List<ChatSessionModelISAR> chatSessionModelList) async {
    chatSessionModelList.forEach((element) async {
      if (element.chatType == ChatType.chatGroup) {
        final groupId = element.groupId ?? '';
        List<UserDBISAR> groupList = await Groups.sharedInstance.getAllGroupMembers(groupId);
        List<String> avatars = groupList.map((element) => element.picture ?? '').toList();
        avatars.removeWhere((element) => element.isEmpty);
        _groupMembersCache[groupId] = avatars;
      }
    });
  }

  void _getMergeStrangerSession() {
    List<ChatSessionModelISAR> strangerSessionList = OXChatBinding.sharedInstance.strangerSessionList;
    if (strangerSessionList.isNotEmpty) {
      ChatSessionModelISAR mergeStrangerSession = ChatSessionModelISAR();
      int latestCreateTime = 0;
      for (var session in strangerSessionList) {
        if (session.createTime > latestCreateTime) {
          latestCreateTime = session.createTime;
        }
      }

      UserDBISAR? user = Account.sharedInstance.userCache[strangerSessionList.first.getOtherPubkey]?.value;
      String userShowName = user?.getUserShowName() ?? '';
      String content = strangerSessionList.length > 1 ? '$userShowName... and other ${strangerSessionList.length} chats' : '$userShowName';

      final unreadCount = OXChatBinding.sharedInstance.unReadStrangerSessionCount;
      mergeStrangerSession.chatId = CommonConstant.NOTICE_CHAT_ID;
      mergeStrangerSession.chatName = Localized.text('ox_chat.request_chat');
      mergeStrangerSession.chatType = ChatType.chatNotice;
      mergeStrangerSession.createTime = latestCreateTime;
      mergeStrangerSession.content = content;
      mergeStrangerSession.unreadCount = unreadCount;

      if (mergeStrangerSession.chatId == CommonConstant.NOTICE_CHAT_ID) {
        _msgDatas.add(mergeStrangerSession);
      }
    }
  }

  Future<int> _deleteStrangerSessionList() async {
    List<String> chatIds = OXChatBinding.sharedInstance.strangerSessionList.map((e) => e.chatId).toList();
    final int count = await OXChatBinding.sharedInstance.deleteSession(chatIds, isStranger: true);
    chatIds.forEach((id) {
      Contacts.sharedInstance.close(id);
    });
    return count;
  }

  void _itemFn(ChatSessionModelISAR item) async {
    final unreadMessageCount = item.unreadCount;
    _setReadBySession(item);
    switch(item.chatType){
      case ChatType.chatRelayGroup:
      case ChatType.chatGroup:
      case ChatType.chatChannel:
      case ChatType.chatSecret:
        ChatMessagePage.open(
          context: context,
          communityItem: item,
          unreadMessageCount: unreadMessageCount,
        );
        break;
      case ChatType.chatNotice:
        OXNavigator.pushPage(context, (context) => ContactRequest());
        break;
      default:
        ChatMessagePage.open(
          context: context,
          communityItem: item,
          unreadMessageCount: unreadMessageCount,
        ).then((value) {
          _merge();
        });
        break;
    }
  }

  @override
  void updateHomeTabClickAction(int num, bool isChangeToHomePage) {
    _controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

