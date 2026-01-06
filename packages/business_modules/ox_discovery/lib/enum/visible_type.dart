import 'package:ox_localizable/ox_localizable.dart';

enum VisibleType {
  everyone,
  allContact,
  private,
  excludeContact,
  // includeContact(name: 'Selected User', illustrate: 'Just Selected Contacts');
}

extension VisibleTypeExtension on VisibleType {
  String get name {
    switch (this) {
      case VisibleType.everyone:
        return Localized.text('ox_discovery.visible_everyone');
      case VisibleType.allContact:
        return Localized.text('ox_discovery.visible_my_contact');
      case VisibleType.private:
        return Localized.text('ox_discovery.visible_private');
      case VisibleType.excludeContact:
        return Localized.text('ox_discovery.visible_selected_friends');
    }
  }

  String get illustrate {
    switch (this) {
      case VisibleType.everyone:
        return Localized.text('ox_discovery.visible_everyone_description');
      case VisibleType.allContact:
        return Localized.text('ox_discovery.visible_my_contact_description');
      case VisibleType.private:
        return Localized.text('ox_discovery.visible_private_description');
      case VisibleType.excludeContact:
        return Localized.text('ox_discovery.visible_selected_friends_description');
    }
  }
}
