import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/model/recent_search_user.dart';
import 'package:ox_chat/model/search_history_model.dart';
import 'package:ox_chat/page/session/chat_group_message_page.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/page/session/search_discover_ui.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
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
import 'package:ox_common/model/channel_model.dart';

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

  SearchPage({
    this.searchText,
    this.searchPageType = SearchPageType.all,
    this.chatMessage,
    this.defaultGroup,
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
  List<UserDB> _selectedHistoryList = [];
  List<SearchHistoryModel> _txtHistoryList = [];
  bool isShowAppBar = false;
  TextEditingController editingController = TextEditingController();
  int lastRequestId = 0;

  final maxItemsCount = 3;

  @override
  void initState() {
    super.initState();

    _prepareData();
  }

  void _prepareData() {
    searchQuery = widget.searchText ?? '';

    if (!OXUserInfoManager.sharedInstance.isLogin) return;

    final searchPageType = widget.searchPageType;

    switch (searchPageType) {
      case SearchPageType.friendSeeMore:
      case SearchPageType.channelSeeMore:
      case SearchPageType.messagesSeeMore:
      case SearchPageType.singleSessionRelated:
        isShowAppBar = true;
        break;
      default:
        isShowAppBar = false;
        break;
    }

    switch (searchPageType) {
      case SearchPageType.all:
        _loadAllData(false);
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
        loadOnlineChannelsData();
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
    dataGroups.clear();
    if (searchQuery.trim().isNotEmpty) {
      _loadFriendsData();
      _loadChannelsData();
      _loadMessagesData();
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

    final userList = await DB.sharedInstance.objects<RecentSearchUser>();
    Future.forEach(userList, (e) async {
      final user = await Account.sharedInstance.getUserInfo(e.pubKey);
      if (user != null) {
        _selectedHistoryList.add(user);
      }
    });

    if (mounted) {
      setState(() {});
    }
  }

  void loadOnlineChannelsData() async {
    dataGroups.clear();
    final requestId = ++lastRequestId;
    if (searchQuery.startsWith('nevent') || searchQuery.startsWith('nostr:') || searchQuery.startsWith('note')) {
      Map<String, dynamic>? map = Channels.decodeChannel(searchQuery);
      if (map != null && map.containsKey('channelId')) {
        String decodeNote = map['channelId'].toString();
        List<ChannelDB> channelDBList = [];
        ChannelDB? c = Channels.sharedInstance.channels[decodeNote];
        if (c == null) {
          channelDBList = await Channels.sharedInstance.getChannelsFromRelay(channelIds: [decodeNote]);
        } else {
          channelDBList = [c];
        }
        if (channelDBList.isNotEmpty) {
          dataGroups.add(
            Group(title: 'Online Channels', type: SearchItemType.channel, items: channelDBList),
          );
        }
      }
    } else {
      List<ChannelModel?> channelModels = await getHotChannels(queryCode: searchQuery, context: context, showLoading: false);
      LogUtil.d('Search Result: ${channelModels.length} ${channelModels}');
      if (requestId == lastRequestId) {
        if (channelModels.length > 0) {
          List<ChannelDB>? tempChannelList = channelModels.map((element) => element!.toChannelDB()).toList();
          dataGroups.add(
            Group(title: 'Online Channels', type: SearchItemType.channel, items: tempChannelList),
          );
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _loadChannelsData() async {
    List<ChannelDB>? tempChannelList = loadChatChannelsWithSymbol(searchQuery);
    if (tempChannelList != null && tempChannelList.length > 0) {
      dataGroups.add(
        Group(title: 'Channels', type: SearchItemType.channel, items: tempChannelList),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _loadFriendsData() async {
    List<UserDB>? tempFriendList = loadChatFriendsWithSymbol(searchQuery);
    if (tempFriendList != null && tempFriendList.length > 0) {
      dataGroups.add(
        Group(title: 'Friends', type: SearchItemType.friend, items: tempFriendList),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _loadMessagesData({String? chatId}) async {
    List<ChatMessage> chatMessageList = await loadChatMessagesWithSymbol(searchQuery, chatId: chatId);
    if (chatMessageList.isNotEmpty) {
      final type = chatId == null ? SearchItemType.messagesGroup : SearchItemType.message;
      dataGroups.add(
        Group(title: 'Messages', type: type, items: chatMessageList),
      );
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ThemeColor.color200;
    return widget.searchPageType == SearchPageType.discover ? discoverPage() : normalPage();
  }

  Widget normalPage() {
    final backgroundColor = ThemeColor.color200;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: isShowAppBar
          ? CommonAppBar(
              useLargeTitle: false,
              centerTitle: true,
              title: _showTitle(),
              backgroundColor: backgroundColor,
            )
          : null,
      body: Column(
        children: [
          isShowAppBar ? Container() : _topSearchView(),
          Expanded(
            child: _contentView().setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24))),
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
          return isShowAppBar
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
                          style: TextStyle(fontSize: Adapt.px(14), color: ThemeColor.color100, fontWeight: FontWeight.w600),
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
          if (element.type == SearchItemType.friend && items is List<UserDB>) {
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
          } else if (element.type == SearchItemType.channel && items is List<ChannelDB>) {
            return Column(
              children: items.map((item) {
                return _buildResultItemView(
                  isUser: false,
                  avatarURL: item.picture,
                  title: item.name,
                  subTitle: item.about ?? '',
                  onTap: () => gotoChatGroupSession(item),
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
                      switch (element.type) {
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
    final avatarWidget = isUser ? OXUserAvatar(imageUrl: avatarURL) : OXChannelAvatar(imageUrl: avatarURL);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        height: Adapt.px(72),
        child: Row(
          children: [
            avatarWidget.setPadding(EdgeInsets.only(left: Adapt.px(0), right: Adapt.px(16))),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '',
                  ).setPadding(EdgeInsets.only(bottom: Adapt.px(2))),
                  highlightText(subTitle ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
      // child: ListTile(
      //   // onTap: onTap,
      //   leading: avatarWidget,
      //   title: Text(
      //     title ?? '',
      //   ),
      //   subtitle: Text(
      //     subText ?? '',
      //     style: TextStyle(
      //       fontSize: Adapt.px(14),
      //       fontWeight: FontWeight.w400,
      //       color: ThemeColor.color120,
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildEmptySearchView() {
    final hasHistory = _selectedHistoryList.length > 0 || _txtHistoryList.length > 0;
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
    List<UserDB?> userList = []..addAll(_selectedHistoryList);
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
          .map(
            (user) => Container(
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
          )
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
          text: mainText.substring(endIndexOfToken, endIndexOfToken + searchText.length),
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
    if (searchPageType == SearchPageType.friendSeeMore || searchPageType == SearchPageType.channelSeeMore || searchPageType == SearchPageType.messagesSeeMore) {
      return items;
    }

    if (items.length > maxItemsCount) {
      items = items.sublist(0, maxItemsCount);
    }
    return items;
  }

  void _onTextChanged(value) {
    searchQuery = value;
    _loadAllData(true);
  }

  Widget _topSearchView() {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
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

  Future<void> _updateSearchHistory(UserDB? userDB) async {
    final userPubkey = userDB?.pubKey;
    if (userPubkey != null) {
      await DB.sharedInstance.insert<RecentSearchUser>(RecentSearchUser(
        pubKey: userPubkey,
      ));
    } else {
      final int count = await DB.sharedInstance.insert<SearchHistoryModel>(SearchHistoryModel(
        searchTxt: searchQuery,
        pubKey: userDB?.pubKey ?? null,
        name: userDB?.name ?? null,
        picture: userDB?.picture ?? null,
      ));
      LogUtil.e('Michael: _updateSearchHistory count =${count}');
    }
  }

  //Queries the list of Friends to see if each Friend name contains a search character
  List<UserDB>? loadChatFriendsWithSymbol(String symbol) {
    List<UserDB>? friendList = Contacts.sharedInstance.fuzzySearch(symbol);
    return friendList;
  }

  //Queries the list of Channels to see if each Channel name contains a search character
  List<ChannelDB>? loadChatChannelsWithSymbol(String symbol) {
    final List<ChannelDB>? channelList = Channels.sharedInstance.fuzzySearch(symbol);
    return channelList;
  }

  Future<List<ChatMessage>> loadChatMessagesWithSymbol(String symbol, {String? chatId}) async {
    List<ChatMessage> chatMessageList = [];
    String originalSearchTxt = symbol;
    originalSearchTxt = originalSearchTxt.replaceFirst("/", "//");
    originalSearchTxt = originalSearchTxt.replaceFirst("_", "/_");
    originalSearchTxt = originalSearchTxt.replaceFirst("%", "/%");
    originalSearchTxt = originalSearchTxt.replaceFirst(" ", "%");
    final List<ChatMessage> channelMsgList = await loadChannelMsgWithSearchTxt(originalSearchTxt, chatId: chatId);
    final List<ChatMessage> privateChatMsgList = await loadPrivateChatMsgWithSearchTxt(originalSearchTxt, chatId: chatId);
    chatMessageList.addAll(channelMsgList);
    chatMessageList.addAll(privateChatMsgList);
    return chatMessageList;
  }

  Future<List<ChatMessage>> loadChannelMsgWithSearchTxt(String orignalSearchTxt, {String? chatId}) async {
    List<ChatMessage> chatMessageList = [];
    try {
      Map<dynamic, dynamic> tempMap = {};
      if (chatId == null) {
        tempMap = await Messages.loadMessagesFromDB(
          where: 'groupId IS NOT NULL AND groupId != ? AND content COLLATE NOCASE NOT LIKE ? AND decryptContent COLLATE NOCASE LIKE ?',
          whereArgs: ['', '%{%}%', "%${orignalSearchTxt}%"],
        );
      } else {
        tempMap = await Messages.loadMessagesFromDB(
          where: 'groupId = ? AND content COLLATE NOCASE NOT LIKE ? AND decryptContent COLLATE NOCASE LIKE ?',
          whereArgs: [chatId, '%{%}%', "%${orignalSearchTxt}%"],
        );
      }
      List<MessageDB> messages = tempMap['messages'];
      LogUtil.e('Michael:loadChannelMsgWithSearchTxt  messages.length =${messages.length}');
      if (messages.length != 0) {
        if (chatId == null) {
          Map<String, ChatMessage> messageInduceMap = {};
          messages.forEach((item) {
            if (messageInduceMap[item.groupId] == null) {
              messageInduceMap[item.groupId] = ChatMessage(
                item.groupId,
                item.messageId ?? '',
                Channels.sharedInstance.myChannels[item.groupId]?.name ?? '',
                item.decryptContent,
                Channels.sharedInstance.myChannels[item.groupId]?.picture ?? '',
                ChatType.chatChannel,
                1,
              );
            } else {
              messageInduceMap[item.groupId]!.relatedCount = messageInduceMap[item.groupId]!.relatedCount + 1;
              messageInduceMap[item.groupId]!.subtitle = '${messageInduceMap[item.groupId]!.relatedCount} related messages';
            }
          });
          LogUtil.e('Michael: messageInduceMap.length =${messageInduceMap.length}');
          chatMessageList = messageInduceMap.values.toList();
        } else {
          messages.forEach((element) {
            Map<String, dynamic> tempMap = jsonDecode(element.content!);
            Map<String, dynamic> rightContentMap = jsonDecode(tempMap['content']);
            String subTitle = rightContentMap['content'].toString();
            chatMessageList.add(ChatMessage(
              element.groupId!,
              element.messageId ?? '',
              Channels.sharedInstance.myChannels[element.groupId!]?.name ?? '',
              subTitle,
              Channels.sharedInstance.myChannels[element.groupId!]?.picture ?? '',
              ChatType.chatChannel,
              1,
            ));
          });
        }
      }
    } catch (e) {
      LogUtil.e('Michael: e =${e}');
    }
    return chatMessageList;
  }

  Future<List<ChatMessage>> loadPrivateChatMsgWithSearchTxt(String orignalSearchTxt, {String? chatId}) async {
    List<ChatMessage> chatMessageList = [];
    try {
      Map<dynamic, dynamic> tempMap = {};
      if (chatId == null) {
        tempMap = await Messages.loadMessagesFromDB(
          where: "sender IS NOT NULL AND sender != ? AND receiver IS NOT NULL AND receiver != ? AND decryptContent COLLATE NOCASE NOT LIKE ? AND decryptContent COLLATE NOCASE LIKE ?",
          whereArgs: ['', '', '%{%}%', "%${orignalSearchTxt}%"],
        );
      } else {
        tempMap = await Messages.loadMessagesFromDB(
          where: "(sender = ? AND receiver = ? ) OR (sender = ? AND receiver = ? ) AND decryptContent COLLATE NOCASE NOT LIKE ? AND decryptContent COLLATE NOCASE LIKE ?",
          whereArgs: [
            chatId,
            OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
            OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
            chatId,
            '%{%}%',
            "%${orignalSearchTxt}%",
          ],
        );
      }
      List<MessageDB> messages = tempMap['messages'];
      LogUtil.e('Michael: loadPrivateChatMsgWithSearchTxt messages.length =${messages.length}');
      if (messages.length != 0) {
        if (chatId == null) {
          Map<String, ChatMessage> messageInduceMap = {};
          messages.forEach((item) {
            String chatId = '';
            if (item.sender == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey ||
                item.receiver == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
              chatId = item.sender!;
            } else if (item.sender == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey ||
                item.receiver != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
              chatId = item.receiver!;
            } else if (item.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey ||
                item.receiver == OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
              chatId = item.sender!;
            }
            if (messageInduceMap[chatId] == null) {
              messageInduceMap[chatId] = ChatMessage(
                chatId,
                item.messageId ?? '',
                Contacts.sharedInstance.allContacts[chatId]?.name ?? '',
                item.decryptContent,
                Contacts.sharedInstance.allContacts[chatId]?.picture ?? '',
                ChatType.chatSingle,
                1,
              );
            } else {
              messageInduceMap[chatId]!.relatedCount = messageInduceMap[chatId]!.relatedCount + 1;
              messageInduceMap[chatId]!.subtitle = '${messageInduceMap[chatId]!.relatedCount} related messages';
            }
          });
          LogUtil.e('Michael: messageInduceMap.length =${messageInduceMap.length}');
          chatMessageList = messageInduceMap.values.toList();
        } else {
          messages.forEach((element) {
            Map<String, dynamic> tempMap = jsonDecode(element.decryptContent!);
            String subTitle = tempMap['content'].toString();
            chatMessageList.add(ChatMessage(
              chatId,
              element.messageId ?? '',
              Contacts.sharedInstance.allContacts[chatId]?.name ?? '',
              subTitle,
              Contacts.sharedInstance.allContacts[chatId]?.picture ?? '',
              ChatType.chatSingle,
              1,
            ));
          });
        }
      }
    } catch (e) {
      LogUtil.e('Michael: e =${e}');
    }
    return chatMessageList;
  }

  Image placeholderImage(bool isUser, double wh) {
    String localAvatarPath = isUser ? 'assets/images/user_image.png' : 'assets/images/icon_group_default.png';
    return Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(wh),
      height: Adapt.px(wh),
      package: 'ox_chat',
    );
  }

  void _gotoFriendSession(UserDB userDB) {
    _updateSearchHistory(userDB);
    OXNavigator.pushPage(
        context,
        (context) => ChatMessagePage(
              communityItem: ChatSessionModel(
                chatId: userDB.pubKey,
                chatName: userDB.name,
                sender: OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
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
          (context) => ChatGroupMessagePage(
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

  void gotoChatGroupSession(ChannelDB channelDB) {
    OXNavigator.pushPage(
        context,
        (context) => ChatGroupMessagePage(
              communityItem: ChatSessionModel(
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
    DB.sharedInstance.delete<SearchHistoryModel>();
    DB.sharedInstance.delete<RecentSearchUser>();
    _selectedHistoryList.clear();
    _txtHistoryList.clear();
    searchQuery = '';
    setState(() {});
  }
}

enum SearchItemType {
  friend,
  channel,
  messagesGroup,
  message,
}

class Group {
  final String title;
  final SearchItemType type;
  final List items;

  Group({required this.title, required this.type, required this.items});

  @override
  String toString() {
    return 'Group{title: $title, type: $type, items: $items}';
  }
}

class ChatMessage {
  String chatId;
  String msgId;
  String name;
  String subtitle;
  String picture;
  int chatType;
  int relatedCount;

  ChatMessage(this.chatId, this.msgId, this.name, this.subtitle, this.picture, this.chatType, this.relatedCount);

  @override
  String toString() {
    return 'ChatMessage{chatId: ${chatId}, msgId: $msgId, name: $name, subtitle: $subtitle, picture: $picture, chatType: ${chatType}, relatedCount: $relatedCount}';
  }
}
