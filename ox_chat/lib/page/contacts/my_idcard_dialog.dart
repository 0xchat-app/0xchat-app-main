import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/base_page_state.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:chatcore/chat-core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_localizable/ox_localizable.dart';

class MyIdCardDialog extends StatefulWidget {
  int type; // 0 Friend QRCode， 1 Channel QRCode
  ChannelDB? channelDB;

  MyIdCardDialog({
    int? type,
    this.channelDB,
  }) : this.type = type ?? CommonConstant.qrCodeUser;

  @override
  State<StatefulWidget> createState() {
    return _MyIdCardDialogState();
  }
}

class _MyIdCardDialogState extends BasePageState<MyIdCardDialog> {
  late String _showName;
  String _imgUrl = '';
  String _userQrCodeUrl = '';
  String _showScanHint = '';
  GlobalKey _globalKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  @override
  String get routeName => 'MyIdCardDialog';

  void _initData() async {
    List<String> relayAddressList = await Account.sharedInstance.getMyGeneralRelayList().map((e) => e.url).toList();
    List<String> relayList = relayAddressList.take(5).toList();
    String shareAppLinkDomain = CommonConstant.SHARE_APP_LINK_DOMAIN;
    if (widget.type == CommonConstant.qrCodeUser) {
      _showName = OXUserInfoManager.sharedInstance.currentUserInfo?.name ?? '';
      _imgUrl = OXUserInfoManager.sharedInstance.currentUserInfo?.picture ?? '';
      _showScanHint = 'str_scan_user_qrcode_hint'.localized();
      _userQrCodeUrl = shareAppLinkDomain + 'nostr?value=' + Account.encodeProfile(OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '', relayList);
      setState(() {});
    } else if (widget.type == CommonConstant.qrCodeChannel) {
      if (widget.channelDB == null) {
        CommonToast.instance.show(context, 'Unable to recognize the QR code.');
      } else {
        _showName = widget.channelDB!.name ?? '';
        _imgUrl = widget.channelDB!.picture ?? '';
        _showScanHint = 'str_scan_channel_qrcode_hint'.localized();
        _userQrCodeUrl = shareAppLinkDomain + 'nostr?value=' + Channels.encodeChannel(widget.channelDB!.channelId ?? '', relayList, widget.channelDB!.creator);
        setState(() {});
      }
    }
  }

  Widget _body() {
    String localAvatarPath = 'assets/images/user_image.png';
    Image placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(76),
      height: Adapt.px(76),
      package: 'ox_common',
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RepaintBoundary(
          key: _globalKey,
          child: Container(
            width: Adapt.px(310),
            height: Adapt.px(430),
            decoration: BoxDecoration(
              color: ThemeColor.color180,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: Adapt.px(48),
                  margin: EdgeInsets.only(
                    left: Adapt.px(24),
                    top: Adapt.px(36),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: Adapt.px(48),
                        height: Adapt.px(48),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Adapt.px(48)),
                          child: OXCachedNetworkImage(
                            imageUrl: _imgUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => placeholderImage,
                            errorWidget: (context, url, error) => placeholderImage,
                            width: Adapt.px(48),
                            height: Adapt.px(48),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: widget.type == CommonConstant.qrCodeUser ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.type == CommonConstant.qrCodeUser
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(left: Adapt.px(16), top: Adapt.px(2)),
                                  child: MyText(
                                    'Channel',
                                    16,
                                    ThemeColor.color10,
                                  ),
                                ),
                          Container(
                            margin: EdgeInsets.only(left: Adapt.px(16), top: Adapt.px(2)),
                            child: MyText(
                              _showName,
                              16,
                              ThemeColor.color10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  radius: 0.0,
                  onLongPress: () {
                    _showBottomMenu();
                  },
                  child: Container(
                    width: double.infinity,
                    height: Adapt.px(260),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: Adapt.px(19), left: Adapt.px(25), right: Adapt.px(25)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(
                      Adapt.px(8),
                    ),
                    child: _userQrCodeUrl.isEmpty ? Container() : _qrCodeWidget(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: Adapt.px(24)),
                  alignment: Alignment.center,
                  child: MyText(_showScanHint, 13, ThemeColor.color110, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            OXNavigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(
              top: Adapt.px(28),
            ),
            child: assetIcon('icon_grey_close.png', 40, 40),
          ),
        ),
      ],
    );
  }

  Widget _qrCodeWidget() {
    // LogUtil.e('Michael : _userQrCodeUrl = ${_userQrCodeUrl}  headUrl:${mCurrentUserInfo?.headUrl}');
    return PrettyQr(
      // image: NetworkImage(
      //   '${mCurrentUserInfo?.headUrl}&v=0' ?? '',
      // ),
      // image: CachedNetworkImageProvider(
      //   '${mCurrentUserInfo?.headUrl}',
      //   maxWidth: (Adapt.px(50) as double).toInt() ,
      //   maxHeight: (Adapt.px(50) as double).toInt(),
      // ),
      size: Adapt.px(240),
      data: _userQrCodeUrl,
      errorCorrectLevel: QrErrorCorrectLevel.M,
      typeNumber: null,
      roundEdges: true,
    );
  }

  void _showBottomMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: new Material(
              type: MaterialType.transparency,
              child: new Opacity(
                opacity: 1, //Opacity containing a widget
                child: new GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Container(
                    decoration: BoxDecoration(
                      color: ThemeColor.color190,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new GestureDetector(
                          onTap: () {
                            _widgetShotAndSave();
                          },
                          child: Container(
                            height: Adapt.px(48),
                            padding: EdgeInsets.all(Adapt.px(8)),
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                              color: ThemeColor.color180,
                            ),
                            child: Text(
                              'str_save_image'.localized(),
                              style: new TextStyle(color: ThemeColor.gray02, fontSize: Adapt.px(16), fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        new Container(
                          height: Adapt.px(2),
                          color: ThemeColor.dark01,
                        ),
                        new GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: Adapt.px(48),
                            padding: EdgeInsets.all(Adapt.px(8)),
                            alignment: FractionalOffset.center,
                            color: ThemeColor.color180,
                            child: Text(
                              'cancel'.commonLocalized(),
                              style: new TextStyle(color: ThemeColor.gray02, fontSize: Adapt.px(16), fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }

  void _widgetShotAndSave() async {
    if (await Permission.storage.request().isGranted) {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      var image = await boundary.toImage(pixelRatio: devicePixelRatio);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData != null) {
        Uint8List? pngBytes = byteData.buffer.asUint8List();
        final result = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
        if (result != null && result != "") {
          // LogUtil.e('Michael : result = ${result.toString()}');
          Navigator.pop(context);
          //Return the path
          // String str = Uri.decodeComponent(result);
          CommonToast.instance.show(
            context,
            "str_saved_to_album".localized(),
          );
        } else {
          Navigator.pop(context);
          CommonToast.instance.show(
            context,
            "str_save_failed".localized(),
          );
        }
      } else {
        Navigator.pop(context);
        CommonToast.instance.show(
          context,
          "str_save_failed".localized(),
        );
      }
    } else {
      OXCommonHintDialog.show(context, content: Localized.text('ox_chat.str_permission_camera_hint'), actionList: [
        OXCommonHintAction(
            text: () => Localized.text('ox_chat.str_go_to_settings'),
            onTap: () {
              openAppSettings();
              OXNavigator.pop(context);
            }),
      ]);
      return;
    }
  }
}
