import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/utils/search_item_click_handler.dart';
import 'package:ox_chat/widget/search_result_item.dart';

class ListSearchTabContentView<T> extends StatelessWidget {
  final List<T> data;
  final Widget Function(BuildContext context, T item) builder;

  const ListSearchTabContentView({
    super.key,
    required this.data,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      padding: EdgeInsets.symmetric(horizontal: 24),
      itemBuilder: (BuildContext context, int index) {
        final item = data[index];
        return builder(context, item);
      },
    );
  }
}

class ContactListView extends ListSearchTabContentView<UserDBISAR> {
  ContactListView({
    Key? key,
    required List<UserDBISAR> data,
  }) : super(
          key: key,
          data: data,
          builder: _buildContactItem,
        );

  static Widget _buildContactItem(BuildContext context, UserDBISAR item) {
    return SearchResultItem(
      isUser: true,
      // searchQuery: widget.searchQuery,
      searchQuery: '',
      avatarURL: item.picture,
      title: item.name,
      subTitle: item.about ?? '',
      onTap: () => SearchItemClickHandler.handleClick(context, item),
    );
  }
}

class GroupListView extends ListSearchTabContentView<GroupUIModel> {
  GroupListView({
    Key? key,
    required List<GroupUIModel> data,
  }) : super(
          key: key,
          data: data,
          builder: _buildGroupItem,
        );

  static Widget _buildGroupItem(BuildContext context, GroupUIModel item) {
    return SearchResultItem(
      isUser: true,
      // searchQuery: widget.searchQuery,
      searchQuery: '',
      avatarURL: item.picture,
      title: item.name,
      subTitle: item.about ?? '',
      onTap: () => SearchItemClickHandler.handleClick(context, item),
    );
  }
}