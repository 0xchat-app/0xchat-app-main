import 'package:flutter/material.dart';

///Title: MsgNotification
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author George
///CreateTime: 2023/6/27 9:35 AM
class MsgNotification extends Notification {
  MsgNotification({
    this.msgNum,
    this.noticeNum,
    this.actNum,
  });

  int? msgNum; //Messages
  int? noticeNum; //Notice
  int? actNum; //Activity
}