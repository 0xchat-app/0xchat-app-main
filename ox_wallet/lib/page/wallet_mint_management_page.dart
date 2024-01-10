import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/utils/ecash_dialog_helper.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';
import 'package:cashu_dart/cashu_dart.dart';

class WalletMintManagementPage extends StatefulWidget {
  final IMint mint;
  const WalletMintManagementPage({super.key, required this.mint});

  @override
  State<WalletMintManagementPage> createState() => _WalletMintManagementPageState();
}

class _WalletMintManagementPageState extends State<WalletMintManagementPage> {

  List<StepItemModel> _generalList = [];
  List<StepItemModel> _dangerZoneList = [];
  late ValueNotifier<String> mintQrCode;

  @override
  void initState() {
    _generalList = [
      StepItemModel(title: 'Mint',content: widget.mint.mintURL),
      StepItemModel(title: 'Balance',content: widget.mint.balance.toString()),
      StepItemModel(title: 'Show QR code',onTap: () => EcashDialogHelper.showMintQrCode(context, mintQrCode)),
      StepItemModel(title: 'Custom name',badge: widget.mint.name,onTap: () => EcashDialogHelper.showEditMintName(context)),
      StepItemModel(title: 'Set as default mint'),
      StepItemModel(title: 'More Info'),
    ];
    _dangerZoneList = [
      StepItemModel(title: 'Check proofs'),
      StepItemModel(title: 'Delete mint'),
    ];
    mintQrCode = ValueNotifier(widget.mint.mintURL);
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
          _buildItemList(labelName: 'GENERAL',items: _generalList),
          SizedBox(height: 24.px,),
          _buildItemList(labelName: 'DANGER ZONE',items: _dangerZoneList),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
    );
  }

  Widget _buildItem({String? title,String? content,String? badge,GestureTapCallback? onTap}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: StepIndicatorItem(
        height: 52.px,
        title: title,
        content: content != null ? Text(content, style: TextStyle(fontSize: 14.px)) : null,
        badge: badge != null ? Text(badge, style: TextStyle(fontSize: 14.px)) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildItemList({required String labelName, required List<StepItemModel> items}){
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
            title: items[index].title,
            content: items[index].content,
            badge: items[index].badge,
            onTap: items[index].onTap,
          ),
          separatorBuilder: (context,index) => Container(height: 0.5.px,color: ThemeColor.color160,),
          itemCount: items.length,
        ),
      ),
    );
  }
}

