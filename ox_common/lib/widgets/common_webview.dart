import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_webview+nostr.dart';
import 'package:ox_common/widgets/common_webview_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ox_common/mixin/common_js_method_mixin.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_theme/ox_theme.dart';


typedef UrlCallBack = void Function(String);

class CommonWebView extends StatefulWidget {
  final String url;
  final String? title;
  final bool hideAppbar;
  final UrlCallBack? urlCallback;
  final bool isLocalHtmlResource;

  CommonWebView(
    this.url,{
    this.title,
    this.hideAppbar = false,
    this.urlCallback,
    bool? isLocalHtmlResource,
  }) : isLocalHtmlResource = isLocalHtmlResource ?? false;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommonWebViewState<CommonWebView>();
  }
}

class CommonWebViewState<T extends CommonWebView> extends State<T>
    with CommonJSMethodMixin<T> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController currentController;

  Future<WebViewController> get controller => _controller.future;

  double loadProgress = 0;
  bool showProgress = false;

  Map<String, Function> get jsMethods => {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //If you use WillPopScope on your ios model, you cannot scroll right to close
    return Platform.isAndroid
        ? WillPopScope(
            child: _root(),
            onWillPop: () async {
              WebViewController webViewController = await controller;
              if (await webViewController.canGoBack()) {
                webViewController.goBack();
                return false;
              }
              return true;
            })
        : _root();
  }

  _root() {
    return Scaffold(
      appBar: !widget.hideAppbar ? _renderAppBar() : null,
      body: Builder(builder: (BuildContext context) {
        return buildBody();
      }),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Visibility(
          visible: !widget.hideAppbar && showProgress,
          child: LinearProgressIndicator(
            value: loadProgress.toDouble(),
            minHeight: 3,
            valueColor: AlwaysStoppedAnimation(ThemeColor.red),
            backgroundColor: Colors.transparent,
          ),
        ),
        Expanded(
          child: buildWebView(),
        )
      ],
    );
  }

  Widget buildWebView() {
    final isLocalHtmlResource = widget.isLocalHtmlResource;
    return WebView(
        debuggingEnabled: kDebugMode,
        initialUrl: isLocalHtmlResource
            ? widget.url
            : Uri.encodeFull(formatUrl(widget.url)),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          currentController = webViewController;
          _controller.complete(webViewController);
        },
        javascriptChannels: nostrChannels,
        onPageFinished: (url) {
          if(mounted){
            setState(() {
              showProgress = false;
            });
          }

          currentController.runJavascript(windowNostrJavaScript);
        },
        onProgress: (process) {
          if (loadProgress != 1) {
            if(mounted){
              setState(() {
                loadProgress = process / 100;
                showProgress = true;
              });
            }
          }
        },
        navigationDelegate: (navigationDelegate) async {
          widget.urlCallback?.call(navigationDelegate.url);
          return NavigationDecision.navigate;
        });
  }

  _renderAppBar() {
    return CommonWebViewAppBar(
      title: Text('${widget.title ?? ""}'),
      webViewControllerFuture: controller,
    );
  }

  String formatUrl(String url) {
    return url;
    if (url.contains("?")) {
      return url +
          "&lang=${Localized.getCurrentLanguage().symbol()}&theme=${ThemeManager.getCurrentThemeStyle().value()}";
    } else {
      return url +
          "?lang=${Localized.getCurrentLanguage().symbol()}&theme=${ThemeManager.getCurrentThemeStyle().value()}";
    }
  }
}
