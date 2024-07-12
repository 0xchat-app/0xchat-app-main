import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/user_config_db.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/utils/import_data_tools.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
import 'package:chatcore/chat-core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pick_or_save/pick_or_save.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

///Title:
///Description: TODO(自填)
///Copyright: Copyright (c) 2022
///@author Michael
///CreateTime: 2023/12/17 19:18
class DatabaseHelper{

  static void exportDB(BuildContext context) async {
    bool isChanged = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_IS_CHANGE_DEFAULT_DB_PW, defaultValue: false);
    if (isChanged) {
      String pubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
      String dbFilePath = await DB.sharedInstance.getDatabaseFilePath(pubkey + '.db2');
      final fileName = '0xchat_db '+OXDateUtils.formatTimestamp(DateTime.now().millisecondsSinceEpoch, pattern: 'MM-dd HH:mm')+'.db';
      FileUtils.exportFile(dbFilePath, fileName);
      if (Platform.isAndroid) {
        CommonToast.instance.show(context, 'str_export_success'.localized());
      }
    } else {
      confirmDialog(context, Localized.text('ox_common.tips'), 'str_change_default_pw_hint'.localized(), (){OXNavigator.pop(context);});
    }
  }

  static void importDB(BuildContext context) async {
    bool isChanged = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_IS_CHANGE_DEFAULT_DB_PW, defaultValue: false);
    if (!isChanged) {
      confirmDialog(context, Localized.text('ox_common.tips'), 'str_change_default_pw_hint'.localized(), (){OXNavigator.pop(context);});
      return;
    }
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
              File? file = await FileUtils.importFile();
              if (file != null) {
                OXLoading.show();
                await importDatabase(context, file.path);
                OXLoading.dismiss();
              }
            }),
      ],
    );
  }

  static Future<void> importDatabase(BuildContext context, String path) async {
    String pubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    String currentDBPW = await OXCacheManager.defaultOXCacheManager.getForeverData('dbpw+$pubKey', defaultValue: '');
    String dbNewPath = await DB.sharedInstance.getDatabaseFilePath('imported_database.db');
    String dbOldPath = await DB.sharedInstance.getDatabaseFilePath(pubKey + '.db2');
    await File(path).copy(dbNewPath);
    try {
      await DB.sharedInstance.closDatabase();
      await DB.sharedInstance.open('imported_database.db', version: CommonConstant.dbVersion, password: currentDBPW);
    } catch (e) {
      confirmDialog(context, 'str_import_db_error_title'.localized(), e.toString(), (){OXNavigator.pop(context);});
      return;
    }
    UserConfigDB? userConfigDB = await UserConfigTool.getUserConfigFromDB();
    if (userConfigDB == null || pubKey != userConfigDB.pubKey){
      confirmDialog(context, 'str_import_db_error_title'.localized(), 'str_import_db_error_hint'.localized(), (){OXNavigator.pop(context);});
      return;
    }
    await DB.sharedInstance.closDatabase();

    await ImportDataTools.importTableData(
      sourceDBPath: dbNewPath,
      sourceDBPwd: currentDBPW,
      targetDBPath: dbOldPath,
      targetDBPwd: currentDBPW,
    );

    OXUserInfoManager.sharedInstance.resetData();
    await OXUserInfoManager.sharedInstance.initLocalData();

    await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_CHAT_IMPORT_DB, true);
    confirmDialog(context, 'str_import_db_success'.localized(), 'str_import_db_success_hint'.localized(), (){OXNavigator.pop(context);});
  }

  static Future<void> replaceDatabase(String oldDbPath, String newDbPath) async {
    try {
      final oldDbFile = File(oldDbPath);
      final newDbFile = File(newDbPath);
      if (!await newDbFile.exists()) {
        LogUtil.e("New database file does not exist.");
      }
      if (await oldDbFile.exists()) {
        await oldDbFile.delete();
      }
      await newDbFile.rename(oldDbPath);
      LogUtil.d('Database has been replaced successfully');
    } catch (e) {
      LogUtil.e('Failed to replace database: $e');
    }
  }

  static void deleteDB(BuildContext context) {
    String pubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    OXCommonHintDialog.show(
      context,
      title: 'str_delete_chat_profile'.localized(),
      content: 'str_delete_chat_profile_hint'.localized(),
      isRowAction: true,
      actionList: [
        OXCommonHintAction(
            text: () => Localized.text('ox_common.cancel'),
            onTap: () {
              OXNavigator.pop(context);
            }),
        OXCommonHintAction(
            text: () => 'str_delete'.localized(),
            onTap: () async {
              OXNavigator.pop(context);
              try {
                await OXLoading.show();
                await OXUserInfoManager.sharedInstance.logout();
                await DB.sharedInstance.closDatabase();
                await DB.sharedInstance.deleteDatabaseFile(pubkey + '.db2');
              } catch (e) {
                print(e.toString());
              }
              await OXLoading.dismiss();
              deleteDBAndLoginDialog(context);
            }),
      ],
    );
  }

  static void deleteDBAndLoginDialog(context) {
    OXCommonHintDialog.show(
      context,
      title: 'str_delete_login_dialog_title'.localized(),
      content: 'str_delete_login_dialog_hint'.localized(),
      isRowAction: true,
      actionList: [
        OXCommonHintAction(
            text: () => Localized.text('ox_common.ok'),
            onTap: () async {
              OXNavigator.pop(context);
              OXNavigator.pop(context);
            }),
      ],
    );
  }

  static Future<bool> deleteFileAndMedia(BuildContext context) async {
    // var result = await showModalBottomSheet(
    //   context: context,
    //   backgroundColor: Colors.transparent,
    //   builder: (BuildContext context) {
    //     return const DeleteFilesSelectorDialog();
    //   },
    // );
    final result = await OXCommonHintDialog.show(
      context,
      title: 'str_delete_file_dialog_title'.localized(),
      content: 'str_delete_file_dialog_hint'.localized(),
      isRowAction: true,
      actionList: [
        OXCommonHintAction(
            text: () => Localized.text('ox_common.cancel'),
            onTap: () {
              OXNavigator.pop(context, false);
            }),
        OXCommonHintAction(
            text: () => 'str_delete'.localized(),
            onTap: () async {
              OXNavigator.pop(context, true);
              try {
                await OXLoading.show();
                await DefaultCacheManager().emptyCache();//clearCachedImages
                await clearCache();
                CommonToast.instance.show(context, 'str_file_delected'.localized());
              } catch (e) {
                print(e.toString());
              }
              await OXLoading.dismiss();
            }),
      ],
    );
    return result;
  }

  static Future<void> clearCache() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.listSync().forEach((file) {
        if (file is File) {
          file.deleteSync();
        } else if (file is Directory) {
          file.deleteSync(recursive: true);
        }
      });
    }
  }

  static Future<int> getCacheFileCount() async {
    int fileCount = 0;
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      try {
        await for (var entity in cacheDir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            fileCount++;
          }
        }
      } catch (e) {
        print("Error calculating file count: $e");
      }
    }

    return fileCount;
  }

  static int getDirectoryFileCount(Directory dir) {
    int count = 0;
    try {
      dir.listSync().forEach((file) {
        if (file is File) {
          count++;
        } else if (file is Directory) {
          count += getDirectoryFileCount(file);
        }
      });
    } catch (e) {
      print(e.toString());
    }
    return count;
  }

  static Future<double> getCacheSizeInMB() async {
    int totalSize = 0;
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      try {
        await for (var entity in cacheDir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      } catch (e) {
        print("Error calculating directory size: $e");
      }
    }
    return totalSize / (1024 * 1024);
  }

  static void confirmDialog( BuildContext context, String titleStr, String contentStr, Function onTap) {
    OXCommonHintDialog.show(
      context,
      title: titleStr,
      content: contentStr,
      isRowAction: true,
      actionList: [
        OXCommonHintAction(
            text: () => Localized.text('ox_common.ok'),
            onTap: onTap),
      ],
    );
  }
}