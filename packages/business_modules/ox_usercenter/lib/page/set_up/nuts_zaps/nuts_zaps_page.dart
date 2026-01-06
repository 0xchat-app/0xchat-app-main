import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';

import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';

import '../../../utils/widget_tool.dart';
import 'nuts_mint_page.dart';
import 'nuts_pub_key_page.dart';
import 'nuts_relay_page.dart';

class NutsZapsPage extends StatefulWidget {
  NutsZapsPage({Key? key}) : super(key: key);

  @override
  NutsZapsPageState createState() => NutsZapsPageState();
}

class NutsZapsPageState extends State<NutsZapsPage> {
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
        title: 'Nuts Zaps',
        backgroundColor: ThemeColor.color190,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _generalWidget(),
            _defaultZapAmountWidget(),
            _cumulativeZapsWidget(),
            _zapsRecordWidget(),
          ],
        ).setPadding(
          EdgeInsets.symmetric(horizontal: 24.px),
        ),
      ),
    );
  }

  Widget _generalWidget() {
    return labelWidgetWrapWidget(
      title: 'GENERAL',
      widget: Column(
        children: [
          labelWidget(
              title: 'Mints',
              subTitle: '6',
              showDivider: true,
              onTap: () {
                OXNavigator.pushPage(context, (context) => NutsMintPage());
              }),
          labelWidget(
              title: 'Relay',
              subTitle: '6',
              showDivider: true,
              onTap: () {
                OXNavigator.pushPage(context, (context) => NutsRelayPage());
              }),
          labelWidget(
              title: 'Receive Pubkey',
              subTitle: 'Key01',
              onTap: () {
                OXNavigator.pushPage(context, (context) => NutsPubKeyPage());
              }),
        ],
      ),
    );
  }

  Widget _defaultZapAmountWidget() {
    return labelWidgetWrapWidget(
      title: 'Default zap amount in sats',
      widget: Column(
        children: [
          labelWidget(title: '1000', showArrow: false),
        ],
      ),
    );
  }

  Widget _cumulativeZapsWidget() {
    return labelWidgetWrapWidget(
      title: 'Cumulative Zaps',
      widget: Column(
        children: [
          labelWidget(title: '🥰 2000', showArrow: false),
        ],
      ),
    );
  }

  Widget _zapsRecordWidget() {
    return labelWidgetWrapWidget(
      title: 'Zaps record',
      widget: Column(
        children: [
          labelWidget(
            title: '+1000',
            subTitle: '2023/06/01 23:00',
            showDivider: true,
          ),
          labelWidget(
            title: '+1000',
            subTitle: '2023/06/01 23:00',
          ),
        ],
      ),
    );
  }
}
