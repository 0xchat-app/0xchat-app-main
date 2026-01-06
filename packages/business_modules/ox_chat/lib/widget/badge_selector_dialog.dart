import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/model/badge_model.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

class BadgeSelectorDialog extends StatefulWidget {
  List<BadgeModel> badgeList = [];

  BadgeSelectorDialog(this.badgeList);

  @override
  State<StatefulWidget> createState() {
    return _BadgeSelectorDialogState();
  }
}

class _BadgeSelectorDialogState extends State<BadgeSelectorDialog> {
  List<BadgeModel> _itemModelList = [];

  @override
  void initState() {
    super.initState();
    _itemModelList = widget.badgeList;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3;
    Widget placeholderImage = CommonImage(
      iconName: 'icon_badge_default.png',
      fit: BoxFit.cover,
      width: Adapt.px(32),
      height: Adapt.px(32),
      useTheme: true,
    );
    return Container(
      height: Adapt.px(390),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: ListView(
        children: [
          for (var tempItem in _itemModelList)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                height: Adapt.px(56),
                padding: EdgeInsets.symmetric(vertical: Adapt.px(12)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ThemeColor.color170,
                      width: Adapt.px(0.5),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width,
                    ),
                    OXCachedNetworkImage(
                      imageUrl: tempItem.badgeImageUrl ?? '',
                      fit: BoxFit.contain,
                      placeholder: (context, url) => placeholderImage,
                      errorWidget: (context, url, error) => placeholderImage,
                      width: Adapt.px(32),
                      height: Adapt.px(32),
                    ),
                    SizedBox(
                      width: Adapt.px(10),
                    ),
                    Text(
                      tempItem.badgeName ?? '',
                      style: TextStyle(
                        fontSize: Adapt.px(16),
                        fontWeight: FontWeight.w400,
                        color: ThemeColor.color0,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                OXNavigator.pop(context, tempItem);
              },
            ),
          _buildConfirmButton(
            Localized.text('ox_common.none'),
            onTap: () {
              OXNavigator.pop(context, Localized.text('ox_common.none'));
            },
          ),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildConfirmButton(
            Localized.text('ox_common.cancel'),
            onTap: () {
              OXNavigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(String label, {GestureTapCallback? onTap}) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        height: Adapt.px(56),
        child: Text(
          label,
          style: TextStyle(fontSize: Adapt.px(16), fontWeight: FontWeight.w400),
        ),
      ),
      onTap: onTap,
    );
  }
}
