import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';

class RelaySelectableTabBar extends StatefulWidget {
  final List<String> tabs;
  final List<String>? tabTips;
  final ValueChanged<int>? onChanged;

  const RelaySelectableTabBar({
    Key? key,
    required this.tabs,
    this.onChanged,
    this.tabTips,
  })  : assert(tabTips == null || tabs.length == tabTips.length,
            'tabs and tabTips must have the same length'),
        super(key: key);

  @override
  State<RelaySelectableTabBar> createState() => _RelaySelectableTabBarState();
}

class _RelaySelectableTabBarState extends State<RelaySelectableTabBar>
    with SingleTickerProviderStateMixin {

  late final TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(_updateStatus);
  }

  _updateStatus() {
    setState(() {
      _currentIndex = _tabController.index;
      widget.onChanged?.call(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = widget.tabs;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          isScrollable: true,
          controller: _tabController,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          labelPadding: EdgeInsets.only(right: 12.px),
          labelColor: ThemeColor.color0,
          unselectedLabelColor: ThemeColor.color100,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 0),
          ),
          tabs: [
            for (int index = 0; index < tabs.length; index++)
              _buildTabItem(tabs[index], index),
          ],
        ),
        if (widget.tabTips != null)
          _buildTabTips().setPaddingOnly(top: 10.px)
      ],
    );
  }

  Widget _buildTabItem(String tab, int index) {
    return Container(
      height: 40.px,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 24.px, vertical: 10.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.px),
        color: ThemeColor.color180,
      ),
      child: Text(
        tab,
        style: TextStyle(
          fontSize: 14.px,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTabTips() {
    final tips = widget.tabTips?[_currentIndex] ?? '';
    return Text(
      tips,
      style: TextStyle(
        fontSize: 12.px,
        fontWeight: FontWeight.w400,
        color: ThemeColor.color100,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabController.removeListener(_updateStatus);
    super.dispose();
  }
}
