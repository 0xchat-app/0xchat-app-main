import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import '../../utils/moment_rich_text.dart';

class SimpleMomentReplyWidget extends StatefulWidget {
  final Function(bool isFocused)? isFocusedCallback;
  SimpleMomentReplyWidget({super.key,this.isFocusedCallback});

  @override
  _SimpleMomentReplyWidgetState createState() => _SimpleMomentReplyWidgetState();
}

class _SimpleMomentReplyWidgetState extends State<SimpleMomentReplyWidget> {
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _replyFocusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _replyFocusNode.addListener(() {
      widget.isFocusedCallback?.call(_replyFocusNode.hasFocus);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MomentRichText(
            text: 'Reply to @Satosh',
            textSize: 12.px,
            defaultTextColor: ThemeColor.color120,
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
      child: TextField(
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
        maxLines: 1,
      ),
    );
  }

  Widget _mediaWidget() {
    return Container(
      margin: EdgeInsets.only(
        right: 12.px,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
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
            onTap: () {},
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
}
