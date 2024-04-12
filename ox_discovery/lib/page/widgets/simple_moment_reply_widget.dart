import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat_ui/ox_chat_ui.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_discovery/utils/album_utils.dart';
import 'moment_rich_text_widget.dart';
import '../../utils/moment_widgets.dart';

class SimpleMomentReplyWidget extends StatefulWidget {
  final Function(bool isFocused)? isFocusedCallback;
  const SimpleMomentReplyWidget({super.key,this.isFocusedCallback});

  @override
  _SimpleMomentReplyWidgetState createState() => _SimpleMomentReplyWidgetState();
}

class _SimpleMomentReplyWidgetState extends State<SimpleMomentReplyWidget> {
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _replyFocusNode = FocusNode();
  bool _isFocused = false;
  String? imageUrl;
  bool isShowEmoji = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _replyFocusNode.addListener(() {
      widget.isFocusedCallback?.call(_replyFocusNode.hasFocus);
      if(!_replyFocusNode.hasFocus){
        isShowEmoji = false;
      }
      setState(() {
        _isFocused = _replyFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.px),
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        color: ThemeColor.color190,
        borderRadius: BorderRadius.all(
          Radius.circular(
            12.px,
          ),
        ),
      ),
      child: Column(
        children: [
          _postYourReplyHeadWidget(),
          _postYourReplyContentWidget(),
          _buildEmojiDialog(),
        ],
      ),
    );
  }

  Widget _postYourReplyHeadWidget() {
    if(!_isFocused) return const SizedBox();
    return Container(
      padding: EdgeInsets.only(
        bottom: 8.px,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            text: TextSpan(
              style: TextStyle(
                  fontSize: 12.px,
                  fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: 'Reply to ',
                  style: TextStyle(
                    color: ThemeColor.color120,
                  ),
                ),
                TextSpan(
                  text: '@Satosh',
                  style: TextStyle(
                    color: ThemeColor.gradientMainStart,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _mediaWidget(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.px,
                    vertical: 2.px,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ThemeColor.color180,
                      borderRadius: BorderRadius.circular(4.px),
                      gradient: LinearGradient(
                        colors: [
                          ThemeColor.gradientMainEnd,
                          ThemeColor.gradientMainStart,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      fontSize: Adapt.px(14),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _postYourReplyContentWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.px,
      ),
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.all(
          Radius.circular(
            12.px,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _showImageWidget(),
          TextField(
            controller: _replyController,
            focusNode: _replyFocusNode,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Post your reply',
              hintStyle: TextStyle(
                color: ThemeColor.color120,
              ),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          )
        ],
      ),
    );
  }

  Widget _showImageWidget(){
    if(imageUrl == null) return const SizedBox();
    return MomentWidgets.clipImage(
      borderRadius: 8.px,
      child: Image.asset(
        imageUrl!,
        width: 100.px,
        fit: BoxFit.fill,
        height: 100.px,
      ),
    ).setPaddingOnly(top: 12.px);
  }

  Widget _mediaWidget() {
    return Container(
      margin: EdgeInsets.only(
        right: 12.px,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              AlbumUtils.openAlbum(
                context,
                type:1,
                selectCount: 1,
                callback: (List<String> imageList){
                  imageUrl = imageList[0];
                  setState(() {});
                }
              );
            },
            child: CommonImage(
              iconName: 'chat_image_icon.png',
              size: 24.px,
              package: 'ox_discovery',
            ),
          ),
          SizedBox(
            width: 12.px,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isShowEmoji = !isShowEmoji;
              });
            },
            child: CommonImage(
              iconName: 'chat_emoti_icon.png',
              size: 24.px,
              package: 'ox_discovery',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiDialog() {
    if(!isShowEmoji) return const SizedBox();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color190,
      ),
      child: SafeArea(
        child: SizedBox(
          height: 180.px,
          child: InputFacePage(
            textController: _replyController,
          ),
        ),
      ),
    );
  }
}
