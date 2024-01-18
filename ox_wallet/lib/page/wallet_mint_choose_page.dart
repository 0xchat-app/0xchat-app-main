import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_wallet/page/wallet_receive_lightning_page.dart';
import 'package:ox_wallet/page/wallet_send_ecash_page.dart';
import 'package:ox_wallet/page/wallet_send_lightning_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';

enum ChooseType{
  payInvoice(title: 'Cash out',tips: 'Choose a mint from which you would like to cash out your funds.'),
  createInvoice(title: 'Create invoice',tips: 'Choose a mint from which you would like to receive Ecash. The mint becomes custodian of your funds.'),
  ecash(title: 'Send Ecash',tips: 'Choose a mint from which you would like to create a Cashu token.');

  final String title;
  final String tips;

  const ChooseType({required this.title,required this.tips});
}

class WalletMintChoosePage extends StatefulWidget {
  final ChooseType type;
  const WalletMintChoosePage({super.key, required this.type});

  @override
  State<WalletMintChoosePage> createState() => _WalletMintChoosePageState();
}

class _WalletMintChoosePageState extends State<WalletMintChoosePage> {
  List<IMint> mintItems = [];

  @override
  void initState() {
    mintItems = EcashManager.shared.mintList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: widget.type.title,
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: Column(
        children: [
          Text(widget.type.tips,style: TextStyle(fontSize: 12.px,fontWeight: FontWeight.w400,color: ThemeColor.white),),
          SizedBox(height: 12.px,),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => CommonCard(
              verticalPadding: 8.px,
              child: StepIndicatorItem(
                title: mintItems[index].name.isNotEmpty ? mintItems[index].name : mintItems[index].mintURL,
                subTitle: '${mintItems[index].balance} Sats',
                onTap: () => _chooseMint(mintItems[index])
              ),
            ),
            separatorBuilder: (context,index) => SizedBox(height: 12.px,),
            itemCount: mintItems.length,
          ),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
    );
  }

  Future<void> _chooseMint(IMint mint) async {
    bool result = await EcashManager.shared.setDefaultMint(mint);
    if(result && context.mounted){
      switch(widget.type){
        case ChooseType.payInvoice : OXNavigator.pushPage(context, (context) => const WalletSendLightningPage());
        case ChooseType.createInvoice : OXNavigator.pushPage(context, (context) => const WalletReceiveLightningPage());
        case ChooseType.ecash : OXNavigator.pushPage(context, (context) => WalletSendEcashPage());
      }
    }
  }
}