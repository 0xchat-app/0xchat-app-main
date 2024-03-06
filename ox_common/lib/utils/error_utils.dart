import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ox_network/network_manager.dart';
import 'package:ox_common/network/network_general.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

///Title: error_utils
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/3/5 20:19
class ErrorUtils{
  static Future<void> logErrorToFile(String error) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/errors.txt';
    final file = File(path);
    await file.writeAsString('\n$error\n', mode: FileMode.append);
  }


  static Future<void> sendLogs(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/errors.txt';
    final file = File(path);
    if (await file.exists()) {
      OXNetwork.instance.doUpload(
       context,
        url: '',
      fileList: [],
       params: {
       'uniqueId': 1,
       'type': '2',
       }
       ).then((OXResponse response) {

       }).catchError((e) {
       });
    }
  }
}