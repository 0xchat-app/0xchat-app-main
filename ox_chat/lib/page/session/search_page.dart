
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/model/recent_search_user_isar.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/model/search_history_model.dart';
import 'package:ox_chat/model/search_history_model_isar.dart';
import 'package:ox_chat/page/session/chat_channel_message_page.dart';
import 'package:ox_chat/page/session/chat_group_message_page.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/page/session/chat_relay_group_msg_page.dart';
import 'package:ox_chat/page/session/chat_secret_message_page.dart';
import 'package:ox_chat/page/session/search_discover_ui.dart';
import 'package:ox_chat/utils/search_txt_util.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/fade_page_route.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:isar/isar.dart';

import 'package:ox_chat/page/contacts/contact_user_info_page.dart';

///Title: search_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/23 17:35

class SearchPage extends StatefulWidget {
  final String? searchText;
  final SearchPageType searchPageType;
  final ChatMessage? chatMessage;
  final Group? defaultGroup;
  final bool forceFirstPage;

  SearchPage({
    this.searchText,
    this.searchPageType = SearchPageType.all,
    this.chatMessage,
    this.defaultGroup,
    this.forceFirstPage = false,
  });

  @override
  State<SearchPage> createState() => SearchPageState();

  show(BuildContext context) async {
    OXNavigator.push(context, FadePageRoute(page: this));
  }
}

enum SearchPageType {
  all,
  friendSeeMore,
  groupSeeMore,
  channelSeeMore,
  messagesSeeMore,
  singleSessionRelated,
  discover,
  singleFriend,
  singleChannel,
}

class SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  List<Group> dataGroups = [];
  List<UserDBISAR> _selectedHistoryList = [];
  List<SearchHistoryModel> _txtHistoryList = [];
  bool isSubpage = false;
  TextEditingController editingController = TextEditingController();
  int lastRequestId = 0;

  final maxItemsCount = 3;
  Map<String, List<String>> _groupMembersCache = {};

  @override
  void initState() {
    super.initState();
    searchQuery = widget.searchText ?? '';
    _prepareData(false);
  }

  void _prepareData(bool isInput) {
    dataGroups.clear();

    if (!OXUserInfoManager.sharedInstance.isLogin) return;

    final searchPageType = widget.searchPageType;

    switch (searchPageType) {
      case SearchPageType.friendSeeMore:
      case SearchPageType.channelSeeMore:
      case SearchPageType.groupSeeMore:
      case SearchPageType.messagesSeeMore:
      case SearchPageType.singleSessionRelated:
        isSubpage = true;
        break;
      default:
        isSubpage = false;
        break;
    }

    switch (searchPageType) {
      case SearchPageType.all:
        _loadAllData(isInput);
        break;
      case SearchPageType.singleFriend:
        _loadFriendsData();
        break;
      case SearchPageType.singleChannel:
        _loadChannelsData();
        break;
      case SearchPageType.singleSessionRelated:
        _loadMessagesData(chatId: widget.chatMessage?.chatId ?? null);
        break;
      case SearchPageType.discover:
        loadOnlineChannelsDataAndClear();
        break;
      case SearchPageType.friendSeeMore:
      case SearchPageType.channelSeeMore:
      case SearchPageType.messagesSeeMore:
        final defaultGroup = widget.defaultGroup;
        if (defaultGroup != null) {
          dataGroups = []..add(defaultGroup);
        }
        break;
      default:
        break;
    }
  }

  void _loadAllData(bool isInput) async {
    if (searchQuery.trim().isNotEmpty) {
      _loadFriendsData();
      _loadChannelsData();
      _loadGroupsData();
      _loadMessagesData();
      loadOnlineChannelsData();
      _loadUsersData();
    } else {
      _loadHistory();
    }
    // if (isInput && searchQuery.trim().isNotEmpty) {
    //   _updateSearchHistory(null);
    // }
  }

  void _loadHistory() async {
    _selectedHistoryList.clear();
    _txtHistoryList.clear();
    // _txtHistoryList = await DB.sharedInstance.objects<SearchHistoryModel>();
    final isar = DBISAR.sharedInstance.isar;
    final userList = await isar.recentSearchUserISARs.where().findAll();
    await Future.forEach(userList, (e) async {
      final user = await Account.sharedInstance.getUserInfo(e.pubKey);
      if (user != null) {
        _selectedHistoryList.add(user);
      }
    });

    if (mounted) {
      setState(() {});
    }
  }


  void _loadGroupsData() async {
    List<GroupUIModel>? tempGroupList = SearchTxtUtil.loadChatGroupWithSymbol(searchQuery);
    if (tempGroupList != null && tempGroupList.length > 0) {
      dataGroups.add(
        Group(
            title: 'str_title_groups'.localized(),
            type: SearchItemType.groups,
            items: tempGroupList),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _loadChannelsData() async {
    List<ChannelDBISAR>? tempChannelList = SearchTxtUtil.loadChatChannelsWithSymbol(searchQuery);
    if (tempChannelList != null && tempChannelList.length > 0) {
      dataGroups.add(
        Group(
            title: 'str_title_channels'.localized(),
            type: SearchItemType.channel,
            items: tempChannelList),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _loadFriendsData() async {
    List<UserDBISAR>? tempFriendList = SearchTxtUtil.loadChatFriendsWithSymbol(searchQuery);
    if (tempFriendList != null && tempFriendList.length > 0) {
      dataGroups.add(
        Group(
            title: 'str_title_contacts'.localized(),
            type: SearchItemType.friend,
            items: tempFriendList),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _loadUsersData() async {
    if (searchQuery.startsWith('npub')) {
      String? pubkey = UserDBISAR.decodePubkey(searchQuery);
      if (pubkey != null) {
        UserDBISAR? user = await Account.sharedInstance.getUserInfo(pubkey);
        dataGroups.add(
          Group(
              title: 'str_title_top_hins_contacts'.localized(),
              type: SearchItemType.friend,
              items: List<UserDBISAR>.from([user])),
        );
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _loadMessagesData({String? chatId}) async {
    List<ChatMessage> chatMessageList = await SearchTxtUtil.loadChatMessagesWithSymbol(searchQuery, chatId: chatId);
    if (chatMessageList.isNotEmpty) {
      final type = chatId == null
          ? SearchItemType.messagesGroup
          : SearchItemType.message;
      dataGroups.add(
        Group(title: 'str_chat_historys'.localized(), type: type, items: chatMessageList),
      );
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchPageType == SearchPageType.discover
        ? discoverPage()
        : normalPage();
  }

  Widget normalPage() {
    final backgroundColor = ThemeColor.color200;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: isSubpage
          ? CommonAppBar(
              useLargeTitle: false,
              centerTitle: true,
              title: _showTitle(),
              backgroundColor: backgroundColor,
            )
          : null,
      body: Column(
        children: [
          isSubpage && !widget.forceFirstPage ? SizedBox() : _topSearchView(),
          Expanded(
            child: _contentView()
                .setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24))),
          ),
        ],
      ),
    );
  }

  String _showTitle() {
    if (widget.searchPageType == SearchPageType.friendSeeMore ||
        widget.searchPageType == SearchPageType.channelSeeMore ||
        widget.searchPageType == SearchPageType.messagesSeeMore) {
      return '\"${widget.searchText ?? ''}\"';
    } else if (widget.searchPageType == SearchPageType.singleSessionRelated) {
      return widget.chatMessage!.name;
    }
    return '';
  }

  Widget _contentView() {
    if (searchQuery.isEmpty)
      return _buildEmptySearchView();
    else {
      return GroupedListView<Group, dynamic>(
        elements: dataGroups,
        groupBy: (element) => element.title,
        padding: EdgeInsets.zero,
        groupHeaderBuilder: (element) {
          final hasMoreItems = element.items.length > maxItemsCount;
          return isSubpage && !widget.forceFirstPage
              ? Container()
              : Container(
                  width: double.infinity,
                  height: Adapt.px(28),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          element.title,
                          style: TextStyle(
                              fontSize: Adapt.px(14),
                              color: ThemeColor.color100,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      !hasMoreItems
                          ? Container()
                          : GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _gotoSeeMorePage(element.type, element);
                              },
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: [
                                      ThemeColor.gradientMainEnd,
                                      ThemeColor.gradientMainStart,
                                    ],
                                  ).createShader(Offset.zero & bounds.size);
                                },
                                child: Text(
                                  Localized.text('ox_chat.search_see_more'),
                                  style: TextStyle(
                                    fontSize: Adapt.px(15),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                );
        },
        itemBuilder: (context, element) {
          final items = showingItems(element.items);
          if (element.type == SearchItemType.friend && items is List<UserDBISAR>) {
            return Column(
              children: items.map((item) {
                return _buildResultItemView(
                  isUser: true,
                  avatarURL: item.picture,
                  title: item.name,
                  subTitle: item.about ?? '',
                  onTap: () => _gotoFriendSession(item),
                );
              }).toList(),
            );
          } else if (element.type == SearchItemType.groups && items is List<GroupUIModel>) {
            return Column(
              children: items.map((item) {
                return _buildResultItemView(
                  isUser: true,
                  avatarURL: item.picture,
                  title: item.name,
                  subTitle: item.about ?? '',
                  onTap: () => gotoChatGroupSession(item),
                );
              }).toList(),
            );
          } else if (element.type == SearchItemType.channel && items is List<ChannelDBISAR>) {
            return Column(
              children: items.map((item) {
                return _buildResultItemView(
                  isUser: false,
                  avatarURL: item.picture,
                  title: item.name,
                  subTitle: item.about ?? '',
                  onTap: () => gotoChatChannelSession(item),
                );
              }).toList(),
            );
          } else if ((element.type == SearchItemType.messagesGroup || element.type == SearchItemType.message) && items is List<ChatMessage>) {
            return Column(
              children: items.map((item) {
                return _buildResultItemView(
                    isUser: false,
                    avatarURL: item.picture,
                    title: item.name,
                    subTitle: item.subtitle,
                    onTap: () {
                      SearchItemType tempType = item.relatedCount > 1 ? SearchItemType.messagesGroup : SearchItemType.message;
                      switch (tempType) {
                        case SearchItemType.messagesGroup:
                          _gotoSingleRelatedPage(item);
                          break;
                        case SearchItemType.message:
                          _gotoChatMessagePage(item);
                          break;
                        default:
                          break;
                      }
                    });
              }).toList(),
            );
          }
          return SizedBox.shrink();
        },
        itemComparator: (item1, item2) => item1.title.compareTo(item2.title),
        useStickyGroupSeparators: false,
        floatingHeader: false,
      );
    }
  }

  Widget _buildResultItemView({
    required bool isUser,
    String? avatarURL,
    String? title,
    String? subTitle,
    VoidCallback? onTap,
  }) {
    final avatarWidget = isUser
        ? OXUserAvatar(imageUrl: avatarURL)
        : OXChannelAvatar(imageUrl: avatarURL);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        height: Adapt.px(72),
        child: Row(
          children: [
            avatarWidget.setPadding(
                EdgeInsets.only(left: Adapt.px(0), right: Adapt.px(16))),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '',
                  ).setPadding(EdgeInsets.only(bottom: Adapt.px(2))),
                  subTitle == null || subTitle.isEmpty ? SizedBox() : highlightText(subTitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchView() {
    final hasHistory =
        _selectedHistoryList.length > 0 || _txtHistoryList.length > 0;
    if (!hasHistory) {
      String hintStr = Localized.text('ox_chat.search_tips_prefix') +
          '${widget.searchPageType == SearchPageType.all ? Localized.text('ox_chat.search_tips_suffix_all') : ''}' +
          '${widget.searchPageType != SearchPageType.all && widget.searchPageType == SearchPageType.singleFriend ? Localized.text('ox_chat.search_tips_suffix_friend') : ''}' +
          '${widget.searchPageType != SearchPageType.all && widget.searchPageType == SearchPageType.singleChannel ? Localized.text('ox_chat.search_tips_suffix_channel') : ''}';
      return Container(
        width: double.infinity,
        height: Adapt.px(22),
        alignment: Alignment.topCenter,
        child: Text(
          hintStr,
          style: TextStyle(
            fontSize: Adapt.px(15),
            color: ThemeColor.color110,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return _buildHistoryView();
  }

  Widget _buildHistoryView() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: Adapt.px(28),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Localized.text('ox_chat.recent_searches'),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Adapt.px(14),
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: CommonImage(
                  iconName: 'icon_clearbutton.png',
                  fit: BoxFit.fill,
                  width: Adapt.px(20),
                  height: Adapt.px(20),
                ),
                onTap: () {
                  _clearRecentSearches();
                },
              ),
            ],
          ),
        ),
        _buildHistoryUserView(),
        Expanded(
          child: _buildHistoryTextView(),
        ),
      ],
    );
  }

  Widget _buildHistoryUserView() {
    List<UserDBISAR?> userList = []..addAll(_selectedHistoryList);
    if (userList.length < 1) return SizedBox();

    if (userList.length > 4) {
      userList = userList.sublist(0, 4);
    }

    for (var i = userList.length; i < 4; i++) {
      userList.add(null);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: userList
          .map((user) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                   OXNavigator.pushPage(context, (context) => ContactUserInfoPage(pubkey: user!.pubKey));
                },
                child: Container(
                  width: Adapt.px(60),
                  height: Adapt.px(81),
                  child: user == null
                      ? null
                      : Column(
                          children: [
                            OXUserAvatar(
                              user: user,
                              size: Adapt.px(60),
                            ).setPadding(EdgeInsets.only(bottom: Adapt.px(4))),
                            Expanded(
                              child: Text(
                                user.getUserShowName(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Adapt.px(14),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ))
          .toList(),
    ).setPadding(EdgeInsets.symmetric(vertical: Adapt.px(12)));
  }

  Widget _buildHistoryTextView() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemCount: _txtHistoryList.length,
      itemBuilder: (context, index) {
        SearchHistoryModel itemModel = _txtHistoryList[index];
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            editingController.text = itemModel.searchTxt ?? '';
            _onTextChanged(itemModel.searchTxt ?? '');
          },
          child: Container(
            height: Adapt.px(40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  itemModel.searchTxt ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Adapt.px(14),
                    color: Colors.white,
                  ),
                ),
                CommonImage(
                  iconName: 'icon_search_arrow.png',
                  fit: BoxFit.fill,
                  width: Adapt.px(16),
                  height: Adapt.px(16),
                  package: 'ox_chat',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget highlightText(String mainText, {int? maxLines = 1}) {
    final searchText = searchQuery;
    final normalTextStyle = TextStyle(
      fontSize: Adapt.px(14),
      fontWeight: FontWeight.w400,
      color: ThemeColor.color120,
    );
    final highlightTextStyle = normalTextStyle.copyWith(
      color: ThemeColor.color10,
    );

    final mainTextLower = mainText.toLowerCase();
    final searchTextLower = searchText.toLowerCase();
    final splitText = mainTextLower.split(searchTextLower);

    var startIndex = 0;
    List<InlineSpan> spans = [];
    for (int i = 0; i < splitText.length; i++) {
      int endIndexOfToken = startIndex + splitText[i].length;

      spans.add(TextSpan(
        text: mainText.substring(startIndex, endIndexOfToken),
        style: normalTextStyle,
      ));

      if (i < splitText.length - 1) {
        spans.add(TextSpan(
          text: mainText.substring(
              endIndexOfToken, endIndexOfToken + searchText.length),
          style: highlightTextStyle,
        ));
      }
      startIndex = endIndexOfToken + searchText.length;
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
    );
  }

  List showingItems(List items) {
    final searchPageType = widget.searchPageType;
    if (searchPageType == SearchPageType.friendSeeMore ||
        searchPageType == SearchPageType.channelSeeMore ||
        searchPageType == SearchPageType.messagesSeeMore) {
      return items;
    }

    if (items.length > maxItemsCount) {
      items = items.sublist(0, maxItemsCount);
    }
    return items;
  }

  void _onTextChanged(value) {
    searchQuery = value;
    _prepareData(true);
  }

  Widget _topSearchView() {
    return Container(
      margin: EdgeInsets.only(
        top: widget.forceFirstPage ? 0 : MediaQuery.of(context).padding.top,
      ),
      height: Adapt.px(80),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: Adapt.px(24)),
              decoration: BoxDecoration(
                color: ThemeColor.color190,
                borderRadius: BorderRadius.circular(Adapt.px(16)),
              ),
              child: TextField(
                controller: editingController,
                onChanged: _onTextChanged,
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: Adapt.px(16)),
                    child: CommonImage(
                      iconName: 'icon_search.png',
                      width: Adapt.px(24),
                      height: Adapt.px(24),
                      fit: BoxFit.fill,
                    ),
                  ),
                  hintText: Localized.text('ox_chat.search'),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: Adapt.px(90),
              alignment: Alignment.center,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      ThemeColor.gradientMainEnd,
                      ThemeColor.gradientMainStart,
                    ],
                  ).createShader(Offset.zero & bounds.size);
                },
                child: Text(
                  Localized.text('ox_common.cancel'),
                  style: TextStyle(
                    fontSize: Adapt.px(15),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onTap: () {
              OXNavigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateSearchHistory(UserDBISAR? userDB) async {
    final userPubkey = userDB?.pubKey;
    if (userPubkey != null) {
      await DBISAR.sharedInstance.isar.writeTxn(() async {
        await DBISAR.sharedInstance.isar.recentSearchUserISARs
            .put(RecentSearchUserISAR(pubKey: userPubkey));
      });
    } else {
      await DBISAR.sharedInstance.isar.writeTxn(() async {
        await DBISAR.sharedInstance.isar.searchHistoryModelISARs
            .put(SearchHistoryModelISAR(
                  searchTxt: searchQuery,
                  pubKey: userDB?.pubKey ?? null,
                  name: userDB?.name ?? null,
                  picture: userDB?.picture ?? null,
            ));
      });
      LogUtil.e('Michael: _updateSearchHistory count =');
    }
  }

  Image placeholderImage(bool isUser, double wh) {
    String localAvatarPath = isUser
        ? 'assets/images/user_image.png'
        : 'assets/images/icon_group_default.png';
    return Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(wh),
      height: Adapt.px(wh),
      package: 'ox_common',
    );
  }

  void _getGroupMembers(List<ChatSessionModelISAR> list) async {
    list.forEach((element) async {
      if (element.chatType == ChatType.chatGroup) {
        final groupId = element.groupId ?? '';
        List<UserDBISAR> groupList = await Groups.sharedInstance.getAllGroupMembers(groupId);
        List<String> avatars = groupList.map((element) => element.picture ?? '').toList();
        avatars.removeWhere((element) => element.isEmpty);
        _groupMembersCache[groupId] = avatars;
      }
    });
  }

  void _gotoFriendSession(UserDBISAR userDB) {
    _updateSearchHistory(userDB);
    OXNavigator.pushPage(
        context,
        (context) => ChatMessagePage(
              communityItem: ChatSessionModelISAR(
                chatId: userDB.pubKey,
                chatName: userDB.name,
                sender:
                    OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
                receiver: userDB.pubKey,
                chatType: ChatType.chatSingle,
              ),
            ));
  }

  void _gotoSingleRelatedPage(ChatMessage chatMessage) {
    OXNavigator.pushPage(
      context,
      (context) => SearchPage(
        searchText: searchQuery,
        searchPageType: SearchPageType.singleSessionRelated,
        chatMessage: chatMessage,
      ),
    );
  }

  void _gotoChatMessagePage(ChatMessage item) {
    final type = item.chatType;
    final sessionModel = OXChatBinding.sharedInstance.sessionMap[item.chatId];
    if (sessionModel == null) return;
    switch (type) {
      case ChatType.chatSingle:
        OXNavigator.pushPage(
          context,
          (context) => ChatMessagePage(
            communityItem: sessionModel,
            anchorMsgId: item.msgId,
          ),
        );
        break;
      case ChatType.chatChannel:
        OXNavigator.pushPage(
          context,
          (context) => ChatChannelMessagePage(
            communityItem: sessionModel,
            anchorMsgId: item.msgId,
          ),
        );
        break;
      case ChatType.chatSecret:
        OXNavigator.pushPage(
          context,
          (context) => ChatSecretMessagePage(
            communityItem: sessionModel,
            anchorMsgId: item.msgId,
          ),
        );
        break;
      case ChatType.chatGroup:
        OXNavigator.pushPage(
          context,
              (context) => ChatGroupMessagePage(
            communityItem: sessionModel,
            anchorMsgId: item.msgId,
          ),
        );
        break;
      case ChatType.chatRelayGroup:
        OXNavigator.pushPage(
          context,
              (context) => ChatRelayGroupMsgPage(
            communityItem: sessionModel,
            anchorMsgId: item.msgId,
          ),
        );
        break;
    }
  }

  void _gotoSeeMorePage(SearchItemType type, Group group) {
    if (type == SearchItemType.friend) {
      OXNavigator.pushPage(
        context,
        (context) => SearchPage(
          searchText: searchQuery,
          searchPageType: SearchPageType.friendSeeMore,
          defaultGroup: group,
        ),
      );
    } else if (type == SearchItemType.channel) {
      OXNavigator.pushPage(
        context,
        (context) => SearchPage(
          searchText: searchQuery,
          searchPageType: SearchPageType.channelSeeMore,
          defaultGroup: group,
        ),
      );
    } else if (type == SearchItemType.messagesGroup) {
      OXNavigator.pushPage(
        context,
        (context) => SearchPage(
          searchText: searchQuery,
          searchPageType: SearchPageType.messagesSeeMore,
          defaultGroup: group,
        ),
      );
    }
  }

  void gotoChatGroupSession(GroupUIModel groupUIModel) {
    if (groupUIModel.chatType == ChatType.chatGroup) {
      OXNavigator.pushPage(
          context,
          (context) => ChatGroupMessagePage(
                communityItem: ChatSessionModelISAR(
                  chatId: groupUIModel.groupId,
                  chatName: groupUIModel.name,
                  chatType: groupUIModel.chatType,
                  avatar: groupUIModel.picture,
                  groupId: groupUIModel.groupId,
                ),
              ));
    } else if (groupUIModel.chatType == ChatType.chatRelayGroup) {
      OXNavigator.pushPage(
          context,
          (context) => ChatRelayGroupMsgPage(
                communityItem: ChatSessionModelISAR(
                  chatId: groupUIModel.groupId,
                  chatName: groupUIModel.name,
                  chatType: groupUIModel.chatType,
                  avatar: groupUIModel.picture,
                  groupId: groupUIModel.groupId,
                ),
              ));
    }
  }

  void gotoChatChannelSession(ChannelDBISAR channelDB) {
    OXNavigator.pushPage(
        context,
        (context) => ChatChannelMessagePage(
              communityItem: ChatSessionModelISAR(
                chatId: channelDB.channelId,
                chatName: channelDB.name,
                chatType: ChatType.chatChannel,
                avatar: channelDB.picture,
                groupId: channelDB.channelId,
                createTime: channelDB.createTime,
              ),
            ));
  }

  void _clearRecentSearches() async {
    final isar = DBISAR.sharedInstance.isar;
    await isar.writeTxn(() async {
      await isar.searchHistoryModelISARs.clear();
      await isar.recentSearchUserISARs.clear();
    });

    _selectedHistoryList.clear();
    _txtHistoryList.clear();
    searchQuery = '';
    setState(() {});
  }
}


