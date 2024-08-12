import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/video_utils.dart';

import '../../conditional/conditional.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';

/// A class that represents image message widget. Supports different
/// aspect ratios, renders blurred image as a background which is visible
/// if the image is narrow, renders image in form of a file if aspect
/// ratio is very small or very big.
class VideoMessage extends StatefulWidget {
  /// Creates an image message widget based on [types.ImageMessage].
  const VideoMessage({
    super.key,
    this.imageHeaders,
    required this.message,
    required this.messageWidth,
  });

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// [types.ImageMessage].
  final types.VideoMessage message;

  /// Maximum message width.
  final int messageWidth;

  @override
  State<VideoMessage> createState() => _VideoMessageState();
}

/// [VideoMessage] widget state.
class _VideoMessageState extends State<VideoMessage> {
  ImageProvider? _image;
  Size _size = Size.zero;
  ImageStream? _stream;

  @override
  void initState() {
    super.initState();
    OXVideoUtils.getVideoThumbnailImage(videoURL: widget.message.videoURL).then((snapshotImageFile) {
      if (!mounted) return ;
      if (snapshotImageFile != null) {
        _image = Image.file(snapshotImageFile).image;
        addImageSizeListener();
      }
    });

    _size = Size(widget.message.width ?? 0, widget.message.height ?? 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_size.isEmpty) {
      addImageSizeListener();
    }
  }

  @override
  void dispose() {
    _stream?.removeListener(ImageStreamListener(_updateImage));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var body = buildVideoContent();
    if (!widget.message.viewWithoutBubble) {
      body = Padding(
        padding: EdgeInsets.all(10.px),
        child: body,
      );
    }
    return body;
  }

  Widget buildVideoContent() {
    final user = InheritedUser.of(context).user;

    if (_size.aspectRatio == 0) {
      return Container(
        color: InheritedChatTheme.of(context).theme.secondaryColor,
        height: _size.height,
        width: _size.width,
      );

    } else if (_size.aspectRatio < 0.1 || _size.aspectRatio > 10) {
      return Container(
        color: user.id == widget.message.author.id
            ? InheritedChatTheme.of(context).theme.primaryColor
            : InheritedChatTheme.of(context).theme.secondaryColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 64,
              margin: EdgeInsetsDirectional.fromSTEB(
                InheritedChatTheme.of(context).theme.messageInsetsVertical,
                InheritedChatTheme.of(context).theme.messageInsetsVertical,
                16,
                InheritedChatTheme.of(context).theme.messageInsetsVertical,
              ),
              width: 64,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image(
                        fit: BoxFit.cover,
                        image: _image!,
                      ),
                    ),
                    Align(
                      alignment:Alignment(0, 0),
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors.transparent,
                        child: Icon(Icons.play_circle, size: 60,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsetsDirectional.fromSTEB(
                  0,
                  InheritedChatTheme.of(context).theme.messageInsetsVertical,
                  InheritedChatTheme.of(context).theme.messageInsetsHorizontal,
                  InheritedChatTheme.of(context).theme.messageInsetsVertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message.name,
                      style: user.id == widget.message.author.id
                          ? InheritedChatTheme.of(context)
                          .theme
                          .sentMessageBodyTextStyle
                          : InheritedChatTheme.of(context)
                          .theme
                          .receivedMessageBodyTextStyle,
                      textWidthBasis: TextWidthBasis.longestLine,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 4,
                      ),
                      child: Text(
                        formatBytes(widget.message.size.truncate()),
                        style: user.id == widget.message.author.id
                            ? InheritedChatTheme.of(context)
                            .theme
                            .sentMessageCaptionTextStyle
                            : InheritedChatTheme.of(context)
                            .theme
                            .receivedMessageCaptionTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        constraints: BoxConstraints(
          maxHeight: widget.messageWidth.toDouble(),
          minWidth: 170,
        ),
        child: AspectRatio(
          aspectRatio: _size.aspectRatio > 0 ? _size.aspectRatio : 1,
          child:
          Stack(
            children: [
              Positioned.fill(
                child: Image(
                  fit: BoxFit.cover,
                  image: _image!,
                ),
              ),
              Align(
                alignment:Alignment(0, 0),
                child: Container(
                  width: 60,
                  height: 60,
                  color: Colors.transparent,
                  child: Icon(Icons.play_circle, size: 60,),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void addImageSizeListener() {
    final oldImageStream = _stream;
    _stream = _image?.resolve(createLocalImageConfiguration(context));
    if (_stream?.key == oldImageStream?.key) {
      return;
    }
    final listener = ImageStreamListener(_updateImage);
    oldImageStream?.removeListener(listener);
    _stream?.addListener(listener);
  }

  void _updateImage(ImageInfo info, bool _) {
    setState(() {
      _size = Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      );
    });
  }
}
