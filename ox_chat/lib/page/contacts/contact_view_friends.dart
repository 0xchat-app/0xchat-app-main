import 'package:chatcore/chat-core.dart';
import 'package:flutter/widgets.dart';
import 'package:ox_chat/page/contacts/contacts_page.dart';
import 'package:ox_chat/widget/contact.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

/// Contact - Friends List
const String systemUserType = "10000";



class ContractViewFriends extends StatefulWidget {
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Widget? topWidget;
  final ScrollToTopStatus? scrollToTopStatus;
  final Color? bgColor;
  ContractViewFriends({Key? key, this.shrinkWrap = false, this.physics, this.topWidget, this.scrollToTopStatus, this.bgColor}): super(key: key);

  @override
  _ContractViewFriendsState createState() => _ContractViewFriendsState();
}

class _ContractViewFriendsState extends State<ContractViewFriends>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin,
        CommonStateViewMixin, OXUserInfoObserver , OXChatObserver{
  List<UserDBISAR> userList = [];

  GlobalKey<ContactWidgetState> contractWidgetKey = new GlobalKey<ContactWidgetState>();


  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    _getDefaultData();
    _onRefresh();
    widget.scrollToTopStatus?.isScrolledToTop.addListener(_scrollToTop);
  }

  @override
  void dispose() {
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
    super.dispose();
    widget.scrollToTopStatus?.isScrolledToTop.removeListener(_scrollToTop);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return commonStateViewWidget(
        context,
        ContactWidget(
          key: contractWidgetKey,
          data: userList,
          shrinkWrap: widget.shrinkWrap,
          physics: widget.physics,
          topWidget: widget.topWidget,
          bgColor: widget.bgColor,
          supportLongPress: true,
        ),
    );
  }

  void _getDefaultData() async {
  }

  void _loadData() {
    Iterable<UserDBISAR> tempList =  Contacts.sharedInstance.allContacts.values;
    userList.clear();
    if (tempList.isNotEmpty) userList.addAll(tempList);
    _showView();
  }

  void _showView() {
    if (this.mounted) {
      contractWidgetKey.currentState?.updateContactData(userList);
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
      });
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

  _scrollToTop() async {
    bool isScrollToTop = widget.scrollToTopStatus?.isScrolledToTop.value ?? false;
    if (isScrollToTop) {
      await contractWidgetKey.currentState?.scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      widget.scrollToTopStatus?.isScrolledToTop.value = false;
    }
  }

  @override
  bool get wantKeepAlive => true;


  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
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
  void didSwitchUser(UserDBISAR? userInfo) {
    LogUtil.e('Michael: contact_view_friends didAccountChanged');
    setState(() {
      userList.clear();
      _onRefresh();
    });
  }

  @override
  void didContactUpdatedCallBack() {
    LogUtil.e('Michael: contact_view_friends didFriendUpdatedCallBack friends.length=${Contacts.sharedInstance.allContacts.length}');
    _loadData();
  }
}
