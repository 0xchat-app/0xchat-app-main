import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/video_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_file_cache_manager.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_image_gallery.dart';
import 'package:ox_common/widgets/gallery/gallery_image_widget.dart';

import 'package:ox_common/widgets/common_video_page.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_common/upload/upload_utils.dart';

class ContactMediaWidget extends StatefulWidget {
  final UserDBISAR userDB;
  ContactMediaWidget({required this.userDB});

  @override
  ContactMediaWidgetState createState() => new ContactMediaWidgetState();
}

class ContactMediaWidgetState extends State<ContactMediaWidget> {
  List<types.CustomMessage> messagesList = [];
  @override
  void initState() {
    super.initState();
    _getMediaList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getMediaList() async {
    List<MessageDBISAR> messages = (await Messages.loadMessagesFromDB(
            receiver: widget.userDB.pubKey,
            messageTypes: [
              MessageType.image,
              MessageType.encryptedImage,
              MessageType.video,
              MessageType.encryptedVideo,
              MessageType.template,
            ]))['messages'] ??
        <MessageDBISAR>[];
    for(var custom in messages){
      final customMsg = await custom.toChatUIMessage();
      if (customMsg == null) continue;
      if (customMsg is! types.CustomMessage) continue;
      if (customMsg.customType == CustomMessageType.imageSending
          || customMsg.customType == CustomMessageType.video) {
        messagesList.add(customMsg);
      }
    }
    if (messagesList.isNotEmpty && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (messagesList.isEmpty) return _noDataWidget();
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messagesList.length,
      itemBuilder: (context, index) {
        types.CustomMessage customMsg = messagesList[index];
        if (customMsg.customType == CustomMessageType.imageSending) {
          return GestureDetector(
            onTap: () {
              CommonImageGallery.show(
                context: context,
                imageList: messagesList
                    .map((e) => ImageEntry(
                          id: index.toString(),
                          url: ImageSendingMessageEx(e).url,
                          decryptedKey: ImageSendingMessageEx(e).encryptedKey,
                        ))
                    .toList(),
                initialPage: 0,
              );
            },
            child: GalleryImageWidget(
              uri: ImageSendingMessageEx(customMsg).url,
              fit: BoxFit.cover,
              decryptKey: ImageSendingMessageEx(customMsg).encryptedKey,
              decryptNonce: ImageSendingMessageEx(customMsg).encryptedNonce,
            ),
          );
        }

        if (customMsg.customType == CustomMessageType.video) {
          return RenderVideoMessage(
            message: messagesList[index],
            reactionWidget: Container(),
            receiverPubkey: null,
            messageUpdateCallback: (newMessage) {
              setState(() {
                messagesList[index] = newMessage;
              });
            },
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
        setState(() {});
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
  String videoURL = '';
  String videoPath = '';
  late Future<String> snapshotPath;
  int? width;
  int? height;
  String? encryptedKey;
  String? encryptedNonce;
  Stream<double>? stream;

  bool canOpen = false;

  @override
  void initState() {
    super.initState();
    prepareData();
    tryInitializeVideoFile();
  }

  @override
  void didUpdateWidget(covariant RenderVideoMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    prepareData();
  }

  void prepareData() {
    final message = widget.message;
    final fileId = VideoMessageEx(message).fileId;
    videoURL = VideoMessageEx(message).url;
    videoPath = VideoMessageEx(message).videoPath;
    encryptedKey = VideoMessageEx(message).encryptedKey;
    encryptedNonce = VideoMessageEx(message).encryptedNonce;
    canOpen = VideoMessageEx(message).canOpen;

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
      } catch (_) {}
    }

    final snapshotPath = VideoMessageEx(message).snapshotPath;
    if (snapshotPath.isNotEmpty) {
      this.snapshotPath = Future.value(snapshotPath);
    } else if (videoURL.isNotEmpty) {
      this.snapshotPath =
          OXVideoUtils.getVideoThumbnailImage(videoURL: videoURL).then((
              file) => file?.path ?? '');
    } else if (fileId.isNotEmpty) {
      this.snapshotPath = Future.value(OXVideoUtils
          .getVideoThumbnailImageFromMem(cacheKey: fileId)
          ?.path ?? '');
    }
  }

  void tryInitializeVideoFile() async {
    if (videoPath.isNotEmpty) return;
    if (videoURL.isEmpty) return;

    File sourceFile;
    final fileManager = OXFileCacheManager.get(
        encryptKey: encryptedKey, encryptNonce: encryptedNonce);
    final cacheFile = await fileManager.getFileFromCache(videoURL);
    if (cacheFile != null) {
      sourceFile = cacheFile.file;
    } else {
      sourceFile = await fileManager.getSingleFile(videoURL);
      if (encryptedKey != null) {
        sourceFile = await DecryptedCacheManager.decryptFile(
            sourceFile, encryptedKey!, nonce: encryptedNonce);
      }
    }

    final path = sourceFile.path;
    if (path.isEmpty) return;

    final snapshotPath = (await OXVideoUtils.getVideoThumbnailImageWithFilePath(
        videoFilePath: path))?.path ?? '';

    types.CustomMessage newMessage = widget.message.copyWith();
    VideoMessageEx(newMessage).videoPath = path;
    VideoMessageEx(newMessage).snapshotPath = snapshotPath;

    widget.messageUpdateCallback?.call(newMessage);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        CommonVideoPage.show(videoPath);
      },
      child: Stack(
        children: [
          FutureBuilder(
            future: snapshotPath,
            builder: (context, snapshot) {
              final snapshotPath = snapshot.data ?? '';
              return snapshotBuilder(snapshotPath);
            },
          ),
          if (videoURL.isNotEmpty)
            Positioned.fill(
              child: Center(
                  child: canOpen ? buildPlayIcon() : buildLoadingWidget()
              ),
            )
        ],
      ),
    );
  }

  Widget buildPlayIcon() => Icon(Icons.play_circle, size: 60.px,);

  Widget buildLoadingWidget() =>
      CircularProgressIndicator(
        strokeWidth: 5,
        backgroundColor: Colors.white.withOpacity(0.5),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeCap: StrokeCap.round,
      );

  Widget snapshotBuilder(String imagePath) {
    if(imagePath.isEmpty) return const SizedBox();
    return Container(
        width: MediaQuery.of(context).size.width / 3,
        child: GalleryImageWidget(
          uri: imagePath,
          fit: BoxFit.cover,
        ),
      );
  }
}
