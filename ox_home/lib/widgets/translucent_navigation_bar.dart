library dot_navigation_bar;

export 'translucent_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:rive/rive.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'translucent_navigation_bar_item.dart';
import 'package:flutter/src/painting/gradient.dart' as gradient;


class TranslucentNavigationBar extends StatefulWidget {
  /// Height of the appbar
  final double height;

  /// Border radius of the appbar
  final double borderRadius;

  /// Blur extent of the appbar
  final double blur;

  /// Padding on the top and bottom of AppBar
  final double verticalPadding;

  /// Padding on the left and right sides of AppBar
  final double horizontalPadding;

  /// List of TranslucentNavigationBarItems
  final List<TranslucentNavigationBarItem> tabBarList;

  /// Returns the index of the tab that was tapped.
  final Function(int)? onTap;

  /// The tab to display.
  final int selectedIndex;

  /// Main icon background color in middle of appbar
  final Color mainIconBackgroundColor;

  /// Main icon  color in middle of appbar
  final Color mainIconColor;

  /// Main icon function on tap
  final Function()? onMainIconTap;

  const TranslucentNavigationBar({
  super.key,
  required this.tabBarList,
  required this.selectedIndex,
  this.mainIconBackgroundColor = Colors.blue,
  this.mainIconColor = Colors.white,
  required this.onTap,
  this.onMainIconTap,
  this.height = 72.0,
  this.borderRadius = 24.0,
  this.blur = 2, // You use 5 for black and 1 for white
  this.verticalPadding = 25.0,
  this.horizontalPadding = 20.0,
  });

  @override
  State<TranslucentNavigationBar> createState() => TranslucentNavigationBarState();
}

class TranslucentNavigationBarState extends State<TranslucentNavigationBar> {

  late double middleIndex;
  late List<TranslucentNavigationBarItem> updatedItems;

  bool get isDark => ThemeManager.getCurrentThemeStyle() == ThemeStyle.dark;

  @override
  void initState() {
    super.initState();
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    middleIndex = (widget.tabBarList.length / 2).floorToDouble();
    updatedItems = [];
    updatedItems.addAll(widget.tabBarList);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    setState(() {
      updatedItems = [];
      updatedItems.addAll(widget.tabBarList);
    });
  }

  @override
  void didUpdateWidget(covariant TranslucentNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabBarList != widget.tabBarList) {
      updatedItems = [];
      updatedItems.addAll(widget.tabBarList);
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {


    return Container(
      margin: EdgeInsets.symmetric(
        vertical: widget.verticalPadding,
        horizontal: widget.horizontalPadding,
      ),
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.height),
        boxShadow: const [
          BoxShadow(
            // color: Color(0x7FE3E3E3), // Daytime pattern
            color: Color(0x33141414), // Dark mode
            offset: Offset(
              3.0,
              1.0,
            ),
            blurRadius: 20.0,
            spreadRadius: 1.0,
            // blurStyle: BlurStyle.solid
          ),
        ],
      ),
      child: createTabContainer(updatedItems, middleIndex),
    );
  }

  Widget createTabContainer(
      List<TranslucentNavigationBarItem> updatedItems, double middleIndex) {
    return GlassmorphicContainer(
      borderRadius: widget.borderRadius,
      blur: widget.blur,
      alignment: Alignment.bottomCenter,
      border: 0.5,
      linearGradient: gradient.LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Daytime pattern
            isDark ? const Color(0xB2444444) : const Color(0xB2FFFFFF),
            isDark ? const Color(0xB2444444) : const Color(0xB2FFFFFF),
         //    Color(isDark ? 0xB2444444 : 0xB2FFFFFF),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: gradient.LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          //Lighting Mode

          // Colors.white.withOpacity(0.1),
          // Colors.white.withOpacity(0.1),
          // Colors.white.withOpacity(0.1),
          // Colors.white.withOpacity(0.1),

          // Color(0x66F5F5F5),
          // Color(0x66F5F5F5),
          // Color(0x66F5F5F5),
          // Color(0x66F5F5F5),

          isDark ?  const Color(0x0c595959) :  const Color(0x66F5F5F5),
          isDark ?  const Color(0x0c595959) : const Color(0x66F5F5F5),
          isDark ?  const Color(0x0c595959) : const Color(0x66F5F5F5),
          isDark ?  const Color(0x0c595959) : const Color(0x66F5F5F5),
          // Dark mode
          // Color(0x0c595959),
          // Color(0x0c595959),
          // Color(0x0c595959),
          // Color(0x0c595959),
        ],
      ),
      height: widget.height,
      width: double.infinity,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final item in updatedItems)
              GestureDetector(
                onTap: () {
                  widget.onTap!.call(widget.tabBarList.indexOf(item));
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: Adapt.px(70),
                      height: widget.height,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              bottom: Adapt.px(2),
                            ),
                            width: Adapt.px(24),
                            child: Stack(
                              children: [_getMyTabBarIcon(item)],
                            ),
                          ),
                          _getTabBarTitle(item),
                        ],
                      ),
                    ),
                    Positioned(bottom: Adapt.px(6),child: _promptWidget(item),),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _promptWidget(TranslucentNavigationBarItem item) {
    if (item.unreadMsgCount > 0) {
      return _iconContainer('unread_dot');
    }
    return Container();
  }

  Widget _iconContainer(String iconName) {
    return Container(
      color: Colors.transparent,
      width: Adapt.px(6),
      height: Adapt.px(6),
      child: Image(
        image: AssetImage("assets/images/$iconName.png"),
      ),
    );
  }

  Widget _getMyTabBarIcon(TranslucentNavigationBarItem item) {
    if(item.artboard != null){
      return  SizedBox(
        width: Adapt.px(24),
        height: Adapt.px(24),
        child: Rive(artboard: item.artboard!),
      );
    }
    return Container();

  }

  Widget _getTabBarTitle(TranslucentNavigationBarItem item) {
    final title = item.title;
    if (title == null || title.isEmpty) return Container();
    return Text(
      title,
      style: TextStyle(
          fontSize: Adapt.px(10), fontWeight: FontWeight.w600,color: widget.tabBarList.indexOf(item) == widget.selectedIndex ? ThemeColor.gradientMainStart : ThemeColor.color100),
    );
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }
}
