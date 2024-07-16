import 'package:flutter/material.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/model/search_chat_model.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: group_share_menu_dialog
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/7/16 12:56
class GroupShareMenuDialog extends StatefulWidget {
  final String titleTxT;

  const GroupShareMenuDialog({Key? key, required this.titleTxT}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GroupShareMenuDialogState();
  }
}

class _GroupShareMenuDialogState extends State<GroupShareMenuDialog> {
  List<GroupMenuType> _itemModelList = GroupMenuType.values;

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
      height: (60.5 * (_itemModelList.length + 1) + 41 + 8).px,
      child: ListView(
        children: [
          SizedBox(
            height: 41.px,
            child: Center(
              child: MyText(widget.titleTxT, 18.sp, ThemeColor.color100, fontWeight: FontWeight.w600),
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
                    height: 60.px,
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.px,
                    ),
                    child: MyText(tempItem.text, 16.sp, ThemeColor.color0, fontWeight: FontWeight.w400),
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
