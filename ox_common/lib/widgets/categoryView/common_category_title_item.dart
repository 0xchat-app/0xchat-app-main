

import 'dart:ui';

/// A tab to display in a [DotNavigationBar]
class CommonCategoryTitleItem {
    /// An icon to display.
    final String title;
    final String selectedIconName;
    final String unSelectedIconName;

    CommonCategoryTitleItem({
        required this.title,
        required this.selectedIconName,
        required this.unSelectedIconName,
    });
}