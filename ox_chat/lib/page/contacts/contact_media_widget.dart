import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';

import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/video_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';

import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_video_page.dart';

import '../../widget/image_preview_widget.dart';

class ContactMediaWidget extends StatefulWidget {
  final UserDBISAR userDB;
  ContactMediaWidget({required this.userDB});

  @override
  ContactMediaWidgetState createState() => new ContactMediaWidgetState();
}

class ContactMediaWidgetState extends State<ContactMediaWidget> {
  List<MessageDBISAR> messagesList = [];
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
    List<MessageDBISAR> messages =
        (await Messages.loadMessagesFromDB(
          receiver: widget.userDB.pubKey,
            messageTypes: [
              MessageType.image,
              MessageType.encryptedImage,
              MessageType.video,
              MessageType.encryptedVideo,
            ]))['messages'] ??
            <MessageDBISAR>[];
    if (messages.isNotEmpty) {
      messagesList = messages;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if(messagesList.isEmpty) return _noDataWidget();
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messagesList.length,
      itemBuilder: (context, index) {
        if(MessageDBISAR.stringtoMessageType(messagesList[index].type) == MessageType.image || MessageDBISAR.stringtoMessageType(messagesList[index].type) == MessageType.encryptedImage){
          return ImagePreviewWidget(
            uri: messagesList[index].decryptContent,
            imageWidth: 40,
            imageHeight: 40,
            decryptKey: messagesList[index].decryptSecret,
            decryptNonce: messagesList[index].decryptNonce,
          );
        }

        return MediaVideoWidget(messageDBISAR:messagesList[index]);

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
  File? _thumbnailFile;

  @override
  void initState() {
    super.initState();
    _initializeThumbnail();
  }

  Future<void> _initializeThumbnail() async {
    final String? thumbPath = (await OXVideoUtils.getVideoThumbnailImage(
            videoURL: widget.messageDBISAR.decryptContent))
        ?.path;
    if (mounted) {
      setState(() {
        if (thumbPath != null) {
          _thumbnailFile = File(thumbPath);
        }
      });
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.messageDBISAR.decryptContent !=
        oldWidget.messageDBISAR.decryptContent) {
      if (mounted) {
        _thumbnailFile = null;
      }
      _initializeThumbnail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return videoMoment();
  }

  Widget videoMoment() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.px,
      ),
      child: GestureDetector(
        onTap: () {
          CommonVideoPage.show(widget.messageDBISAR.decryptContent);
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: ThemeColor.color100,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Adapt.px(12),
                  ),
                ),
              ),
              width: 40.px,
              // height: 154.px,
            ),
            _getPicWidget(),
            // _videoSurfaceDrawingWidget(),
          ],
        ),
      ),
    );
  }

  Widget _getPicWidget() {
    if (_thumbnailFile == null) return const SizedBox();
    return Image.file(
      _thumbnailFile!,
      width: 40.px,
      fit: BoxFit.cover,
    );
  }
}
