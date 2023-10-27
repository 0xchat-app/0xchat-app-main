
import 'dart:async';
import 'dart:io';

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ox_common/widgets/common_decrypted_image_provider.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../models/preview_image.dart';

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
                    imageProvider: OXCachedNetworkImageProviderEx.create(
                      context,
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
                  onPressed: () async {
                    if (images.isEmpty) return ;
                    final pageIndex = pageController.page?.round() ?? 0;
                    final imageUri = images[pageIndex].uri;

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
