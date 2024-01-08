import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/page/wallet_mint_management_add_page.dart';
import 'package:ox_wallet/page/wallet_mint_management_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';

class WalletMintListPage extends StatefulWidget {
  const WalletMintListPage({super.key});

  @override
  State<WalletMintListPage> createState() => _WalletMintListPageState();
}

class _WalletMintListPageState extends State<WalletMintListPage> {

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
        title: 'Mints',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => CommonCard(
              verticalPadding: 8.px,
              child: StepIndicatorItem(
                title: mintItems[index].name ?? '',
                content: '${mintItems[index].balance} Sats',
                onTap: () => OXNavigator.pushPage(context, (context) => const WalletMintManagementPage()),
              ),
            ),
            separatorBuilder: (context,index) => SizedBox(height: 12.px,),
            itemCount: mintItems.length,
          ),
          SizedBox(height: 24.px,),
          ThemeButton(text: 'Add Mint',height: 48.px,onTap: () => OXNavigator.pushPage(context, (context) => WalletMintManagementAddPage()),),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
    );
  }
}
