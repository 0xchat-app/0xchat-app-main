import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';

import '../../utils/moment_widgets.dart';

class IntelligentInputBoxWidget extends StatefulWidget {
  final String hintText;
  final Function(bool isFocused)? isFocusedCallback;
  final TextEditingController textController;
  final String? imageUrl;
  const IntelligentInputBoxWidget({
    super.key,
    this.hintText = '---',
    this.isFocusedCallback,
    this.imageUrl,
    required this.textController,
  });

  @override
  _IntelligentInputBoxWidgetState createState() =>
      _IntelligentInputBoxWidgetState();
}

class _IntelligentInputBoxWidgetState extends State<IntelligentInputBoxWidget> {
  final FocusNode _replyFocusNode = FocusNode();

  bool isShowUserList = false;
  bool isShowTopicList = false;

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(() {
      final text = widget.textController.text;
      bool isShowUser = text.isNotEmpty && text[text.length - 1] == '@';
      bool isShowTopic = text.isNotEmpty && text[text.length - 1] == '#';

      setState(() {
        isShowUserList = isShowUser;
        isShowTopicList = isShowTopic;
      });
    });

    _replyFocusNode.addListener(() {
      widget.isFocusedCallback?.call(_replyFocusNode.hasFocus);
    });
  }

  void _insertText(String textToInsert) {
    final text = widget.textController.text;
    final textSelection = widget.textController.selection;
    final newText =
        text.replaceRange(textSelection.start, textSelection.end, textToInsert);
    widget.textController.value = widget.textController.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
    setState(() {
      isShowUserList = false;
      isShowTopicList = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 16.px,
                right: 16.px,
                bottom: 50.px,
              ),
              // height: 134.px,
              decoration: BoxDecoration(
                color: ThemeColor.color180,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Adapt.px(12),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _showImageWidget(),
                  TextField(
                    controller: widget.textController,
                    focusNode: _replyFocusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: widget.hintText,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  )
                ],
              ),
            ),
            _selectListWidget(),
          ],
        ),
      ),
    );
  }

  Widget _showImageWidget(){
    String? image = widget.imageUrl;
    if(image == null) return const SizedBox();
    return MomentWidgets.clipImage(
      borderRadius: 8.px,
      child: Image.asset(
        image,
        width: 100.px,
        fit: BoxFit.fill,
        height: 100.px,
      ),
    ).setPaddingOnly(top: 12.px);
  }

  Widget _selectListWidget() {
    if (!isShowUserList && !isShowTopicList) return const SizedBox();

    return Container(
      margin: EdgeInsets.only(
        top: 12.px,
      ),
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.px),
          topRight: Radius.circular(12.px),
        ),
      ),
      height: 300.px,
      child: SingleChildScrollView(
        child: isShowUserList
            ? _captionToUserListWidget()
            : _captionToTopicListWidget(),
      ),
    );
  }

  Widget _captionToUserListWidget() {
    if (!isShowUserList) return const SizedBox();
    return ListView.builder(
      primary: false,
      controller: null,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return _captionToUserWidget();
      },
    );
  }

  Widget _captionToUserWidget() {
    return GestureDetector(
      onTap: () {
        _insertText('User');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ThemeColor.color160,
              width: 1.px,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10.px,
          horizontal: 12.px,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MomentWidgets.clipImage(
              imageName: 'moment_avatar.png',
              borderRadius: 24.px,
              imageSize: 24.px,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 12.px,
              ),
              child: Row(
                children: [
                  Text(
                    '昵称',
                    style: TextStyle(
                      color: ThemeColor.color0,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.px,
                    ),
                  ).setPaddingOnly(
                    right: 8.px,
                  ),
                  Text(
                    '0xchat@satosh.com',
                    style: TextStyle(
                      color: ThemeColor.color100,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.px,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _captionToTopicListWidget() {
    if (!isShowTopicList) return const SizedBox();
    return ListView.builder(
      primary: false,
      controller: null,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return _captionToTopicWidget();
      },
    );
  }

  Widget _captionToTopicWidget() {
    return GestureDetector(
      onTap: () {
        _insertText('Topic');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: ThemeColor.color160,
              width: 1.px,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10.px,
          horizontal: 16.px,
        ),
        child: Row(
          children: [
            Text(
              '#Topic',
              style: TextStyle(
                fontSize: 14.px,
                color: ThemeColor.color0,
                fontWeight: FontWeight.w600,
              ),
            ).setPaddingOnly(
              right: 8.px,
            ),
            Text(
              'Treding',
              style: TextStyle(
                fontSize: 14.px,
                color: ThemeColor.color100,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
