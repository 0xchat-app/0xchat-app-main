import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';

///Title: clear_account_selector_dialog
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/7/25 19:39
class ClearAccountSelectorDialog extends StatefulWidget {
  const ClearAccountSelectorDialog({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ClearAccountSelectorDialogState();
  }
}

class _ClearAccountSelectorDialogState extends State<ClearAccountSelectorDialog> {

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
      height: (56 * 2 + 36 + 8).px,
      child: ListView(
        children: [
          Container(
            height: 36.px,
            alignment: Alignment.center,
            child: Text(
              'str_clear_account_dialog_hint'.localized(),
              style: TextStyle(
                fontSize: 16.px,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color0,
              ),
            ),
          ),
          _buildConfirmButton(
            'str_clear_account_dialog_remove'.localized(),
            onTap: () {
              OXNavigator.pop(context, true);
            },
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
