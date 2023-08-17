import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';

///Title: keys_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/9 09:52
class KeysPage extends StatefulWidget{

  KeysPage();

  @override
  State<StatefulWidget> createState() {
    return _KeysPageState();
  }

}
enum KeyType { PublicKey, PrivateKey }
class _KeysPageState extends State<KeysPage>{
  bool _publicKeyCopyied = false;
  bool _privateKeyCopyied = false;
  bool _isShowPrivkey = true;
  late UserDB userDB;
  TextEditingController _pubTextEditingController = TextEditingController();
  TextEditingController _privTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userDB = OXUserInfoManager.sharedInstance.currentUserInfo!;
    _pubTextEditingController.text = userDB.encodedPubkey ?? '';
    _privTextEditingController.text = userDB.encodedPrivkey ?? '';
    initData();
  }

  void initData() async {
    bool isShowPrivkey = await getShowPrivkeyFlag();
    setState(() {
      _isShowPrivkey = isShowPrivkey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: 'Keys',
        centerTitle: true,
        useLargeTitle: false,
        titleTextColor: ThemeColor.color0,
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return Container(
      margin: EdgeInsets.all(Adapt.px(24)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _itemView(
            KeyType.PublicKey,
            Localized.text('ox_login.public_key'),
            _pubTextEditingController,
            false,
          ),
          _itemView(
            KeyType.PrivateKey,
            Localized.text('ox_login.private_key'),
            _privTextEditingController,
            true,
          ),
        ],
      ),
    );
  }

  Future<void> _changeShowPrivkeyFn(bool value) async {
    LogUtil.e('Michael： value =${value}');

    setState(() {
      _isShowPrivkey = value;
    });
    await saveShowPrivkeyFlag(value);
  }

  Widget _itemView(KeyType keyType, String title, TextEditingController _textEditingController, bool isShowSwitch) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: Adapt.px(16),
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Visibility(
              visible: isShowSwitch,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Text(
                      'Show',
                      style: TextStyle(
                        fontSize: Adapt.px(14),
                        color: ThemeColor.color100,
                      ),
                    ),
                  ),
                  SizedBox(width: Adapt.px(4),),
                  Switch(
                    value: _isShowPrivkey,
                    activeColor: Colors.white,
                    activeTrackColor: ThemeColor.gradientMainStart,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: ThemeColor.color160,
                    onChanged: (value) => _changeShowPrivkeyFn(value),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height:  Adapt.px(12),),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: ThemeColor.color180,
          ),
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(16), vertical: Adapt.px(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: Adapt.px(100),
                  child: TextField(
                    readOnly: true,
                    obscureText: keyType == KeyType.PublicKey || (keyType == KeyType.PrivateKey && _isShowPrivkey)? false: true,
                    decoration: InputDecoration(
                      hintText: '',
                      isCollapsed: true,
                      hintStyle: TextStyle(
                        color: ThemeColor.color100,
                      ),
                      border: InputBorder.none,
                    ),
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: ThemeColor.color40),
                    maxLines: keyType == KeyType.PublicKey || (keyType == KeyType.PrivateKey && _isShowPrivkey)? null: 1,
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  if (keyType == KeyType.PublicKey) {
                    await TookKit.copyKey(context, userDB.encodedPubkey);
                    _publicKeyCopyied = true;
                  } else if (keyType == KeyType.PrivateKey) {
                    await TookKit.copyKey(context, userDB.encodedPrivkey);
                    _privateKeyCopyied = true;
                  }
                  setState(() {
                  });
                },
                child: Container(
                  width: Adapt.px(48),
                  alignment: Alignment.center,
                  child: CommonImage(
                    iconName: ((keyType == KeyType.PublicKey && _publicKeyCopyied) || (keyType == KeyType.PrivateKey && _privateKeyCopyied))
                        ? 'icon_copyied_success.png'
                        : 'icon_copy.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ).setPadding(EdgeInsets.only(bottom: Adapt.px(30)));
  }

  Future<void> saveShowPrivkeyFlag(bool isShowPrivkey) async {
    try {
      await OXCacheManager.defaultOXCacheManager.saveForeverData('isShowPrivkey', isShowPrivkey);
    } catch (e) {
      LogUtil.e("save flag fail!");
    }
  }

  Future<bool> getShowPrivkeyFlag() async {
    bool isShowPrivkey;
    try {
      isShowPrivkey = await OXCacheManager.defaultOXCacheManager.getForeverData('isShowPrivkey');
    } catch (e) {
      isShowPrivkey = false;
      LogUtil.e("get flag fail!");
    }
    return isShowPrivkey;
  }
}