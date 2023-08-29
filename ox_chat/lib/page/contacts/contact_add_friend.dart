import 'dart:convert' as convert;

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_user_info_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_search_textfield.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

class CommunityContactAddFriend extends StatefulWidget {
  @override
  _CommunityContactAddFriendState createState() => new _CommunityContactAddFriendState();
}

class _CommunityContactAddFriendState extends State<CommunityContactAddFriend> with CommonStateViewMixin {
  FocusNode _searchNode = FocusNode();
  bool _isPhone = false;
  String countryAreaCode = '+86';
  String countryIcon = "";
  GlobalKey<CountryWidgetState> countryKey = GlobalKey();
  bool _isPreventUserClicks = false; // Control the status of the loading indicator and user interaction

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_searchNode); // Auto-focus
    });
  }

  @override
  void dispose() {
    _searchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isPreventUserClicks,
      child: Scaffold(
        backgroundColor: ThemeColor.color200,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kMinInteractiveDimension),
          child: Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(_searchNode);
              },
              child: _searchWidget(),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: commonStateViewWidget(
              context,
              Container(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchWidget() {
    return CommonSearchTextField(
      textFieldEnable: !_isPreventUserClicks,
      leftWidget: assetIcon(
        'icon_chat_search.png',
        24,
        24,
      ),
      contentBgColor: ThemeColor.color190,
      focusNode: _searchNode,
      hintText: Localized.text('ox_chat.please_enter_user_address'),
      isShowDeleteBtn: true,
      isDense: true,
      maxLength: 100,
      inputCallBack: _inputSearchCall,
      // leftWidget: CountryTextWidget(_isPhone, countryAreaCode, _selectCountryCode, countryKey),
      rightWidget: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        radius: 0.0,
        child: Container(
          width: Adapt.px(58),
          height: Adapt.px(44),
          child: Center(
            child: Text(
              Localized.text('ox_login.cancel'),
              style: TextStyle(fontSize: Adapt.px(14), color: ThemeColor.gray02, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        onTap: () {
          OXNavigator.pop(context);
        },
      ),
      onSubmitted: _editCompletion,
    );
  }

  void _selectCountryCode() async {
    final Map map = await OXModuleService.pushPage(context, "ox_login", "CountryChoice", {});
    if (map.containsKey('code') && this.mounted) {
      countryAreaCode = map['code'];
      countryIcon = map['icon'];
      if (countryKey.currentState != null) {
        countryKey.currentState!.onPressed(_isPhone, countryAreaCode, countryIcon);
      }
    }
    // FocusScope.of(context).requestFocus(_searchNode);
  }

  void _inputSearchCall(String value) {
    _isPhone = RegExp(r"^[0-9]+$").hasMatch(value);
    if (countryKey.currentState != null) {
      countryKey.currentState?.onPressed(_isPhone, countryAreaCode, countryIcon);
    }
  }

  void _editCompletion(String value) async {
    if (value.length > 0) {
      updateStateView(CommonStateView.CommonStateView_None);
      await OXLoading.show();
      _isPreventUserClicks = true;// Prevent user clicks"
      String? info;
      if (value.startsWith('npub')) {
        info = UserDB.decodePubkey(value);
      } else if (value.contains('@')) {
        info = await Account.getDNSPubkey(value.substring(0, value.indexOf('@')), value.substring(value.indexOf('@') + 1));
      }
      if (info == null) {
        await OXLoading.dismiss();
        _isPreventUserClicks = false;
        CommonToast.instance.show(context, 'User not found, please re-enter.');
        return;
      }
      var usersMap = await Account.syncProfilesFromRelay([info!]);
      UserDB? user = usersMap[info];
      await OXLoading.dismiss();
      _isPreventUserClicks = false;
      if (user == null) {
        updateStateView(CommonStateView.CommonStateView_NetworkError);
      } else if (info == '') {
        updateStateView(CommonStateView.CommonStateView_NoData);
      } else {
        if (user.pubKey != null) {
          OXNavigator.pushPage(
            context,
            (context) => ContactUserInfoPage(
              userDB: user,
            ),
          );
        }
      }
      if (this.mounted) {
        setState(() {});
      }
    } else {
      CommonToast.instance.show(
        context,
        Localized.text('ox_chat.please_enter_user_address'),
      );
    }
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
        _editCompletion('');
        break;
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  renderNoDataView(BuildContext context, {String? errorTip}) {
    // TODO: implement renderNoDataView
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(123)),
      child: Column(
        children: <Widget>[
          assetIcon(
            'icon_search_user_no.png',
            110,
            110,
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20)),
            child: MyText(
              Localized.text('ox_chat.no_related_users_were_found'),
              14,
              ThemeColor.gray02,
            ),
          ),
        ],
      ),
    );
  }
}

typedef CountrySelectCallBack = void Function();

class CountryTextWidget extends StatefulWidget {
  bool isPhone;
  String countryAreaCode = '+86';
  String countryIcon = '';
  final CountrySelectCallBack selectCallBack;

  CountryTextWidget(this.isPhone, this.countryAreaCode, this.selectCallBack, Key key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CountryWidgetState();
  }
}

class CountryWidgetState extends State<CountryTextWidget> {
  @override
  Widget build(BuildContext context) {
    return !widget.isPhone
        ? Container(
            // margin: EdgeInsets.only(left: Adapt.px(15), right: Adapt.px(8)),
            child: assetIcon(
              'icon_chat_search.png',
              20,
              22,
            ),
          )
        : GestureDetector(
            onTap: widget.selectCallBack,
            child: Container(
              color: ThemeColor.gray5,
              margin: EdgeInsets.only(top: Adapt.px(6), bottom: Adapt.px(6)),
              child: Row(
                children: <Widget>[
                  Text(
                    widget.countryAreaCode,
                    style: TextStyle(
                      fontSize: Adapt.px(16),
                      color: ThemeColor.white02,
                    ),
                  ),
                  assetIcon(
                    'icon_arrow_down.png',
                    22,
                    22,
                  ),
                  Container(
                    height: Adapt.px(12),
                    width: Adapt.px(1),
                    margin: EdgeInsets.only(left: Adapt.px(6), right: Adapt.px(14)),
                    color: ThemeColor.dark06,
                  ),
                ],
              ),
            ),
          );
  }

  void onPressed(bool isPhone, String countryAreaCode, String countryIcon) {
    setState(() {
      widget.isPhone = isPhone;
      widget.countryAreaCode = countryAreaCode;
      widget.countryIcon = countryIcon;
    });
  }
}
