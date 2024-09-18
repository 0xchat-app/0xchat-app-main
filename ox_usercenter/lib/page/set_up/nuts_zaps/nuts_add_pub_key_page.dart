import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';

import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';

class NutsAddPubKeyPage extends StatefulWidget {
  NutsAddPubKeyPage({Key? key}) : super(key: key);

  @override
  NutsAddPubKeyPageState createState() => NutsAddPubKeyPageState();
}

class NutsAddPubKeyPageState extends State<NutsAddPubKeyPage> {
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
        title: 'Add Pub Key',
        backgroundColor: ThemeColor.color190,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _textFieldWidget(title: 'Pub Key', height: 92.px),
            _textFieldWidget(
              title: 'Wallet Name',
              height: 48.px,
            ),
            _textFieldWidget(
              title: 'Description',
              height: 92.px,
            ),
            CommonButton.themeButton(onTap: () {}, text: 'Save').setPaddingOnly(top:8.px),
          ],
        ).setPadding(
          EdgeInsets.symmetric(horizontal: 24.px),
        ),
      ),
    );
  }

  Widget _textFieldWidget({
    required String title,
    required double height,
  }) {
    return Container(
      padding: EdgeInsets.only(bottom: 16.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: ThemeColor.color0,
              fontWeight: FontWeight.w600,
              fontSize: 14.px,
            ),
          ).setPaddingOnly(bottom: 12.px),
          Container(
            height: height,
            padding: EdgeInsets.only(
              left: 16.px,
              right: 16.px,
            ),
            // height: 134.px,
            decoration: BoxDecoration(
              color: ThemeColor.color180,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Adapt.px(12),
                ),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'asd',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
