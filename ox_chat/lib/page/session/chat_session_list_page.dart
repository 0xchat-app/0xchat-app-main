import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ox_chat/page/contacts/contact_group_chat_choose_page.dart';
import 'package:ox_chat/page/contacts/contact_group_list_page.dart';
import 'package:ox_chat/page/session/chat_group_message_page.dart';
import 'package:ox_chat/page/session/chat_secret_message_page.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_chat/model/message_content_model.dart';
import 'package:ox_common/model/msg_notification_model.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/page/contacts/contact_channel_create.dart';
import 'package:ox_chat/page/contacts/contact_qrcode_add_friend.dart';
import 'package:ox_chat/page/session/chat_channel_message_page.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/page/session/search_page.dart';
import 'package:ox_chat/utils/chat_log_utils.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_chat/model/community_menu_option_model.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/model/relay_model.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/scan_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_relay_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/base_page_state.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_common/widgets/common_scan_page.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/highlighted_clickable_text.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/utils/chat_prompt_tone.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_common/utils/throttle_utils.dart';

const ListViewHorizontalPadding = 20.0;
final String ServiceListItemCreateTime = 'ServiceListItemCreateTime';
const tabBarName = "announcement";

class ChatSessionListPage extends StatefulWidget {
  ChatSessionListPage();

  @override
  State<StatefulWidget> createState() => new _ChatSessionListPageState();
}

class _ChatSessionListPageState extends BasePageState<ChatSessionListPage>
    with AutomaticKeepAliveClientMixin, CommonStateViewMixin, OXUserInfoObserver, WidgetsBindingObserver, OXChatObserver, OXRelayObserver {
  _ChatSessionListPageState();

  RefreshController _refreshController = new RefreshController();
  int pageNum = 1; // Page number
  List<ChatSessionModel> msgDatas = []; // Message List
  List<CommunityMenuOptionModel> _menuOptionModelList = [];
  Map<String, BadgeDB> _badgeCache = {};
  Map<String, bool> _muteCache = {};

  GlobalKey? _latestGlobalKey;

  final throttle = ThrottleUtils(delay: Duration(milliseconds: 3000));

  @override
  void initState() {
    super.initState();
    _menuOptionModelList = CommunityMenuOptionModel.getOptionModelList();
    OXChatBinding.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    WidgetsBinding.instance.addObserver(this);
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXRelayManager.sharedInstance.addObserver(this);
    Localized.addLocaleChangedCallback(onLocaleChange); //fetchNewestNotice
    _merge();
  }

  _navigateToLoginPage(BuildContext context) async {
    await OXModuleService.pushPage(
      context,
      "ox_login",
      "LoginPage",
      {},
    );
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
    OXRelayManager.sharedInstance.removeObserver(this);
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
    }
  }

  @override
  void didLoginSuccess(UserDB? userInfo) {
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
  void didSwitchUser(UserDB? userInfo) {
    if (this.mounted) {
      setState(() {
        msgDatas.clear();
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

  void didPromptToneCallBack (MessageDB message, int type) async {
    if(PromptToneManager.sharedInstance.isCurrencyChatPage != null && PromptToneManager.sharedInstance.isCurrencyChatPage!(message)) return;
    bool isMute = await _checkIsMute(message,type);
    if(!isMute) throttle(() {PromptToneManager.sharedInstance.play();});
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
            SizedBox(
              height: Adapt.px(24),
              child: GestureDetector(
                onTap: () {
                  OXModuleService.invoke('ox_usercenter', 'showRelayPage', [context]);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CommonImage(
                      iconName: 'icon_relay_connected_amount.png',
                      width: Adapt.px(24),
                      height: Adapt.px(24),
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: Adapt.px(4),
                    ),
                    Text(
                      '${OXRelayManager.sharedInstance.connectedCount}/${OXRelayManager.sharedInstance.relayAddressList.length}',
                      style: TextStyle(
                        fontSize: Adapt.px(14),
                        color: ThemeColor.color100,
                      ),
                    ),
                  ],
                ),
              ),
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
          child: commonStateViewWidget(
            context,
            _listView(),
          ),
        ),
      ),
    );
  }

  Widget _menueWidget() {
    return Container(
      height: Adapt.px(105),
      color: ThemeColor.color200,
      padding: EdgeInsets.symmetric(vertical: Adapt.px(10)),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
        scrollDirection: Axis.horizontal,
        itemCount: _menuOptionModelList.length,
        itemBuilder: (context, index) {
          return _getTopWidget(index);
        },
      ),
    );
  }

  Widget _getTopWidget(int index) {
    CommunityMenuOptionModel model = _menuOptionModelList[index];
    return Container(
      margin: EdgeInsets.only(right: Adapt.px(25)),
      child: InkWell(
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: Adapt.px(60), height: Adapt.px(60), child: CommonImage(iconName:model.iconName,useTheme:true),),
            SizedBox(
              height: Adapt.px(4),
            ),
            Text(
              model.content,
              style: TextStyle(fontSize: Adapt.sp(12), color: ThemeColor.color40, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        onTap: () {
          _optionsOnTap(model.optionModel);
        },
      ),
    );
  }

  Widget _listView() {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: Adapt.px(120)),
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: itemCount(),
      itemBuilder: _buildListViewItem,
    );
  }

  int itemCount() {
    return msgDatas.length + 2;
  }

  void _onRefresh() async {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (isLogin == false) {
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
    msgDatas.clear();
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (!isLogin) {
      if (this.mounted) {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_NotLogin);
        });
      }
      return;
    }
    msgDatas = OXChatBinding.sharedInstance.sessionList;

    msgDatas.sort((session1, session2) {
      var session2CreatedTime = session2.createTime;
      var session1CreatedTime = session1.createTime;
      return session2CreatedTime.compareTo(session1CreatedTime);
    });
    if (this.mounted) {
      setState(() {});
    }
    if (msgDatas.length > 0) {
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
  void didAddRelay(RelayModel? relayModel) {
    setState(() {});
  }

  @override
  void didDeleteRelay(RelayModel? relayModel) {
    setState(() {});
  }

  @override
  void didRelayStatusChange(String relay, int status) {
    setState(() {});
  }

  @override
  void didUpdateUserInfo() {}

  @override
  void didSessionUpdate() {
    _merge();
  }

  void _updateReadStatus() {
    int readCount = 0;
    for (ChatSessionModel i in msgDatas) {
      if (i.unreadCount > 0) {
        readCount += i.unreadCount;
      }
    }
    if(mounted){
      MsgNotification(msgNum: readCount).dispatch(context);
    }
  }

  Widget _buildListViewItem(context, int index) {
    if (index == 0) {
      return _topSearch();
    } else if (index == 1) {
      return _menueWidget();
    } else {
      ChatSessionModel item = msgDatas[index - 2];
      GlobalKey tempKey = GlobalKey(debugLabel: index.toString());
      // ChatLogUtils.info(
      //     className: 'ChatSessionListPage',
      //     funcName: '_buildListViewItem',
      //     message: 'chatID: ${announceItem.chatId}, chatName: ${announceItem.chatName}, createTime: ${announceItem.createTime}');
      return GestureDetector(
        onHorizontalDragDown: (details) {
          _dismissSlidable();
          _latestGlobalKey = tempKey;
        },
        child: Container(
          color: ThemeColor.color200,
          child: Column(
            children: <Widget>[
              Slidable(
                key: ValueKey("$index"),
                endActionPane: ActionPane(
                  extentRatio: 0.23,
                  motion: const ScrollMotion(),
                  children: [
                    CustomSlidableAction(
                      onPressed: (BuildContext _) async {
                        OXCommonHintDialog.show(context,
                            content: item.chatType == ChatType.chatSecret
                                ? Localized.text('ox_chat.secret_message_delete_tips')
                                : Localized.text('ox_chat.message_delete_tips'),
                            actionList: [
                              OXCommonHintAction.cancel(onTap: () {
                                OXNavigator.pop(context);
                              }),
                              OXCommonHintAction.sure(
                                  text: Localized.text('ox_common.confirm'),
                                  onTap: () async {
                                    OXNavigator.pop(context);
                                    final int count = await OXChatBinding.sharedInstance.deleteSession(item.chatId);
                                    if (item.chatType == ChatType.chatSecret) {
                                      Contacts.sharedInstance.close(item.chatId!);
                                    } else if (item.chatType == ChatType.chatSingle) {
                                      Messages.deleteMessagesFromDB(
                                        where: '(sessionId IS NULL OR sessionId = "") AND ((sender = ? AND receiver = ? ) OR (sender = ? AND receiver = ? )) ',
                                        whereArgs: [item.sender, item.receiver, item.receiver, item.sender],
                                      );
                                    } else if (item.chatType == ChatType.chatChannel) {
                                      Messages.deleteMessagesFromDB(
                                        where: ' groupId = ? ',
                                        whereArgs: [item.groupId],
                                      );
                                    }
                                    if (count > 0) {
                                      setState(() {
                                        _merge();
                                      });
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
                            style: TextStyle(color: Colors.white, fontSize: Adapt.px(12)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                child: Stack(
                  key: tempKey,
                  // key: _slidableGlobalKey,
                  children: [
                    _buildBusinessInfo(item),
                    item.alwaysTop
                        ? Container(
                      alignment: Alignment.topRight,
                      child: assetIcon('icon_red_always_top.png', 12, 12),
                    )
                        : Container(),
                  ],
                ),
              ),
              // _buildSeparetor(index),
            ],
          ),
        ),
      );
    }
  }

  @override
  renderNoDataView(BuildContext context, {String? errorTip}) {
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
              text: 'No chats yet?\nTry add a friend or join a channel.',
              highlightWords: ['add a friend', 'join a channel'],
              onWordTap: (word) async {
                switch (word) {
                  case 'add a friend':
                    _gotoAddFriend();
                    break;
                  case 'join a channel':
                    OXNavigator.pushPage(
                        context,
                            (context) =>
                            SearchPage(
                              searchPageType: SearchPageType.discover,
                            ));
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMsgIcon(ChatSessionModel item) {
    if (item.chatType == '1000') {
      return assetIcon('icon_notice_avatar.png', 60, 60);
    } else {
      String showPicUrl = '';
      switch(item.chatType){
        case ChatType.chatChannel:
          showPicUrl = Channels.sharedInstance.channels[item.chatId]?.picture ?? '';
          break;
        case ChatType.chatSingle:
          showPicUrl = Account.sharedInstance.userCache[item.getOtherPubkey]?.picture ?? '';
          break;
        case ChatType.chatGroup:
          showPicUrl = Groups.sharedInstance.groups[item.chatId]?.picture ?? '';
          break;
      }
      String localAvatarPath = item.chatType == ChatType.chatChannel ? 'icon_group_default.png' : 'user_image.png';
      return Container(
        width: Adapt.px(60),
        height: Adapt.px(60),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(60)),
              child: BaseAvatarWidget(
                imageUrl: '${showPicUrl}',
                defaultImageName: localAvatarPath,
                size: Adapt.px(60),
              ),
            ),
            (item.chatType == ChatType.chatSingle)
                ? Positioned(
              bottom: 0,
              right: 0,
              child: FutureBuilder<BadgeDB?>(
                initialData: _badgeCache[item.chatId],
                builder: (context, snapshot) {
                  return (snapshot.data != null && snapshot.data!.thumb != null)
                      ? CachedNetworkImage(
                    imageUrl: snapshot.data!.thumb!,
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                    fit: BoxFit.cover,
                  )
                      : Container();
                },
                future: _getUserSelectedBadgeInfo(item),
              ),
            )
                : Container(),
          ],
        ),
      );
    }
  }

  Widget _buildItemName(ChatSessionModel item) {
    String showName = '';
    switch(item.chatType){
      case ChatType.chatChannel:
        showName = Channels.sharedInstance.channels[item.chatId]?.name ?? '';
        break;
      case ChatType.chatSingle:
        showName = Account.sharedInstance.userCache[item.getOtherPubkey]?.name ?? '';
        break;
      case ChatType.chatGroup:
        showName = Groups.sharedInstance.groups[item.chatId]?.name ?? '';
        break;
    }
    return Container(
      margin: EdgeInsets.only(right: Adapt.px(4)),
      child: item.chatType == ChatType.chatSecret
          ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonImage(
            iconName: 'icon_lock_secret.png',
            width: Adapt.px(16),
            height: Adapt.px(16),
            package: 'ox_chat',
          ),
          SizedBox(
            width: Adapt.px(4),
          ),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [
                  ThemeColor.gradientMainEnd,
                  ThemeColor.gradientMainStart,
                ],
              ).createShader(Offset.zero & bounds.size);
            },
            child: Text(
              showName,
              style: TextStyle(
                fontSize: Adapt.px(16),
                color: ThemeColor.color0,
                letterSpacing: Adapt.px(0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      )
          : Text(showName, textAlign: TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis, style: _Style.newsTitle()),
      constraints: BoxConstraints(maxWidth: Adapt.screenW() - Adapt.px(48 + 60 + 36 + 50)),
      // width: Adapt.px(135),
    );
  }

  Widget _buildBusinessInfo(ChatSessionModel item) {
    return MaterialButton(
        padding: EdgeInsets.only(top: Adapt.px(12), left: Adapt.px(16), bottom: Adapt.px(12), right: Adapt.px(16)),
        minWidth: 30.0,
        elevation: 0.0,
        highlightElevation: 0.0,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  _getMsgIcon(item),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              _buildItemName(item),
                              FutureBuilder<bool>(
                                initialData: _muteCache[item.chatId],
                                builder: (context, snapshot) {
                                  return (snapshot.data ?? false)
                                      ? CommonImage(
                                    iconName: 'icon_session_mute.png',
                                    width: Adapt.px(16),
                                    height: Adapt.px(16),
                                    package: 'ox_chat',
                                  )
                                      : Container();
                                },
                                future: _getChatSessionMute(item),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: Adapt.px(5)),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: Adapt.screenW() - Adapt.px(48 + 60 + 36 + 30)),
                              child: _buildItemSubtitle(item),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FutureBuilder<bool>(
                  initialData: _muteCache[item.chatId],
                  builder: (context, snapshot) {
                    return _buildReadWidget(item, snapshot.data ?? false);
                  },
                  future: _getChatSessionMute(item),
                ),
                SizedBox(
                  height: Adapt.px(18),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Text(item.createTime ==null ? '': OXDateUtils.convertTimeFormatString2(item.createTime! * 1000, pattern: 'MM-dd'),
                      textAlign: TextAlign.left, maxLines: 1, style: _Style.newsContentSub()),
                ),
              ],
            ),
          ],
        ),
        onPressed: () async {
          _setAllRead(item);
          if (item.chatType == 9999) {
            _routeCustomService();
          } else if (item.chatType == ChatType.chatGroup) {
            OXNavigator.pushPage(
                context,
                    (context) =>
                    ChatGroupMessagePage(
                      communityItem: item,
                    ));
          } else if (item.chatType == ChatType.chatChannel) {
            OXNavigator.pushPage(
                context,
                    (context) =>
                    ChatChannelMessagePage(
                      communityItem: item,
                    ));
          } else if (item.chatType == ChatType.chatSecret) {
            OXNavigator.pushPage(
                context,
                    (context) =>
                    ChatSecretMessagePage(
                      communityItem: item,
                    ));
          } else {
            OXNavigator.pushPage(
                context,
                    (context) =>
                    ChatMessagePage(
                      communityItem: item,
                    )).then((value) {
              _merge();
            });
          }
        });
  }

  Widget _buildItemSubtitle(ChatSessionModel announceItem) {

    final isMentioned = announceItem.isMentioned;
    if (isMentioned) {
      return RichText(
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: '[${Localized.text('ox_chat.session_content_mentioned')}]',
              style: _Style.hintContentSub(),
            ),
            TextSpan(
              text: announceItem.content ?? '',
              style: _Style.newsContentSub(),
            ),
          ],
        ),
      );
    }

    final draft = announceItem.draft ?? '';
    if (draft.isNotEmpty) {
      return Text(
        '[${Localized.text('ox_chat.session_content_draft')}]$draft',
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _Style.hintContentSub(),
      );
    }
    return Text(
      announceItem.content ?? '',
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: _Style.newsContentSub(),
    );
  }

  String getLastMessageStr(MessageDB? messageDB) {
    if (messageDB == null) {
      return '';
    }
    final decryptedContent = json.decode(messageDB.decryptContent ?? '{}');
    MessageContentModel contentModel = MessageContentModel.fromJson(decryptedContent);
    if (contentModel.contentType == null) {
      return '';
    }
    if (messageDB.type == MessageType.text) {
      return contentModel.content ?? '';
    } else {
      return '[${contentModel.contentType
          .toString()
          .split('.')
          .last}]';
    }
  }

  void _setAllRead(ChatSessionModel item) {
    setState(() {
      item.unreadCount = 0;
      _updateReadStatus();
    });
    OXChatBinding.sharedInstance.updateChatSession(item.chatId ?? '', unreadCount: 0);
  }

  void _routeCustomService() async {
    CommonToast.instance.show(context, Localized.text('ox_chat.services'));
  }

  Future<bool> _getChatSessionMute(ChatSessionModel item) async {
    bool isMute = false;
    if (item.chatType == ChatType.chatSingle) {
      UserDB? tempUserDB = Account.sharedInstance.userCache[item.chatId!];
      if (tempUserDB != null) {
        isMute = tempUserDB.mute ?? false;
      }
    } else if (item.chatType == ChatType.chatChannel) {
      ChannelDB? channelDB = Channels.sharedInstance.channels[item.chatId!];
      if (channelDB != null) {
        isMute = channelDB.mute ?? false;
      }
    }
    if (isMute != _muteCache[item.chatId!]){
      _muteCache[item.chatId!] = isMute;
    }
    return isMute;
  }

  Widget _buildReadWidget(ChatSessionModel announceItem, bool isMute) {
    int read = announceItem.unreadCount;
    if (isMute) {
      if (read > 0) {
        return ClipOval(
          child: Container(
            alignment: Alignment.center,
            color: ThemeColor.color110,
            width: Adapt.px(12),
            height: Adapt.px(12),
          ),
        );
      } else {
        return SizedBox();
      }
    }
    if (read > 0 && read < 10) {
      return ClipOval(
        child: Container(
          alignment: Alignment.center,
          color: ThemeColor.red1,
          width: Adapt.px(17),
          height: Adapt.px(17),
          child: Text(
            read.toString(),
            style: _Style.read(),
          ),
        ),
      );
    } else if (read >= 10 && read < 100) {
      return Container(
        alignment: Alignment.center,
        width: Adapt.px(22),
        height: Adapt.px(20),
        decoration: BoxDecoration(
          color: ThemeColor.red1,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(13.5))),
        ),
        padding: EdgeInsets.symmetric(vertical: Adapt.px(3), horizontal: Adapt.px(3)),
        child: Text(
          read.toString(),
          style: _Style.read(),
        ),
      );
    } else if (read >= 100) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ThemeColor.red1,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(13.5))),
        ),
        padding: EdgeInsets.symmetric(vertical: Adapt.px(3), horizontal: Adapt.px(3)),
        child: Text(
          '99+',
          style: _Style.read(),
        ),
      );
    }
    return Container();
  }

  void _gotoAddFriend() {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (!isLogin) {
      _navigateToLoginPage(context);
      return;
    }
    OXNavigator.pushPage(context, (context) => CommunityQrcodeAddFriend());
  }

  void _gotoCreateGroup() {
    final height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    List<UserDB> userList = Contacts.sharedInstance.allContacts.values.toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        height: height,
        child: ContactGroupChatChoosePage(
          userList: userList,
          groupListAction: GroupListAction.select,
          searchBarHintText: Localized.text('ox_chat.create_group_search_hint_text'),
        ),
      ),
    );
  }

  Widget _topSearch() {
    return InkWell(
      onTap: () {
        SearchPage().show(context);
      },
      highlightColor: Colors.transparent,
      radius: 0.0,
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
    );
  }

  Future<BadgeDB?> _getUserSelectedBadgeInfo(ChatSessionModel announceListItem) async {
    final chatId = announceListItem.chatId ?? '';
    UserDB? friendUserDB = await Account.sharedInstance.getUserInfo(chatId);
    if (friendUserDB == null) {
      return null;
    }
    String badges = friendUserDB.badges ?? '';
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
        _badgeCache[chatId] = badgeDB;
      }
      return badgeDB;
    }
    return null;
  }

  void _dismissSlidable() {
    if (_latestGlobalKey != null && _latestGlobalKey!.currentContext != null) {
      Slidable.of(_latestGlobalKey!.currentContext!)!.close();
    }
  }

  void _optionsOnTap(OptionModel optionModel) async {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (isLogin == false) {
      await _navigateToLoginPage(context);
      return;
    }
    if (optionModel == OptionModel.AddFriend) {
      _gotoAddFriend();
    } else if (optionModel == OptionModel.NewChannel) {
      OXNavigator.pushPage(context, (context) => ChatChannelCreate());
    } else if (optionModel == OptionModel.ScanQCode) {
      _gotoScan();
    } else if (optionModel == OptionModel.RecommenderTools) {
      CommonToast.instance.show(context, 'str_stay_tuned'.localized());
    } else if (optionModel == OptionModel.AddGroup) {
      _gotoCreateGroup();
    }
  }

  void _gotoScan() async {
    if (await Permission.camera
        .request()
        .isGranted) {
      String? result = await OXNavigator.pushPage(context, (context) => CommonScanPage());
      if (result != null) {
        ScanUtils.analysis(context, result);
      }
    } else {
      OXCommonHintDialog.show(context, content: Localized.text('ox_chat.str_permission_camera_hint'), actionList: [
        OXCommonHintAction(
            text: () => Localized.text('ox_chat.str_go_to_settings'),
            onTap: () {
              openAppSettings();
              OXNavigator.pop(context);
            }),
      ]);
    }
  }

  Future<bool> _checkIsMute(MessageDB message,int type) async {
    bool isMute = false;
    if(type == ChatType.chatChannel){
      ChannelDB? channelDB = Channels.sharedInstance.channels[message.groupId!];
      isMute = channelDB?.mute ?? false;
      return isMute;
    }
    UserDB? tempUserDB = await Account.sharedInstance.getUserInfo(message.sender!);
    isMute = tempUserDB?.mute ?? false;
    return isMute;
  }

}

class _Style {

  static TextStyle newsTitle() {
    return new TextStyle(
      fontSize: Adapt.px(16),
      fontWeight: FontWeight.w600,
      color: ThemeColor.color10,
    );
  }

  static TextStyle newsContentSub() {
    return new TextStyle(
      fontSize: Adapt.px(14),
      fontWeight: FontWeight.w400,
      color: ThemeColor.color120,
    );
  }

  static TextStyle hintContentSub() {
    return new TextStyle(
      fontSize: Adapt.px(14),
      fontWeight: FontWeight.w400,
      color: ThemeColor.red,
    );
  }

  static TextStyle read() {
    return new TextStyle(
      fontSize: Adapt.px(12),
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
  }
}
