import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/common_color.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/permission_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/custom_scanner_overlay.dart';
import 'package:ox_localizable/ox_localizable.dart';

class EcashScanPage extends StatefulWidget {
  const EcashScanPage({super.key});

  @override
  EcashScanPageState createState() => EcashScanPageState();
}

class EcashScanPageState extends State<EcashScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late final MobileScannerController _scannerController;
  late double _scanArea;
  bool _isProcessingScan = false;
  String? _lastErrorMessage;

  @override
  void initState() {
    super.initState();
    _scanArea = (Adapt.screenW < 375 || Adapt.screenH < 400)
        ? Adapt.px(160)
        : Adapt.px(260);
    final Size? preferredResolution = _resolvePreferredCameraResolution();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      formats: [BarcodeFormat.qrCode],
      autoStart: true,
      cameraResolution: preferredResolution,
      useNewCameraSelector: Platform.isAndroid,
    );
  }

  Size? _resolvePreferredCameraResolution() {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return null;
    }
    final Iterable<ui.FlutterView> views =
        WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) {
      return null;
    }
    final ui.Size physicalSize = views.first.physicalSize;
    if (physicalSize.width <= 0 || physicalSize.height <= 0) {
      return null;
    }
    final double maxSide = math.max(physicalSize.width, physicalSize.height);
    final double minSide = math.min(physicalSize.width, physicalSize.height);
    final double normalizedWidth = _normalizeResolutionDimension(maxSide);
    final double normalizedHeight = _normalizeResolutionDimension(minSide);
    if (normalizedWidth <= 0 || normalizedHeight <= 0) {
      return null;
    }
    return Size(normalizedWidth, normalizedHeight);
  }

  double _normalizeResolutionDimension(double value) {
    const double alignmentUnit = 16.0;
    final double rounded = (value / alignmentUnit).round() * alignmentUnit;
    return math.max(alignmentUnit, rounded);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _scannerController.stop();
    }
    _scannerController.start();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: _buildCameraView(),
          ),
          Positioned.fill(
            child: CustomScannerOverlay(
              cutOutSize: _scanArea,
              verticalOffset: Adapt.px(50),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: MediaQueryData.fromView(ui.window).padding.top,
            child: Container(
              height: Adapt.px(56),
              margin:
                  EdgeInsets.only(left: Adapt.px(12), right: Adapt.px(12)),
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
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: Adapt.px(56),
            child: Container(
              margin: EdgeInsets.only(
                left: Adapt.px(24),
                right: Adapt.px(24),
                top: Adapt.px(16),
              ),
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

  Widget _buildCameraView() {
    return MobileScanner(
      controller: _scannerController,
      fit: BoxFit.cover,
      onDetect: _handleBarcodeDetection,
      errorBuilder: (context, error, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleScannerError(error);
        });
        return child ?? Container(color: Colors.black);
      },
    );
  }

  void _onPicTap() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    bool storagePermission = false;
    File? imageFile;
    if (Platform.isAndroid && (await plugin.androidInfo).version.sdkInt >= 34) {
      Map<String, bool> result = await OXCommon.request34MediaPermission(1);
      bool readMediaImagesGranted = result['READ_MEDIA_IMAGES'] ?? false;
      bool readMediaVisualUserSelectedGranted =
          result['READ_MEDIA_VISUAL_USER_SELECTED'] ?? false;
      if (readMediaImagesGranted) {
        storagePermission = true;
      } else if (readMediaVisualUserSelectedGranted) {
        final filePaths = await OXCommon.select34MediaFilePaths(1);
        if (filePaths.isNotEmpty) {
          imageFile = File(filePaths.first);
        }
      }
    } else {
      storagePermission = await PermissionUtils.getPhotosPermission(context);
    }
    if (storagePermission) {
      final res = await ImagePickerUtils.pickerPaths(
        galleryMode: GalleryMode.image,
        selectCount: 1,
        showGif: false,
        compressSize: 5120,
      );
      if (res.isEmpty) {
        return;
      }
      final path = res.first.path ?? '';
      imageFile = path.isEmpty ? null : File(path);
    } else if (imageFile == null) {
      CommonToast.instance.show(
        context,
        Localized.text('ox_common.str_grant_permission_photo_hint'),
      );
      return;
    }

    final filePath = imageFile?.path;
    if (filePath == null || filePath.isEmpty) {
      return;
    }

    try {
      final qrcode = await OXCommon.scanPath(filePath);
      if (!mounted) {
        return;
      }
      OXNavigator.pop(context, qrcode);
    } catch (e) {
      CommonToast.instance.show(
        context,
        "str_invalid_qr_code".commonLocalized(),
      );
    }
  }

  void _handleBarcodeDetection(BarcodeCapture capture) {
    if (_isProcessingScan) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue ?? barcode.displayValue;
      if (value != null && value.isNotEmpty) {
        _isProcessingScan = true;
        _scannerController.stop();
        if (mounted) {
          OXNavigator.pop(context, value);
        }
        return;
      }
    }
  }

  void _handleScannerError(MobileScannerException error) {
    final details = error.errorDetails?.toString();
    final message = (details != null && details.trim().isNotEmpty)
        ? details
        : error.errorCode.name;
    if (message.isEmpty || _lastErrorMessage == message) {
      return;
    }
    _lastErrorMessage = message;
    _showMessage(
      context,
      '${"str_error".commonLocalized()}: $message',
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}