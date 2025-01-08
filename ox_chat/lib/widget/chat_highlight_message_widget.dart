
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../utils/general_handler/chat_highlight_message_handler.dart';

class ChatHighlightMessageWidget extends StatefulWidget {

  ChatHighlightMessageWidget({
    super.key,
    required this.handler,
    required this.anchorMessageOnTap,
    required this.scrollToBottomOnTap,
    this.showScrollToBottomItem = false,
  });

  final ChatHighlightMessageHandler handler;
  final Function(String messageId) anchorMessageOnTap;
  final VoidCallback scrollToBottomOnTap;
  final bool showScrollToBottomItem;

  @override
  State<StatefulWidget> createState() => ChatHighlightMessageWidgetState();
}

class ChatHighlightMessageWidgetState extends State<ChatHighlightMessageWidget> {

  ChatHighlightMessageHandler get handler => widget.handler;

  double get _fontSize => 12;
  EdgeInsets get _numPadding => EdgeInsets.symmetric(
    horizontal: 5.5.px,
    vertical: 1.px,
  );

  @override
  void initState() {
    super.initState();
    handler.dataHasChanged = () => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: handler.initializeComplete,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const SizedBox();
        return Column(
          children: [
            _buildAnimatedItem(
              visible: handler.unreadLastMessage != null,
              child: _buildItem(
                count: handler.unreadMessageCount,
                iconName: 'icon_arrow_down.png',
                rotate: true,
                onTap: () {
                  final msgId = handler.unreadLastMessage!.id;
                  handler.tryRemoveMessageHighlightState(msgId);
                  widget.anchorMessageOnTap.call(msgId);
                },
              ),
            ),
            _buildAnimatedItem(
              visible: handler.reactionMessages.isNotEmpty,
              child: _buildItem(
                count: handler.reactionMessages.length,
                iconName: 'chat_highlight_reaction.png',
                onTap: () {
                  final msgId = handler.reactionMessages.first.id;
                  handler.tryRemoveMessageHighlightState(msgId);
                  widget.anchorMessageOnTap.call(msgId);
                },
              ),
            ),
            _buildAnimatedItem(
              visible: handler.mentionMessages.isNotEmpty,
              child: _buildItem(
                count: handler.mentionMessages.length,
                iconName: 'chat_highlight_mention.png',
                onTap: () {
                  final msgId = handler.mentionMessages.first.id;
                  handler.tryRemoveMessageHighlightState(msgId);
                  widget.anchorMessageOnTap.call(msgId);
                },
              ),
            ),
            _buildAnimatedItem(
              visible: widget.showScrollToBottomItem,
              child: _buildItem(
                count: 0,
                iconName: 'icon_arrow_down.png',
                onTap: () {
                  widget.scrollToBottomOnTap.call();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedItem({
    required bool visible,
    required Widget child,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          ),
        );
      },
      child: visible ? child : SizedBox(),
    );
  }

  Widget _buildItem({
    required int count,
    required String iconName,
    required GestureTapCallback onTap,
    bool rotate = false,
  }) {
    var countText = count > 9999 ? '9999+' : count.toString();
    if (count == 0) {
      countText = '';
    }
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 48.px,
            height: 48.px,
            decoration: BoxDecoration(
              color: ThemeColor.color160,
              borderRadius: BorderRadius.circular(24.px),
            ),
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: rotate ? pi : 0,
              child: CommonImage(
                iconName: iconName,
                size: 24.px,
                package: 'ox_chat',
              ),
            ),
          ),
          if (countText.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              top: -_fontSize.spWithTextScale / 2,
              child: Center(
                child: Container(
                  padding: _numPadding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.px),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        ThemeColor.gradientMainEnd,
                        ThemeColor.gradientMainStart
                      ],
                    ),
                  ),
                  child: Text(
                    countText,
                    style: TextStyle(
                      fontSize: _fontSize.sp,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ).setPaddingOnly(top: 12.px);
  }
}