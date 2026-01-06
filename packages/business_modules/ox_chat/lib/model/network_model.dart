

import 'package:flutter/cupertino.dart';
import 'package:ox_network/network_manager.dart';

const baseNdsHost = 'https://www.dns.site/';

class ChecksModel{
  String? status;
  String? ip;
  String? country;
  String? area;
  String? lineArea;
  String? lineId;
  Map<String,dynamic>? toMap;

  ChecksModel({
    this.status,
    this.ip,
    this.country,
    this.area,
    this.lineArea,
    this.lineId,
    this.toMap
});

  factory ChecksModel.formJson(Map<String, dynamic> json){
    return ChecksModel(
        status: json['status']?.toString()??'',
        ip: json['ip']?.toString()??'',
        country: json['country']?.toString()??'',
        area: json['area']?.toString()??'',
        lineArea: json['lineArea']?.toString()??'',
        lineId: json['lineId']?.toString()??'',
        toMap: json
    );
  }
}

class DomainModel{
  String? domain;
  Map<String,dynamic>? toMap;

  DomainModel({
    this.domain,
    this.toMap,
  });

  factory DomainModel.formJson(Map<String, dynamic> json){
    return DomainModel(
        domain: json['Domain']?.toString()??'',
        toMap: json
    );
  }
}

Future<ChecksModel?> requestAreaChecks({BuildContext? context, params}) async {
  try {
    NetworkResponse result = await OXNetwork.instance.request(
      context,
      url: '${baseNdsHost}checks?p=16&u=12323&mz=616&clear=true',
      requestType: RequestType.GET,
    );
    if (result.code == 200) {
      ChecksModel model = ChecksModel.formJson(result.data);
      return model;
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<bool> requestTextLine({BuildContext? context, url}) async {
  try {
    NetworkResponse result = await OXNetwork.instance.request(
      context,
      url: 'https://vip.$url',
      requestType: RequestType.GET,
    );
    if (result.code == 200) {
      return true;
    }else{
      return false;
    }
  } catch (e) {
    return false;
  }
}