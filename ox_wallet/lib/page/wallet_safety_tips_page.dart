
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart' hide TypewriterAnimatedText;
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/widget/wallet_safety_tips_writer.dart';

class WalletSafetyTipsPage extends StatefulWidget {
  const WalletSafetyTipsPage({
    super.key,
    required this.nextStepHandler,
  });

  final Function(BuildContext) nextStepHandler;

  @override
  State<StatefulWidget> createState() => WalletSafetyTipsPageState();
}

class WalletSafetyTipsPageState extends State<WalletSafetyTipsPage> {

  int step = 0;
  
  bool showStartBtn = true;

  List<TextSpan> tips = [];

  @override
  void initState() {
    super.initState();
    prepareData();
  }

  prepareData() {
    final textList = [
      TypewriterText.parse(
        r'''Please remember the following information''',
      ),
      TypewriterText.parse(
        r'''All assets in the Ecash wallet are ${Stored Locally}''',
      ),
      TypewriterText.parse(
        r'''If you delete the app or lose local data for any reason without ${Backing Up} your assets''',
      ),
      TypewriterText.parse(
        r'''They will be ${Irretrievable}''',
      ),
    ];
    tips = textList.map(
      (list) => TextSpan(
        children: list.map((text) => text.getTextSpan()).toList()
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '',
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => widget.nextStepHandler(context),
            child: Text(
              'Skip',
              style: TextStyle(
                color: ThemeColor.purple2,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ).setPadding(
              EdgeInsets.only(
                top: 18.px,
                bottom: 18.px,
              ),
            ),
          )
        ],
      ),
      body: buildContentView(),
    );
  }

  Widget buildContentView() {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          buildTipsView(),
          Positioned(
            bottom: 16.py,
            child: Visibility(
              visible: showStartBtn,
              child: ThemeButton(
                height: 48.px,
                width: 342.px,
                onTap: () => widget.nextStepHandler(context),
                text: 'Start',
              )
            )
          )
        ],
      ),
    );
  }

  Widget buildTipsView() {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      margin: EdgeInsets.only(bottom: 334.py),
      child: Stack(
        children: [
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            reverse: true,
            children: buildAllText().reversed.toList(),
          ).setPadding(EdgeInsets.symmetric(horizontal: 24.px),),
          IgnorePointer(
            child: Container(
              height: 200.py,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundColor, Colors.transparent,],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildAllText() {
    final totalCount = tips.length;
    return tips
        .asMap()
        .map((index, text) => MapEntry(index, buildTextView(text, index, totalCount).setPaddingOnly(bottom: 12.5.px)))
        .values.toList();
  }

  Widget buildTextView(TextSpan text, int index, int totalCount) {
    final isDisable = step > index;
    return Visibility(
      visible: step >= index,
      child: AnimatedOpacity(
        opacity: isDisable ? 0.2 : 1,
        duration: const Duration(milliseconds: 300),
        child: AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
            TypewriterAnimatedText(
              textSpan: text,
              textStyle: TextStyle(
                fontSize: 30.0.sp,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          onFinished: () {
            setState(() {
              if (step < totalCount - 1) step = index + 1;
            });
          },
          onTap: () { },
        ),
      ),
    );
  }
}

class TypewriterText {
  TypewriterText({required this.text, required this.isHighlight});
  final String text;
  final bool isHighlight;
  TextSpan getTextSpan() {
    final style = TextStyle(
      fontSize: 30.0.sp,
      height: 1.4,
      fontWeight: FontWeight.w600,
    );
    return isHighlight
        ? TextSpan(text: text, style: style.merge(TextStyle(color: ThemeColor.purple2)))
        : TextSpan(text: text, style: style);
  }

  /// Parses a string and returns a list of TypewriterText objects.
  /// Text wrapped in ${} is considered as highlighted, otherwise as regular text.
  ///
  /// Example:
  /// If input is "This is a normal text and ${this is highlighted} text.",
  /// it will return a list with "This is a normal text and " as non-highlighted
  /// and "this is highlighted" as highlighted.
  ///
  /// [input] The string to parse.
  /// Returns a List<TypewriterText> representing the parsed text.
  static List<TypewriterText> parse(String input) {
    List<TypewriterText> result = [];
    // Define a RegExp pattern to identify highlighted text (${text}) and regular text.
    final regex = RegExp(r'\$\{([^\}]+)\}|([^\$]+)');

    // Use the RegExp to find all matches within the input string.
    for (final match in regex.allMatches(input)) {
      if (match.group(1) != null) {
        // If group 1 is matched, it's a highlighted text inside ${}.
        result.add(TypewriterText(text: match.group(1)!, isHighlight: true));
      } else if (match.group(2) != null) {
        // If group 2 is matched, it's a regular text outside of ${}.
        result.add(TypewriterText(text: match.group(2)!, isHighlight: false));
      }
    }

    return result;
  }
}