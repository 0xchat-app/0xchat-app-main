
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
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

class _RelaysPageState extends State<RelaysPage> {
  final TextEditingController _relayTextFieldControll = TextEditingController();
  final Map<RelayType,List<RelayDBISAR>> _relayListMap = {
    RelayType.general: [],
    RelayType.dm: []
  };
  final Map<RelayType,List<RelayDBISAR>> _recommendRelayListMap = {
    RelayType.general: [],
    RelayType.dm: []
  };
  bool _isEditing = false;
  bool _isShowDelete = false;
  final RelaySelectableController _relaySelectableController = RelaySelectableController();
  RelayType _relayType = RelayType.general;

  @override
  void initState() {
    super.initState();
    _relaySelectableController.currentIndex.addListener(_relaySelectableListener);
    _initDefault();
    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) {
      didRelayStatusChange(relay, status);
    });
    Account.sharedInstance.relayListUpdateCallback = _initDefault;
    Account.sharedInstance.dmRelayListUpdateCallback = _initDefault;
  }

  void _relaySelectableListener() {
    final currentIndex = _relaySelectableController.currentIndex.value;
    setState(() {
      _relayType = RelayType.values[currentIndex];
    });
  }

  @override
  void dispose() {
    _relaySelectableController.currentIndex.removeListener(_relaySelectableListener);
    super.dispose();
  }

  void _initDefault() async {
    for (var relayType in RelayType.values) {
      _initRelayList(relayType);
    }
    if(mounted) setState(() {});
  }

  void _initRelayList(RelayType relayType) {
    List<RelayDBISAR> relayList = _getRelayList(relayType);
    List<RelayDBISAR> recommendRelayList = _getRecommendRelayList(relayType);

    //Filters elements in the relay LIst
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
          //icon_edit.png
          Container(
            margin: EdgeInsets.only(
              right: Adapt.px(14),
            ),
            color: Colors.transparent,
            child: OXButton(
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
          )
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RelaySelectableTabBar(
              tabs: RelayType.values.map((e) => e.name()).toList(),
              tabTips: RelayType.values.map((e) => e.tips()).toList(),
              controller: _relaySelectableController,
            ).setPaddingOnly(top: 12.px),
            Container(
              width: double.infinity,
              height: Adapt.px(46),
              alignment: Alignment.centerLeft,
              child: Text(
                // Localized.text('ox_usercenter.connect_relay'),
                'CONNECT TO ${_relayType.sign()} RELAY',
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
                              'Add',
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
                height: Adapt.px(58),
                alignment: Alignment.centerLeft,
                child: Text(
                  // Localized.text('ox_usercenter.connected_relay'),
                  'CONNECTED TO ${_relayType.sign()} RELAY',
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
        ).setPadding(EdgeInsets.only(left: Adapt.px(24), right: Adapt.px(24), bottom: Adapt.px(24))),
      ),
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    List<RelayDBISAR> relayList = _relayListMap[_relayType]!;
    RelayDBISAR _model = relayList[index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap:() {
            if(!_isEditing){
              OXNavigator.pushPage(context, (context) => RelayDetailPage(relayURL: _model.url,));
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
                    child: Text(
                      _model.url,
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: Adapt.px(16),
                      ),
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
        )
      );
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
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: Adapt.px(16)),
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
    if(upcomingRelay.endsWith('/')){
      upcomingRelay = upcomingRelay.substring(0, upcomingRelay.length - 1);
    }
    List<RelayDBISAR> relayList = _relayListMap[_relayType]!;
    List<RelayDBISAR> recommendRelayList = _recommendRelayListMap[_relayType]!;
    final upcomingRelays = relayList.map((e) => e.url).toList();
    if (!isWssWithValidURL(upcomingRelay)) {
      CommonToast.instance.show(context, 'Please input the right wss');
      return;
    }
    if (upcomingRelays.contains(upcomingRelay)) {
      CommonToast.instance.show(context, 'This Relay already exists');
    } else {
      switch(_relayType) {
        case RelayType.general:
          await Account.sharedInstance.addGeneralRelay(upcomingRelay);
          break;
        case RelayType.dm:
          await Account.sharedInstance.addDMRelay(upcomingRelay);
          break;
      }
      recommendRelayList.removeWhere((element) => element.url == upcomingRelay);
      setState(() {
        relayList.add(RelayDBISAR(url: upcomingRelay!));
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
                switch(_relayType) {
                  case RelayType.general:
                    await Account.sharedInstance.removeGeneralRelay(relayModel.url);
                    break;
                  case RelayType.dm:
                    await Account.sharedInstance.removeDMRelay(relayModel.url);
                    break;
                }
                OXNavigator.pop(context);
                _initDefault();
              }),
        ],
        isRowAction: true);
  }
}

enum RelayType {
  general,
  dm,
}

extension RelayTypeExtension on RelayType {
  String name() {
    switch (this) {
      case RelayType.dm:
        return 'DM Inbox Relays';
      case RelayType.general:
        return 'General Relays';
    }
  }

  String sign() {
    switch (this) {
      case RelayType.dm:
        return 'DM';
      case RelayType.general:
        return 'GENERAL';
    }
  }

  String tips() {
    switch (this) {
      case RelayType.dm:
        return "It is recommended to set up 1-3 DM inbox relays. Your private messages and private group chat messages will be sent to your DM relay. If not set, they will be sent to the general relay by default.";
      case RelayType.general:
        return "0xchat uses these relays to download user profiles, lists, and posts for you";
    }
  }
}

class RelayConnectStatus {
  static final int connecting = 0;
  static final int open = 1;
  static final int closing = 2;
  static final int closed = 3;
}
