import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/widget/ecash_qr_code.dart';
import 'package:ox_wallet/widget/sats_amount_card.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class WalletSendEcashNewTokenPage extends StatefulWidget {
  const WalletSendEcashNewTokenPage({super.key});

  @override
  State<WalletSendEcashNewTokenPage> createState() => _WalletSendEcashNewTokenPageState();
}

class _WalletSendEcashNewTokenPageState extends State<WalletSendEcashNewTokenPage> {

  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String?> _invoiceNotifier = ValueNotifier('');
  final String token = 'lnbc1pjky30tpp59shnkt9qe4vfvzmmk2k0yevqj5c9wu2ra0fvrw28vz7slr6wctusdqqcqzzsxqyz5vqsp5qple5cdqlpnf34pa0643xd7csv9wajp5z9qxp4mkgkkt7h72s4ts9qyyssqnmmtn02mj7vj5mkjr6wxknjc4xsss0d9qrdw9pyq9zfqezzyhgu99hq4k50k623fnrxk...x23nshrjymkue8k3spnfmxn';

  String? get invoice => _invoiceNotifier.value;

  @override
  void initState() {
    super.initState();
    _createNewCashuToke();
    _controller.text = '3000';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: 'New Cashu token',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: Column(
        children: [
          SatsAmountCard(controller: _controller, enable: false,).setPaddingOnly(top: 12.px),
          _buildInvoiceCard(),
          ThemeButton(text: 'Share', height: 48.px,).setPaddingOnly(top: 24.px)
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
    );
  }

  Widget _buildInvoiceCard(){
    return ValueListenableBuilder(
        valueListenable: _invoiceNotifier,
        builder: (context,value,child) {
          return CommonCard(
            horizontalPadding: 16.px,
            verticalPadding: 24.px,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EcashQrCode(controller: _invoiceNotifier),
                _buildInvoice(),
              ],
            ),
          ).setPaddingOnly(top: 24.px);
        }
    );
  }

  Widget _buildInvoice(){
    if (invoice != null && invoice!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Token',style: TextStyle(fontSize: 14.sp),),
          SizedBox(height: 4.px,),
          Text(invoice!,style: TextStyle(fontSize: 12.sp)),
        ],
      ).setPaddingOnly(top: 31.px);
    }
    return Container();
  }

  Future<void> _createNewCashuToke() async {
    Future.delayed(const Duration(seconds: 5),()=> _invoiceNotifier.value = token);
  }
}
