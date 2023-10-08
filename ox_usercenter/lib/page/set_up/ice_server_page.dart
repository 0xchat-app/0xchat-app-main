import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

class ICEServerPage extends StatefulWidget {
  const ICEServerPage({super.key});

  @override
  State<ICEServerPage> createState() => _ICEServerPageState();
}

class _ICEServerPageState extends State<ICEServerPage> {
  final TextEditingController _iceServerTextFieldController = TextEditingController();
  final List<ICEServerModel> _connectICEServerList = [];
  final List<ICEServerModel> _recommendICEServerList = [];
  bool _isShowDelete = false;

  @override
  void initState() {
    super.initState();
    _connectICEServerList.add(ICEServerModel(
      iceServerName: 'https://ice.0xchat.com',
      canDelete: true,
      isSelected: false,
      isAddedRecommend: true,
    ));
    _recommendICEServerList.add(ICEServerModel(
      iceServerName: 'https://ice.damus.io',
      canDelete: true,
      isSelected: false,
      isAddedRecommend: true,
    ));
    _recommendICEServerList.add(ICEServerModel(
      iceServerName: 'https://ice.nostr.band',
      canDelete: true,
      isSelected: false,
      isAddedRecommend: true,
    ));
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildItem(Localized.text('ox_usercenter.connect_ice_server'), _buildICEServerTextField()),
          SizedBox(
            height: Adapt.px(12),
          ),
          _buildAddButton(),
          _connectICEServerList.isNotEmpty ? _buildItem(Localized.text('ox_usercenter.connected_ice_server'), _buildICEServerList(_connectICEServerList)) : Container(),
          _recommendICEServerList.isNotEmpty ? _buildItem(Localized.text('ox_usercenter.recommend_ice_server'), _buildICEServerList(_recommendICEServerList,trailing: _buildTrailing())) : Container(),
        ],
      ),
    );
  }

  Widget _buildItem(String? itemTitle, Widget? itemBody) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: Adapt.px(46),
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
                hintText: '',
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
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
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
          child: InkWell(
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

  Widget _buildICEServerList(List<ICEServerModel> iceServerList,{Widget? trailing}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context,index) => _buildICEServerItem(context,index,iceServerList: iceServerList,trailing: trailing),
        itemCount: iceServerList.length,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildICEServerItem(BuildContext context, int index, {required List<ICEServerModel> iceServerList,Widget? trailing}) {
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
                model.iceServerName,
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(16),
                ),
              ),
            ),
            trailing: trailing,
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

  Widget _buildTrailing() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
      },
      child: CommonImage(
        iconName: 'icon_bar_add.png',
        width: Adapt.px(24),
        height: Adapt.px(24),
        package: 'ox_usercenter',
      ),
    );
  }

  Future<void> _saveICEServerList(List<ICEServerModel> iceServerList) async {
    List<String> jsonStringList = iceServerList.map((item) => json.encode(item.toJson(item))).toList();
    await OXCacheManager.defaultOXCacheManager.saveForeverData('KEY_ICE_SERVER', jsonStringList);
  }

  @override
  void dispose() {
    super.dispose();
    _iceServerTextFieldController.dispose();
  }
}

class ICEServerModel {
  String iceServerName;
  bool canDelete;
  bool isSelected;
  bool isAddedRecommend;
  int createTime;

  ICEServerModel({
    this.iceServerName = '',
    this.canDelete = false,
    this.isSelected = false,
    this.isAddedRecommend = false,
    this.createTime = 0,
  });

  factory ICEServerModel.fromJson(Map<String, dynamic> json) {
    return ICEServerModel(
      iceServerName: json['relayName'] ?? '',
      canDelete: json['canDelete'] ?? false,
      isSelected: json['isSelected'] ?? false,
      isAddedRecommend: json['isAddedRecommend'] ?? false,
      createTime: json['createTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(ICEServerModel iceServerModel) =>
      <String, dynamic>{
        'iceServerName': iceServerModel.iceServerName,
        'canDelete': iceServerModel.canDelete,
        'isSelected': iceServerModel.isSelected,
        'isAddedRecommend': iceServerModel.isAddedRecommend,
        'createTime': iceServerModel.createTime,
      };
}
