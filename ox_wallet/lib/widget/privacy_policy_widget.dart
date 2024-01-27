import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_webview.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  final ValueNotifier<bool> controller;
  const PrivacyPolicyWidget({super.key, required this.controller});

  final _termsOfUser = 'https://www.0xchat.com/protocols/0xchat_terms_of_use.html';
  final _privacyPolicy = 'https://www.0xchat.com/protocols/0xchat_privacy_policy.html';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: controller,
              builder: (context,value,child) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    controller.value = !value;
                  },
                  child: CommonImage(
                    iconName: value ? 'icon_item_selected.png' : 'icon_item_unselected.png',
                    size: 20.px,
                    package: 'ox_wallet',
                    useTheme: true,
                  ),
                );
              }
          ),
          SizedBox(width: Adapt.px(8)),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 14.px,
              fontWeight: FontWeight.w500,
              height: 20.px / 14.px,
              color: ThemeColor.color0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('By add your mint you accept the'),
                FittedBox(
                  child: Row(
                    children: [
                      _highlightText(text: 'Terms of Use', onTap: () => _openLinkURL(context, url: _termsOfUser, title: 'Terms of Use')),
                      const Text(' and '),
                      _highlightText(text: 'Privacy Policy', onTap: () => _openLinkURL(context, url: _privacyPolicy, title: 'Privacy Policy')),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _highlightText({required String text, Function()? onTap}){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [ThemeColor.gradientMainEnd, ThemeColor.gradientMainStart,],
          ).createShader(Offset.zero & bounds.size);
        },
        child: Text(text),
      ),
    );
  }

  void _openLinkURL(BuildContext context, {required String url, required String title}) {
    OXNavigator.presentPage(context, (context) => CommonWebView(url, title: title,),);
  }
}
