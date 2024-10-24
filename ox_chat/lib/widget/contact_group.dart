import 'dart:async';
import 'dart:io';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:ox_chat/model/group_ui_model.dart';
import 'package:ox_chat/page/session/chat_channel_message_page.dart';
import 'package:ox_chat/page/session/chat_group_message_page.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/page/session/chat_relay_group_msg_page.dart';
import 'package:ox_chat/utils/chat_session_utils.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/alpha.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

double headerHeight = Adapt.px(24);
double itemHeight = Adapt.px(68.0);

typedef void CursorGroupsChanged(Widget cursor, int noteLength);

class GroupContact extends StatefulWidget {
  final List<GroupUIModel> data;
  final bool shrinkWrap;
  ScrollPhysics? physics;
  final Widget? topWidget;

  GroupContact({
    Key? key,
    required this.data,
    this.shrinkWrap = false,
    this.physics,
    this.topWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GroupContactState();
  }
}

class Note {
  String tag;
  List<GroupUIModel> childList;

  Note(this.tag, this.childList);
}

class GroupContactState extends State<GroupContact> {
  ScrollController scrollController = ScrollController();
  List<String> indexTagList = [];
  late List<GroupUIModel> groupList;
  int defaultIndex = 0;

  List<Note> noteList = [];

  String _tagName = '';
  bool _isTouchTagBar = false;

  List<GroupUIModel> selectedList = [];
  Map<String, List<GroupUIModel>> mapData = Map();
  bool addAutomaticKeepAlives = true;
  bool addRepaintBoundaries = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      addAutomaticKeepAlives = false;
      addRepaintBoundaries = false;
    }
    groupList = widget.data;
    _initIndexBarData();
    scrollController.addListener(() {
      double position = scrollController.offset.toDouble();
      int index = _computerIndex(position);
      defaultIndex = index;
    });
  }

  void updateContactData(List<GroupUIModel> data) {
    groupList = data;
    _initIndexBarData();
  }

  void _initIndexBarData() {
    indexTagList.clear();
    mapData.clear();
    noteList.clear();

    if (groupList.length == 0) return;

    ALPHAS_INDEX.forEach((v) {
      mapData[v] = [];
    });
    Map<GroupUIModel, String> pinyinMap = Map<GroupUIModel, String>();
    for (var groupDB in groupList) {
      String pinyin = PinyinHelper.getFirstWordPinyin(groupDB.name);
      pinyinMap[groupDB] = pinyin;
    }
    groupList.sort((v1, v2) {
      return pinyinMap[v1]!.compareTo(pinyinMap[v2]!);
    });

    groupList.forEach((item) {
      if (item.groupId == '' || item.name == '') return;
      var cTag = pinyinMap[item]!.substring(0, 1).toUpperCase();
      if (!ALPHAS_INDEX.contains(cTag)) cTag = '#';
      mapData[cTag]?.add(item);
    });

    mapData.forEach((tag, list) {
      if (list.isNotEmpty) {
        indexTagList.add(tag);
        noteList.add(Note(tag, list));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    groupList = widget.data;
    _initIndexBarData();
    return Material(
      color: ThemeColor.color200,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          CustomScrollView(
                  slivers: _buildSlivers(context),
                  physics: widget.physics ?? BouncingScrollPhysics(),
                  shrinkWrap: widget.shrinkWrap,
                  controller: scrollController,
                ),
          groupList.isEmpty
              ? SizedBox()
              : Container(
                  child: _buildAlphaBar(),
                  width: 30,
                ),
          _isTouchTagBar ? _buildCenterModal() : SizedBox(),
        ],
      ),
    );
  }

  Widget _emptyWidget() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 87.0),
      child: Column(
        children: <Widget>[
          assetIcon(
            'icon_group_no.png',
            110.0,
            110.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: MyText(
              Localized.text('ox_chat.no_groups_added'),
              14,
              ThemeColor.gray02,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  int _computerIndex(double position) {
    for (int i = 0; i < noteList.length; i++) {
      double pre = _computerIndexPosition(i);
      double next = _computerIndexPosition(i + 1);
      if (position > pre && position < next) {
        return i;
      }
    }
    return 0;
  }

  double _computerIndexPosition(int index) {
    int n = 0;
    for (int i = 0; i < index; i++) {
      n += noteList[i].childList.length;
    }
    return n * itemHeight + index * headerHeight;
  }

  /// Used to control the disappearance of letters
  Timer? timer;

  void _onTouchCallback(int index) {
    if (defaultIndex != index) {
      if (null != timer && timer!.isActive) {
        timer!.cancel();
        timer = null;
      }
      var offset = _computerIndexPosition(index).clamp(.0, scrollController.position.maxScrollExtent);
      scrollController.jumpTo(offset.toDouble());
      defaultIndex = index;
    }
    timer = Timer(Duration(milliseconds: 300), () {
      setState(() {
        _isTouchTagBar = false;
      });
    });
  }

  /// Generate a modal with the middle letter prompt
  Widget _buildCenterModal() {
    return Center(
      child: Card(
        elevation: 0,
        color: ThemeColor.color180,
        child: Container(
          alignment: Alignment.center,
          width: 60.0,
          height: 60.0,
          child: Text(
            _tagName,
            style: TextStyle(
              fontSize: 32.0,
              color: ThemeColor.titleColor,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSlivers(BuildContext context) {
    List<Widget> slivers = [];
    if (widget.topWidget != null) {
      slivers.add(
        SliverToBoxAdapter(
          child: widget.topWidget,
        ),
      );
    }
    if (groupList.isEmpty) {
      slivers.add(SliverToBoxAdapter(child: _emptyWidget()));
    } else {
      noteList.forEach((item) {
        slivers.add(
          SliverStickyHeader(
            header: Visibility(
                visible: item.tag != "☆",
                child: GroupHeaderWidget(
                  tag: item.tag,
                )),
            sliver: SliverList(
              delegate: new SliverChildBuilderDelegate(
                    (context, i) =>
                    GroupContactListItem(
                      item: item.childList[i],
                    ),
                childCount: item.childList.length,
                addAutomaticKeepAlives: addAutomaticKeepAlives,
                addRepaintBoundaries: addRepaintBoundaries,
              ),
            ),
          ),
        );
      });
      slivers.add(
        SliverToBoxAdapter(
          child: SizedBox(
            height: 168.px,
          ),
        ),
      );
    }
    return slivers;
  }

  Widget _buildAlphaBar() {
    return Alpha(
      alphas: indexTagList,
      fontColor: ThemeColor.gray2,
      fontActiveColor: ThemeColor.white02,
      onAlphaChange: (value) {
        setState(() {
          if (!_isTouchTagBar) {
            _isTouchTagBar = true;
          }
          _tagName = value;
        });

        int index = indexTagList.indexOf(value);
        _onTouchCallback(index);
      },
      onTouchEnd: () {
        _onTouchCallback(defaultIndex);
      },
      onTouchStart: () {
        setState(() {
          _isTouchTagBar = true;
        });
        _onTouchCallback(defaultIndex);
      },
    );
  }
}

class GroupHeaderWidget extends StatelessWidget {
  String tag;

  GroupHeaderWidget({Key? key, this.tag = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: headerHeight,
      alignment: Alignment.centerLeft,
      color: ThemeColor.color200,
      padding: EdgeInsets.only(
        left: Adapt.px(24.0),
      ),
      child: MyText(
        tag,
        14,
        ThemeColor.color10,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class GroupContactListItem extends StatefulWidget {
  late GroupUIModel item;
  final onCheckChanged;

  GroupContactListItem({
    required this.item,
    this.onCheckChanged,
  });

  @override
  State createState() {
    return _GroupContactListItemState();
  }
}

class _GroupContactListItemState extends State<GroupContactListItem> {
  void _onItemClick() async {
    if (widget.item.chatType == ChatType.chatGroup
        || widget.item.chatType == ChatType.chatRelayGroup
        || widget.item.chatType == ChatType.chatChannel) {
      ChatMessagePage.open(
        context: context,
        communityItem: ChatSessionModelISAR(
          chatId: widget.item.groupId,
          groupId: widget.item.groupId,
          chatType: widget.item.chatType,
          chatName: widget.item.name,
          createTime: widget.item.updateTime,
          avatar: widget.item.picture ?? '',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget iconAvatar = SizedBox();
    String showName = '';
    switch (widget.item.chatType) {
      case ChatType.chatGroup:
        GroupDBISAR? tempGroupDB = Groups.sharedInstance.myGroups[widget.item.groupId]?.value;
        iconAvatar = OXGroupAvatar(group: tempGroupDB);
        showName = tempGroupDB?.name ?? '';
        if (showName.isEmpty) showName = Groups.encodeGroup(widget.item.groupId, null, null);
        break;
      case ChatType.chatRelayGroup:
        RelayGroupDBISAR? tempRelayGroupDB = RelayGroup.sharedInstance.myGroups[widget.item.groupId]?.value;
        iconAvatar = OXRelayGroupAvatar(relayGroup: tempRelayGroupDB);
        showName = tempRelayGroupDB?.name ?? '';
        if (showName.isEmpty) showName = tempRelayGroupDB?.shortGroupId ?? '';
        break;
      case ChatType.chatChannel:
        ChannelDBISAR? tempChannelDB = Channels.sharedInstance.channels[widget.item.groupId]?.value;
        iconAvatar = OXChannelAvatar(channel: tempChannelDB);
        showName = tempChannelDB?.name ?? '';
        if (showName.isEmpty) showName = tempChannelDB?.shortChannelId ?? '';
        break;
    }
    Widget? groupTypeWidget = ChatSessionUtils.getTypeSessionView(widget.item.chatType, widget.item.groupId);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onItemClick,
      child: Container(
        color: ThemeColor.color200,
        width: double.infinity,
        height: itemHeight,
        padding: EdgeInsets.only(left: Adapt.px(24.0), top: Adapt.px(10.0), bottom: Adapt.px(10.0)),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 48.px,
              height: 48.px,
              child: Stack(
                children: [
                  iconAvatar,
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: groupTypeWidget,
                  ),
                ],
              ),
            ),
            Container(
              width: Adapt.screenW - Adapt.px(120),
              margin: EdgeInsets.only(left: Adapt.px(16)),
              child: Text(
                showName,
                style: TextStyle(
                  fontSize: Adapt.px(16),
                  color: ThemeColor.color10,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
