///Title: home_tabbar_type
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2024
///@author Michael
///CreateTime: 2024/12/2 17:23
enum HomeTabBarType {
  contact,
  home,
  discover,
  me,
}

extension HomeTabBarTypeEx on HomeTabBarType {

  String get riveFileNames {
    switch (this) {
      case HomeTabBarType.contact:
        return 'Contact';
      case HomeTabBarType.home:
        return 'Home';
      case HomeTabBarType.discover:
        return 'Discover';
      case HomeTabBarType.me:
        return 'Me';
    }
  }

  String get stateMachineNames {
    switch (this) {
      case HomeTabBarType.contact:
        return 'state_machine_contact';
      case HomeTabBarType.home:
        return 'state_machine_home';
      case HomeTabBarType.discover:
        return 'state_machine_discover';
      case HomeTabBarType.me:
        return 'state_machine_me';
    }
  }
}
