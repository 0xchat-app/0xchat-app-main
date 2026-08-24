
enum ResponseCode {
  success(0),
  failed(1),
  notAllowedError(10000),
  transactionError(11000),
  tokenAlreadySpentError(11001),
  secretTooLongError(11003),
  noSecretInProofsError(11004),
  keysetError(12000),
  keysetNotFoundError(12001),
  lightningError(20000),
  invoiceNotPaidError(2001);

  final int value;

  const ResponseCode(this.value);

  static ResponseCode fromValue(int value) {
    return ResponseCode.values.where((e) => e.value == value).firstOrNull ?? ResponseCode.failed;
  }
}

extension ResponseCodeEx on ResponseCode {
  Set<String> get subErrorText {
    switch (this) {
      case ResponseCode.success: return {};
      case ResponseCode.failed: return {};
      case ResponseCode.notAllowedError: return {};
      case ResponseCode.transactionError: return {};
      case ResponseCode.tokenAlreadySpentError:
        return {
          'Token already spent',
        };
      case ResponseCode.secretTooLongError: return {};
      case ResponseCode.noSecretInProofsError: return {};
      case ResponseCode.keysetError: return {};
      case ResponseCode.keysetNotFoundError: return {};
      case ResponseCode.lightningError: return {};
      case ResponseCode.invoiceNotPaidError: return {
        'quote not paid',
      };
    }
  }

  static ResponseCode? tryGetCodeWithErrorMsg(String text) {
    if (text.isEmpty) return null;
    final allEnum = [...ResponseCode.values];
    for (final e in allEnum) {
      if (e.subErrorText.any((errorText) => text.contains(errorText))) {
        return e;
      }
    }
    return null;
  }
}

class CashuResponse<T> {
  CashuResponse({
    this.code = ResponseCode.success,
    this.errorMsg = '',
    T? data,
  }) : _data = data;

  /// Response code indicating the status of the response.
  final ResponseCode code;

  /// Error message providing details in case of a failure response.
  final String errorMsg;

  /// Private data field that holds the actual data of the response.
  final T? _data;

  /// Indicates whether the response is a success.
  bool get isSuccess => code == ResponseCode.success;

  /// Data associated with the response.
  ///
  /// This property should only be accessed when `isSuccess` is true.
  /// Attempting to access `data` when `isSuccess` is false may cause a runtime error
  /// due to null data.
  T get data => _data!;

  factory CashuResponse.generalError() {
    return CashuResponse.fromErrorMsg(
      'Network exception, please try again later',
    );
  }

  factory CashuResponse.fromSuccessData(T data) {
    return CashuResponse(
      data: data,
    );
  }

  factory CashuResponse.fromErrorMsg(String message) {
    return CashuResponse(
      code: ResponseCode.failed,
      errorMsg: message,
    );
  }

  factory CashuResponse.fromErrorMap(Map map) {
    ResponseCode code = ResponseCode.fromValue(map['code']);
    if (code == ResponseCode.success) {
      code = ResponseCode.failed;
    }
    return CashuResponse(
      code: code,
      errorMsg: map['detail'] ?? ''
    );
  }

  @override
  String toString() {
    return '${super.toString()}, code: $code, errorMsg: $errorMsg, data: $_data';
  }

  CashuResponse<R> cast<R>() {
    R? newData;
    if (_data is R?) {
      newData = _data as R?;
    }
    return CashuResponse<R>(
      code: code,
      errorMsg: errorMsg,
      data: newData,
    );
  }
}

typedef CashuProgressCallback = Function(String statusText);
