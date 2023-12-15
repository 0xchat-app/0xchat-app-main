import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/ox_relay_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/model/database_set_model.dart';
import 'package:ox_usercenter/page/set_up/database_passphrase.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
import 'package:ox_usercenter/widget/database_item_widget.dart';
import 'package:ox_usercenter/widget/time_selector_dialog.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';



///Title: database_setting_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/11 16:04
class DatabaseSettingPage extends StatefulWidget {
  const DatabaseSettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DatabaseSettingPageState();
  }
}

class DatabaseSettingPageState extends State<DatabaseSettingPage> {
  bool _chatRunStatus = true;
  int _selectedTimeCode = TimeType.never.code;
  TimeType _selectedTimeType = TimeType.never;
  List<DatabaseSetModel> _databaseModelList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _databaseModelList = DatabaseSetModel.getUIListData();
    _selectedTimeCode = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_CHAT_MSG_DELETE_TIME_TYPE, defaultValue: TimeType.never.code);
    _selectedTimeType = getType(_selectedTimeCode);
    _chatRunStatus = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_CHAT_RUN_STATUS, defaultValue: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        centerTitle: true,
        useLargeTitle: false,
        title: 'str_chat_database'.localized(),
      ),
      backgroundColor: ThemeColor.color190,
      body: _body(),
    );
  }

  Widget _body() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _topWidget(),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _itemBuild(context, index);
            },
            childCount: _databaseModelList.length,
          ),
        ),
        SliverToBoxAdapter(
          child: _bottomWidget(),
        ),
      ],
    ).setPadding(EdgeInsets.symmetric(horizontal: 24.px));
  }

  Widget _bottomWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.px),
        abbrText('str_file_and_media'.localized(), 14, ThemeColor.color0),
        SizedBox(height: 12.px),
        Opacity(
          opacity: _getItemOpacity(),
          child: DatabaseItemWidget(
            onTapCall: () {},
            radiusCornerList: [16.px, 16.px, 16.px, 16.px],
            switchValue: _chatRunStatus,
            title: 'str_delete_all_files',
            titleTxtColor: ThemeColor.red,
            iconRightMargin: 0,
          ),
        ),
        SizedBox(height: 12.px),
        abbrText('str_delete_all_file_hint'.localized(), 12, ThemeColor.color100), //or like "1 file(s) with total size of 2.02 MB"
        SizedBox(height: 16.px),
      ],
    );
  }

  Widget _topWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        abbrText('str_run_chat'.localized(), 14, ThemeColor.color0),
        SizedBox(height: 12.px),
        DatabaseItemWidget(
          onTapCall: () {},
          onChanged: _stopConfirmDialog,
          radiusCornerList: [16.px, 16.px, 16.px, 16.px],
          showSwitch: true,
          switchValue: _chatRunStatus,
          title: _chatRunStatus ? 'str_chat_running' : 'str_chat_stopped',
          iconRightMargin: 0,
        ),
        SizedBox(height: 12.px),
        abbrText(_chatRunStatus ? 'str_chat_stopped_hint'.localized() : 'str_chat_running_hint'.localized(), 12, ThemeColor.color100),
        SizedBox(height: 16.px),
        abbrText('str_database_messages'.localized(), 14, ThemeColor.color0),
        SizedBox(height: 12.px),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.px),
            color: ThemeColor.color180,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 15.px),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  abbrText('str_database_delete_msg_after'.localized(), 16, ThemeColor.color0),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _showDeleteTimeDialog();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedTimeType.text,
                          style: TextStyle(
                            color: ThemeColor.color100,
                            fontSize: 14.px,
                          ),
                        ),
                        CommonImage(iconName: 'icon_database_delete_time_more.png', width: 24, height: 24, package: 'ox_usercenter'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.px),
              abbrText('str_database_delete_msg_after_hint'.localized(), 12, ThemeColor.color100),
            ],
          ),
        ),
        SizedBox(height: 16.px),
        abbrText('str_database_chat_title'.localized(), 14, ThemeColor.color0),
        SizedBox(height: 12.px),
      ],
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    DatabaseSetModel model = _databaseModelList[index];
    return Opacity(
      opacity: _getItemOpacity(),
      child: DatabaseItemWidget(
        radiusCornerList: index == 0
            ? [16.px, 16.px, 0, 0]
            : index == _databaseModelList.length - 1
                ? [0, 0, 16.px, 16.px]
                : null,
        onTapCall: () {
          _onItemTap(model.settingItemType);
        },
        showArrow: index == 0 ? true : false,
        title: model.title,
        iconName: model.iconName,
        showDivider: index == _databaseModelList.length - 1 ? false : true,
      ),
    );
  }

  double _getItemOpacity() {
    if (_chatRunStatus) {
      return 0.5;
    } else {
      return 1;
    }
  }

  void _onItemTap(DatabaseSetItemType type) {
    if (_chatRunStatus) {
      return;
    }
    switch (type) {
      case DatabaseSetItemType.databasePassphrase:
        OXNavigator.pushPage(context, (context) => const DatabasePassphrase());
        break;
      case DatabaseSetItemType.exportDatabase:
        _exportDB();
        break;
      case DatabaseSetItemType.importDatabase:
        _importDB();
        break;
      case DatabaseSetItemType.databaseArchive:
        break;
      case DatabaseSetItemType.deleteDatabase:
        break;
    }
  }

  void _stopConfirmDialog(bool value) {
    if (_chatRunStatus) {
      OXCommonHintDialog.show(
        context,
        title: 'str_stop_chat'.localized(),
        content: 'str_stop_chat_hint'.localized(),
        isRowAction: true,
        actionList: [
          OXCommonHintAction(
              text: () => Localized.text('ox_common.cancel'),
              onTap: () {
                OXNavigator.pop(context);
              }),
          OXCommonHintAction(
              text: () => 'str_stop_button'.localized(),
              onTap: () {
                OXNavigator.pop(context);
                _onChangedChatRunStatus(value);
              }),
        ],
      );
    } else {
      _onChangedChatRunStatus(value);
    }
  }

  void _onChangedChatRunStatus(bool value) async {
    await OXLoading.show();
    if (value != _chatRunStatus) {
      _chatRunStatus = value;
      await Future.forEach(OXRelayManager.sharedInstance.relayModelList, (element) async {
        await Connect.sharedInstance.closeConnect(element.relayName );
      });
      await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_CHAT_RUN_STATUS, _chatRunStatus);
    }
    await OXLoading.dismiss();
    setState(() {});
  }

  void _exportDB() async {
    String pubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    String dbFilePath = await OXCommon.getDatabaseFilePath(pubkey + ".db2");
    final fileName = '0xchat_db '+OXDateUtils.formatTimestamp(DateTime.now().millisecondsSinceEpoch)+'.db';

    _fileSaver(FileSaverParams(
      saveFiles: [
        SaveFileInfo(
          fileName: fileName,
          filePath: dbFilePath,
        ),
      ],
    ));
  }

  void _importDB() async {
    OXCommonHintDialog.show(
      context,
      title: 'str_import_db_dialog_title'.localized(),
      content: 'str_import_db_dialog_content'.localized(),
      isRowAction: true,
      actionList: [
        OXCommonHintAction(
            text: () => Localized.text('ox_common.cancel'),
            onTap: () {
              OXNavigator.pop(context);
            }),
        OXCommonHintAction(
            text: () => 'str_import_db_dialog_import'.localized(),
            onTap: () async {
              OXNavigator.pop(context);
              File? file = await pickDatabaseFile();
              LogUtil.e('Michael: ----file =${file?.path}');
            }),
      ],
    );
  }

  Future<void> importDatabase(String path) async {
    //Copy the file to the app's sandbox directory.
    final Directory directory = await getApplicationDocumentsDirectory();
    final String newPath = directory.path + '/imported_database.db';
    await File(path).copy(newPath);

    // TODO : open this database and read the data.
  }


  Future<File?> pickDatabaseFile() async {
    LogUtil.e('Michael: -pickDatabaseFile---file.path  ');
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'db',
      extensions: <String>['db'],
    );
    final XFile? file =
    await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (file != null) {
      LogUtil.e('Michael: -pickDatabaseFile---file.path =${file.path}');
      return File(file.path);
    } else {
      // User canceled the picker
      return null;
    }
  }

  Future<void> saveFileToSelectedFolder(String filePath, String targetPath) async {
    final File sourceFile = File(filePath);
    final File targetFile = File(targetPath);

    try {
      await sourceFile.copy(targetFile.path);
      print('File saved to $targetPath');
    } catch (e) {
      print('Failed to save file: $e');
    }
  }


  final _pickOrSavePlugin = PickOrSave();
  Future<List<String>?> _fileSaver(FileSaverParams params) async {
    List<String>? result;
    try {
      result = await _pickOrSavePlugin.fileSaver(params: params);
    } on PlatformException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return result;

    return result;
  }

  TimeType getType(int value) {
    switch (value) {
      case 0:
        return TimeType.never;
      case 1:
        return TimeType.oneMonth;
      case 2:
        return TimeType.oneWeek;
      case 3:
        return TimeType.oneDay;
    }
    return TimeType.never;
  }

  void _showDeleteTimeDialog() async {
    var result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const TimeSelectorDialog();
      },
    );
    if (result != null) {
      if (result is TimeType) {
          _selectedTimeType = result;
          await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_CHAT_MSG_DELETE_TIME_TYPE,   _selectedTimeType.code);
          await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_CHAT_MSG_DELETE_TIME,   _selectedTimeType.value);
          setState(() {});
      }
    }
  }
}
