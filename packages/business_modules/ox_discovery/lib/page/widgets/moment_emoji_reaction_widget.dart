import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/mixin/common_navigator_observer_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/emoji_style.dart';
import 'package:ox_common/utils/ox_default_emoji.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import '../../model/moment_ui_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:nostr_core_dart/nostr.dart';

class MomentEmojiReactionWidget extends StatefulWidget {
  final NotedUIModel? notedUIModel;
  final bool reactionTag;
  const MomentEmojiReactionWidget(
      {super.key, required this.notedUIModel, required this.reactionTag});

  @override
  _MomentEmojiReactionWidgetState createState() =>
      _MomentEmojiReactionWidgetState();
}

class _MomentEmojiReactionWidgetState extends State<MomentEmojiReactionWidget> with SingleTickerProviderStateMixin, NavigatorObserverMixin {
  List<String> emojiReactionList = [];
  Map<String, int> emojiReactionMap = {};


  @override
  void initState() {
    super.initState();
    _getReactionMap();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 300.px
      ),
      padding: EdgeInsets.all(6.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color190,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildShowEmojiWidget(),
              buildSessionEmojiGridView(oxDefaultEmoji),
            ],
          ).setPadding(EdgeInsets.symmetric(horizontal: 8.px, vertical: 12.px)),
        ),
      ),
    );
  }
  // emojiList

  Widget buildShowEmojiWidget() {
    NotedUIModel? notedUIModel = widget.notedUIModel;
    if (notedUIModel == null) return const SizedBox();
    int? getLikeNum = notedUIModel.noteDB.reactionEventIds?.length;
    if (getLikeNum == null || getLikeNum == 0) {
      return const SizedBox();
    }
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getLikeNum.toString() + ' Likes',
            style: TextStyle(
              fontSize: 12.sp,
              color: ThemeColor.color100,
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 13.px,
                runSpacing: 8.px,
                children: emojiReactionMap.keys.map((emojiStr) {
                  return RichText(
                    text: TextSpan(
                      text: emojiStr,
                      style: emojiTextStyle(
                        fontSize: 24.px,
                        color: ThemeColor.color100,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' x ' + emojiReactionMap[emojiStr].toString(),
                          style: TextStyle(
                            fontSize: 12.px, // 更大的字体
                          ),
                        ),
                      ],
                    ),
                  ).setPaddingOnly(right: 8.px);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSessionHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        color: ThemeColor.color100,
      ),
    );
  }

  Widget buildSessionEmojiGridView(List<Emoji> data) {
    NotedUIModel? notedUIModel = widget.notedUIModel;
    if (notedUIModel == null) return const SizedBox();
    int getLikeNum = notedUIModel.noteDB.reactionCountByMe;
    if (getLikeNum > 0 || widget.reactionTag) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Default emojis',
          style: TextStyle(
            fontSize: 12.sp,
            color: ThemeColor.color100,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
          child:  Wrap(
            spacing: 13.px,
            runSpacing: 8.px,
            children: data.map((item) => buildSingleEmoji(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildSingleEmoji(Emoji data) {
    return GestureDetector(
      onTap: () => _reactionOnTap(data),
      child: Text(
        data.emoji,
        style: emojiTextStyle(fontSize: 24.px),
      ),
    );
  }

  void _reactionOnTap(Emoji data) async {
    NoteDBISAR? noteDB = widget.notedUIModel?.noteDB;
    if (noteDB == null) return;
    bool isSuccess = false;
    if (noteDB.groupId.isEmpty) {
      OKEvent event = await Moment.sharedInstance.sendReaction(noteDB.noteId, content: data.emoji);
      isSuccess = event.status;
    } else {
      OKEvent event = await RelayGroup.sharedInstance.sendGroupNoteReaction(noteDB.noteId,content: data.emoji);
      isSuccess = event.status;
    }
    OXNavigator.pop(context, isSuccess);
  }

  void _getReactionMap() async {
    List<String>? list = widget.notedUIModel?.noteDB.reactionEventIds;
    if (list != null) {
      for (var item in list) {
        NoteDBISAR? note = await Moment.sharedInstance.loadNoteWithNoteId(item);
        if (note != null && note.content.length < 3) {
          String content = note.content;
          emojiReactionMap[content] = (emojiReactionMap[content] ?? 0) + 1;
        }
      }
    }
    setState(() {});
  }
}
