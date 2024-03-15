import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
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
import 'package:ox_wallet/utils/lightning_utils.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';
import 'package:ox_wallet/widget/mint_indicator_item.dart';
import 'package:ox_wallet/widget/sats_amount_card.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_localizable/ox_localizable.dart';

enum SendType{
  none,
  invoice,
  address
}

class WalletSendLightningPage extends StatefulWidget {
  final Map<String,String>? external;
  const WalletSendLightningPage({super.key,this.external});

  @override
  State<WalletSendLightningPage> createState() => _WalletSendLightningPageState();
}

class _WalletSendLightningPageState extends State<WalletSendLightningPage> {

  final ValueNotifier<SendType> _sendType = ValueNotifier<SendType>(SendType.none);
  final ValueNotifier<IMint?> _mintNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _enableButton = ValueNotifier(true);

  final TextEditingController _invoiceEditController = TextEditingController();
  final TextEditingController _amountEditController = TextEditingController();

  final FocusNode _invoiceFocus = FocusNode();
  String get invoice => _invoiceEditController.text;
  IMint? get mint => _mintNotifier.value;
  String get amount => _amountEditController.text;

  @override
  void initState() {
    super.initState();
    _mintNotifier.value = EcashManager.shared.defaultIMint;
    _invoiceFocus.addListener(_focusChanged);
    _initExternalData();
  }
  
  _focusChanged(){
    if(!_invoiceFocus.hasFocus){
      _updateSendType();
    }
  }

  void _initExternalData() {
    final externalData = widget.external;
    if (externalData != null) {
      bool hasRequiredKeys = externalData.containsKey('invoice') && externalData.containsKey('amount');
      if (hasRequiredKeys) {
        _sendType.value = SendType.invoice;
        _invoiceEditController.text = externalData['invoice']!;
        _amountEditController.text = externalData['amount']!;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
          title: Localized.text('ox_wallet.send_text'),
          centerTitle: true,
          useLargeTitle: false,
        ),
        body: Column(
          children: [
            _buildSelectMintWidget(),
            _buildInvoiceTextEdit(),
            _buildVisibilityWidget(),
          ],
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
      ),
    );
  }

  Widget _buildSelectMintWidget() {
    return ValueListenableBuilder(
      valueListenable: _mintNotifier,
      builder: (context, value, child) =>
          MintIndicatorItem(mint: value, onChanged: (mint) =>  _mintNotifier.value = mint),
    );
  }

  Widget _buildInvoiceTextEdit() {
    return CommonLabeledCard.textFieldAndScan(
      label: Localized.text('ox_wallet.recipient'),
      hintText: Localized.text('ox_wallet.invoice_hint_text'),
      controller: _invoiceEditController,
      focusNode: _invoiceFocus,
      onTap: (){
        WalletUtils.gotoScan(context, (result) {
          _invoiceEditController.text = result;
          _updateSendType();
        },);
      },
    ).setPaddingOnly(top: 12.px);
  }

  Widget _buildVisibilityWidget() {
    return ValueListenableBuilder(
        valueListenable: _sendType,
        builder: (context, value, child) {
          return Visibility(
              visible: _sendType.value != SendType.none,
              child: Column(
                children: [
                  SatsAmountCard(controller: _amountEditController,enable: _sendType.value == SendType.address,),
                  _buildPayButton(),
                ],
              )).setPaddingOnly(top: 24.px);
        });
  }

  Widget _buildPayButton() {
    return ListenableBuilder(
      listenable: Listenable.merge([_mintNotifier,_amountEditController, _enableButton]),
      builder: (context, child) {
        final enable = amount.isNotEmpty && int.parse(amount) > 0 && mint != null && _enableButton.value;
        return ThemeButton(
          onTap: _send,
          text: Localized.text('ox_wallet.pay_now_button'),
          height: 48.px,
          enable: enable,
        ).setPaddingOnly(top: 24.px);
      }
    );
  }

  Future<void> _updateSendType() async {
    if (invoice.isEmpty) return;
    if (invoice.contains('@')) {
      _sendType.value = SendType.address;
      return;
    }

    bool result = EcashService.isLnInvoice(invoice);
    if (!result){
      _sendType.value = SendType.none;
      await CommonToast.instance.show(context, Localized.text('ox_wallet.invoice_valid_tips'));
      return;
    }

    int? amount = EcashService.decodeLightningInvoice(invoice: invoice);
    if(amount == null){
      CommonToast.instance.show(context, Localized.text('ox_wallet.invoice_decode_failed_tips'));
      return;
    }
    _amountEditController.text = amount.toString();
    _sendType.value = SendType.invoice;
  }

  Future<void> _send() async {
    if (mint == null) {
      CommonToast.instance.show(context, Localized.text('ox_wallet.withdraw_valid_tips'));
      return;
    }
    int balance = mint?.balance ?? 0;
    int sats = int.parse(amount);
    if (balance <= 0 || balance < sats) {
      CommonToast.instance.show(context, Localized.text('ox_wallet.send_insufficient_balance'));
      return;
    }
    String invoice = '';
    _enableButton.value = false;
    if(_sendType.value == SendType.address){
      try {
        OXLoading.show(status: Localized.text('ox_wallet.generating_invoice'));
        invoice = await LightningUtils.getInvoice(sats, _invoiceEditController.text);
        OXLoading.dismiss();
      } catch (e, s) {
        OXLoading.dismiss();
        _enableButton.value = true;
        if (context.mounted) CommonToast.instance.show(context, Localized.text('ox_wallet.generate_invoice_failed'));
        LogUtil.e("Invoice generation failed: $e\r\n$s");
        return;
      }
    } else {
      invoice = _invoiceEditController.text;
    }
    OXLoading.show();
    EcashService.payingLightningInvoice(mint: mint!, pr: invoice)
        .then((result) {
        OXLoading.dismiss();
        _enableButton.value = true;
        if (result != null && result) {
          OXNavigator.pushPage(
            context,
            (context) => WalletSuccessfulPage(
              title: Localized.text('ox_wallet.send_text'),
              canBack: true,
              content: Localized.text('ox_wallet.swap_success_tips').replaceAll(r'${amount}', amount),
            ),
          );
          return;
        }
        CommonToast.instance.show(context, Localized.text('ox_wallet.pay_invoice_failed'));
      },
    );
  }

  @override
  void dispose() {
    _sendType.dispose();
    _mintNotifier.dispose();
    _enableButton.dispose();
    _invoiceEditController.dispose();
    _amountEditController.dispose();
    _invoiceFocus.removeListener(_focusChanged);
    _invoiceFocus.dispose();
    super.dispose();
  }
}
