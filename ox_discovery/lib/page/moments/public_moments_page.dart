import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_discovery/page/widgets/moment_tips.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';

import '../../enum/moment_enum.dart';
import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import '../widgets/moment_widget.dart';
import 'create_moments_page.dart';
import 'group_moments_page.dart';
import 'moments_page.dart';
import 'notifications_moments_page.dart';
import 'package:flutter/services.dart';

enum EPublicMomentsPageType { global, contacts, reacted, private }

extension EPublicMomentsPageTypeEx on EPublicMomentsPageType {
  String get text {
    switch (this) {
      case EPublicMomentsPageType.global:
        return 'Global';
      case EPublicMomentsPageType.contacts:
        return 'Contacts';
      case EPublicMomentsPageType.reacted:
        return 'Liked & Zapped';
      case EPublicMomentsPageType.private:
        return 'Private posts';
    }
  }

  String get subtitle {
    switch (this) {
      case EPublicMomentsPageType.global:
        return 'Everything from selected relays';
      case EPublicMomentsPageType.contacts:
        return 'Posts from contacts';
      case EPublicMomentsPageType.reacted:
        return 'Reactions and activity posts';
      case EPublicMomentsPageType.private:
        return 'Private posts';
    }
  }

  int get changeInt {
    switch (this) {
      case EPublicMomentsPageType.global:
        return 0;
      case EPublicMomentsPageType.contacts:
        return 1;
      case EPublicMomentsPageType.reacted:
        return 2;
      case EPublicMomentsPageType.private:
        return 3;
    }
  }

  static EPublicMomentsPageType getEnumType(int type) {
    switch (type) {
      case 0:
        return EPublicMomentsPageType.global;
      case 1:
        return EPublicMomentsPageType.contacts;
      case 2:
        return EPublicMomentsPageType.reacted;
      case 3:
        return EPublicMomentsPageType.private;
      default:
        return EPublicMomentsPageType.contacts;
    }
  }
}

class PublicMomentsPage extends StatefulWidget {
  final EPublicMomentsPageType publicMomentsPageType;
  final double? newMomentsBottom;
  const PublicMomentsPage(
      {Key? key, this.publicMomentsPageType = EPublicMomentsPageType.contacts, this.newMomentsBottom})
      : super(key: key);

  @override
  State<PublicMomentsPage> createState() => PublicMomentsPageState();
}

class PublicMomentsPageState extends State<PublicMomentsPage>
    with OXMomentObserver, OXUserInfoObserver {
  bool isLogin = false;
  final String _momentRelayCacheKey = 'momentRelaysKey';
  List<String> _globalRelays = [];
  // Optimized: Reduce initial load limit to improve initial render performance
  // Load more items on scroll instead of all at once
  final int _limit = 30; // Reduced from 50 to 30 for better initial performance
  final double tipsHeight = 52;
  final double tipsGroupHeight = 52;

  int? _allNotesFromDBLastTimestamp;
  List<NotedUIModel?> notesList = [];

  final ScrollController momentScrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  ValueNotifier<double> tipContainerHeight = ValueNotifier(0);

  List<NoteDBISAR> _notificationNotes = [];
  List<String> _notificationAvatarList = [];

  List<NotificationDBISAR> _notifications = [];
  List<String> _avatarList = [];

  List<NoteDBISAR> _notificationGroupNotes = [];
  bool addAutomaticKeepAlives = true;
  bool addRepaintBoundaries = true;

  Map<String, List<NoteDBISAR>> get getNotificationGroupNotesToMap {
    Map<String, List<NoteDBISAR>> map = {};
    _notificationGroupNotes.map((NoteDBISAR note) {
      if (map[note.groupId] == null) {
        map[note.groupId] = [];
      }
      map[note.groupId]!.add(note);
    }).toList();
    return map;
  }

  bool _isInitializingSubscriptions = false;
  EPublicMomentsPageType? _lastInitializedType;

  @override
  void initState() {
    super.initState();
    // Keep performance optimizations enabled on Android for better performance
    addAutomaticKeepAlives = true;
    addRepaintBoundaries = true;
    isLogin = OXUserInfoManager.sharedInstance.isLogin;
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXMomentManager.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    // Initialize subscriptions based on current filter type
    _initializeSubscriptions();
    _notificationUpdateNotes(OXMomentManager.sharedInstance.notes);
    _updateNotifications(OXMomentManager.sharedInstance.notifications);
  }

  Future<void> _initializeSubscriptions() async {
    // Prevent concurrent initialization
    if (_isInitializingSubscriptions) {
      return;
    }
    // Skip if type hasn't changed
    if (_lastInitializedType == widget.publicMomentsPageType) {
      return;
    }
    // Store the type we're about to initialize to prevent race conditions
    final targetType = widget.publicMomentsPageType;
    _isInitializingSubscriptions = true;
    try {
      // Verify type hasn't changed during async gap
      if (widget.publicMomentsPageType != targetType) {
        return;
      }
      _lastInitializedType = targetType;
      switch (targetType) {
      case EPublicMomentsPageType.global:
        await _loadGlobalRelaysAndInit();
        break;
      case EPublicMomentsPageType.contacts:
        // Subscribe to contacts feed
        await Moment.sharedInstance.updateSubscriptions(filterType: targetType.changeInt);
        updateNotesList(true);
        break;
      case EPublicMomentsPageType.private:
        // Close subscriptions for private posts (they only exist in local DB)
        Moment.sharedInstance.closeSubscriptions();
        updateNotesList(true);
        break;
      case EPublicMomentsPageType.reacted:
        // For reacted type, close subscriptions (no relay subscription needed)
        Moment.sharedInstance.closeSubscriptions();
        updateNotesList(true);
        break;
      }
    } catch (e) {
      // Reset _lastInitializedType on error so it can be retried
      _lastInitializedType = null;
      rethrow;
    } finally {
      _isInitializingSubscriptions = false;
    }
  }

  Future<void> _loadGlobalRelaysAndInit() async {
    // Safety check: only proceed if current type is global
    if (widget.publicMomentsPageType != EPublicMomentsPageType.global || !mounted) {
      return;
    }
    try {
      final relays =
          await OXCacheManager.defaultOXCacheManager.getListData(_momentRelayCacheKey);
      _globalRelays = relays;
    } catch (e) {
      _globalRelays = [];
    }
    // Double check type before subscribing (in case it changed during async operation)
    if (mounted && widget.publicMomentsPageType == EPublicMomentsPageType.global) {
      setState(() {});
      await Moment.sharedInstance.updateSubscriptions(
        filterType: widget.publicMomentsPageType.changeInt,
        relays: _globalRelays.isNotEmpty ? _globalRelays : null,
      );
      updateNotesList(true);
    }
  }

  /// Refresh global relays and reload data (used when staying on global type)
  Future<void> refreshGlobalRelays() async {
    await _loadGlobalRelaysAndInit();
  }


  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only re-initialize if the type actually changed
    if (widget.publicMomentsPageType != oldWidget.publicMomentsPageType) {
      refreshController.resetNoData();
      _clearData();
      // Reset last initialized type to allow re-initialization
      _lastInitializedType = null;
      // Use _initializeSubscriptions to ensure consistent subscription logic
      _initializeSubscriptions();
    }
  }

  @override
  void dispose() {
    refreshController.dispose();
    Moment.sharedInstance.closeSubscriptions();
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXMomentManager.sharedInstance.removeObserver(this);
    super.dispose();
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isLogin) return _noLoginWidget();
    return Stack(
      children: [
        SwipeDetector(
          onLeftSwipe: () {
            OXNavigator.pushPage(context,(context) => const NotificationsMomentsPage());
          },
          child: OXSmartRefresher(
            scrollController: momentScrollController,
            controller: refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () async {
              // Re-initialize subscriptions based on current filter type
              await _initializeSubscriptions();
            },
            onLoading: () => updateNotesList(false),
            child: _getMomentListWidget(),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              children: [
                _newMomentTipsWidget(),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: widget.newMomentsBottom ?? 50.px,
          right: 20.px,
          child: GestureDetector(
            onLongPress: () {
              OXNavigator.presentPage(
                  context,
                  (context) =>
                      const CreateMomentsPage(type: EMomentType.content));
            },
            onTap: () {
              CreateMomentDraft? createMomentMediaDraft =
                  OXMomentCacheManager.sharedInstance.createMomentMediaDraft;
              if (createMomentMediaDraft != null) {
                final type = createMomentMediaDraft.type;
                final imageList = type == EMomentType.picture
                    ? createMomentMediaDraft.imageList
                    : null;
                final videoPath = type == EMomentType.video
                    ? createMomentMediaDraft.videoPath
                    : null;
                final videoImagePath = type == EMomentType.video
                    ? createMomentMediaDraft.videoImagePath
                    : null;

                OXNavigator.presentPage(
                  context,
                  (context) => CreateMomentsPage(
                    type: type,
                    imageList: imageList,
                    videoPath: videoPath,
                    videoImagePath: videoImagePath,
                  ),
                );
                return;
              }
              OXNavigator.presentPage(
                  context, (context) => const CreateMomentsPage(type: null));
            },
            child: CommonImage(
              iconName: 'theme_add_icon.png',
              size: 48.px,
              package: 'ox_discovery',
            ),
          ),
        ),
      ],
    );
  }

  Widget _getMomentListWidget() {
    return ListView.builder(
        primary: false,
        controller: null,
        shrinkWrap: false,
        itemCount: notesList.length,
        // Optimized: Enable performance optimizations
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        // Optimized: Add cache extent to improve scroll performance
        cacheExtent: 200, // Cache 200px worth of items off-screen
        itemBuilder: (context, index) {
          NotedUIModel? notedUIModel = notesList[index];
          if (index == 0) {
            return ValueListenableBuilder<double>(
              valueListenable: tipContainerHeight,
              builder: (context, value, child) {
                return Container(
                  padding: EdgeInsets.only(top: value),
                  child: Column(
                    children: [
                      _groupNoteTips(),
                      MomentWidget(
                        isShowReplyWidget: true,
                        notedUIModel: notedUIModel,
                        clickMomentCallback:
                            (NotedUIModel? notedUIModel) async {
                          await OXNavigator.pushPage(
                              context,
                              (context) =>
                                  MomentsPage(notedUIModel: notedUIModel));
                        },
                      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
                    ],
                  ),
                );
              },
            );
          }

          return MomentWidget(
            isShowReplyWidget: true,
            notedUIModel: notedUIModel,
            clickMomentCallback:
                (NotedUIModel? notedUIModel) async {
              await OXNavigator.pushPage(
                  context, (context) => MomentsPage(notedUIModel: notedUIModel));
            },
          ).setPadding(EdgeInsets.only(
              left: 24.px,
              right:24.px,
              bottom: index == notesList.length - 1 ? 24.px : 0,
          ));
        },
    );
  }

  Widget _newMomentTipsWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _notificationNotes.isNotEmpty
              ? Container(
                  height: 52.px,
                  padding: EdgeInsets.only(top: 12.px),
                  child: MomentTips(
                    title:
                        '${_notificationNotes.length} ${Localized.text('ox_discovery.new_post')}',
                    avatars: _notificationAvatarList,
                    onTap: () async {
                      momentScrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                      // Force flush buffered database writes before refreshing
                      await DBISAR.sharedInstance.flushBuffers();
                      updateNotesList(true);
                      _clearNotedNotification();
                    },
                  ),
                )
              : Container(),
          SizedBox(
            width: 20.px,
          ),
          _notifications.isNotEmpty
              ? Container(
                  height: 52.px,
                  padding: EdgeInsets.only(top: 12.px),
                  child: MomentTips(
                    title:
                        '${_notifications.length} ${Localized.text('ox_discovery.reactions')}',
                    avatars: _avatarList,
                    onTap: () async {
                      OXMomentManager.sharedInstance.clearNewNotifications();
                      setState(() {
                        _notifications.clear();
                        tipContainerHeight.value = _getNotificationHeight;
                      });
                      await OXNavigator.pushPage(context,
                          (context) => const NotificationsMomentsPage());
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _groupNoteTips() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 24.px),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: getNotificationGroupNotesToMap.keys.map((String groupId) {
            RelayGroupDBISAR? groupDB =
                RelayGroup.sharedInstance.myGroups[groupId]?.value;
            if(groupDB == null) return const SizedBox();
            return _groupNotificationItem(groupDB);
          }).toList(),
        ),
      ),
    );
  }

  Widget _groupNotificationItem(RelayGroupDBISAR groupDB) {
    int noteNum = getNotificationGroupNotesToMap[groupDB.groupId]!.length;

    return GestureDetector(
      onTap: () async {
        _notificationGroupNotes
            .removeWhere((NoteDBISAR db) => db.groupId == groupDB.groupId);
        tipContainerHeight.value = _getNotificationHeight;
        await OXNavigator.pushPage(
            context, (context) => GroupMomentsPage(groupId: groupDB.groupId));
      },
      child: Stack(
        children: [
          MomentWidgetsUtils.clipImage(
            borderRadius: 16,
            child: OXCachedNetworkImage(
              imageUrl: groupDB.picture,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  MomentWidgetsUtils.badgePlaceholderImage(),
              errorWidget: (context, url, error) =>
                  MomentWidgetsUtils.badgePlaceholderImage(),
              width: 120.px,
              height: 80.px,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 26.px,
              decoration: BoxDecoration(
                color: ThemeColor.color180.withOpacity(0.72),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 80.px),
                    child: Text(
                      groupDB.name,
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: 14.px,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if(noteNum > 1)
                  Container(
                    margin: EdgeInsets.only(left: 2.px),
                    width: 16.px,
                    height: 16.px,
                    decoration: BoxDecoration(
                      color: ThemeColor.color0,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        getNotificationGroupNotesToMap[groupDB.groupId]!
                            .length
                            .toString(),
                        style: TextStyle(
                          color: ThemeColor.color200,
                          fontSize: 10.px,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ).setPaddingOnly(right: 16.px),
    );
  }

  Widget _noLoginWidget() {
    return Container(
      padding: EdgeInsets.only(top: Adapt.px(80.0)),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          CommonImage(
            iconName: 'icon_no_login.png',
            width: Adapt.px(90),
            height: Adapt.px(90),
            package: 'ox_common',
          ),
          GestureDetector(
            onTap: () {
              OXModuleService.pushPage(context, "ox_login", "LoginPage", {});
            },
            child: Container(
              margin: EdgeInsets.only(top: Adapt.px(24)),
              child: RichText(
                text: TextSpan(
                    text: Localized.text('ox_common.please_login_hint'),
                    style: TextStyle(
                        color: ThemeColor.color100,
                        fontSize: Adapt.px(16),
                        fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                        text: Localized.text('ox_common.please_login'),
                        style: TextStyle(
                          color: ThemeColor.color0,
                          fontSize: Adapt.px(14),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateNotesList(bool isInit,
      {bool isWrapRefresh = false}) async {
    if (isInit) {
      _clearNotedNotification();
    }
    if (isWrapRefresh) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _clearNotedNotification();
          refreshController.requestRefresh();
        }
      });
    }
    try {
      List<NoteDBISAR> list = await _getNoteTypeToDB(isInit);
      List<NoteDBISAR> showList = _filterNotes(list);
      _updateUI(showList, isInit, list.length);
      
      // If we got fewer notes than the limit, there's no more data
      if (list.length < _limit) {
        refreshController.loadNoData();
      }
    } catch (e) {
      print('Error loading notes: $e');
      refreshController.loadFailed();
    }
  }

  Future<List<NoteDBISAR>> _getNoteTypeToDB(bool isInit) async {
    int? until = isInit ? null : _allNotesFromDBLastTimestamp;
    switch (widget.publicMomentsPageType) {
      case EPublicMomentsPageType.global:
        return await Moment.sharedInstance.loadAllNotesFromDB(
                until: until, limit: _limit, relayList: _globalRelays.isNotEmpty ? _globalRelays : null) ??
            [];
      case EPublicMomentsPageType.contacts:
        return await Moment.sharedInstance.loadContactsNotesFromDB(until: until, limit: _limit) ?? [];
      case EPublicMomentsPageType.reacted:
        return await Moment.sharedInstance.loadMyReactedNotesFromDB(until: until, limit: _limit) ?? [];
      case EPublicMomentsPageType.private:
        return await Moment.sharedInstance.loadAllNotesFromDB(private: true, until: until, limit: _limit) ?? [];
    }
  }


  List<NoteDBISAR> _filterNotes(List<NoteDBISAR> list) {
    return list.where((NoteDBISAR note) => !note.isReaction && note.getReplyLevel(null) < 2).toList();
  }

  void _updateUI(List<NoteDBISAR> showList, bool isInit, int fetchedCount) {
    List<NotedUIModel?> list = showList.map((item) => NotedUIModel(noteDB: item)).toList();
    if (isInit) {
      notesList = list;
    } else {
      notesList.addAll(list);
    }

    if (showList.isNotEmpty) {
      _allNotesFromDBLastTimestamp = showList.last.createAt;
    }

    if (isInit) {
      refreshController.refreshCompleted();
    } else {
      fetchedCount < _limit
          ? refreshController.loadNoData()
          : refreshController.loadComplete();
    }
    setState(() {});
  }

  void _notificationUpdateNotes(List<NoteDBISAR> notes) async {
    if (notes.isEmpty) return;
    List<NoteDBISAR> personalNoteList = [];
    List<NoteDBISAR> groupNoteList = [];

    for (NoteDBISAR noteDB in notes) {
      bool isGroupNoted = noteDB.groupId.isNotEmpty;
      if (isGroupNoted) {
        int findIndex = groupNoteList.indexWhere((NoteDBISAR noted) => noted.noteId == noteDB.noteId);
        if(findIndex == -1){
          groupNoteList.add(noteDB);
        }
      } else {
        personalNoteList.add(noteDB);
      }
    }

    List<String> avatars = await DiscoveryUtils.getAvatarBatch(
        personalNoteList.map((e) => e.author).toSet().toList());
    if (avatars.length > 3) avatars = avatars.sublist(0, 3);

    double height = 0;
    if (groupNoteList.isNotEmpty) {
      height += tipsGroupHeight;
    }
    if (personalNoteList.isNotEmpty) {
      height += tipsHeight;
    }
    tipContainerHeight.value = height;
    setState(() {
      _notificationNotes = personalNoteList;
      _notificationAvatarList = avatars;
      _notificationGroupNotes = groupNoteList;
    });
  }

  void _updateNotifications(List<NotificationDBISAR> notifications) async {
    if (notifications.isEmpty) return;
    List<String> avatars = await DiscoveryUtils.getAvatarBatch(
        notifications.map((e) => e.author).toSet().toList());
    if (avatars.length > 3) avatars = avatars.sublist(0, 3);
    if (mounted) {
      setState(() {
        _notifications = notifications;
        _avatarList = avatars;
      });
    }
  }

  void _clearData() {
    notesList = [];
    _allNotesFromDBLastTimestamp = null;
    if (mounted) {
      setState(() {});
    }
  }

  double get _getNotificationHeight {
    double personalHeight =
        _notificationNotes.length + _notifications.length == 0 ? 0 : tipsHeight;
    double groupHeight = _notificationGroupNotes.isEmpty ? 0 : tipsGroupHeight;
    return personalHeight + groupHeight;
  }

  void _clearNotedNotification() {
    OXMomentManager.sharedInstance.clearNewNotes();
    setState(() {
      _notificationNotes.clear();
      tipContainerHeight.value = _getNotificationHeight;
    });
  }

  @override
  didNewNotesCallBackCallBack(List<NoteDBISAR> notes) {
    _notificationUpdateNotes(notes);
  }

  @override
  didNewNotificationCallBack(List<NotificationDBISAR> notifications) {
    _updateNotifications(notifications);
    tipContainerHeight.value = tipsHeight;
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    setState(() {
      isLogin = true;
    });
    updateNotesList(true);
  }

  @override
  void didLogout() {
    setState(() {
      isLogin = false;
    });
    _clearData();
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    if (mounted) {
      setState(() {
        notesList = [];
        isLogin = true;
      });
    }
  }
}

typedef SwipeCallback = void Function();

class SwipeDetector extends StatefulWidget {
  final Widget child;
  final SwipeCallback onLeftSwipe;

  SwipeDetector({required this.child, required this.onLeftSwipe});

  @override
  _SwipeDetectorState createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  Offset? _startDrag;
  bool _isHorizontal = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        _startDrag = details.globalPosition;
        _isHorizontal = false;
      },
      onHorizontalDragUpdate: (details) {
        if (_startDrag == null) return;

        double deltaX = details.globalPosition.dx - _startDrag!.dx;
        double deltaY = details.globalPosition.dy - _startDrag!.dy;

        if (!_isHorizontal && deltaX.abs() > deltaY.abs()) {
          _isHorizontal = true;
        }

        if (_isHorizontal && deltaX < -50) {
          widget.onLeftSwipe();
          _startDrag = null;
        }
      },
      child: widget.child,
    );
  }
}
