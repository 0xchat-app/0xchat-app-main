import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_chat/page/session/chat_channel_message_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/alpha.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

double headerHeight = Adapt.px(24);
double itemHeight = Adapt.px(68.0);

typedef void CursorChannelsChanged(Widget cursor, int noteLength);

class ChannelContact extends StatefulWidget {
  final List<ChannelDB> data;
  final int chatType;
  final bool shrinkWrap;
  ScrollPhysics? physics;
  final Widget? topWidget;

  ChannelContact({
    Key? key,
    required this.data,
    required this.chatType,
    this.shrinkWrap = false,
    this.physics,
    this.topWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChannelContactState();
  }
}

class Note {
  String tag;
  List<ChannelDB> childList;

  Note(this.tag, this.childList);
}

class ChannelContactState extends State<ChannelContact> {
  ScrollController _scrollController = ScrollController();
  List<String> indexTagList = [];
  late List<ChannelDB> channelList;
  int defaultIndex = 0;

  List<Note> noteList = [];

  String _tagName = '';
  bool _isTouchTagBar = false;

  List<ChannelDB> selectedList = [];
  Map<String, List<ChannelDB>> mapData = Map();

  @override
  void initState() {
    super.initState();
    channelList = widget.data;
    _initIndexBarData();
    _scrollController.addListener(() {
      double position = _scrollController.offset.toDouble();
      int index = _computerIndex(position);
      defaultIndex = index;
    });
  }

  void updateContactData(List<ChannelDB> data) {
    channelList = data;
    _initIndexBarData();
  }

  void _initIndexBarData() {
    indexTagList.clear();
    mapData.clear();
    noteList.clear();

    if (channelList.length == 0) return;

    ALPHAS_INDEX.forEach((v) {
      mapData[v] = [];
    });
    Map<ChannelDB, String> pinyinMap = Map<ChannelDB, String>();
    for (var channelDB in channelList) {
      String pinyin = PinyinHelper.getFirstWordPinyin(channelDB.name ?? '');
      pinyinMap[channelDB] = pinyin;
    }
    channelList.sort((v1, v2) {
      return pinyinMap[v1]!.compareTo(pinyinMap[v2]!);
    });

    channelList.forEach((item) {
      if (item.channelId == '' || item.name == '') return;
      var cTag = pinyinMap[item]![0].toUpperCase();
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
    channelList = widget.data;
    _initIndexBarData();
    return Material(
      color: ThemeColor.color200,
      child: channelList.isEmpty
          ? _emptyWidget()
          : Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: <Widget>[
                CustomScrollView(
                  slivers: _buildSlivers(context),
                  physics: widget.physics ?? AlwaysScrollableScrollPhysics(),
                  shrinkWrap: widget.shrinkWrap,
                ),
                Container(
                  child: _buildAlphaBar(),
                  width: 30,
                ),
                _isTouchTagBar ? _buildCenterModal() : Container(),
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
            'icon_search_user_no.png',
            110.0,
            110.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: MyText(
              Localized.text('ox_chat.no_contacts_added'),
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
    _scrollController.dispose();
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
      var offset = _computerIndexPosition(index).clamp(.0, _scrollController.position.maxScrollExtent);
      _scrollController.jumpTo(offset.toDouble());
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
              (context, i) => GroupContactListItem(
                item: item.childList[i],
                chatType: widget.chatType,
              ),
              childCount: item.childList.length,
            ),
          ),
        ),
      );
    });
    double fillH = noteList.length * 68.px > Adapt.screenH() ? 118.px : (Adapt.screenH() - noteList.length * 68.px);
    slivers.add(
      SliverToBoxAdapter(
        child: Container(
          height: fillH,
        ),
      ),
    );
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
  late ChannelDB item;
  final onCheckChanged;
  final int chatType;

  GroupContactListItem({
    required this.item,
    this.onCheckChanged,
    required this.chatType,
  });

  @override
  State createState() {
    return _GroupContactListItemState();
  }
}

class _GroupContactListItemState extends State<GroupContactListItem> {
  void _onItemClick() async {
    if (widget.chatType == ChatType.chatGroup) {
      OXNavigator.pushPage(
        context,
            (context) => ChatChannelMessagePage(
          communityItem: ChatSessionModel(
            chatId: widget.item.channelId,
            groupId: widget.item.channelId,
            chatType: ChatType.chatGroup,
            chatName: widget.item.name!,
            createTime: widget.item.createTime,
            avatar: widget.item.picture!,
          ),
        ),
      );
    } else if (widget.chatType == ChatType.chatChannel) {
      OXNavigator.pushPage(
        context,
        (context) => ChatChannelMessagePage(
          communityItem: ChatSessionModel(
            chatId: widget.item.channelId,
            groupId: widget.item.channelId,
            chatType: ChatType.chatChannel,
            chatName: widget.item.name!,
            createTime: widget.item.createTime,
            avatar: widget.item.picture!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget iconAvatar = OXChannelAvatar(channel: widget.item);
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
            iconAvatar,
            Container(
              width: Adapt.screenW() - Adapt.px(120),
              margin: EdgeInsets.only(left: Adapt.px(16)),
              child: Text(
                widget.item.name ?? '',
                style: TextStyle(fontSize: Adapt.px(16), color: ThemeColor.color10, fontWeight: FontWeight.w600,),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
