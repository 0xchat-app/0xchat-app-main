import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_wallet/page/contact_choose_page.dart';
import 'package:ox_wallet/page/wallet_home_page.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/widget/ecash_qr_code.dart';
import 'package:ox_wallet/widget/sats_amount_card.dart';
import 'package:ox_wallet/widget/screenshot_widget.dart';
import 'package:chatcore/chat-core.dart';

class WalletSendEcashNewTokenPage extends StatefulWidget {
  final String token;
  final int amount;
  const WalletSendEcashNewTokenPage({super.key, required this.token, required this.amount});

  @override
  State<WalletSendEcashNewTokenPage> createState() => _WalletSendEcashNewTokenPageState();
}

class _WalletSendEcashNewTokenPageState extends State<WalletSendEcashNewTokenPage> {

  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> _tokenNotifier = ValueNotifier('');
  final _newTokenPageScreenshotKey = GlobalKey<ScreenshotWidgetState>();

  String get token => _tokenNotifier.value;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.amount.toString();
    _tokenNotifier.value = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {return false;},
      child: Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
          title: 'New Cashu token',
          centerTitle: true,
          useLargeTitle: false,
          backCallback: () => OXNavigator.popToPage(context, pageType: const WalletHomePage().runtimeType.toString()),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SatsAmountCard(controller: _controller, enable: false,).setPaddingOnly(top: 12.px),
              _buildTokenCard(),
              ThemeButton(
                  text: 'Share',
                  height: 48.px,
                  onTap: () => OXNavigator.presentPage(
                      context,
                      (context) => ContactChoosePage<UserDB>(contactType: ContactType.contact, onSubmitted: _shareCashuToken,)),
              ).setPaddingOnly(top: 24.px),
            ],
          ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
        ),
      ),
    );
  }

  Widget _buildTokenCard(){
    return CommonCard(
      horizontalPadding: 16.px,
      verticalPadding: 24.px,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScreenshotWidget(key:_newTokenPageScreenshotKey,child: EcashQrCode(controller: _tokenNotifier)),
          _buildToken(),
        ],
      ),
    ).setPaddingOnly(top: 24.px);
  }

  Widget _buildToken(){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => TookKit.copyKey(context, token),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Token',style: TextStyle(fontSize: 14.sp),),
          SizedBox(height: 4.px,),
          Text(WalletUtils.formatString(token),style: TextStyle(fontSize: 12.sp)),
        ],
      ).setPaddingOnly(top: 31.px),
    );
  }

  void _shareCashuToken(List<UserDB> userList){
    if(userList.isEmpty){
      CommonToast.instance.show(context, 'Please select share contact');
      return;
    }
    for (var user in userList) {
      OXModuleService.invoke('ox_chat', 'sendTextMsg', [context,user.pubKey,token]);
    }
    OXNavigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tokenNotifier.dispose();
    super.dispose();
  }
}
