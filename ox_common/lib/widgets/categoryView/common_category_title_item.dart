

/// A tab to display in a [DotNavigationBar]
class CommonCategoryTitleItem {
    /// An icon to display.
    final String title;
    String? selectedIconName;
    String? unSelectedIconName;

    CommonCategoryTitleItem({
        required this.title,
        this.selectedIconName,
        this.unSelectedIconName,
    });
}