import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ox_common/utils/adapt.dart';

import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../../../utils/widget_tool.dart';

class NutsMintManagementPage extends StatefulWidget {
  NutsMintManagementPage({Key? key}) : super(key: key);

  @override
  NutsMintManagementPageState createState() => NutsMintManagementPageState();
}

class NutsMintManagementPageState extends State<NutsMintManagementPage> {
  bool setAsDefaultMintStatus = false;

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
        title: 'Mint Management',
        backgroundColor: ThemeColor.color190,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _generalWidget(),
            _fundsWidget(),
            _dangerZoneWidget(),
          ],
        ).setPadding(
          EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px),
        ),
      ),
    );
  }

  Widget _generalWidget() {
    return Container(
      padding: EdgeInsets.only(bottom: 24.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GENERAL',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.px,
              color: ThemeColor.color0,
            ),
          ).setPaddingOnly(bottom: 12.px),
          labelWidgetWrapWidget(
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelWidget(
                  title: 'Mint',
                  showArrow: false,
                  showDivider: true,
                  subTitle: 'mint.tangjinxing.com',
                ),
                labelWidget(
                  title: 'Balance',
                  showArrow: false,
                  showDivider: true,
                  subTitle: '99 Sats',
                ),
                labelWidget(
                  title: 'Show QR code',
                  showDivider: true,
                ),
                labelWidget(
                  title: 'Custom name',
                  subTitle: 'name',
                  showDivider: true,
                ),
                labelWidget(
                  title: 'Set as Default mint',
                  showDivider: true,
                  rightWidget: Container(
                    height: 20.px,
                    child: Switch(
                      value: setAsDefaultMintStatus,
                      activeColor: Colors.white,
                      activeTrackColor: ThemeColor.gradientMainStart,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: ThemeColor.color160,
                      onChanged: (bool value) async {
                        setAsDefaultMintStatus = value;
                        setState(() {});
                      },
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  )
                ),
                labelWidget(
                  title: 'More info',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fundsWidget() {
    return Container(
      padding: EdgeInsets.only(bottom: 24.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FUNDS',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.px,
              color: ThemeColor.color0,
            ),
          ).setPaddingOnly(bottom: 12.px),
          labelWidgetWrapWidget(
            widget: Column(
              children: [
                labelWidget(
                  title: 'Backup funds',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dangerZoneWidget() {
    return Container(
      padding: EdgeInsets.only(bottom: 24.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DANGER ZONE',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.px,
              color: ThemeColor.color0,
            ),
          ).setPaddingOnly(bottom: 12.px),
          labelWidgetWrapWidget(
            widget: Column(
              children: [
                labelWidget(
                  title: 'Check proofs',
                  showDivider: true,
                ),
                labelWidget(
                  title: 'Delete mint',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
