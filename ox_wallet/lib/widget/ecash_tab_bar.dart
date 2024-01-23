import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_wallet/widget/common_card.dart';

class EcashTabBar extends StatelessWidget {

  final List<String> tabsName;
  final TabController controller;
  const EcashTabBar({super.key, required this.tabsName, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      height: 36.px,
      width: 200.px,
      radius: 40.px,
      verticalPadding: 0,
      horizontalPadding: 0,
      child: TabBar(
        controller: controller,
        tabs: tabsName.map((e) => _buildTab(e)).toList(),
        splashBorderRadius: BorderRadius.circular(24.px),
        padding: EdgeInsets.all(4.px),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(24.px),
          gradient: LinearGradient(
            stops: const [0.45, 0.55],
            begin: const Alignment(-0.5, -20),
            end: const Alignment(0.5, 20),
            colors: [
              ThemeColor.gradientMainEnd,
              ThemeColor.gradientMainStart,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label){
    return Container(
      height: 28.px,
      alignment: Alignment.center,
      child: Text(label,),
    );
  }
}

