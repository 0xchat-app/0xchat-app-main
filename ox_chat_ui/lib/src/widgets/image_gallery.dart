
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/scan_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_decrypted_image_provider.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:screenshot/screenshot.dart';

import '../models/preview_image.dart';




class ImageGallery extends StatefulWidget {

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// Images to show in the gallery.
  final List<PreviewImage> images;

  /// Triggered when the gallery is swiped down or closed via the icon.
  final VoidCallback onClosePressed;

  /// Customisation options for the gallery.
  final ImageGalleryOptions options;

  /// Page controller for the image pages.
  final PageController pageController;


  const ImageGallery({
    this.imageHeaders,
    required this.images,
    required this.onClosePressed,
    this.options = const ImageGalleryOptions(),
    required this.pageController,
  });


  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}



class _ImageGalleryState extends State<ImageGallery> {

  GlobalKey _globalKey = new GlobalKey();

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) =>
      WillPopScope(
        onWillPop: () async {
          widget.onClosePressed();
          return false;
        },
        child: Dismissible(
          key: const Key('photo_view_gallery'),
          background: Container(color: Colors.black,),
          direction: DismissDirection.down,
          onDismissed: (direction) => widget.onClosePressed(),
          child: Stack(
            children: [
              Screenshot(
                controller: screenshotController,
                child:GestureDetector(
                  onLongPress: _showBottomMenu,
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: PhotoViewGallery.builder(
                      builder: (BuildContext context, int index) {
                        final uri = widget.images[index].uri;
                        final encrypted = widget.images[index].encrypted;
                        final decryptKey = widget.images[index].decryptSecret;
                        return PhotoViewGalleryPageOptions(
                          imageProvider: OXCachedNetworkImageProviderEx.create(
                            context,
                            uri,
                            headers: widget.imageHeaders,
                            cacheManager: encrypted
                                ? DecryptedCacheManager(decryptKey ?? widget.options.decryptionKey)
                                : null,
                          ),
                          minScale: widget.options.minScale,
                          maxScale: widget.options.maxScale,
                        );
                      },
                      itemCount: widget.images.length,
                      loadingBuilder: (context, event) =>
                          _imageGalleryLoadingBuilder(event),
                      pageController: widget.pageController,
                      scrollPhysics: const ClampingScrollPhysics(),
                    ),
                  ),
                ),
              ),
              Positioned.directional(
                end: 16,
                textDirection: Directionality.of(context),
                top: 56,
                child: CloseButton(
                  color: Colors.white,
                  onPressed: widget.onClosePressed,
                ),
              ),
              Positioned.directional(
                end: 16,
                textDirection: Directionality.of(context),
                bottom: 56,
                child: IconButton(
                  icon: Icon(Icons.save_alt, color: Colors.white),
                  onPressed: () async {
                    if (widget.images.isEmpty) return ;
                    final pageIndex = widget.pageController.page?.round() ?? 0;
                    final imageUri = widget.images[pageIndex].uri;

                    final isNetworkImage = imageUri.startsWith('http');
                    var result;
                    if (isNetworkImage) {
                      final response = await Dio().get(
                          imageUri,
                          options: Options(responseType: ResponseType.bytes));
                      result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
                    } else {
                      final imageData = await File(imageUri).readAsBytes();
                      result = await ImageGallerySaver.saveImage(Uint8List.fromList(imageData));
                    }

                    if (result != null) {
                      unawaited(CommonToast.instance.show(context, Localized.text('ox_chat.str_saved_to_album')));
                    } else {
                      unawaited(CommonToast.instance.show(context, Localized.text('ox_chat.str_save_failed')));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _imageGalleryLoadingBuilder(ImageChunkEvent? event) =>  Container(
    color: Colors.black,
    child: Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          value: event == null || event.expectedTotalBytes == null
              ? 0
              : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
        ),
      ),
    ),
  );

  void _showBottomMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => GestureDetector(
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
                          onTap: _identifyQRCode,
                          child: Container(
                            height: Adapt.px(48),
                            padding: EdgeInsets.all(Adapt.px(8)),
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                              color: ThemeColor.color180,
                            ),
                            child: Text(
                              'Identify QR code',
                              style: new TextStyle(color: ThemeColor.gray02, fontSize: Adapt.px(16), fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        Divider(
                          height: Adapt.px(0.5),
                          color: ThemeColor.color160,
                        ),
                        new GestureDetector(
                          onTap: _widgetShotAndSave,
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
              ),
          ),
        ),
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

  Future<void> _identifyQRCode() async {
    final image = await screenshotController.capture();
    if(image == null)return;
    OXLoading.show();
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/screenshot.png';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(image);

    try {
      String qrcode = await OXCommon.scanPath(imageFile.path);
      OXLoading.dismiss();
      OXNavigator.pop(context);
      ScanUtils.analysis(context, qrcode);
    } catch (e) {
      OXLoading.dismiss();
      CommonToast.instance.show(context, "str_invalid_qr_code".commonLocalized());
    }
  }

}

class ImageGalleryOptions {
  const ImageGalleryOptions({
    this.maxScale,
    this.minScale,
    this.decryptionKey = '',
  });

  /// See [PhotoViewGalleryPageOptions.maxScale].
  final dynamic maxScale;

  /// See [PhotoViewGalleryPageOptions.minScale].
  final dynamic minScale;

  /// See [PhotoViewGalleryPageOptions.minScale].
  final String decryptionKey;
}
