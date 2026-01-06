import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/page/contacts/contacts_page.dart';
import 'package:ox_chat/widget/contact_group.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class ContactViewGroups extends StatefulWidget {
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Widget? appBar;
  final Widget? topWidget;
  final ScrollToTopStatus? scrollToTopStatus;
  ContactViewGroups({Key? key, this.shrinkWrap = false, this.physics, this.appBar, this.topWidget, this.scrollToTopStatus}): super(key: key);

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
  bool hasVibrator = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXChatBinding.sharedInstance.addObserver(this);
    WidgetsBinding.instance.addObserver(this);
    _onRefresh();
    widget.scrollToTopStatus?.isScrolledToTop.addListener(_scrollToTop);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXChatBinding.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    widget.scrollToTopStatus?.isScrolledToTop.removeListener(_scrollToTop);
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
        appBar: widget.appBar,
        topWidget: widget.topWidget,
        supportLongPress: true,
      ),
    );
  }

  void _loadData() {
    groups.clear();
    Map<String, ValueNotifier<GroupDBISAR>> privateGroupMap = Groups.sharedInstance.myGroups;
    if(privateGroupMap.length>0) {
      List<GroupDBISAR> tempGroups = privateGroupMap.values.map((e) => e.value).toList();
      tempGroups.forEach((element) {
        GroupUIModel tempUIModel= GroupUIModel.groupdbToUIModel(element);
        groups.add(tempUIModel);
      });
    }
    Map<String, ValueNotifier<RelayGroupDBISAR>> relayGroupMap = RelayGroup.sharedInstance.myGroups;
    if(relayGroupMap.length>0) {
      List<RelayGroupDBISAR> tempRelayGroups = relayGroupMap.values.map((e) => e.value).toList();
      tempRelayGroups.forEach((element) {
        GroupUIModel uIModel= GroupUIModel.relayGroupdbToUIModel(element);
        groups.add(uIModel);
      });
    }
    Map<String, ValueNotifier<ChannelDBISAR>> channelsMap = Channels.sharedInstance.myChannels;
    if (channelsMap.length > 0) {
      List<ChannelDBISAR> channels = channelsMap.values.map((e) => e.value).toList();
      channels.forEach((element) {
        GroupUIModel uIModel= GroupUIModel.channeldbToUIModel(element);
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
      _loadData();
    }
    _refreshController.refreshCompleted();
  }

  _scrollToTop() async {
    bool isScrollToTop = widget.scrollToTopStatus?.isScrolledToTop.value ?? false;
    if (isScrollToTop) {
      await groupsWidgetKey.currentState?.scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      widget.scrollToTopStatus?.isScrolledToTop.value = false;
    }
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
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 300), () async {
      _loadData();
    });
  }

  @override
  void didRelayGroupsUpdatedCallBack() {
    LogUtil.e('Michael: ----didRelayGroupsUpdatedCallBack----------');
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 300), () async {
      _loadData();
    });
  }

  @override
  void didChannelsUpdatedCallBack() {
    _loadData();
  }

  @override
  void didCreateChannel(ChannelDBISAR? channelDB) {
    _loadData();
  }

  @override
  void didDeleteChannel(ChannelDBISAR? channelDB) {
    _loadData();
  }
}
