///Title: scan_jump_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 1/12/22 11:11 AM
class ScanJumpModel {
  bool? isNeedLogin;
  String? gid;
  String? scheme;

  ScanJumpModel({
    this.isNeedLogin,
    this.gid,
    this.scheme,
  });

  factory ScanJumpModel.fromJson(Map<String, dynamic> json) => _$ScanJumpModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScanJumpModelToJson(this);
}
ScanJumpModel _$ScanJumpModelFromJson(Map<String, dynamic> json){
  return ScanJumpModel(
    isNeedLogin: json.containsKey('isNeedLogin') ? json['isNeedLogin'] : false,
    gid: json.containsKey('gid') ? json['gid'].toString() : '',
    scheme: json.containsKey('scheme') ? json['scheme'].toString() : '',

  );
}

Map<String, dynamic> _$ScanJumpModelToJson(ScanJumpModel instance) {
  return <String, dynamic>{
    'isNeedLogin' : instance.isNeedLogin,
    'gid' : instance.gid,
    'scheme' : instance.scheme,
  };
}