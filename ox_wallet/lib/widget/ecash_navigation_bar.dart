import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/utils/scan_utils.dart';
import 'package:ox_wallet/page/wallet_mint_choose_page.dart';
import 'package:ox_wallet/page/wallet_receive_lightning_page.dart';
import 'package:ox_wallet/page/wallet_send_ecash_page.dart';
import 'package:ox_wallet/page/wallet_send_lightning_page.dart';
import 'package:ox_wallet/page/wallet_successful_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/common_modal_bottom_sheet_widget.dart';

class EcashNavigationBar extends StatefulWidget {
  const EcashNavigationBar({super.key});

  @override
  State<EcashNavigationBar> createState() => _EcashNavigationBarState();
}

class _EcashNavigationBarState extends State<EcashNavigationBar> {

  late final List<BottomSheetItem> _receiveBottomSheetOptions;
  late final List<BottomSheetItem> _sendBottomSheetOptions;
  bool get isUnsetDefaultMint => EcashManager.shared.defaultIMint == null;

  @override
  void initState() {
    _receiveBottomSheetOptions = [
      BottomSheetItem(
        iconName: 'icon_copy.png',
        title: 'Redeem Ecash',
        subTitle: 'Paste & redeem a Cashu token form Clipboard.',
        enable: false,
        onTap: _redeemCashuToken,
      ),
      BottomSheetItem(
        iconName: 'icon_wallet_lightning.png',
        title: 'Deposit Ecash',
        subTitle: 'Deposit Ecash by Paying a Lightning invoice',
        onTap: () => _handlePageAction(ChooseType.createInvoice),
      )
    ];

    _sendBottomSheetOptions = [
      BottomSheetItem(
        iconName: 'icon_wallet_send.png',
        title: 'Send Ecash',
        subTitle: 'Create a Cashu token and send.',
        onTap: () => _handlePageAction(ChooseType.ecash),
      ),
      BottomSheetItem(
        iconName: 'icon_wallet_lightning.png',
        title: 'Withdraw Ecash',
        subTitle: 'Withdraw your funds to a lightning node.',
        onTap: () => _handlePageAction(ChooseType.payInvoice),
      )
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.px),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ThemeColor.color180.withOpacity(0.72),
            borderRadius: BorderRadius.circular(24.px),
            boxShadow: [
              BoxShadow(
                color: ThemeColor.titleColor.withOpacity(0.2),
                offset: const Offset(0,4),
                blurRadius: 8
              ),
            ]
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NavigationBarItem(
                label: 'Receive',
                iconName: 'icon_transaction_receive.png',
                onTap: () => ShowModalBottomSheet.showOptionsBottomSheet(context, title: 'Receive', options: _receiveBottomSheetOptions),
              ),
              NavigationBarItem(label: 'Scan',iconName: 'icon_wallet_scan.png',onTap: () => WalletUtils.gotoScan(context, (result) => ScanUtils.analysis(context, result)),),
              NavigationBarItem(
                label: 'Send',
                iconName: 'icon_transaction_send.png',
                onTap: () => ShowModalBottomSheet.showOptionsBottomSheet(context, title: 'Send', options: _sendBottomSheetOptions),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _redeemCashuToken() async {
    String? content = await WalletUtils.getClipboardData();
    if(content!=null && content.isNotEmpty){
      if(EcashService.isCashuToken(content)){
        OXLoading.show();
        final result = await EcashService.redeemEcash(content);
        OXLoading.dismiss();
        if(!result.isSuccess) {
          _showToast(result.errorMsg);
          return;
        }
        final (memo, amount) = result.data;
        if(context.mounted) await OXNavigator.pushPage(context, (context) => WalletSuccessfulPage.redeemClaimed(amount: amount.toString(),content: memo,onTap: () => OXNavigator.pop(context!),));
      }else{
        _showToast('Not a valid cashu token, Please re-enter');
      }
    }else {
      _showToast('The clipboard has no content');
    }
    if(context.mounted) OXNavigator.pop(context);
  }

  void _showToast(String message) {
    if (context.mounted) CommonToast.instance.show(context, message);
  }

  void _jumpToPage({required Widget Function(BuildContext? context) pageBuilder}) {
    if (context.mounted) {
      OXNavigator.pop(context);
      OXNavigator.pushPage(context, pageBuilder);
    }
  }

  bool _hasMintAdded(){
    if(EcashManager.shared.mintList.isEmpty){
      _showToast('Please add the default Mint first.');
      return false;
    }
    return true;
  }

  _handlePageAction(ChooseType actionType) async {
    if (!_hasMintAdded()) return;

    Widget Function(BuildContext?) pageBuilder;
    if (isUnsetDefaultMint) {
      pageBuilder = (context) => WalletMintChoosePage(type: actionType);
    } else {
      pageBuilder = actionType.defaultPageBuilder;
    }
    _jumpToPage(pageBuilder: pageBuilder);
  }
}

extension ChooseTypeExtension on ChooseType {
  Widget Function(BuildContext? context) get defaultPageBuilder {
    switch (this) {
      case ChooseType.createInvoice:
        return (context) => const WalletReceiveLightningPage();
      case ChooseType.ecash:
        return (context) => WalletSendEcashPage();
      case ChooseType.payInvoice:
        return (context) => const WalletSendLightningPage();
    }
  }
}

class NavigationBarItem extends StatelessWidget {
  final String label;
  final String iconName;
  final VoidCallback? onTap;
  const NavigationBarItem({super.key, required this.label, required this.iconName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonImage(
            iconName: iconName,
            size: 24.px,
            package: 'ox_wallet',
            useTheme: true,
          ),
          SizedBox(height: 4.px,),
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10.px,
                color: ThemeColor.color100),
          ),
        ],
      ),
    );
  }
}