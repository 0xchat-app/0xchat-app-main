import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/common_color.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/custom_scanner_overlay.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:ox_common/widgets/common_image.dart';

class EcashScanPage extends StatefulWidget {
  const EcashScanPage({super.key});

  @override
  EcashScanPageState createState() => EcashScanPageState();
}

class EcashScanPageState extends State<EcashScanPage> with SingleTickerProviderStateMixin{
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late AnimationController _controller;
  late double _scanArea;

  @override
  void initState() {
    super.initState();
    _scanArea = (Adapt.screenW < 375 ||
        Adapt.screenH < 400)
        ? Adapt.px(160)
        : Adapt.px(260);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    _controller.forward();

  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: _buildQrView(context),
          ),
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQueryData.fromView(window).padding.top,
              child: Container(
                height: Adapt.px(56),
                margin: EdgeInsets.only(left: Adapt.px(12), right: Adapt.px(12)),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => OXNavigator.pop(context),
                      behavior: HitTestBehavior.translucent,
                      child: SizedBox(
                        height: double.infinity,
                        child: CommonImage(
                          iconName: "appbar_back.png",
                          width: Adapt.px(32),
                          height: Adapt.px(32),
                          color: CommonColor.white01,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'str_scan'.commonLocalized(),
                        style: TextStyle(
                          fontSize: Adapt.px(18),
                          color: ThemeColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: Adapt.px(56),
            child: Container(
              margin: EdgeInsets.only(left: Adapt.px(24), right: Adapt.px(24), top: Adapt.px(16)),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _onPicTap,
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Adapt.px(20),
                          ),
                          CommonImage(
                            iconName: 'icon_scan_qr.png',
                            width: Adapt.px(54),
                            height: Adapt.px(54),
                          ),
                          SizedBox(
                            height: Adapt.px(7),
                          ),
                          Text(
                            'str_album'.commonLocalized(),
                            style: TextStyle(
                              color: ThemeColor.white,
                              fontSize: Adapt.px(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPicTap() async {
    final res = await ImagePickerUtils.pickerPaths(
      galleryMode: GalleryMode.image,
      selectCount: 1,
      showGif: false,
      compressSize: 5120,
    );
    File file = File(res[0].path ?? '');
    try {
      String qrcode = await OXCommon.scanPath(file.path);
      OXNavigator.pop(context, qrcode);
    } catch (e) {
      CommonToast.instance.show(context, "str_invalid_qr_code".commonLocalized());
    }
  }

  Widget _buildQrView(BuildContext context) {
    return  ReaderWidget(
      onScan: _onScanSuccess,
      onScanFailure: _onScanFailure,
      scanDelay: const Duration(milliseconds: 500),
      resolution: ResolutionPreset.high,
      lensDirection: CameraLensDirection.back,
      scannerOverlay: CustomScannerOverlay(
        cutOutSize: _scanArea,
        borderColor: Colors.white,
        borderRadius: 0,
        borderLength: 20,
        borderWidth: Adapt.px(4),
      ),
      showFlashlight: false,
      showGallery: false,
      showToggleCamera: false,
    );
  }

  _onScanSuccess(Code? code) {
    if (code != null) {
      OXNavigator.pop(context, code.text);
    } else {
      CommonToast.instance.show(context, "str_invalid_qr_code".commonLocalized());
    }
  }

  _onScanFailure(Code? code) {
    if (code?.error?.isNotEmpty == true) {
      _showMessage(context, 'Error: ${code?.error}');
    }
  }

  _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
