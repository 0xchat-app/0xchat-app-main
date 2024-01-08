import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';

class WalletMintManagementPage extends StatefulWidget {
  const WalletMintManagementPage({super.key});

  @override
  State<WalletMintManagementPage> createState() => _WalletMintManagementPageState();
}

class _WalletMintManagementPageState extends State<WalletMintManagementPage> {

  Map<String,String?> general = {
    'Mint': 'mint.tangjinxing.com',
    'Balance': '99 Sats',
    'Show QR code': null,
    'Custom name': null,
    'Set ad default mint': null,
    'More Info': null
  };

  Map<String,String?> dangerZone = {
    'Check proofs': null,
    'Delete mint': null,
  };

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
          _buildItemList(labelName: 'GENERAL',items: general),
          SizedBox(height: 24.px,),
          _buildItemList(labelName: 'DANGER ZONE',items: dangerZone),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
    );
  }

  Widget _buildItem({required String title,String? value,String? badge}){
    Widget? action ;

    if (value != null) {
      action = Text(value,style: TextStyle(fontSize: 14.px),);
    } else {
      action = null;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: StepIndicatorItem(
        height: 52.px,
        title: title,
        action: action,
      ),
    );
  }

  Widget _buildItemList({required String labelName, required Map<String, String?> items}){
    return CommonLabeledCard(
      label: labelName,
      child: CommonCard(
        radius: 12.px,
        verticalPadding: 0.px,
        horizontalPadding: 0.px,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) => _buildItem(
            title: items.keys.toList()[index],
            value: items.values.toList()[index],
          ),
          separatorBuilder: (context,index) => Container(height: 0.5.px,color: ThemeColor.color160,),
          itemCount: items.length,
        ),
      ),
    );
  }
}
