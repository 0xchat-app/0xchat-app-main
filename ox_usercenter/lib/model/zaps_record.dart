import 'package:flutter/material.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/network/network_general.dart';
import 'package:ox_network/network_manager.dart';
import 'package:intl/intl.dart';

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

  factory ZapsRecord.fromJson(Map<String, dynamic> json){
    List<ZapsRecordDetail> list = [];

    if (json['list'] != null) {
      json['list'].forEach((value) {
        list.add(ZapsRecordDetail.fromJson(value));
      });
    }

    return ZapsRecord(
      currentPage: json['currentPage'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPage: json['totalPage'] ?? 0,
      list: list,
      totalZaps: json['totalZaps'],
      offset: json['offset'],
    );
  }
}

class ZapsRecordDetail {
  final String? id;
  final double? amount;
  final String? fromPubKey;
  final String? toPubKey;
  final String? zapsTime;
  final String? donationDesc;
  final String? donationId;
  final String? currency;

  Map<String, String> get zapsRecordAttributes => <String, String>{
        'Zaps': '+$amount',
        'ID': donationId ?? '',
        'From': fromPubKey ?? '',
        'To': toPubKey ?? '',
        'Time': zapsTimeFormat,
      };

  String get zapsTimeFormat => DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(zapsTime ?? ''));

  ZapsRecordDetail({
    this.id,
    this.amount,
    this.fromPubKey,
    this.toPubKey,
    this.zapsTime,
    this.donationDesc,
    this.donationId,
    this.currency,
  });

  factory ZapsRecordDetail.fromJson(Map<String, dynamic> json) {
    return ZapsRecordDetail(
      id: json['id'] ?? '',
      amount: json['amount'] ?? '',
      fromPubKey: json['fromPubKey'] ?? '',
      toPubKey: json['toPubKey'] ?? '',
      zapsTime: json['zapsTime'] ?? '',
      donationDesc: json['donationDesc'] ?? '',
      donationId: json['donationId'] ?? '',
      currency: json['currency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['amount'] = amount;
    map['fromPubkey'] = fromPubKey;
    map['toPubkey'] = toPubKey;
    map['zapsTime'] = zapsTime;
    map['donationDesc'] = donationDesc;
    map['donationId'] = donationId;
    map['currency'] = currency;

    return map;
  }

  @override
  String toString() {
    return 'ZapsRecordDetail{id: $id, amount: $amount, fromPubkey: $fromPubKey, toPubkey: $toPubKey, zapsTime: $zapsTime, donationDesc: $donationDesc, donationId: $donationId, currency: $currency}';
  }
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

    ZapsRecord zapsRecord = ZapsRecord.fromJson(response.data);
    return zapsRecord;
  } catch (e,s) {
    LogUtil.e('Get zaps record request failed: $e \r\n $s');
    return null;
  }
}
