import 'dart:ui';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_discovery/page/moments/moments_page.dart';
import 'package:ox_discovery/utils/discovery_utils.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';

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
  List<ENotificationsMomentType> notificationsList = [
    ENotificationsMomentType.quote,
    ENotificationsMomentType.repost,
    ENotificationsMomentType.like,
    ENotificationsMomentType.reply,
    ENotificationsMomentType.zaps
  ];

  List<NotificationDB> _notifications = [];

  @override
  void initState() {
    super.initState();
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
    if(notificationsList.isEmpty) return const SizedBox();
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
    if(notificationsList.isEmpty) return _noDataWidget();
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: 60.px,
        ),
        child: ListView.builder(
          primary: false,
          controller: null,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            return _notificationsItemWidget(notificationDB: _notifications[index]);
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

  Widget _notificationsItemWidget({required NotificationDB notificationDB}) {
    ENotificationsMomentType type = _fromIndex(notificationDB.kind);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(notificationDB.associatedNoteId);
        if(note != null){
          OXNavigator.pushPage(context, (context) => MomentsPage(notedUIModel: NotedUIModel(noteDB: note)));
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
          future: _getUser(notificationDB.author),
          builder: (context,snapshot) {
            String localAvatarPath = 'assets/images/icon_user_default.png';
            Image _placeholderImage = Image.asset(
              localAvatarPath,
              fit: BoxFit.cover,
              width: 40.px,
              height: 40.px,
              package: 'ox_common',
            );

            final username = snapshot.data?.name ?? '';
            final dns = snapshot.data?.dns ?? '';
            final imageUrl = snapshot.data?.picture ?? '';
            String showTimeContent = DiscoveryUtils.formatTimeAgo(notificationDB.createAt);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40.px),
                      child: OXCachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 40.px,
                        height: 40.px,
                        errorWidget: (context, url, error) => _placeholderImage,
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
                            children: [
                              Text(
                                username,
                                style: TextStyle(
                                  color: ThemeColor.color0,
                                  fontSize: 14.px,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 14.px,
                              ),
                              Text(
                                // '$dns· 45s ago',
                                showTimeContent,
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
                              _getNotificationsContentWidget(notificationDB),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildThumbnailWidget(notificationDB),
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

  Widget _getNotificationsContentWidget(NotificationDB notificationDB) {
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

  Widget _buildThumbnailWidget(NotificationDB notificationDB) {
    return FutureBuilder(
      future: _getNote(notificationDB),
      builder: (context,snapshot) {
        final note = snapshot.data;
        MomentContentAnalyzeUtils mediaAnalyzer = MomentContentAnalyzeUtils(note?.content ?? '');
        List<String> pictures = mediaAnalyzer.getMediaList(1);
        if(note == null || pictures.isEmpty) return Container();
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

  Future<NoteDB?> _getNote(NotificationDB notificationDB) async {
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
        OXCommonHintAction.sure(text: 'Sure', onTap: () {
          setState(() {
            notificationsList = [];
          });
         return OXNavigator.pop(context);
        }),
      ],
      isRowAction: true,
    );

  }

  _loadNotificationData() async {
    int date = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    List<NotificationDB>? notificationList = await Moment.sharedInstance.loadNotificationsFromDB(date);
    List<NotificationDB> notificationOfLike = [];
    List<NotificationDB> notificationExceptLike = [];
    if(notificationList != null) {
      notificationOfLike = notificationList.where((element) => element.isLike).toList();
      notificationExceptLike = notificationList.where((element) => !element.isLike).toList();
    }
    Set<String> groupedItems = {};
    for (var element in notificationOfLike) {
      groupedItems.add(element.associatedNoteId);
    }

    Map<String, List<NotificationDB>> grouped = {};
    for (var groupedItem in groupedItems) {
      List<NotificationDB> temp = [];
      for (var element in notificationOfLike) {
        if (element.associatedNoteId == groupedItem) {
          temp.add(element);
        }
        //time DESC
        temp.sort((a, b) => a.createAt.compareTo(b.createAt));
        grouped[groupedItem] = temp;
      }
    }
    List<GroupedNotification> groupedNotificationList = notificationExceptLike.map((element) => GroupedNotification.fromNotification(element)).toList();
    grouped.forEach((key, value) {
      GroupedNotification groupedNotification = GroupedNotification.fromNotification(value.first);
      groupedNotification.likeCount = value.length;
      groupedNotificationList.add(groupedNotification);
    });

    setState(() {
      _notifications = notificationList ?? [];
    });
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
}

class GroupedNotification {
  String notificationId; //event id
  int kind; // 1：reply 2:quoteRepost 6:repost 7:reaction 9735:zap
  String author;
  int createAt;
  String content;
  int zapAmount;
  String associatedNoteId;
  int likeCount;

  GroupedNotification(
      {this.notificationId = '',
      this.kind = 0,
      this.author = '',
      this.createAt = 0,
      this.content = '',
      this.zapAmount = 0,
      this.associatedNoteId = '',
      this.likeCount = 0
      });

  factory GroupedNotification.fromNotification(NotificationDB notificationDB){
    return GroupedNotification(
      notificationId: notificationDB.notificationId,
      kind: notificationDB.kind,
      author: notificationDB.author,
      createAt: notificationDB.createAt,
      zapAmount: notificationDB.zapAmount,
      associatedNoteId: notificationDB.associatedNoteId,
    );
  }
}
