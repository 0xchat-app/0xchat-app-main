import 'dart:convert';

ProductListEntity myProductListEntityFromJson(String str) => ProductListEntity.fromJson(json.decode(str));

String myProductListEntityToJson(ProductListEntity data) => json.encode(data.toJson());

class ProductListEntity {
  ProductListEntity({
    List<ProductEntity>? productList,
  }) {
    _productList = productList;
  }

  ProductListEntity.fromJson(dynamic json) {
    if (json['productList'] != null) {
      _productList = [];
      json['productList'].forEach((v) {
        _productList?.add(ProductEntity.fromJson(v));
      });
    }
  }

  List<ProductEntity>? _productList;

  ProductListEntity copyWith({
    List<ProductEntity>? productList,
  }) =>
      ProductListEntity(
        productList: productList ?? _productList,
      );

  List<ProductEntity>? get productList => _productList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_productList != null) {
      map['productList'] = _productList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}


ProductEntity productListFromJson(String str) => ProductEntity.fromJson(json.decode(str));

String productListToJson(ProductEntity data) => json.encode(data.toJson());

class ProductEntity {
  ProductEntity({
    String? currency,
    String? description,
    num? price,
    String? productId,
    String? title,
    String? inPurchasingIdAndroid,
    String? inPurchasingIdIos,
    bool? hotFlag,
    String? badgeId,
  }) {
    _currency = currency;
    _description = description;
    _price = price;
    _productId = productId;
    _title = title;
    _inPurchasingIdAndroid = inPurchasingIdAndroid;
    _inPurchasingIdIos = inPurchasingIdIos;
    _hotFlag = hotFlag;
    _badgeId = badgeId;
  }

  ProductEntity.fromJson(dynamic json) {
    _currency = json['currency'];
    _description = json['description'];
    _price = json['price'];
    _productId = json['productId'];
    _title = json['title'];
    _inPurchasingIdAndroid = json['inPurchasingIdAndroid'];
    _inPurchasingIdIos = json['inPurchasingIdIos'];
    _hotFlag = json['hotFlag'];
    _badgeId = json['badgeId'];
  }

  String? _currency;
  String? _description;
  num? _price;
  String? _productId;
  String? _title;
  String? _inPurchasingIdAndroid;
  String? _inPurchasingIdIos;
  bool? _hotFlag;
  String? _badgeId;

  ProductEntity copyWith({
    String? currency,
    String? description,
    num? price,
    String? productId,
    String? title,
    String? inPurchasingIdAndroid,
    String? inPurchasingIdIos,
    bool? hotFlag,
    String? badgeId,
  }) =>
      ProductEntity(
        currency: currency ?? _currency,
        description: description ?? _description,
        price: price ?? _price,
        productId: productId ?? _productId,
        title: title ?? _title,
        inPurchasingIdAndroid: inPurchasingIdAndroid ?? _inPurchasingIdAndroid,
        inPurchasingIdIos: inPurchasingIdIos ?? _inPurchasingIdIos,
        hotFlag: hotFlag ?? _hotFlag,
        badgeId: badgeId ?? _badgeId,
      );

  String? get currency => _currency;

  String? get description => _description;

  num? get price => _price;

  String? get productId => _productId;

  String? get title => _title;

  String? get inPurchasingIdAndroid => _inPurchasingIdAndroid;

  String? get inPurchasingIdIos => _inPurchasingIdIos;

  bool? get hotFlag => _hotFlag;

  String? get badgeId => _badgeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency'] = _currency;
    map['description'] = _description;
    map['price'] = _price;
    map['productId'] = _productId;
    map['title'] = _title;
    map['inPurchasingIdAndroid'] = _inPurchasingIdAndroid;
    map['inPurchasingIdIos'] = _inPurchasingIdIos;
    map['hotFlag'] = _hotFlag;
    map['badgeId'] = _badgeId;
    return map;
  }

  @override
  String toString() {
    return 'ProductEntity{_currency: $_currency, _description: $_description, _price: $_price, _productId: $_productId, _title: $_title, _inPurchasingIdAndroid: $_inPurchasingIdAndroid, _inPurchasingIdIos: $_inPurchasingIdIos, _hotFlag: $_hotFlag, _badgeId: $_badgeId}';
  }
}
