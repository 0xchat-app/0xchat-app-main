library dot_navigation_bar;
export 'common_category_title_item.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/categoryView/common_category_title_item.dart';


class CommonCategoryTitleView extends StatelessWidget {
    CommonCategoryTitleView({
        Key? key,
        required this.items,
        this.selectedColor = Colors.black,
        this.unselectedColor = Colors.black26,
        this.bgColor = Colors.white,
        required this.selectedIndex,
        required this.onTap,
        this.height = 45.0,
        this.width = 0,
        this.verticalPadding = 25.0,
        this.horizontalPadding = 20.0,
        this.selectedFontSize = 20,
        this.unSelectedFontSize = 20,
        this.gradient,
        this.gradientWidth = 16,
        required this.selectedGradientColors,
        required this.unselectedGradientColors,
    })  : assert(items.length >= 2),
          assert(items.length <= 6);
    // assert(mainTranslucentNavigationBarItem != null
    //     ? items.length.isEven
    //     : items.isNotEmpty);

    /// Height of the appbar
    final double height;
    final double width;
    final List<Color> selectedGradientColors;
    final List<Color> unselectedGradientColors;
    /// Padding on the top and bottom of AppBar
    final double verticalPadding;

    /// Padding on the left and right sides of AppBar
    final double horizontalPadding;

    /// List of TranslucentNavigationBarItems
    final List<CommonCategoryTitleItem> items;

    /// Returns the index of the tab that was tapped.
    final Function(int)? onTap;

    /// The tab to display.
    final int selectedIndex;
    /// The color of the icon when the item is selected.
    final Color selectedColor;
    /// The color of the icon when the item is unselected.
    final Color unselectedColor;

    final double selectedFontSize;

    final double unSelectedFontSize;

    final Gradient? gradient;

    final double gradientWidth;

    final Color bgColor;

    @override
    Widget build(BuildContext context) {
        double middleIndex = (items.length / 2).floorToDouble();
        List<CommonCategoryTitleItem> updatedItems = [];
        updatedItems.addAll(items);
        return createContainer(updatedItems, middleIndex, context);
    }

    Widget createContainer(List<CommonCategoryTitleItem> updatedItems,
      double middleIndex, BuildContext context) {
    return Container(
      child: Container(
        width: width > 0 ? width : MediaQuery.of(context).size.width,
        color: bgColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (final item in updatedItems)
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  onTap!.call(items.indexOf(item));
                },
                child: Padding(
                  padding: EdgeInsets.only(right: Adapt.px(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image(image: AssetImage('')),
                      SizedBox(
                        height: Adapt.px(12),
                      ),
                      item.selectedIconName.isNotEmpty
                          ? Container(
                        child: Image(
                          image: items.indexOf(item) == selectedIndex
                              ? AssetImage(
                              'assets/images/${item.selectedIconName}')
                              : AssetImage(
                              'assets/images/${item.unSelectedIconName}'),
                        ),
                        width: Adapt.px(29),
                        height: Adapt.px(29),
                      )
                          : Container(),
                      // Icon(z
                      //   item.iconData,
                      //   color: items.indexOf(item) == selectedIndex
                      //     ? selectedColor
                      //     : unselectedColor,
                      // ),
                      SizedBox(
                        height: Adapt.px(2),
                      ),
                      AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          // curve: Curves.easeInOutQuint,
                          curve: Curves.easeInOutCirc,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: items.indexOf(item) == selectedIndex
                                  ? selectedFontSize
                                  : unSelectedFontSize,
                              color: items.indexOf(item) == selectedIndex
                                  ? selectedColor
                                  : unselectedColor,
                              fontWeight: FontWeight.bold
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 0),
                            child: GradientText(item.title, overflow: TextOverflow.fade, colors: items.indexOf(item) == selectedIndex ? selectedGradientColors : unselectedGradientColors, textAlign: TextAlign.left, style: TextStyle(
                                fontSize: items.indexOf(item) == selectedIndex
                                    ? selectedFontSize
                                    : unSelectedFontSize,
                                color: items.indexOf(item) == selectedIndex
                                    ? selectedColor
                                    : unselectedColor,
                                fontWeight: FontWeight.bold
                            ),),
                            // height: 25,
                          )),

                      SizedBox(
                        height: Adapt.px(1),
                      ),
                      items.indexOf(item) == selectedIndex
                          ? Container(
                        margin: EdgeInsets.only(left: 3),
                        width: gradientWidth,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        ),
                      )
                          : Container(
                        height: 4,
                      ),
                      SizedBox(
                        height: Adapt.px(5),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
