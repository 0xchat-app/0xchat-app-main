import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/widgets/common_toast.dart';

///Title: took_kit
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/4/26 18:02
class TookKit{
  static String getShortStrByHex64(String hex64){
    // First, the hexadecimal string is converted to an array of bytes
    List<int> bytes = hexStringToBytes(hex64);

    // The byte array is then converted to a short string using Base64 encoding
    String base64String = base64Encode(bytes);
    return base64String;
  }

  static String decodeHex64(String base64String){

    // Use Base64 decoding to restore a short string to an array of bytes
    List<int> decodedBytes = base64Decode(base64String);
    // Finally, the byte array is converted back to a hexadecimal string
    String decodedHex64 = bytesToHexString(decodedBytes);
    print('The decoded hexadecimal string: $decodedHex64');
    return decodedHex64;
  }


  static List<int> hexStringToBytes(String hex) {
    int length = hex.length;
    List<int> bytes = List<int>.generate(length ~/ 2, (index) => 0);

    for (int i = 0; i < length; i += 2) {
      bytes[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }

    return bytes;
  }

  static String bytesToHexString(List<int> bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  static Future<void> copyKey(BuildContext context, String keyContent) async {
    await Clipboard.setData(
      ClipboardData(
        text: keyContent,
      ),
    );
    await CommonToast.instance
        .show(context, 'copied_to_clipboard'.commonLocalized());
  }

  static Future<void> vibrateEffect() async {
    if(PlatformUtils.isMobile) {
      if (OXUserInfoManager.sharedInstance.canVibrate) {
        Vibrate.feedback(FeedbackType.impact);
      }
    }
  }
}