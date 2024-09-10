import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';

import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';

import 'nuts_add_pub_key_page.dart';

class NutsPubKeyPage extends StatefulWidget {
  NutsPubKeyPage({Key? key}) : super(key: key);

  @override
  NutsPubKeyPageState createState() => NutsPubKeyPageState();
}

class NutsPubKeyPageState extends State<NutsPubKeyPage> {
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
        title: 'Pub Key',
        backgroundColor: ThemeColor.color190,
        actions: [
          _editWidget(),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _pubKeyWidget(isSelect: true),
            _pubKeyWidget(isSelect: false),
            SizedBox(height: 24.px),
            CommonButton.themeButton(onTap: () {
              OXNavigator.pushPage(context, (context) => NutsAddPubKeyPage());
            }, text: 'Add Pub Key'),
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

  Widget _pubKeyWidget({required bool isSelect}) {
    Widget widget = Container(
      width: 20.px,
      height: 20.px,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: ThemeColor.color100,
          width: 1.px,
          style: BorderStyle.solid,
          // double strokeAlign = BorderSide.strokeAlignInside,
        ),
      ),
    );
    if (isSelect) {
      widget = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => {},
        child: CommonImage(
          iconName: 'icon_copyied_success.png',
          width: Adapt.px(20),
          height: Adapt.px(20),
          fit: BoxFit.fill,
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(bottom: 12.px),
      padding: EdgeInsets.symmetric(
        vertical: 10.px,
        horizontal: 16.px,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ThemeColor.color180,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Key01',
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: 16.px,
                  fontWeight: FontWeight.w400,
                ),
              ).setPaddingOnly(bottom: 4.px),
              Container(
                width: 280.px,
                child: Text(
                  'lnbc1pjky30tpp59shnkt9qe4vfvzmmk2k0yevqj5c9wu2ra0fvrw28vz7slr6wctusdqqcqzzsxqyz5vqsp5qple5cdqlpnf34pa0643xd7csv9',
                  style: TextStyle(
                    color: ThemeColor.color100,
                    fontSize: 12.px,
                    fontWeight: FontWeight.w400,
                    // overflow:
                  ),
                ),
              ),
            ],
          ),
          widget,
        ],
      ),
    );
  }
}
