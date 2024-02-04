import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/page/wallet_backup_funds_page.dart';
import 'package:ox_wallet/page/wallet_mint_management_add_page.dart';
import 'package:ox_wallet/page/wallet_mint_management_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/widget/common_card.dart';

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
        actions: [
          _buildBackupWidget(),
        ],
      ),
      body: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => CommonCard(
              verticalPadding: 8.px,
              child: _buildItem(
                title: _mintTitle(index),
                subTitle: '${mintItems[index].balance} Sats',
                showBadge: EcashManager.shared.isDefaultMint(mintItems[index]),
                onTap: () => _clickItem(index),
              ),
            ),
            separatorBuilder: (context,index) => SizedBox(height: 12.px,),
            itemCount: mintItems.length,
          ),
          mintItems.isNotEmpty ? SizedBox(height: 24.px,) : Container(),
          ThemeButton(text: 'Add Mint',height: 48.px,onTap: _addMint),
          ThemeButton(text: 'Import Wallet',height: 48.px,onTap: _importWallet).setPaddingOnly(top: 24.px),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
    );
  }

  Widget _buildItem({required String title, required String subTitle, required bool showBadge, Function()? onTap}) {
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
                Row(
                  children: [
                    showBadge ? CommonImage(iconName: 'icon_default_mint.png',size: 22.px,package: 'ox_wallet',).setPaddingOnly(right: 4.px) : Container(),
                    Expanded(child: Text(title ?? '',style: TextStyle(fontSize: 16.px,color: ThemeColor.color0,height: 22.px / 16.px,overflow: TextOverflow.ellipsis),)),
                  ],
                ),
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

  Widget _buildBackupWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => OXNavigator.pushPage(context, (context) => const WalletBackupFundsPage(mint: null,),),
      child: CommonImage(
        iconName: 'icon_wallet_backup.png',
        size: 24.px,
        package: 'ox_wallet',
      ).setPaddingOnly(right: 20.px),
    );
  }

  String _mintTitle(int index) => mintItems[index].name.isNotEmpty ? mintItems[index].name : mintItems[index].mintURL;

  void _clickItem(int index) => OXNavigator.pushPage(context, (context) => WalletMintManagementPage(mint: mintItems[index],)).then((value) {
        setState(() {});
      });

  void _addMint() async {
    bool? result = await OXNavigator.pushPage(context, (context) => const WalletMintManagementAddPage());
    if (result != null && result) {
      setState(() {
        mintItems = EcashManager.shared.mintList;
      });
    }
  }

  void _importWallet() async {
    bool? result = await OXNavigator.pushPage(context, (context) => const WalletMintManagementAddPage(action: ImportAction.import));
    if (result != null && result) {
      setState(() {
        mintItems = EcashManager.shared.mintList;
      });
    }
  }
}
