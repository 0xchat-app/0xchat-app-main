import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_webview+nostr.dart';
import 'package:ox_common/widgets/common_webview_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ox_common/mixin/common_js_method_mixin.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_localizable/ox_localizable.dart';

typedef JavascriptMessageHandler = void Function(JavaScriptMessage message);
final RegExp _validChannelNames = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');

typedef UrlCallBack = void Function(String);

/// Returns SOCKS proxy host/port for the given URL when app proxy/Tor is enabled (same logic as OXHttpOverrides).
/// Used on Android to pass proxy to GeckoView so in-app web content uses the same proxy/Tor.
({String host, int port})? _getProxyForUrl(String url) {
  final settings = Config.sharedInstance.getProxy();
  final shouldUseTor = settings.turnOnTor || TorNetworkHelper.shouldUseTor(url);
  if (shouldUseTor && TorNetworkHelper.isTorEnabled) {
    return (host: TorNetworkHelper.torProxyHost.address, port: TorNetworkHelper.torProxyPort);
  }
  if (settings.turnOnProxy && !settings.useSystemProxy) {
    return (host: settings.socksProxyHost, port: settings.socksProxyPort);
  }
  return null;
}

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

  // Debounce mechanism to prevent multiple downloads
  String? _lastDownloadUrl;
  DateTime? _lastDownloadTime;
  static const Duration _downloadDebounceDuration = Duration(seconds: 2);
  bool _isShowingDownloadDialog = false; // Flag to prevent multiple dialogs

  Map<String, Function> get jsMethods => {};

  /// On Android with proxy/Tor enabled, use GeckoView so web traffic goes through app proxy.
  bool get _useGeckoView =>
      Platform.isAndroid &&
      !widget.isLocalHtmlResource &&
      _getProxyForUrl(widget.url) != null;

  @override
  void initState() {
    super.initState();
    if (!_useGeckoView) {
      prepareWebViewDelegate();
      prepareWebViewController();
    }
  }

  void prepareWebViewDelegate() {
    webViewDelegate = NavigationDelegate(
      onPageFinished: (String url) {
        if (mounted) {
          setState(() {
            showProgress = false;
          });
        }
        currentController.runJavaScript(windowNostrJavaScript);
        // Inject bottom safe area CSS variable for Android navigation bar
        _injectBottomSafeArea();
        // Inject download interceptor for Android
        if (Platform.isAndroid) {
          // Add a small delay to ensure DOM is fully loaded
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _injectDownloadInterceptor();
            }
          });
        }
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
    currentController.setJavaScriptMode(JavaScriptMode.unrestricted);
    if (!Platform.isMacOS) {
      currentController.setBackgroundColor(Colors.transparent);
    }
    currentController.setNavigationDelegate(webViewDelegate);

    // Add JavaScript channel for media download (Android only)
    if (Platform.isAndroid) {
      currentController.addJavaScriptChannel(
        'OxWebViewDownload',
        onMessageReceived: (JavaScriptMessage message) {
          _handleDownloadRequest(message.message);
        },
      );
    }

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
              if (_useGeckoView) {
                // GeckoView back handled by system; allow pop
                return true;
              }
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
          child: SafeArea(
            bottom: true,
            child: buildWebView(),
          ),
        )
      ],
    );
  }

  Widget buildWebView() {
    if (_useGeckoView) {
      final proxy = _getProxyForUrl(widget.url)!;
      return AndroidView(
        viewType: 'ox_geckoview',
        creationParams: <String, dynamic>{
          'url': formatUrl(widget.url),
          'socksHost': proxy.host,
          'socksPort': proxy.port,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
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
    // TODO: Add language and theme parameters if needed
    // if (url.contains("?")) {
    //   return url +
    //       "&lang=${Localized.getCurrentLanguage().symbol()}&theme=${ThemeManager.getCurrentThemeStyle().value()}";
    // } else {
    //   return url +
    //       "?lang=${Localized.getCurrentLanguage().symbol()}&theme=${ThemeManager.getCurrentThemeStyle().value()}";
    // }
  }

  // Inject bottom safe area CSS variable to help web pages adjust bottom content
  void _injectBottomSafeArea() {
    if (!mounted) return;
    
    // Use WidgetsBinding to get safe area info reliably
    final window = WidgetsBinding.instance.window;
    // Get bottom padding in logical pixels (CSS pixels)
    final double bottomPadding = window.padding.bottom / window.devicePixelRatio;
    
    // Inject CSS variable for web pages to use
    final String script = """
      (function() {
        const root = document.documentElement;
        const bottomSafeArea = ${bottomPadding};
        root.style.setProperty('--safe-area-inset-bottom', bottomSafeArea + 'px');
        
        // Dispatch a custom event so web pages can listen and adjust their layout
        window.dispatchEvent(new CustomEvent('safeAreaChanged', {
          detail: { bottom: bottomSafeArea }
        }));
      })();
    """;
    
    currentController.runJavaScript(script);
  }

  // Inject JavaScript code to intercept media file long press events for download
  void _injectDownloadInterceptor() {
    if (!mounted) return;
    
    final String script = """
      (function() {
        // Function to get media URL from element
        function getMediaUrl(element) {
          if (element.tagName === 'IMG') {
            return element.src || element.getAttribute('data-src') || element.getAttribute('data-original');
          } else if (element.tagName === 'VIDEO') {
            return element.src || element.getAttribute('data-src') || (element.querySelector('source') && element.querySelector('source').src);
          } else if (element.tagName === 'AUDIO') {
            return element.src || element.getAttribute('data-src') || (element.querySelector('source') && element.querySelector('source').src);
          } else if (element.tagName === 'A') {
            const href = element.href;
            if (href && (href.match(/\\.(jpg|jpeg|png|gif|webp|bmp|svg|mp4|avi|mov|wmv|flv|webm|mp3|wav|ogg|m4a)\$/i) || 
                element.querySelector('img') || element.querySelector('video') || element.querySelector('audio'))) {
              return href;
            }
          }
          return null;
        }

        // Function to determine media type
        function getMediaType(url) {
          if (!url) return 'unknown';
          const lowerUrl = url.toLowerCase();
          if (lowerUrl.match(/\\.(jpg|jpeg|png|gif|webp|bmp|svg)\$/i) || url.startsWith('data:image/')) {
            return 'image';
          } else if (lowerUrl.match(/\\.(mp4|avi|mov|wmv|flv|webm|mkv|3gp)\$/i) || url.startsWith('data:video/')) {
            return 'video';
          } else if (lowerUrl.match(/\\.(mp3|wav|ogg|m4a|aac|flac)\$/i) || url.startsWith('data:audio/')) {
            return 'audio';
          }
          return 'file';
        }

        // Function to handle download request
        function handleDownload(url, mediaType) {
          if (!url || url.startsWith('javascript:') || url.startsWith('#')) {
            return;
          }
          
          // Convert data URL or blob URL to downloadable format
          let downloadUrl = url;
          
          // For data URLs, we need to keep them as is
          // For blob URLs, we can't directly download, so skip
          if (url.startsWith('blob:')) {
            console.log('Blob URLs are not directly downloadable');
            return;
          }
          
          // Send download request to Flutter
          try {
            if (typeof OxWebViewDownload !== 'undefined' && OxWebViewDownload.postMessage) {
              const message = JSON.stringify({
                url: downloadUrl,
                type: mediaType
              });
              OxWebViewDownload.postMessage(message);
              console.log('Download request sent:', downloadUrl);
            } else {
              console.error('OxWebViewDownload channel not available');
            }
          } catch (error) {
            console.error('Error sending download request:', error);
          }
        }

        // Long press detection using touch events (more reliable on Android)
        let longPressTimer = null;
        let longPressTarget = null;
        const LONG_PRESS_DURATION = 500; // 500ms

        function findMediaElement(element) {
          let target = element;
          let mediaUrl = null;
          let mediaType = 'file';

          while (target && target !== document.body) {
            if (target.tagName === 'IMG' || target.tagName === 'VIDEO' || target.tagName === 'AUDIO') {
              mediaUrl = getMediaUrl(target);
              if (mediaUrl) {
                mediaType = getMediaType(mediaUrl);
                return { element: target, url: mediaUrl, type: mediaType };
              }
            } else if (target.tagName === 'A') {
              const url = getMediaUrl(target);
              if (url) {
                mediaUrl = url;
                mediaType = getMediaType(url);
                return { element: target, url: mediaUrl, type: mediaType };
              }
            }
            target = target.parentElement;
          }
          return null;
        }

        // Touch start - begin long press detection
        document.addEventListener('touchstart', function(e) {
          const mediaInfo = findMediaElement(e.target);
          if (mediaInfo && mediaInfo.url) {
            longPressTarget = mediaInfo;
            longPressTimer = setTimeout(function() {
              if (longPressTarget) {
                e.preventDefault();
                e.stopPropagation();
                handleDownload(longPressTarget.url, longPressTarget.type);
                longPressTarget = null;
              }
            }, LONG_PRESS_DURATION);
          }
        }, true);

        // Touch end - cancel long press if released early
        document.addEventListener('touchend', function(e) {
          if (longPressTimer) {
            clearTimeout(longPressTimer);
            longPressTimer = null;
          }
          longPressTarget = null;
        }, true);

        // Touch move - cancel long press if moved
        document.addEventListener('touchmove', function(e) {
          if (longPressTimer) {
            clearTimeout(longPressTimer);
            longPressTimer = null;
          }
          longPressTarget = null;
        }, true);

        // Also intercept contextmenu event as fallback
        document.addEventListener('contextmenu', function(e) {
          const mediaInfo = findMediaElement(e.target);
          if (mediaInfo && mediaInfo.url) {
            e.preventDefault();
            e.stopPropagation();
            handleDownload(mediaInfo.url, mediaInfo.type);
            return false;
          }
        }, true);

        // Also intercept click events on media links (as fallback)
        document.addEventListener('click', function(e) {
          // Only handle if Ctrl or Cmd key is pressed (common download gesture)
          if (!e.ctrlKey && !e.metaKey) {
            return;
          }

          let target = e.target;
          while (target && target !== document.body) {
            if (target.tagName === 'A') {
              const url = getMediaUrl(target);
              if (url) {
                const mediaType = getMediaType(url);
                if (mediaType !== 'unknown') {
                  e.preventDefault();
                  e.stopPropagation();
                  handleDownload(url, mediaType);
                  return false;
                }
              }
            }
            target = target.parentElement;
          }
        }, true);
      })();
    """;
    
    currentController.runJavaScript(script);
  }

  // Handle download request from JavaScript
  void _handleDownloadRequest(String message) {
    print('Received download request: $message');
    try {
      String? url;
      String type = 'file';
      
      // Try to parse as JSON
      if (message.startsWith('{')) {
        final Map<String, dynamic> data = jsonDecode(message);
        url = data['url'] as String?;
        type = data['type'] as String? ?? 'file';
      } else {
        // Fallback: treat entire message as URL
        url = message;
      }
      
      if (url != null && url.isNotEmpty) {
        print('Downloading: $url (type: $type)');
        _downloadMediaFile(url, type);
      } else {
        print('Invalid download URL');
      }
    } catch (e) {
      print('Error parsing download request: $e');
      // If parsing fails, try to use message as URL directly
      if (message.isNotEmpty) {
        _downloadMediaFile(message, 'file');
      }
    }
  }

  // Download media file using platform channel
  Future<void> _downloadMediaFile(String url, String type) async {
    if (!mounted) return;
    
    // Prevent multiple dialogs from showing simultaneously
    if (_isShowingDownloadDialog) {
      print('Download dialog already showing, ignoring request: $url');
      return;
    }
    
    // Debounce: prevent multiple downloads of the same file within short time
    final now = DateTime.now();
    if (_lastDownloadUrl == url && 
        _lastDownloadTime != null && 
        now.difference(_lastDownloadTime!) < _downloadDebounceDuration) {
      print('Download request ignored (debounced): $url');
      return;
    }
    
    // Show confirmation dialog before downloading
    if (!mounted) return;
    final context = this.context;
    
    // Set flag to prevent multiple dialogs
    _isShowingDownloadDialog = true;
    
    // Get file name from URL
    final uri = Uri.tryParse(url);
    final fileName = uri?.pathSegments.lastOrNull ?? 'file';
    
    // Get media type display name
    String typeName;
    switch (type.toLowerCase()) {
      case 'image':
        typeName = Localized.text('ox_common.media_type_image');
        break;
      case 'video':
        typeName = Localized.text('ox_common.media_type_video');
        break;
      case 'audio':
        typeName = Localized.text('ox_common.media_type_audio');
        break;
      default:
        typeName = Localized.text('ox_common.media_type_file');
    }
    
    // Get confirmation message
    final confirmMessage = Localized.text('ox_common.download_confirm_message')
        .replaceAll('{type}', typeName);
    
    try {
      // Show confirmation dialog
      final confirmed = await OXCommonHintDialog.showConfirmDialog(
        context,
        title: Localized.text('ox_common.download_confirm'),
        content: '$confirmMessage\n\n$fileName',
      );
      
      // Reset dialog flag
      _isShowingDownloadDialog = false;
      
      if (!confirmed || !mounted) {
        return;
      }
      
      _lastDownloadUrl = url;
      _lastDownloadTime = now;
      
      print('Calling platform method with url: $url, type: $type');
      // Call Android platform to handle download
      final result = await OXCommon.channel.invokeMethod('handleWebViewDownload', {
        'url': url,
        'type': type,
      });
      print('Download result: $result');
    } catch (e) {
      // Reset dialog flag on error
      _isShowingDownloadDialog = false;
      print('Error downloading media file: $e');
      print('Stack trace: ${StackTrace.current}');
      // Reset debounce on error so user can retry
      _lastDownloadUrl = null;
      _lastDownloadTime = null;
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
