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
  final String searchQuery;
  final String? chatId;

  const SearchTabGridView({
    super.key,
    required this.searchQuery,
    this.chatId,
  });

  @override
  State<SearchTabGridView> createState() => _SearchTabGridViewState();
}

class _SearchTabGridViewState extends State<SearchTabGridView> with CommonStateViewMixin {

  List<MessageDBISAR> _mediaMessages = [];
  final ScrollController _scrollController = ScrollController();
  int? lastTimestamp;
  final int pageSize = 51;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _updateState();
    _scrollController.addListener(_scrollListener);
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

  void _updateState() {
    if (widget.searchQuery.isEmpty) {
      _getMediaList();
    } else {
      _getMediaList(content: widget.searchQuery);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _updateState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaMessages = _mediaMessages;
    return commonStateViewWidget(
      context,
      GridView.builder(
        controller: _scrollController,
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
                    onDeleteChanged: (message) {
                      setState(() {
                        _mediaMessages.remove(message);
                      });
                    },
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
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _mediaMessages.clear();
      hasMore = true;
      lastTimestamp = null;
      _getMediaList(content: widget.searchQuery);
    }
  }

  void _getMediaList({String? content}) async {
    if(!hasMore) return;
    Map result = await Messages.loadMessagesFromDB(
      receiver: widget.chatId,
      messageTypes: [
        MessageType.image,
        MessageType.encryptedImage,
        MessageType.video,
        MessageType.encryptedVideo,
      ],
      decryptContentLike: content,
      until: lastTimestamp,
      limit: pageSize,
    );
    List<MessageDBISAR> messages = result['messages'] ?? <MessageDBISAR>[];
    if (messages.isEmpty) {
      updateStateView(CommonStateView.CommonStateView_NoData);
    } else {
      lastTimestamp = messages.last.createTime - 1;
      _mediaMessages.addAll(messages);
      if (messages.length < pageSize) hasMore = false;
      updateStateView(CommonStateView.CommonStateView_None);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}
