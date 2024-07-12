import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ox_chat/model/option_model.dart';
import 'package:ox_chat/page/contacts/contact_relay_page.dart';
import 'package:ox_chat/page/session/chat_relay_group_msg_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/ox_common.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/permission_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:device_info/device_info.dart';


///Title: relay_group_create_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/7/1 16:59
class RelayGroupCreatePage extends StatefulWidget {
  final GroupType groupType;

  const RelayGroupCreatePage({
    super.key,
    required this.groupType,
  });

  @override
  State<StatefulWidget> createState() {
    return _RelayGroupCreatePageState();
  }
}

class _RelayGroupCreatePageState extends State<RelayGroupCreatePage> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _chatRelay = Relays.sharedInstance.recommendGroupRelays.first;
  String _avatarAliyunUrl = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_chat.str_new_group'),
        actions: [
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 24.px),
              child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        ThemeColor.gradientMainEnd,
                        ThemeColor.gradientMainStart,
                      ],
                    ).createShader(Offset.zero & bounds.size);
                  },
                  child: Text(Localized.text('ox_common.create'), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),)),
            ),
            onTap: () {
              _createGroup();
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.px),
          child: Column(
            children: [
              SizedBox(height: 28.px),
              _buildHeader(),
              SizedBox(height: 16.px),
              _listItem('group_name_item'.localized(),
                  childView: _buildTextEditing(
                      controller: _groupNameController,
                      hintText: 'group_enter_hint_text'.localized(),
                      maxLines: 1)),
              SizedBox(height: 16.px),
              _listItem(Localized.text('ox_chat.description'),
                  childView: _buildTextEditing(
                      controller: _descriptionController,
                      hintText:
                      Localized.text('ox_chat.description_hint_text'),
                      maxLines: null)),
              SizedBox(height: 16.px),
              _buildGroupRelayEditText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    Widget placeholderImage = CommonImage(
      iconName: 'icon_default_channel.png',
      fit: BoxFit.fill,
      width: Adapt.px(100),
      height: Adapt.px(100),
      package: 'ox_chat',
      useTheme: true,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _handleImageSelection();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Adapt.px(100)),
        child: OXCachedNetworkImage(
          errorWidget: (context, url, error) => placeholderImage,
          placeholder: (context, url) => placeholderImage,
          fit: BoxFit.fill,
          imageUrl: _avatarAliyunUrl,
          width: Adapt.px(100),
          height: Adapt.px(100),
        ),
      ),
    );
  }
  Widget _listItem(String label, {Widget? childView}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w600,
            // height: Adapt.px(22.4),
          ),
        ),
        SizedBox(
          height: Adapt.px(12),
        ),
        childView ?? Container(),
        SizedBox(
          height: Adapt.px(12),
        ),
      ],
    );
  }

  Widget _buildTextEditing({
    String? hintText,
    required TextEditingController controller,
    double? height,
    int? maxLines,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.px),
        color: ThemeColor.color180,
      ),
      height: height,
      child: TextField(
        // focusNode: _focusNode,
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText ?? Localized.text('ox_chat.confirm_join_dialog_hint'),
          hintStyle: TextStyle(
              color: ThemeColor.color160,
              fontWeight: FontWeight.w400,
              fontSize: Adapt.px(16)),
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: Adapt.px(16),
          fontWeight: FontWeight.w600,
          height: Adapt.px(22.4) / Adapt.px(16),
          color: ThemeColor.color0,
        ),
      ),
    );
  }

  Widget _buildGroupRelayEditText() {
    return _labelWidget(
      title: Localized.text('ox_chat.relay'),
      content: _chatRelay,
      onTap: () async {
        var result = await OXNavigator.presentPage(context, (context) => ContactRelayPage(defaultRelayList: Relays.sharedInstance.recommendGroupRelays));
        if (result != null) {
          _chatRelay = result as String;
          setState(() {});
        }
      },
    );
  }

  Widget _labelWidget({
    required String title,
    required String content,
    required GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Adapt.px(52),
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Adapt.px(16),
                fontWeight: FontWeight.w400,
                color: ThemeColor.color0,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _ellipsisText(content),
                    style: TextStyle(
                      fontSize: Adapt.px(16),
                      fontWeight: FontWeight.w400,
                      color: ThemeColor.color100,
                    ),
                  ),
                  CommonImage(
                    iconName: 'icon_arrow_more.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _ellipsisText(String text) {
    if (text.length > 30) {
      return text.substring(0, 10) + '...' + text.substring(text.length - 10, text.length);
    }
    return text;
  }

  Widget _buildItem({required String itemName, required Widget itemContent}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemName,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: Adapt.px(16),
            color: ThemeColor.color0,
          ),
        ),
        SizedBox(
          height: Adapt.px(12),
        ),
        itemContent,
      ],
    ).setPadding(EdgeInsets.only(bottom: Adapt.px(12)));
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
        filename: _groupNameController.text +
            DateTime.now().microsecondsSinceEpoch.toString() +
            '_avatar01.png',
      );
      await OXLoading.dismiss();
      if (url.isNotEmpty) {
        if (mounted) {
          setState(() {
            _avatarAliyunUrl = url;
          });
        }
      }
    }
  }

  Future<void> _createGroup() async {
    String name = _groupNameController.text;
    if (name.isEmpty) {
      CommonToast.instance.show(context, Localized.text("ox_chat.group_enter_hint_text"));
      return;
    }
    ;
    await OXLoading.show();
    if (widget.groupType == GroupType.openGroup || widget.groupType == GroupType.closeGroup) {
      var uri = Uri.parse(_chatRelay);
      var hostWithPort = uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
      RelayGroupDB? relayGroupDB = await RelayGroup.sharedInstance.createGroup(
        _chatRelay,
        name: name,
        picture: _avatarAliyunUrl,
        about: _descriptionController.text,
        closed: widget.groupType == GroupType.closeGroup ? true : false,
      );
      await OXLoading.dismiss();
      if (relayGroupDB != null) {
        OXNavigator.pushReplacement(
          context,
          ChatRelayGroupMsgPage(
            communityItem: ChatSessionModel(
              chatId: relayGroupDB.groupId,
              groupId: relayGroupDB.groupId,
              chatType: ChatType.chatRelayGroup,
              chatName: relayGroupDB.name,
              createTime: relayGroupDB.lastUpdatedTime,
              avatar: relayGroupDB.picture,
            ),
          ),
        );
      } else {
        CommonToast.instance.show(context, Localized.text('ox_chat.create_group_fail_tips'));
      }
    }
  }
}
