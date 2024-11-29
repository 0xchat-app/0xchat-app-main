import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/model/ice_server_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_server_manager.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

enum ICEServerType{
  connected,
  recommend
}

class ICEServerPage extends StatefulWidget {
  const ICEServerPage({super.key});

  @override
  State<ICEServerPage> createState() => _ICEServerPageState();
}

class _ICEServerPageState extends State<ICEServerPage> {
  final TextEditingController _iceServerTextFieldController = TextEditingController();
  List<ICEServerModel> _connectICEServerList = [];
  final List<ICEServerModel> _recommendICEServerList = [];
  bool _isEditing = false;
  bool _isShowDelete = false;
  bool _isShowAdd = false;
  bool _isOpenP2PAndRelay = true;

  @override
  void initState() {
    super.initState();
    _recommendICEServerList.addAll(ICEServerModel.defaultICEServers);
    _isOpenP2PAndRelay = OXServerManager.sharedInstance.openP2PAndRelay;
    _initData();
  }

  Future<void> _initData() async {
    List<ICEServerModel> iCEServerList = await OXServerManager.sharedInstance.getICEServerList();
    setState(() {
      _connectICEServerList = iCEServerList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_usercenter.ice_server_title'),
        backgroundColor: ThemeColor.color190,
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
      body: _buildBody().setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(12))),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: PlatformUtils.listWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildP2pStatusWidget(),
                _buildItem(Localized.text('ox_usercenter.connect_ice_server'), _buildICEServerTextField()),
                SizedBox(
                  height: Adapt.px(12),
                ),
                _buildAddButton(),
                _connectICEServerList.isNotEmpty ? _buildItem(Localized.text('ox_usercenter.connected_ice_server'), _buildICEServerList(_connectICEServerList,)) : Container(),
                _recommendICEServerList.isNotEmpty ? _buildItem(Localized.text('ox_usercenter.recommend_ice_server'), _buildICEServerList(_recommendICEServerList,type: ICEServerType.recommend)) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildP2pStatusWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.px),
            color: ThemeColor.color180,
          ),
          margin: EdgeInsets.only(top: 12.px),
          padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Localized.text('ox_usercenter.str_p2p_tips'),
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(16),
                ),
              ),
              _p2pSwitchWidget(),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8.px),
          alignment: Alignment.centerLeft,
          child: Text(
            Localized.text('ox_usercenter.str_p2p_title'),
            style: TextStyle(
              color: ThemeColor.color100,
              fontSize: Adapt.px(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(String? itemTitle, Widget? itemBody) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 4.px),
          alignment: Alignment.centerLeft,
          child: Text(
            itemTitle ?? "",
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: Adapt.px(16),
            ),
          ),
        ),
        itemBody ?? Container(),
      ],
    );
  }

  Widget _buildICEServerTextField() {
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
              controller: _iceServerTextFieldController,
              decoration: InputDecoration(
                hintText: Localized.text('ox_usercenter.enter_ice_server_hint'),
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
                      _iceServerTextFieldController.clear();
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
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.px),
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
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

  Widget _buildAddButton(){
    return _isShowDelete ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                _iceServerTextFieldController.clear();
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
            onTap: _addICEServer,
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
                Localized.text('ox_usercenter.add'),
                style: TextStyle(
                  fontSize: Adapt.px(14),
                  color: ThemeColor.color0,
                ),
              ),
            ),
          ),
        ),
      ],
    ) : Container();
  }

  Widget _buildICEServerList(List<ICEServerModel> iceServerList,{ICEServerType type = ICEServerType.connected}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context,index) => _buildICEServerItem(context,index,iceServerList: iceServerList,type: type),
        itemCount: iceServerList.length,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildICEServerItem(BuildContext context, int index, {required List<ICEServerModel> iceServerList,ICEServerType type = ICEServerType.connected}) {
    ICEServerModel model = iceServerList[index];
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: Adapt.px(52),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
            leading: CommonImage(
              iconName: 'icon_settings_ice_server.png',
              width: Adapt.px(32),
              height: Adapt.px(32),
              package: 'ox_usercenter',
            ),
            title: Container(
              margin: EdgeInsets.only(left: Adapt.px(12)),
              child: Text(
                model.host,
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(16),
                ),
              ),
            ),
            trailing: _buildTrailing(index: index, type: type),
          ),
        ),
        iceServerList.length > 1 && iceServerList.length - 1 != index
            ? Divider(
                height: Adapt.px(0.5),
                color: ThemeColor.color160,
              )
            : Container(),
      ],
    );
  }

  Widget _buildTrailing({required int index, ICEServerType type = ICEServerType.connected}) {
    switch(type){
      case ICEServerType.connected:
        return _isEditing ? GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            _deleteOnTap(_connectICEServerList[index]);
          },
          child: CommonImage(
            iconName: 'icon_bar_delete_red.png',
            width: Adapt.px(24),
            height: Adapt.px(24),
          ),
        ) : const SizedBox(height: 10,width: 10,);
      case ICEServerType.recommend:
        _isShowAdd = !_connectICEServerList.any((element) => element.url == _recommendICEServerList[index].url);
        return _isShowAdd ? GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            await OXServerManager.sharedInstance.addServer(_recommendICEServerList[index]);
            setState(() {
              _connectICEServerList.add(_recommendICEServerList[index]);
            });
          },
          child: CommonImage(
            iconName: 'icon_bar_add.png',
            width: Adapt.px(24),
            height: Adapt.px(24),
            package: 'ox_usercenter',
          ),
        ) : const SizedBox(height: 10,width: 10,);
    }
  }

  Future<void> _addICEServer() async {
    String iceServerAddress = _iceServerTextFieldController.text;

    List<String> _iCEServerAddressList =_connectICEServerList.map((item) => item.url).toList();

    if (_iCEServerAddressList.contains(iceServerAddress)) {
      CommonToast.instance.show(context, Localized.text('ox_usercenter.add_ice_server_exist_tips'));
    } else {
      ICEServerModel tempICEServerModel = ICEServerModel(
        url: iceServerAddress,
        canDelete: true,
        createTime: DateTime.now().millisecondsSinceEpoch,
      );
      await OXServerManager.sharedInstance.addServer(tempICEServerModel);
      setState(() {
        _connectICEServerList.add(tempICEServerModel);
        _iceServerTextFieldController.clear();
        _isShowDelete = false;
      });
    }
  }

  void _deleteOnTap(ICEServerModel iceServerModel) async {
    if (iceServerModel.canDelete) {
      OXCommonHintDialog.show(context,
          title: Localized.text('ox_common.tips'),
          content: Localized.text('ox_usercenter.delete_server_tips'),
          actionList: [
            OXCommonHintAction.cancel(onTap: () {
              OXNavigator.pop(context);
            }),
            OXCommonHintAction.sure(
                text: Localized.text('ox_common.confirm'),
                onTap: () async {
                  OXNavigator.pop(context);
                  await OXServerManager.sharedInstance.deleteServer(iceServerModel);
                  _initData();
                  CommonToast.instance.show(context, Localized.text('ox_usercenter.delete_server_success_tips'));
                }),
          ],
          isRowAction: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _iceServerTextFieldController.dispose();
  }

  Widget _p2pSwitchWidget() {
    return Switch(
      value: !_isOpenP2PAndRelay,
      activeColor: Colors.white,
      activeTrackColor: ThemeColor.gradientMainStart,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: ThemeColor.color160,
      onChanged: (value) => _changeP2PFn(value),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  Future<void> _changeP2PFn(bool value) async {
    _isOpenP2PAndRelay = !value;
    await OXServerManager.sharedInstance.saveOpenP2PAndRelay(_isOpenP2PAndRelay);
    setState(() {});
  }
}
