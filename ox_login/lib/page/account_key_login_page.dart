import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';

// common
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/user_config_tool.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/utils/app_relay_hint_dialog.dart';

// component
import '../component/common_input.dart';
import '../component/input_wrap.dart';
import '../component/lose_focus_wrap.dart';

// plugin
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

///Title: account_key_login_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/4/25 15:49
class AccountKeyLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountKeyLoginPageState();
  }
}

class _AccountKeyLoginPageState extends State<AccountKeyLoginPage> {
  TextEditingController _accountKeyEditingController = new TextEditingController();
  bool _isShowLoginBtn = false;
  String _accountKeyInput = '';

  @override
  void initState() {
    super.initState();
    _accountKeyEditingController.addListener(_checkAccountKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '',
        centerTitle: true,
        useLargeTitle: false,
        backgroundColor: ThemeColor.color200,
      ),
      backgroundColor: ThemeColor.color200,
      body: LoseFocusWrap(_body()),
    );
  }

  Widget _body() {
    String inputStr = _accountKeyEditingController.text;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _titleView(),
        InputWrap(
          title: Localized.text('ox_login.enter_account_key_login_hint'),
          contentWidget: CommonInput(
            hintText: 'nsec or bunker:// ',
            textController: _accountKeyEditingController,
            maxLines: null,
            inputAction: TextInputAction.done,
            onSubmitted: (value) {
              _checkAccountKey();
              if (_accountKeyInput.isNotEmpty) {
                _nescLogin();
              }
            },
          ),
        ),
        Visibility(
          visible: !_isShowLoginBtn && inputStr.trim().startsWith('nsec') && inputStr.length >= 63,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              Localized.text('ox_login.str_nesc_invalid_hint'),
              style: TextStyle(color: ThemeColor.red, fontSize: 12.sp),
            ),
          ),
        ),
        Visibility(
          visible: _isShowLoginBtn,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _nescLogin,
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
                Localized.text('ox_login.login_title'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Adapt.px(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(30)));
  }

  Widget _titleView() {
    return Container(
      width: double.infinity,
      height: Adapt.px(100),
      alignment: Alignment.center,
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
          Localized.text('ox_login.login_title'),
          style: TextStyle(
            fontSize: Adapt.px(32),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _checkAccountKey() {
    String textContent = _accountKeyEditingController.text.trim();
    if (textContent.startsWith('bunker://')){
      _isShowLoginBtn = true;
      _accountKeyInput = textContent;
    } else {
      if (textContent.length >= 63) {
        final String? decodeResult = UserDBISAR.decodePrivkey(textContent);
        if (decodeResult == null || decodeResult.isEmpty) {
          _isShowLoginBtn = false;
        } else {
          _accountKeyInput = decodeResult;
          _isShowLoginBtn = true;
        }
      } else {
        _isShowLoginBtn = false;
      }
    }
    setState(() {});
  }

  void _nescLogin() async {
    await OXLoading.show();
    String pubkey = "";
    UserDBISAR? userDB;
    String currentUserPubKey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    if (_accountKeyInput.startsWith('bunker://')){
      pubkey = await Account.getPublicKeyWithNIP46URI(_accountKeyInput);
      await OXUserInfoManager.sharedInstance.initDB(pubkey);
      userDB = await Account.sharedInstance.loginWithNip46URI(_accountKeyInput);
    } else {
      pubkey = Account.getPublicKey(_accountKeyInput);
      await OXUserInfoManager.sharedInstance.initDB(pubkey);
      userDB = await Account.sharedInstance.loginWithPriKey(_accountKeyInput);
    }
    userDB = await OXUserInfoManager.sharedInstance.handleSwitchFailures(userDB, currentUserPubKey);
    if (userDB == null) {
      CommonToast.instance.show(context, Localized.text('ox_login.private_key_regular_failed'));
      return;
    }
    Account.sharedInstance.reloadProfileFromRelay(userDB.pubKey).then((value) {
      LogUtil.e('Michael:---reloadProfileFromRelay--name = ${value.name}; pic =${value.picture}}');
      UserConfigTool.saveUser(value);
      UserConfigTool.updateSettingFromDB(value.settings);
    });
    OXUserInfoManager.sharedInstance.loginSuccess(userDB);
    await OXLoading.dismiss();
    OXNavigator.popToRoot(context);
  }
}
