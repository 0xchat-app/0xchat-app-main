import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_media_widget.dart';
import 'package:ox_chat/widget/media_message_viewer.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/gallery/gallery_image_widget.dart';

class SearchTabGridView extends StatefulWidget {
  // final List<MessageDBISAR> data;
  final String searchQuery;

  const SearchTabGridView({
    super.key,
    // required this.data,
    required this.searchQuery,
  });

  @override
  State<SearchTabGridView> createState() => _SearchTabGridViewState();
}

class _SearchTabGridViewState extends State<SearchTabGridView> with CommonStateViewMixin {

  List<MessageDBISAR> _mediaMessages = [];

  @override
  void initState() {
    super.initState();
    if (widget.searchQuery.isEmpty) {
      _getMediaList();
    } else {
      _getMediaList(content: widget.searchQuery);
    }
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaMessages = _mediaMessages;
    return commonStateViewWidget(
      context,
      GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.px),
        shrinkWrap: true,
        itemCount: mediaMessages.length,
        itemBuilder: (context, index) {
          final mediaMessage = mediaMessages[index];
          if (MessageDBISAR.stringtoMessageType(mediaMessage.type) == MessageType.image ||
              MessageDBISAR.stringtoMessageType(mediaMessage.type) == MessageType.encryptedImage) {
            return GestureDetector(
              onTap: () {
                OXNavigator.pushPage(
                  context,
                  (context) => MediaMessageViewer(
                    messages: mediaMessages,
                    initialIndex: index,
                  ),
                );
              },
              child: Container(
                color: ThemeColor.color180,
                child: GalleryImageWidget(
                  uri: mediaMessage.decryptContent,
                  fit: BoxFit.cover,
                  decryptKey: mediaMessage.decryptSecret,
                  decryptNonce: mediaMessage.decryptNonce,
                ),
              ),
            );
          }

          return MediaVideoWidget(messageDBISAR: mediaMessage);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant SearchTabGridView oldWidget) {
    if (widget.searchQuery != oldWidget.searchQuery) {
      _getMediaList(content: widget.searchQuery);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _getMediaList({String? content}) async {
    Map result = await Messages.loadMessagesFromDB(
      messageTypes: [
        MessageType.image,
        MessageType.encryptedImage,
        MessageType.video,
        MessageType.encryptedVideo,
      ],
      decryptContentLike: content,
      // since: 0
      // until: DateTime.now().microsecondsSinceEpoch,
      // limit: 50,
    );
    List<MessageDBISAR> messages = result['messages'] ?? <MessageDBISAR>[];
    _mediaMessages = messages;
    if (_mediaMessages.isEmpty) {
      updateStateView(CommonStateView.CommonStateView_NoData);
    } else {
      updateStateView(CommonStateView.CommonStateView_None);
    }
    setState(() {});
  }
}
