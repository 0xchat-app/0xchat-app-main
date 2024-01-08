import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/widget/common_card.dart';

class WalletMintManagementAddPage extends StatelessWidget {
  WalletMintManagementAddPage({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: 'Add a new mint',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonCard(
            radius: 12.px,
            verticalPadding: 12.px,
            horizontalPadding: 16.px,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Mint URL',
                          hintStyle: TextStyle(fontSize: 16.px,height: 22.px / 16.px),
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        controller: controller,
                        maxLines: 1,
                        showCursor: true,
                        style: TextStyle(fontSize: 16.px,height: 22.px / 16.px,color: ThemeColor.color0),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.px),
                CommonImage(
                  iconName: 'icon_send_qrcode.png',
                  size: 24.px,
                  package: 'ox_wallet',
                ),
              ],
            ),
          ),
          SizedBox(height: 24.px,),
          ThemeButton(text: 'Add',height: 48.px,onTap: _addMint),
        ],
      ).setPadding(EdgeInsets.symmetric(vertical: 12.px,horizontal: 24.px))
    );
  }

  void _addMint(){

  }
}
