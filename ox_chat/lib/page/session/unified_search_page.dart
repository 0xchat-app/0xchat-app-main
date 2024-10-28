import 'package:flutter/material.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/page/session/search_tab_view.dart';
import 'package:ox_chat/utils/search_txt_util.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/search_tab_grouped_view.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_gradient_tab_bar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';

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
  }

  void _loadContactsData() {
    _contacts.clear();
    List<UserDBISAR>? contactList = SearchTxtUtil.loadChatFriendsWithSymbol(searchQuery);
    if (contactList != null && contactList.length > 0) {
      _contacts.add(
        GroupedModel(
          title: 'Contacts',
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
    List<GroupUIModel>? groupList = await SearchTxtUtil.loadChatGroupWithSymbol(searchQuery);
    if (groupList != null && groupList.length > 0) {
      _groups.add(GroupedModel<GroupUIModel>(title: 'Groups', items: groupList));
      _searchResult[SearchType.group] = _groups;
    }
  }

  void _loadChannelsData() async {
    List<ChannelDBISAR>? channelList = SearchTxtUtil.loadChatChannelsWithSymbol(searchQuery);
    if (channelList != null && channelList.length > 0) {
      _channels.add(GroupedModel<ChannelDBISAR>(title: 'Channels', items: channelList));
      _searchResult[SearchType.channel] = _channels;
    }
  }

  void _loadOnlineGroupsAndChannelsData() async {
    _groups.clear();
    _channels.clear();
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
            _channels.add(GroupedModel(title: 'Online Channels', items: result));
          }
        } else if (kind == 39000) {
          final groupId = map['channelId'];
          final relays = map['relays'];
          RelayGroupDBISAR? relayGroupDB = await RelayGroup.sharedInstance.searchGroupsMetadataWithGroupID(groupId, relays[0]);
          if (relayGroupDB != null) {
            List<GroupUIModel> result = [GroupUIModel.relayGroupdbToUIModel(relayGroupDB)];
            _groups.add(GroupedModel(title: 'Online Groups', items: result));
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
    }
    setState(() {});
  }


  void _onTextChanged(value) {
    _searchQuery = value;
    _prepareData();
  }

  List<GroupedModel<ChatMessage>> _groupedChatMessage(List<ChatMessage> messages) {
    List<GroupedModel<ChatMessage>> groupedChatMessage = [];
    GroupedModel<ChatMessage> singleChatCategory = GroupedModel(title: 'Person', items: []);
    GroupedModel<ChatMessage> groupChatCategory = GroupedModel(title: 'Group', items: []);
    GroupedModel<ChatMessage> channelChatCategory = GroupedModel(title: 'Channel', items: []);
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
          _buildSearchBar(),
          CommonGradientTabBar(
            controller: _controller,
            data: SearchType.values.map((element) => element.label).toList(),
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

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      height: 80.px,
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
                controller: _searchBarController,
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
                    fontSize: 15.px,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onTap: () => OXNavigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchBarController.dispose();
    super.dispose();
  }
}