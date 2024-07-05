import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/mint_indicator_item.dart';
import 'package:ox_wallet/widget/sats_amount_card.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_wallet/widget/send_p2pk_option_widget.dart';
import 'wallet_send_ecash_overview_page.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_localizable/ox_localizable.dart';

class WalletSendEcashPage extends StatefulWidget {
  const WalletSendEcashPage({super.key});

  @override
  State<WalletSendEcashPage> createState() => _WalletSendEcashPageState();
}

class _WalletSendEcashPageState extends State<WalletSendEcashPage> {

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String get amount => _amountController.text;
  String get description => _descriptionController.text;
  bool get enable => amount.isNotEmpty && double.parse(amount) > 0 && _mint != null;
  SendP2PKOption p2pkOption = SendP2PKOption();

  IMint? _mint;

  @override
  void initState() {
    _mint = EcashManager.shared.defaultIMint;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
          title: Localized.text('ox_wallet.send_ecash'),
          centerTitle: true,
          useLargeTitle: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MintIndicatorItem(mint: _mint,onChanged: _onChanged),
            SatsAmountCard(controller: _amountController,).setPaddingOnly(top: 12.px),
            _buildDescription(),
            SendP2PKOptionWidget(option: p2pkOption,).setPaddingOnly(top: 24.px),
            _buildContinueButton(),
          ],
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
      ),
    );
  }

  Widget _buildDescription(){
    return CommonCard(
      verticalPadding: 24.px,
      child: TextField(
        controller: _descriptionController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
          hintText: Localized.text('ox_wallet.description_hint_text'),
          hintStyle: TextStyle(fontSize: 13.sp)
        ),
      ),
    ).setPaddingOnly(top: 24.px);
  }

  Widget _buildContinueButton() {
    return ValueListenableBuilder(
        valueListenable: _amountController,
        builder: (context,value,child) {
          return ThemeButton(
            text: Localized.text('ox_wallet.continue_button'),
            height: 48.px,
            enable: enable,
            onTap: () => _nextStep(context),
          ).setPaddingOnly(top: 24.px);
        }
    );
  }
  
  Future<void> _nextStep(BuildContext context) async {
    int balance = _mint?.balance ?? 0;
    int sats = int.parse(amount);
    String memo = description.isEmpty ? 'Sent via 0xChat.' : description;
    if (balance <= 0 || balance < sats) {
      CommonToast.instance.show(context, Localized.text('ox_wallet.send_insufficient_balance'));
      return;
    }

    OXNavigator.pushPage(context, (context) =>
      WalletSendEcashOverviewPage(
        amount: sats,
        memo: memo,
        mint: _mint!,
        p2pkOption: p2pkOption.enable ? p2pkOption : null,
      ),
    );
  }

  void _onChanged(IMint mint) {
    setState(() {
      _mint = mint;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
