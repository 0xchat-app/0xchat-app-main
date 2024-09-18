import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';

import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../../../utils/widget_tool.dart';
import 'nuts_relays_discovery_page.dart';

class NutsRelayPage extends StatefulWidget {
  NutsRelayPage({Key? key}) : super(key: key);

  @override
  NutsRelayPageState createState() => NutsRelayPageState();
}

class NutsRelayPageState extends State<NutsRelayPage> {
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
        title: 'Relay',
        backgroundColor: ThemeColor.color190,
        actions: [
          _editWidget(),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _mintListWidget().setPaddingOnly(top: 12.px, bottom: 24.px),
            CommonButton.themeButton(onTap: () {
              OXNavigator.pushPage(context, (context) => NutsRelaysDiscoveryPage());
            }, text: 'Add Relay'),
          ],
        ).setPadding(
          EdgeInsets.symmetric(horizontal: 24.px),
        ),
      ),
    );
  }

  Widget _editWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {},
      child: CommonImage(
        iconName: 'icon_edit.png',
        width: Adapt.px(24),
        height: Adapt.px(24),
        useTheme: true,
      ),
    ).setPaddingOnly(right:20.px);
  }


  Widget _mintListWidget() {
    return labelWidgetWrapWidget(
      widget: Column(
        children: [
          labelWidget(
            title: 'mint.tangjinxing.com(Default)',
            showDivider: true,
            rightWidget: _circleWidget(),
          ),
          labelWidget(
            title: 'mint.tangjinxing.com(Default)',
            rightWidget: _circleWidget(),
            showDivider: true,
          ),
          labelWidget(
            title: 'mint.tangjinxing.com(Default)',
            rightWidget: _circleWidget(),
            showDivider: true,
          ),
          labelWidget(
            title: 'mint.tangjinxing.com(Default)',
            rightWidget: _circleWidget(),
            showDivider: true,
          ),
          labelWidget(
            title: 'mint.tangjinxing.com(Default)',
            rightWidget: _circleWidget(),
            showDivider: true,
          ),
          labelWidget(
            title: 'mint.tangjinxing.com(Default)',
            rightWidget: CommonImage(
              iconName: 'icon_bar_delete.png',
              width: Adapt.px(24),
              height: Adapt.px(24),
            ),
          ),
        ],
      ),
    );
  }

  _circleWidget() {
    return Container(
      margin: EdgeInsets.only(
        right: 8.px,
      ),
      width: 8.px,
      height: 8.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.px),
        color: ThemeColor.green,
      ),
    );
  }
}
