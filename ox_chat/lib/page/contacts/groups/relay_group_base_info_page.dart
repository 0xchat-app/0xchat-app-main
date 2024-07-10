import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/groups/relay_group_edit_page.dart';
import 'package:ox_chat/page/contacts/groups/relay_group_qrcode_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/business_interface/ox_chat/interface.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/permission_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:device_info/device_info.dart';

///Title: relay_group_base_info_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/6/21 18:06
class RelayGroupBaseInfoPage extends StatefulWidget {
  final String groupId;

  RelayGroupBaseInfoPage({
    super.key,
    required this.groupId,
  });

  @override
  State<StatefulWidget> createState() {
    return _RelayGroupBaseInfoPageState();
  }
}

class _RelayGroupBaseInfoPageState extends State<RelayGroupBaseInfoPage> {
  late RelayGroupDB? _groupDBInfo;
  bool _hasEditMetadataPermission = false;
  String _avatarAliyunUrl = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData(){
    _groupDBInfo = RelayGroup.sharedInstance.myGroups[widget.groupId];
    UserDB? userDB = OXUserInfoManager.sharedInstance.currentUserInfo;
    if (userDB != null && _groupDBInfo != null && _groupDBInfo!.admins != null && _groupDBInfo!.admins!.length > 0) {
      List<GroupActionKind>? userPermissions;
      try {
        userPermissions = _groupDBInfo!.admins!.firstWhere((admin) => admin.pubkey == userDB.pubKey).permissions;
        LogUtil.e('Michael:--- pubkey: ${userPermissions.toString()}');
      } catch (e) {
        userPermissions = [];
        LogUtil.e('No admin found with pubkey: ${userDB.pubKey}');
      }
      _hasEditMetadataPermission = userPermissions.contains(GroupActionKind.editMetadata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: 'group_info'.localized(),
        backgroundColor: ThemeColor.color190,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.px),
              color: ThemeColor.color180,
            ),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _hasEditMetadataPermission ? _handleImageSelection : null,
                  child: Container(
                    height: 76.px,
                    margin: EdgeInsets.symmetric(horizontal: 16.px),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyText('Group Photo', 16.sp, ThemeColor.color0),
                        Row(
                          children: [
                            _buildHeader(),
                            Visibility(
                              visible: _hasEditMetadataPermission,
                              child: CommonImage(
                                iconName: 'icon_arrow_more.png',
                                size: 24.px,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GroupItemBuild(
                  title: 'str_group_ID'.localized(),
                  subTitle: _groupDBInfo?.groupId ?? '',
                  isShowMoreIcon: false,
                ),
                GroupItemBuild(
                  title: 'group_name'.localized(),
                  subTitle: _groupDBInfo?.name ?? '',
                  isShowMoreIcon: _hasEditMetadataPermission,
                  onTap: _hasEditMetadataPermission ? _changeGroupNameFn : null,
                ),
                GroupItemBuild(
                  title: 'description'.localized(),
                  titleDes: _groupDBInfo?.about ?? '',
                  isShowMoreIcon: _hasEditMetadataPermission,
                  isShowDivider: false,
                  onTap: _showGroupAboutFn,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.px),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.px),
              color: ThemeColor.color180,
            ),
            child: GroupItemBuild(
              title: Localized.text('ox_chat.group_qr_code'),
              actionWidget: CommonImage(
                iconName: 'qrcode_icon.png',
                width: Adapt.px(24),
                height: Adapt.px(24),
                useTheme: true,
              ),
              isShowDivider: false,
              onTap: () {
                OXNavigator.pushPage(
                  context,
                      (context) => RelayGroupQrcodePage(groupId: _groupDBInfo?.groupId ?? ''),
                );
              },
            ),
          ),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px, vertical: 12.px)),
    );
  }

  Widget _buildHeader() {
    Widget placeholderImage = CommonImage(
      iconName: 'icon_group_default.png',
      fit: BoxFit.fill,
      size: 56.px,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(56.px),
      child: OXCachedNetworkImage(
        errorWidget: (context, url, error) => placeholderImage,
        placeholder: (context, url) => placeholderImage,
        fit: BoxFit.fill,
        imageUrl: _avatarAliyunUrl,
        width: 56.px,
        height: 56.px,
      ),
    );
  }

  void _changeGroupNameFn() {
    OXNavigator.pushPage(context, (context) => RelayGroupEditPage(groupId: widget.groupId, pageType: EGroupEditType.groupName)).then((value){
      if(value!=null && value is bool){
        setState(() {
          _loadData();
        });
      }
    });
  }

  void _showGroupAboutFn() {
    OXNavigator.pushPage(
        context, (context) => RelayGroupEditPage(groupId: widget.groupId, pageType: EGroupEditType.about))
        .then((value) {
      if (value != null && value is bool) {
        setState(() {
          _loadData();
        });
      }
    });
  }

  void _handleImageSelection() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    bool storagePermission = false;
    File? _imgFile;
    if (Platform.isAndroid && (await plugin.androidInfo).version.sdkInt >= 34) {
      Map<String, bool> result = await OXCommon.request34MediaPermission(1);
      bool readMediaImagesGranted = result['READ_MEDIA_IMAGES'] ?? false;
      bool readMediaVisualUserSelectedGranted = result['READ_MEDIA_VISUAL_USER_SELECTED'] ?? false;
      if (readMediaImagesGranted) {
        storagePermission = true;
      } else if (readMediaVisualUserSelectedGranted) {
        final filePaths = await OXCommon.select34MediaFilePaths(1);
        _imgFile = File(filePaths[0]);
        _uploadAndRefresh(_imgFile);
      }
    } else {
      storagePermission = await PermissionUtils.getPhotosPermission();
    }
    if (storagePermission) {
      final res = await ImagePickerUtils.pickerPaths(
        galleryMode: GalleryMode.image,
        selectCount: 1,
        showGif: false,
        compressSize: 2048,
      );
      _imgFile = (res[0].path == null) ? null : File(res[0].path ?? '');
      _uploadAndRefresh(_imgFile);
    } else {
      CommonToast.instance.show(context, Localized.text('ox_common.str_grant_permission_photo_hint'));
      return;
    }
  }

  void _uploadAndRefresh(File? imgFile) async {
    if (imgFile != null) {
      await OXLoading.show();
      final String url = await UplodAliyun.uploadFileToAliyun(
        fileType: UplodAliyunType.imageType,
        file: imgFile,
        filename: _groupDBInfo?.name ?? '' +
            DateTime.now().microsecondsSinceEpoch.toString() +
            '_avatar01.png',
      );
      await OXLoading.dismiss();
      if (url.isNotEmpty) {
        OKEvent event = await RelayGroup.sharedInstance.editMetadata(widget.groupId, _groupDBInfo?.name??'', _groupDBInfo?.about??'', _avatarAliyunUrl, '');
        if (!event.status) {
          CommonToast.instance.show(context, event.message);
          return;
        }
        if (mounted) {
          setState(() {
            _avatarAliyunUrl = url;
          });
        }
      }
    }
  }
}

class RelayGroupBaseInfoView extends StatelessWidget {
  final String? groupId;
  final GestureTapCallback? groupQrCodeFn;

  RelayGroupBaseInfoView({this.groupId, this.groupQrCodeFn});

  @override
  Widget build(BuildContext context) {
    RelayGroupDB? relayGroup = RelayGroup.sharedInstance.myGroups[groupId];
    return Container(
      width: double.infinity,
      height: 80.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.px),
        color: ThemeColor.color180,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 12.px),
      child: Row(
        children: [
          OXRelayGroupAvatar(
            relayGroup: relayGroup,
            size: 56.px,
          ),
          SizedBox(width: 10.px),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(relayGroup?.name ?? '', 16.sp, ThemeColor.color0, fontWeight: FontWeight.w400),
                if (relayGroup != null && relayGroup!.relayPubkey.isNotEmpty) SizedBox(height: 2.px),
                if (relayGroup != null && relayGroup!.relayPubkey.isNotEmpty)
                  MyText(relayGroup?.relayPubkey ?? '', 14.sp, ThemeColor.color100,
                      fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          SizedBox(width: 10.px),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: groupQrCodeFn,
            child: CommonImage(
              iconName: 'qrcode_icon.png',
              width: Adapt.px(24),
              height: Adapt.px(24),
              useTheme: true,
            ),
          ),
          CommonImage(
            iconName: 'icon_arrow_more.png',
            width: Adapt.px(24),
            height: Adapt.px(24),
          )
        ],
      ),
    );
  }
}

class GroupItemBuild extends StatelessWidget {
  final String? title;
  final String? titleDes;
  final String? subTitle;
  String? subTitleIcon;
  bool isShowMoreIcon;
  bool isShowDivider;
  final Widget? actionWidget;
  final GestureTapCallback? onTap;

  GroupItemBuild({
    this.title,
    this.titleDes,
    this.subTitle,
    this.subTitleIcon,
    this.isShowMoreIcon = true,
    this.isShowDivider = true,
    this.actionWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap != null ? onTap : () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16.px,
            ),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 12.px,
            ),
            // height: Adapt.px(52),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // margin: EdgeInsets.only(left: Adapt.px(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        style: TextStyle(
                          color: ThemeColor.color0,
                          fontSize: 16.px,
                        ),
                      ),
                      titleDes != null
                          ? Container(
                              width: Adapt.screenW() - 104.px,
                              margin: EdgeInsets.only(
                                top: 4.px,
                              ),
                              child: Text(
                                titleDes ?? '',
                                style: TextStyle(
                                  fontSize: 14.px,
                                  fontWeight: FontWeight.w400,
                                  color: ThemeColor.color100,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      actionWidget ?? SizedBox(),
                      subTitle != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (subTitleIcon != null)
                                  CommonImage(
                                      iconName: subTitleIcon ?? '', size: 24.px, package: OXChatInterface.moduleName),
                                MyText(subTitle ?? '', 14.sp, ThemeColor.color100, fontWeight: FontWeight.w400)
                              ],
                            )
                          : SizedBox(),
                      isShowMoreIcon
                          ? CommonImage(
                              iconName: 'icon_arrow_more.png',
                              size: 24.px,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isShowDivider,
            child: Divider(
              height: 0.5.px,
              color: ThemeColor.color160,
            ),
          ),
        ],
      ),
    );
  }
}
