import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

enum EGroupEditType { groupName, notice, about }

extension EGroupEditTypeStr on EGroupEditType {
  String get title {
    switch (this) {
      case EGroupEditType.groupName:
        return Localized.text('ox_chat.edit_group_name');
      case EGroupEditType.notice:
        return Localized.text('ox_chat.edit_group_notice');
      case EGroupEditType.about:
        return Localized.text('ox_chat.str_edit_group_about');
    }
  }

  String get subTitle {
    switch (this) {
      case EGroupEditType.groupName:
        return Localized.text('ox_chat.group_name_item');
      case EGroupEditType.notice:
        return Localized.text('ox_chat.group_notice');
      case EGroupEditType.about:
        return Localized.text('ox_chat.str_group_about');
    }
  }

  String get hintText {
    switch (this) {
      case EGroupEditType.groupName:
        return Localized.text('ox_chat.edit_group_name_hint');
      case EGroupEditType.notice:
        return Localized.text('ox_chat.edit_group_notice_hint');
      case EGroupEditType.about:
        return Localized.text('ox_chat.str_edit_group_about_hint');
    }
  }
}

class RelayGroupEditPage extends StatefulWidget {
  final EGroupEditType pageType;
  final String groupId;

  RelayGroupEditPage({required this.pageType, required this.groupId});

  @override
  State<StatefulWidget> createState() => new _RelayGroupEditPageState();
}

class _RelayGroupEditPageState extends State<RelayGroupEditPage> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _groupAboutController = TextEditingController();
  TextEditingController _groupNoticeController = TextEditingController();

  bool _isShowDelete = false;
  bool _hasEditMetadataPermission = false;

  RelayGroupDB? _groupDBInfo = null;

  @override
  void initState() {
    super.initState();
    _groupInfoInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _groupInfoInit() {
    RelayGroupDB? groupDB = RelayGroup.sharedInstance.myGroups[widget.groupId];

    if (groupDB != null) {
      _groupDBInfo = groupDB;
      _groupNameController.text = _groupDBInfo?.name ?? '';
      _groupAboutController.text = _groupDBInfo?.about ?? '';
      UserDBISAR? myUserDB = OXUserInfoManager.sharedInstance.currentUserInfo;
      if (myUserDB != null) {
        _hasEditMetadataPermission = RelayGroup.sharedInstance.hasPermissions(
            groupDB.admins ?? [], myUserDB.pubKey, [GroupActionKind.editMetadata]);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: widget.pageType.title,
        backgroundColor: ThemeColor.color190,
        actions: [
          if(_hasEditMetadataPermission) _appBarActionWidget(),
          SizedBox(
            width: Adapt.px(24),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: _EditGroupInfoWidget(),
      ),
    );
  }

  Widget _appBarActionWidget() {
    return GestureDetector(
      onTap: _submitFn,
      child: Center(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                ThemeColor.gradientMainEnd,
                ThemeColor.gradientMainStart,
              ],
            ).createShader(Offset.zero & bounds.size);
          },
          child: Text(
            Localized.text('ox_common.complete'),
            style: TextStyle(
              fontSize: 16.px,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _EditGroupInfoWidget() {
    EGroupEditType type = widget.pageType;
    return Container(
      margin: EdgeInsets.only(top: 24.px),
      padding: EdgeInsets.symmetric(horizontal: 30.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: Adapt.px(12),
            ),
            child: Text(
              type.subTitle,
              style: TextStyle(
                fontSize: Adapt.px(16),
                fontWeight: FontWeight.w400,
                color: ThemeColor.color0,
              ),
            ),
          ),
          _buildTextEditing(
            controller: _getTextController(),
            hintText: _getTextHintText(),
            maxLines: null,
            height: type == EGroupEditType.about ? Adapt.px(110) : null,
          )
        ],
      ),
    );
  }

  String _getTextHintText() {
    return widget.pageType.hintText;
  }

  TextEditingController _getTextController() {
    switch (widget.pageType) {
      case EGroupEditType.groupName:
        return _groupNameController;
      case EGroupEditType.about:
        return _groupAboutController;
      case EGroupEditType.notice:
        return _groupNoticeController;
    }
  }

  Widget _buildTextEditing({
    String? hintText,
    required TextEditingController controller,
    double? height,
    int? maxLines,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            Adapt.px(16),
          ),
        ),
        color: ThemeColor.color180,
      ),
      height: height,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText ?? Localized.text('ox_chat.confirm_join_dialog_hint'),
          hintStyle: TextStyle(
            color: ThemeColor.color100,
            fontSize: 14.px,
          ),
          suffixIcon: _delTextIconWidget(controller),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        readOnly: !_hasEditMetadataPermission,
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
    );
  }

  Widget? _delTextIconWidget(TextEditingController controller) {
    if (!_isShowDelete) return null;
    return IconButton(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onPressed: () {
        setState(() {
          _isShowDelete = false;
          controller.text = '';
        });
      },
      icon: CommonImage(
        iconName: 'icon_textfield_close.png',
        width: Adapt.px(16),
        height: Adapt.px(16),
      ),
    );
  }

  void _submitFn() {
    switch (widget.pageType) {
      case EGroupEditType.groupName:
        return _updateGroupName();
      case EGroupEditType.notice:
        return _updateGroupNotice();
      case EGroupEditType.about:
        return _updateGroupAbout();
    }
  }

  void _updateGroupName() async {
    String groupNameContent = _groupNameController.text;
    if (groupNameContent.isEmpty) {
      CommonToast.instance.show(context, Localized.text('ox_chat.edit_group_name_not_empty_toast'));
    }
    OKEvent event = await RelayGroup.sharedInstance
        .editMetadata(widget.groupId, groupNameContent, _groupDBInfo?.about ?? '', _groupDBInfo?.picture ?? '', '');
    if (!event.status) {
      CommonToast.instance.show(context, event.message);
      return;
    }
    OXChatBinding.sharedInstance.relayGroupsUpdatedCallBack();
    OXNavigator.pop(context, true);
  }

  void _updateGroupAbout() async {
    String groupAboutContent = _groupAboutController.text;
    if (groupAboutContent.isEmpty)
      return CommonToast.instance.show(context, Localized.text('ox_chat.edit_group_notice_not_empty_toast'));
    OKEvent event = await RelayGroup.sharedInstance.editMetadata(
        widget.groupId, _groupDBInfo?.name ?? '', groupAboutContent, _groupDBInfo?.picture ?? '', '');
    if (!event.status) return CommonToast.instance.show(context, event.message);
    OXNavigator.pop(context, true);
  }

  void _updateGroupNotice() async {
    //TODO future need function
  }
}
