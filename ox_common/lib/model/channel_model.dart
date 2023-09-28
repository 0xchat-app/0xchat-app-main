import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/network/network_general.dart';
import 'package:ox_network/network_manager.dart';

class ChannelModel {
  String? channelId;
  String? channelName;
  String? owner;
  String? about;
  String? picture;
  String? createTime;
  int? createTimeMs;
  List<String>? latestChatUsers;
  int? msgCount;

  ChannelModel(
      {this.channelId,
      this.channelName,
      this.owner,
      this.about,
      this.picture,
      this.createTime,
      this.createTimeMs,
      this.latestChatUsers,
      this.msgCount});

  factory ChannelModel.fromJson(Map<String, dynamic> json) {

    List<String> list = [];

    if (json['latestChatUsers'] != null) {
      json['latestChatUsers'].forEach((value) {
        list.add(value);
      });
    }

    return ChannelModel(
        channelId: json['channelId'] ?? '',
        channelName: json['channelName'] ?? '',
        owner: json['owner'] ?? '',
        about: json['about'] ?? '',
        picture: json['picture'] ?? '',
        createTime: json['createTime'] ?? '',
        createTimeMs: json['createTimeMs'] ?? 0,
        latestChatUsers: list,
        msgCount: json['msgCount'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'channelId': channelId,
      'channelName': channelName,
      'owner': owner,
      'about': about,
      'picture': picture,
      'createTime': createTime,
      'createTimeMs':createTimeMs,
      'latestChatUsers':latestChatUsers,
      'msgCount':msgCount
    };
  }

  ChannelDB toChannelDB() {
    return ChannelDB(
      channelId: channelId!,
      name: channelName,
      picture: picture,
      about: about,
      creator: owner ?? '',
      createTime: createTimeMs ?? 0,
    );
  }

  factory ChannelModel.fromChannelDB(ChannelDB channelDB){
    return ChannelModel(
        channelId: channelDB.channelId,
        channelName: channelDB.name,
        owner: channelDB.creator,
        about: channelDB.about,
        picture: channelDB.picture,
        createTimeMs: channelDB.createTime ?? 0,
    );
  }

  @override
  String toString() {
    return 'ChannelModel{channelId: $channelId, channelName: $channelName, owner: $owner, about: $about, picture: $picture, createTime: $createTime, createTimeMs: $createTimeMs, latestChatUsers: $latestChatUsers, msgCount: $msgCount}';
  }
}


Future<List<ChannelModel>> getHotChannels(
    {BuildContext? context,
    int? type,
    String? queryCode,
    bool? showErrorToast,
    bool? showLoading}) async {
  OXResponse response;
  String url = '${CommonConstant.baseUrl}/nostrchat/channel/getHotChannels';

  Map<String, dynamic>? params;

  if(type != null && queryCode == null){
    params = {"type": type ?? 1};
  }
  if(queryCode != null && type == null){
    params = {"queryCode": queryCode ?? ''};
  }else{
    params = {"type": type ?? 1, "queryCode": queryCode ?? ''};
  }

  try {
    response = await OXNetwork.instance.doRequest(context,
        url: url,
        showLoading: showLoading ?? true,
        showErrorToast: showLoading ?? true,
        needCommonParams: false,
        needRSA: false,
        type: RequestType.POST,
        params: params,
        contentType: OXNetwork.CONTENT_TYPE_JSON);

    List<dynamic> result = response.data;
    List<ChannelModel> channelModelList = [];
    for (var value in result) {
      channelModelList.add(ChannelModel.fromJson(value));
    }
    return channelModelList;
  } catch (e,s) {
    LogUtil.e('Get Channel List request failed: $e \r\n $s');
    return [];
  }
}


