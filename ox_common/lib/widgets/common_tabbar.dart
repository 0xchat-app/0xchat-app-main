
import 'package:flutter/material.dart';

import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/adapt.dart';

class OXCommonTabBar extends StatefulWidget {

  OXCommonTabBar({
    Key? key,
    required this.data,
    this.controller,
    this.itemExpanded = true,
    this.height,
    this.lableColor,
    this.unselectedLabelColor,
    this.indicatorWidth,
    this.indicatorInset,
  }) : assert(data.length > 0),
       super(key: key);

  final List<String> data;
  final TabController? controller;
  /// item divides the whole space equally
  final bool itemExpanded;
  final double? height;
  final Color? lableColor;
  final Color? unselectedLabelColor;
  final double? indicatorWidth;
  final EdgeInsets? indicatorInset;

  @override
  State<StatefulWidget> createState() => OXCommonTabBarState();
}

class OXCommonTabBarState extends State<OXCommonTabBar> with SingleTickerProviderStateMixin {

  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TabController(length: widget.data.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final lableColor = widget.lableColor ?? ThemeColor.white01;
    final unselectedLabelColor = widget.unselectedLabelColor ?? ThemeColor.gray02;
    final isScrollable = widget.itemExpanded ? false : true;
    final indicatorWidth = widget.indicatorWidth ?? Adapt.px(24);
    final inset = (Adapt.screenW() / widget.data.length - indicatorWidth) / 2;
    return Theme(
      data: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        enableFeedback: true,
        automaticIndicatorColorAdjustment: true,
        labelColor: lableColor,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: Adapt.px(16),
        ),
        unselectedLabelColor: unselectedLabelColor,
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: Adapt.px(16),
        ),
        indicatorWeight: Adapt.px(3),
        indicatorColor: ThemeColor.main,
        indicatorPadding: widget.indicatorInset ?? EdgeInsets.symmetric(horizontal: inset),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: widget.data.map((title) {
          return Container(
            height: widget.height ?? Adapt.px(44.0),
            child: Center(child: Text(title, textAlign: TextAlign.center,),),
          );
        }).toList(),
      )
    );
  }
}