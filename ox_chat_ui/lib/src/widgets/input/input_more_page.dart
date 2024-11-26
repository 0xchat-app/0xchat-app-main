

import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';

class InputMoreItem {
  const InputMoreItem({required this.id, required this.title, required this.iconName, required this.action,});
  final String id;
  final String Function() title;
  final String iconName;
  final Function(BuildContext context) action;
}

class InputMorePage extends StatefulWidget {
  const InputMorePage({super.key, required this.items});

  final List<InputMoreItem> items;

  @override
  State<InputMorePage> createState() => _InputMorePageState();
}

class _InputMorePageState extends State<InputMorePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final maxAvailableWidth = MediaQuery.of(context).size.width - MediaQuery.of(context).padding.horizontal;
    final margin = EdgeInsets.only(top: 4.px);
    final padding = EdgeInsets.symmetric(
      horizontal: 14.px,
      vertical: 20.px,
    );
    final crossAxisCount = 4;
    final crossAxisSpacing = 22.px;

    final iconSize = 48.px;
    final iconPadding = EdgeInsets.only(bottom: 8.px);
    final itemTitleFont = 12;
    final itemWidth = ((maxAvailableWidth - Adapt.px(12) * 2 - margin.horizontal * 2 - padding.horizontal * 2 - (crossAxisCount - 1) * crossAxisSpacing) / crossAxisCount).floor();
    final itemHeight = (iconSize + iconPadding.top + iconPadding.bottom + itemTitleFont.spWithTextScale * 1.2).ceil();

    final childAspectRatio = itemWidth / itemHeight;
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color190,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: margin,
        child: GridView.count(
          crossAxisCount: crossAxisCount, // The number of columns displayed per row
          childAspectRatio: childAspectRatio,
          padding: padding,
          mainAxisSpacing: 12.px, // Line spacing
          crossAxisSpacing: crossAxisSpacing, // Space between columns
          children: List.generate(widget.items.length, (index) {
            final item = widget.items[index];
            return GestureDetector(
              child: Container(
                color: Colors.transparent, // Background color for each grid
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: ThemeColor.color180,
                      ),
                      margin: iconPadding,
                      child: Center(
                        child: CommonImage(
                          iconName: item.iconName,
                          size: 24.px,
                          package: 'ox_chat_ui',
                        ),
                      ),
                    ),
                    Text(
                      '${item.title()}',
                      style: TextStyle(
                        fontSize: itemTitleFont.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              onTap: () => item.action(context),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildItem(InputMoreItem item) =>
    GestureDetector(
      child: Container(
        color: Colors.transparent, // Background color for each grid
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Adapt.px(48),
              height: Adapt.px(48),
              margin: EdgeInsets.only(bottom: Adapt.px(8)),
              child: CommonImage(
                iconName: item.iconName,
                package: 'ox_chat_ui',
                useTheme: true,
              ),
            ),
            Text(
              '${item.title()}',
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
      onTap: () => item.action(context),
    );
}
