import 'dart:convert';

///Title: benefits_model
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/8 15:17
/// benefit : "Stand out in Comments"
/// imageUrl : "https://0xchat.com/ipfs/QmQ6WHeH8fcJoJNF6SoG6AKGDZ9WxY4e2RmPAgJLQhHpZB"

BenefitsModel benefitsFromJson(String str) => BenefitsModel.fromJson(json.decode(str));

String benefitsToJson(BenefitsModel data) => json.encode(data.toJson());

class BenefitsModel {
  BenefitsModel({
    String? benefit,
    String? imageUrl,
  }) {
    _benefit = benefit;
    _imageUrl = imageUrl;
  }

  BenefitsModel.fromJson(dynamic json) {
    _benefit = json['benefit'];
    _imageUrl = json['imageUrl'];
  }

  String? _benefit;
  String? _imageUrl;

  BenefitsModel copyWith({
    String? benefit,
    String? imageUrl,
  }) =>
      BenefitsModel(
        benefit: benefit ?? _benefit,
        imageUrl: imageUrl ?? _imageUrl,
      );

  String? get benefit => _benefit;

  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['benefit'] = _benefit;
    map['imageUrl'] = _imageUrl;
    return map;
  }
}
