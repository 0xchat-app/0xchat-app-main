import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/video_data_manager.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_image_gallery.dart';
import 'package:ox_common/widgets/gallery/gallery_image_widget.dart';

import 'package:ox_common/widgets/common_video_page.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_common/upload/upload_utils.dart';

class ContactMediaWidget extends StatefulWidget {
  final UserDBISAR userDB;

  final ValueNotifier<bool> isScrollBottom;

  ContactMediaWidget({required this.userDB, required this.isScrollBottom});

  @override
  ContactMediaWidgetState createState() => new ContactMediaWidgetState();
}

class ContactMediaWidgetState extends State<ContactMediaWidget>
    with CommonStateViewMixin {
  List<types.CustomMessage> messagesList = [];
  final ScrollController _scrollController = ScrollController();
  int? lastTimestamp;
  final int pageSize = 30;
  bool hasMore = true;

  bool isTop = false;

  bool _previousScrollStatus = false;

  @override
  void initState() {
    super.initState();
    _getMediaList();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _getMediaList();
    }
    final atTop = _scrollController.position.pixels <= 0;
    if (isTop != atTop) {
      isTop = atTop;
      setState(() {});
    }
  }

  void _getMediaList() async {
    if (!hasMore) return;
    List<MessageDBISAR> messages = (await Messages.loadMessagesFromDB(
          receiver: widget.userDB.pubKey,
          messageTypes: [
            MessageType.image,
            MessageType.encryptedImage,
            MessageType.video,
            MessageType.encryptedVideo,
            MessageType.template,
          ],
          until: lastTimestamp,
          limit: pageSize,
        ))['messages'] ??
        <MessageDBISAR>[];
    if (messages.isEmpty) {
      updateStateView(CommonStateView.CommonStateView_NoData);
    } else {
      for (var custom in messages) {
        final customMsg = await custom.toChatUIMessage();
        if (customMsg == null) continue;
        if (customMsg is! types.CustomMessage) continue;
        if (customMsg.customType == CustomMessageType.imageSending ||
            customMsg.customType == CustomMessageType.video) {
          messagesList.add(customMsg);
        }
      }
      lastTimestamp = messages.last.createTime - 1;
      if (messages.length < pageSize) hasMore = false;
      if (messagesList.isNotEmpty && mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (messagesList.isEmpty) return _noDataWidget();
    return ValueListenableBuilder<bool>(
        valueListenable: widget.isScrollBottom,
        builder: (context, value, child) {
          ScrollPhysics physicsNever = const NeverScrollableScrollPhysics();
          bool isDisableScroll = isTop && _previousScrollStatus == value;

          ScrollPhysics? physicsPre = (isDisableScroll ? physicsNever : null);
          physicsPre = value ? physicsPre : physicsNever;

          _previousScrollStatus = value;
          return GridView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            shrinkWrap: false,
            physics: physicsPre,
            itemCount: messagesList.length,
            itemBuilder: (context, index) {
              types.CustomMessage customMsg = messagesList[index];
              if (customMsg.customType == CustomMessageType.imageSending) {
                if (ImageSendingMessageEx(customMsg).url.isEmpty) {
                  return const SizedBox();
                }
                return GestureDetector(
                  onTap: () {
                    CommonImageGallery.show(
                      context: context,
                      imageList: messagesList
                          .map((e) => ImageEntry(
                                id: index.toString(),
                                url: ImageSendingMessageEx(e).uri,
                                decryptedKey:
                                    ImageSendingMessageEx(e).encryptedKey,
                              ))
                          .toList(),
                      initialPage: index,
                    );
                  },
                  child: Container(
                    color: ThemeColor.color190,
                    child: GalleryImageWidget(
                      uri: ImageSendingMessageEx(customMsg).uri,
                      fit: BoxFit.cover,
                      decryptKey:
                      ImageSendingMessageEx(customMsg).encryptedKey,
                      decryptNonce:
                      ImageSendingMessageEx(customMsg).encryptedNonce,
                    ),
                  ),
                );
              }

              if (customMsg.customType == CustomMessageType.video) {
                return Container(
                  color: ThemeColor.color190,
                  child: RenderVideoMessage(
                    message: messagesList[index],
                    reactionWidget: Container(),
                    receiverPubkey: null,
                    messageUpdateCallback: (newMessage) {
                      if (!mounted) return;
                      setState(() {
                        messagesList[index] = newMessage;
                      });
                    },
                  ),
                );
              }
              return const SizedBox();
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 1,
            ),
          );
        });
  }

  Widget _noDataWidget() {
    return Container(
      height: 200.px,
      padding: EdgeInsets.only(
        top: 100.px,
      ),
      child: Center(
        child: Column(
          children: [
            CommonImage(
              iconName: 'icon_no_data.png',
              width: Adapt.px(90),
              height: Adapt.px(90),
            ),
            Text(
              'No Media',
              style: TextStyle(
                fontSize: 16.px,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color100,
              ),
            ).setPaddingOnly(
              top: 24.px,
            ),
          ],
        ),
      ),
    );
  }
}

class MediaVideoWidget extends StatefulWidget {
  final MessageDBISAR messageDBISAR;

  const MediaVideoWidget({super.key, required this.messageDBISAR});

  @override
  MediaVideoWidgetState createState() => MediaVideoWidgetState();
}

class MediaVideoWidgetState extends State<MediaVideoWidget> {
  types.CustomMessage? message;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    message =
        await widget.messageDBISAR.toChatUIMessage() as types.CustomMessage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox();
    return RenderVideoMessage(
      message: message!,
      reactionWidget: Container(),
      receiverPubkey: null,
      messageUpdateCallback: (types.Message newMessage) {
        message = newMessage as types.CustomMessage;
        if(mounted) setState(() {});
      },
    );
  }
}

class RenderVideoMessage extends StatefulWidget {
  RenderVideoMessage({
    required this.message,
    required this.reactionWidget,
    required this.receiverPubkey,
    this.messageUpdateCallback,
  });

  final types.CustomMessage message;
  final Widget reactionWidget;
  final String? receiverPubkey;
  final Function(types.CustomMessage newMessage)? messageUpdateCallback;

  @override
  State<StatefulWidget> createState() => RenderVideoMessageState();
}

class RenderVideoMessageState extends State<RenderVideoMessage> {

  String get fileId => VideoMessageEx(widget.message).fileId;
  String get videoURL => VideoMessageEx(widget.message).url;
  String get videoPath => VideoMessageEx(widget.message).videoPath;
  String get snapshotPath => VideoMessageEx(widget.message).snapshotPath;
  String? get encryptedKey => VideoMessageEx(widget.message).encryptedKey;
  String? get encryptedNonce => VideoMessageEx(widget.message).encryptedNonce;
  bool get canOpen => VideoMessageEx(widget.message).canOpen;

  int? width;
  int? height;
  Stream<double>? stream;

  @override
  void initState() {
    super.initState();
    prepareData();
    tryInitializeVideoFile();
  }

  @override
  void dispose() {
    VideoDataManager.shared.cancelTask(videoURL);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RenderVideoMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    prepareData();
  }

  void prepareData() {
    final message = widget.message;

    width = VideoMessageEx(message).width;
    height = VideoMessageEx(message).height;
    stream = fileId.isEmpty || videoURL.isNotEmpty
        ? null
        : UploadManager.shared.getUploadProgress(fileId, null);

    if (width == null || height == null) {
      try {
        final uri = Uri.parse(videoURL);
        final query = uri.queryParameters;
        width ??= int.tryParse(query['width'] ?? query['w'] ?? '');
        height ??= int.tryParse(query['height'] ?? query['h'] ?? '');
      } catch (_) { }
    }
  }

  void tryInitializeVideoFile() async {
    if (videoURL.isEmpty) return;

    final media = await VideoDataManager.shared.fetchVideoMedia(
      videoURL: videoURL,
      encryptedKey: encryptedKey,
      encryptedNonce: encryptedNonce,
    );
    if (media == null) return;

    types.CustomMessage newMessage = widget.message.copyWith();
    VideoMessageEx(newMessage).videoPath = media.path ?? '';
    VideoMessageEx(newMessage).snapshotPath = media.thumbPath ?? '';

    widget.messageUpdateCallback?.call(newMessage);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        CommonVideoPage.show(videoPath);
      },
      child: Stack(
        children: [
          snapshotBuilder(snapshotPath),
          if (videoURL.isNotEmpty)
            Positioned.fill(
              child: Center(
                  child: canOpen ? buildPlayIcon() : buildLoadingWidget()),
            )
        ],
      ),
    );
  }

  Widget buildPlayIcon() => Icon(
        Icons.play_circle,
        size: 60.px,
      );

  Widget buildLoadingWidget() => CircularProgressIndicator(
        strokeWidth: 5,
        backgroundColor: Colors.white.withOpacity(0.5),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeCap: StrokeCap.round,
      );

  Widget snapshotBuilder(String imagePath) {
    if (imagePath.isEmpty) return const SizedBox();
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      child: GalleryImageWidget(
        uri: imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
