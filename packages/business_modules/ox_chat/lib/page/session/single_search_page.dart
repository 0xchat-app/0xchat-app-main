import 'package:flutter/material.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/page/session/search_tab_view.dart';
import 'package:ox_chat/utils/search_txt_util.dart';
import 'package:ox_chat/widget/search_bar.dart';
import 'package:ox_chat/widget/search_tab_grouped_view.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_gradient_tab_bar.dart';

class SingleSearchPage extends StatefulWidget {
  final String chatId;

  const SingleSearchPage({super.key, required this.chatId});

  @override
  State<SingleSearchPage> createState() => _SingleSearchPageState();

  show(BuildContext context) async {
    OXNavigator.pushPage(context, (context) => this, type: OXPushPageType.opacity);
  }
}

class _SingleSearchPageState extends State<SingleSearchPage>
    with SingleTickerProviderStateMixin {

  final tabs = [SearchType.chat, SearchType.media];
  late final TabController _controller;
  String _searchQuery = '';
  TextEditingController _searchBarController = TextEditingController();
  Map<SearchType, List<dynamic>> _searchResult = {};

  String get searchQuery => _searchQuery;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: SearchType.values.length,
      vsync: this,
    );
  }

  void _loadChatMessagesData({String? chatId}) async {
    List<GroupedModel<ChatMessage>> groupedChatMessage = [];
    if(searchQuery.isEmpty) {
      _searchResult[SearchType.chat] = groupedChatMessage;
      setState(() {});
      return;
    }
    List<ChatMessage> chatMessageList = await SearchTxtUtil.loadChatMessagesWithSymbol(searchQuery, chatId: chatId);
    if (chatMessageList.isNotEmpty) {
      groupedChatMessage.add(GroupedModel<ChatMessage>(title: 'Chat Result', items: chatMessageList));
      _searchResult[SearchType.chat] = groupedChatMessage;
    }
    setState(() {});
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
            data: tabs.map((element) => element.label).toList(),
          ).setPaddingOnly(left: 24.px),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: tabs.map(
                    (searchType) => SearchTabView(
                  data: _searchResult[searchType] ?? [],
                  type: searchType,
                  searchQuery: _searchQuery,
                  chatId: widget.chatId,
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _onTextChanged(String value) {
    _searchResult.clear();
    _searchQuery = value;
    _loadChatMessagesData(chatId: widget.chatId);
  }
}
