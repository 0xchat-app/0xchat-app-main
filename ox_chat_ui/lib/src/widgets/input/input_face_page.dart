import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/theme_color.dart';

class InputFacePage extends StatefulWidget {
  final TextEditingController? textController;
  const InputFacePage({super.key, this.textController});

  @override
  State<InputFacePage> createState() => _InputFacePageState();
}

class _InputFacePageState extends State<InputFacePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color190,
        borderRadius: BorderRadius.circular(12),
      ),
      child: EmojiPicker(
        textEditingController: widget.textController,
        config: Config(
          columns: (screenWidth / 50).floor(),
          emojiSizeMax: 30,
          // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Category.RECENT,
          bgColor: Colors.transparent,
          indicatorColor: ThemeColor.color0,
          iconColor: ThemeColor.color100,
          iconColorSelected: ThemeColor.color0,
          backspaceColor: ThemeColor.color100,
          skinToneDialogBgColor: Colors.white60,
          skinToneIndicatorColor: Colors.white30,
          enableSkinTones: true,
          showRecentsTab: false,
          recentsLimit: 28,
          checkPlatformCompatibility: false,
          noRecents: const Text(
            'No Recents',
            style: TextStyle(fontSize: 20, color: Colors.black26),
            textAlign: TextAlign.center,
          ),
          // Needs to be const Widget
          loadingIndicator: const SizedBox.shrink(),
          // Needs to be const Widget
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
        onEmojiSelected: (Category? ca, Emoji emoje) {

        },
        onBackspacePressed: () {

        },
      ),
    );
  }
}
