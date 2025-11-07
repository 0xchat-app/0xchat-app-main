import 'dart:convert';
import 'package:flutter/services.dart';
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
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/nostr_permission_bottom_sheet.dart';
import 'package:ox_common/utils/string_utils.dart';

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
      this.webViewControllerFuture,
      this.nappName,
      this.nappUrl,
      this.nappId});

  final Color? backgroundColor;
  final Widget? title;
  final Widget? leading;
  final Widget? extend;
  final bool canBack;
  final GestureTapCallback? onClickMore;
  final GestureTapCallback? onClickClose;
  final Future<WebViewController>? webViewControllerFuture;
  final String? nappName;
  final String? nappUrl;
  final String? nappId;

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
            padding: EdgeInsets.symmetric(horizontal: 16.px,vertical: 16.px),
            child: _buildMoreItems(context),
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

  Widget _buildMoreItems(BuildContext context) {
    final List<Widget Function(EdgeInsetsGeometry margin)> builders = [];

    if ((nappName != null && nappUrl != null) || nappId != null) {
      builders.add((margin) => FutureBuilder<bool>(
            future: _isBookmarked(),
            builder: (context, snapshot) {
              bool isBookmarked = snapshot.data ?? false;
              return _buildItem(
                label: Localized.text('ox_common.webview_more_bookmark'),
                onTap: () => _onBookmark(context),
                iconName: isBookmarked ? 'icon_unbookmark.png' : 'icon_bookmark.png',
                margin: margin,
              );
            },
          ));
    }

    builders
      ..add((margin) => _buildItem(
            label: Localized.text('ox_common.webview_more_send_to_chat'),
            onTap: () => _onSendToOther(context),
            iconName: 'icon_share_chat.png',
            margin: margin,
          ))
      ..add((margin) => _buildItem(
            label: Localized.text('ox_common.status_network_refresh'),
            onTap: () => _onRefreshPage(context),
            iconName: 'icon_reload.png',
            margin: margin,
          ))
      ..add((margin) => _buildItem(
            label: Localized.text('ox_common.webview_more_browser'),
            onTap: () => _launchURL(context),
            iconName: 'icon_share_browser.png',
            margin: margin,
          ))
      ..add((margin) => _buildItem(
            label: Localized.text('ox_common.webview_more_copy'),
            onTap: () => _copyURL(context),
            iconName: 'icon_share_link.png',
            margin: margin,
          ))
      ..add((margin) => _buildItem(
            label: Localized.text('ox_common.str_share'),
            onTap: () => _onShare(context),
            iconName: 'icon_share_file.png',
            margin: margin,
          ))
      ..add((margin) => FutureBuilder<bool>(
            future: _hasAnyPermission(),
            builder: (context, snapshot) {
              bool hasPermission = snapshot.data ?? false;
              return _buildItem(
                label: hasPermission 
                    ? Localized.text('ox_common.webview_more_revoke_nip07_permissions')
                    : Localized.text('ox_common.webview_more_grant_nip07_permissions'),
                onTap: () => _onToggleNip07Permissions(context, hasPermission),
                iconName: hasPermission ? 'icon_unauth.png' : 'icon_auth.png',
                margin: margin,
              );
            },
          ));

    final bool useWrap = builders.length > 5;
    final EdgeInsetsGeometry itemMargin = useWrap ? EdgeInsets.zero : EdgeInsets.only(right: 16.px);
    final List<Widget> items = builders.map((builder) => builder(itemMargin)).toList();

    if (useWrap) {
      return Wrap(
        spacing: 16.px,
        runSpacing: 16.px,
        children: items,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  Widget _buildItem({required String label, String? iconName, Widget? iconWidget, GestureTapCallback? onTap, EdgeInsetsGeometry? margin}){
    assert(iconName != null || iconWidget != null, 'Either iconName or iconWidget must be provided');
    final EdgeInsetsGeometry effectiveMargin = margin ?? EdgeInsets.only(right: 16.px);
    return _buildTapWidget(
      onTap: onTap,
      child: Container(
        width: 60.px,
        margin: effectiveMargin,
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
              child: iconWidget ?? CommonImage(
                iconName: iconName!,
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

  void _onRefreshPage(BuildContext context) async {
    if (webViewControllerFuture == null) return;
    WebViewController webViewController = await webViewControllerFuture!;
    OXNavigator.pop(context);
    webViewController.reload();
  }

  Future<String?> _getTargetNappId() async {
    if (nappId != null) return nappId;
    if (nappUrl == null) return null;
    
    try {
      // Try to load napp_list.json to find matching id
      final String jsonString = await rootBundle.loadString('packages/ox_discovery/assets/napp_list.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      for (var item in jsonList) {
        if (item is Map && item['url'] == nappUrl) {
          return item['id'] as String?;
        }
      }
    } catch (e) {
      // If can't load JSON, use URL as fallback
      return nappUrl;
    }
    
    return nappUrl;
  }

  Future<bool> _isBookmarked() async {
    if (nappId == null && (nappName == null || nappUrl == null)) return false;
    
    String? targetNappId = await _getTargetNappId();
    if (targetNappId == null) return false;
    
    // Get current bookmarks (only store ids)
    List<dynamic> bookmarkIds = await OXCacheManager.defaultOXCacheManager
        .getForeverData('napp_bookmarks', defaultValue: []) ?? [];
    
    // Check if already bookmarked
    return bookmarkIds.any((item) {
      if (item is Map) {
        return item['id'] == targetNappId;
      } else if (item is String) {
        return item == targetNappId;
      }
      return false;
    });
  }

  void _onBookmark(BuildContext context) async {
    if (nappId == null && (nappName == null || nappUrl == null)) return;
    
    OXNavigator.pop(context);
    
    // Get current bookmarks (only store ids)
    List<dynamic> bookmarkIds = await OXCacheManager.defaultOXCacheManager
        .getForeverData('napp_bookmarks', defaultValue: []) ?? [];
    
    // Use helper method to get target NApp id
    String? targetNappId = await _getTargetNappId();
    if (targetNappId == null) {
      targetNappId = nappUrl ?? ''; // Fallback to URL if no id found
    }
    
    // Check if already bookmarked
    bool isBookmarked = bookmarkIds.any((item) {
      if (item is Map) {
        return item['id'] == targetNappId;
      } else if (item is String) {
        return item == targetNappId;
      }
      return false;
    });
    
    if (isBookmarked) {
      // Remove bookmark
      bookmarkIds.removeWhere((item) {
        if (item is Map) {
          return item['id'] == targetNappId;
        } else if (item is String) {
          return item == targetNappId;
        }
        return false;
      });
      await OXCacheManager.defaultOXCacheManager
          .saveForeverData('napp_bookmarks', bookmarkIds);
      // Show toast
      CommonToast.instance.show(context, 'Bookmark removed');
    } else {
      // Add bookmark (only store id)
      bookmarkIds.add(targetNappId);
      await OXCacheManager.defaultOXCacheManager
          .saveForeverData('napp_bookmarks', bookmarkIds);
      // Show toast
      CommonToast.instance.show(context, 'Bookmarked');
    }
  }

  Future<String?> _getCurrentWebViewUrl() async {
    if (webViewControllerFuture == null) return null;
    try {
      WebViewController controller = await webViewControllerFuture!;
      return await controller.currentUrl();
    } catch (e) {
      return null;
    }
  }

  Future<String?> _getCurrentHost() async {
    String? url = await _getCurrentWebViewUrl();
    if (url == null || url.isEmpty) {
      // Fallback to nappUrl if available
      if (nappUrl != null && nappUrl!.isNotEmpty) {
        url = nappUrl;
      } else {
        return null;
      }
    }
    if (url == null || url.isEmpty) {
      return null;
    }
    try {
      Uri uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _hasAnyPermission() async {
    String? host = await _getCurrentHost();
    if (host == null || host.isEmpty) {
      return false;
    }

    // Check all permission keys
    List<String> allKeys = ['getPublicKey', 'signEvent', 'encryptNIP04', 'encryptNIP44', 'decryptNIP44'];
    for (String key in allKeys) {
      String cacheKey = '$host.$key';
      bool granted = await OXCacheManager.defaultOXCacheManager
          .getForeverData(cacheKey, defaultValue: false) ?? false;
      if (granted) {
        return true;
      }
    }
    return false;
  }

  Future<void> _grantAllPermissions() async {
    String? host = await _getCurrentHost();
    if (host == null || host.isEmpty) {
      return;
    }

    // Grant all permission keys
    List<String> allKeys = ['getPublicKey', 'signEvent', 'encryptNIP04', 'encryptNIP44', 'decryptNIP44'];
    for (String key in allKeys) {
      String cacheKey = '$host.$key';
      await OXCacheManager.defaultOXCacheManager
          .saveForeverData(cacheKey, true);
    }
  }

  Future<void> _revokeAllPermissions() async {
    String? host = await _getCurrentHost();
    if (host == null || host.isEmpty) {
      return;
    }

    // Revoke all permission keys
    List<String> allKeys = ['getPublicKey', 'signEvent', 'encryptNIP04', 'encryptNIP44', 'decryptNIP44'];
    for (String key in allKeys) {
      String cacheKey = '$host.$key';
      await OXCacheManager.defaultOXCacheManager
          .saveForeverData(cacheKey, false);
    }
  }

  void _onToggleNip07Permissions(BuildContext context, bool hasPermission) async {
    OXNavigator.pop(context);
    
    String? host = await _getCurrentHost();
    if (host == null || host.isEmpty) {
      CommonToast.instance.show(context, 'Unable to get website host');
      return;
    }

    if (hasPermission) {
      // Revoke permissions
      await _revokeAllPermissions();
      CommonToast.instance.show(context, 'Permissions revoked');
    } else {
      // Grant permissions - show confirmation dialog
      String content = 'get_publicKey_request_content'.commonLocalized();
      bool confirmed = await NostrPermissionBottomSheet.show(
        context,
        title: 'get_request_title'.commonLocalized(),
        content: content,
      );
      
      if (confirmed) {
        await _grantAllPermissions();
        CommonToast.instance.show(context, 'Permissions granted');
      }
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
