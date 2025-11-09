import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/alpha.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/font_size_notifier.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';


double itemHeight = Adapt.px(68.0);

typedef void CursorContactsChanged(Widget cursor, int noteLength);

class ContactWidget extends StatefulWidget {
  final List<UserDBISAR> data;
  final bool editable;
  final onSelectChanged;
  String hostName = ''; //The current domain
  final bool shrinkWrap;
  ScrollPhysics? physics;
  final Widget? appBar;
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
    this.appBar,
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
  // Cache for pinyin calculations to avoid repeated computation
  Map<String, String> _pinyinCache = {};

  @override
  void initState() {
    super.initState();
    // Keep performance optimizations enabled on Android for better performance
    // These optimizations help reduce unnecessary rebuilds and repaints
    addAutomaticKeepAlives = true;
    addRepaintBoundaries = true;
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
    // Clear cache if needed before updating
    _clearPinyinCacheIfNeeded(data);
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
    
    // Build pinyin map with caching to avoid repeated calculations
    Map<String, String> pinyinMap = Map<String, String>();
    for (var user in userList) {
      String? cachedPinyin = _pinyinCache[user.pubKey];
      if (cachedPinyin == null) {
        // Calculate pinyin only if not in cache
        String nameToConvert = user.nickName != null && user.nickName!.isNotEmpty 
            ? user.nickName! 
            : (user.name ?? '');
        cachedPinyin = PinyinHelper.getFirstWordPinyin(nameToConvert);
        _pinyinCache[user.pubKey] = cachedPinyin;
      }
      pinyinMap[user.pubKey] = cachedPinyin;
    }
    
    // Sort user list using cached pinyin values
    userList.sort((v1, v2) {
      return pinyinMap[v1.pubKey]!.compareTo(pinyinMap[v2.pubKey]!);
    });
    
    // Group users by first letter of pinyin
    userList.forEach((item) {
      String? pinyin = pinyinMap[item.pubKey];
      pinyin = pinyin == null || pinyin.isEmpty ? '' : pinyin[0];
      var cTag = pinyin.toUpperCase();
      if (!ALPHAS_INDEX.contains(cTag)) {
        cTag = '#';
      }
      mapData[cTag]?.add(item);
    });
    
    // Build index tag list and note list
    mapData.forEach((tag, list) {
      if (list.isNotEmpty) {
        indexTagList.add(tag);
        noteList.add(Note(tag, list));
      }
    });
  }
  
  // Clear pinyin cache when user list changes significantly
  void _clearPinyinCacheIfNeeded(List<UserDBISAR> newUserList) {
    // If user list size changed significantly, clear cache to avoid stale data
    if ((newUserList.length - userList.length).abs() > userList.length * 0.3) {
      _pinyinCache.clear();
    } else {
      // Remove cache entries for users no longer in the list
      final newPubKeys = newUserList.map((u) => u.pubKey).toSet();
      _pinyinCache.removeWhere((key, value) => !newPubKeys.contains(key));
    }
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
                  width: 24.px * textScaleFactorNotifier.value,
                  constraints: BoxConstraints(maxWidth: 50.px),
                  child: _buildAlphaBar(),
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
    return n * itemHeight + index * (24.px * textScaleFactorNotifier.value);
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
    Widget? tempAppBar = widget.appBar;
    if (tempAppBar != null) {
      slivers.add(tempAppBar);
    }
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
                headerHeight: 24.px * textScaleFactorNotifier.value,
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
      alphaItemSize: 19 * textScaleFactorNotifier.value,
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
  double headerHeight;

  HeaderWidget({Key? key, this.tag = '', this.headerHeight = 24}) : super(key: key);

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
  ValueNotifier<bool> valueNotifier = ValueNotifier(false);

  void _onCheckChanged() {
    setState(() {
      isChecked = !isChecked;
    });
    widget.onCheckChanged(isChecked, widget.item);
  }

  void _itemLongPress() async {
    TookKit.vibrateEffect();
    await Future.delayed(Duration(milliseconds: 100));
    valueNotifier.value = false;
    if (widget.supportLongPress && widget.item.pubKey.isNotEmpty) {
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
    // Optimized: Extract static content to reduce rebuilds
    final userNameWidget = ValueListenableBuilder<UserDBISAR>(
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
    );
    
    final contentWidget = Container(
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
              // Badge removed for performance optimization
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width - Adapt.px(120),
            margin: EdgeInsets.only(left: Adapt.px(16.0)),
            child: userNameWidget,
          ),
        ],
      ),
    );
    
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.editable ? _onCheckChanged : _onItemClick,
      onLongPressStart: (_) {
        valueNotifier.value = true;
      },
      onLongPress: _itemLongPress,
      child: ValueListenableBuilder<bool>(
        valueListenable: valueNotifier,
        builder: (context, scale, child) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: scale ? 0.9 : 1.0),
            duration: Duration(milliseconds: 100),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child!,
              );
            },
            child: contentWidget,
          );
        },
      ),
    );
  }

  // Badge loading removed for performance optimization
}
