import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/font_size_notifier.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/utils/text_scale_slider.dart';

class ChatSettingPage extends StatefulWidget {
  const ChatSettingPage({super.key});

  @override
  State<ChatSettingPage> createState() => _ChatSettingPageState();
}

class _ChatSettingPageState extends State<ChatSettingPage> {
  double _textScale = textScaleFactorNotifier.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        titleWidget: Text(
          Localized.text('ox_usercenter.str_settings_chat'),
          textScaler: const TextScaler.linear(1),
          style: TextStyle(
            color: ThemeColor.color0,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: ThemeColor.color190,
        actions: [
          _buildDoneButton()
        ],
      ),
      body: _buildBody().setPadding(
        EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            _buildChatWidget(
              name: 'Jack',
              content: 'Hello, 0xChat.\nHow can I set the text size?',
              picture: 'icon_chat_settings_right.png',
              isSender: false,
            ),
            SizedBox(height: 16.px),
            _buildChatWidget(
              name: '0xchat',
              content: 'Hello, Jack.\nGo to "Me - Text Size", and drag the slider below to set the text size.',
              picture: 'icon_chat_settings_left.png',
            ),
          ],
        ),
        Positioned(
          bottom: 20.px,
          left: 0.px,
          right: 0.px,
          child: TextScaleSlider(
            onChanged: (value) {
              setState(() {
                _textScale = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatWidget({
    required String name,
    required String content,
    required String picture,
    bool isSender = true,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: isSender ? TextDirection.rtl : TextDirection.ltr,
      children: [
        CommonImage(
          iconName: picture,
          width: 40.px,
          height: 40.px,
          package: 'ox_usercenter',
        ),
        SizedBox(width: 10.px),
        Expanded(
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                name,
                textScaler: TextScaler.linear(_textScale),
                style: TextStyle(
                  fontSize: 12.px,
                  color: ThemeColor.color0,
                  height: 17.px / 12.px,
                ),
              ),
              SizedBox(height: 4.px),
              Container(
                padding: EdgeInsets.all(10.px),
                decoration: BoxDecoration(
                  color: ThemeColor.color180,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isSender ? 16.px : 0),
                    topRight: Radius.circular(isSender ? 0 : 16.px),
                    bottomRight: Radius.circular(16.px),
                    bottomLeft: Radius.circular(16.px),
                  ),
                  gradient: isSender ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      ThemeColor.gradientMainEnd,
                      ThemeColor.gradientMainStart
                    ],
                  ) : null,
                ),
                child: Text(
                  content,
                  textScaler: TextScaler.linear(_textScale),
                  style: TextStyle(
                    fontSize: 14.px,
                    color: ThemeColor.color0,
                    height: 20.px / 14.px,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDoneButton() {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                ThemeColor.gradientMainEnd,
                ThemeColor.gradientMainStart,
              ],
            ).createShader(Offset.zero & bounds.size);
          },
          child: Text(
            Localized.text('ox_usercenter.str_settings_chat_set'),
            textScaler: const TextScaler.linear(1),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: (){
          textScaleFactorNotifier.value = _textScale;
          OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.APP_FONT_SIZE, _textScale);
          OXNavigator.pop(context);
        },
      ).setPaddingOnly(right: 24.px),
    );
  }
}
