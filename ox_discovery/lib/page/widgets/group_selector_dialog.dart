import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

class GroupSelectorDialog extends StatefulWidget {
  final String title;

  const GroupSelectorDialog({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GroupSelectorDialogState();
  }
}

class _GroupSelectorDialogState extends State<GroupSelectorDialog> {
  final List<GroupType> _itemModelList = GroupType.values;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.px),
        color: ThemeColor.color180,
      ),
      height: (78.5 * (_itemModelList.length + 1) + 41 + 8).px,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 41.px,
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: ThemeColor.color100,
                ),
              ),
            ),
          ),
          for (var tempItem in _itemModelList)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  color: ThemeColor.color170,
                  height: Adapt.px(0.5),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 78.px,
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.px,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CommonImage(
                              iconName: tempItem.typeIcon,
                              size: 24.px,
                              package: 'ox_chat',
                              useTheme: true,
                            ),
                            SizedBox(width: 8.px),
                            Text(
                              tempItem.text,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: ThemeColor.color100,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.px),
                        Text(
                          tempItem.groupDesc,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: ThemeColor.color100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    OXNavigator.pop(context, tempItem);
                  },
                ),
              ],
            ),
          Container(
            height: 8.px,
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
        height: 56.px,
        child: Text(
          label,
          style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w400),
        ),
      ),
      onTap: onTap,
    );
  }
}


enum GroupType{
  channel,
  openGroup,
  privateGroup,
}

extension GroupTypeEx on GroupType{
  String get text {
    switch (this) {
      case GroupType.openGroup:
        return Localized.text('ox_chat.str_group_type_open');
      case GroupType.privateGroup:
        return Localized.text('ox_chat.str_group_type_private');
      case GroupType.channel:
        return Localized.text('ox_common.str_new_channel');
    }
  }

  String get typeIcon {
    switch (this) {
      case GroupType.openGroup:
        return 'icon_type_open_group.png';
      case GroupType.privateGroup:
        return 'icon_type_private_group.png';
      case GroupType.channel:
        return 'icon_type_channel.png';
    }
  }

  String get groupDesc {
    switch (this) {
      case GroupType.openGroup:
        return Localized.text('ox_chat.str_group_open_description');
      case GroupType.privateGroup:
        return Localized.text('ox_chat.str_group_private_description');
      case GroupType.channel:
        return 'Channel description';
    }
  }
}