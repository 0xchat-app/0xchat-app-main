import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:flutter/services.dart';
import 'package:chatcore/chat-core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'group_edit_page.dart';

class GroupNoticePage extends StatefulWidget {
  final String groupId;

  GroupNoticePage({required this.groupId});

  @override
  _GroupNoticePageState createState() => new _GroupNoticePageState();
}

class _GroupNoticePageState extends State<GroupNoticePage> {
  GroupDB? groupDBInfo = null;

  String get _getGroupNotice {
    String groupNotice = groupDBInfo?.pinned?[0] ?? '';
    return groupNotice.isEmpty ? Localized.text('ox_chat.group_notice_default_hint') : groupNotice;
  }

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
    if (groupDB == null) return;
    setState(() {
      groupDBInfo = groupDB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_chat.group_notice'),
        backgroundColor: ThemeColor.color190,
        actions: [
          _appBarActionWidget(),
          SizedBox(
            width: Adapt.px(24),
          ),
        ],
      ),
      body: _EditGroupName(),
    );
  }

  Widget _appBarActionWidget() {
    return GestureDetector(
      onTap: () async {
        bool? result = await OXNavigator.pushPage(
          context,
          (context) => GroupEditPage(
              pageType: EGroupEditType.notice, groupId: widget.groupId),
        );
        if (result != null && result) _groupInfoInit();
      },
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
            Localized.text('ox_common.edit'),
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
    Widget placeholderImage = CommonImage(
      iconName: 'user_image.png',
      width: Adapt.px(76),
      height: Adapt.px(76),
    );
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Adapt.px(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: Adapt.px(48),
                margin: EdgeInsets.symmetric(
                  vertical: Adapt.px(24),
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
                        borderRadius: BorderRadius.circular(Adapt.px(48)),
                        child: CachedNetworkImage(
                          imageUrl: groupDBInfo?.picture ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => placeholderImage,
                          errorWidget: (context, url, error) =>
                              placeholderImage,
                          width: Adapt.px(76),
                          height: Adapt.px(76),
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
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Adapt.px(16),
              vertical: Adapt.px(12),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Adapt.px(16),
                ),
              ),
              color: ThemeColor.color180,
            ),
            height: Adapt.px(110),
            child: Text(
              _getGroupNotice,
              style: TextStyle(
                color: ThemeColor.color0,
                fontWeight: FontWeight.w400,
                fontSize: Adapt.px(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _dealWithGroupId {
    String groupId = widget.groupId;
    return groupId.substring(0,5) + '...' +  groupId.substring(groupId.length - 5);
  }

}
