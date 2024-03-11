import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/error_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:path_provider/path_provider.dart';

///Title: logs_file_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/3/11 15:23
class LogsFilePage extends StatefulWidget {

  const LogsFilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogsFilePageState();
  }
}

class _LogsFilePageState extends State<LogsFilePage> {
  List<File> _filePaths = [];

  @override
  void initState() {
    super.initState();
    _loadLogsFile();
  }

  void _loadLogsFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = directory.listSync();
    for (var file in files) {
      if (file is File && file.path.split("/").last.startsWith('0xchat_log_')) {
        LogUtil.e('John: _loadLogsFile----file.path =${file.path}');
        _filePaths.add(file);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        title: 'Send Log To DEV',
      ),
      body: ListView.builder(
        itemCount: _filePaths.length,
        itemBuilder: (BuildContext context, int index) {
          File file = _filePaths.elementAt(index);
          String fileName = file.path.substring(file.path.lastIndexOf('/')+1);
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              _uploadAndSendLog(file);
            },
            child: Column(
              children: [
                Container(
                  height: 44.px,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12.px),
                  child: Text(
                    fileName,
                    style: TextStyle(color: ThemeColor.color0, fontSize: 16.px, fontWeight: FontWeight.w600),
                  ),
                ),
                Divider(
                  height: Adapt.px(0.5),
                  color: ThemeColor.color160,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _uploadAndSendLog(File file) async {
    OXCommonHintDialog.show(context,
        title: 'Hint',
        content: 'Are you sure you want to send this log file to the developer water783?',
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                OXNavigator.pop(context);
                await OXLoading.show();
                await ErrorUtils.sendLogs(context, file);
                await OXLoading.dismiss();
              }),
        ],
        isRowAction: true);
  }
}
