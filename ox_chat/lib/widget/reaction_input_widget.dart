
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_default_emoji.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';

class ReactionInputWidget extends StatefulWidget {

  final Function(bool isExpanded)? expandedOnChange;
  final Function(Emoji emoji)? reactionOnTap;

  ReactionInputWidget({
    this.expandedOnChange,
    this.reactionOnTap,
  });

  @override
  State<StatefulWidget> createState() => ReactionInputWidgetState();
}

class ReactionInputWidgetState extends State<ReactionInputWidget> {

  List<Emoji> emojiData = [];
  List<Emoji> frequentlyEmoji = [];
  final frequentlyEmojiLimit = 16;

  Duration expandedDuration = const Duration(milliseconds: 300);
  bool isExpanded = false;
  final Key wholeKey = UniqueKey();
  bool recentLoadFinish = false;

  double get emojiSize => 24;

  @override
  void initState() {
    super.initState();
    emojiData = oxDefaultEmoji;
    if (emojiData.isNotEmpty) {
      frequentlyEmoji.addAll(emojiData.sublist(0, min(emojiData.length, frequentlyEmojiLimit)));
    }
    _EmojiLocalStorage.getRecentEmojis().then((recentEmoji) {
      setState(() {
        if (recentEmoji.isNotEmpty) {
          frequentlyEmoji = [
            ...recentEmoji,
            ...frequentlyEmoji,
          ].take(frequentlyEmojiLimit).toList();
        }
        recentLoadFinish = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        buildShortcutWidget(),
        buildWholeWidget(),
      ],
    );
  }

  Widget buildShortcutWidget() {
    final padding = EdgeInsets.symmetric(
      vertical: 4.px,
    );
    return AnimatedOpacity(
      opacity: isExpanded ? 0.0 : 1.0,
      curve: Curves.easeOut,
      duration: expandedDuration,
      child: Container(
        padding: padding,
        height: emojiSize.spWithTextScale + padding.vertical * 2,
        child: Row(
          children: [
            Expanded(
              child: recentLoadFinish ? ListView.separated(
                itemCount: frequentlyEmoji.length,
                padding: EdgeInsets.symmetric(horizontal: 8.px),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return buildSingleEmoji(frequentlyEmoji[index]);
                },
                separatorBuilder: (_, __) => SizedBox(width: 13.px,),
              ) : const SizedBox(),
            ),
            buildMoreButton().setPaddingOnly(left: 13.px, right: 8.px),
          ],
        ),
      ),
    );
  }

  Widget buildMoreButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = true;
        });
        widget.expandedOnChange?.call(isExpanded);
      },
      child: Container(
        height: 24.pxWithTextScale,
        width: 24.pxWithTextScale,
        decoration: BoxDecoration(
          color: ThemeColor.color160,
          borderRadius: BorderRadius.circular(12.pxWithTextScale),
        ),
        alignment: Alignment.center,
        child: CommonImage(
          iconName: 'icon_more.png',
          size: 18.pxWithTextScale,
          package: 'ox_chat',
        ),
      ),
    );
  }

  Widget buildSingleEmoji(Emoji data) {
    return GestureDetector(
      onTap: () {
        _EmojiLocalStorage.addEmojiToRecentlyUsed(emoji: data);
        widget.reactionOnTap?.call(data);
      },
      child: Text(
        data.emoji,
        style: TextStyle(
          fontSize: emojiSize.sp,
        ),
      ),
    );
  }

  Widget buildWholeWidget() {
    return AnimatedAlign(
      alignment: Alignment.topCenter,
      duration: expandedDuration,
      heightFactor: isExpanded ? 1.0 : 0.0,
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: isExpanded ? 1.0 : 0.0,
        duration: expandedDuration,
        curve: Curves.easeIn,
        child: ListView(
          key: wholeKey,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            buildSessionHeader('Frequently used'),
            buildSessionEmojiGridView(frequentlyEmoji),
            buildSessionHeader('Default emojis'),
            buildSessionEmojiGridView(emojiData),
          ],
        ),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 4.px),
      child: Wrap(
        spacing: 13.px,
        runSpacing: 8.px,
        children: data
            .map((item) => buildSingleEmoji(item))
            .toList(),
      ),
    );
  }
}

class _EmojiLocalStorage {
  static const _localKey = 'chat_emoji_recent';

  static String get localKey => _localKey + '_' + (OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '');
  /// Returns list of recently used emoji from cache
  static Future<List<Emoji>> getRecentEmojis() async {
    final json = await OXCacheManager.defaultOXCacheManager.getForeverData(localKey, defaultValue: []);
    try {
      return json.map((e) => Emoji.fromJson(e as Map<String, dynamic>)).cast<Emoji>().toList();
    } catch(_) {
      return [];
    }
  }

  /// Add an emoji to recently used list or increase its counter
  static Future<List<Emoji>> addEmojiToRecentlyUsed(
      {required Emoji emoji, Config config = const Config()}) async {
    var recentEmoji = await getRecentEmojis();
    var recentEmojiIndex =
        recentEmoji.indexWhere((element) => element.emoji == emoji.emoji);
    if (recentEmojiIndex != -1) {
      recentEmoji.removeAt(recentEmojiIndex);
    }

    recentEmoji.insert(0, emoji);
    recentEmoji =
        recentEmoji.sublist(0, min(config.recentsLimit, recentEmoji.length));

    await OXCacheManager.defaultOXCacheManager.saveForeverData(localKey, recentEmoji);

    return recentEmoji;
  }

  /// Clears the list of recent emojis in local storage
  Future<void> clearRecentEmojisInLocalStorage() async {
    await OXCacheManager.defaultOXCacheManager.saveForeverData(localKey, []);
  }
}

