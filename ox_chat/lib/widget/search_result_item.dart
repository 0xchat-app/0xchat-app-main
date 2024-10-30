import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/avatar.dart';

class SearchResultItem extends StatelessWidget {
  final bool isUser;
  final String searchQuery;
  final String? avatarURL;
  final String? title;
  final String? subTitle;
  final VoidCallback? onTap;

  const SearchResultItem({
    super.key,
    required this.isUser,
    required this.searchQuery,
    this.avatarURL,
    this.title,
    this.subTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarWidget = isUser
        ? OXUserAvatar(imageUrl: avatarURL)
        : OXChannelAvatar(imageUrl: avatarURL);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        height: Adapt.px(72),
        child: Row(
          children: [
            avatarWidget.setPadding(
                EdgeInsets.only(left: Adapt.px(0), right: Adapt.px(16))),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '',
                    overflow: TextOverflow.ellipsis,
                  ).setPadding(EdgeInsets.only(bottom: Adapt.px(2))),
                  subTitle == null || subTitle!.isEmpty ? SizedBox() : _highlightText(subTitle!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightText(String mainText, {int? maxLines = 1}) {
    final searchText = searchQuery;
    final normalTextStyle = TextStyle(
      fontSize: Adapt.px(14),
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
