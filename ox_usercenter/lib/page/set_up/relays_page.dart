import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_relay_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/model/relay_model.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_usercenter/page/set_up/relay_detail_page.dart';
import 'package:ox_usercenter/widget/relay_recommend_widget.dart';

///Title: relays_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/4 17:20
class RelaysPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RelaysPageState();
  }
}

class _RelaysPageState extends State<RelaysPage> with OXRelayObserver {
  final TextEditingController _relayTextFieldControll = TextEditingController();
  late List<RelayModel> _relayList = [];
  final List<RelayModel> _commendRelayList = [];
  final List<String> _relayAddressList = [];
  final Map<String, RelayModel> _relayConnectStatusMap = {};
  bool _isEditing = false;
  bool _isShowDelete = false;

  @override
  void initState() {
    super.initState();
    OXRelayManager.sharedInstance.addObserver(this);
    _initDefault();
  }

  @override
  void dispose() {
    OXRelayManager.sharedInstance.removeObserver(this);
    super.dispose();
  }

  void _initDefault() async {
    _relayAddressList.clear();
    _relayConnectStatusMap.clear();
    _commendRelayList.clear();
    _relayList = OXRelayManager.sharedInstance.relayModelList
        .map((obj) => RelayModel(
              relayName: obj.relayName,
              canDelete: obj.canDelete,
              isSelected: obj.isSelected,
              createTime: obj.createTime,
              connectStatus: obj.connectStatus,
            ))
        .toList();
    for (RelayModel model in _relayList) {
      _relayAddressList.add(model.identify);
      _relayConnectStatusMap[model.identify] = model;
    }
    bool containsDamusIo = _relayAddressList.contains('wss://relay.damus.io');
    _commendRelayList.add(RelayModel(
      canDelete: true,
      connectStatus: 3,
      isSelected: false,
      isAddedCommend: containsDamusIo ? true : false,
      relayName: 'wss://relay.damus.io',
    ));
    bool containsNostrBand = _relayAddressList.contains(''
        'wss://relay.nostr.band');
    _commendRelayList.add(RelayModel(
      canDelete: true,
      connectStatus: 3,
      isSelected: false,
      isAddedCommend: containsNostrBand ? true : false,
      relayName: 'wss://relay.nostr.band',
    ));
    bool containsOxChatRelay = _relayAddressList.contains(CommonConstant.oxChatRelay);
    _commendRelayList.add(RelayModel(
      relayName: CommonConstant.oxChatRelay,
      canDelete: true,
      connectStatus: 3,
      isSelected: true,
      isAddedCommend: containsOxChatRelay ? true : false,
      createTime: DateTime.now().millisecondsSinceEpoch,
    ));
    setState(() {});
    _relayConnectStatusMap.forEach((key, value) {
      if (Connect.sharedInstance.webSockets[key]?.connectStatus != null) {
        value.connectStatus = Connect.sharedInstance.webSockets[key]!.connectStatus;
      }
    });
  }

  @override
  void didRelayStatusChange(String relay, int status) {
    if (_relayConnectStatusMap[relay] != null && _relayConnectStatusMap[relay]!.connectStatus != status) {
      _relayConnectStatusMap[relay]!.connectStatus = status;
      if (mounted) {
        setState(() {});
      }
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
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: Adapt.px(46),
            alignment: Alignment.centerLeft,
            child: Text(
              Localized.text('ox_usercenter.connect_relay'),
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: Adapt.px(16),
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
                        onTap: _addOnTap,
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
          Container(
            width: double.infinity,
            height: Adapt.px(58),
            alignment: Alignment.centerLeft,
            child: Text(
              Localized.text('ox_usercenter.connected_relay'),
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
          RelayCommendWidget(_commendRelayList, (relayModel) {
            _addOnTap(upcomingRelay: relayModel.relayName);
          }),
        ],
      ).setPadding(EdgeInsets.only(left: Adapt.px(24), right: Adapt.px(24), bottom: Adapt.px(24))),
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    RelayModel _model = _relayList[index];
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: Adapt.px(52),
          child: ListTile(
            onTap: (){
              if(!_isEditing){
                OXNavigator.pushPage(context, (context) => RelayDetailPage(relayURL: _model.relayName,));
              }
            },
            contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
            leading: CommonImage(
              iconName: 'icon_settings_relays.png',
              width: Adapt.px(32),
              height: Adapt.px(32),
              package: 'ox_usercenter',
            ),
            title: Container(
              margin: EdgeInsets.only(left: Adapt.px(12)),
              child: Text(
                _model.relayName,
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(16),
                ),
              ),
            ),
            trailing: _relayStateImage(_model),
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

  Widget _relayStateImage(RelayModel relayModel) {
    if (_isEditing) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _deleteOnTap(relayModel);
        },
        child: relayModel.canDelete
            ? CommonImage(
                iconName: 'icon_bar_delete_red.png',
                width: Adapt.px(24),
                height: Adapt.px(24),
              )
            : CommonImage(
                iconName: 'icon_bar_delete.png',
                width: Adapt.px(24),
                height: Adapt.px(24),
              ),
      );
    } else {
      if (_relayConnectStatusMap[relayModel.identify]?.connectStatus == RelayConnectStatus.open) {
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
      height: Adapt.px(48),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ThemeColor.color180,
      ),
      alignment: Alignment.center,
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
    );
  }

  bool isWssWithValidURL(String input) {
    RegExp regex = RegExp(r'^wss?:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(:[0-9]{1,5})?(\/\S*)?$');
    return regex.hasMatch(input);
  }

  void _addOnTap({String? upcomingRelay}) async {
    upcomingRelay ??= _relayTextFieldControll.text;
    upcomingRelay = RelayModel.identifyWithAddress(upcomingRelay);
    if (!isWssWithValidURL(upcomingRelay)) {
      CommonToast.instance.show(context, 'Please input the right wss');
      return;
    }
    if (_relayAddressList.contains(upcomingRelay)) {
      CommonToast.instance.show(context, 'This Relay already exists');
    } else {
      RelayModel _tempRelayModel = RelayModel(
        relayName: upcomingRelay,
        canDelete: true,
        connectStatus: 0,
        createTime: DateTime.now().millisecondsSinceEpoch,
      );
      _relayConnectStatusMap[upcomingRelay] = _tempRelayModel;
      await OXRelayManager.sharedInstance.addRelaySuccess(_tempRelayModel);
      for(RelayModel model in _commendRelayList){
        if(model.relayName == upcomingRelay){
          model.isAddedCommend = true;
        }
      }
      setState(() {
        _relayList.add(_tempRelayModel);
        _relayAddressList.add(upcomingRelay!);
      });
    }
  }

  void _deleteOnTap(RelayModel relayModel) async {
    if (relayModel.canDelete) {
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
                  await OXRelayManager.sharedInstance.deleteRelay(relayModel);
                  OXNavigator.pop(context);
                  _initDefault();
                }),
          ],
          isRowAction: true);
    }
  }
}
