import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/utils/scan_utils.dart';
import 'package:ox_wallet/page/wallet_receive_lightning_page.dart';
import 'package:ox_wallet/page/wallet_send_ecash_page.dart';
import 'package:ox_wallet/page/wallet_send_lightning_page.dart';
import 'package:ox_wallet/page/wallet_successful_page.dart';
import 'package:ox_wallet/page/wallet_swap_ecash_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/common_modal_bottom_sheet_widget.dart';

enum ItemType{
  redeemEcash,
  depositEcash,
  sendEcash,
  withdrawEcash
}

class EcashNavigationBar extends StatefulWidget {
  const EcashNavigationBar({super.key});

  @override
  State<EcashNavigationBar> createState() => _EcashNavigationBarState();
}

class _EcashNavigationBarState extends State<EcashNavigationBar> {

  late final List<BottomSheetItem> _receiveBottomSheetOptions;
  late final List<BottomSheetItem> _sendBottomSheetOptions;

  bool get isShowSwap => EcashManager.shared.mintList.length >= 2;

  @override
  void initState() {
    super.initState();
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
        onTap: () => _handlePageAction(ItemType.depositEcash),
      )
    ];

    _sendBottomSheetOptions = [
      BottomSheetItem(
        iconName: 'icon_wallet_send.png',
        title: 'Send Ecash',
        subTitle: 'Create a Cashu token and send.',
        onTap: () => _handlePageAction(ItemType.sendEcash),
      ),
      BottomSheetItem(
        iconName: 'icon_wallet_lightning.png',
        title: 'Withdraw Ecash',
        subTitle: 'Withdraw your funds to a lightning node.',
        onTap: () => _handlePageAction(ItemType.withdrawEcash),
      )
    ];
    EcashManager.shared.addListener(() {
      setState(() {});
    });
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
              if (isShowSwap)
                NavigationBarItem(
                  label: 'Swap',
                  iconName: 'icon_swap.png',
                  onTap: () => OXNavigator.pushPage(context, (context) => const WalletSwapEcashPage()),
                ),
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

  _handlePageAction(ItemType itemType) async {
    if(itemType.defaultPageBuilder != null){
      _jumpToPage(pageBuilder: itemType.defaultPageBuilder!);
    }
  }
}

extension ItemTypeEx on ItemType {
  Widget Function(BuildContext? context)? get defaultPageBuilder {
    switch (this) {
      case ItemType.depositEcash:
        return (context) => const WalletReceiveLightningPage();
      case ItemType.sendEcash:
        return (context) => const WalletSendEcashPage();
      case ItemType.withdrawEcash:
        return (context) => const WalletSendLightningPage();
      case ItemType.redeemEcash:
        return null;
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