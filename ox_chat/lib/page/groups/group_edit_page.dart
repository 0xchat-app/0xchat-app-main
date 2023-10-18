import 'dart:io';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum EGroupEditType { remark, alias, groupName,notice }

extension EGroupEditTypeStr on EGroupEditType {
  String get title {
    switch (this) {
      case EGroupEditType.remark:
        return 'Edit Remark';
      case EGroupEditType.alias:
        return 'My Alias in Group';
      case EGroupEditType.groupName:
        return 'Edit Group Name';
      case EGroupEditType.notice:
        return 'Edit Group Notice';
    }
  }

  String get subTitle {
    switch (this) {
      case EGroupEditType.remark:
        return 'Remark';
      case EGroupEditType.alias:
        return 'My Alias';
      case EGroupEditType.groupName:
        return 'Group Name';
      case EGroupEditType.notice:
        return 'Group Notice';
    }
  }


  String get hintText {
    switch (this) {
      case EGroupEditType.remark:
        return 'satoshi';
      case EGroupEditType.alias:
        return 'satoshi';
      case EGroupEditType.groupName:
        return 'This is Group Name';
      case EGroupEditType.notice:
        return 'This is Group Name';
    }
  }


}

class GroupEditPage extends StatefulWidget {
  final EGroupEditType pageType;

  GroupEditPage({required this.pageType});
  @override
  _GroupEditPageState createState() => new _GroupEditPageState();
}

class _GroupEditPageState extends State<GroupEditPage> {

  TextEditingController _remarkController = TextEditingController();
  TextEditingController _aliasController = TextEditingController();
  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _noticeNameController = TextEditingController();

  bool _isShowDelete = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            _EditGroupName(),
          ],
        ),
      ),
    );
  }

  Widget _appBarActionWidget() {
    return GestureDetector(
      onTap: () { },
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
            'Done',
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


  Widget _EditGroupName() {
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
              hintText: type.hintText,
              maxLines: null,
            height: type == EGroupEditType.notice ? Adapt.px(110) : null,
          )
        ],
      ),
    );
  }

  TextEditingController _getTextController(){
    switch(widget.pageType){
      case EGroupEditType.remark:
        return _remarkController;
      case EGroupEditType.alias:
        return _aliasController;
      case EGroupEditType.groupName:
        return _groupNameController;
      case EGroupEditType.notice:
        return _noticeNameController;
    }
  }


  Widget _buildTextEditing({
    String? hintText,
    required TextEditingController controller,
    double? height,
    int? maxLines,
  }) {
    return Container(
      // alignment: Alignment.center,
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
          hintText: hintText ?? "Please enter...",
          hintStyle: TextStyle(
            color: ThemeColor.color100,
            fontSize: Adapt.px(15),
          ),
          suffixIcon:_delTextIconWidget(controller),
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
}
