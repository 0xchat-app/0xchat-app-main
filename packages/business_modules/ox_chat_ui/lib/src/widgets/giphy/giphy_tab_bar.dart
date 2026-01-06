import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import '../../models/giphy_general_model.dart';
import 'custom_tab_indicator.dart';
import 'giphy_picker.dart';

class GiphyTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController? controller;

  const GiphyTabBar({super.key, this.controller});

  @override
  State<GiphyTabBar> createState() => _GiphyTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(Adapt.px(36));
}

class _GiphyTabBarState extends State<GiphyTabBar> {
  @override
  Widget build(BuildContext context) => TabBar(
        tabs: GiphyCategory.values.map((item) => _buildTabLabel(item.label)).toList(),
        controller: widget.controller,
        labelColor: ThemeColor.color0,
        unselectedLabelColor: ThemeColor.color110,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        labelPadding: EdgeInsets.zero,
        indicatorWeight: 0,
        indicator: CustomTabIndicator(
          width: Adapt.px(30),
          gradient: LinearGradient(colors: [
            ThemeColor.gradientMainEnd,
            ThemeColor.gradientMainStart
          ]),
        ),
        labelStyle: TextStyle(
          fontSize: Adapt.px(14),
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: Adapt.px(14),
          fontWeight: FontWeight.w600,
        ),
      );

  Widget _buildTabLabel(String label) => Container(
        child: Tab(
          height: Adapt.px(36),
          child: Center(child: Text(label)),
        ),
      );
}
