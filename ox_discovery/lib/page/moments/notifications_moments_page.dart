import 'dart:ui';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/model/aggregated_notification.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_discovery/page/moments/moments_page.dart';
import 'package:ox_discovery/utils/discovery_utils.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';
import 'package:ox_module_service/ox_module_service.dart';

import '../../enum/moment_enum.dart';
import '../../model/moment_ui_model.dart';
import '../../utils/moment_widgets_utils.dart';

class NotificationsMomentsPage extends StatefulWidget {
  const NotificationsMomentsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsMomentsPage> createState() =>
      _NotificationsMomentsPageState();
}

class _NotificationsMomentsPageState extends State<NotificationsMomentsPage> {
  final int _limit = 50;
  int? _lastTimestamp;
  final RefreshController _refreshController = RefreshController();
  final List<AggregatedNotification> _aggregatedNotifications = [];

  @override
  void initState() {
    super.initState();
    _lastTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    _loadNotificationData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        actions: [
          _isShowClearWidget(),
        ],
        title: 'Notifications',
      ),
      body: _bodyWidget(),
    );
  }

  Widget _isShowClearWidget(){
    if(_aggregatedNotifications.isEmpty) return const SizedBox();
    return GestureDetector(
      onTap: _clearNotifications,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 24.px),
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
            'Clear',
            style: TextStyle(
              fontSize: 16.px,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyWidget(){
    if(_aggregatedNotifications.isEmpty) return _noDataWidget();
    return OXSmartRefresher(
      controller: _refreshController,
      enablePullDown: false,
      enablePullUp: true,
      onLoading: () => _loadNotificationData(),
      child: SingleChildScrollView(
        child: ListView.builder(
          primary: false,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _aggregatedNotifications.length,
          itemBuilder: (context, index) {
            return _notificationsItemWidget(notification: _aggregatedNotifications[index]);
          },
        ),
      ),
    );
  }

  Widget _noDataWidget(){
    return Padding(
      padding: EdgeInsets.only(
        top: 120.px,
      ),
      child: Center(
        child: Column(
          children: [
            CommonImage(
              iconName: 'icon_no_data.png',
              width: Adapt.px(90),
              height: Adapt.px(90),
            ),
            Text(
              'No Notifications !',
              style: TextStyle(
                fontSize: 16.px,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color100,
              ),
            ).setPaddingOnly(
              top: 24.px,
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationsItemWidget({required AggregatedNotification notification}) {
    ENotificationsMomentType type = _fromIndex(notification.kind);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        NoteDB? note;
        if(type == ENotificationsMomentType.reply || type == ENotificationsMomentType.quote) {
          note = await Moment.sharedInstance.loadNoteWithNoteId(notification.notificationId);
        } else {
          note = await Moment.sharedInstance.loadNoteWithNoteId(notification.associatedNoteId);
        }
        if(note != null){
          OXNavigator.pushPage(context, (context) => MomentsPage(isShowReply: true, notedUIModel: ValueNotifier(NotedUIModel(noteDB: note!))));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.px,
          vertical: 12.px,
        ),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 1.px,
          color: ThemeColor.color180,
        ))),
        child: FutureBuilder<UserDB?>(
          future: _getUser(notification.author),
          builder: (context,snapshot) {
            final placeholder = MomentWidgetsUtils.badgePlaceholderImage(size: 40);

            if(snapshot.data == null) return Container();
            final user = snapshot.data!;
            final likeCount = notification.likeCount;
            final username = user.name ?? user.shortEncodedPubkey ?? '';
            final suffix = (likeCount - 1) > 0 ? 'and ${notification.likeCount - 1} people' : '';
            final itemLabel = type == ENotificationsMomentType.like ? '$username $suffix' : username;
            final imageUrl = snapshot.data?.picture ?? '';
            String showTimeContent = DiscoveryUtils.formatTimeAgo(notification.createAt);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        OXModuleService.pushPage(
                            context, 'ox_chat', 'ContactUserInfoPage', {
                          'pubkey': user.pubKey,
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.px),
                        child: OXCachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 40.px,
                          height: 40.px,
                          placeholder: (context, url) => placeholder,
                          errorWidget: (context, url, error) => placeholder,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 8.px,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                itemLabel,
                                style: TextStyle(
                                  color: ThemeColor.color0,
                                  fontSize: 14.px,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 8.px,
                              ),
                              Text(
                                showTimeContent,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ThemeColor.color120,
                                  fontSize: 12.px,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ).setPaddingOnly(bottom: 2.px),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: 4.px,
                                ),
                                child: CommonImage(
                                  iconName: type.getIconName,
                                  size: 16.px,
                                  package: 'ox_discovery',
                                  color: ThemeColor.gradientMainStart,
                                ),
                              ),
                              _getNotificationsContentWidget(notification),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildThumbnailWidget(notification),
              ],
            );
          }
        ),
      ),
    );
  }

  Future<UserDB?> _getUser(String pubkey) async {
    return await Account.sharedInstance.getUserInfo(pubkey);
  }

  Widget _getNotificationsContentWidget(AggregatedNotification notificationDB) {
    ENotificationsMomentType type = _fromIndex(notificationDB.kind);
    String content = '';
    switch (type) {
      case ENotificationsMomentType.quote:
      case ENotificationsMomentType.reply:
        content = notificationDB.content;
        break;
      case ENotificationsMomentType.like:
        content = "liked your moments";
        break;
      case ENotificationsMomentType.repost:
        content = "Reposted your moments";
        break;
      case ENotificationsMomentType.zaps:
        content = "Zaps +${notificationDB.zapAmount}";
        break;
    }
    bool isPurpleColor = type != ENotificationsMomentType.quote &&
        type != ENotificationsMomentType.reply;
    return SizedBox(
      width: 200.px,
      child: Text(
        content,
        style: TextStyle(
          color: isPurpleColor ? ThemeColor.purple2 : ThemeColor.color0,
          fontSize: 12.px,
          fontWeight: FontWeight.w400,
          height: 16.8.px / 12.px,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  Widget _buildThumbnailWidget(AggregatedNotification notificationDB) {
    return FutureBuilder(
      future: _getNote(notificationDB),
      builder: (context,snapshot) {
        final note = snapshot.data;
        if(note == null) return Container();
        MomentContentAnalyzeUtils mediaAnalyzer = MomentContentAnalyzeUtils(note.content ?? '');
        List<String> pictures = mediaAnalyzer.getMediaList(1);
        if(pictures.isEmpty) return Container();
        return MomentWidgetsUtils.clipImage(
          borderRadius: 8.px,
          imageSize: 60.px,
          child: OXCachedNetworkImage(
            imageUrl: pictures.first,
            fit: BoxFit.cover,
            placeholder: (context, url) => MomentWidgetsUtils.badgePlaceholderImage(),
            errorWidget: (context, url, error) => MomentWidgetsUtils.badgePlaceholderImage(),
            width: 60.px,
            height: 60.px,
          ),
        );
      }
    );
  }

  Future<NoteDB?> _getNote(AggregatedNotification notificationDB) async {
    return await Moment.sharedInstance.loadNoteWithNoteId(notificationDB.associatedNoteId);
  }

  void _clearNotifications(){
    OXCommonHintDialog.show(
      context,
      title: '',
      content: 'Are you sure to clear all the notifications ?',
      actionList: [
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context);
        }),
        OXCommonHintAction.sure(text: 'Sure', onTap: () async {
          OXLoading.show();
          await Moment.sharedInstance.deleteAllNotifications();
          OXLoading.dismiss();
          setState(() {
            _aggregatedNotifications.clear();
          });
          CommonToast.instance.show(context, 'clear notifications successful');
         return OXNavigator.pop(context);
        }),
      ],
      isRowAction: true,
    );

  }

  _loadNotificationData() async {
    List<NotificationDB> notificationList = await Moment.sharedInstance.loadNotificationsFromDB(_lastTimestamp ?? 0,limit: _limit) ?? [];

    List<AggregatedNotification> aggregatedNotifications = _getAggregatedNotifications(notificationList);
    _aggregatedNotifications.addAll(aggregatedNotifications);
    _lastTimestamp = notificationList.last.createAt;
    notificationList.length < _limit ? _refreshController.loadNoData() : _refreshController.loadComplete();
    setState(() {});
  }

  ENotificationsMomentType _fromIndex(int kind) {
    //1：reply 2:quoteRepost 6:repost 7:reaction 9735:zap
    switch (kind) {
      case 1 :
        return ENotificationsMomentType.reply;
      case 2 :
        return ENotificationsMomentType.quote;
      case 6 :
        return ENotificationsMomentType.repost;
      case 7 :
        return ENotificationsMomentType.like;
      case 9735 :
        return ENotificationsMomentType.zaps;
      default:
        return ENotificationsMomentType.reply;
    }
  }

  List<AggregatedNotification> _getAggregatedNotifications(List<NotificationDB> notifications) {
    List<NotificationDB> likeTypeNotification = [];
    List<NotificationDB> otherTypeNotification = [];
    Set<String> groupedItems = {};

    for (var notification in notifications) {
      if (notification.isLike) {
        likeTypeNotification.add(notification);
        groupedItems.add(notification.associatedNoteId);
      } else {
        otherTypeNotification.add(notification);
      }
    }

    Map<String, List<NotificationDB>> grouped = {};
    for (var groupedItem in groupedItems) {
      grouped[groupedItem] = likeTypeNotification.where((notification) => notification.associatedNoteId == groupedItem).toList();
    }

    List<AggregatedNotification> aggregatedNotifications = [];
    grouped.forEach((key, value) {
      value.sort((a, b) => b.createAt.compareTo(a.createAt)); // sort each group
      AggregatedNotification groupedNotification = AggregatedNotification.fromNotificationDB(value.first);
      groupedNotification.likeCount = value.length;
      aggregatedNotifications.add(groupedNotification);
    });

    aggregatedNotifications.addAll(otherTypeNotification.map((element) => AggregatedNotification.fromNotificationDB(element)));
    aggregatedNotifications.sort((a, b) => b.createAt.compareTo(a.createAt));

    return aggregatedNotifications;
  }
}
