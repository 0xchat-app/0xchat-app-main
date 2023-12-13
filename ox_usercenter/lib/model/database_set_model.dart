import 'package:ox_usercenter/utils/widget_tool.dart';

///Title: database_set_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/12 11:19
class DatabaseSetModel {
  final String iconName;
  final String title;
  final bool showArrow;
  final DatabaseSetItemType settingItemType;

  DatabaseSetModel({
    this.iconName = '',
    this.title = '',
    this.showArrow = false,
    this.settingItemType = DatabaseSetItemType.databasePassphrase,
  });

  static List<DatabaseSetModel> getUIListData() {
    List<DatabaseSetModel> settingModelList = [];
    settingModelList.add(DatabaseSetModel(
      iconName: 'icon_database_key.png',
      title: 'str_database_passphrase',
      showArrow: true,
      settingItemType: DatabaseSetItemType.databasePassphrase,
    ));

    settingModelList.add(DatabaseSetModel(
      iconName: 'icon_database_export.png',
      title: 'str_database_export',
      settingItemType: DatabaseSetItemType.exportDatabase,
    ));
    settingModelList.add(DatabaseSetModel(
      iconName: 'icon_database_import.png',
      title: 'str_database_import',
      settingItemType: DatabaseSetItemType.importDatabase,
    ));
    settingModelList.add(DatabaseSetModel(
      iconName: 'icon_database_archive.png',
      title: 'str_old_database_archive',
      showArrow: true,
      settingItemType: DatabaseSetItemType.databaseArchive,
    ));
    settingModelList.add(DatabaseSetModel(
      iconName: 'icon_database_delete.png',
      title: 'str_database_delete',
      settingItemType: DatabaseSetItemType.deleteDatabase,
    ));

    return settingModelList;
  }
}

enum DatabaseSetItemType {
  databasePassphrase,
  exportDatabase,
  importDatabase,
  databaseArchive,
  deleteDatabase
}


enum TimeType{
  never,
  oneMonth,
  oneWeek,
  oneDay
}

extension TimeTypeEx on TimeType{
  String get text {
    switch (this) {
      case TimeType.never:
        return 'str_database_time_never'.localized();
      case TimeType.oneMonth:
        return 'str_database_time_1_month'.localized();
      case TimeType.oneWeek:
        return 'str_database_time_1_week'.localized();
      case TimeType.oneDay:
        return 'str_database_time_1_day'.localized();
    }
  }
}