import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/model/user_config_db.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_push/push_lib.dart';
import 'package:ox_usercenter/model/notice_model.dart';
import 'package:ox_usercenter/page/set_up/settings_page.dart';
import 'package:ox_usercenter/utils/widget_tool.dart';

///Title: message_notification_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/6/6 14:46
class MessageNotificationPage extends StatefulWidget {
  const MessageNotificationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MessageNotificationPageState();
  }
}

class _MessageNotificationPageState extends State<MessageNotificationPage> {
  Map<int, NoticeModel> _allNoticeModel = {};
  final List<NoticeModel> _noticeModelList = [];
  NoticeModel? _messageNoticeModel;
  final List<NoticeModel> _feedbackList = [];
  String _pushName = '0xchat';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    if (Platform.isAndroid) {
      String? distributor = await UnifiedPush.getDistributor();
      _pushName = distributor != null ? getShowTitle(distributor) : _pushName;
    }
    _allNoticeModel = await getObjectList();
    bool containsNotification = _allNoticeModel.containsKey(CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS);
    if (!containsNotification) {
      _allNoticeModel[CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS] = NoticeModel(
        id: CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS,
        isSelected: true,
      );
    }
    bool containsPrivMessages = _allNoticeModel.containsKey(CommonConstant.NOTIFICATION_PRIVATE_MESSAGES);
    if (!containsPrivMessages) {
      _allNoticeModel[CommonConstant.NOTIFICATION_PRIVATE_MESSAGES] = NoticeModel(
        id: CommonConstant.NOTIFICATION_PRIVATE_MESSAGES,
        isSelected: true,
      );
    }
    bool containsChannels = _allNoticeModel.containsKey(CommonConstant.NOTIFICATION_CHANNELS);
    if (!containsChannels) {
      _allNoticeModel[CommonConstant.NOTIFICATION_CHANNELS] = NoticeModel(
        id: CommonConstant.NOTIFICATION_CHANNELS,
        isSelected: true,
      );
    }
    bool containsZaps = _allNoticeModel.containsKey(CommonConstant.NOTIFICATION_ZAPS);
    if (!containsZaps) {
      _allNoticeModel[CommonConstant.NOTIFICATION_ZAPS] = NoticeModel(
        id: CommonConstant.NOTIFICATION_ZAPS,
        isSelected: true,
      );
    }
    bool containsSound = _allNoticeModel.containsKey(CommonConstant.NOTIFICATION_SOUND);
    if(!containsSound){
      _allNoticeModel[CommonConstant.NOTIFICATION_SOUND] = NoticeModel(
        id: CommonConstant.NOTIFICATION_SOUND,
        isSelected: true,
      );
    }
    bool containsVibrate = _allNoticeModel.containsKey(CommonConstant.NOTIFICATION_VIBRATE);
    if(!containsVibrate){
      _allNoticeModel[CommonConstant.NOTIFICATION_VIBRATE] = NoticeModel(
        id: CommonConstant.NOTIFICATION_VIBRATE,
        isSelected: true,
      );
    }
    _allNoticeModel.forEach((key, element) {
      if (element.id == CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS) {
        _messageNoticeModel = element;
      } else if (element.id == CommonConstant.NOTIFICATION_SOUND || element.id == CommonConstant.NOTIFICATION_VIBRATE){
        _feedbackList.add(element);
      } else {
        _noticeModelList.add(element);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Localized.text('ox_usercenter.notifications'),
        centerTitle: true,
        useLargeTitle: false,
      ),
      backgroundColor: ThemeColor.color190,
      body: _body().setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24))),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Adapt.px(12),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Adapt.px(16)),
              color: ThemeColor.color180,
            ),
            child: _messageNoticeModel != null ? _itemContent(_messageNoticeModel!, height: Adapt.px(80)) : const SizedBox(),
          ),
          SizedBox(height: Adapt.px(12)),
          Platform.isAndroid ? _itemPushAppPicker() : const SizedBox(),
          Platform.isAndroid ? SizedBox(height: Adapt.px(12)) : const SizedBox(),
          _buildCardItem(_feedbackList),
          SizedBox(height: Adapt.px(12)),
          _buildCardItem(_noticeModelList),
        ],
      ),
    );
  }

  Widget _itemBuild(BuildContext context, int index,List<NoticeModel> noticeModelList) {
    NoticeModel model = noticeModelList[index];
    return Column(
      children: [
        _itemContent(model),
        noticeModelList.length > 1 && noticeModelList.length - 1 != index
            ? Container(
                color: ThemeColor.color160,
                height: Adapt.px(0.5),
              )
            : Container(),
      ],
    );
  }

  Widget _buildCardItem(List<NoticeModel> noticeModelList){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 0),
        itemBuilder: (context,index)=> _itemBuild(context, index, noticeModelList),
        itemCount: noticeModelList.length,
      ),
    );
  }

  Widget _itemPushAppPicker(){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        _pushName = await UnifiedPush.registerAppWithDialog(context) ?? 'Push Picker';
        setState(() {});
      },
      child: Container(
        width: double.infinity,
        height: Adapt.px(52),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(16)),
          color: ThemeColor.color180,
        ),
        alignment: Alignment.center,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
          title: Text(
            'str_push_app'.localized(),
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: 16.px,
            ),
          ),
          trailing: SizedBox(
            width: Adapt.px(140),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _pushName,
                  style: TextStyle(
                    color: ThemeColor.color100,
                    fontSize: 14.px,
                  ),
                ),
                CommonImage(
                  iconName: 'icon_arrow_more.png',
                  width: Adapt.px(24),
                  height: Adapt.px(24),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemContent(NoticeModel model, {double? height}) {
    String gitUrl = 'https://github.com/0xchat-app/0xchat-core/blob/main/doc/nofitications.md';
    return Container(
      constraints: BoxConstraints(
        minHeight: height ?? Adapt.px(60),
      ),
      padding: EdgeInsets.symmetric(vertical: Adapt.px(15), horizontal: Adapt.px(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  _showNameById(model.id),
                  style: TextStyle(
                    color: ThemeColor.color0,
                    fontSize: Adapt.px(16),
                  ),
                ),
              ),
              _switchMute(model),
            ],
          ),
          _showDescriptionById(model.id).isNotEmpty ? RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: _showDescriptionById(model.id),
                  style: TextStyle(
                    color: ThemeColor.color100,
                    fontSize: Adapt.px(12),
                  ),
                ),
                  model.id != CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS
                      ? const TextSpan()
                      : TextSpan(
                    text: gitUrl,
                    style: TextStyle(
                      fontSize: Adapt.px(12),
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [ThemeColor.gradientMainEnd, ThemeColor.gradientMainStart],
                        ).createShader(
                          Rect.fromLTWH(0.0, 0.0, Adapt.px(550), Adapt.px(70)),
                        ),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                      _showWebView('', gitUrl);
                      },
                  ),
              ]
            ),
          ) : Container(),
        ],
      ),
    );
  }

  Widget _switchMute(NoticeModel model) {
    return Switch(
      value: model.isSelected,
      activeColor: Colors.white,
      activeTrackColor: ThemeColor.gradientMainStart,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: ThemeColor.color160,
      onChanged: (bool value) async {
        await OXLoading.show();
        if (value != model.isSelected) {
          model.isSelected = value;
          if (model.id == CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS) {
            for (var element in _allNoticeModel.values) {
              element.isSelected = value;
            }
          }
          await saveObjectList(_allNoticeModel.values.toList());
          OXUserInfoManager.sharedInstance.setNotification();
          if(model.id == CommonConstant.NOTIFICATION_VIBRATE){
            OXUserInfoManager.sharedInstance.canVibrate = value;
          }
          if(model.id == CommonConstant.NOTIFICATION_SOUND){
            OXUserInfoManager.sharedInstance.canSound = value;
          }
        }
        await OXLoading.dismiss();
        if(mounted){
          setState(() {});
        }
      },
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  Future<void> saveObjectList(List<NoticeModel> objectList) async {
    List<String> jsonStringList = objectList.map((obj) => json.encode(obj.noticeModelToMap(obj))).toList();
    final bool result = await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_NOTIFICATION_SWITCH, jsonStringList);
    UserConfigDB? userConfigDB = await UserConfigTool.getUserConfigFromDB();
    if (userConfigDB != null) {
      userConfigDB.notificationSettings = json.encode(jsonStringList);
      UserConfigTool.updateUserConfigDB(userConfigDB);
    }
  }

  Future<Map<int, NoticeModel>> getObjectList() async {
    List<dynamic> dynamicList = await await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_NOTIFICATION_SWITCH, defaultValue: []);
    Map<int, NoticeModel> resultMap = {};
    if (dynamicList.isNotEmpty) {
      List<String> jsonStringList = dynamicList.cast<String>();
      for (var jsonString in jsonStringList) {
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        resultMap[jsonMap['id'] ?? 0] = NoticeModel(id: jsonMap['id'] ?? 0, isSelected: jsonMap['isSelected'] ?? false);
      }
    }
    return resultMap;
  }

  Future _showWebView(String title, String url) {
    return OXNavigator.presentPage(
      context,
      (context) => CommonWebView(
        url,
        title: '0xchat',
      ),
      fullscreenDialog: true,
    );
  }

  String _showNameById(int id) {
    if (id == CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS) {
      return Localized.text('ox_usercenter.push_notifications');
    } else if (id == CommonConstant.NOTIFICATION_PRIVATE_MESSAGES) {
      return Localized.text('ox_usercenter.private_messages_notifications');
    } else if (id == CommonConstant.NOTIFICATION_CHANNELS) {
      return Localized.text('ox_usercenter.channels');
    } else if (id == CommonConstant.NOTIFICATION_ZAPS) {
      return Localized.text('ox_usercenter.zaps');
    } else if (id == CommonConstant.NOTIFICATION_SOUND) {
      return Localized.text('ox_usercenter.sound_feedback');
    } else if (id == CommonConstant.NOTIFICATION_VIBRATE) {
      return Localized.text('ox_usercenter.vibrate_feedback');
    }
    return '';
  }

  String _showDescriptionById(int id) {
    if (id == CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS) {
      return Localized.text('ox_usercenter.push_notifications_tips');
    } else if (id == CommonConstant.NOTIFICATION_PRIVATE_MESSAGES) {
      return Localized.text('ox_usercenter.private_messages_notifications_tips');
    } else if (id == CommonConstant.NOTIFICATION_CHANNELS) {
      return Localized.text('ox_usercenter.channels_notifications_tips');
    } else if (id == CommonConstant.NOTIFICATION_ZAPS) {
      return Localized.text('ox_usercenter.zaps_notifications_tips');
    }
    return '';
  }
}
