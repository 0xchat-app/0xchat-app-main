import 'dart:convert';
import 'package:nostr_core_dart/src/channel/core_method_channel.dart';
import 'package:nostr_core_dart/src/signer/signer_permission_model.dart';
import 'package:nostr_core_dart/src/signer/signer_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Title: external_signer_tool
///Description: External signer tool with support for both Intent and Content Provider communication
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/11/29 11:21
class ExternalSignerTool {
  // In-memory cache of rejected kinds (cleared on app restart)
  // Key: kind (int), Value: true if rejected
  static final Map<int, bool> _rejectedKinds = {};
  
  /// Initialize signer configuration
  static Future<void> initialize() async {
    SignerConfigManager.instance.initialize();
    // Try to restore signer config from storage
    final config = await _getSignerConfigFromStorage();
    if (config != null) {
      SignerConfigManager.instance.setSigner(config.packageName == 'com.aegis.app' ? 'nostr_aegis' : 
                                            config.packageName == 'com.greenart7c3.nostrsigner' ? 'amber' : 
                                            config.packageName == 'com.github.haorendashu.nowser' ? 'nowser' : '');
    }
  }

  /// Set current signer by signer key (e.g. 'amber', 'nostr_aegis', 'nowser')
  static Future<void> setSigner(String signerKey) async {
    SignerConfigManager.instance.setSigner(signerKey);
    await _saveSignerConfigToStorage(signerKey);
  }

  /// Set current signer by package name (NIP-55 compliant)
  /// This method is used when user selects a signer from the installed signers list
  static Future<void> setSignerByPackageName(String packageName) async {
    // First try to find a known signer key for this package name
    String? signerKey = SignerConfigs.getSignerKeyByPackageName(packageName);
    
    if (signerKey != null) {
      // Known signer, use existing configuration
      await setSigner(signerKey);
    } else {
      // Unknown signer, create a dynamic configuration
      final dynamicConfig = SignerConfig(
        packageName: packageName,
        displayName: packageName.split('.').last,
        iconName: 'icon_login_amber.png',
        callMethod: SignerCallMethod.auto,
        contentProviderUris: {
          'get_public_key': 'content://$packageName.GET_PUBLIC_KEY',
          'sign_event': 'content://$packageName.SIGN_EVENT',
          'sign_message': 'content://$packageName.SIGN_MESSAGE',
          'nip04_encrypt': 'content://$packageName.NIP04_ENCRYPT',
          'nip04_decrypt': 'content://$packageName.NIP04_DECRYPT',
          'nip44_encrypt': 'content://$packageName.NIP44_ENCRYPT',
          'nip44_decrypt': 'content://$packageName.NIP44_DECRYPT',
          'decrypt_zap_event': 'content://$packageName.DECRYPT_ZAP_EVENT',
        },
      );
      // Register the dynamic config and set it as current
      SignerConfigs.addCustomConfig(packageName, dynamicConfig);
      await setSigner(packageName);
    }
  }

  /// Get signer config from SharedPreferences
  static Future<SignerConfig?> _getSignerConfigFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final signerKey = prefs.getString('current_signer');
      if (signerKey != null && signerKey.isNotEmpty) {
        final config = SignerConfigs.getConfig(signerKey);
        return config;
      }
    } catch (e) {
      // Silent fail
    }
    return null;
  }

  /// Save signer config to SharedPreferences
  static Future<void> _saveSignerConfigToStorage(String signerKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_signer', signerKey);
    } catch (e) {
      // Silent fail
    }
  }

  /// Get current signer configuration
  static SignerConfig? getCurrentConfig() {
    return SignerConfigManager.instance.currentConfig;
  }

  /// Get signer config with fallback to amber if null
  /// If config is null, automatically fallback to amber with auto mode
  static Future<SignerConfig?> _getConfigWithAmberFallback() async {
    // Try to get config from SharedPreferences first
    SignerConfig? config = await _getSignerConfigFromStorage();
    if (config == null) {
      config = getCurrentConfig();
    }
    
    // If still null, fallback to amber with auto mode
    if (config == null) {
      config = SignerConfigs.getConfig('amber');
      if (config != null) {
        // Set the signer to amber so it persists
        await setSigner('amber');
      }
    }
    
    return config;
  }



  ///get_public_key
  static Future<String?> getPubKey() async {
    final config = await _getConfigWithAmberFallback();
    
    if (config == null) {
      // Fallback to default behavior (should not happen as amber fallback is set)
      return _getPubKeyWithIntent();
    }

    switch (config.callMethod) {
      case SignerCallMethod.intent:
        return _getPubKeyWithIntent();
      case SignerCallMethod.contentProvider:
        return _getPubKeyWithContentProvider(config);
      case SignerCallMethod.auto:
        // Try Content Provider first, fallback to Intent
        final result = await _getPubKeyWithContentProvider(config);
        if (result != null) {
          return result;
        } else {
          // Content Provider failed, use Intent method directly
          return await _getPubKeyWithIntent(forceIntent: true);
        }
    }
  }

  /// Get public key using Intent method
  /// [forceIntent] if true, force using Intent method without trying Content Provider first
  static Future<String?> _getPubKeyWithIntent({bool forceIntent = false}) async {
    final config = await _getConfigWithAmberFallback();
    final useContentProvider = !forceIntent && config?.callMethod == SignerCallMethod.auto;
    final callMethod = forceIntent ? 'intent' : (config?.callMethod.name ?? 'intent');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.GET_PUBLIC_KEY.name,
        'requestCode': SignerType.GET_PUBLIC_KEY.requestCode,
        'permissions': SignerPermissionModel.defaultPermissions(),
        'packageName': config?.packageName, // Pass the correct package name
        'useContentProvider': useContentProvider, // Use Content Provider first for auto mode (unless forced to use Intent)
        'callMethod': callMethod, // Pass the call method, force intent if needed
      },
    );
    
    if (result == null) {
      return null;
    }
    
    try {
      final Map<String, dynamic> resultMap = Map<String, dynamic>.from(result as Map);
      return resultMap['result']?.toString() ?? resultMap['signature']?.toString();
    } catch (e) {
      return null;
    }
  }

  /// Get public key using Content Provider method
  static Future<String?> _getPubKeyWithContentProvider(SignerConfig config) async {
    final uri = config.getContentProviderUri('get_public_key');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner_content_provider',
      {
        'type': SignerType.GET_PUBLIC_KEY.name,
        'packageName': config.packageName,
        'contentProviderUri': uri,
        'data': ['login'], // Content Provider parameters
      },
    );
    
    if (result == null) {
      return null;
    }
    
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap['result'];
  }

  ///sign_event
  ///@return signature、id、event
  static Future<Map<String, String>?> signEvent(String eventJson, String id, String current_user) async {
    // Extract kind from eventJson and check if it's been rejected
    final kind = _extractKindFromEventJson(eventJson);
    if (kind != null && _rejectedKinds[kind] == true) {
      // This kind has been rejected before, skip the request
      return null;
    }
    
    final config = await _getConfigWithAmberFallback();
    if (config == null) {
      // Fallback to default behavior (should not happen as amber fallback is set)
      return _signEventWithIntent(eventJson, id, current_user);
    }

    Map<String, String>? result;
    switch (config.callMethod) {
      case SignerCallMethod.intent:
        result = await _signEventWithIntent(eventJson, id, current_user, kind: kind);
        break;
      case SignerCallMethod.contentProvider:
        result = await _signEventWithContentProvider(config, eventJson, id, current_user, kind: kind);
        break;
      case SignerCallMethod.auto:
        // Try Content Provider first, fallback to Intent
        result = await _signEventWithContentProvider(config, eventJson, id, current_user, kind: kind);
        if (result != null && result['rejected'] == 'true') {
          // Content Provider returned rejected, user chose to always reject
          // No need to try Intent method, it will also be rejected
          // The kind has already been recorded in _signEventWithContentProvider
          return null;
        }
        // Content Provider failed (not rejected), try Intent method as fallback
        result ??= await _signEventWithIntent(eventJson, id, current_user, forceIntent: true, kind: kind);
        break;
    }
    
    // Check if the result indicates rejection and record it
    if (result != null && result['rejected'] == 'true' && kind != null) {
      _rejectedKinds[kind] = true;
      return null; // Return null to indicate rejection
    }
    
    return result;
  }
  
  /// Extract kind from eventJson
  static int? _extractKindFromEventJson(String eventJson) {
    try {
      final json = jsonDecode(eventJson) as Map<String, dynamic>;
      return json['kind'] as int?;
    } catch (e) {
      return null;
    }
  }

  /// Sign event using Intent method
  /// [forceIntent] if true, force using Intent method without trying Content Provider first
  /// [kind] the event kind, used for rejection tracking
  static Future<Map<String, String>?> _signEventWithIntent(String eventJson, String id, String current_user, {bool forceIntent = false, int? kind}) async {
    final config = await _getConfigWithAmberFallback();
    final useContentProvider = !forceIntent && config?.callMethod == SignerCallMethod.auto;
    final callMethod = forceIntent ? 'intent' : (config?.callMethod.name ?? 'intent');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.SIGN_EVENT.name,
        'id': id,
        'pubKey': "",
        'current_user': current_user,
        'requestCode': SignerType.SIGN_EVENT.requestCode,
        'extendParse': eventJson,
        'packageName': config?.packageName, // Pass the correct package name
        'useContentProvider': useContentProvider, // Use Content Provider first for auto mode (unless forced to use Intent)
        'callMethod': callMethod, // Pass the call method, force intent if needed
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value?.toString() ?? '');
    });
    
    // Check if rejected and record the kind
    if (resultMap['rejected'] == 'true') {
      final kindStr = resultMap['rejected_kind'];
      if (kindStr != null) {
        final rejectedKind = int.tryParse(kindStr);
        if (rejectedKind != null) {
          _rejectedKinds[rejectedKind] = true;
        }
      } else if (kind != null) {
        // Fallback: use the kind passed as parameter
        _rejectedKinds[kind] = true;
      } else {
        // Last resort: extract kind from eventJson
        final extractedKind = _extractKindFromEventJson(eventJson);
        if (extractedKind != null) {
          _rejectedKinds[extractedKind] = true;
        }
      }
    }
    
    return resultMap;
  }

  /// Sign event using Content Provider method
  /// [kind] the event kind, used for rejection tracking
  static Future<Map<String, String>?> _signEventWithContentProvider(
    SignerConfig config, String eventJson, String id, String current_user, {int? kind}) async {
    final uri = config.getContentProviderUri('sign_event');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner_content_provider',
      {
        'type': SignerType.SIGN_EVENT.name,
        'packageName': config.packageName,
        'contentProviderUri': uri,
        'data': [eventJson, '', current_user], // Content Provider parameters
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value?.toString() ?? '');
    });
    
    // Check if rejected and record the kind
    if (resultMap['rejected'] == 'true') {
      final kindStr = resultMap['rejected_kind'];
      if (kindStr != null) {
        final rejectedKind = int.tryParse(kindStr);
        if (rejectedKind != null) {
          _rejectedKinds[rejectedKind] = true;
        }
      } else if (kind != null) {
        // Fallback: use the kind passed as parameter
        _rejectedKinds[kind] = true;
      } else {
        // Last resort: extract kind from eventJson
        final extractedKind = _extractKindFromEventJson(eventJson);
        if (extractedKind != null) {
          _rejectedKinds[extractedKind] = true;
        }
      }
    }
    
    return resultMap;
  }

  ///sign_message
  static Future<Map<String, String>?> signMessage(String eventJson, String id, String current_user) async {
    final config = await _getConfigWithAmberFallback();
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.SIGN_MESSAGE.name,
        'id': id,
        'pubKey': "",
        'current_user': current_user,
        'requestCode': SignerType.SIGN_MESSAGE.requestCode,
        'extendParse': eventJson,
        'packageName': config?.packageName, // Pass the correct package name
        'useContentProvider': config?.callMethod == SignerCallMethod.auto, // Use Content Provider first for auto mode
        'callMethod': config?.callMethod.name ?? 'intent', // Pass the call method
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
    final config = await _getConfigWithAmberFallback();
    
    if (config == null) {
      // Fallback to default behavior (should not happen as amber fallback is set)
      return _nip04EncryptWithIntent(plaintext, id, current_user, pubKey);
    }

    switch (config.callMethod) {
      case SignerCallMethod.intent:
        return _nip04EncryptWithIntent(plaintext, id, current_user, pubKey);
      case SignerCallMethod.contentProvider:
        return _nip04EncryptWithContentProvider(config, plaintext, id, current_user, pubKey);
      case SignerCallMethod.auto:
        // Try Content Provider first, fallback to Intent
        final result = await _nip04EncryptWithContentProvider(config, plaintext, id, current_user, pubKey);
        if (result != null) {
          return result;
        } else {
          // Content Provider failed, use Intent method directly
          return await _nip04EncryptWithIntent(plaintext, id, current_user, pubKey, forceIntent: true);
        }
    }
  }

  /// NIP04 encrypt using Content Provider method
  static Future<Map<String, String>?> _nip04EncryptWithContentProvider(
    SignerConfig config, String plaintext, String id, String current_user, String pubKey) async {
    final uri = config.getContentProviderUri('nip04_encrypt');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner_content_provider',
      {
        'type': SignerType.NIP04_ENCRYPT.name,
        'packageName': config.packageName,
        'contentProviderUri': uri,
        'data': [plaintext, pubKey, current_user], // Content Provider parameters: plainText, hex_pub_key, logged_in_user_pubkey
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap;
  }

  /// NIP04 encrypt using Intent method
  /// [forceIntent] if true, force using Intent method without trying Content Provider first
  static Future<Map<String, String>?> _nip04EncryptWithIntent(String plaintext, String id, String current_user, String pubKey, {bool forceIntent = false}) async {
    final config = await _getConfigWithAmberFallback();
    final useContentProvider = !forceIntent && config?.callMethod == SignerCallMethod.auto;
    final callMethod = forceIntent ? 'intent' : (config?.callMethod.name ?? 'intent');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.NIP04_ENCRYPT.name,
        'id': id,
        'current_user': current_user,
        'pubKey': pubKey,
        'requestCode': SignerType.NIP04_ENCRYPT.requestCode,
        'extendParse': plaintext,
        'packageName': config?.packageName, // Pass the correct package name
        'useContentProvider': useContentProvider, // Use Content Provider first for auto mode (unless forced to use Intent)
        'callMethod': callMethod, // Pass the call method, force intent if needed
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
    final config = await _getConfigWithAmberFallback();
    
    if (config == null) {
      // Fallback to default behavior (should not happen as amber fallback is set)
      return _nip44EncryptWithIntent(plaintext, id, current_user, pubKey);
    }

    switch (config.callMethod) {
      case SignerCallMethod.intent:
        return _nip44EncryptWithIntent(plaintext, id, current_user, pubKey);
      case SignerCallMethod.contentProvider:
        return _nip44EncryptWithContentProvider(config, plaintext, id, current_user, pubKey);
      case SignerCallMethod.auto:
        // Try Content Provider first, fallback to Intent
        final result = await _nip44EncryptWithContentProvider(config, plaintext, id, current_user, pubKey);
        if (result != null) {
          return result;
        } else {
          // Content Provider failed, use Intent method directly
          return await _nip44EncryptWithIntent(plaintext, id, current_user, pubKey, forceIntent: true);
        }
    }
  }

  /// NIP44 encrypt using Content Provider method
  static Future<Map<String, String>?> _nip44EncryptWithContentProvider(
    SignerConfig config, String plaintext, String id, String current_user, String pubKey) async {
    final uri = config.getContentProviderUri('nip44_encrypt');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner_content_provider',
      {
        'type': SignerType.NIP44_ENCRYPT.name,
        'packageName': config.packageName,
        'contentProviderUri': uri,
        'data': [plaintext, pubKey, current_user], // Content Provider parameters: plainText, hex_pub_key, logged_in_user_pubkey
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap;
  }

  /// NIP44 encrypt using Intent method
  /// [forceIntent] if true, force using Intent method without trying Content Provider first
  static Future<Map<String, String>?> _nip44EncryptWithIntent(String plaintext, String id, String current_user, String pubKey, {bool forceIntent = false}) async {
    final config = await _getConfigWithAmberFallback();
    final useContentProvider = !forceIntent && config?.callMethod == SignerCallMethod.auto;
    final callMethod = forceIntent ? 'intent' : (config?.callMethod.name ?? 'intent');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.NIP44_ENCRYPT.name,
        'id': id,
        'current_user': current_user,
        'pubKey': pubKey,
        'requestCode': SignerType.NIP44_ENCRYPT.requestCode,
        'extendParse': plaintext,
        'packageName': config?.packageName, // Pass the correct package name
        'useContentProvider': useContentProvider, // Use Content Provider first for auto mode (unless forced to use Intent)
        'callMethod': callMethod, // Pass the call method, force intent if needed
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
    final config = await _getConfigWithAmberFallback();
    
    if (config == null) {
      // Fallback to default behavior (should not happen as amber fallback is set)
      return _nip04DecryptWithIntent(encryptedText, id, current_user, pubKey);
    }

    switch (config.callMethod) {
      case SignerCallMethod.intent:
        return _nip04DecryptWithIntent(encryptedText, id, current_user, pubKey);
      case SignerCallMethod.contentProvider:
        return _nip04DecryptWithContentProvider(config, encryptedText, id, current_user, pubKey);
      case SignerCallMethod.auto:
        // Try Content Provider first, fallback to Intent
        final result = await _nip04DecryptWithContentProvider(config, encryptedText, id, current_user, pubKey);
        if (result != null) {
          return result;
        } else {
          // Content Provider failed, use Intent method directly
          return await _nip04DecryptWithIntent(encryptedText, id, current_user, pubKey, forceIntent: true);
        }
    }
  }

  /// NIP04 decrypt using Content Provider method
  static Future<Map<String, String>?> _nip04DecryptWithContentProvider(
    SignerConfig config, String encryptedText, String id, String current_user, String pubKey) async {
    final uri = config.getContentProviderUri('nip04_decrypt');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner_content_provider',
      {
        'type': SignerType.NIP04_DECRYPT.name,
        'packageName': config.packageName,
        'contentProviderUri': uri,
        'data': [encryptedText, pubKey, current_user], // Content Provider parameters: encryptedText, hex_pub_key, logged_in_user_pubkey
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap;
  }

  /// NIP04 decrypt using Intent method
  /// [forceIntent] if true, force using Intent method without trying Content Provider first
  static Future<Map<String, String>?> _nip04DecryptWithIntent(String encryptedText, String id, String current_user, String pubKey, {bool forceIntent = false}) async {
    final config = await _getConfigWithAmberFallback();
    final useContentProvider = !forceIntent && config?.callMethod == SignerCallMethod.auto;
    final callMethod = forceIntent ? 'intent' : (config?.callMethod.name ?? 'intent');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.NIP04_DECRYPT.name,
        'id': id,
        'current_user': current_user,
        'pubKey': pubKey,
        'requestCode': SignerType.NIP04_DECRYPT.requestCode,
        'extendParse': encryptedText,
        'packageName': config?.packageName, // Pass the correct package name
        'useContentProvider': useContentProvider, // Use Content Provider first for auto mode (unless forced to use Intent)
        'callMethod': callMethod, // Pass the call method, force intent if needed
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
    final config = await _getConfigWithAmberFallback();
    
    if (config == null) {
      // Fallback to default behavior (should not happen as amber fallback is set)
      return _nip44DecryptWithIntent(encryptedText, id, current_user, pubKey);
    }

    switch (config.callMethod) {
      case SignerCallMethod.intent:
        return _nip44DecryptWithIntent(encryptedText, id, current_user, pubKey);
      case SignerCallMethod.contentProvider:
        return _nip44DecryptWithContentProvider(config, encryptedText, id, current_user, pubKey);
      case SignerCallMethod.auto:
        // Try Content Provider first, fallback to Intent
        final result = await _nip44DecryptWithContentProvider(config, encryptedText, id, current_user, pubKey);
        if (result != null) {
          return result;
        } else {
          // Content Provider failed, use Intent method directly
          return await _nip44DecryptWithIntent(encryptedText, id, current_user, pubKey, forceIntent: true);
        }
    }
  }

  /// NIP44 decrypt using Content Provider method
  static Future<Map<String, String>?> _nip44DecryptWithContentProvider(
    SignerConfig config, String encryptedText, String id, String current_user, String pubKey) async {
    final uri = config.getContentProviderUri('nip44_decrypt');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner_content_provider',
      {
        'type': SignerType.NIP44_DECRYPT.name,
        'packageName': config.packageName,
        'contentProviderUri': uri,
        'data': [encryptedText, pubKey, current_user], // Content Provider parameters: encryptedText, hex_pub_key, logged_in_user_pubkey
      },
    );
    if (result == null) return null;
    final Map<String, String> resultMap = (result as Map).map((key, value) {
      return MapEntry(key as String, value as String);
    });
    return resultMap;
  }

  /// NIP44 decrypt using Intent method
  /// [forceIntent] if true, force using Intent method without trying Content Provider first
  static Future<Map<String, String>?> _nip44DecryptWithIntent(String encryptedText, String id, String current_user, String pubKey, {bool forceIntent = false}) async {
    final config = await _getConfigWithAmberFallback();
    final useContentProvider = !forceIntent && config?.callMethod == SignerCallMethod.auto;
    final callMethod = forceIntent ? 'intent' : (config?.callMethod.name ?? 'intent');
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.NIP44_DECRYPT.name,
        'id': id,
        'current_user': current_user,
        'pubKey': pubKey,
        'requestCode': SignerType.NIP44_DECRYPT.requestCode,
        'extendParse': encryptedText,
        'packageName': config?.packageName, // Pass the correct package name
        'useContentProvider': useContentProvider, // Use Content Provider first for auto mode (unless forced to use Intent)
        'callMethod': callMethod, // Pass the call method, force intent if needed
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
    final config = await _getConfigWithAmberFallback();
    final Object? result = await CoreMethodChannel.channelChatCore.invokeMethod(
      'nostrsigner',
      {
        'type': SignerType.DECRYPT_ZAP_EVENT.name,
        'id': id,
        'current_user': current_user,
        'requestCode': SignerType.DECRYPT_ZAP_EVENT.requestCode,
        'extendParse': encryptedText,
        'packageName': config?.packageName, // Pass the correct package name
        'useContentProvider': config?.callMethod == SignerCallMethod.auto, // Use Content Provider first for auto mode
        'callMethod': config?.callMethod.name ?? 'intent', // Pass the call method
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
  SIGN_MESSAGE,
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
      case SignerType.SIGN_MESSAGE:
        return 'sign_message';
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
      case SignerType.SIGN_MESSAGE:
        return 108;
    }
  }
}
