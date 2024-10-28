import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/utils/search_item_click_handler.dart';
import 'package:ox_chat/widget/search_result_item.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:chatcore/chat-core.dart';

class GroupedModel<T> {
  final String title;
  final List<T> items;

  GroupedModel({required this.title, required this.items});
}

class SearchTabGroupedView<T> extends StatelessWidget {
  final List<GroupedModel<T>> data;
  final Widget Function(BuildContext context, String key, List<T> items) builder;
  final Widget Function(BuildContext context, String key)? headerBuilder;

  const SearchTabGroupedView({
    super.key,
    required this.data,
    required this.builder,
    this.headerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: data.map(
        (element) {
          final items =element.items;
          return SliverStickyHeader(
            header: headerBuilder != null
                ? headerBuilder!(context, element.title)
                : _buildDefaultHeader(element.title, items),
            sliver: builder(context, element.title, items),
          );
        },
      ).toList(),
    );
  }

  Widget _buildDefaultHeader(String title, items) {
    if(items.isEmpty) return SizedBox();
    return Container(
      alignment: Alignment.centerLeft,
      color: ThemeColor.color190,
      height: 28.px,
      width: double.infinity,
      padding: EdgeInsets.only(left: 24.px),
      child: Text(
        title,
        style: TextStyle(
          color: ThemeColor.color10,
          fontSize: 14.px,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ChatMessageGroupedListView extends SearchTabGroupedView<ChatMessage> {

  final String searchQuery;

  ChatMessageGroupedListView({
    Key? key,
    required List<GroupedModel<ChatMessage>> data,
    required this.searchQuery,
  }) : super(
    key: key,
    data: data,
    builder: (context, key, items) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final item = items[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.px),
              child: SearchResultItem(
                isUser: false,
                searchQuery: '',
                avatarURL: item.picture,
                title: item.name,
                subTitle: item.subtitle,
                onTap: () => SearchItemClickHandler.handleClick(context, item, searchQuery),
              ),
            );
          },
          childCount: items.length,
        ),
      );
    },
  );
}

class ChannelGroupedListView extends SearchTabGroupedView<ChannelDBISAR> {

  final String searchQuery;

  ChannelGroupedListView({
    Key? key,
    required List<GroupedModel<ChannelDBISAR>> data,
    required this.searchQuery,
  }) : super(
    key: key,
    data: data,
    builder: (context, key, items) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final item = items[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.px),
              child: SearchResultItem(
                isUser: false,
                searchQuery: '',
                avatarURL: item.picture,
                title: item.name,
                subTitle: item.about,
                onTap: () => SearchItemClickHandler.handleClick(context, item, searchQuery),
              ),
            );
          },
          childCount: items.length,
        ),
      );
    },
  );
}

class GroupCategorizedListView extends SearchTabGroupedView<GroupUIModel> {

  final String searchQuery;

  GroupCategorizedListView({
    Key? key,
    required List<GroupedModel<GroupUIModel>> data,
    required this.searchQuery,
  }) : super(
    key: key,
    data: data,
    builder: (context, key, items) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final item = items[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.px),
              child: SearchResultItem(
                isUser: false,
                searchQuery: '',
                avatarURL: item.picture,
                title: item.name,
                subTitle: item.about,
                onTap: () => SearchItemClickHandler.handleClick(context, item, searchQuery),
              ),
            );
          },
          childCount: items.length,
        ),
      );
    },
  );
}

class ContactGroupedListView extends SearchTabGroupedView<UserDBISAR> {

  final String searchQuery;

  ContactGroupedListView({
    Key? key,
    required List<GroupedModel<UserDBISAR>> data,
    required this.searchQuery,
  }) : super(
    key: key,
    data: data,
    builder: (context, key, items) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final item = items[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.px),
              child: SearchResultItem(
                isUser: false,
                searchQuery: '',
                avatarURL: item.picture,
                title: item.name,
                subTitle: item.about,
                onTap: () => SearchItemClickHandler.handleClick(context, item, searchQuery),
              ),
            );
          },
          childCount: items.length,
        ),
      );
    },
  );
}