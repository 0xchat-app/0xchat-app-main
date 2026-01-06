
import './network_general.dart';
import './network_adapter.dart';

class OXNormalResponse extends OXNetworkResponseModel {

  static const MessageKey = 'data';

  @override
  bool isMatchWithResponseInfo(Map json) {
    return json.keys.contains(MessageKey);
  }

  @override
  OXResponse responseWithInfo(Map json) {
    return OXResponse(
        code: json['code']?.toString() ?? RESPONSE_CODE_SUCCESS,
        message: json['message'] ?? '',
        data: json[MessageKey]
    );
  }
}

class OXUploadResponse extends OXNetworkResponseModel {

  static const SuccessKey = 'isSuc';
  static const MessageKey = 'msg';

  @override
  bool isMatchWithResponseInfo(Map json) {
    return json.keys.contains(SuccessKey) && json.keys.contains(MessageKey);
  }

  @override
  OXResponse responseWithInfo(Map json) {
    final isSuccess = json[SuccessKey] as bool;
    return OXResponse(
        code: isSuccess ? RESPONSE_CODE_SUCCESS : RESPONSE_CODE_ERROR,
        message: json['MessageKey'] ?? '',
        data: json
    );
  }
}

