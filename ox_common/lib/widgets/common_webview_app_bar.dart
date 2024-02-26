import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class CommonWebViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonWebViewAppBar(
      {super.key,
      this.backgroundColor,
      this.title,
      this.leading,
      this.extend,
      this.canBack = true,
      this.onClickMore,
      this.onClickClose,
      this.webViewControllerFuture});

  final Color? backgroundColor;
  final Widget? title;
  final Widget? leading;
  final Widget? extend;
  final bool canBack;
  final GestureTapCallback? onClickMore;
  final GestureTapCallback? onClickClose;
  final Future<WebViewController>? webViewControllerFuture;

  @override
  Size get preferredSize => Size.fromHeight(56.px);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? ThemeColor.color230,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.px),
          child: Row(
            children: [
              canBack ? WebViewBackBtn(webViewControllerFuture: webViewControllerFuture) : Container(),
              leading ?? Container(),
              SizedBox(width: 20.px,),
              Expanded(child: Center(child: title ?? Container())),
              _buildAction(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    return Row(children: [
      extend ?? Container(),
      SizedBox(
        width: 12.px,
      ),
      Container(
        height: 32.px,
        padding: EdgeInsets.symmetric(horizontal: 10.px),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.px),
            color: ThemeColor.color210,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTapWidget(
                child: CommonImage(
                  iconName: 'icon_dapp_more.png',
                  size: 24.px,
                ),
                onTap: onClickMore ?? ()=>_handleMore(context),
            ),
            SizedBox(
              width: 10.px,
            ),
            Container(
              height: 20.px,
              width: 0.5.px,
              color: ThemeColor.color220,
            ),
            SizedBox(
              width: 10.px,
            ),
            _buildTapWidget(
              child: CommonImage(
                iconName: 'icon_big_del.png',
                size: 24.px,
              ),
              onTap: onClickClose ?? () => OXNavigator.pop(context),
            ),
          ],
        ),
      )
    ]);
  }

  _buildTapWidget({child, onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: child,
      onTap: onTap,
    );
  }

  void _handleMore(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildMoreWidget(context));
  }

  Widget _buildMoreWidget(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.px)),
        color: ThemeColor.color180,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.px,vertical: 16.px),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItem(label: Localized.text('ox_common.webview_more_send_to_chat'),onTap: ()=>_onSendToOther(context), iconName: 'icon_share_browser.png'),
                _buildItem(label: Localized.text('ox_common.webview_more_browser'),onTap: ()=>_launchURL(context), iconName: 'icon_share_browser.png'),
                _buildItem(label: Localized.text('ox_common.webview_more_copy'),onTap: ()=>_copyURL(context), iconName: 'icon_share_link.png',),
                _buildItem(label: Localized.text('ox_common.webview_more_copy'),onTap: ()=>_onShare(context), iconName: 'icon_share_link.png',),
              ],
            ),
          ),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildTapWidget(
            onTap: () => OXNavigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: Adapt.px(56),
              child: Text(
                Localized.text('ox_common.cancel'),
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(16),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({required String label,required String iconName,GestureTapCallback? onTap}){
    return _buildTapWidget(
      onTap: onTap,
      child: Container(
        width: 60.px,
        margin: EdgeInsets.only(right: 16.px),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeColor.color170,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              width: 60.px,
              height: 60.px,
              child: CommonImage(
                iconName: iconName,
                size: 24.px,
              ),
            ),
            SizedBox(height: 8.px,),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context) async {
    WebViewController webViewController = await webViewControllerFuture!;
    String? url = await webViewController.currentUrl();
    if(url != null && url.isNotEmpty){
      final Uri uri = Uri.parse(url);
      try {
        OXNavigator.pop(context);
        await launchUrl(uri);
      } catch (e) {
        print(e.toString()+'Cannot open $url');
      }
    }
  }

  void _copyURL(BuildContext context) async {
    WebViewController webViewController = await webViewControllerFuture!;
    String? url = await webViewController.currentUrl();
    if(url != null && url.isNotEmpty) {
      OXNavigator.pop(context);
      TookKit.copyKey(context, url);
    }
  }

  void _onSendToOther(BuildContext context) async {
    WebViewController webViewController = await webViewControllerFuture!;
    String? url = await webViewController.currentUrl();
    if(url != null && url.isNotEmpty){
      OXNavigator.pop(context);
      OXModuleService.pushPage(OXNavigator.navigatorKey.currentContext!, 'ox_chat', 'ChatChooseSharePage', {
        'url': url,
      });
    }
  }

  void _onShare(BuildContext context) async {
    WebViewController webViewController = await webViewControllerFuture!;
    String? url = await webViewController.currentUrl();
    if(url != null && url.isNotEmpty){
      OXNavigator.pop(context);
      Share.share(url);
    }
  }
}

class WebViewBackBtn extends StatelessWidget {
  final Future<WebViewController>? webViewControllerFuture;
  final Widget? backIcon;

  WebViewBackBtn({this.webViewControllerFuture, this.backIcon});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: webViewControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady = snapshot.connectionState == ConnectionState.done;
        WebViewController? controller = snapshot.data;
        return controller != null
            ? GestureDetector(
                onTap: webViewReady
                    ? () async {
                        if (await controller.canGoBack()) {
                          await controller.goBack();
                        } else {
                          OXNavigator.pop(context);
                        }
                      }
                    : null,
                child: this.backIcon ??
                    CommonImage(
                      iconName: 'icon_webview_back.png',
                      useTheme: true,
                      size: 24.px,
                    ),
              ) : Container();
      },
    );
  }
}
