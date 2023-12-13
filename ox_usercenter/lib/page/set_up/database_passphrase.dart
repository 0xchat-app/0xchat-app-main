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
  bool _currentEyeOpen = true;
  bool _newEyeOpen = true;
  bool _confirmEyeOpen = true;

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
          _customTextField(
            controller: _currentTeController,
            focusNode: _currentFocusNode,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
          ),
          // CommonTextField(
          //   controller: _currentTeController,
          //   type: TextFieldType.normal,
          //   keyboardType: TextInputType.text,
          //   inputFormatters: [LengthLimitingTextInputFormatter(30)],
          //   focusNode: _currentFocusNode,
          //   hintText: 'str_current_passphrase'.localized(),
          //   leftWidget: CommonImage(
          //     iconName: _currentEyeOpen ? 'icon_obscure_close.png' : 'icon_obscure.png',
          //     width: 24.px,
          //     height: 24.px,
          //   ),
          // ),
          CommonTextField(
            controller: _newTeController,
            type: TextFieldType.normal,
            keyboardType: TextInputType.text,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            focusNode: _newFocusNode,
            decoration: InputDecoration(
              hintText: 'str_new_passphrase'.localized(),
              contentPadding: EdgeInsets.only(left: 8.px),
              prefixIcon: CommonImage(
                iconName: _newEyeOpen ? 'icon_obscure_close.png' : 'icon_obscure.png',
                width: 12.px,
                height: 12.px,
              ),
              border: InputBorder.none,
            ),
          ),
          CommonTextField(
            controller: _confirmTeController,
            type: TextFieldType.normal,
            keyboardType: TextInputType.text,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            focusNode: _confirmFocusNode,
            decoration: InputDecoration(
              hintText: 'str_confirm_new_passphrase'.localized(),
              prefixIcon:  ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 24.px,
                  minHeight: 24.px,
                  maxWidth: 24.px,
                  maxHeight: 24.px,
                ),
                child: CommonImage(
                  iconName: _confirmEyeOpen ? 'icon_obscure_close.png' : 'icon_obscure.png',
                  width: 12.px,
                  height: 12.px,
                ),
              ),
              border: InputBorder.none,
            ),
          ),
          DatabaseItemWidget(
            title: 'str_update_database_passphrase',
            radiusCornerList: [16.px, 16.px, 16.px, 16.px],
            iconRightMargin: 0,
            iconName: 'icon_update.png',
            iconPackage: 'ox_common',
            onTapCall: () {},
          ),
          SizedBox(height: 12.px),
          abbrText(_isSavePhrase ? 'str_passphrase_hint1'.localized() : 'str_passphrase_hint2'.localized(), 12, ThemeColor.color100),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px)),
    );
  }

  bool _obscureText = false;
  Widget _customTextField({TextEditingController? controller,FocusNode? focusNode,List<TextInputFormatter>? inputFormatters }){
    return TextField(
        autofocus: false,
        style: Styles.textFieldStyles(),
        controller: controller,
        obscureText: _obscureText,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          hintText: 'str_confirm_new_passphrase'.localized(),

          prefixIcon: CommonImage(
            iconName: _confirmEyeOpen ? 'icon_obscure_close.png' : 'icon_obscure.png',
            width: 24.px,
            height: 24.px,
          ),
          border: InputBorder.none,
        ),
        focusNode: focusNode,
        inputFormatters: inputFormatters,
        cursorColor: ThemeColor.red);
  }
}
