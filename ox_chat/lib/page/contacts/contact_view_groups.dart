import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/widget/contact_group.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';

class ContactViewGroups extends StatefulWidget {
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Widget? topWidget;
  ContactViewGroups({Key? key, this.shrinkWrap = false, this.physics, this.topWidget}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ContactViewGroupsState();
  }
}

class _ContactViewGroupsState extends State<ContactViewGroups> with SingleTickerProviderStateMixin,
    AutomaticKeepAliveClientMixin, WidgetsBindingObserver, CommonStateViewMixin, OXChatObserver, OXUserInfoObserver {
  List<GroupUIModel> groups = [];
  RefreshController _refreshController = RefreshController();
  GlobalKey<GroupContactState> groupsWidgetKey = new GlobalKey<GroupContactState>();
  num imageV = 0;

  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    WidgetsBinding.instance.addObserver(this);
    _onRefresh();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return commonStateViewWidget(
      context,
      GroupContact(
        key: groupsWidgetKey,
        data: groups,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        topWidget: widget.topWidget,
      ),
    );
  }

  void _loadData() {
    groups.clear();
    if(Groups.sharedInstance.myGroups.length>0) {
      List<GroupDB> tempGroups = Groups.sharedInstance.myGroups.values.toList();
      tempGroups.forEach((element) {
        GroupUIModel tempUIModel= GroupUIModel.groupdbToUIModel(element);
        groups.add(tempUIModel);
      });
    }
    if(RelayGroup.sharedInstance.myGroups.length>0) {
      List<RelayGroupDB> tempRelayGroups = RelayGroup.sharedInstance.myGroups.values.toList();
      tempRelayGroups.forEach((element) {
        GroupUIModel uIModel= GroupUIModel.relayGroupdbToUIModel(element);
        groups.add(uIModel);
      });
    }
    _showView();
  }

  void _showView() {
    if (this.mounted) {
      groupsWidgetKey.currentState?.updateContactData(groups);
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
    imageV++;
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (isLogin == false) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_NotLogin);
      });
    } else {
      setState(() {
        _loadData();
      });
    }
    _refreshController.refreshCompleted();
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    LogUtil.e('Topic List didLoginStateChanged : $userInfo');
    setState(() {
      groups.clear();
      _onRefresh();
    });
  }

  @override
  void didLogout() {
    setState(() {
      groups.clear();
      _onRefresh();
    });
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    _onRefresh();
  }

  @override
  void didGroupsUpdatedCallBack() {
    LogUtil.e('Michael: ----didGroupsUpdatedCallBack----------');
    _loadData();
  }

  @override
  void didRelayGroupsUpdatedCallBack() {
    LogUtil.e('Michael: ----didRelayGroupsUpdatedCallBack----------');
    _loadData();
  }
}
