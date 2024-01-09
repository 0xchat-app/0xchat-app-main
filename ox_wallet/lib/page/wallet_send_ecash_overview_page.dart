import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_wallet/page/wallet_send_ecash_coin_selection_page.dart';
import 'package:ox_wallet/page/wallet_send_ecash_new_token_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/switch_widget.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:cashu_dart/cashu_dart.dart';

class WalletSendEcashOverviewPage extends StatefulWidget {
  final int amount;
  final String? memo;
  const WalletSendEcashOverviewPage({super.key, required this.amount, this.memo});

  @override
  State<WalletSendEcashOverviewPage> createState() => _WalletSendEcashOverviewPageState();
}

class _WalletSendEcashOverviewPageState extends State<WalletSendEcashOverviewPage> {

  List<CardItemModel> _items = [];

  bool _isCoinSelection = false;
  int get balance => EcashManager.shared.defaultIMint.balance - widget.amount;
  List<Proof>? _selectedProofs;

  @override
  void initState() {
    int balance = EcashManager.shared.defaultIMint.balance;
    _items = [
      CardItemModel(label: 'Payment type',content: 'Send Ecash',),
      CardItemModel(label: 'Mint',content: EcashManager.shared.defaultIMint.name,),
      CardItemModel(label: 'Amount',content: widget.amount.toString(),),
      CardItemModel(label: 'Balance after TX',content: '$balance Sats',),
      CardItemModel(
        label: 'Coin Selection',
        content: 'Your Ecash balance is essentially a collection of coin-sets. Coin selection allows you to choose the coins you want to spend. Coin- sets are assigned a keyset-ID by the mint, which may change over time. Newly added keysets are highlighted in green. It is advisable to spend older sets first.',
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: 'Send Ecash',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: ListView(
        children: [
          CommonCard(
            verticalPadding: 0,
            horizontalPadding: 0,
            child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: _buildItem,
                separatorBuilder: (context,index) => Container(height: 0.5.px,color: ThemeColor.color160,),
                itemCount: _items.length),
          ).setPaddingOnly(top: 12.px),
          ThemeButton(
            text: 'Create Token',
            height: 48.px,
            onTap: _createToken,
          ).setPaddingOnly(top: 24.px),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
    );
  }

  Widget _buildItem(context,index){
    List<CommonCardItem> commonCardItemList= _items.map((element){
      if(element.label == 'Coin Selection'){
        return CommonCardItem(
          label: element.label,
          content: element.content,
          action: SwitchWidget(
            value: _isCoinSelection,
            onChanged: (value) async {
              if (value) {
                List<Proof>? result = await OXNavigator.pushPage(context, (context) => WalletSendEcashCoinSelectionPage(amount: widget.amount,));
                if(result != null){
                  _selectedProofs = result;
                  int totalAmount = result.fold(0, (pre, proof) => pre + proof.amountNum);
                  _isCoinSelection = true;
                  _items.addAll([
                    CardItemModel(label: 'Selected',content: '$totalAmount/${widget.amount} Sats',),
                    CardItemModel(label: 'Change',content: 'Sats',),
                  ]);
                }else{
                  _isCoinSelection = false;
                }
              }else{
                _items.removeWhere((element) => element.label == 'Selected' || element.label == 'Change');
                _isCoinSelection = false;
                _selectedProofs =  null;
              }
              setState(() {});
            },
          ),
        );
      }
      return CommonCardItem(label: element.label,content: element.content);
    }).toList();
    return commonCardItemList[index];
  }

  Future<void> _createToken() async {
    await OXLoading.show();
    String? token = await EcashService.sendEcash(mint: EcashManager.shared.defaultIMint, amount: widget.amount,memo: widget.memo,proofs: _selectedProofs);
    await OXLoading.dismiss();
    if(token!=null){
      OXNavigator.pushPage(context, (context) => WalletSendEcashNewTokenPage(amount: widget.amount,token: token,));
      return;
    }
    CommonToast.instance.show(context, 'create toke failed');
  }
}
