import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_usercenter/model/notice_model.dart';

///Title: message_notification_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/6/6 14:46
class MessageNotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessageNotificationPageState();
  }
}

class _MessageNotificationPageState extends State<MessageNotificationPage> {
  List<NoticeModel> _allNoticeModelList = [];
  List<NoticeModel> _noticeModelList = [];
  late NoticeModel _messageNoticeModel;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _allNoticeModelList = await getObjectList();
    bool containsNotification = _allNoticeModelList.any((notice) => notice.id == CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS);
    if (!containsNotification) {
      _allNoticeModelList.add(NoticeModel(
        CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS,
        'Push Notifications',
        'We employ a privacy-oriented solution for our message push notifications. Technical details can be found here: ',
        true,
      ));
    }
    bool containsPrivMessages = _allNoticeModelList.any((notice) => notice.id == CommonConstant.NOTIFICATION_PRIVATE_MESSAGES);
    if (!containsPrivMessages) {
      _allNoticeModelList.add(NoticeModel(
        CommonConstant.NOTIFICATION_PRIVATE_MESSAGES,
        'Private Messages',
        'Enable notifications for private messages and secret chat requests, without compromising the privacy of your message contents.',
        true,
      ));
    }
    bool containsChannels = _allNoticeModelList.any((notice) => notice.id == CommonConstant.NOTIFICATION_CHANNELS);
    if (!containsChannels) {
      _allNoticeModelList.add(NoticeModel(
        CommonConstant.NOTIFICATION_CHANNELS,
        'Channels',
        'Enabling notifications for Channels will send your list of joined channels to the push server.',
        true,
      ));
    }
    bool containsZaps = _allNoticeModelList.any((notice) => notice.id == CommonConstant.NOTIFICATION_ZAPS);
    if (!containsZaps) {
      _allNoticeModelList.add(NoticeModel(
        CommonConstant.NOTIFICATION_ZAPS,
        'Zaps',
        'Only Zaps that support the Nostr protocol are able to receive Zap notifications.',
        true,
      ));
    }
    _allNoticeModelList.forEach((element) {
      if (element.id == CommonConstant.NOTIFICATION_PUSH_NOTIFICATIONS) {
        _messageNoticeModel = element;
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
        title: 'Notification',
        centerTitle: true,
        useLargeTitle: false,
      ),
      backgroundColor: ThemeColor.color190,
      body: _body().setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24))),
    );
  }

  Widget _body() {
    return Column(
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
          child: _itemContent(_messageNoticeModel, height: Adapt.px(80)),
        ),
        SizedBox(
          height: Adapt.px(12),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: ThemeColor.color180,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: _itemBuild,
            itemCount: _noticeModelList.length,
          ),
        ),
      ],
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    NoticeModel model = _noticeModelList[index];
    return Column(
      children: [
        _itemContent(model),
        _noticeModelList.length > 1 && _noticeModelList.length - 1 != index
            ? Container(
                color: ThemeColor.color160,
                height: Adapt.px(0.5),
              )
            : Container(),
      ],
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  model.name,
                  style: TextStyle(
                    color: ThemeColor.color0,
                    fontSize: Adapt.px(16),
                  ),
                ),
              ),
              _switchMute(model),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: model.description,
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
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [ThemeColor.gradientMainEnd, ThemeColor.gradientMainStart],
                        ).createShader(
                          Rect.fromLTWH(0.0, 0.0, 550.0, 70.0),
                        ),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                      _showWebView('', gitUrl);
                      },
                  ),
              ]
            ),
          ),
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
            for (var element in _allNoticeModelList) {
              element.isSelected = value;
            }
          }
          await saveObjectList(_allNoticeModelList);
          OXUserInfoManager.sharedInstance.setNotification();
        }
        await OXLoading.dismiss();
        setState(() {});
      },
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  Future<void> saveObjectList(List<NoticeModel> objectList) async {
    List<String> jsonStringList = objectList.map((obj) => json.encode(obj.noticeModelToMap(obj))).toList();
    await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_NOTIFICATION_SWITCH, jsonStringList);
  }

  Future<List<NoticeModel>> getObjectList() async {
    List<dynamic> dynamicList = await await OXCacheManager.defaultOXCacheManager.getForeverData(StorageKeyTool.KEY_NOTIFICATION_SWITCH, defaultValue: []);
    List<String> jsonStringList = dynamicList.cast<String>();
    List<NoticeModel> objectList = jsonStringList.map((jsonString) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      return NoticeModel(jsonMap['id'] ?? -1, jsonMap['name'] ?? '', jsonMap['description'] ?? '', jsonMap['isSelected'] ?? false);
    }).toList();

    return objectList;
  }

  Future _showWebView(String title, String url) {
    return OXNavigator.presentPage(
      context,
      (context) => CommonWebView(
        url,
        title: '0xchat',
      ),
    );
  }
}
