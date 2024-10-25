import 'package:flutter/material.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/page/session/search_tab_content_view.dart';
import 'package:ox_chat/utils/search_txt_util.dart';
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
  late final TabController _controller;

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
    List<UserDBISAR>? contactList = SearchTxtUtil.loadChatFriendsWithSymbol(_searchQuery);
    if (contactList != null && contactList.length > 0) {
      _searchResult[SearchType.contact] = contactList;
    }
  }

  void _loadMessagesData({String? chatId}) async {
    List<ChatMessage> chatMessageList = await SearchTxtUtil.loadChatMessagesWithSymbol(_searchQuery, chatId: chatId);
    if (chatMessageList.isNotEmpty) {
      _searchResult[SearchType.chat] = chatMessageList;
    }
    setState(() {});
  }

  void _loadGroupsData() async {
    List<GroupUIModel>? groupList = await SearchTxtUtil.loadChatGroupWithSymbol(_searchQuery);
    if (groupList != null && groupList.length > 0) {
      _searchResult[SearchType.group] = groupList;
    }
  }
  void _prepareData() {
    _searchResult.clear();
    if (!OXUserInfoManager.sharedInstance.isLogin) return;
    _loadAllData();
  }

  void _loadAllData() async {
    if (_searchQuery.trim().isNotEmpty) {
      _loadContactsData();
      // _loadChannelsData();
      _loadGroupsData();
      _loadMessagesData();
      // loadOnlineChannelsData();
      // _loadUsersData();
    } else {
      // _loadHistory();
    }
    setState(() {});
  }


  void _onTextChanged(value) {
    _searchQuery = value;
    _prepareData();
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
          _buildRecentText(),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: SearchType.values.map(
                    (searchType) => SearchTabContentView(
                      data: _searchResult[searchType] ?? [],
                      type: searchType,
                      searchQuery: _searchQuery,
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
            onTap: () {
              OXNavigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentText() {
    return Container(
      alignment: Alignment.centerLeft,
      color: ThemeColor.color190,
      height: 28.px,
      width: double.infinity,
      padding: EdgeInsets.only(left: 24.px),
      child: Text(
        'Recent',
        style: TextStyle(
          color: ThemeColor.color10,
          fontSize: 14.px,
          fontWeight: FontWeight.w600,
        ),
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
