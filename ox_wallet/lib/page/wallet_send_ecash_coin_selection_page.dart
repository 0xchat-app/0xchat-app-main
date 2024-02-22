import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_wallet/widget/proof_selection_card.dart';
import 'package:ox_wallet/widget/selection_card.dart';
import 'package:cashu_dart/cashu_dart.dart';

class WalletSendEcashCoinSelectionPage extends StatefulWidget {
  final IMint mint;
  final int amount;

  const WalletSendEcashCoinSelectionPage({super.key, required this.amount, required this.mint});

  @override
  State<WalletSendEcashCoinSelectionPage> createState() => _WalletSendEcashCoinSelectionPage();
}

class _WalletSendEcashCoinSelectionPage extends State<WalletSendEcashCoinSelectionPage> {
  final ValueNotifier<List<CardItemModel>> _commonCardItemList = ValueNotifier([]);
  final ValueNotifier<bool> _enable = ValueNotifier(false);
  List<Proof> _proofs = [];
  List<Proof> _selectedProofs = [];

  @override
  void initState() {
    _commonCardItemList.value = [
      CardItemModel(label: 'Selected',content: '0/${widget.amount}Sats',),
      CardItemModel(label: 'Change',content: 'Sats',),
    ];
    _getAllProof();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: 'Coin selection',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSelectionInfo(),
          Expanded(child: ProofSelectionCard(items: _proofs,onChanged: _onChanged,).setPaddingOnly(top: 24.px)),
          _buildConfirmButton()
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
    );
  }

  Widget _buildSelectionInfo(){
    return ValueListenableBuilder(
      valueListenable: _commonCardItemList,
      builder: (context,value,child) {
          return SelectionCard(
          items: _commonCardItemList.value,
          enableSelection: false,
        );
      }
    );
  }

  Widget _buildConfirmButton() {
    return ValueListenableBuilder(
      valueListenable: _enable,
      builder: (context,value,child) {
        return SafeArea(
            child: ThemeButton(
              text: 'Confirm',
              height: 48.px,
              enable: value,
              onTap: () => OXNavigator.pop(context, _selectedProofs),
            ).setPaddingOnly(top: 24.px),
          );
        }
    );
  }

  Future<void> _getAllProof() async {
    List<Proof> proofs = await EcashService.getAllUseProofs(mint: widget.mint);
    if(proofs.isNotEmpty){
      setState(() {
        _proofs = proofs;
      });
    }
  }

  void _onChanged(List<Proof> items){
    int totalAmount = items.fold(0, (pre, proof) => pre + proof.amountNum);
    if(totalAmount > widget.amount){
      _enable.value = true;
    }else{
      _enable.value = false;
    }
    _commonCardItemList.value = List.from(_commonCardItemList.value)..[0] = CardItemModel(label: 'Selected', content: '$totalAmount/${widget.amount} Sats');
    _selectedProofs = items;
  }
}
