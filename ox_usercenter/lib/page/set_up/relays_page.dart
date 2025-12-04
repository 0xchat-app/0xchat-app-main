import 'package:flutter/material.dart';
import 'package:ox_common/mixin/common_navigator_observer_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_usercenter/page/set_up/relay_detail_page.dart';
import 'package:ox_usercenter/widget/ping_delay_time_widget.dart';
import 'package:ox_usercenter/widget/relay_recommend_widget.dart';
import 'package:ox_usercenter/widget/relay_selectable_tab_bar.dart';

///Title: relays_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/4 17:20
class RelaysPage extends StatefulWidget {
  const RelaysPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RelaysPageState();
  }
}

class _RelaysPageState extends State<RelaysPage> with WidgetsBindingObserver, NavigatorObserverMixin {
  final TextEditingController _relayTextFieldControll = TextEditingController();
  final Map<RelayType, List<RelayDBISAR>> _relayListMap = {
    RelayType.general: [],
    RelayType.dm: [],
    RelayType.outbox: [],
    RelayType.inbox: [],
    RelayType.search: []
  };
  final Map<RelayType, List<RelayDBISAR>> _recommendRelayListMap = {
    RelayType.general: [],
    RelayType.dm: [],
    RelayType.outbox: [],
    RelayType.inbox: [],
    RelayType.search: []
  };
  bool _isEditing = false;
  bool _isShowDelete = false;
  RelayType _relayType = RelayType.general;
  final PingLifecycleController _pingLifecycleController = PingLifecycleController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDefault();
    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) {
      didRelayStatusChange(relay, status);
    });
    Account.sharedInstance.relayListUpdateCallback = _initDefault;
    Account.sharedInstance.dmRelayListUpdateCallback = _initDefault;
  }

  void _relayTypeChanged(int index) {
    setState(() {
      _relayType = RelayType.values[index];
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pingLifecycleController.isPaused.dispose();
    super.dispose();
  }

  void _initDefault() async {
    for (var relayType in RelayType.values) {
      await _initRelayList(relayType);
    }
    if (mounted) setState(() {});
  }

  Future<void> _initRelayList(RelayType relayType) async {
    List<RelayDBISAR> relayList = _getRelayList(relayType);
    List<RelayDBISAR> recommendRelayList = _getRecommendRelayList(relayType);

    // For all relay types, filter out relays that are already in the list
    recommendRelayList.removeWhere((recommendRelay) {
      return relayList.any((relay) => relay.url == recommendRelay.url);
    });

    _relayListMap[relayType] = relayList;
    _recommendRelayListMap[relayType] = recommendRelayList;
  }

  List<RelayDBISAR> _getRelayList(RelayType relayType) {
    switch (relayType) {
      case RelayType.general:
        return Account.sharedInstance.getMyGeneralRelayList();
      case RelayType.dm:
        return Account.sharedInstance.getMyDMRelayList();
      case RelayType.inbox:
        return Account.sharedInstance.getMyInboxRelayList();
      case RelayType.outbox:
        return Account.sharedInstance.getMyOutboxRelayList();
      case RelayType.search:
        return Account.sharedInstance.getMySearchRelayList();
      default:
        return [];
    }
  }

  List<RelayDBISAR> _getRecommendRelayList(RelayType relayType) {
    switch (relayType) {
      case RelayType.general:
        return Account.sharedInstance.getMyRecommendGeneralRelaysList();
      case RelayType.dm:
        return Account.sharedInstance.getMyRecommendDMRelaysList();
      case RelayType.inbox:
        return Account.sharedInstance.getMyRecommendDMRelaysList();
      case RelayType.outbox:
        return Account.sharedInstance.getMyRecommendDMRelaysList();
      case RelayType.search:
        return Account.sharedInstance.getMyRecommendSearchRelaysList();
      default:
        return [];
    }
  }

  void didRelayStatusChange(String relay, int status) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_usercenter.relays'),
        titleTextColor: ThemeColor.color0,
        actions: [
          OXButton(
            highlightColor: Colors.transparent,
            color: Colors.transparent,
            minWidth: Adapt.px(44),
            height: Adapt.px(44),
            child: CommonImage(
              iconName: _isEditing ? 'icon_done.png' : 'icon_edit.png',
              width: Adapt.px(24),
              height: Adapt.px(24),
              useTheme: true,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      backgroundColor: ThemeColor.color190,
      body: _body(),
    );
  }

  Widget _body() {
    List<RelayDBISAR> relayList = _relayListMap[_relayType]!;
    List<RelayDBISAR> recommendRelayList = _recommendRelayListMap[_relayType]!;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: PlatformUtils.listWidth,
            ),
            child: PingInheritedWidget(
              controller: _pingLifecycleController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RelaySelectableTabBar(
                    tabs: RelayType.values.map((e) => e.name()).toList(),
                    tabTips: RelayType.values.map((e) => e.tips()).toList(),
                    onChanged: _relayTypeChanged,
                  ).setPaddingOnly(top: 12.px),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 24.px, bottom: 12.px),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _relayType == RelayType.search
                          ? Localized.text('ox_usercenter.str_custom_search_relay')
                          : '${Localized.text('ox_usercenter.str_connect_to_relay')} ${_relayType.sign()}',
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: Adapt.px(14),
                      ),
                    ),
                  ),
                  _inputRelay(),
                  SizedBox(
                    height: Adapt.px(12),
                  ),
                  _isShowDelete
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _relayTextFieldControll.text = '';
                                    _isShowDelete = false;
                                  });
                                },
                                child: Container(
                                  height: Adapt.px(36),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Adapt.px(8)),
                                    color: ThemeColor.color180,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    Localized.text('ox_common.cancel'),
                                    style: TextStyle(
                                      fontSize: Adapt.px(14),
                                      color: ThemeColor.color0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Adapt.px(12),
                            ),
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => _addOnTap(isUserInput: true),
                                child: Container(
                                  height: Adapt.px(36),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Adapt.px(8)),
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
                                    Localized.text('ox_usercenter.str_add'),
                                    style: TextStyle(
                                      fontSize: Adapt.px(14),
                                      color: ThemeColor.color0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  if (relayList.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 24.px, bottom: 12.px),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${Localized.text('ox_usercenter.str_connected_to_relay')} ${_relayType.sign()}',
                        style: TextStyle(
                          color: ThemeColor.color0,
                          fontSize: Adapt.px(16),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Adapt.px(16)),
                        color: ThemeColor.color180,
                      ),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: _itemBuild,
                        itemCount: relayList.length,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                  if (recommendRelayList.isNotEmpty)
                    RelayCommendWidget(recommendRelayList, (RelayDBISAR relayDB) {
                      _addOnTap(upcomingRelay: relayDB.url);
                    }),
                ],
              ).setPadding(
                  EdgeInsets.only(left: Adapt.px(24), right: Adapt.px(24), bottom: Adapt.px(24))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    List<RelayDBISAR> relayList = _relayListMap[_relayType]!;
    RelayDBISAR _model = relayList[index];
    final host = _model.url.split('//').last;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (!_isEditing) {
              OXNavigator.pushPage(
                  context,
                  (context) => RelayDetailPage(
                        relayURL: _model.url,
                      ));
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 10.px),
            child: Row(
              children: [
                CommonImage(
                  iconName: 'icon_settings_relays.png',
                  width: Adapt.px(32),
                  height: Adapt.px(32),
                  package: 'ox_usercenter',
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.px),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _model.url,
                          style: TextStyle(
                            color: ThemeColor.color0,
                            fontSize: Adapt.px(16),
                          ),
                        ),
                        PingDelayTimeWidget(
                          host: host,
                          controller: _pingLifecycleController,
                        ).setPaddingOnly(top: 4.px)
                      ],
                    ),
                  ),
                ),
                _relayStateImage(_model),
              ],
            ),
          ),
        ),
        relayList.length > 1 && relayList.length - 1 != index
            ? Divider(
                height: Adapt.px(0.5),
                color: ThemeColor.color160,
              )
            : Container(),
      ],
    );
  }

  Widget _relayStateImage(RelayDBISAR relayDB) {
    if (_isEditing) {
      return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _deleteOnTap(relayDB);
          },
          child: CommonImage(
            iconName: 'icon_bar_delete_red.png',
            width: Adapt.px(24),
            height: Adapt.px(24),
          ));
    } else {
      if (relayDB.connectStatus == RelayConnectStatus.open) {
        return CommonImage(
          iconName: 'icon_pic_selected.png',
          width: Adapt.px(24),
          height: Adapt.px(24),
        );
      } else {
        return SizedBox(
          width: Adapt.px(24),
          height: Adapt.px(24),
          child: CircularProgressIndicator(
            backgroundColor: ThemeColor.color0.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(ThemeColor.color0),
          ),
        );
      }
    }
  }

  Widget _inputRelay() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ThemeColor.color180,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: Adapt.px(24),
              height: Adapt.px(24),
              child: CommonImage(
                iconName: 'icon_relay_paste.png',
                width: Adapt.px(24),
                height: Adapt.px(24),
                package: 'ox_usercenter',
                useTheme: true,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _relayTextFieldControll,
                decoration: InputDecoration(
                  hintText: 'wss://some.relay.com',
                  hintStyle: TextStyle(
                    color: ThemeColor.color100,
                    fontSize: Adapt.px(15),
                  ),
                  suffixIcon: _isShowDelete
                      ? IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _relayTextFieldControll.text = '';
                              _isShowDelete = false;
                            });
                          },
                          icon: CommonImage(
                            iconName: 'icon_textfield_close.png',
                            width: Adapt.px(16),
                            height: Adapt.px(16),
                          ),
                        )
                      : null,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (str) {
                  setState(() {
                    if (str.isNotEmpty) {
                      _isShowDelete = true;
                    } else {
                      _isShowDelete = false;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isWssWithValidURL(String input) {
    RegExp regex = RegExp(r'^(wss?://)([\w-]+\.)+[\w-]+(:\d+)?(/[\w- ./?%&=]*)?$');
    return regex.hasMatch(input);
  }

  void _addOnTap({String? upcomingRelay, bool isUserInput = false}) async {
    upcomingRelay ??= _relayTextFieldControll.text;
    if (upcomingRelay.endsWith('/')) {
      upcomingRelay = upcomingRelay.substring(0, upcomingRelay.length - 1);
    }
    List<RelayDBISAR> relayList = _relayListMap[_relayType]!;
    List<RelayDBISAR> recommendRelayList = _recommendRelayListMap[_relayType]!;
    final upcomingRelays = relayList.map((e) => e.url).toList();
    if (!isWssWithValidURL(upcomingRelay)) {
      CommonToast.instance.show(context, Localized.text('ox_usercenter.str_please_input_right_wss'));
      return;
    }
    if (upcomingRelays.contains(upcomingRelay)) {
      CommonToast.instance.show(context, Localized.text('ox_usercenter.str_relay_already_exists'));
    } else {
      switch (_relayType) {
        case RelayType.general:
          await Account.sharedInstance.addGeneralRelay(upcomingRelay);
          break;
        case RelayType.dm:
          await Account.sharedInstance.addDMRelay(upcomingRelay);
          break;
        case RelayType.inbox:
          await Account.sharedInstance.addInboxRelay(upcomingRelay);
          break;
        case RelayType.outbox:
          await Account.sharedInstance.addOutboxRelay(upcomingRelay);
          break;
        case RelayType.search:
          await Account.sharedInstance.addSearchRelay(upcomingRelay);
          break;
      }
      recommendRelayList.removeWhere((element) => element.url == upcomingRelay);
      relayList.add(RelayDBISAR(url: upcomingRelay));
      setState(() {
        if (isUserInput) {
          _relayTextFieldControll.text = '';
          _isShowDelete = false;
        }
      });
    }
  }

  void _deleteOnTap(RelayDBISAR relayModel) async {
    OXCommonHintDialog.show(context,
        title: Localized.text('ox_common.tips'),
        content: Localized.text('ox_usercenter.delete_relay_hint'),
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                switch (_relayType) {
                  case RelayType.general:
                    await Account.sharedInstance.removeGeneralRelay(relayModel.url);
                    break;
                  case RelayType.dm:
                    await Account.sharedInstance.removeDMRelay(relayModel.url);
                    break;
                  case RelayType.inbox:
                    await Account.sharedInstance.removeInboxRelay(relayModel.url);
                    break;
                  case RelayType.outbox:
                    await Account.sharedInstance.removeOutboxRelay(relayModel.url);
                    break;
                  case RelayType.search:
                    await Account.sharedInstance.removeSearchRelay(relayModel.url);
                    break;
                }
                OXNavigator.pop(context);
                _initDefault();
              }),
        ],
        isRowAction: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _pingLifecycleController.isPaused.value = true;
    } else if (state == AppLifecycleState.resumed) {
      _pingLifecycleController.isPaused.value = false;
    }
  }

  @override
  void didPushNext() {
    _pingLifecycleController.isPaused.value = true;
  }

  @override
  void didPopNext() {
    _pingLifecycleController.isPaused.value = false;
  }
}

enum RelayType {
  general,
  dm,
  outbox,
  inbox,
  search,
}

extension RelayTypeExtension on RelayType {
  String name() {
    switch (this) {
      case RelayType.dm:
        return Localized.text('ox_usercenter.str_dm_relays');
      case RelayType.general:
        return Localized.text('ox_usercenter.str_app_relays');
      case RelayType.inbox:
        return Localized.text('ox_usercenter.str_inbox_relays');
      case RelayType.outbox:
        return Localized.text('ox_usercenter.str_outbox_relays');
      case RelayType.search:
        return Localized.text('ox_usercenter.str_search_relays');
    }
  }

  String sign() {
    switch (this) {
      case RelayType.dm:
        return Localized.text('ox_usercenter.str_dm_relays');
      case RelayType.general:
        return Localized.text('ox_usercenter.str_app');
      case RelayType.inbox:
        return Localized.text('ox_usercenter.str_inbox');
      case RelayType.outbox:
        return Localized.text('ox_usercenter.str_outbox');
      case RelayType.search:
        return Localized.text('ox_usercenter.str_search');
    }
  }

  String tips() {
    switch (this) {
      case RelayType.dm:
        return Localized.text('ox_usercenter.str_dm_relay_description');
      case RelayType.general:
        return Localized.text('ox_usercenter.str_local_relay_description');
      case RelayType.inbox:
        return Localized.text('ox_usercenter.str_inbox_relay_description');
      case RelayType.outbox:
        return Localized.text('ox_usercenter.str_outbox_relay_description');
      case RelayType.search:
        return Localized.text('ox_usercenter.str_search_relay_description');
    }
  }
}

class RelayConnectStatus {
  static final int connecting = 0;
  static final int open = 1;
  static final int closing = 2;
  static final int closed = 3;
}
