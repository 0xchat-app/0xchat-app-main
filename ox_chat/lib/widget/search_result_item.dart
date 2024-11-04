import 'package:flutter/material.dart';
import 'package:ox_chat/utils/search_result_utils.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/avatar.dart';

enum SearchResultItemType {
  contact,
  group,
  relayGroup,
  channel,
}

class SearchResultItem extends StatelessWidget {
  final String searchQuery;
  final SearchResultItemType type;
  final String pubkey;
  final String? avatarURL;
  final String? title;
  final String? subTitle;
  final VoidCallback? onTap;

  const SearchResultItem({
    super.key,
    required this.searchQuery,
    required this.type,
    required this.pubkey,
    this.avatarURL,
    this.title,
    this.subTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarWidget = type == SearchResultItemType.contact
        ? OXUserAvatar(imageUrl: avatarURL)
        : OXChannelAvatar(imageUrl: avatarURL);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        height: 72.px,
        child: Row(
          children: [
            avatarWidget.setPadding(EdgeInsets.only(right: 16.px)),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  subTitle == null || subTitle!.isEmpty ? SizedBox() : _highlightText(subTitle!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    ValueNotifier? valueNotifier = SearchResultItemUtils.getValueNotifier(this);

    Widget getText(String text) {
      return Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: ThemeColor.color0,
          fontSize: 14.px,
          fontWeight: FontWeight.w600
        ),
      ).setPadding(EdgeInsets.only(bottom: 2.px));
    }

    if (valueNotifier == null) return getText(title ?? '');
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, child) => getText(value.name),
    );
  }

  Widget _highlightText(String mainText, {int? maxLines = 1}) {
    final searchText = searchQuery;
    final normalTextStyle = TextStyle(
      fontSize: 14.px,
      fontWeight: FontWeight.w400,
      color: ThemeColor.color120,
    );
    final highlightTextStyle = normalTextStyle.copyWith(
      color: ThemeColor.color10,
    );

    final mainTextLower = mainText.toLowerCase();
    final searchTextLower = searchText.toLowerCase();
    final splitText = mainTextLower.split(searchTextLower);

    var startIndex = 0;
    List<InlineSpan> spans = [];
    for (int i = 0; i < splitText.length; i++) {
      int endIndexOfToken = startIndex + splitText[i].length;

      spans.add(TextSpan(
        text: mainText.substring(startIndex, endIndexOfToken),
        style: normalTextStyle,
      ));

      if (i < splitText.length - 1) {
        spans.add(TextSpan(
          text: mainText.substring(
              endIndexOfToken, endIndexOfToken + searchText.length),
          style: highlightTextStyle,
        ));
      }
      startIndex = endIndexOfToken + searchText.length;
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
    );
  }
}