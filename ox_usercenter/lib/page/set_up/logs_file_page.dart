import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
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
  double  fillH = 200;

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
    fillH = Adapt.screenH() - 60.px - 30.px - 70.px * _filePaths.length;
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 12.px, left: 24.px, right: 24.px),
              child: Text(
                'str_send_log_to_dev_hint'.localized(),
                style: TextStyle(
                    color: ThemeColor.color100, fontSize: 12.px, fontWeight: FontWeight.w400, height: 1.4),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return _itemBuild(context, index);
              },
              childCount: _filePaths.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: fillH < Adapt.screenH() ? fillH.abs() : 50.px),
          ),
        ],
      ),
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
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
                        style: TextStyle(
                            color: ThemeColor.color0, fontSize: 16.px, fontWeight: FontWeight.w400, height: 1.4),
                      ),
                      Text(
                        fileName,
                        style: TextStyle(
                            color: ThemeColor.color100, fontSize: 14.px, fontWeight: FontWeight.w400, height: 1.4),
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
  }
}
