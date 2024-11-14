import 'package:flutter/material.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/page/session/search_tab_view.dart';
import 'package:ox_chat/utils/search_txt_util.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/search_bar.dart';
import 'package:ox_chat/widget/search_tab_grouped_view.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_gradient_tab_bar.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_theme/ox_theme.dart';

class UnifiedSearchPage extends StatefulWidget {
  final int initialIndex;

  const UnifiedSearchPage({super.key, this.initialIndex = 0});

  @override
  State<UnifiedSearchPage> createState() => _UnifiedSearchPageState();

  show(BuildContext context) async {
    OXNavigator.pushPage(context, (context) => this, type: OXPushPageType.opacity);
  }
}

class _UnifiedSearchPageState extends State<UnifiedSearchPage>
    with SingleTickerProviderStateMixin {

  String _searchQuery = '';
  TextEditingController _searchBarController = TextEditingController();
  Map<SearchType, List<dynamic>> _searchResult = {};
  List<GroupedModel<UserDBISAR>> _contacts = [];
  List<GroupedModel<GroupUIModel>> _groups = [];
  List<GroupedModel<ChannelDBISAR>> _channels = [];
  late final TabController _controller;

  String get searchQuery => _searchQuery;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: SearchType.values.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    _loadRecentData();
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  void _loadContactsData() {
    _contacts.clear();
    List<UserDBISAR>? contactList = SearchTxtUtil.loadChatFriendsWithSymbol(searchQuery);
    if (contactList != null && contactList.length > 0) {
      _contacts.add(
        GroupedModel(
          title: 'str_title_contacts'.localized(),
          items: contactList,
        ),
      );
      _searchResult[SearchType.contact] = _contacts;
    }
  }

  void _loadUsersData() async {
    if (searchQuery.startsWith('npub')) {
      String? pubkey = UserDBISAR.decodePubkey(searchQuery);
      if (pubkey != null) {
        UserDBISAR? user = await Account.sharedInstance.getUserInfo(pubkey);
        if (user == null) return;
        _contacts.add(
          GroupedModel(
            title: 'str_title_top_hins_contacts'.localized(),
            items: List<UserDBISAR>.from([user]),
          ),
        );
      }
      _searchResult[SearchType.contact] = _contacts;
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _loadChatMessagesData({String? chatId}) async {
    List<ChatMessage> chatMessageList = await SearchTxtUtil.loadChatMessagesWithSymbol(searchQuery, chatId: chatId);
    if (chatMessageList.isNotEmpty) {
      List<GroupedModel<ChatMessage>> groupedChatMessage = _groupedChatMessage(chatMessageList);
      _searchResult[SearchType.chat] = groupedChatMessage;
    }
    setState(() {});
  }

  void _loadGroupsData() async {
    _groups.clear();
    OXLoading.show();
    List<GroupUIModel>? groupList = await SearchTxtUtil.loadChatGroupWithSymbol(searchQuery);
    OXLoading.dismiss();
    if (groupList != null && groupList.length > 0) {
      _groups.add(GroupedModel<GroupUIModel>(title: 'str_title_groups'.localized(), items: groupList));
      _searchResult[SearchType.group] = _groups;
      setState(() {});
    }
  }

  void _loadChannelsData() async {
    _channels.clear();
    List<ChannelDBISAR>? channelList = SearchTxtUtil.loadChatChannelsWithSymbol(searchQuery);
    if (channelList != null && channelList.length > 0) {
      _channels.add(GroupedModel<ChannelDBISAR>(title: 'str_title_channels'.localized(), items: channelList));
      _searchResult[SearchType.channel] = _channels;
    }
  }

  void _loadOnlineGroupsAndChannelsData() async {
    if (searchQuery.startsWith('nevent') ||
        searchQuery.startsWith('naddr') ||
        searchQuery.startsWith('nostr:') ||
        searchQuery.startsWith('note')) {
      Map<String, dynamic>? map = Channels.decodeChannel(searchQuery);
      if (map != null) {
        final kind = map['kind'];
        if (kind == 40 || kind == 41) {
          String decodeNote = map['channelId'].toString();
          List<String> relays = List<String>.from(map['relays']);
          ChannelDBISAR? c = await Channels.sharedInstance.searchChannel(decodeNote, relays);
          if (c != null) {
            List<ChannelDBISAR> result = [c];
            _channels.add(GroupedModel(title: 'str_online_channels'.localized(), items: result));
          }
        } else if (kind == 39000) {
          final groupId = map['channelId'];
          final relays = map['relays'];
          RelayGroupDBISAR? relayGroupDB = await RelayGroup.sharedInstance.searchGroupsMetadataWithGroupID(groupId, relays[0]);
          if (relayGroupDB != null) {
            List<GroupUIModel> result = [GroupUIModel.relayGroupdbToUIModel(relayGroupDB)];
            _groups.add(GroupedModel(title: 'str_online_groups'.localized(), items: result));
          }
        }
      }
      _searchResult[SearchType.group] = _groups;
      _searchResult[SearchType.channel] = _channels;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _loadRecentChatMessage() async {
    final List<ChatSessionModelISAR> sessionList = OXChatBinding.sharedInstance.sessionList;
    List<GroupedModel<ChatMessage>> recentChatMessage = [];
    if(sessionList.isNotEmpty) {
      sessionList.sort((session1, session2) {
        var session2CreatedTime = session2.createTime;
        var session1CreatedTime = session1.createTime;
        return session2CreatedTime.compareTo(session1CreatedTime);
      });
      List<ChatSessionModelISAR> recentSessionList = _getRecentRecord(sessionList);
      List<ChatMessage> chatMessageList = recentSessionList.map((item) => ChatMessage(
          item.chatId,
          '',
          item.chatName ?? '',
          item.content ?? '',
          item.avatar ?? '',
          item.chatType,0
      ),).toList();
      recentChatMessage.add(GroupedModel<ChatMessage>(title: 'str_recent_chats'.localized(), items: chatMessageList));
    }
    _searchResult[SearchType.chat] = recentChatMessage;
    setState(() {});
  }

  void _loadRecentGroup() {
    List<GroupedModel<GroupUIModel>> recentGroup = [];
    List<GroupUIModel> groups = [];
    Map<String, ValueNotifier<GroupDBISAR>> privateGroupMap = Groups.sharedInstance.myGroups;
    if(privateGroupMap.length>0) {
      List<GroupDBISAR> tempGroups = privateGroupMap.values.map((e) => e.value).toList();
      tempGroups.forEach((element) {
        GroupUIModel tempUIModel= GroupUIModel.groupdbToUIModel(element);
        groups.add(tempUIModel);
      });
    }
    Map<String, ValueNotifier<RelayGroupDBISAR>> relayGroupMap = RelayGroup.sharedInstance.myGroups;
    if(relayGroupMap.length>0) {
      List<RelayGroupDBISAR> tempRelayGroups = relayGroupMap.values.map((e) => e.value).toList();
      tempRelayGroups.forEach((element) {
        GroupUIModel uIModel= GroupUIModel.relayGroupdbToUIModel(element);
        groups.add(uIModel);
      });
    }
    recentGroup.add(GroupedModel<GroupUIModel>(title: 'recent_searches'.localized(), items: _getRecentRecord(groups)));
    _searchResult[SearchType.group] = recentGroup;
    setState(() {});
  }

  void _loadRecentChannel() {
    List<GroupedModel<ChannelDBISAR>> recentChannel = [];
    List<ChannelDBISAR> channels = [];
    Map<String, ValueNotifier<ChannelDBISAR>> channelsMap = Channels.sharedInstance.myChannels;
    if (channelsMap.length > 0) {
      channels = channelsMap.values.map((e) => e.value).toList();
    }
    recentChannel.add(GroupedModel<ChannelDBISAR>(title: 'recent_searches'.localized(), items: _getRecentRecord(channels)));
    _searchResult[SearchType.channel] = recentChannel;
    setState(() {});
  }

  void _getMediaList({String? content}) async {
    Map result = await Messages.loadMessagesFromDB(
      messageTypes: [
        MessageType.image,
        MessageType.encryptedImage,
        MessageType.video,
        MessageType.encryptedVideo,
      ],
      decryptContentLike: content,
      // since: 0
      // until: DateTime.now().microsecondsSinceEpoch,
      // limit: 50,
    );
    List<MessageDBISAR> messages = result['messages'] ?? <MessageDBISAR>[];
    _searchResult[SearchType.media] = messages;
    setState(() {});
  }

  void _prepareData() {
    _searchResult.clear();
    if (!OXUserInfoManager.sharedInstance.isLogin) return;
    _loadAllData();
  }

  void _loadAllData() async {
    if (searchQuery.trim().isNotEmpty) {
      _loadChatMessagesData();
      _loadContactsData();
      _loadGroupsData();
      _loadChannelsData();
      _loadOnlineGroupsAndChannelsData();
      _loadUsersData();
      // _getMediaList(content: searchQuery);
    }
    setState(() {});
  }

  void _loadRecentData() {
    _searchResult.clear();
    _loadRecentChatMessage();
    _loadRecentGroup();
    _loadRecentChannel();
    // _getMediaList();
  }


  void _onTextChanged(String value) {
    _searchQuery = value;
    if(value.isEmpty) {
      _loadRecentData();
    } else {
      _prepareData();
    }
  }

  List<GroupedModel<ChatMessage>> _groupedChatMessage(List<ChatMessage> messages) {
    List<GroupedModel<ChatMessage>> groupedChatMessage = [];
    GroupedModel<ChatMessage> singleChatCategory = GroupedModel(title: 'str_title_contacts'.localized(), items: []);
    GroupedModel<ChatMessage> groupChatCategory = GroupedModel(title: 'str_title_groups'.localized(), items: []);
    GroupedModel<ChatMessage> channelChatCategory = GroupedModel(title: 'str_title_channels'.localized(), items: []);
    GroupedModel<ChatMessage> otherChatCategory = GroupedModel(title: 'Other', items: []);
    for (var message in messages) {
      if (message.chatType == ChatType.chatSingle) {
        singleChatCategory.items.add(message);
      } else if (message.chatType == ChatType.chatGroup ||
          message.chatType == ChatType.chatRelayGroup) {
        groupChatCategory.items.add(message);
      } else if (message.chatType == ChatType.chatChannel) {
        channelChatCategory.items.add(message);
      } else {
        otherChatCategory.items.add(message);
      }
    }

    groupedChatMessage.add(singleChatCategory);
    groupedChatMessage.add(groupChatCategory);
    groupedChatMessage.add(channelChatCategory);
    groupedChatMessage.add(otherChatCategory);

    return groupedChatMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnifiedSearchBar(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            controller: _searchBarController,
            onChanged: _onTextChanged,
          ),
          CommonGradientTabBar(
            controller: _controller,
            data: SearchType.values.map((element) => element.getLocalizedLabel()).toList(),
          ).setPaddingOnly(left: 24.px),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: SearchType.values.map(
                    (searchType) => SearchTabView(
                      data: _searchResult[searchType] ?? [],
                      type: searchType,
                      searchQuery: searchQuery,
                    ),
                  ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<T> _getRecentRecord<T>(List<T> list, {int limit = 5}) {
    return list.length > limit ? list.sublist(0, limit) : list;
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchBarController.dispose();
    ThemeManager.removeOnThemeChangedCallback(onThemeStyleChange);
    super.dispose();
  }
}