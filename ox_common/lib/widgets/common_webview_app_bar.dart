import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
      color: backgroundColor ?? ThemeColor.color200,
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
            color: ThemeColor.color200),
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
              color: ThemeColor.color120,
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
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color160,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.px,vertical: 20.px),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItem(label: '在默认浏览器中打开',onTap: _launchURL, iconName: ''),
                _buildItem(label: '复制链接',onTap: ()=>_copyURL(context), iconName: ''),
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
        width: 80.px,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.open_in_browser,size: 48.sp,),
            SizedBox(height: 5.px,),
            Text(label,textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }

  void _launchURL() async {
    WebViewController webViewController = await webViewControllerFuture!;
    String? url = await webViewController.currentUrl();
    if(url != null && url.isNotEmpty){
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri,mode: LaunchMode.externalApplication);
      } else {
        throw 'Cannot open $url';
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
                      iconName: 'icon_back_light.png',
                      size: 24.px,
                    ),
              ) : Container();
      },
    );
  }
}
