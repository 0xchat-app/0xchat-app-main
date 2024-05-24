import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/page/wallet_successful_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';
import 'package:ox_wallet/widget/mint_indicator_item.dart';
import 'package:ox_wallet/widget/sats_amount_card.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_localizable/ox_localizable.dart';

class WalletSwapEcashPage extends StatefulWidget {
  const WalletSwapEcashPage({super.key});

  @override
  State<WalletSwapEcashPage> createState() => _WalletSwapEcashPageState();
}

class _WalletSwapEcashPageState extends State<WalletSwapEcashPage> {

  final TextEditingController _amountEditController = TextEditingController();
  final ValueNotifier<IMint?> _sendMintNotifier = ValueNotifier(EcashManager.shared.defaultIMint);
  final ValueNotifier<IMint?> _receiveNotifier = ValueNotifier(null);

  String get amount => _amountEditController.text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
          title: Localized.text('ox_wallet.swap_ecash'),
          centerTitle: true,
          useLargeTitle: false,
        ),
        body: Column(
          children: [
            _buildSwapWidget(),
            SatsAmountCard(controller: _amountEditController).setPaddingOnly(top: 24.px),
            _buildSwapButton(),
          ],
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
      ),
    );
  }

  Widget _buildSelectMintWidget(String label, ValueNotifier<IMint?> mintNotifier, {ValueChanged<IMint?>? onChanged}) {
    return CommonLabeledCard(
      label: label,
      child: MintIndicatorItem(
        mint: mintNotifier.value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSwapWidget() {
    return ListenableBuilder(
        listenable: Listenable.merge([_sendMintNotifier, _receiveNotifier]),
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildSelectMintWidget(
                  Localized.text('ox_wallet.from'),
                  _sendMintNotifier,
                  onChanged: (mint) => _mintChanged(mint, _sendMintNotifier, _receiveNotifier),
                ).setPaddingOnly(top: 12.px),
                _buildSelectMintWidget(
                  Localized.text('ox_wallet.to'),
                  _receiveNotifier,
                  onChanged: (mint) => _mintChanged(mint, _receiveNotifier, _sendMintNotifier),
                ).setPaddingOnly(top: 24.px),
              ],
            ),
          );
        },
    );
  }

  Widget _buildSwapButton() {
    return ListenableBuilder(
        listenable: Listenable.merge([_amountEditController,_sendMintNotifier,_receiveNotifier]),
        builder: (context, child) {
          return ThemeButton(
            onTap: _swap,
            text: Localized.text('ox_wallet.swap'),
            height: 48.px,
            enable: _isValid(),
          ).setPaddingOnly(top: 24.px);
        }
    );
  }

  void _mintChanged(
    IMint? selectedMint,
    ValueNotifier<IMint?> exchange,
    ValueNotifier<IMint?> recipient,
  ) {
    exchange.value = selectedMint;
    if (exchange.value == recipient.value) {
      recipient.value = null;
    }
  }

  bool _isValid() {
    return amount.isNotEmpty &&
        int.parse(amount) > 0 &&
        _receiveNotifier.value != null &&
        _sendMintNotifier.value != null;
  }

  Future<void> _swap() async {
    try{
      if(!_isValid()) return;
      int amount = int.parse(_amountEditController.text);
      if(_sendMintNotifier.value!.balance < amount) throw SwapException(Localized.text('ox_wallet.swap_insufficient_balance'));

      OXLoading.show();
      final receipt = await EcashService.createLightningInvoice(mint: _receiveNotifier.value!, amount: amount);
      if(receipt == null) throw SwapException(Localized.text('ox_wallet.swap_failed'));

      final payingResponse = await EcashService.payingLightningInvoice(mint: _sendMintNotifier.value!, pr: receipt.request);
      if (payingResponse == null || !payingResponse.isSuccess) {
        await Cashu.deleteLightningInvoice(receipt);
        throw SwapException(payingResponse?.errorMsg ?? Localized.text('ox_wallet.swap_failed'));
      }

      final response = await Cashu.checkReceiptCompleted(receipt);
      if(!response.isSuccess) throw SwapException(Localized.text('ox_wallet.swap_failed'));
      OXLoading.dismiss();
      setState(() {});
      if (context.mounted) {
        OXNavigator.pushPage(
          context,
          (context) => WalletSuccessfulPage(
            title: Localized.text('ox_wallet.swap'),
            canBack: true,
            content: Localized.text('ox_wallet.swap_success_tips').replaceAll(r'$amount', '$amount'),
          ),
        );
      }
    } catch (e) {
      OXLoading.dismiss();
      if (e is SwapException) if (context.mounted) CommonToast.instance.show(context, e.message);
    }
  }

  @override
  void dispose() {
    _amountEditController.dispose();
    _sendMintNotifier.dispose();
    _receiveNotifier.dispose();
    super.dispose();
  }
}

class SwapException implements Exception {
  final String message;

  SwapException(this.message);
}