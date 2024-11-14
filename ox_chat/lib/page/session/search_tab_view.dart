import 'package:flutter/material.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/widget/search_tab_grid_view.dart';
import 'package:ox_chat/widget/search_tab_grouped_view.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:chatcore/chat-core.dart';

class SearchTabView extends StatefulWidget {
  final String searchQuery;
  final SearchType type;
  final List<dynamic> data;
  final String? chatId;

  const SearchTabView({
    super.key,
    required this.data,
    required this.type,
    required this.searchQuery,
    this.chatId,
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
        if (widget.data is List<GroupedModel<ChatMessage>>) {
          final data = widget.data as List<GroupedModel<ChatMessage>>;
          return ChatMessageGroupedListView(
            data: data,
            searchQuery: widget.searchQuery,
          );
        }
        break;
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
      // case SearchType.ecash:
      //   break;
      case SearchType.media:
        return SearchTabGridView(
          searchQuery: widget.searchQuery,
          chatId: widget.chatId,
        );
        break;
      // case SearchType.link:
      //   break;
      default:
        break;
    }
    return Container();
  }

  void _handleNoData() {
    if(widget.type == SearchType.media) return;
    if (widget.data.isEmpty) {
      updateStateView(CommonStateView.CommonStateView_NoData);
    } else {
      updateStateView(CommonStateView.CommonStateView_None);
    }
    setState(() {});
  }
}