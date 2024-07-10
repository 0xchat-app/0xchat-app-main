
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/adapt.dart';
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

  @override
  void initState() {
    super.initState();
    emojiData = defaultEmoji;
    if (emojiData.isNotEmpty) {
      frequentlyEmoji.addAll(emojiData.sublist(0, min(emojiData.length, frequentlyEmojiLimit)));
    }
    _EmojiLocalStorage.getRecentEmojis().then((recentEmoji) {
      if (recentEmoji.isNotEmpty) {
        setState(() {
          frequentlyEmoji = [
            ...recentEmoji,
            ...frequentlyEmoji,
          ].take(frequentlyEmojiLimit).toList();
          recentLoadFinish = true;
        });
      }
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
    return AnimatedOpacity(
      opacity: isExpanded ? 0.0 : 1.0,
      curve: Curves.easeOut,
      duration: expandedDuration,
      child: SizedBox(
        height: 32.px,
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
        height: 24.px,
        width: 24.px,
        decoration: BoxDecoration(
          color: ThemeColor.color160,
          borderRadius: BorderRadius.circular(12.px),
        ),
        alignment: Alignment.center,
        child: CommonImage(
          iconName: 'icon_more.png',
          size: 18.px,
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
          fontSize: 24.sp,
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

const defaultEmoji = [
  Emoji('😀', 'Grinning Face'),
  Emoji('😃', 'Grinning Face With Big Eyes'),
  Emoji('😄', 'Grinning Face With Smiling Eyes'),
  Emoji('😁', 'Beaming Face With Smiling Eyes'),
  Emoji('😆', 'Grinning Squinting Face'),
  Emoji('😅', 'Grinning Face With Sweat'),
  Emoji('🤣', 'Rolling on the Floor Laughing'),
  Emoji('😂', 'Face With Tears of Joy'),
  Emoji('🙂', 'Slightly Smiling Face'),
  Emoji('🙃', 'Upside-Down Face'),
  Emoji('😉', 'Winking Face'),
  Emoji('😊', 'Smiling Face With Smiling Eyes'),
  Emoji('😇', 'Smiling Face With Halo'),
  Emoji('🥰', 'Smiling Face With Hearts'),
  Emoji('😍', 'Smiling Face With Heart-Eyes'),
  Emoji('🤩', 'Star-Struck'),
  Emoji('😘', 'Face Blowing a Kiss'),
  Emoji('😗', 'Kissing Face'),
  Emoji('☺', 'Smiling Face'),
  Emoji('😚', 'Kissing Face With Closed Eyes'),
  Emoji('😙', 'Kissing Face With Smiling Eyes'),
  Emoji('😋', 'Face Savoring Food'),
  Emoji('😛', 'Face With Tongue'),
  Emoji('😜', 'Winking Face With Tongue'),
  Emoji('🤪', 'Zany Face'),
  Emoji('😝', 'Squinting Face With Tongue'),
  Emoji('🤑', 'Money-Mouth Face'),
  Emoji('🤗', 'Hugging Face'),
  Emoji('🫣', 'Face with Peeking Eye'),
  Emoji('🤭', 'Face With Hand Over Mouth'),
  Emoji('🫢', 'Face with Open Eyes and Hand Over Mouth'),
  Emoji('🫡', 'Saluting Face'),
  Emoji('🤫', 'Shushing Face'),
  Emoji('🫠', 'Melting Face'),
  Emoji('🤔', 'Thinking Face'),
  Emoji('🤐', 'Zipper-Mouth Face'),
  Emoji('🤨', 'Face With Raised Eyebrow'),
  Emoji('😐', 'Neutral Face'),
  Emoji('🫤', 'Face with Diagonal Mouth'),
  Emoji('😑', 'Expressionless Face'),
  Emoji('😶', 'Face Without Mouth'),
  Emoji('🫥', 'Dotted Line Face'),
  Emoji('😏', 'Smirking Face'),
  Emoji('😒', 'Unamused Face'),
  Emoji('🙄', 'Face With Rolling Eyes'),
  Emoji('😬', 'Grimacing Face'),
  Emoji('🤥', 'Lying Face'),
  Emoji('😌', 'Relieved Face'),
  Emoji('😔', 'Pensive Face'),
  Emoji('🥹', 'Face Holding Back Tears'),
  Emoji('😪', 'Sleepy Face'),
  Emoji('🤤', 'Drooling Face'),
  Emoji('😴', 'Sleeping Face'),
  Emoji('😷', 'Face With Medical Mask'),
  Emoji('🤒', 'Face With Thermometer'),
  Emoji('🤕', 'Face With Head-Bandage'),
  Emoji('🤢', 'Nauseated Face'),
  Emoji('🤮', 'Face Vomiting'),
  Emoji('🤧', 'Sneezing Face'),
  Emoji('🥵', 'Hot Face'),
  Emoji('🥶', 'Cold Face'),
  Emoji('🥴', 'Woozy Face'),
  Emoji('😵', 'Dizzy Face'),
  Emoji('🤯', 'Exploding Head'),
  Emoji('🤠', 'Cowboy Hat Face'),
  Emoji('🥳', 'Partying Face'),
  Emoji('😎', 'Smiling Face With Sunglasses'),
  Emoji('🤓', 'Nerd Face'),
  Emoji('🧐', 'Face With Monocle'),
  Emoji('😕', 'Confused Face'),
  Emoji('😟', 'Worried Face'),
  Emoji('🙁', 'Slightly Frowning Face'),
  Emoji('☹', 'Frowning Face'),
  Emoji('😮', 'Face With Open Mouth'),
  Emoji('😯', 'Hushed Face'),
  Emoji('😲', 'Astonished Face'),
  Emoji('😳', 'Flushed Face'),
  Emoji('🥺', 'Pleading Face'),
  Emoji('😦', 'Frowning Face With Open Mouth'),
  Emoji('😧', 'Anguished Face'),
  Emoji('😨', 'Fearful Face'),
  Emoji('😰', 'Anxious Face With Sweat'),
  Emoji('😥', 'Sad but Relieved Face'),
  Emoji('😢', 'Crying Face'),
  Emoji('😭', 'Loudly Crying Face'),
  Emoji('😱', 'Face Screaming in Fear'),
  Emoji('😖', 'Confounded Face'),
  Emoji('😣', 'Persevering Face'),
  Emoji('😞', 'Disappointed Face'),
  Emoji('😓', 'Downcast Face With Sweat'),
  Emoji('😩', 'Weary Face'),
  Emoji('😫', 'Tired Face'),
  Emoji('😤', 'Face With Steam From Nose'),
  Emoji('😡', 'Pouting Face'),
  Emoji('😠', 'Angry Face'),
  Emoji('🤬', 'Face With Symbols on Mouth'),
  Emoji('😈', 'Smiling Face With Horns'),
  Emoji('👿', 'Angry Face With Horns'),
  Emoji('💀', 'Skull'),
  Emoji('☠', 'Skull and Crossbones'),
  Emoji('💩', 'Pile of Poo'),
  Emoji('🤡', 'Clown Face'),
  Emoji('👹', 'Ogre'),
  Emoji('👺', 'Goblin'),
  Emoji('👻', 'Ghost'),
  Emoji('👽', 'Alien'),
  Emoji('👾', 'Alien Monster'),
  Emoji('🤖', 'Robot Face'),
  Emoji('😺', 'Grinning Cat Face'),
  Emoji('😸', 'Grinning Cat Face With Smiling Eyes'),
  Emoji('😹', 'Cat Face With Tears of Joy'),
  Emoji('😻', 'Smiling Cat Face With Heart-Eyes'),
  Emoji('😼', 'Cat Face With Wry Smile'),
  Emoji('😽', 'Kissing Cat Face'),
  Emoji('🙀', 'Weary Cat Face'),
  Emoji('😿', 'Crying Cat Face'),
  Emoji('😾', 'Pouting Cat Face'),
  Emoji('🫶', 'Heart Hands', hasSkinTone: true),
  Emoji('👋', 'Waving Hand', hasSkinTone: true),
  Emoji('🤚', 'Raised Back of Hand', hasSkinTone: true),
  Emoji('🖐', 'Hand With Fingers Splayed', hasSkinTone: true),
  Emoji('✋', 'Raised Hand', hasSkinTone: true),
  Emoji('🖖', 'Vulcan Salute', hasSkinTone: true),
  Emoji('👌', 'OK Hand', hasSkinTone: true),
  Emoji('🤌', 'Pinched Fingers', hasSkinTone: true),
  Emoji('🤏', 'Pinching Hand', hasSkinTone: true),
  Emoji('🫳', 'Palm Down Hand', hasSkinTone: true),
  Emoji('🫴', 'Palm Up Hand', hasSkinTone: true),
  Emoji('✌️', 'Victory Hand', hasSkinTone: true),
  Emoji('🫰', 'Hand with Index Finger and Thumb Crossed', hasSkinTone: true),
  Emoji('🤞', 'Crossed Fingers', hasSkinTone: true),
  Emoji('🤟', 'Love-You Gesture', hasSkinTone: true),
  Emoji('🤘', 'Sign of the Horns', hasSkinTone: true),
  Emoji('🤙', 'Call Me Hand', hasSkinTone: true),
  Emoji('👈', 'Backhand Index Pointing Left', hasSkinTone: true),
  Emoji('👉', 'Backhand Index Pointing Right', hasSkinTone: true),
  Emoji('👆', 'Backhand Index Pointing Up', hasSkinTone: true),
  Emoji('🖕', 'Middle Finger', hasSkinTone: true),
  Emoji('👇', 'Backhand Index Pointing Down', hasSkinTone: true),
  Emoji('☝', 'Index Pointing Up', hasSkinTone: true),
  Emoji('👍', 'Thumbs Up', hasSkinTone: true),
  Emoji('👎', 'Thumbs Down', hasSkinTone: true),
  Emoji('✊', 'Raised Fist', hasSkinTone: true),
  Emoji('👊', 'Oncoming Fist', hasSkinTone: true),
  Emoji('🤛', 'Left-Facing Fist', hasSkinTone: true),
  Emoji('🤜', 'Right-Facing Fist', hasSkinTone: true),
  Emoji('🫲', 'Leftwards Hand', hasSkinTone: true),
  Emoji('🫱', 'Rightwards Hand', hasSkinTone: true),
  Emoji('👏', 'Clapping Hands', hasSkinTone: true),
  Emoji('🙌', 'Raising Hands', hasSkinTone: true),
  Emoji('👐', 'Open Hands', hasSkinTone: true),
  Emoji('🤲', 'Palms Up Together', hasSkinTone: true),
  Emoji('🤝', 'Handshake', hasSkinTone: true),
  Emoji('🙏', 'Folded Hands', hasSkinTone: true),
  Emoji('🫵', 'Index Pointing at the Viewer', hasSkinTone: true),
  Emoji('✍', 'Writing Hand', hasSkinTone: true),
  Emoji('💅', 'Nail Polish', hasSkinTone: true),
  Emoji('🤳', 'Selfie', hasSkinTone: true),
  Emoji('💪', 'Flexed Biceps', hasSkinTone: true),
  Emoji('🦵', 'Leg', hasSkinTone: true),
  Emoji('🦶', 'Foot', hasSkinTone: true),
  Emoji('👂', 'Ear', hasSkinTone: true),
  Emoji('👃', 'Nose', hasSkinTone: true),
  Emoji('🧠', 'Brain'),
  Emoji('🦴', 'Bone'),
  Emoji('👀', 'Eyes'),
  Emoji('👁', 'Eye'),
  Emoji('💋', 'Kiss Mark'),
  Emoji('👄', 'Mouth'),
  Emoji('🫦', 'Biting Lip'),
  Emoji('🦷', 'Tooth'),
  Emoji('👅', 'Tongue'),
];