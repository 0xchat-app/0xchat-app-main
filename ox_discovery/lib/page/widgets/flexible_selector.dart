import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';

enum SelectionType {
  single,
  multiple
}

class FlexibleSelector extends StatefulWidget {
  final String title;
  final String subTitle;
  final String content;
  final SelectionType type;
  final bool isSelected;
  final VoidCallback? onChanged;

  const FlexibleSelector({
    super.key,
    required this.title,
    required this.subTitle,
    SelectionType? type,
    bool? isSelected,
    String? content,
    this.onChanged,
  })  : type = type ?? SelectionType.single,
        isSelected = isSelected ?? false,
        content = content ?? '';

  @override
  State<FlexibleSelector> createState() => _FlexibleSelectorState();
}

class _FlexibleSelectorState extends State<FlexibleSelector> {

  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.onChanged?.call(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: 16.px,
                    fontWeight: FontWeight.w400,
                    color: ThemeColor.color0,
                    height: 22.px / 16.px
                ),
              ),
              SizedBox(width: 8.px,),
              const Spacer(),
              _buildOptions(widget.type),
            ],
          ).setPaddingOnly(top: 1.px),
          Text(
            widget.subTitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 14.px,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color100,
                height: 20.px / 16.px
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(SelectionType type){
    switch(type) {
      case SelectionType.single:
        return CommonImage(
          iconName: _isSelected ? 'icon_selected.png' : 'icon_unSelected.png',
          package: 'ox_discovery',
          useTheme: true,
          size: 24.px,
        );
      case SelectionType.multiple:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 150.px,
              child: Text(
                widget.content,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.w400,
                  color: ThemeColor.gradientMainStart,
                  height: 20.px / 14.px
                ),
              ),
            ),
            CommonImage(
              iconName: 'icon_arrow_more.png',
              size: 24.px,
            )
          ],
        );
    }
  }

  @override
  void didUpdateWidget(covariant FlexibleSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      _isSelected = !_isSelected;
    }
  }
}
