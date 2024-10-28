import 'package:flutter/material.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/model/recent_search_user_isar.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/model/search_history_model_isar.dart';
import 'package:ox_chat/widget/categorized_list_search_tab_content_view.dart';
import 'package:ox_chat/widget/list_search_tab_content_view.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:chatcore/chat-core.dart';

class SearchTabContentView extends StatefulWidget {
  final String searchQuery;
  final SearchType type;
  final List<dynamic> data;

  const SearchTabContentView({
    super.key,
    required this.data,
    required this.type,
    required this.searchQuery,
  });

  @override
  State<SearchTabContentView> createState() => _SearchTabContentViewState();
}

class _SearchTabContentViewState extends State<SearchTabContentView> with CommonStateViewMixin {

  @override
  void initState() {
    super.initState();
    _handleNoData();
  }

  @override
  void didUpdateWidget(covariant SearchTabContentView oldWidget) {
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
        Map<String, List<ChatMessage>> categorizedMessages = _groupedChatMessage();
        return ChatMessageCategorizedListView(
          categorizedData: categorizedMessages,
          searchQuery: widget.searchQuery,
        );
      case SearchType.contact:
        if (widget.data is List<UserDBISAR>) {
          final data = widget.data as List<UserDBISAR>;
          return ContactListView(
            data: data,
          );
        }
        break;
      case SearchType.group:
        if (widget.data is List<GroupUIModel>) {
          final data = widget.data as List<GroupUIModel>;
          return GroupListView(
            data: data,
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

  Map<String, List<ChatMessage>> _groupedChatMessage() {
    Map<String, List<ChatMessage>> categorizedMessages = {
      'Person': [],
      'Group': [],
      'Channel': []
    };
    if (widget.data is List<ChatMessage>) {
      List<ChatMessage> messages = widget.data as List<ChatMessage>;
      for (var message in messages) {
        if (message.chatType == ChatType.chatSingle) {
          categorizedMessages['Person']!.add(message);
        } else if (message.chatType == ChatType.chatGroup ||
            message.chatType == ChatType.chatRelayGroup) {
          categorizedMessages['Group']!.add(message);
        } else if (message.chatType == ChatType.chatChannel) {
          categorizedMessages['Channel']!.add(message);
        } else {
          categorizedMessages['Other'] = [message];
        }
      }
    }
    return categorizedMessages;
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


