import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/utils/search_item_click_handler.dart';
import 'package:ox_chat/widget/search_result_item.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

class CategorizedListSearchTabContentView<T> extends StatelessWidget {
  final Map<String, List<T>> categorizedData;
  final Widget Function(BuildContext context, String key, List<T> items) builder;
  final Widget Function(BuildContext context, String key)? headerBuilder;

  const CategorizedListSearchTabContentView({
    super.key,
    required this.categorizedData,
    required this.builder,
    this.headerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: categorizedData.keys.map(
        (key) {
          final items = categorizedData[key] ?? [];
          return SliverStickyHeader(
            header: headerBuilder != null
                ? headerBuilder!(context, key)
                : _buildDefaultHeader(key, items),
            sliver: builder(context, key, items),
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

class ChatMessageCategorizedListView extends CategorizedListSearchTabContentView<ChatMessage> {

  final String searchQuery;

  ChatMessageCategorizedListView({
    Key? key,
    required Map<String, List<ChatMessage>> categorizedData,
    required this.searchQuery,
  }) : super(
    key: key,
    categorizedData: categorizedData,
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