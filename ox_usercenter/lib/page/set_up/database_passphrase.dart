import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_textfield.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_usercenter/model/database_set_model.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
import 'package:ox_usercenter/widget/database_item_widget.dart';

///Title: database_passphrase
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/12/13 14:47
class DatabasePassphrase extends StatefulWidget {
  const DatabasePassphrase({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DatabasePassphraseState();
  }
}

class DatabasePassphraseState extends State<DatabasePassphrase> {
  TextEditingController _currentTeController = TextEditingController();
  TextEditingController _newTeController = TextEditingController();
  TextEditingController _confirmTeController = TextEditingController();
  FocusNode _currentFocusNode = FocusNode();
  FocusNode _newFocusNode = FocusNode();
  FocusNode _confirmFocusNode = FocusNode();
  bool _isOriginalPw = true;
  bool _currentEyeStatus = true;
  bool _newEyeStatus = true;
  bool _confirmEyeStatus = true;
  String pubkey = '';
  String currentDBPW = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    pubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    _isOriginalPw = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_IS_ORIGINAL_PASSPHRASE, defaultValue: true);
    currentDBPW = await OXCacheManager.defaultOXCacheManager.getForeverData('dbpw+$pubkey', defaultValue: '');
    if (_isOriginalPw) {
      _currentTeController.text = currentDBPW;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        centerTitle: true,
        useLargeTitle: false,
        title: 'str_database_passphrase'.localized(),
      ),
      backgroundColor: ThemeColor.color190,
      body: _body(),
    );
  }

  Widget _body() {
    LogUtil.e('Michael: _body--- _newEyeStatus=$_newEyeStatus; _confirmEyeStatus =$_confirmEyeStatus');
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          CommonTextField(
            controller: _currentTeController,
            inputEnabled: !_isOriginalPw,
            type: TextFieldType.normal,
            keyboardType: TextInputType.visiblePassword,
            needTopView: true,
            title: 'Current Passphrase',
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            focusNode: _currentFocusNode,
            decoration: _getInputDecoration('str_current_passphrase'.localized()),
            leftWidget: _isOriginalPw ? SizedBox() : _getLeftWidget(_currentEyeStatus, PassphraseEyeType.currentPassphrase),
          ),
          CommonTextField(
            controller: _newTeController,
            type: TextFieldType.normal,
            keyboardType: TextInputType.visiblePassword,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            focusNode: _newFocusNode,
            decoration: _getInputDecoration('str_new_passphrase'.localized()),
            leftWidget: _getLeftWidget(_newEyeStatus, PassphraseEyeType.newPassphrase),
            obscureText: _newEyeStatus,
          ),
          CommonTextField(
            controller: _confirmTeController,
            type: TextFieldType.normal,
            keyboardType: TextInputType.visiblePassword,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            focusNode: _confirmFocusNode,
            decoration: _getInputDecoration('str_confirm_new_passphrase'.localized()),
            leftWidget: _getLeftWidget(_confirmEyeStatus, PassphraseEyeType.confirmPassPhrase),
            obscureText: _newEyeStatus,
          ),
          SizedBox(height: 12.px),
          DatabaseItemWidget(
            height: 48.px,
            title: 'str_update_database_passphrase',
            titleTxtColor: ThemeColor.color100,
            radiusCornerList: [16.px, 16.px, 16.px, 16.px],
            iconRightMargin: 8,
            iconName: 'icon_update.png',
            iconSize: 24.px,
            iconPackage: 'ox_common',
            onTapCall: _clickUpdatePassphrase,
          ),
          SizedBox(height: 12.px),
          abbrText('str_passphrase_hint'.localized(), 12, ThemeColor.color100),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px)),
    );
  }

  InputDecoration _getInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 16.px,
        color: ThemeColor.color100,
      ),
      contentPadding: EdgeInsets.only(left: 8.px),
      border: InputBorder.none,
    );
  }

  Widget _getLeftWidget(bool eysStatus, PassphraseEyeType eyeType) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        switch (eyeType) {
          case PassphraseEyeType.currentPassphrase:
            _currentEyeStatus = !_currentEyeStatus;
            break;
          case PassphraseEyeType.newPassphrase:
            _newEyeStatus = !_newEyeStatus;
            break;
          case PassphraseEyeType.confirmPassPhrase:
            _confirmEyeStatus = !_confirmEyeStatus;
            break;
        }
        LogUtil.e('Michael: onTap--- _newEyeStatus=$_newEyeStatus; _confirmEyeStatus =$_confirmEyeStatus');
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(left: 16.px),
        child: CommonImage(
          iconName: eysStatus ? 'icon_obscure.png' : 'icon_obscure_close.png',
          width: 24.px,
          height: 24.px,
        ),
      ),
    );
  }

  void _clickUpdatePassphrase() {
    String currentPW = _currentTeController.text.isEmpty ? '' : _currentTeController.text;
    String newPW = _newTeController.text.isEmpty ? '' : _newTeController.text;
    String confirmPW = _confirmTeController.text.isEmpty ? '' : _confirmTeController.text;
    if (!_isOriginalPw && currentDBPW != currentDBPW) {
      CommonToast.instance.show(context, 'str_passphrase_current_error'.localized());
      return;
    }
    if ((!_isOriginalPw && currentPW.length < 8) || newPW.length < 8 || confirmPW.length < 8) {
      CommonToast.instance.show(context, 'str_passphrase_invalidate_tips'.localized());
      return;
    }
    if (newPW != confirmPW) {
      CommonToast.instance.show(context, 'str_input_confirm_error'.localized());
      return;
    }
    keychainWrite(confirmPW);
  }

  void keychainWrite(String value) async {
    await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_IS_ORIGINAL_PASSPHRASE, false);
    await OXCacheManager.defaultOXCacheManager.saveForeverData('dbpw+$pubkey', value);
    LogUtil.e('Michael: -keychainWrite---passphrase =${value}');
  }
}
