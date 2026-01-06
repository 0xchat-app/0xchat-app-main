

import 'package:flutter/cupertino.dart';
import 'package:ox_common/network/network_adapter_template.dart';
import './network_general.dart';

/// Back-end data format declaration
abstract class OXNetworkResponseModel {
  @protected
  bool isMatchWithResponseInfo(Map json);
  @protected
  OXResponse responseWithInfo(Map json);
}

/// The Back-end returns the data adapter
class OXNetworkResponseAdapter {

  static List<OXNetworkResponseModel> models = [
    OXNormalResponse(), OXUploadResponse()
  ];

  static OXResponse responseModelWithInfo(dynamic json) {
    if (json is Map) {
      for (int i = 0; i < models.length; i++) {
        if (models[i].isMatchWithResponseInfo(json)) {
          return models[i].responseWithInfo(json);
        }
      }
    }
    return OXResponse(
      code: RESPONSE_CODE_SUCCESS,
      message: '',
      data: json
    );
  }
}