import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/model/database_set_model.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';

///Title: delete_files_selector_dialog
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/17 14:39
class DeleteFilesSelectorDialog extends StatefulWidget {
  const DeleteFilesSelectorDialog({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DeleteFilesSelectorDialogState();
  }
}

class _DeleteFilesSelectorDialogState extends State<DeleteFilesSelectorDialog> {

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
      height: (56 * 5 + 8).px,
      child: ListView(
        children: [
          Container(
            height: 36.px,
            padding: EdgeInsets.symmetric(vertical: 12.px),
            alignment: Alignment.center,
            child: Text(
              'str_delete_file_dialog_title'.localized(),
              style: TextStyle(
                fontSize: 16.px,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color0,
              ),
            ),
          ),
          _buildConfirmButton(
            'str_delete_file_dia'.localized(),
            onTap: () {
              OXNavigator.pop(context);
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
