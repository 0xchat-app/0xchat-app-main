import 'package:flutter/material.dart';
import 'package:ox_common/business_interface/ox_usercenter/zaps_detail_model.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/network/network_general.dart';
import 'package:ox_network/network_manager.dart';

class ZapsRecord {
  final int? currentPage;
  final int? pageSize;
  final int? totalPage;
  final List<ZapsRecordDetail>? list;
  final double? totalZaps;
  final int? offset;

  ZapsRecord(
      {this.currentPage,
      this.pageSize,
      this.totalPage,
      this.list,
      this.totalZaps,
      this.offset});
}

Future<ZapsRecord?> getZapsRecord({BuildContext? context, String? userPubKey,int currentPage = 1, bool? showErrorToast, bool? showLoading}) async {

  OXResponse response;
  String url = '${CommonConstant.baseUrl}/nostrchat/zaps/getRecord';

  try {
    response = await OXNetwork.instance.doRequest(context,
        url: url,
        showLoading: showLoading ?? false,
        showErrorToast: showLoading ?? true,
        needCommonParams: false,
        needRSA: false,
        type: RequestType.POST,
        params: {"userPubKey": userPubKey, "currentPage": currentPage},
        contentType: OXNetwork.CONTENT_TYPE_JSON);

    // ZapsRecord zapsRecord = ZapsRecord.fromJson(response.data);
    // return zapsRecord;
    return null;
  } catch (e,s) {
    LogUtil.e('Get zaps record request failed: $e \r\n $s');
    return null;
  }
}
