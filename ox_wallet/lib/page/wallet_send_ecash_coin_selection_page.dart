import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_wallet/widget/selection_card.dart';

class WalletSendEcashCoinSelectionPage extends StatefulWidget {
  const WalletSendEcashCoinSelectionPage({super.key});

  @override
  State<WalletSendEcashCoinSelectionPage> createState() => _WalletSendEcashCoinSelectionPage();
}

class _WalletSendEcashCoinSelectionPage extends State<WalletSendEcashCoinSelectionPage> {

  List<CardItemModel> _commonCardItemList = [];
  List<CardItemModel> _selectCardItemList = [];

  @override
  void initState() {
    _commonCardItemList = [
      CardItemModel(label: 'Amount',content: '255 Sats',),
      CardItemModel(label: 'Balance after TX',content: '45 Sats',),
    ];

    _selectCardItemList = [
      CardItemModel(label: '1 Sats', content: '9232d2_2323/',),
      CardItemModel(label: '2 Sats', content: '9232d2_2323/',),
      CardItemModel(label: '3 Sats', content: '9232d2_2323/',),
      CardItemModel(label: '4 Sats', content: '9232d2_2323/',),
      CardItemModel(label: '5 Sats', content: '9232d2_2323/',),
    ];

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SelectionCard(items: _commonCardItemList,enableSelection: false,),
            SelectionCard(items: _selectCardItemList,).setPaddingOnly(top: 24.px),
            ThemeButton(text: 'Continue',height: 48.px,onTap: () => OXNavigator.pop(context,true),).setPaddingOnly(top: 24.px),
          ],
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
      ),
    );
  }
}
