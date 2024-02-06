import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_wallet/page/wallet_home_page.dart';
import 'package:ox_wallet/page/wallet_successful_page.dart';
import 'package:ox_wallet/services/ecash_listener.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';
import 'package:ox_wallet/widget/counter_down.dart';
import 'package:ox_wallet/widget/ecash_qr_code.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/widget/mint_indicator_item.dart';
import 'package:ox_wallet/widget/screenshot_widget.dart';

class SatsReceivePage extends StatefulWidget {
  final ValueNotifier<bool>? shareController;
  const SatsReceivePage({super.key, this.shareController});

  @override
  State<SatsReceivePage> createState() => _SatsReceivePageState();
}

class _SatsReceivePageState extends State<SatsReceivePage> {

  final ValueNotifier<String?> _invoiceNotifier = ValueNotifier('');
  final ValueNotifier<int> _expiredTimeNotifier = ValueNotifier(0);
  final ValueNotifier<IMint?> _mintNotifier = ValueNotifier(null);
  final TextEditingController _amountEditController = TextEditingController();
  final TextEditingController _noteEditController = TextEditingController();
  final FocusNode _noteFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  late final EcashListener payInvoiceListener;
  final _stasReceivePageScreenshotKey = GlobalKey<ScreenshotWidgetState>();

  String get amount => _amountEditController.text;
  String get note => _noteEditController.text;
  String? get invoice => _invoiceNotifier.value;
  IMint? get mint => _mintNotifier.value;

  String _amountLastInput = '', _noteLastInput = '';
  late IMint? _mintLastSelected;

  @override
  void initState() {
    super.initState();
    _mintNotifier.value = EcashManager.shared.defaultIMint;
    _amountEditController.text = '21';
    _amountLastInput = amount;
    _mintLastSelected = mint;
    _createLightningInvoice();
    _amountFocus.addListener(() => _focusChanged(_amountFocus));
    _noteFocus.addListener(() => _focusChanged(_noteFocus));
    payInvoiceListener = EcashListener(onInvoicePaidChanged: _onInvoicePaid);
    Cashu.addInvoiceListener(payInvoiceListener);
    widget.shareController?.addListener(_shareListener);
  }

  void _focusChanged(FocusNode focusNode) {
    if(!focusNode.hasFocus){
      if(amount == _amountLastInput && note == _noteLastInput){
        return;
      }else{
        _amountLastInput = amount;
        _noteLastInput = note;
        _createLightningInvoice();
      }
    }
  }

  void _onInvoicePaid(Receipt receipt) {
    OXNavigator.pushPage(
      context,
      (context) => WalletSuccessfulPage.invoicePaid(
        amount: receipt.amount,
        onTap: () => OXNavigator.popToPage(context!,
            pageType: const WalletHomePage().runtimeType.toString()),
      ),
    );
  }

  void _shareListener() async {
    if(mint == null) {
      await CommonToast.instance.show(context, 'Please select mint first');
      return;
    }
    await OXModuleService.pushPage(context, 'ox_usercenter', 'ZapsInvoiceDialog', {'invoice':_invoiceNotifier.value});
    // WalletUtils.takeScreen(_stasReceivePageScreenshotKey);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSelectMintWidget(),
              _buildVisibilityWidget(),
            ],
          ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
        ),
      ],
    );
  }

  Widget _buildVisibilityWidget() {
    return ValueListenableBuilder(
      valueListenable: _mintNotifier,
      builder: (context, value, child) {
        return Visibility(
          visible: value != null,
          child: Column(
            children: [
              _buildReceiveInfo(),
              _buildLightningInvoice(),
              _buildAmountEdit(),
              _buildNoteEdit(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectMintWidget() {
    return ValueListenableBuilder(
      valueListenable: _mintNotifier,
      builder: (context, value, child) =>
          MintIndicatorItem(mint: value, onChanged: _onChanged),
    );
  }

  Widget _buildReceiveInfo(){
    return ValueListenableBuilder(
        valueListenable: _invoiceNotifier,
        builder: (context,value,child) {
          return CommonCard(
            verticalPadding: 24.px,
            height: 386.px,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCountDownWidget(),
                SizedBox(height: 16.px,),
                ScreenshotWidget(key:_stasReceivePageScreenshotKey, child: EcashQrCode(controller: _invoiceNotifier,onRefresh: () => _createLightningInvoice(),)),
              ],
            ),
          ).setPaddingOnly(top: 12.px);
        }
    );
  }

  Widget _buildCountDownWidget(){
    if(_invoiceNotifier.value == null || _invoiceNotifier.value == '0'){
      return Container();
    }
    return ValueListenableBuilder(
        valueListenable: _expiredTimeNotifier,
        builder: (context,value,child) {
          return _expiredTimeNotifier.value > 0 ? Column(
            children: [
              Text('Invoice Expires In',style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w400,color: ThemeColor.color100),),
              SizedBox(height: 2.px,),
              CounterDown(second: _expiredTimeNotifier.value),
            ],
          ) : Container();
        }
    );
  }

  Widget _buildLightningInvoice(){
    return CommonCard(
      verticalPadding: 16.px,
      horizontalPadding: 15.px,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lightning Invoice',style: TextStyle(fontSize: 16.px,color: ThemeColor.color0),),
          SizedBox(height: 4.px,),
          ValueListenableBuilder(
              valueListenable: _invoiceNotifier,
              builder: (context,value,child) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    if(_invoiceNotifier.value!=null && _invoiceNotifier.value!.isNotEmpty){
                      TookKit.copyKey(context, _invoiceNotifier.value ?? '');
                    }
                  },
                  child: Text(_invoiceNotifier.value ?? '', style: TextStyle(fontSize: 12.px, fontWeight: FontWeight.w400,),),);
              }
          ),
        ],
      ),
    ).setPaddingOnly(top: 12.px);
  }

  Widget _buildAmountEdit() {
    return CommonLabeledCard.textField(
      label: 'Amount',
      hintText: 'Enter Amount',
      suffix: Text('Sats',style: TextStyle(fontSize: 16.px,color: ThemeColor.color0, height: 22.px / 16.px),),
      controller: _amountEditController,
      focusNode: _amountFocus,
      keyboardType: TextInputType.number,
    ).setPaddingOnly(top: 16.px);
  }

  Widget _buildNoteEdit(){
    return CommonLabeledCard.textField(
      label: 'Public',
      hintText: 'Add Public Note',
      controller: _noteEditController,
      focusNode: _noteFocus,
    ).setPaddingOnly(top: 16.px);
  }

  Future<void> _createLightningInvoice() async {
    if(mint == null) return;
    int amountSats = int.parse(amount);
    _updateLoadingStatus();
    Receipt? receipt = await EcashService.createLightningInvoice(mint: mint!, amount: amountSats);
    if(receipt != null && receipt.request.isNotEmpty){
      _invoiceNotifier.value = receipt.request;
      // _expiredTimeNotifier.value = receipt.expiry;
      _expiredTimeNotifier.value = 3600;
      return;
    }
    _invoiceNotifier.value = null;
  }

  void _updateLoadingStatus() {
    _invoiceNotifier.value = '';
    _expiredTimeNotifier.value = 0;
  }

  void _onChanged(IMint mint) {
    _mintNotifier.value = mint;
    if(_mintLastSelected != mint) {
      _createLightningInvoice();
      _mintLastSelected = mint;
    }
  }

  @override
  void dispose() {
    _amountEditController.dispose();
    _noteEditController.dispose();
    _invoiceNotifier.dispose();
    _expiredTimeNotifier.dispose();
    _amountFocus.removeListener(() => _focusChanged(_amountFocus));
    _noteFocus.removeListener(() => _focusChanged(_noteFocus));
    _amountFocus.dispose();
    _noteFocus.dispose();
    Cashu.removeInvoiceListener(payInvoiceListener);
    _mintNotifier.dispose();
    super.dispose();
  }
}
