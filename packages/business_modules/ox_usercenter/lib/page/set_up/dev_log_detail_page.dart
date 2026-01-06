import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/error_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';

///Title: dev_log_detail_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/3/15 17:13
class DevLogDetailPage extends StatefulWidget {
  final File file;

  DevLogDetailPage({Key? key, required this.file}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DevLogDetailPageState();
  }
}

class _DevLogDetailPageState extends State<DevLogDetailPage> {
  late File _file;
  String _fileChangedTime = '';
  String _fileContent = '';

  @override
  void initState() {
    super.initState();
    _file = widget.file;
    String fileName = _file.path.substring(_file.path.lastIndexOf('/') + 1);
    String timestampStr = fileName.split('_').last.split('.').first;
    int timestamp = int.parse(timestampStr);
    _fileChangedTime = OXDateUtils.formatTimestamp(timestamp, pattern: 'yyyy-MM-dd HH:mm:ss');
    _loadData(_file);
  }

  void _loadData(File file) async {
    _fileContent = await file.readAsString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'str_send_dev_log_detail'.localized(),
        backgroundColor: ThemeColor.color200,
      ),
      backgroundColor: ThemeColor.color200,
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        SizedBox(height: 12.px),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.px),
            color: ThemeColor.color180,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70.px,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'str_log_filemtime'.localized(),
                      style: TextStyle(
                        fontSize: 14.px,
                        color: ThemeColor.color100,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      _fileChangedTime,
                      style: TextStyle(
                        fontSize: 14.px,
                        color: ThemeColor.color0,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px),
              ),
              Container(
                width: double.infinity,
                height: 0.5.px,
                color: ThemeColor.color160,
              ),
              SizedBox(height: 12.px),
              Container(
                padding: EdgeInsets.only(left: 16.px),
                child: Text(
                  'str_dev_log'.localized(),
                  style: TextStyle(
                    fontSize: 14.px,
                    color: ThemeColor.color100,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16.px),
                height: 200.px,
                child: SingleChildScrollView(
                  child: Text(
                    _fileContent,
                    style: TextStyle(
                      fontSize: 12.px,
                      color: ThemeColor.color0,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
        SizedBox(height: 24.px),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _uploadAndSendLog,
          child: Container(
            width: double.infinity,
            height: Adapt.px(48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ThemeColor.color180,
              gradient: LinearGradient(
                colors: [
                  ThemeColor.gradientMainEnd,
                  ThemeColor.gradientMainStart,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'str_send_log_to_dev'.localized(),
              style: TextStyle(
                color: Colors.white,
                fontSize: Adapt.px(16),
              ),
            ),
          ),
        ),
      ],
    ).setPadding(EdgeInsets.symmetric(horizontal: 24.px));
  }

  void _uploadAndSendLog() async {
    OXCommonHintDialog.show(context,
        title: Localized.text('ox_common.tips'),
        content:
        'str_send_log_to_dev_dialog_content'.localized()+' (npub10td4yrp6cl9kmjp9x5yd7r8pm96a5j07lk5mtj2kw39qf8frpt8qm9x2wl)?',
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                OXNavigator.pop(context);
                await OXLoading.show();
                await ErrorUtils.sendLogs(context, _file);
                await OXLoading.dismiss();
              }),
        ],
        isRowAction: true);
  }
}
