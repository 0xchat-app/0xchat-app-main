import 'package:ox_home/model/home_tabbar_type.dart';

///Title: tab_view_info
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2024
///@author Michael
///CreateTime: 2024/12/2 18:54
class TabViewInfo {
  final String moduleName;
  final String modulePage;

  TabViewInfo({
    required this.moduleName,
    required this.modulePage,
  });


  @override
  String toString() {
    return 'TabViewInfo{moduleName: $moduleName, modulePage: $modulePage}';
  }

  static List<TabViewInfo> getTabViewData(List<HomeTabBarType> typeList) {
    List<TabViewInfo> tabViewInfo = [];
    for (HomeTabBarType type in typeList) {
      switch (type) {
        case HomeTabBarType.contact:
          tabViewInfo.add(
            TabViewInfo(
              moduleName: 'ox_chat',
              modulePage: 'contractsPageWidget',
            ),
          );
          break;
        case HomeTabBarType.home:
          tabViewInfo.add(
            TabViewInfo(
              moduleName: 'ox_chat',
              modulePage: 'chatSessionListPageWidget',
            ),
          );
          break;
        case HomeTabBarType.discover:
          tabViewInfo.add(
            TabViewInfo(
              moduleName: 'ox_discovery',
              modulePage: 'discoveryPageWidget',
            ),
          );
          break;
        case HomeTabBarType.me:
          tabViewInfo.add(
            TabViewInfo(
              moduleName: 'ox_usercenter',
              modulePage: 'userCenterPageWidget',
            ),
          );
          break;
      }
    }
    return tabViewInfo;
  }
}
