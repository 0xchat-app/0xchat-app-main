import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/badge_model.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_chat/page/session/chat_group_message_page.dart';
import 'package:ox_common/utils/uplod_aliyun_utils.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_chat/widget/badge_selector_dialog.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/utils/permission_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:nostr_core_dart/nostr.dart';

enum ChannelCreateType { create, edit }

class ChatChannelCreate extends StatefulWidget {
  ChannelDB? channelDB;
  ChannelCreateType? channelCreateType;

  ChatChannelCreate(
      {Key? key,
      this.channelDB,
      this.channelCreateType = ChannelCreateType.create})
      : super(key: key);

  @override
  State<ChatChannelCreate> createState() => _ChatChannelCreateState();
}

class _ChatChannelCreateState extends State<ChatChannelCreate> {
  late TextEditingController _channelNameController;

  late TextEditingController _descriptionController;

  bool _isNone = true;

  late BadgeModel _requirementModel;
  List<BadgeModel> _badgeModelList = [];

  String _avatarAliyunUrl = '';

  @override
  void initState() {
    _channelNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _requirementModel = BadgeModel();
    _requestBadges().then((value) {
      _initEditChannelBadgeData();
    });
    if (widget.channelCreateType == ChannelCreateType.edit &&
        widget.channelDB != null) {
      _initEditChannelData();
    }
    super.initState();
  }

  Future<void> _requestBadges() async {
    _badgeModelList =
        await BadgeModel.getDefaultBadge(context: context, showLoading: false);
  }

  void _initEditChannelData() {
    _channelNameController.text = widget.channelDB!.name!;
    _descriptionController.text = widget.channelDB!.about!;
    _avatarAliyunUrl = widget.channelDB?.picture ?? '';
  }

  void _initEditChannelBadgeData() {
    List<String> badgeIds =
        _badgeModelList.map((badgeModel) => badgeModel.badgeId!).toList();
    int index = -1;
    try {
      String badgeId =
          List<String>.from(jsonDecode(widget.channelDB?.badges ?? '')).first;
      index = badgeIds.indexOf(badgeId);
    } catch (_) {}
    setState(() {
      _isNone = index == -1;
      if (!_isNone) {
        _requirementModel = _badgeModelList[index];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: widget.channelCreateType == ChannelCreateType.create
            ? "New Channel"
            : "Edit Channel",
        actions: [
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: Adapt.px(24)),
              child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        ThemeColor.gradientMainEnd,
                        ThemeColor.gradientMainStart,
                      ],
                    ).createShader(Offset.zero & bounds.size);
                  },
                  child: widget.channelCreateType == ChannelCreateType.create
                      ? Text("Create")
                      : Text("Done")),
            ),
            onTap: () {
              _createChannel();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Adapt.px(28),
            ),
            _buildHeader(),
            SizedBox(
              height: Adapt.px(12),
            ),
            _listItem("Channel Name",
                childView: _buildTextEditing(
                    controller: _channelNameController,
                    hintText: 'satoshi',
                    maxLines: 1)),
            _listItem("Badge Requirements",
                childView: _buildRequirementWidget()),
            _listItem("Description",
                childView: _buildTextEditing(
                    controller: _descriptionController,
                    hintText:
                        'Creator(s) of Bitcoin.\nAbsolute legend. (Optional)',
                    maxLines: null)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String localAvatarPath = 'assets/images/icon_default_channel.png';
    Image placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.fill,
      width: Adapt.px(100),
      height: Adapt.px(100),
      package: 'ox_chat',
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _handleImageSelection();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Adapt.px(100)),
        child: CachedNetworkImage(
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
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
      child: Column(
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
      ),
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
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            Adapt.px(16),
          ),
        ),
        color: Color.fromRGBO(36, 37, 42, 1),
      ),
      height: height,
      child: TextField(
        // focusNode: _focusNode,
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText ?? "Please enter...",
          hintStyle: TextStyle(
              color: Color.fromRGBO(123, 127, 143, 1),
              fontWeight: FontWeight.w400,
              fontSize: Adapt.px(16)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildRequirementWidget() {
    Image placeholderImage = Image.asset(
      'assets/images/icon_badge_default.png',
      fit: BoxFit.cover,
      width: Adapt.px(32),
      height: Adapt.px(32),
      package: 'ox_common',
    );

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Only users who have met the badge requirements are authorized to send messages.',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: Adapt.px(14),
                color: ThemeColor.color100),
            maxLines: 2,
          ),
        ),
        SizedBox(
          height: Adapt.px(8),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(16),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                Adapt.px(16),
              ),
            ),
            color: Color.fromRGBO(36, 37, 42, 1),
          ),
          height: Adapt.px(48),
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Row(
              children: [
                _isNone
                    ? Text("None")
                    : Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: _requirementModel.badgeImageUrl ?? '',
                            fit: BoxFit.contain,
                            placeholder: (context, url) => placeholderImage,
                            errorWidget: (context, url, error) =>
                                placeholderImage,
                            width: Adapt.px(32),
                            height: Adapt.px(32),
                          ),
                          SizedBox(
                            width: Adapt.px(6),
                          ),
                          Text(
                            _requirementModel.badgeName ??
                                'Badge Name and above',
                            style: TextStyle(
                              fontSize: Adapt.px(16),
                              fontWeight: FontWeight.w400,
                              color: ThemeColor.color0,
                            ),
                          ),
                        ],
                      ),
                Spacer(),
                CommonImage(
                  iconName: 'icon_badge_arrow_down.png',
                  width: Adapt.px(24),
                  height: Adapt.px(24),
                  package: 'ox_chat',
                ),
              ],
            ),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              var result = await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return BadgeSelectorDialog(_badgeModelList);
                },
              );

              if (result != null) {
                if (result is BadgeModel) {
                  setState(() {
                    _isNone = false;
                    _requirementModel = result;
                  });
                } else {
                  setState(() {
                    _isNone = true;
                  });
                }
              }
            },
          ),
        ),
      ],
    );
  }

  void _createChannel() async {
    if (_channelNameController.text.isEmpty) {
      CommonToast.instance.show(context, "Please enter Channel Name!");
      return;
    }
    if (_avatarAliyunUrl.isEmpty) {
      CommonToast.instance.show(context, "Please set Avatar!");
    }
    OXLoading.show();
    final badgeId = _requirementModel.badgeId;
    List<String> requirementBadgeIdList = [];
    if (badgeId != null && badgeId.isNotEmpty) {
      requirementBadgeIdList.add(badgeId);
    }

    if (widget.channelCreateType == ChannelCreateType.create) {
      final ChannelDB? channelDB = await Channels.sharedInstance.createChannel(
        _channelNameController.text,
        _descriptionController.text,
        _avatarAliyunUrl,
        requirementBadgeIdList,
        'wss://relay.0xchat.com',
      );
      OXLoading.dismiss();
      if (channelDB != null) {
        OXChatBinding.sharedInstance.createChannelSuccess(channelDB);
        OXNavigator.pushReplacement(
          context,
          ChatGroupMessagePage(
            communityItem: ChatSessionModel(
              chatId: channelDB.channelId!,
              groupId: channelDB.channelId!,
              chatType: ChatType.chatChannel,
              chatName: channelDB.name!,
              createTime: channelDB.createTime!,
              avatar: channelDB.picture!,
            ),
          ),
        );
      } else {
        CommonToast.instance
            .show(context, 'Failed to create, please try again later');
      }
    } else {
      widget.channelDB?.name = _channelNameController.text;
      widget.channelDB?.about = _descriptionController.text;
      widget.channelDB?.picture = _avatarAliyunUrl;
      widget.channelDB?.badges = requirementBadgeIdList.toString();

      OKEvent okEvent =
          await Channels.sharedInstance.setChannel(widget.channelDB!);
      OXLoading.dismiss();
      if (okEvent.status) {
        await CommonToast.instance.show(context, 'channel update success');
        OXNavigator.pop(context);
        OXNavigator.pop(context);
      } else {
        CommonToast.instance
            .show(context, 'Failed to update channel, please try again later');
      }
    }
  }

  void _handleImageSelection() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera, Permission.storage].request();
    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.storage]!.isGranted) {
      File? _imgFile = await ImagePickerUtils.getImageFromGallery();
      if (_imgFile != null) {
        final String url = await UplodAliyun.uploadFileToAliyun(
          fileType: UplodAliyunType.imageType,
          file: _imgFile,
          filename: _channelNameController.text +
              DateTime.now().microsecondsSinceEpoch.toString() +
              '_avatar01.png',
        );
        if (url.isNotEmpty) {
          if (mounted) {
            setState(() {
              _avatarAliyunUrl = url;
            });
          }
        }
      }
    } else {
      PermissionUtils.showPermission(context, statuses);
    }
  }
}
