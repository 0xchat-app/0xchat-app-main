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

///Title: relays_for_login_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/12/27 15:33
class RelaysForLoginPage extends StatefulWidget {
  final List<String> relayUrls;
  const RelaysForLoginPage({super.key, required this.relayUrls});

  @override
  State<StatefulWidget> createState() {
    return _RelaysForLoginPageState();
  }
}

class _RelaysForLoginPageState extends State<RelaysForLoginPage> with WidgetsBindingObserver, NavigatorObserverMixin {
  final TextEditingController _relayTextFieldControll = TextEditingController();
  late List<RelayDBISAR> _relayList = [];
  late List<RelayDBISAR> _recommendRelayList = [];
  bool _isEditing = false;
  bool _isShowDelete = false;
  final PingLifecycleController _pingLifecycleController = PingLifecycleController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDefault();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pingLifecycleController.isPaused.dispose();
    super.dispose();
  }

  void _initDefault() async {
    _initRelayList();
    if (mounted) setState(() {});
  }

  void _initRelayList() {
    List<String> urls = ['wss://relay.nsec.app'];
    if (widget.relayUrls.isNotEmpty) {
      urls = widget.relayUrls;
    }
    for(String url in urls) {
      _relayList.add(RelayDBISAR(url: url));
    }
    _recommendRelayList = [RelayDBISAR(url: 'wss://relay.nsec.app')];
    //Filters elements in the relay LIst
    _recommendRelayList.removeWhere((recommendRelay) {
      return _relayList.any((relay) => relay.url == recommendRelay.url);
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.relayUrls.length != _relayList.length) {
          List<String> newUrls = _relayList.map((relay) => relay.url).toList();
          OXNavigator.pop(context, newUrls);
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: CommonAppBar(
          useLargeTitle: false,
          centerTitle: true,
          title: Localized.text('ox_usercenter.relays'),
          titleTextColor: ThemeColor.color0,
          backCallback: () {
            OXNavigator.pop(context, _relayList.map((relay) => relay.url).toList());
          },
          actions: [
            //icon_edit.png
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
      ),
    );
  }

  Widget _body() {
    print('Jeff: --_body---_relayList----${_relayList.length}');
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
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 24.px, bottom: 12.px),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'CONNECT TO REMOTE SIGNER RELAY',
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
                  if (_relayList.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 24.px, bottom: 12.px),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        // Localized.text('ox_usercenter.connected_relay'),
                        'CONNECTED TO REMOTE SIGNER RELAY',
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
                        itemCount: _relayList.length,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                  if (_recommendRelayList.isNotEmpty)
                    RelayCommendWidget(_recommendRelayList, (RelayDBISAR relayDB) {
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
    RelayDBISAR _model = _relayList[index];
    print('Jeff: ---_relayList----${_model.url}');
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
        _relayList.length > 1 && _relayList.length - 1 != index
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
      return CommonImage(
        iconName: 'icon_pic_selected.png',
        width: Adapt.px(24),
        height: Adapt.px(24),
      );
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

    if (!isWssWithValidURL(upcomingRelay)) {
      CommonToast.instance.show(context, Localized.text('ox_usercenter.str_please_input_right_wss'));
      return;
    }
    if (_relayList.contains(upcomingRelay)) {
      CommonToast.instance.show(context, Localized.text('ox_usercenter.str_relay_already_exists'));
    } else {
      _recommendRelayList.removeWhere((element) => element.url == upcomingRelay);
      setState(() {
        _relayList.add(RelayDBISAR(url: upcomingRelay!));
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
                _relayList.removeWhere((element) => element.url == relayModel.url);
                if (relayModel.url == 'wss://relay.nsec.app' || relayModel.url == 'wss://relay.0xchat.com') {
                  _recommendRelayList.add(relayModel);
                }
                OXNavigator.pop(context);
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




class RelayConnectStatus {
  static final int connecting = 0;
  static final int open = 1;
  static final int closing = 2;
  static final int closed = 3;
}
