import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:ox_chat/page/contacts/contact_user_info_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/alpha.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../page/session/chat_message_page.dart';

double headerHeight = Adapt.px(24);
double itemHeight = Adapt.px(68.0);

typedef void CursorContactsChanged(Widget cursor, int noteLength);

class ContactWidget extends StatefulWidget {
  final List<UserDBISAR> data;
  final bool editable;
  final onSelectChanged;
  String hostName = ''; //The current domain
  final bool shrinkWrap;
  ScrollPhysics? physics;
  final Widget? topWidget;
  final Color? bgColor;
  final bool supportLongPress;

  ContactWidget({
    Key? key,
    required this.data,
    this.editable = false,
    this.onSelectChanged,
    this.hostName = 'ox.com',
    this.shrinkWrap = false,
    this.physics,
    this.topWidget,
    this.bgColor,
    this.supportLongPress = false,
  }) : super(key: key);

  @override
  State createState() {
    return ContactWidgetState();
  }
}

class Note {
  String tag;
  List<UserDBISAR> childList;

  Note(this.tag, this.childList);
}

class ContactWidgetState<T extends ContactWidget> extends State<T> {
  ScrollController scrollController = ScrollController();
  List<String> indexTagList = [];
  List<UserDBISAR> userList = [];
  int defaultIndex = 0;

  List<Note> noteList = [];

  String _tagName = '';
  bool _isTouchTagBar = false;

  List<UserDBISAR> selectedList = [];
  Map<String, List<UserDBISAR>> mapData = Map();
  String mHostName = '';
  bool addAutomaticKeepAlives = true;
  bool addRepaintBoundaries = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      addAutomaticKeepAlives = false;
      addRepaintBoundaries = false;
    }
    userList = widget.data;
    _initIndexBarData();
    initFromCache();
    scrollController.addListener(() {
      double position = scrollController.offset.toDouble();
      int index = _computerIndex(position);
      defaultIndex = index;
    });
  }

  void initFromCache() async {}

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void updateContactData(List<UserDBISAR> data) {
    userList = data;
    _initIndexBarData();
  }

  void _initIndexBarData() {
    indexTagList.clear();
    mapData.clear();
    noteList.clear();

    ALPHAS_INDEX.forEach((v) {
      mapData[v] = [];
    });
    Map<String, String> pinyinMap = Map<String, String>();
    for (var user in userList) {
      String nameToConvert = user.nickName != null && user.nickName!.isNotEmpty ? user.nickName! : (user.name ?? '');
      String pinyin = PinyinHelper.getFirstWordPinyin(nameToConvert);
      pinyinMap[user.pubKey] = pinyin;
    }
    userList.sort((v1, v2) {
      return pinyinMap[v1.pubKey]!.compareTo(pinyinMap[v2.pubKey]!);
    });
    userList.forEach((item) {
      // if (item.userType == systemUserType) {
      //   mapData["☆"]?.insert(0, item);
      //   return;
      // }
      String? pingyin = pinyinMap[item.pubKey] ;
      pingyin = pingyin == null || pingyin.isEmpty ? '' : pingyin[0];
      var cTag = pingyin.toUpperCase();
      // if (EnumTypeUtils.checkShiftOperation(item.userType!, 0)) {
      //   cTag = "☆";
      // } else if (!ALPHAS_INDEX.contains(cTag)){ cTag = '#';}
      if (!ALPHAS_INDEX.contains(cTag)) {
        cTag = '#';
      }
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
    return Material(
      color: widget.bgColor ?? ThemeColor.color200,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: <Widget>[
          CustomScrollView(
            slivers: _buildSlivers(context),
            physics: widget.physics ?? BouncingScrollPhysics(),
            shrinkWrap: widget.shrinkWrap,
            controller: scrollController,
          ),
          userList.isEmpty
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

  void _onCheckChangedListener(bool checked, UserDBISAR item) {
    if (checked)
      selectedList.add(item);
    else
      selectedList.remove(item);
    widget.onSelectChanged(selectedList);
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
    if (userList.isEmpty) {
      slivers.add(SliverToBoxAdapter(child: _emptyWidget()));
    } else {
      noteList.forEach((item) {
        slivers.add(
          SliverStickyHeader(
            header: Visibility(
              visible: item.tag != "☆",
              child: HeaderWidget(
                tag: item.tag,
              ),
            ),
            sliver: SliverList(
              delegate: new SliverChildBuilderDelegate(
                (context, i) {
                  return ContractListItem(
                    item: item.childList[i],
                    editable: widget.editable,
                    onCheckChanged: _onCheckChangedListener,
                    hostName: widget.hostName,
                    supportLongPress: widget.supportLongPress,
                  );
                },
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

class HeaderWidget extends StatelessWidget {
  String tag;

  HeaderWidget({Key? key, this.tag = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: headerHeight,
      alignment: Alignment.centerLeft,
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

class ContractListItem extends StatefulWidget {
  late UserDBISAR item;

  final onCheckChanged;
  final bool editable;

  String hostName = ''; //The current domain
  final bool supportLongPress;

  ContractListItem({
    required this.item,
    this.editable = false,
    this.onCheckChanged,
    this.hostName = 'ox.com',
    this.supportLongPress = false,
  });

  @override
  State createState() {
    return _ContractListItemState();
  }
}

class _ContractListItemState extends State<ContractListItem> {
  bool isChecked = false;
  ValueNotifier<double> valueNotifier = ValueNotifier(1.0);

  void _onCheckChanged() {
    setState(() {
      isChecked = !isChecked;
    });
    widget.onCheckChanged(isChecked, widget.item);
  }

  void _itemLongPress() async {
    if (widget.supportLongPress && widget.item.pubKey.isNotEmpty) {
      valueNotifier.value = 0.96;
      await Future.delayed(Duration(milliseconds: 80));
      valueNotifier.value = 1.0;
      await Future.delayed(Duration(milliseconds: 80));
      UserDBISAR? userDB = Contacts.sharedInstance.allContacts[widget.item.pubKey] as UserDBISAR;
      ChatMessagePage.open(
        context: context,
        communityItem: ChatSessionModelISAR(
          chatId: userDB.pubKey,
          chatName: userDB.name,
          sender: OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
          receiver: userDB.pubKey,
          chatType: ChatType.chatSingle,
        ),
        isLongPressShow: true,
        fromWhere: 1,
      );
    }
  }

  void _onItemClick() async {
    if (widget.item.pubKey.isNotEmpty) {
      UserDBISAR? userDB = Contacts.sharedInstance.allContacts[widget.item.pubKey] as UserDBISAR;
      // OXNavigator.pushPage(context, (context) => ContactUserInfoPage(pubkey: userDB.pubKey));
      ChatMessagePage.open(
        context: context,
        communityItem: ChatSessionModelISAR(
          chatId: userDB.pubKey,
          chatName: userDB.name,
          sender: OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
          receiver: userDB.pubKey,
          chatType: ChatType.chatSingle,
        ),
        isPushWithReplace: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget iconAvatar = OXUserAvatar(user: widget.item);
    Widget badgePlaceholderImage = CommonImage(
      iconName: 'icon_badge_default.png',
      fit: BoxFit.cover,
      width: Adapt.px(20),
      height: Adapt.px(20),
      useTheme: true,
    );

    Widget checkWidget = isChecked
        ? assetIcon(
            'icon_item_selected.png',
            24.0,
            24.0,
            useTheme: false,
          )
        : assetIcon(
            'icon_item_not_selected.png',
            24.0,
            24.0,
            useTheme: true,
          );
    return ValueListenableBuilder<double>(
      valueListenable: valueNotifier,
      builder: (context, scale, child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.editable ? _onCheckChanged : _onItemClick,
          onLongPress: _itemLongPress,
          child: AnimatedScale(
            scale: scale,
            duration: Duration(milliseconds: 80),
            curve: Curves.easeOut,
            child: Container(
              width: double.infinity,
              height: itemHeight,
              padding: EdgeInsets.only(
                  left: Adapt.px(24.0),
                  top: Adapt.px(10.0),
                  bottom: Adapt.px(10.0)),
              child: Row(
                children: <Widget>[
                  widget.editable
                      ? Container(
                          margin: EdgeInsets.only(right: Adapt.px(7.0)),
                          child: checkWidget,
                        )
                      : SizedBox(),
                  Stack(
                    children: [
                      iconAvatar,
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: FutureBuilder<BadgeDBISAR?>(
                          builder: (context, snapshot) {
                            return (snapshot.data != null)
                                ? OXCachedNetworkImage(
                                    imageUrl: snapshot.data?.thumb ?? '',
                                    errorWidget: (context, url, error) =>
                                        badgePlaceholderImage,
                                    width: Adapt.px(20),
                                    height: Adapt.px(20),
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox();
                          },
                          future: _getUserSelectedBadgeInfo(widget.item),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: Adapt.screenW - Adapt.px(120),
                    margin: EdgeInsets.only(left: Adapt.px(16.0)),
                    child: ValueListenableBuilder<UserDBISAR>(
                      valueListenable: Account.sharedInstance
                          .getUserNotifier(widget.item.pubKey),
                      builder: (context, value, child) {
                        return MyText(
                          (widget.item.nickName != null &&
                                  widget.item.nickName!.isNotEmpty)
                              ? widget.item.nickName!
                              : widget.item.name ?? '',
                          18,
                          ThemeColor.white02,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<BadgeDBISAR?> _getUserSelectedBadgeInfo(UserDBISAR friendDB) async {
    UserDBISAR? friendUserDB = Contacts.sharedInstance.allContacts[friendDB.pubKey];
    if (friendUserDB == null) {
      return null;
    }
    String badges = friendUserDB.badges ?? '';
    if (badges.isNotEmpty) {
      List<dynamic> badgeListDynamic = jsonDecode(badges);
      List<String> badgeList = badgeListDynamic.cast();
      BadgeDBISAR? badgeDB;
      try {
        List<BadgeDBISAR?> badgeDBList = await BadgesHelper.getBadgeInfosFromDB(badgeList);
        badgeDB = badgeDBList.firstOrNull;
      } catch (error) {
        LogUtil.e("user selected badge info fetch failed: $error");
      }
      return badgeDB;
    }
    return null;
  }
}
