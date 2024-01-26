import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/widgets/common_toast.dart';

class LaunchThirdPartyApp{

  static Future<void> openWallet(String url, String storeUrl, {required BuildContext context}) async {
    LogUtil.d('launch url: $url');
    Uri uri = Uri.parse(url);
    Uri storeUri = Uri.parse(storeUrl);
    try {
      await launchUrl(uri);
    } catch (e) {
      try {
        await launchUrl(storeUri);
      } catch (e) {
        CommonToast.instance.show(context, 'Unable to open the App');
      }
    }

  }
}