import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/storage_key_tool.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_webview.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
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
  Map<int, NoticeModel> _allNoticeModel = {};
  List<NoticeModel> _noticeModelList = [];
  NoticeModel? _messageNoticeModel;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
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
    _allNoticeModel.forEach((key, element) {
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
        title: Localized.text('ox_usercenter.notifications'),
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
          child: _messageNoticeModel != null ? _itemContent(_messageNoticeModel!, height: Adapt.px(80)) : const SizedBox(),
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
          RichText(
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
            for (var element in _allNoticeModel.values) {
              element.isSelected = value;
            }
          }
          await saveObjectList(_allNoticeModel.values.toList());
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
    final bool result = await OXCacheManager.defaultOXCacheManager.saveForeverData(StorageKeyTool.KEY_NOTIFICATION_SWITCH, jsonStringList);
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
