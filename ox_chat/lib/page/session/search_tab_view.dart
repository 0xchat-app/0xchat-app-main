import 'package:flutter/material.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/model/recent_search_user_isar.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/model/search_history_model_isar.dart';
import 'package:ox_chat/widget/search_tab_grouped_view.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:chatcore/chat-core.dart';

class SearchTabView extends StatefulWidget {
  final String searchQuery;
  final SearchType type;
  final List<dynamic> data;

  const SearchTabView({
    super.key,
    required this.data,
    required this.type,
    required this.searchQuery,
  });

  @override
  State<SearchTabView> createState() => _SearchTabViewState();
}

class _SearchTabViewState extends State<SearchTabView> with CommonStateViewMixin {

  @override
  void initState() {
    super.initState();
    _handleNoData();
  }

  @override
  void didUpdateWidget(covariant SearchTabView oldWidget) {
    setState(() {
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _handleNoData();
    return commonStateViewWidget(
      context,
      _buildContentView(),
    );
  }

  Widget _buildContentView() {
    switch (widget.type) {
      case SearchType.chat:
        List<GroupedModel<ChatMessage>> groupedChatMessages = _groupedChatMessage();
        return ChatMessageGroupedListView(
          data: groupedChatMessages,
          searchQuery: widget.searchQuery,
        );
      case SearchType.contact:
        if (widget.data is List<GroupedModel<UserDBISAR>>) {
          final data = widget.data as List<GroupedModel<UserDBISAR>>;
          return ContactGroupedListView(
            data: data,
            searchQuery: widget.searchQuery,
          );
        }
        break;
      case SearchType.group:
        if (widget.data is List<GroupedModel<GroupUIModel>>) {
          final data = widget.data as List<GroupedModel<GroupUIModel>>;
          return GroupCategorizedListView(
            data: data,
            searchQuery: widget.searchQuery,
          );
        }
        break;
      case SearchType.channel:
        if (widget.data is List<GroupedModel<ChannelDBISAR>>) {
          final data = widget.data as List<GroupedModel<ChannelDBISAR>>;
          return ChannelGroupedListView(
            data: data,
            searchQuery: widget.searchQuery,
          );
        }
        break;
      case SearchType.ecash:
        break;
      case SearchType.media:
        break;
      case SearchType.link:
        break;
      default:
        break;
    }
    return Container();
  }

  void _handleNoData() {
    if (widget.data.isEmpty) {
      updateStateView(CommonStateView.CommonStateView_NoData);
    } else {
      updateStateView(CommonStateView.CommonStateView_None);
    }
    setState(() {});
  }

  List<GroupedModel<ChatMessage>> _groupedChatMessage() {
    List<GroupedModel<ChatMessage>> groupedChatMessage = [];
    GroupedModel<ChatMessage> personChatMessage = GroupedModel(title: 'Person', items: []);
    GroupedModel<ChatMessage> groupChatMessage = GroupedModel(title: 'Group', items: []);
    GroupedModel<ChatMessage> channelChatMessage = GroupedModel(title: 'Channel', items: []);
    GroupedModel<ChatMessage> otherChatMessage = GroupedModel(title: 'Other', items: []);
    if (widget.data is List<ChatMessage>) {
      List<ChatMessage> messages = widget.data as List<ChatMessage>;
      for (var message in messages) {
        if (message.chatType == ChatType.chatSingle) {
          personChatMessage.items.add(message);
        } else if (message.chatType == ChatType.chatGroup ||
            message.chatType == ChatType.chatRelayGroup) {
          groupChatMessage.items.add(message);
        } else if (message.chatType == ChatType.chatChannel) {
          channelChatMessage.items.add(message);
        } else {
          otherChatMessage.items.add(message);
        }
      }
    }
    groupedChatMessage.add(personChatMessage);
    groupedChatMessage.add(groupChatMessage);
    groupedChatMessage.add(channelChatMessage);
    groupedChatMessage.add(otherChatMessage);

    return groupedChatMessage;
  }

  Future<void> _updateSearchHistory(UserDBISAR? userDB) async {
    final userPubkey = userDB?.pubKey;
    if (userPubkey != null) {
      await DBISAR.sharedInstance.saveToDB(RecentSearchUserISAR(pubKey: userPubkey));
    } else {
      await DBISAR.sharedInstance.saveToDB(SearchHistoryModelISAR(
        searchTxt: widget.searchQuery,
        pubKey: userDB?.pubKey ?? null,
        name: userDB?.name ?? null,
        picture: userDB?.picture ?? null,
      ));
      LogUtil.e('Michael: _updateSearchHistory count =');
    }
  }
}

class GridSearchTabContentView extends StatelessWidget {
  const GridSearchTabContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


