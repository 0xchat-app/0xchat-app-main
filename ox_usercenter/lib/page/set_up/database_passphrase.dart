import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_textfield.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';
import 'package:ox_usercenter/widget/database_item_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  bool _isSavePhrase = true;
  TextEditingController _currentTeController = TextEditingController();
  TextEditingController _newTeController = TextEditingController();
  TextEditingController _confirmTeController = TextEditingController();
  FocusNode _currentFocusNode = FocusNode();
  FocusNode _newFocusNode = FocusNode();
  FocusNode _confirmFocusNode = FocusNode();
  bool _currentEyeStatus = true;
  bool _newEyeStatus = true;
  bool _confirmEyeStatus = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _isSavePhrase = await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_SAVE_PASSPHRASE_IN_KEYCHAIN, defaultValue: true);
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
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          DatabaseItemWidget(
            height: 48.px,
            title: 'str_save_passphrase_in_keychain',
            radiusCornerList: [16.px, 16.px, 16.px, 16.px],
            iconRightMargin: 0,
            showSwitch: true,
            switchValue: _isSavePhrase,
            onTapCall: () {},
            onChanged: (bool value) async {
              await OXLoading.show();
              if (value != _isSavePhrase) {
                _isSavePhrase = value;
                await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_SAVE_PASSPHRASE_IN_KEYCHAIN, _isSavePhrase);
              }
              await OXLoading.dismiss();
              setState(() {});
            },
          ),
          CommonTextField(
            controller: _currentTeController,
            type: TextFieldType.normal,
            keyboardType: TextInputType.text,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            focusNode: _currentFocusNode,
            decoration: _getInputDecoration('str_current_passphrase'.localized()),
            leftWidget: _getLeftWidget(_currentEyeStatus),
          ),
          CommonTextField(
            controller: _newTeController,
            type: TextFieldType.normal,
            keyboardType: TextInputType.text,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            focusNode: _newFocusNode,
            decoration: _getInputDecoration('str_new_passphrase'.localized()),
            leftWidget: _getLeftWidget(_newEyeStatus),
          ),
          CommonTextField(
            controller: _confirmTeController,
            type: TextFieldType.normal,
            keyboardType: TextInputType.text,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            focusNode: _confirmFocusNode,
            decoration: _getInputDecoration('str_confirm_new_passphrase'.localized()),
            leftWidget: _getLeftWidget(_confirmEyeStatus),
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
            onTapCall: () {},
          ),
          SizedBox(height: 12.px),
          abbrText(_isSavePhrase ? 'str_passphrase_hint1'.localized() : 'str_passphrase_hint2'.localized(), 12, ThemeColor.color100),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px)),
    );
  }
  InputDecoration _getInputDecoration(String hint){
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

  Widget _getLeftWidget(bool eysStatus){
    return Container(
      margin: EdgeInsets.only(left: 16.px),
      child: CommonImage(
        iconName: eysStatus ? 'icon_obscure_close.png' : 'icon_obscure.png',
        width: 24.px,
        height: 24.px,
      ),
    );
  }
}
