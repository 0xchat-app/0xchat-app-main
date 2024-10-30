import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_media_widget.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_image_gallery.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/widgets/gallery/gallery_image_widget.dart';

class SearchTabGridView<T> extends StatelessWidget {
  // final List<T> data;
  final List<MessageDBISAR> data;

  // final Widget Function(BuildContext context, T item) builder;

  const SearchTabGridView({
    super.key,
    required this.data,
    // required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.px,vertical: 2.px),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        if (MessageDBISAR.stringtoMessageType(data[index].type) == MessageType.image ||
            MessageDBISAR.stringtoMessageType(data[index].type) == MessageType.encryptedImage) {
          return GestureDetector(
            onTap: () {
              CommonImageGallery.show(
                context: context,
                imageList: [data[index]]
                    .map((e) => ImageEntry(
                          id: index.toString(),
                          url: e.decryptContent,
                          decryptedKey: e.decryptSecret,
                        ))
                    .toList(),
                initialPage: 0,
              );
            },
            child: GalleryImageWidget(
              uri: data[index].decryptContent,
              fit: BoxFit.cover,
              decryptKey: data[index].decryptSecret,
              decryptNonce: data[index].decryptNonce,
            ),
          );
        }

        return MediaVideoWidget(messageDBISAR: data[index]);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
    );
  }
}