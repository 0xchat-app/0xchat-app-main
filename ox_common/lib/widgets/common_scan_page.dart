import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/common_color.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'common_image.dart';

class CommonScanPage extends StatefulWidget {
  @override
  CommonScanPageState createState() => CommonScanPageState();
}

class CommonScanPageState extends State<CommonScanPage> with SingleTickerProviderStateMixin{
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _scanArea;
  late double _scanBarMarginLR;

  @override
  void initState() {
    super.initState();
    _scanArea = (Adapt.screenW() < 400 ||
        Adapt.screenH() < 400)
        ? Adapt.px(260)
        : Adapt.px(360);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    _scanBarMarginLR = (Adapt.screenW() - _scanArea)/2 + Adapt.px(20);
    double halfRange = _scanArea/2 - Adapt.px(30);
    double centerPos = Adapt.screenH() / 2;
    _animation = Tween(begin: centerPos - halfRange, end: centerPos + halfRange).animate(_controller);

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
          Container(
            width: double.infinity,
            height: double.infinity,
            child: _buildQrView(context),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Positioned(
                top: _animation.value,
                left: _scanBarMarginLR,
                right: _scanBarMarginLR,
                child: Container(
                  width: _scanArea - Adapt.px(20),
                  height: Adapt.px(1),
                  color: Colors.white54,
                ),
              );
            },
          ),
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQueryData.fromWindow(window).padding.top,
              child: Container(
                height: Adapt.px(56),
                margin: EdgeInsets.only(left: Adapt.px(12), right: Adapt.px(12)),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => OXNavigator.pop(context),
                      behavior: HitTestBehavior.translucent,
                      child: Container(
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
              height: Adapt.px(105),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Adapt.px(20),
                          ),
                          CommonImage(
                            iconName: 'icon_business_card.png',
                            width: Adapt.px(54),
                            height: Adapt.px(54),
                            useTheme: true,
                          ),
                          SizedBox(
                            height: Adapt.px(7),
                          ),
                          Text(
                            'str_my_idcard'.commonLocalized(),
                            style: TextStyle(
                              color: ThemeColor.white,
                              fontSize: Adapt.px(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      OXModuleService.invoke('ox_chat', 'showMyIdCardDialog', [context]);
                    },
                  )),
                  Container(
                    width: Adapt.px(0.5),
                    height: Adapt.px(79),
                    color: ThemeColor.gray5,
                  ),
                  Expanded(
                      child: GestureDetector(
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
                            useTheme: true,
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
                    onTap: () async {
                      final res = await ImagePickerUtils.pickerPaths(
                        galleryMode: GalleryMode.image,
                        selectCount: 1,
                        showGif: false,
                        compressSize: 5120,
                      );
                      if(res == null) return;
                      File? file = File(res[0].path ?? '');
                      if (file != null) {
                        String? qrcode = await scanner.scanPath(file.path);
                        if (qrcode != null) {
                          OXNavigator.pop(context, qrcode);
                        } else {
                          CommonToast.instance.show(context, "str_invalid_qr_code".commonLocalized());
                        }
                      }
                    },
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return  ReaderWidget(
      onScan: _onScanSuccess,
      onScanFailure: _onScanFailure,
      scanDelay: Duration(milliseconds: 500),
      resolution: ResolutionPreset.high,
      lensDirection: CameraLensDirection.back,
      scannerOverlay: CustomScannerOverlay(
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

class CustomScannerOverlay extends ScannerOverlay{
  CustomScannerOverlay({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    double? cutOutSize,
    double? cutOutWidth,
    double? cutOutHeight,
    this.cutOutBottomOffset = 0,
  })  : cutOutWidth = cutOutWidth ?? cutOutSize ?? 250,
        cutOutHeight = cutOutHeight ?? cutOutSize ?? 250 {
    assert(
    borderLength <=
        min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2,
    "Border can't be larger than ${min(this.cutOutWidth, this.cutOutHeight) / 2 + borderWidth * 2}",
    );
    assert(
    (cutOutWidth == null && cutOutHeight == null) ||
        (cutOutSize == null && cutOutWidth != null && cutOutHeight != null),
    'Use only cutOutWidth and cutOutHeight or only cutOutSize');
  }

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutWidth;
  final double cutOutHeight;
  final double cutOutBottomOffset;


  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final _borderLength =
    borderLength > min(cutOutHeight, cutOutHeight) / 2 + borderWidth * 2
        ? borderWidthSize / 2
        : borderLength;
    final _cutOutWidth =
    cutOutWidth < width ? cutOutWidth : width - borderOffset;
    final _cutOutHeight =
    cutOutHeight < height ? cutOutHeight : height - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - _cutOutWidth / 2 + borderOffset,
      -cutOutBottomOffset +
          rect.top +
          height / 2 -
          _cutOutHeight / 2 +
          borderOffset,
      _cutOutWidth - borderOffset * 2,
      _cutOutHeight - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
    // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - _borderLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + _borderLength,
          topRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
    // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + _borderLength,
          cutOutRect.top + _borderLength,
          topLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
    // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - _borderLength,
          cutOutRect.bottom - _borderLength,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
    // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - _borderLength,
          cutOutRect.left + _borderLength,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ScannerOverlay scale(double t) {
    return CustomScannerOverlay(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }

  @override
  // TODO: implement cutOutSize
  double get cutOutSize => throw UnimplementedError();

}
