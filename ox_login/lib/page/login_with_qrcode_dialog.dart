import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/base_page_state.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

///Title: login_with_qrcode_dialog
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/12/23 16:39
class LoginWithQRCodeDialog extends StatefulWidget {
  final String? loginQRCodeUrl;

  LoginWithQRCodeDialog({
    this.loginQRCodeUrl,
  });

  @override
  State<StatefulWidget> createState() {
    return _LoginWithQRCodeDialogState();
  }
}

class _LoginWithQRCodeDialogState extends BasePageState<LoginWithQRCodeDialog> {
  String _loginQRCodeUrl = '';
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

  void _initData() {
    _loginQRCodeUrl = widget.loginQRCodeUrl ?? '';
    setState(() {});
  }

  Widget _body() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RepaintBoundary(
          key: _globalKey,
          child: Container(
            width: Adapt.px(310),
            height: Adapt.px(380),
            decoration: BoxDecoration(
              color: ThemeColor.color180,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: Adapt.px(60),
                  alignment: Alignment.center,
                  child: Text(
                      'Please scan the QR Code'
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
                    margin: EdgeInsets.symmetric(horizontal: 25.px),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(
                      Adapt.px(8),
                    ),
                    child: _loginQRCodeUrl.isEmpty ? Container() : _qrCodeWidget(),
                  ),
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
            // child: assetIcon('icon_grey_close.png', 40, 40),
            child: CommonImage(
              iconName: 'icon_grey_close.png',
              size: 40.px,
              package: 'ox_chat',
            ),
          ),
        ),
      ],
    );
  }

  Widget _qrCodeWidget() {
    return PrettyQr(
      size: Adapt.px(240),
      data: _loginQRCodeUrl,
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
                              Localized.text('ox_chat.str_save_image'),
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
            Localized.text('ox_chat.str_saved_to_album'),
          );
        } else {
          Navigator.pop(context);
          CommonToast.instance.show(
            context,
            Localized.text('ox_chat.str_save_failed'),
          );
        }
      } else {
        Navigator.pop(context);
        CommonToast.instance.show(
          context,
          Localized.text('ox_chat.str_save_failed'),
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
