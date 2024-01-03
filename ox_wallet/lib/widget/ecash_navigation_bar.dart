import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_wallet/page/wallet_receive_lightning_page.dart';
import 'package:ox_wallet/page/wallet_send_ecash_page.dart';
import 'package:ox_wallet/page/wallet_send_lightning_page.dart';
import 'package:ox_wallet/widget/common_modal_bottom_sheet_widget.dart';

class EcashNavigationBar extends StatefulWidget {
  const EcashNavigationBar({super.key});

  @override
  State<EcashNavigationBar> createState() => _EcashNavigationBarState();
}

class _EcashNavigationBarState extends State<EcashNavigationBar> {
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
                onTap: () {
                  List<BottomSheetItem> options = [
                    BottomSheetItem(
                      iconName: 'icon_copy.png',
                      title: 'Redeem Ecash',
                      subTitle: 'Paste & redeem a Cashu token form Clipboard.',
                      enable: false,
                      onTap: () {
                        OXNavigator.pop(context);
                      },
                    ),
                    BottomSheetItem(
                      iconName: 'icon_wallet_lightning.png',
                      title: 'Create Lightning invoice',
                      subTitle: 'Receive Ecash by Paying a Lightning invoice',
                      onTap: () {
                        OXNavigator.pop(context);
                        OXNavigator.pushPage(context, (context) => const WalletReceiveLightningPage());
                      },
                    )
                  ];
                  ShowModalBottomSheet.showOptionsBottomSheet(context, title: 'Receive', options: options);
                },
              ),
              const NavigationBarItem(label: 'Scan',iconName: 'icon_wallet_scan.png',),
              NavigationBarItem(
                label: 'Send',
                iconName: 'icon_transaction_send.png',
                onTap: () {
                  List<BottomSheetItem> options = [
                    BottomSheetItem(
                      iconName: 'icon_wallet_send.png',
                      title: 'Send Ecash',
                      subTitle: 'Create a Cashu token and send.',
                      onTap: () {
                        OXNavigator.pop(context);
                        OXNavigator.pushPage(context, (context) => WalletSendEcashPage());
                      },
                    ),
                    BottomSheetItem(
                      iconName: 'icon_wallet_lightning.png',
                      title: 'Pay Lightning invoice',
                      subTitle: 'Send your funds to a lightning node.',
                      onTap: () {
                        OXNavigator.pop(context);
                        OXNavigator.pushPage(context, (context) => const WalletSendLightningPage());
                      },
                    )
                  ];
                  ShowModalBottomSheet.showOptionsBottomSheet(context, title: 'Send', options: options);
                },
              ),
            ],
          ),
        ),
      ),
    );
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonImage(
            iconName: iconName,
            size: 24.px,
            package: 'ox_wallet',
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