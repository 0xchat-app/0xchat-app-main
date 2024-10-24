import 'package:flutter/material.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/utils/search_txt_util.dart';
import 'package:ox_chat/widget/search_result_item.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';

class SearchChatDetailPage extends StatefulWidget {
  final String searchQuery;
  final ChatMessage? chatMessage;

  const SearchChatDetailPage({
    super.key,
    required this.searchQuery,
    this.chatMessage,
  });

  @override
  State<SearchChatDetailPage> createState() => _SearchChatDetailPageState();
}

class _SearchChatDetailPageState extends State<SearchChatDetailPage> {
  List<ChatMessage> _chatMessageList = [];

  @override
  void initState() {
    super.initState();
    _loadMessagesData(chatId: widget.chatMessage?.chatId ?? null);
  }

  void _loadMessagesData({String? chatId}) async {
    List<ChatMessage> messages = await SearchTxtUtil.loadChatMessagesWithSymbol(
      widget.searchQuery,
      chatId: chatId,
    );

    setState(() {
      _chatMessageList = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: widget.chatMessage?.name ?? '',
        backgroundColor: ThemeColor.color200,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: ThemeColor.color200,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.px),
        itemBuilder: (context, index) {
          final item = _chatMessageList[index];
          return SearchResultItem(
            isUser: false,
            searchQuery: widget.searchQuery,
            avatarURL: item.picture,
            title: item.name,
            subTitle: item.subtitle,
            onTap: () => _gotoChatMessagePage(item),
          );
        },
        itemCount: _chatMessageList.length,
      ),
    );
  }

  void _gotoChatMessagePage(ChatMessage item) {
    final type = item.chatType;
    final sessionModel = OXChatBinding.sharedInstance.sessionMap[item.chatId];
    if (sessionModel == null) return;
    switch (type) {
      case ChatType.chatSingle:
      case ChatType.chatChannel:
      case ChatType.chatSecret:
      case ChatType.chatGroup:
      case ChatType.chatRelayGroup:
        ChatMessagePage.open(
          context: context,
          communityItem: sessionModel,
          anchorMsgId: item.msgId,
        );
        break;
    }
  }
}
