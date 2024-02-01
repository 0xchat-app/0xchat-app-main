import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_wallet/page/wallet_receive_lightning_page.dart';
import 'package:ox_wallet/page/wallet_send_ecash_page.dart';
import 'package:ox_wallet/page/wallet_send_lightning_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/widget/common_card.dart';

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
  final ValueChanged<IMint>? onChanged;
  const WalletMintChoosePage({super.key, required this.type, this.onChanged});

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
              child: _buildItem(
                title: mintItems[index].name.isNotEmpty ? mintItems[index].name : mintItems[index].mintURL,
                subTitle: '${mintItems[index].balance} Sats',
                onTap: () => _chooseMint(mintItems[index]),
              ),
            ),
            separatorBuilder: (context,index) => SizedBox(height: 12.px,),
            itemCount: mintItems.length,
          ),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
    );
  }

  Widget _buildItem({required String title,required String subTitle,Function()? onTap}){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? '',style: TextStyle(fontSize: 16.px,color: ThemeColor.color0,height: 22.px / 16.px,overflow: TextOverflow.ellipsis),),
                Text(subTitle,style: TextStyle(fontSize: 14.px,height: 20.px / 14.px),),
              ],
            ),
          ),
          CommonImage(
            iconName: 'icon_wallet_more_arrow.png',
            size: 24.px,
            package: 'ox_wallet',
          )
        ],
      ),
    );
  }

  Future<void> _chooseMint(IMint mint) async {
    bool result = await EcashManager.shared.setDefaultMint(mint);
    if(result && context.mounted){
      OXNavigator.pop(context);
      if (widget.onChanged != null) {
        widget.onChanged!.call(mint);
        return;
      }
      switch(widget.type){
        case ChooseType.payInvoice : OXNavigator.pushPage(context, (context) => const WalletSendLightningPage());
        case ChooseType.createInvoice : OXNavigator.pushPage(context, (context) => const WalletReceiveLightningPage());
        case ChooseType.ecash : OXNavigator.pushPage(context, (context) => WalletSendEcashPage());
      }
    }
  }
}