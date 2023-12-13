import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';

///Title: database_item_widget
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/12 12:24
class DatabaseItemWidget extends StatelessWidget {
  List<double>? radiusCornerList; //topLeft、topRight、bottomLeft、bottomRight
  String? iconName;
  String? iconPackage;
  double iconRightMargin;
  String title;
  Color? titleTxtColor;
  bool showMargin;
  bool showDivider;
  bool showArrow;
  bool showSwitch;
  bool switchValue;
  Function() onTapCall;
  final ValueChanged<bool>? onChanged;

  DatabaseItemWidget({
    Key? key,
    this.radiusCornerList,
    this.iconName,
    this.iconPackage,
    this.iconRightMargin = 12,
    this.title = '',
    this.titleTxtColor,
    this.showMargin = false,
    this.showDivider = false,
    this.showArrow = false,
    this.showSwitch = false,
    this.switchValue = false,
    this.onChanged,
    required this.onTapCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTapCall();
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: Adapt.px(10), horizontal: Adapt.px(16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radiusCornerList?[0] ?? 0),
                  topRight: Radius.circular(radiusCornerList?[1] ?? 0),
                  bottomLeft: Radius.circular(radiusCornerList?[2] ?? 0),
                  bottomRight: Radius.circular(radiusCornerList?[3] ?? 0)),
              color: ThemeColor.color180,
            ),
            height: 52.px,
            child: _buildItem(
              leading: iconName != null
                  ? CommonImage(
                      iconName: iconName ?? '',
                      width: Adapt.px(32),
                      height: Adapt.px(32),
                      package: iconPackage ?? 'ox_usercenter',
                    )
                  : null,
              content: title.localized(),
              contentColor: titleTxtColor,
              actions: Row(
                children: [
                  Text(
                    '',
                    style: TextStyle(fontSize: Adapt.px(16), fontWeight: FontWeight.w400, color: ThemeColor.color100),
                  ),
                  Visibility(
                    visible: showSwitch,
                    child: _switchItem(),
                  ),
                  Visibility(
                    visible: showArrow,
                    child: CommonImage(
                      iconName: 'icon_arrow_more.png',
                      width: Adapt.px(24),
                      height: Adapt.px(24),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: showMargin ? 12.px : 0),
          Visibility(
            visible: showDivider,
            child: Container(
              width: double.infinity,
              height: 0.5.px,
              color: ThemeColor.color160,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({String content = '', Widget? leading, Widget? actions, Color? contentColor}) {
    return Row(children: [
      leading ?? const SizedBox(),
      SizedBox(
        width: iconRightMargin.px,
      ),
      Expanded(
        child: Text(
          content,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontSize: 16.px,
            fontWeight: FontWeight.w400,
            color: contentColor ?? ThemeColor.color0,
            height: Adapt.px(22) / Adapt.px(16),
          ),
        ),
      ),
      actions ?? Container()
    ]);
  }

  Widget _switchItem() {
    return Switch(
      value: switchValue,
      activeColor: Colors.white,
      activeTrackColor: ThemeColor.gradientMainStart,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: ThemeColor.color160,
      onChanged: onChanged,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}
