import 'dart:io';

import 'package:flutter/services.dart';

///Title: core_method_channel
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/11/29 17:39
class CoreMethodChannel{
  static const MethodChannel channelChatCore = MethodChannel('com.oxchat.nostrcore');


  ///check an app is installed/enabled
  static Future<bool> isAppInstalled(String packageName) async {
    final bool result = await channelChatCore.invokeMethod(
      'isAppInstalled',
      {
        'packageName': packageName,
      },
    );
    return result;
  }

  static Future<bool> isInstalledAmber() async {
    if (Platform.isIOS) return false;
    final bool result = await isAppInstalled('com.greenart7c3.nostrsigner');
    return result;
  }

  /// Check if nostrsigner scheme is supported by any installed app
  /// This method doesn't require QUERY_ALL_PACKAGES permission
  static Future<bool> isNostrSignerSupported() async {
    if (Platform.isIOS) return false;
    final bool result = await channelChatCore.invokeMethod('isNostrSignerSupported');
    return result;
  }

  /// Get all installed external signers that support nostrsigner:// scheme
  /// Returns a list of maps containing packageName and appName
  /// Reference: NIP-55 https://github.com/nostr-protocol/nips/blob/master/55.md
  static Future<List<Map<String, String>>> getInstalledExternalSigners() async {
    if (Platform.isIOS) return [];
    final List<dynamic> result = await channelChatCore.invokeMethod('getInstalledExternalSigners');
    return result.map((e) => Map<String, String>.from(e as Map)).toList();
  }
}