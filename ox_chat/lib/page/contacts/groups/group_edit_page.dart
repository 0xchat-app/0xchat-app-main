import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

enum EGroupEditType { groupName, notice }

extension EGroupEditTypeStr on EGroupEditType {
  String get title {
    switch (this) {
      case EGroupEditType.groupName:
        return Localized.text('ox_chat.edit_group_name');
      case EGroupEditType.notice:
        return Localized.text('ox_chat.edit_group_notice');
    }
  }

  String get subTitle {
    switch (this) {
      case EGroupEditType.groupName:
        return Localized.text('ox_chat.group_name_item');
      case EGroupEditType.notice:
        return Localized.text('ox_chat.group_notice');
    }
  }

  String get hintText {
    switch (this) {
      case EGroupEditType.groupName:
        return Localized.text('ox_chat.edit_group_name_hint');
      case EGroupEditType.notice:
        return Localized.text('ox_chat.edit_group_notice_hint');
    }
  }
}

class GroupEditPage extends StatefulWidget {
  final EGroupEditType pageType;
  final String groupId;

  GroupEditPage({required this.pageType, required this.groupId});
  @override
  _GroupEditPageState createState() => new _GroupEditPageState();
}

class _GroupEditPageState extends State<GroupEditPage> {
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _groupNoticeController = TextEditingController();

  bool _isShowDelete = false;

  GroupDB? groupDBInfo = null;

  @override
  void initState() {
    super.initState();
    _groupInfoInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _groupInfoInit() async {
    GroupDB? groupDB = await Groups.sharedInstance.myGroups[widget.groupId];

    if (groupDB != null) {
      groupDBInfo = groupDB;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: Adapt.px(24),
              ),
              child: Text(
                widget.pageType.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Adapt.px(24),
                  fontWeight: FontWeight.w600,
                  color: ThemeColor.color0,
                ),
              ),
            ),
            _EditGroupInfoWidget(),
          ],
        ),
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
              fontSize: Adapt.px(16),
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _EditGroupInfoWidget() {
    EGroupEditType type = widget.pageType;
    return Container(
      padding: EdgeInsets.only(
        top: Adapt.px(24),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: Adapt.px(30),
      ),
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
            height: type == EGroupEditType.notice ? Adapt.px(110) : null,
          )
        ],
      ),
    );
  }

  String _getTextHintText() {
    String textHint = '';
    switch (widget.pageType) {
      case EGroupEditType.groupName:
        textHint = groupDBInfo?.name ?? '';
        break;
      case EGroupEditType.notice:
        textHint = groupDBInfo?.pinned?[0] ?? '';
        break;
    }
    return textHint.isEmpty ? widget.pageType.hintText : textHint;
  }

  TextEditingController _getTextController() {
    switch (widget.pageType) {
      case EGroupEditType.groupName:
        return _groupNameController;
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
            color: ThemeColor.color0,
            fontSize: Adapt.px(15),
          ),
          suffixIcon: _delTextIconWidget(controller),
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
    }
  }

  void _updateGroupName() async {
    String groupNameContent = _groupNameController.text;
    if (groupNameContent.isEmpty) {
      CommonToast.instance.show(context, Localized.text('ox_chat.edit_group_name_not_empty_toast'));
    }
    OKEvent event = await Groups.sharedInstance
        .updatePrivateGroupName(OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey, widget.groupId, groupNameContent);
    if (!event.status) {
      CommonToast.instance.show(context, event.message);
      return;
    }
    OXNavigator.pop(context, true);
  }

  void _updateGroupNotice() async {
    String groupNoticeContent = _groupNoticeController.text;
    if (groupNoticeContent.isEmpty)
      return CommonToast.instance.show(context, Localized.text('ox_chat.edit_group_notice_not_empty_toast'));
    OKEvent event = await Groups.sharedInstance
        .updateGroupPinned(widget.groupId, '${Localized.text('ox_chat.pin')}: \"$groupNoticeContent\"', groupNoticeContent);
    if (!event.status) return CommonToast.instance.show(context, event.message);
    OXNavigator.pop(context, true);
  }
}
