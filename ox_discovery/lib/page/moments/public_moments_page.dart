import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_discovery/page/widgets/moment_tips.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_theme/ox_theme.dart';

import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import '../widgets/moment_widget.dart';
import 'group_moments_page.dart';
import 'moments_page.dart';
import 'notifications_moments_page.dart';
import 'package:flutter/services.dart';

enum EPublicMomentsPageType { all, contacts, follows, reacted, private }

extension EPublicMomentsPageTypeEx on EPublicMomentsPageType {
  String get text {
    switch (this) {
      case EPublicMomentsPageType.all:
        return Localized.text('ox_discovery.all');
      case EPublicMomentsPageType.contacts:
        return 'Contacts';
      case EPublicMomentsPageType.follows:
        return 'Follows';
      case EPublicMomentsPageType.reacted:
        return 'Liked & Zapped';
      case EPublicMomentsPageType.private:
        return 'Private';
    }
  }
}

class PublicMomentsPage extends StatefulWidget {
  final EPublicMomentsPageType publicMomentsPageType;
  const PublicMomentsPage(
      {Key? key, this.publicMomentsPageType = EPublicMomentsPageType.all})
      : super(key: key);

  @override
  State<PublicMomentsPage> createState() => PublicMomentsPageState();
}

class PublicMomentsPageState extends State<PublicMomentsPage>
    with OXMomentObserver, OXUserInfoObserver {
  bool isLogin = false;
  final int _limit = 50;
  final double tipsHeight = 52;
  final double tipsGroupHeight = 52;

  int? _allNotesFromDBLastTimestamp;
  List<ValueNotifier<NotedUIModel>> notesList = [];

  final ScrollController momentScrollController = ScrollController();
  final RefreshController _refreshController = RefreshController();

  ValueNotifier<double> tipContainerHeight = ValueNotifier(0);

  List<NoteDB> _notificationNotes = [];
  List<String> _notificationAvatarList = [];

  List<NotificationDB> _notifications = [];
  List<String> _avatarList = [];

  List<NoteDB> _notificationGroupNotes = [];

  @override
  void initState() {
    super.initState();
    isLogin = OXUserInfoManager.sharedInstance.isLogin;
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXMomentManager.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    updateNotesList(true);
    _notificationUpdateNotes(OXMomentManager.sharedInstance.notes);
    _updateNotifications(OXMomentManager.sharedInstance.notifications);
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.publicMomentsPageType != oldWidget.publicMomentsPageType) {
      _refreshController.resetNoData();
      _clearData();
      updateNotesList(true);
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
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
        OXSmartRefresher(
          scrollController: momentScrollController,
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () => updateNotesList(true),
          onLoading: () => updateNotesList(false),
          child: _getMomentListWidget(),
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
      ],
    );
  }

  Widget _getMomentListWidget() {
    return ListView.builder(
      primary: false,
      controller: null,
      shrinkWrap: false,
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        ValueNotifier<NotedUIModel> notedUIModel = notesList[index];
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
                          (ValueNotifier<NotedUIModel> notedUIModel) async {
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
              (ValueNotifier<NotedUIModel> notedUIModel) async {
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
                    onTap: () {
                      momentScrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                      updateNotesList(true);
                      _clearNotedNotification();
                    },
                  ),
                )
              : Container(),

          // MomentNewPostTips(
          //   tipsHeight: tipsHeight,
          //   onTap: (List<NoteDB> list) {
          //     updateNotesList(true);
          //     momentScrollController.animateTo(
          //       0.0,
          //       duration: const Duration(milliseconds: 500),
          //       curve: Curves.easeInOut,
          //     );
          //     newNotesCallBackCallBackList.value = [];
          //     tipContainerHeight.value =
          //         newNotificationCallBackList.value.isNotEmpty ? tipsHeight : 0;
          //   },
          // ),
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

          // MomentNotificationTips(
          //   tipsHeight: tipsHeight,
          //   onTap: (List<NotificationDB>? notificationDBList) async {
          //     await OXNavigator.pushPage(
          //         context, (context) => const NotificationsMomentsPage());
          //     newNotificationCallBackList.value = [];
          //     tipContainerHeight.value =
          //         newNotesCallBackCallBackList.value.isNotEmpty
          //             ? tipsHeight
          //             : 0;
          //   },
          // ),
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
          children: _notificationGroupNotes.map((NoteDB item) {
            RelayGroupDB? groupDB =
                RelayGroup.sharedInstance.myGroups[item.groupId];
            return _groupNotificationItem(groupDB);
          }).toList(),
        ),
      ),
    );
  }

  Widget _groupNotificationItem(RelayGroupDB? groupDB) {
    return GestureDetector(
      onTap: () async {
        if (groupDB == null) return;
        _notificationGroupNotes
            .removeWhere((NoteDB db) => db.groupId == groupDB.groupId);
        tipContainerHeight.value = _getNotificationHeight;
        await OXNavigator.pushPage(
            context, (context) => GroupMomentsPage(groupId: groupDB.groupId));
      },
      child: Stack(
        children: [
          MomentWidgetsUtils.clipImage(
            borderRadius: 16,
            child: OXCachedNetworkImage(
              imageUrl: groupDB?.picture ?? '',
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
              child: Text(groupDB?.name ?? '--'),
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
    bool isPrivateMoment =
        widget.publicMomentsPageType == EPublicMomentsPageType.private;
    if (isWrapRefresh) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _clearNotedNotification();
          _refreshController.requestRefresh();
        }
      });
    }
    try {
      List<NoteDB> list = await _getNoteTypeToDB(isInit);
      if (list.isEmpty) {
        isInit
            ? _refreshController.refreshCompleted()
            : _refreshController.loadNoData();
        if (!isPrivateMoment && !isInit) await _getNotesFromRelay();
        return;
      }

      List<NoteDB> showList = _filterNotes(list);
      _updateUI(showList, isInit, list.length);

      if (list.length < _limit) {
        !isPrivateMoment && !isInit
            ? await _getNotesFromRelay()
            : _refreshController.loadNoData();
      }
    } catch (e) {
      print('Error loading notes: $e');
      _refreshController.loadFailed();
    }
  }

  Future<List<NoteDB>> _getNoteTypeToDB(bool isInit) async {
    switch (widget.publicMomentsPageType) {
      case EPublicMomentsPageType.all:
        return await Moment.sharedInstance.loadAllNotesFromDB(
                until: isInit ? null : _allNotesFromDBLastTimestamp,
                limit: _limit) ??
            [];
      case EPublicMomentsPageType.contacts:
        return await Moment.sharedInstance.loadContactsNotesFromDB(
                until: isInit ? null : _allNotesFromDBLastTimestamp,
                limit: _limit) ??
            [];
      case EPublicMomentsPageType.follows:
        return await Moment.sharedInstance.loadFollowsNotesFromDB(
            until: isInit ? null : _allNotesFromDBLastTimestamp,
            limit: _limit) ??
            [];
      case EPublicMomentsPageType.reacted:
        return await Moment.sharedInstance.loadMyReactedNotesFromDB(
                until: isInit ? null : _allNotesFromDBLastTimestamp,
                limit: _limit) ??
            [];
      case EPublicMomentsPageType.private:
        return await Moment.sharedInstance.loadAllNotesFromDB(
                private: true,
                until: isInit ? null : _allNotesFromDBLastTimestamp,
                limit: _limit) ??
            [];
    }
  }

  Future<List<NoteDB>> _getNoteTypeToRelay() async {
    switch (widget.publicMomentsPageType) {
      case EPublicMomentsPageType.all:
        return await Moment.sharedInstance.loadAllNewNotesFromRelay(
                until: _allNotesFromDBLastTimestamp, limit: _limit) ??
            [];
      case EPublicMomentsPageType.contacts:
        return await Moment.sharedInstance.loadContactsNewNotesFromRelay(
                until: _allNotesFromDBLastTimestamp, limit: _limit) ??
            [];
      case EPublicMomentsPageType.follows:
        return await Moment.sharedInstance.loadFollowsNewNotesFromRelay(
                until: _allNotesFromDBLastTimestamp, limit: _limit) ??
            [];
      case EPublicMomentsPageType.reacted:
        return [];
      case EPublicMomentsPageType.private:
        return [];
    }
  }

  Future<void> _getNotesFromRelay() async {
    try {
      List<NoteDB> list = await _getNoteTypeToRelay();

      if (list.isEmpty) {
        _refreshController.loadNoData();
        return;
      }

      List<NoteDB> showList = _filterNotes(list);
      _updateUI(showList, false, list.length);
    } catch (e) {
      print('Error loading notes from relay: $e');
      _refreshController.loadFailed();
    }
  }

  List<NoteDB> _filterNotes(List<NoteDB> list) {
    return list
        .where(
            (NoteDB note) => !note.isReaction && note.getReplyLevel(null) < 2)
        .toList();
  }

  void _updateUI(List<NoteDB> showList, bool isInit, int fetchedCount) {
    List<ValueNotifier<NotedUIModel>> list = showList
        .map((note) => ValueNotifier(NotedUIModel(noteDB: note)))
        .toList();
    if (isInit) {
      notesList = list;
    } else {
      notesList.addAll(list);
    }

    _allNotesFromDBLastTimestamp = showList.last.createAt;

    if (isInit) {
      _refreshController.refreshCompleted();
    } else {
      fetchedCount < _limit
          ? _refreshController.loadNoData()
          : _refreshController.loadComplete();
    }
    setState(() {});
  }

  void _notificationUpdateNotes(List<NoteDB> notes) async {
    if (notes.isEmpty) return;
    List<NoteDB> personalNoteList = [];
    List<NoteDB> groupNoteList = [];

    for (NoteDB noteDB in notes) {
      bool isGroupNoted = noteDB.groupId.isNotEmpty;
      isGroupNoted ? groupNoteList.add(noteDB) : personalNoteList.add(noteDB);
    }

    List<String> avatars = await DiscoveryUtils.getAvatarBatch(
        personalNoteList.map((e) => e.author).toSet().toList());
    if (avatars.length > 3) avatars = avatars.sublist(0, 3);
    setState(() {
      _notificationNotes = personalNoteList;
      _notificationAvatarList = avatars;
      _notificationGroupNotes = groupNoteList;
    });
    double height = 0;
    if (groupNoteList.isNotEmpty) {
      height += tipsGroupHeight;
    }
    if (personalNoteList.isNotEmpty) {
      height += tipsHeight;
    }
    tipContainerHeight.value = height;
  }

  void _updateNotifications(List<NotificationDB> notifications) async {
    if (notifications.isEmpty) return;
    List<String> avatars = await DiscoveryUtils.getAvatarBatch(
        notifications.map((e) => e.author).toSet().toList());
    if (avatars.length > 3) avatars = avatars.sublist(0, 3);
    setState(() {
      _notifications = notifications;
      _avatarList = avatars;
    });
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
  didNewNotesCallBackCallBack(List<NoteDB> notes) {
    _notificationUpdateNotes(notes);
  }

  @override
  didNewNotificationCallBack(List<NotificationDB> notifications) {
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
    setState(() {
      isLogin = true;
    });
    updateNotesList(true);
  }
}
