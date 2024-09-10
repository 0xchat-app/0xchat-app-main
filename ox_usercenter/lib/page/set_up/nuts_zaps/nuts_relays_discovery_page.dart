import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';

import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../../../utils/widget_tool.dart';

class NutsRelaysDiscoveryPage extends StatefulWidget {
  NutsRelaysDiscoveryPage({Key? key}) : super(key: key);

  @override
  NutsRelaysDiscoveryPageState createState() => NutsRelaysDiscoveryPageState();
}

class NutsRelaysDiscoveryPageState extends State<NutsRelaysDiscoveryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: 'Relays Discovery',
        backgroundColor: ThemeColor.color190,
        actions: [
          _doneWidget(),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _discoveryItemWidget(),
            _discoveryItemWidget(),
            _discoveryItemWidget(),

          ],
        ).setPadding(
          EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px),
        ),
      ),
    );
  }


  Widget _doneWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {},
      child: CommonImage(
        iconName: 'icon_done.png',
        width: Adapt.px(24),
        height: Adapt.px(24),
        useTheme: true,
      ),
    ).setPaddingOnly(right:20.px);
  }

  Widget _discoveryItemWidget() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 12.px,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 20.px,
        vertical: 15.px,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ThemeColor.color180,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 12.px),
                width: 32.px,
                height: 32.px,
                color: ThemeColor.color100,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Defualt Mint'),
                  Text('A CashU mint hosted by lnwallet.app'),
                ],
              ),
            ],
          ),
          Container(
            width: 20.px,
            height: 20.px,
            color: ThemeColor.color100,
          ),
        ],
      ),
    );
  }
}
