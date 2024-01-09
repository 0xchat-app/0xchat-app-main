import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_wallet/widget/screenshot_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_scan_page.dart';

class WalletUtils {

  static double satoshiToBitcoin(double satoshiAmount) {
    return satoshiAmount / 100000000;
  }

  static double bitcoinToUSD(double amount){
    double currentPrice = 2228.81;
    return amount * currentPrice;
  }

  static String satoshiToUSD(double satoshiAmount,{int decimal = 2}) {
    return bitcoinToUSD(satoshiToBitcoin(satoshiAmount)).toStringAsFixed(decimal);
  }

  static Future<String?> getClipboardData() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    String? text;
    if (data != null) {
      text = data.text;
    }
    return text;
  }

  static Future<void> takeScreen(GlobalKey<ScreenshotWidgetState> screenshotKey) async {
    String? imagePath = await screenshotKey.currentState?.saveScreenshotToFile();
    if (imagePath != null) {
      Share.shareFiles([imagePath]);
    }
  }

  static Future<void> gotoScan(BuildContext context, Function(String result) onScanResult) async {
    PermissionStatus permissionStatus = await Permission.camera.request();
    // if (!mounted) return;
    if (permissionStatus.isGranted) {
      String? result = await OXNavigator.pushPage(context, (context) => CommonScanPage());
      if (result != null) {
        onScanResult(result);
      }
    } else {
      OXCommonHintDialog.show(context,
          content: 'Please grant access to the camera',
          actionList: [
            OXCommonHintAction(
                text: () => 'Go to Settings',
                onTap: () {
                  openAppSettings();
                  Navigator.pop(context);
                }),
          ]);
    }
  }
}
