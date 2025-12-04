import 'dart:async';
import 'dart:convert';
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
import 'package:nostr_core_dart/nostr.dart';

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
  String _lastSearchQuery = ''; // Track last search query to avoid clearing results unnecessarily
  TextEditingController _searchBarController = TextEditingController();
  Map<SearchType, List<dynamic>> _searchResult = {};
  List<GroupedModel<UserDBISAR>> _contacts = [];
  List<GroupedModel<GroupUIModel>> _groups = [];
  List<GroupedModel<ChannelDBISAR>> _channels = [];
  late final TabController _controller;
  Timer? _searchDebounceTimer;

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
    // Only clear contacts if search query has changed
    if (_searchQuery != _lastSearchQuery) {
      _contacts.clear();
    }
    List<UserDBISAR>? contactList = SearchTxtUtil.loadChatFriendsWithSymbol(searchQuery);
    if (contactList != null && contactList.length > 0) {
      // Remove existing group with same title if exists
      _contacts.removeWhere((group) => group.title == 'str_title_contacts'.localized());
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
    } else if (searchQuery.isNotEmpty) {
      // Search contacts from search relay
      await _searchContactsFromRelay(searchQuery);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _searchContactsFromRelay(String keyword) async {
    List<RelayDBISAR> searchRelayList = Account.sharedInstance.getMySearchRelayList();
    
    // If no search relay is selected, use all recommended ones
    if (searchRelayList.isEmpty) {
      List<RelayDBISAR> recommendRelayList = Account.sharedInstance.getMyRecommendSearchRelaysList();
      if (recommendRelayList.isEmpty) {
        return;
      }
      // Auto-select all recommended relays
      for (var relay in recommendRelayList) {
        await Account.sharedInstance.addSearchRelay(relay.url);
      }
      searchRelayList = Account.sharedInstance.getMySearchRelayList();
      if (searchRelayList.isEmpty) {
        return;
      }
    }

    // Show loading during search
    if (!OXLoading.isShow) {
      OXLoading.show();
    }

    try {
      List<String> searchRelays = searchRelayList.map((r) => r.url).toList();
      await Connect.sharedInstance.connectRelays(searchRelays, relayKind: RelayKind.search);
      
      Filter searchFilter = Nip50.encode(
        search: keyword,
        kinds: [0],
        limit: 10,
      );

      Map<String, UserDBISAR> result = {};
      Map<String, Event> eventMap = {}; // Store events to clean cache later
      Connect.sharedInstance.addSubscription(
        [searchFilter],
        relays: searchRelays,
        relayKinds: [RelayKind.search],
        eventCallBack: (event, relay) async {
          if (event.kind == 0) {
            // Store event for cache cleanup
            eventMap[event.id] = event;
            // Parse kind 0 event and create/update user info
            UserDBISAR? user = await _handleKind0Event(event);
            if (user != null) {
              result[event.pubkey] = user;
            }
          }
        },
        eoseCallBack: (requestId, ok, relay, unRelays) async {
          if (unRelays.isEmpty && result.isNotEmpty) {
            List<UserDBISAR> users = result.values.toList();
            // Remove existing group with same title if exists (from relay search)
            String contactsTitle = 'str_title_contacts'.localized();
            _contacts.removeWhere((group) => group.title == contactsTitle);
            _contacts.add(
              GroupedModel(
                title: contactsTitle,
                items: users,
              ),
            );
            _searchResult[SearchType.contact] = _contacts;
            if (mounted) {
              setState(() {});
            }
          }
          // Remove eventIds from event cache to avoid being cached for next search
          for (Event event in eventMap.values) {
            EventCache.sharedInstance.cacheIds.remove(event.id);
          }
          // Hide loading after search completes
          if (OXLoading.isShow) {
            OXLoading.dismiss();
          }
        },
      );
    } catch (e) {
      // Hide loading if error occurs
      if (OXLoading.isShow) {
        OXLoading.dismiss();
      }
    }
  }

  /// Handle kind 0 event and create/update user info
  Future<UserDBISAR?> _handleKind0Event(Event event) async {
    if (event.content.isEmpty) return null;
    
    try {
      Map map = jsonDecode(event.content);
      
      // Get existing user or create new one
      UserDBISAR? user = await Account.sharedInstance.getUserInfo(event.pubkey);
      if (user == null) {
        user = UserDBISAR(pubKey: event.pubkey);
      }
      
      // Update user info from event if event is newer
      if (user.lastUpdatedTime < event.createdAt) {
        user.name = map['name']?.toString();
        user.gender = map['gender']?.toString();
        user.area = map['area']?.toString();
        user.about = map['about']?.toString();
        user.picture = map['picture']?.toString();
        user.banner = map['banner']?.toString();
        user.dns = map['nip05']?.toString();
        user.lnurl = map['lnurl']?.toString();
        if (user.lnurl == null || user.lnurl == 'null' || user.lnurl!.isEmpty) {
          user.lnurl = null;
        }
        user.lnurl ??= map['lud06']?.toString();
        user.lnurl ??= map['lud16']?.toString();
        user.lastUpdatedTime = event.createdAt;
        
        if (user.name == null || user.name!.isEmpty) {
          user.name = map['display_name']?.toString();
        }
        if (user.name == null || user.name!.isEmpty) {
          user.name = map['username']?.toString();
        }
        if (user.name == null || user.name!.isEmpty) {
          user.name = user.shortEncodedPubkey;
        }
        
        var keysToRemove = {
          'name',
          'display_name',
          'username',
          'gender',
          'area',
          'about',
          'picture',
          'banner',
          'nip05',
          'lnurl',
          'lud16',
          'lud06'
        };
        Map filteredMap = Map.from(map)..removeWhere((key, value) => keysToRemove.contains(key));
        user.otherField = jsonEncode(filteredMap);
      } else {
        // Update lnurl even if event is older
        if (user.lnurl == null || user.lnurl == 'null' || user.lnurl!.isEmpty) {
          user.lnurl = null;
        }
        user.lnurl ??= map['lud16']?.toString();
        user.lnurl ??= map['lud06']?.toString();
      }
      
      // Save to database and cache
      Account.saveUserToDB(user);
      Account.sharedInstance.userCache[event.pubkey] = ValueNotifier<UserDBISAR>(user);
      
      return user;
    } catch (e) {
      return null;
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
          List<String> relays = map['relays'];
          if (relays.isEmpty) return;
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

  void _prepareData() {
    // Only clear results if search query has changed
    if (_searchQuery != _lastSearchQuery) {
      _searchResult.clear();
      _lastSearchQuery = _searchQuery;
    }
    if (!OXUserInfoManager.sharedInstance.isLogin) {
      return;
    }
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
    }
    setState(() {});
  }

  void _loadRecentData() {
    _searchResult.clear();
    _lastSearchQuery = ''; // Reset last search query when loading recent data
    _loadRecentChatMessage();
    _loadRecentGroup();
    _loadRecentChannel();
  }


  void _onTextChanged(String value) {
    _searchQuery = value;
    
    // Cancel previous timer
    _searchDebounceTimer?.cancel();
    
    if(value.isEmpty) {
      _loadRecentData();
    } else {
      // Start debounce timer: trigger search after 1 second of no input
      _searchDebounceTimer = Timer(Duration(milliseconds: 1000), () {
        _prepareData();
      });
    }
  }

  _onSubmitted(String value) {
    // Cancel debounce timer and trigger search immediately
    _searchDebounceTimer?.cancel();
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
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
              onSubmitted: _onSubmitted,
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
      ),
    );
  }

  List<T> _getRecentRecord<T>(List<T> list, {int limit = 5}) {
    return list.length > limit ? list.sublist(0, limit) : list;
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _controller.dispose();
    _searchBarController.dispose();
    ThemeManager.removeOnThemeChangedCallback(onThemeStyleChange);
    super.dispose();
  }
}