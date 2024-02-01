import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/widget/mint_indicator_item.dart';

class WalletMintChoosePage extends StatefulWidget {
  final ValueChanged<IMint>? onChanged;
  const WalletMintChoosePage({super.key, this.onChanged});

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
        title: 'Select Mint',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 12.px,),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => MintItem(mint: mintItems[index],onChanged: _chooseMint,),
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
    }
  }
}