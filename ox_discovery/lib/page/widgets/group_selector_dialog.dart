import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_discovery/enum/group_type.dart';
import 'package:ox_localizable/ox_localizable.dart';

class GroupSelectorDialog extends StatefulWidget {
  final String title;
  final ValueChanged<GroupType>? onChanged;

  const GroupSelectorDialog({
    Key? key,
    required this.title,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GroupSelectorDialogState();
  }
}

class _GroupSelectorDialogState extends State<GroupSelectorDialog> {
  final List<GroupType> _itemModelList = [GroupType.openGroup,GroupType.channel];

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
      height: (78.5 * (_itemModelList.length + 1) + 8).px,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // SizedBox(
          //   height: 41.px,
          //   child: Center(
          //     child: Text(
          //       widget.title,
          //       style: TextStyle(
          //         fontWeight: FontWeight.w600,
          //         fontSize: 18.sp,
          //         color: ThemeColor.color100,
          //       ),
          //     ),
          //   ),
          // ),
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
                            ),
                            SizedBox(width: 8.px),
                            Text(
                              tempItem.text,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: ThemeColor.color0,
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
                    widget.onChanged?.call(tempItem);
                    OXNavigator.pop(context);
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
      behavior: HitTestBehavior.translucent,
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