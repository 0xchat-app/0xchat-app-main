import 'package:chatcore/chat-core.dart';
import 'package:flutter/widgets.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/contract.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/mixin/common_ui_refresh_mixin.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_localizable/ox_localizable.dart';

/// Contact - Friends List
const String systemUserType = "10000";

class ContractViewFriends extends StatefulWidget {
  final bool shrinkWrap;
  ScrollPhysics? physics;
  ContractViewFriends({Key? key, this.shrinkWrap = false, this.physics}): super(key: key);

  @override
  _ContractViewFriendsState createState() => _ContractViewFriendsState();
}

class _ContractViewFriendsState extends State<ContractViewFriends>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin,
        CommonStateViewMixin, OXUserInfoObserver , OXChatObserver{
  List<UserDB> userList = [];

  GlobalKey<ContractWidgetState> contractWidgetKey = new GlobalKey<ContractWidgetState>();


  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    _getDefaultData();
    _onRefresh();
  }

  @override
  void dispose() {
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return commonStateViewWidget(
        context,
        VisibilityDetector(
          key: const Key('friend_list'),
          onVisibilityChanged: (VisibilityInfo visibilityInfo) {
            if (visibilityInfo.visibleFraction == 0.0) {
            } else {
              _loadData();
            }
          },
          child: ContractWidget(
            key: contractWidgetKey,
            data: userList,
            shrinkWrap: widget.shrinkWrap,
            physics: widget.physics,
          ),
        )
    );
  }

  void _getDefaultData() async {
  }

  void _loadData() {
    Iterable<UserDB> tempList =  Contacts.sharedInstance.allContacts.values;
    userList.clear();
    tempList.forEach (( value) {
      userList.add(value);
    });
    _showView();
  }

  void _showView() {
    if (this.mounted) {
      contractWidgetKey.currentState?.updateContactData(userList);
      if (userList.length == 0) {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_NoData);
        });
      } else {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_None);
        });
      }
    }
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
      case CommonStateView.CommonStateView_NoData:
        _onRefresh();
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  void _onRefresh() async {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (isLogin == false) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_NotLogin);
      });
    } else {
      _loadData();
    }
  }

  // @override
  // renderNoDataView() => _emptyWidget();

  Widget _emptyWidget() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 87.0),
      child: Column(
        children: <Widget>[
          assetIcon(
            'icon_search_user_no.png',
            110.0,
            110.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: MyText(
              Localized.text('ox_chat.no_contacts_added'),
              14,
              ThemeColor.gray02,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;


  @override
  void didLoginSuccess(UserDB? userInfo) {
    LogUtil.e('Michael: contact_view_friends didLoginSuccess: $userInfo');
    setState(() {
      userList.clear();
      _onRefresh();
    });
  }

  @override
  void didLogout() {
    LogUtil.e('Michael: contact_view_friends didLoginStateChanged');
    setState(() {
      userList.clear();
      _onRefresh();
    });
  }

  @override
  void didSwitchUser(UserDB? userInfo) {
    LogUtil.e('Michael: contact_view_friends didAccountChanged');
    _onRefresh();
  }

  @override
  void didContactUpdatedCallBack() {
    LogUtil.e('Michael: contact_view_friends didFriendUpdatedCallBack friends.length=${Contacts.sharedInstance.allContacts.length}');
    _loadData();
  }
}
