import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/common_option_item.dart';
import 'package:ox_wallet/widget/counter_down.dart';
import 'package:ox_wallet/widget/ecash_tab_bar.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class WalletReceiveLightningPage extends StatefulWidget {
  const WalletReceiveLightningPage({super.key});

  @override
  State<WalletReceiveLightningPage> createState() => _WalletReceiveLightningPageState();
}

class _WalletReceiveLightningPageState extends State<WalletReceiveLightningPage> with SingleTickerProviderStateMixin{

  late final TabController _controller;

  final List<String> tabsName = const ['Sats', 'BTC'];

  @override
  void initState() {
    _controller = TabController(length: tabsName.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: ThemeColor.color190,
          appBar: CommonAppBar(
            title: 'Receive',
            centerTitle: true,
            useLargeTitle: false,
            actions: [
              CommonImage(
                iconName: 'icon_share.png',
                size: 24.px,
                package: 'ox_wallet',
              ).setPaddingOnly(right: 20.px),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EcashTabBar(controller: _controller, tabsName: tabsName,),
              SizedBox(height: 12.px,),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: const [
                    SatsReceiveTabView(),
                    BTCReceiveTabView(),
                  ],
                ),
              ),
            ],
          ).setPaddingOnly(top: 12.px)
      ),
    );
  }
}

class SatsReceiveTabView extends StatefulWidget {
  const SatsReceiveTabView({super.key});

  @override
  State<SatsReceiveTabView> createState() => _SatsReceiveTabViewState();
}

class _SatsReceiveTabViewState extends State<SatsReceiveTabView> {

  final ValueNotifier<String?> _invoiceNotifier = ValueNotifier('');
  final ValueNotifier<int> _expiredTimeNotifier = ValueNotifier(0);
  final TextEditingController _amountEditController = TextEditingController();
  final TextEditingController _noteEditController = TextEditingController();
  final FocusNode _noteFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();

  final String token = 'lnbc1pjky30tpp59shnkt9qe4vfvzmmk2k0yevqj5c9wu2ra0fvrw28vz7slr6wctusdqqcqzzsxqyz5vqsp5qple5cdqlpnf34pa0643xd7csv9wajp5z9qxp4mkgkkt7h72s4ts9qyyssqnmmtn02mj7vj5mkjr6wxknjc4xsss0d9qrdw9pyq9zfqezzyhgu99hq4k50k623fnrxk...x23nshrjymkue8k3spnfmxn';

  @override
  void initState() {
    _createInvoice();
    _amountFocus.addListener(() => _focusChanged(_amountFocus));
    _noteFocus.addListener(() => _focusChanged(_noteFocus));
    super.initState();
  }

  void _focusChanged(FocusNode focusNode) {
    if (focusNode.hasFocus) {
      _invoiceNotifier.value = '';
      _expiredTimeNotifier.value = 0;
    } else {
      _createInvoice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildReceiveInfo(),
              _buildLightningInvoice(),
              _buildAmountEdit(),
              _buildNoteEdit(),
            ],
          ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
        ),
      ],
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
                Container(
                  height: 260.px,
                  width: 260.px,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.px),
                    color: _invoiceNotifier.value != null &&_invoiceNotifier.value!.isNotEmpty ? Colors.white : ThemeColor.color100,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: _buildQRCode(),
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildQRCode() {
    if (_invoiceNotifier.value == '') {
      return Center(
        child: SizedBox(
            width: 50.px,
            height: 50.px,
            child: const CircularProgressIndicator()),
      );
    }
    if (_invoiceNotifier.value == null) {
      return Center(
        child: Icon(
          Icons.warning,
          size: 50.px,
          color: Colors.yellow,
        ),
      );
    }
    return PrettyQr(
      data: _invoiceNotifier.value!,
      errorCorrectLevel: QrErrorCorrectLevel.M,
      typeNumber: null,
      roundEdges: true,
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
    return CommonOptionItem.textField(
      label: 'Amount',
      hintText: 'Enter Amount',
      suffixText: 'Sats',
      controller: _amountEditController,
      focusNode: _amountFocus,
      keyboardType: TextInputType.number,
    ).setPaddingOnly(top: 16.px);
  }

  Widget _buildNoteEdit(){
    return CommonOptionItem.textField(
      label: 'Public',
      hintText: 'Add Public Note',
      controller: _noteEditController,
      focusNode: _noteFocus,
    ).setPaddingOnly(top: 16.px);
  }

  Future<void> _createInvoice() async {
    Future.delayed(const Duration(seconds: 5),()=> _invoiceNotifier.value = token);
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
    super.dispose();
  }
}


class BTCReceiveTabView extends StatefulWidget {
  const BTCReceiveTabView({super.key});

  @override
  State<BTCReceiveTabView> createState() => _BTCReceiveTabViewState();
}

class _BTCReceiveTabViewState extends State<BTCReceiveTabView> {

  final ValueNotifier<String?> _invoiceNotifier = ValueNotifier('');
  final String tips = '• Do not send Ordinals or any inscriptions to this address\r\n• Do not send more than 0.05BTC to this address';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildReceiveInfo(),
            ],
          ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
        ),
      ],
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
                const Text('bc1qw2cwz63l6a8jasgy2l2ruth0pmt4dah8fda6fv',),
                SizedBox(height: 16.px,),
                Container(
                  height: 260.px,
                  width: 260.px,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.px),
                    color: _invoiceNotifier.value != null &&_invoiceNotifier.value!.isNotEmpty ? Colors.white : ThemeColor.color100,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: _buildQRCode(),
                ),
                SizedBox(height: 16.px,),
                Text(tips,style: TextStyle(color: ThemeColor.red1,fontSize: 12.px,height: 20.px / 12.px),),
              ],
            ),
          );
        }
    );
  }

  Widget _buildQRCode() {
    if (_invoiceNotifier.value == '') {
      return Center(
        child: SizedBox(
            width: 50.px,
            height: 50.px,
            child: const CircularProgressIndicator()),
      );
    }
    if (_invoiceNotifier.value == null) {
      return Center(
        child: Icon(
          Icons.warning,
          size: 50.px,
          color: Colors.yellow,
        ),
      );
    }
    return PrettyQr(
      data: _invoiceNotifier.value!,
      errorCorrectLevel: QrErrorCorrectLevel.M,
      typeNumber: null,
      roundEdges: true,
    );
  }
}


