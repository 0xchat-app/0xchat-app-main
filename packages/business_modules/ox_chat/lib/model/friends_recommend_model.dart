
class FriendsRecommendModel {
  FriendsRecommendModel({
      List<RelatedFriendList>? relatedFriendList, 
      List<RecommendGroupList>? recommendGroupList, 
      List<BannerList>? bannerList,}){
    _relatedFriendList = relatedFriendList;
    _recommendGroupList = recommendGroupList;
    _bannerList = bannerList;
}

  FriendsRecommendModel.fromJson(dynamic json) {
    if (json['relatedFriendList'] != null) {
      _relatedFriendList = [];
      json['relatedFriendList'].forEach((v) {
        _relatedFriendList?.add(RelatedFriendList.fromJson(v));
      });
    }
    if (json['recommendGroupList'] != null) {
      _recommendGroupList = [];
      json['recommendGroupList'].forEach((v) {
        _recommendGroupList?.add(RecommendGroupList.fromJson(v));
      });
    }
    if (json['bannerList'] != null) {
      _bannerList = [];
      json['bannerList'].forEach((v) {
        _bannerList?.add(BannerList.fromJson(v));
      });
    }
  }
  List<RelatedFriendList>? _relatedFriendList;
  List<RecommendGroupList>? _recommendGroupList;
  List<BannerList>? _bannerList;
  FriendsRecommendModel copyWith({  List<RelatedFriendList>? relatedFriendList,
  List<RecommendGroupList>? recommendGroupList,
  List<BannerList>? bannerList,
}) => FriendsRecommendModel(  relatedFriendList: relatedFriendList ?? _relatedFriendList,
  recommendGroupList: recommendGroupList ?? _recommendGroupList,
  bannerList: bannerList ?? _bannerList,
);
  List<RelatedFriendList>? get relatedFriendList => _relatedFriendList;
  List<RecommendGroupList>? get recommendGroupList => _recommendGroupList;
  List<BannerList>? get bannerList => _bannerList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_relatedFriendList != null) {
      map['relatedFriendList'] = _relatedFriendList?.map((v) => v.toJson()).toList();
    }
    if (_recommendGroupList != null) {
      map['recommendGroupList'] = _recommendGroupList?.map((v) => v.toJson()).toList();
    }
    if (_bannerList != null) {
      map['bannerList'] = _bannerList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class BannerList {
  BannerList({
      String? linkUrl,
      num? createTime, 
      num? id, 
      String? imageUrl, 
      num? status, 
      String? desc,}){
    _linkUrl = linkUrl;
    _createTime = createTime;
    _id = id;
    _imageUrl = imageUrl;
    _status = status;
    _desc = desc;
}

  BannerList.fromJson(dynamic json) {
    _linkUrl = json['linkUrl'];
    _createTime = json['createTime'];
    _id = json['id'];
    _imageUrl = json['imageUrl'];
    _status = json['status'];
    _desc = json['desc'];
  }
  String? _linkUrl;
  num? _createTime;
  num? _id;
  String? _imageUrl;
  num? _status;
  String? _desc;
BannerList copyWith({  String? linkUrl,
  num? createTime,
  num? id,
  String? imageUrl,
  num? status,
  String? desc,
}) => BannerList(  linkUrl: linkUrl ?? _linkUrl,
  createTime: createTime ?? _createTime,
  id: id ?? _id,
  imageUrl: imageUrl ?? _imageUrl,
  status: status ?? _status,
  desc: desc ?? _desc,
);
  String? get linkUrl => _linkUrl;
  num? get createTime => _createTime;
  num? get id => _id;
  String? get imageUrl => _imageUrl;
  num? get status => _status;
  String? get desc => _desc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['linkUrl'] = _linkUrl;
    map['createTime'] = _createTime;
    map['id'] = _id;
    map['imageUrl'] = _imageUrl;
    map['status'] = _status;
    map['desc'] = _desc;
    return map;
  }

}

class RecommendGroupList {
  RecommendGroupList({
      String? groupId, 
      List<String>? first5HeadUrl, 
      String? groupName,
    String? groupNotice,
    String? backgroundUrl,
    String? collectionName,
    String? collectionCreator,
    String? collectionLogo,
  }){
    _groupId = groupId;
    _first5HeadUrl = first5HeadUrl;
    _groupName = groupName;
    _groupNotice = groupNotice;
    _backgroundUrl = backgroundUrl;
    _collectionName = collectionName;
    _collectionCreator = collectionCreator;
    _collectionLogo = collectionLogo;
}

  RecommendGroupList.fromJson(dynamic json) {
    _groupId = json['groupId'];
    _first5HeadUrl = json['first5HeadUrl'] != null ? json['first5HeadUrl'].cast<String>() : [];
    _groupName = json['groupName'];
    if (json['groupNotice'] != null) {
      _groupNotice = json['groupNotice'];
    }else{
      _groupNotice = '';
    }
    _backgroundUrl = json['backgroundUrl'];
    _collectionName = json['collectionName'];
    _collectionCreator = json['collectionCreator'];
    _collectionLogo = json['collectionLogo'];
  }

  String? _groupId;
  List<String>? _first5HeadUrl;
  String? _groupName;
  dynamic _groupNotice;
  String? _backgroundUrl;
  String? _collectionName;
  String? _collectionCreator;
  String? _collectionLogo;
RecommendGroupList copyWith({  String? groupId,
  List<String>? first5HeadUrl,
  String? groupName,
  dynamic groupNotice,
  String? backgroundUrl,
  String? collectionName,
  String? collectionCreator,
  String? collectionLogo,
}) => RecommendGroupList(  groupId: groupId ?? _groupId,
  first5HeadUrl: first5HeadUrl ?? _first5HeadUrl,
  groupName: groupName ?? _groupName,
  groupNotice: groupNotice ?? _groupNotice,
  backgroundUrl: backgroundUrl ?? _backgroundUrl,
  collectionName: collectionName ?? _collectionName,
  collectionCreator: collectionCreator ?? _collectionCreator,
  collectionLogo: collectionLogo ?? _collectionLogo,
);
  String? get groupId => _groupId;
  List<String>? get first5HeadUrl => _first5HeadUrl;
  String? get groupName => _groupName;
  dynamic get groupNotice => _groupNotice;

  String? get backgroundUrl => _backgroundUrl;
  String? get collectionName => _collectionName;
  String? get collectionCreator => _collectionCreator;
  String? get collectionLogo => _collectionLogo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = _groupId;
    map['first5HeadUrl'] = _first5HeadUrl;
    map['groupName'] = _groupName;
    map['groupNotice'] = _groupNotice;
    map['backgroundUrl'] = _backgroundUrl;
    map['collectionName'] = _collectionName;
    map['collectionCreator'] = _collectionCreator;
    map['collectionLogo'] = _collectionLogo;

    return map;
  }

}

class RelatedFriendList {
  RelatedFriendList({
      String? headerUrl, 
      String? userUid, 
      String? nickname, 
      String? address,}){
    _headerUrl = headerUrl;
    _userUid = userUid;
    _nickname = nickname;
    _address = address;
}

  RelatedFriendList.fromJson(dynamic json) {
    _headerUrl = json['headerUrl'];
    _userUid = json['userUid'];
    _nickname = json['nickname'];
    _address = json['address'];
  }
  String? _headerUrl;
  String? _userUid;
  String? _nickname;
  String? _address;
RelatedFriendList copyWith({  String? headerUrl,
  String? userUid,
  String? nickname,
  String? address,
}) => RelatedFriendList(  headerUrl: headerUrl ?? _headerUrl,
  userUid: userUid ?? _userUid,
  nickname: nickname ?? _nickname,
  address: address ?? _address,
);
  String? get headerUrl => _headerUrl;
  String? get userUid => _userUid;
  String? get nickname => _nickname;
  String? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['headerUrl'] = _headerUrl;
    map['userUid'] = _userUid;
    map['nickname'] = _nickname;
    map['address'] = _address;
    return map;
  }

}