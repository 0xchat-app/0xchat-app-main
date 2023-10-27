import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';

import '../contact_group_list_page.dart';
import '../contact_group_member_page.dart';

class GroupSettingQrcodePage extends StatefulWidget {

  final String groupId;

  GroupSettingQrcodePage({required this.groupId});

  @override
  State<StatefulWidget> createState() {
    return _GroupSettingQrcodePageState();
  }
}

class _GroupSettingQrcodePageState extends State<GroupSettingQrcodePage> {
  String _imgUrl = '';
  String _groupQrCodeUrl = '';
  GlobalKey _globalKey = new GlobalKey();

  GroupDB? groupDBInfo = null;

  @override
  void initState() {
    super.initState();
    _groupInfoInit();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  void _groupInfoInit() async {
    GroupDB? groupDB = await Groups.sharedInstance.myGroups[widget.groupId];

    if (groupDB != null) {
      groupDBInfo = groupDB;
      _getGroupQrcode(groupDB);
      setState(() {});
    }
  }

  void _getGroupQrcode(GroupDB groupDB){
    String relay = groupDB.relay ?? '';
    String groupOwner = groupDB.owner;
    String groupId = groupDB.groupId;
    _groupQrCodeUrl = Groups.encodeGroup(groupId,[relay],groupOwner);
  }

  Widget _body() {
    String localAvatarPath = 'assets/images/user_image.png';
    Image placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(76),
      height: Adapt.px(76),
      package: 'ox_common',
    );

    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: '',
        backgroundColor: ThemeColor.color190,
        actions: [
          _appBarActionWidget(),
          SizedBox(
            width: Adapt.px(24),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: Adapt.px(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: Container(
                width: Adapt.px(310),
                height: Adapt.px(430),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ThemeColor.color180,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: Adapt.px(48),
                      margin: EdgeInsets.only(
                        left: Adapt.px(24),
                        top: Adapt.px(36),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: Adapt.px(48),
                            height: Adapt.px(48),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Adapt.px(48)),
                              child: CachedNetworkImage(
                                imageUrl: _imgUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    placeholderImage,
                                errorWidget: (context, url, error) =>
                                    placeholderImage,
                                width: Adapt.px(48),
                                height: Adapt.px(48),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: Adapt.px(16), top: Adapt.px(2)),
                                child: MyText(
                                  groupDBInfo?.name ?? '--',
                                  16,
                                  ThemeColor.color10,
                                  fontWeight:FontWeight.w600,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: Adapt.px(16), top: Adapt.px(2)),
                                child: MyText(
                                  _dealWithGroupId,
                                  14,
                                  ThemeColor.color120,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      radius: 0.0,
                      onLongPress: () {
                        _showBottomMenu();
                      },
                      child: Container(
                        width: double.infinity,
                        height: Adapt.px(260),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: Adapt.px(19),
                            left: Adapt.px(25),
                            right: Adapt.px(25)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(
                          Adapt.px(8),
                        ),
                        child: _groupQrCodeUrl!.isEmpty
                            ? Container()
                            : _qrCodeWidget(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: Adapt.px(24)),
                      alignment: Alignment.center,
                      child: MyText('Scan the QR code to join the group ', 13, ThemeColor.color110,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            //
           GestureDetector(
             onTap: _widgetShotAndSave,
             child:  Container(
               child:Text(
                 'Save Image',
                 style: TextStyle(
                   fontWeight: FontWeight.w600,
                   color: ThemeColor.purple2,
                   fontSize: Adapt.px(18),

                 ),
               ),
             ),
           ),
          ],
        ),
      ),
    );
  }

  void _shareGroupFn() {
    OXNavigator.presentPage(
      context,
          (context) => ContactGroupMemberPage(
        groupId: widget.groupId,
        groupListAction: GroupListAction.send,
      ),);
  }

  Widget _appBarActionWidget() {
    return GestureDetector(
      onTap: _shareGroupFn,
      child: CommonImage(
        iconName: 'share_icon.png',
        width: Adapt.px(20),
        height: Adapt.px(20),
        useTheme: true,
      ),
    );
  }

  Widget _qrCodeWidget() {
    return PrettyQr(
      size: Adapt.px(240),
      data: _groupQrCodeUrl,
      errorCorrectLevel: QrErrorCorrectLevel.M,
      typeNumber: null,
      roundEdges: true,
    );
  }

  void _showBottomMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: new Material(
              type: MaterialType.transparency,
              child: new Opacity(
                opacity: 1, //Opacity containing a widget
                child: new GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Container(
                    decoration: BoxDecoration(
                      color: ThemeColor.color190,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new GestureDetector(
                          onTap: () {
                            _widgetShotAndSave();
                          },
                          child: Container(
                            height: Adapt.px(48),
                            padding: EdgeInsets.all(Adapt.px(8)),
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                              color: ThemeColor.color180,
                            ),
                            child: Text(
                              'str_save_image'.localized(),
                              style: new TextStyle(
                                  color: ThemeColor.gray02,
                                  fontSize: Adapt.px(16),
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        new Container(
                          height: Adapt.px(2),
                          color: ThemeColor.dark01,
                        ),
                        new GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: Adapt.px(48),
                            padding: EdgeInsets.all(Adapt.px(8)),
                            alignment: FractionalOffset.center,
                            color: ThemeColor.color180,
                            child: Text(
                              'cancel'.commonLocalized(),
                              style: new TextStyle(
                                  color: ThemeColor.gray02,
                                  fontSize: Adapt.px(16),
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }

  void _widgetShotAndSave() async {
    if (await Permission.storage.request().isGranted) {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      var image = await boundary.toImage(pixelRatio: devicePixelRatio);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData != null) {
        Uint8List? pngBytes = byteData.buffer.asUint8List();
        final result =
            await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
        if (result != null && result != "") {
          // LogUtil.e('Michael : result = ${result.toString()}');
          // Navigator.pop(context);
          //Return the path
          // String str = Uri.decodeComponent(result);
          CommonToast.instance.show(
            context,
            "str_saved_to_album".localized(),
          );
        } else {
          // Navigator.pop(context);
          CommonToast.instance.show(
            context,
            "str_save_failed".localized(),
          );
        }
      } else {
        // Navigator.pop(context);
        CommonToast.instance.show(
          context,
          "str_save_failed".localized(),
        );
      }
    } else {
      OXCommonHintDialog.show(context,
          content: Localized.text('ox_chat.str_permission_camera_hint'),
          actionList: [
            OXCommonHintAction(
                text: () => Localized.text('ox_chat.str_go_to_settings'),
                onTap: () {
                  openAppSettings();
                  OXNavigator.pop(context);
                }),
          ]);
      return;
    }
  }

  String get _dealWithGroupId {
    String? groupId = groupDBInfo?.groupId;
    if(groupId == null) return '--';
    return groupId.substring(0,5) + '...' +  groupId.substring(groupId.length - 5);
  }
}
