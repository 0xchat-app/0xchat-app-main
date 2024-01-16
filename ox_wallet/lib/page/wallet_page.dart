import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/page/wallet_home_page.dart';
import 'package:ox_wallet/page/wallet_mint_management_add_page.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/widget/common_card.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _defaultMintURL = 'https://legend.lnbits.com/cashu/api/v1/AptDNABNBXv8gpuywhx6NV';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
        centerTitle: true,
        useLargeTitle: false,
    ),
    body:SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonImage(
                iconName: 'icon_wallet_logo.png',
                size: 100.px,
                package: 'ox_wallet',
              ).setPaddingOnly(top: 44.px),
            CommonImage(
              iconName: 'icon_wallet_symbol.png',
              height: 25.px,
              width: 100.px,
              package: 'ox_wallet',
            ).setPaddingOnly(top: 16.px),
            const Spacer(),
            ThemeButton(height: 48.px,text: 'Use the default mint',onTap: _useDefaultMint,),
            GestureDetector(
              onTap: () => OXNavigator.pushPage(context, (context) => WalletMintManagementAddPage(action: ImportAction.import,callback: (){
                OXNavigator.pushPage(context!, (context) => const WalletHomePage());
              })),
              child: CommonCard(
                  height: 48.px,
                  child: Center(
                    child: Text('Add mint URL', style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w600,color: ThemeColor.color0),
                    ),
                  ),
                ).setPaddingOnly(top: 18.px),
            ),
              SizedBox(height: 40.px,)
            ],
          ).setPadding(EdgeInsets.symmetric(horizontal: 30.px)),
      ),
    ),
    );
  }

  void _useDefaultMint() {
    OXLoading.show();
    EcashService.addMint(_defaultMintURL).then((mint) {
      OXLoading.dismiss();
      if (mint != null) {
        OXNavigator.pushPage(context, (context) => const WalletHomePage());
      } else {
        CommonToast.instance.show(context, 'Add default mint Failed, Please try again.');
      }
    });
  }
}