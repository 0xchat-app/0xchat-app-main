import 'package:flutter/material.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/network/network_general.dart';
import 'package:ox_network/network_manager.dart';

const String NIP05_SUCCESSFUL = '000000';
const String NIP05_URL_EXIST = '200001';
const String NIP05_URL_FAILED = '200002';
const String NIP05_URL_SIGN_ERROR = '200001';
const String NIP05_LEVEL_NOT = '200004';


Future<Map<String, dynamic>?> registerNip05({BuildContext? context,
  Map<String, dynamic>? params,
  bool? showErrorToast,
  bool? showLoading}) async {
  OXResponse response;

  String url = '${CommonConstant.baseUrl}/nostrchat/nip05/registerNip05';

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

    if (response.data is Map) {
      return response.data;
    }
    return null;
  } catch (e) {
    return null;
  }
}
