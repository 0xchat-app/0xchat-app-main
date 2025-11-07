import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_webview+nostr.dart';
import 'package:ox_common/widgets/common_webview_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ox_common/mixin/common_js_method_mixin.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_theme/ox_theme.dart';

typedef JavascriptMessageHandler = void Function(JavaScriptMessage message);
final RegExp _validChannelNames = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');

typedef UrlCallBack = void Function(String);

class CommonWebView extends StatefulWidget {
  final String url;
  final String? title;
  final bool hideAppbar;
  final UrlCallBack? urlCallback;
  final bool isLocalHtmlResource;
  final String? nappName;
  final String? nappUrl;
  final String? nappId;

  CommonWebView(
    this.url,{
    this.title,
    this.hideAppbar = false,
    this.urlCallback,
    bool? isLocalHtmlResource,
    this.nappName,
    this.nappUrl,
    this.nappId,
  }) : isLocalHtmlResource = isLocalHtmlResource ?? false;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommonWebViewState<CommonWebView>();
  }
}

class CommonWebViewState<T extends CommonWebView> extends State<T>
    with CommonJSMethodMixin<T> {

  final WebViewController currentController = WebViewController();
  late NavigationDelegate webViewDelegate;

  double loadProgress = 0;
  bool showProgress = false;

  Map<String, Function> get jsMethods => {};

  @override
  void initState() {
    super.initState();

    prepareWebViewDelegate();
    prepareWebViewController();
  }

  void prepareWebViewDelegate() {
    webViewDelegate = NavigationDelegate(
      onPageFinished: (_) {
        if (mounted) {
          setState(() {
            showProgress = false;
          });
        }
        currentController.runJavaScript(windowNostrJavaScript);
      },
      onProgress: (progress) {
        if (loadProgress != 1) {
          if(mounted){
            setState(() {
              loadProgress = progress / 100;
              showProgress = true;
            });
          }
        }
      },
      onNavigationRequest: (request) {
        widget.urlCallback?.call(request.url);
        return NavigationDecision.navigate;
      },
    );
  }

  void prepareWebViewController() {
    currentController.setNavigationDelegate(webViewDelegate);

    final isLocalHtmlResource = widget.isLocalHtmlResource;
    if (isLocalHtmlResource) {
      currentController.loadFile(widget.url);
    } else {
      currentController.loadRequest(Uri.parse(formatUrl(widget.url)));
    }

    nostrChannels?.forEach((channel) => currentController.addJavaScriptChannel(
      channel.name,
      onMessageReceived: channel.onMessageReceived,
    ),);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //If you use WillPopScope on your ios model, you cannot scroll right to close
    return Platform.isAndroid
        ? WillPopScope(
            child: _root(),
            onWillPop: () async {
              if (await currentController.canGoBack()) {
                currentController.goBack();
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
    return WebViewWidget(
      controller: currentController,
    );
  }

  _renderAppBar() {
    return CommonWebViewAppBar(
      title: Text('${widget.title ?? ""}'),
      webViewControllerFuture: Future.value(currentController),
      nappName: widget.nappName,
      nappUrl: widget.nappUrl,
      nappId: widget.nappId,
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


class JavascriptChannel {
  /// Constructs a JavaScript channel.
  ///
  /// The parameters `name` and `onMessageReceived` must not be null.
  JavascriptChannel({
    required this.name,
    required this.onMessageReceived,
  })  : assert(name.isNotEmpty),
        assert(_validChannelNames.hasMatch(name));

  /// The channel's name.
  ///
  /// Passing this channel object as part of a [WebView.javascriptChannels] adds a channel object to
  /// the JavaScript window object's property named `name`.
  ///
  /// The name must start with a letter or underscore(_), followed by any combination of those
  /// characters plus digits.
  ///
  /// Note that any JavaScript existing `window` property with this name will be overriden.
  ///
  /// See also [WebView.javascriptChannels] for more details on the channel registration mechanism.
  final String name;

  /// A callback that's invoked when a message is received through the channel.
  final JavascriptMessageHandler onMessageReceived;
}
