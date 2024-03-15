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
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/page/set_up/dev_log_detail_page.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
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
    _filePaths.sort((a, b) {
      DateTime aModified = a.lastModifiedSync();
      DateTime bModified = b.lastModifiedSync();
      return bModified.compareTo(aModified);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        title: 'str_dev_log'.localized(),
        backgroundColor: ThemeColor.color200,
      ),
      body: ListView.builder(
        itemCount: _filePaths.length,
        itemBuilder: (BuildContext context, int index) {
          File file = _filePaths.elementAt(index);
          String fileName = file.path.substring(file.path.lastIndexOf('/') + 1);
          String timestampStr = fileName.split('_').last.split('.').first;
          int timestamp = int.parse(timestampStr);
          String fileChangedTime = OXDateUtils.formatTimestamp(timestamp, pattern: 'yyyy-MM-dd HH:mm:ss');
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              OXNavigator.pushPage(context, (context) => DevLogDetailPage(file: file));
            },
            child: Column(
              children: [
                SizedBox(height: 12.px),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.px),
                    color: ThemeColor.color180,
                  ),
                  child: Container(
                    height: 58.px,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fileChangedTime,
                              style: TextStyle(color: ThemeColor.color0, fontSize: 16.px, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              fileName,
                              style: TextStyle(color: ThemeColor.color0, fontSize: 16.px, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        CommonImage(
                          iconName: 'icon_arrow_more.png',
                          width: 24.px,
                          height: 24.px,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
          );
        },
      ),
    );
  }


}
