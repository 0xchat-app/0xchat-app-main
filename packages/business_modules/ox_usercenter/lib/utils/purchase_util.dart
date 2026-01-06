
import 'package:flutter/cupertino.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_network/network_manager.dart';
import 'package:ox_common/network/network_general.dart';
import 'package:ox_usercenter/model/product_list_entity.dart';

///Title: purchase_util
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/7/4 16:52
class PurchaseUtil {
  //request price list
  static Future<List<ProductEntity>?> getProductList({
    BuildContext? context,
    required String pubKey,
  }) async {
    return OXNetwork.instance
        .doRequest(
      null,
      url: '${CommonConstant.baseUrl}/nostrchat/donate/getProductList',
      type: RequestType.GET,
      params: {'pubKey': pubKey},
      needRSA: false,
      needCommonParams: false,
      showLoading: true,
    )
        .then((result) {
      List<ProductEntity>? productList;
      Map<String, dynamic> dataMap = Map<String, dynamic>.from(result.data);
      if (dataMap.isNotEmpty) {
        ProductListEntity assetsEntity = ProductListEntity.fromJson(Map<String, dynamic>.from(dataMap));
        return assetsEntity.productList;
      }

      return productList;
    }).catchError((error) {
      LogUtil.e(error);
      CommonToast.instance.show(context, error.message);
      return null;
    });
  }

  static Future<bool> validationPay({
    BuildContext? context,
    required Map<String, dynamic> dataMap,
  }) async {
    return OXNetwork.instance
        .doRequest(
      null,
      url: '${CommonConstant.baseUrl}/nostrchat/donate/validationPay',
      type: RequestType.POST,
      params: dataMap,
      needRSA: false,
      needCommonParams: false,
    )
        .then((result) {
      bool payResult = false;
      Map<String, dynamic> dataMap = Map<String, dynamic>.from(result.data);
      if (dataMap.isNotEmpty) {
        payResult = dataMap['result'] as bool;
        return payResult;
      }

      return payResult;
    }).catchError((error) {
      LogUtil.e(error);
      CommonToast.instance.show(context, error.message);
      return false;
    });
  }
}
