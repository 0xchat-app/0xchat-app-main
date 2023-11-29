import 'package:ox_common/ox_common.dart';

///Title: external_signer_tool
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/11/29 11:21
class ExternalSignerTool {
  ///get_public_key
  static Future<String?> getPubKey() async {
    final Object? result = await OXCommon.channelPreferences.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.GET_PUBLIC_KEY.name,
        'requestCode': SignerType.GET_PUBLIC_KEY.requestCode,
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap['signature'];
  }

  ///sign_event
  ///@return signature、id、event
  static Future<Map<String, String>?> signEvent(String eventJson, String id, String current_user) async {
    final Object? result = await OXCommon.channelPreferences.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.SIGN_EVENT.name,
        'id': id,
        'current_user': current_user,
        'requestCode': SignerType.SIGN_EVENT.requestCode,
        'extendParse': eventJson,
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap;
  }

  ///nip04_encrypt
  ///@return signature、id
  static Future<Map<String, String>?> nip04Encrypt(String plaintext, String id, String current_user, String pubKey) async {
    final Object? result = await OXCommon.channelPreferences.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.NIP04_ENCRYPT.name,
        'id': id,
        'current_user': current_user,
        'pubKey': pubKey,
        'requestCode': SignerType.NIP04_ENCRYPT.requestCode,
        'extendParse': plaintext,
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap;
  }

  ///nip44_encrypt
  ///@return signature、id
  static Future<Map<String, String>?> nip44Encrypt(String plaintext, String id, String current_user, String pubKey) async {
    final Object? result = await OXCommon.channelPreferences.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.NIP44_ENCRYPT.name,
        'id': id,
        'current_user': current_user,
        'pubKey': pubKey,
        'requestCode': SignerType.NIP44_ENCRYPT.requestCode,
        'extendParse': plaintext,
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap;
  }

  ///nip04_decrypt
  ///@return signature、id
  static Future<Map<String, String>?> nip04Decrypt(String encryptedText, String id, String current_user, String pubKey) async {
    final Object? result = await OXCommon.channelPreferences.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.NIP04_DECRYPT.name,
        'id': id,
        'current_user': current_user,
        'pubKey': pubKey,
        'requestCode': SignerType.NIP04_DECRYPT.requestCode,
        'extendParse': encryptedText,
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap;
  }

  ///nip44_decrypt
  ///@return signature、id
  static Future<Map<String, String>?> nip44Decrypt(String encryptedText, String id, String current_user, String pubKey) async {
    final Object? result = await OXCommon.channelPreferences.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.NIP44_DECRYPT.name,
        'id': id,
        'current_user': current_user,
        'pubKey': pubKey,
        'requestCode': SignerType.NIP44_DECRYPT.requestCode,
        'extendParse': encryptedText,
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap;
  }

  ///decrypt_zap_event
  ///@return signature、id
  static Future<Map<String, String>?> decryptZapEvent(String encryptedText, String id, String current_user) async {
    final Object? result = await OXCommon.channelPreferences.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.DECRYPT_ZAP_EVENT.name,
        'id': id,
        'current_user': current_user,
        'requestCode': SignerType.DECRYPT_ZAP_EVENT.requestCode,
        'extendParse': encryptedText,
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap;
  }
}

enum SignerType {
  SIGN_EVENT,
  NIP04_ENCRYPT,
  NIP04_DECRYPT,
  NIP44_ENCRYPT,
  NIP44_DECRYPT,
  GET_PUBLIC_KEY,
  DECRYPT_ZAP_EVENT,
}

extension SignerTypeEx on SignerType {
  String get name {
    switch (this) {
      case SignerType.GET_PUBLIC_KEY:
        return 'get_public_key';
      case SignerType.SIGN_EVENT:
        return 'sign_event';
      case SignerType.NIP04_ENCRYPT:
        return 'nip04_encrypt';
      case SignerType.NIP04_DECRYPT:
        return 'nip04_decrypt';
      case SignerType.NIP44_ENCRYPT:
        return 'nip44_encrypt';
      case SignerType.NIP44_DECRYPT:
        return 'nip44_decrypt';
      case SignerType.DECRYPT_ZAP_EVENT:
        return 'decrypt_zap_event';
    }
  }

  int get requestCode {
    switch (this) {
      case SignerType.GET_PUBLIC_KEY:
        return 101;
      case SignerType.SIGN_EVENT:
        return 102;
      case SignerType.NIP04_ENCRYPT:
        return 103;
      case SignerType.NIP04_DECRYPT:
        return 104;
      case SignerType.NIP44_ENCRYPT:
        return 105;
      case SignerType.NIP44_DECRYPT:
        return 106;
      case SignerType.DECRYPT_ZAP_EVENT:
        return 107;
    }
  }
}
