
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:ox_common/widgets/common_decrypted_image_provider.dart';
import 'package:ox_common/widgets/common_toast.dart';

import '../conditional/conditional.dart';
import '../models/preview_image.dart';

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'dart:io';

class ImageGallery extends StatelessWidget {
  const ImageGallery({
    super.key,
    this.imageHeaders,
    required this.images,
    required this.onClosePressed,
    this.options = const ImageGalleryOptions(),
    required this.pageController,
  });

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


  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          onClosePressed();
          return false;
        },
        child: Dismissible(
          key: const Key('photo_view_gallery'),
          background: Container(color: Colors.black,),
          direction: DismissDirection.down,
          onDismissed: (direction) => onClosePressed(),
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                builder: (BuildContext context, int index) {
                  final isEncryptedImage = images[index].encrypted;
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(
                      images[index].uri,
                      headers: imageHeaders,
                      cacheManager: isEncryptedImage ? DecryptedCacheManager(options.decryptionKey) : null,
                    ),
                    minScale: options.minScale,
                    maxScale: options.maxScale,
                  );
                },
                itemCount: images.length,
                loadingBuilder: (context, event) =>
                    _imageGalleryLoadingBuilder(event),
                pageController: pageController,
                scrollPhysics: const ClampingScrollPhysics(),
              ),
              Positioned.directional(
                end: 16,
                textDirection: Directionality.of(context),
                top: 56,
                child: CloseButton(
                  color: Colors.white,
                  onPressed: onClosePressed,
                ),
              ),
              Positioned.directional(
                end: 16,
                textDirection: Directionality.of(context),
                bottom: 56,
                child: IconButton(
                  icon: Icon(Icons.save_alt, color: Colors.white),
                  onPressed: () async{
                    if (RegExp(r'http?:\/\/').hasMatch(images[pageController.initialPage].uri)) {
                      final uri = Uri.parse(images[pageController.initialPage].uri);
                      final response = await Dio().get(
                          images[pageController.initialPage].uri,
                          options: Options(responseType: ResponseType.bytes));
                      final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(response.data),
                          quality: 100,
                          name: uri.pathSegments.last);
                      // print(result);
                      if(result['isSuccess'] == true){
                        CommonToast.instance.show(context, 'save successful');
                      }
                    } else {
                      File imageFile = File(images[pageController.initialPage].uri);
                      final uri = Uri.parse(images[pageController.initialPage].uri);
                      final bytes = await imageFile.readAsBytes();
                      final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(bytes),
                          quality: 100,
                          name: uri.pathSegments.last);
                      // print(result);
                      if(result['isSuccess'] == true){
                        CommonToast.instance.show(context, 'save successful');
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _imageGalleryLoadingBuilder(ImageChunkEvent? event) => Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            value: event == null || event.expectedTotalBytes == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      );
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
