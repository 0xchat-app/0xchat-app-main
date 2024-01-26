import 'package:flutter/material.dart';
// common
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/app_initialization_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';

import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';

///Title: save_account_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/4/25 14:14
class SaveAccountPage extends StatefulWidget {
  final UserDB userDB;

  SaveAccountPage({required this.userDB});

  @override
  State<StatefulWidget> createState() {
    return _SaveAccountPageState();
  }
}

enum KeyType { PublicKey, PrivateKey }

class _SaveAccountPageState extends State<SaveAccountPage>
    with SingleTickerProviderStateMixin {
  bool publicKeyCopied = false;
  bool privateKeyCopied = false;

  late final AnimationController opacityController;
  late final Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    opacityController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(opacityController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        useLargeTitle: false,
        centerTitle: true,
        title: '',
      ),
      backgroundColor: ThemeColor.color200,
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      reverse: false,
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _titleView(),
          _itemView(
            KeyType.PublicKey,
            Localized.text('ox_login.public_key'),
            "Before we get started, you need to save your account info. This is your account ID; you can give it to your friends so they can follow you. Tap to copy.",
            widget.userDB.encodedPubkey,
          ),
          AnimatedBuilder(
            animation: opacityAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: opacityAnimation.value,
                child: _itemView(
                  KeyType.PrivateKey,
                  Localized.text('ox_login.private_key'),
                  "This is your account secret key. You need this to access your account; without it, you won't be able to log in if you ever uninstall 0xchat."
                  "Don't share this with anyone! Save it in a password manager for safekeeping!",
                  widget.userDB.encodedPrivkey,
                ),
              );
            },
          ),
          _nextView(),
        ],
      ).setPadding(EdgeInsets.symmetric(
        horizontal: Adapt.px(30),
      )),
    );
  }

  Widget _titleView() {
    return Container(
      width: double.infinity,
      height: Adapt.px(100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/icon_logo_ox_login.png',
            width: Adapt.px(60),
            height: Adapt.px(60),
            fit: BoxFit.fill,
            package: 'ox_login',
          ),
          SizedBox(
            width: Adapt.px(10),
          ),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [
                  ThemeColor.gradientMainEnd,
                  ThemeColor.gradientMainStart,
                ],
              ).createShader(Offset.zero & bounds.size);
            },
            child: Text(
              Localized.text('ox_login.welcome'),
              style: TextStyle(
                fontSize: Adapt.px(32),
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _itemView(
    KeyType keyType,
    String title,
    String keyHintStr,
    String keyContent,
  ) {
    bool isPublicKeySuccess = publicKeyCopied && keyType == KeyType.PublicKey;
    bool isPrivateKeySuccess =
        privateKeyCopied && keyType == KeyType.PrivateKey;
    bool isSuccessPic = isPublicKeySuccess || isPrivateKeySuccess;
    String copyStatusIcon = isSuccessPic
        ? 'icon_copyied_success.png'
        : 'icon_copy.png';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(bottom: Adapt.px(12)),
          child: Text(
            title,
            style: TextStyle(
              fontSize: Adapt.px(16),
              color: ThemeColor.color0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: Adapt.px(12)),
          alignment: Alignment.topLeft,
          child: Text(
            keyHintStr,
            style: TextStyle(
              fontSize: Adapt.px(16),
              color: ThemeColor.color0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: ThemeColor.color190,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: Adapt.px(16), vertical: Adapt.px(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  keyContent,
                  style: TextStyle(
                      fontSize: Adapt.px(16),
                      color: ThemeColor.color40,
                      fontWeight: FontWeight.w400),
                  maxLines: null,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _clickKey(keyType),
                child: Container(
                  width: Adapt.px(48),
                  alignment: Alignment.center,
                  child: CommonImage(
                    iconName: copyStatusIcon,
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                    fit: BoxFit.fill,
                    useTheme: !isSuccessPic,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ).setPadding(EdgeInsets.only(bottom: Adapt.px(30)));
  }

  Widget _nextView() {
    return Container(
      padding: EdgeInsets.only(
        bottom: Adapt.px(30),
      ),
      child: Visibility(
        visible: publicKeyCopied && privateKeyCopied,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _login,
          child: Container(
            width: double.infinity,
            height: Adapt.px(48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ThemeColor.color180,
              gradient: LinearGradient(
                colors: [
                  ThemeColor.gradientMainEnd,
                  ThemeColor.gradientMainStart,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              Localized.text('ox_login.lets_go'),
              style: TextStyle(
                color: Colors.white,
                fontSize: Adapt.px(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    await OXUserInfoManager.sharedInstance.loginSuccess(widget.userDB);
    OXNavigator.popToRoot(context);
    AppInitializationManager.shared.showInitializationLoading();
  }

  void _clickKey(KeyType keyType) async {
    UserDB db = widget.userDB;
    String getKey =
        keyType == KeyType.PublicKey ? db.encodedPubkey : db.encodedPrivkey;

    await TookKit.copyKey(context, getKey);

    setState(() {
      if (keyType == KeyType.PublicKey && publicKeyCopied == false) {
        publicKeyCopied = true;
        _startOpacityAnimation();
      }
      if (keyType == KeyType.PrivateKey) {
        privateKeyCopied = true;
      }
    });
  }

  void _startOpacityAnimation() {
    if (opacityController.status == AnimationStatus.completed) {
      opacityController.reverse();
    } else {
      opacityController.forward();
    }
  }

}
