
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/scan_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';
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
  Widget build(BuildContext context) => WillPopScope(
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
                    final decryptKey = widget.images[index].decryptSecret;
                    final decryptNonce = widget.images[index].decryptNonce;
                    return PhotoViewGalleryPageOptions(
                      imageProvider: OXCachedImageProviderEx.create(
                        uri,
                        headers: widget.imageHeaders,
                        cacheManager: OXFileCacheManager.get(encryptKey: decryptKey, encryptNonce: decryptNonce),
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

                await saveImageToLocal(widget.images[pageIndex]);
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
                          Localized.text('ox_chat.scan_qr_code'),
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
      _deleteImage(imageFile.path);
      OXLoading.dismiss();
      OXNavigator.pop(context);
      ScanUtils.analysis(context, qrcode);
    } catch (e) {
      OXLoading.dismiss();
      CommonToast.instance.show(context, "str_invalid_qr_code".commonLocalized());
    }
  }

  void _deleteImage(String imagePath) {
    final file = File(imagePath);
    if (file.existsSync()) {
      file.delete().then((_) {
        print('File Deleted');
      }).catchError((error) {
        print('Error: $error');
      });
    } else {
      print('File not found');
    }
  }

  Future saveImageToLocal(PreviewImage image) async {
    final imageUri = image.uri;
    final decryptKey = image.decryptSecret;
    final decryptNonce = image.decryptNonce;
    final fileName = imageUri.split('/').lastOrNull?.split('?').firstOrNull ?? '';
    final isGIF = fileName.contains('.gif');

    unawaited(OXLoading.show());

    var result;
    if (imageUri.isRemoteURL) {
      final imageManager = OXFileCacheManager.get(encryptKey: decryptKey, encryptNonce: decryptNonce);
      try {
        final imageFile = await imageManager.getSingleFile(imageUri)
            .timeout(const Duration(seconds: 30), onTimeout: () {
          throw Exception('time out');
        });

        if (isGIF) {
          result = await ImageGallerySaver.saveFile(imageFile.path, isReturnPathOfIOS: true);
        } else {
          final imageData = await imageFile.readAsBytes();
          result = await ImageGallerySaver.saveImage(Uint8List.fromList(imageData));
        }
      } catch (e) {
        unawaited(CommonToast.instance.show(context, e.toString()));
      }
    } else {
      final imageFile = File(imageUri);
      if (decryptKey != null) {
        final completer = Completer();
        await DecryptedCacheManager.decryptFile(imageFile, decryptKey, nonce: decryptNonce, bytesCallback: (imageData) async {
          result = await ImageGallerySaver.saveImage(Uint8List.fromList(imageData));
          completer.complete();
        });
        await completer.future;
      } else {
        final imageData = await imageFile.readAsBytes();
        result = await ImageGallerySaver.saveImage(Uint8List.fromList(imageData));
      }
    }

    unawaited(OXLoading.dismiss());

    if (result != null) {
      unawaited(CommonToast.instance.show(context, Localized.text('ox_chat.str_saved_to_album')));
    } else {
      unawaited(CommonToast.instance.show(context, Localized.text('ox_chat.str_save_failed')));
    }
  }
}

class ImageGalleryOptions {
  const ImageGalleryOptions({
    this.maxScale,
    this.minScale,
  });

  /// See [PhotoViewGalleryPageOptions.maxScale].
  final dynamic maxScale;

  /// See [PhotoViewGalleryPageOptions.minScale].
  final dynamic minScale;
}
