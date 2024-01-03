import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/page/wallet_successful_page.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/sats_amount_card.dart';

enum SendType{
  none,
  invoice
}

class WalletSendLightningPage extends StatefulWidget {
  const WalletSendLightningPage({super.key});

  @override
  State<WalletSendLightningPage> createState() => _WalletSendLightningPageState();
}

class _WalletSendLightningPageState extends State<WalletSendLightningPage> {

  final ValueNotifier<SendType> _sendType = ValueNotifier<SendType>(SendType.none);

  final TextEditingController _invoiceEditController = TextEditingController();
  final TextEditingController _amountEditController = TextEditingController();
  final TextEditingController _noteEditController = TextEditingController();

  final FocusNode _invoiceFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();

  @override
  void initState() {
    _invoiceFocus.addListener(() {
      if(!_invoiceFocus.hasFocus){
        _updateSendType();
      }
    });
    super.initState();
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
          title: 'Send',
          centerTitle: true,
          useLargeTitle: false,
        ),
        body: Column(
          children: [
            _buildInvoiceTextEdit(),
            _buildVisibilityWidget(),
          ],
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
      ),
    );
  }

  Widget _buildInvoiceTextEdit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recipeint',style: TextStyle(fontSize: 14.px,fontWeight: FontWeight.w600,color: ThemeColor.color0),),
        SizedBox(height: 12.px,),
        CommonCard(
          radius: 12.px,
          verticalPadding: 12.px,
          horizontalPadding: 16.px,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Invoice or Address',
                        hintStyle: TextStyle(fontSize: 16.px,height: 22.px / 16.px),
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      controller: _invoiceEditController,
                      focusNode: _invoiceFocus,
                      maxLines: 1,
                      showCursor: true,
                      style: TextStyle(fontSize: 16.px,height: 22.px / 16.px,color: ThemeColor.color0),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.px),
              CommonImage(
                iconName: 'icon_send_qrcode.png',
                size: 24.px,
                package: 'ox_wallet',
              ),
            ],
          ),
        ),
      ],
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
                  SatsAmountCard(controller: _amountEditController,enable: false,),
                  _buildDescriptionText(),
                  _buildPayButton(),
                ],
              )).setPaddingOnly(top: 24.px);
        });
  }

  Widget _buildDescriptionText() {
    return CommonCard(
      verticalPadding: 24.px,
      child: ValueListenableBuilder(
          valueListenable: _sendType,
          builder: (context,value,child) {
            return TextField(
              // controller: _noteEditController,
              textAlign: TextAlign.center,
              style: TextStyle(color: ThemeColor.color0),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 18.px,vertical: 0.px),
                isDense: true,
                enabled: false,
                hintText: 'This is Description',
                // enabled: _sendType.value == SendType.address,
              ),
            );
          }
      ),
    ).setPaddingOnly(top: 24.px);
  }

  Widget _buildPayButton() {
    return ListenableBuilder(
        listenable: _sendType,
        // listenable: Listenable.merge([_amountEditController,_enableButton,_tipsType]),
        builder: (context,child) {
          return ThemeButton(
            onTap: _send,
            text: 'Pay now',
            height: 48.px,
            // enable: _amountEditController.text.isNotEmpty && _amountEditController.text != '0' && _enableButton.value && !(_tipsType.value < 0),
          ).setPaddingOnly(top: 24.px);
        }
    );
  }

  bool? _checkLnurl(String lnurl) {
    if (lnurl.isEmpty) return null;
    if (lnurl.contains('@')) return true;
    if (RegExp(r'^ln[a-zA-Z0-9]+$', caseSensitive: false).hasMatch(lnurl)) return false;
    return null;
  }

  Future<void> _updateSendType() async {
    bool? result = _checkLnurl(_invoiceEditController.text);
    if (result == null){
      _sendType.value = SendType.none;
      if(_invoiceEditController.text.isNotEmpty){
        await CommonToast.instance.show(context, '请输入正确的invoice或地址');
      }
      return;
    }

    //解析Invoice
    Future.delayed(const Duration(seconds: 2));
    _amountEditController.text = '5434234';
    _sendType.value = SendType.invoice;
  }

  void _send(){
    OXNavigator.pushPage(context, (context) => const WalletSuccessfulPage(title: 'Send',canBack: true,));
  }
}
