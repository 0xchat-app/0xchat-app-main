/// Signer configuration for different signer applications
class SignerConfig {
  final String packageName;
  final String displayName;
  final String iconName;
  final SignerCallMethod callMethod;
  final Map<String, String> contentProviderUris;

  const SignerConfig({
    required this.packageName,
    required this.displayName,
    required this.iconName,
    required this.callMethod,
    required this.contentProviderUris,
  });

  /// Get content provider URI for specific operation
  String getContentProviderUri(String operation) {
    return contentProviderUris[operation] ?? 
           "content://$packageName.${operation.toUpperCase()}";
  }
}

/// Available signer call methods
enum SignerCallMethod {
  intent,        // Use Intent-based communication
  contentProvider, // Use Content Provider communication
  auto,          // Try Content Provider first, fallback to Intent
}

/// Predefined signer configurations
class SignerConfigs {
  static const Map<String, SignerConfig> _configs = {
    'amber': SignerConfig(
      packageName: 'com.greenart7c3.nostrsigner',
      displayName: 'Amber',
      iconName: 'icon_login_amber.png',
      callMethod: SignerCallMethod.auto,
      contentProviderUris: {
        'get_public_key': 'content://com.greenart7c3.nostrsigner.GET_PUBLIC_KEY',
        'sign_event': 'content://com.greenart7c3.nostrsigner.SIGN_EVENT',
        'sign_message': 'content://com.greenart7c3.nostrsigner.SIGN_MESSAGE',
        'nip04_encrypt': 'content://com.greenart7c3.nostrsigner.NIP04_ENCRYPT',
        'nip04_decrypt': 'content://com.greenart7c3.nostrsigner.NIP04_DECRYPT',
        'nip44_encrypt': 'content://com.greenart7c3.nostrsigner.NIP44_ENCRYPT',
        'nip44_decrypt': 'content://com.greenart7c3.nostrsigner.NIP44_DECRYPT',
        'decrypt_zap_event': 'content://com.greenart7c3.nostrsigner.DECRYPT_ZAP_EVENT',
      },
    ),
    'nostr_aegis': SignerConfig(
      packageName: 'com.aegis.app',
      displayName: 'Aegis',
      iconName: 'aegis.png',
      callMethod: SignerCallMethod.auto,
      contentProviderUris: {
        'get_public_key': 'content://com.aegis.app.GET_PUBLIC_KEY',
        'sign_event': 'content://com.aegis.app.SIGN_EVENT',
        'sign_message': 'content://com.aegis.app.SIGN_MESSAGE',
        'nip04_encrypt': 'content://com.aegis.app.NIP04_ENCRYPT',
        'nip04_decrypt': 'content://com.aegis.app.NIP04_DECRYPT',
        'nip44_encrypt': 'content://com.aegis.app.NIP44_ENCRYPT',
        'nip44_decrypt': 'content://com.aegis.app.NIP44_DECRYPT',
        'decrypt_zap_event': 'content://com.aegis.app.DECRYPT_ZAP_EVENT',
      },
    ),
    'nowser': SignerConfig(
      packageName: 'com.github.haorendashu.nowser',
      displayName: 'Nowser',
      iconName: 'nowser.png',
      callMethod: SignerCallMethod.auto,
      contentProviderUris: {
        'get_public_key': 'content://com.github.haorendashu.nowser.GET_PUBLIC_KEY',
        'sign_event': 'content://com.github.haorendashu.nowser.SIGN_EVENT',
        'sign_message': 'content://com.github.haorendashu.nowser.SIGN_MESSAGE',
        'nip04_encrypt': 'content://com.github.haorendashu.nowser.NIP04_ENCRYPT',
        'nip04_decrypt': 'content://com.github.haorendashu.nowser.NIP04_DECRYPT',
        'nip44_encrypt': 'content://com.github.haorendashu.nowser.NIP44_ENCRYPT',
        'nip44_decrypt': 'content://com.github.haorendashu.nowser.NIP44_DECRYPT',
        'decrypt_zap_event': 'content://com.github.haorendashu.nowser.DECRYPT_ZAP_EVENT',
      },
    ),
  };

  /// Get signer configuration by key
  static SignerConfig? getConfig(String key) {
    return _configs[key];
  }

  /// Get all available signer configurations
  static Map<String, SignerConfig> getAllConfigs() {
    return Map.unmodifiable(_configs);
  }

  /// Get available signer keys
  static List<String> getAvailableSigners() {
    return _configs.keys.toList();
  }

  /// Add or update a custom signer configuration
  static void addCustomConfig(String key, SignerConfig config) {
    _configs[key] = config;
  }

  /// Get signer key by package name
  static String? getSignerKeyByPackageName(String packageName) {
    for (var entry in _configs.entries) {
      if (entry.value.packageName == packageName) {
        return entry.key;
      }
    }
    return null;
  }

  /// Get signer configuration by package name
  static SignerConfig? getConfigByPackageName(String packageName) {
    for (var config in _configs.values) {
      if (config.packageName == packageName) {
        return config;
      }
    }
    return null;
  }
}

/// Signer configuration manager
class SignerConfigManager {
  static SignerConfigManager? _instance;
  static SignerConfigManager get instance {
    _instance ??= SignerConfigManager._internal();
    return _instance!;
  }

  SignerConfigManager._internal();

  String _currentSigner = '';
  SignerConfig? _currentConfig;

  /// Get current signer key
  String get currentSigner => _currentSigner;

  /// Get current signer configuration
  SignerConfig? get currentConfig => _currentConfig;

  /// Set current signer
  void setSigner(String signerKey) {
    _currentSigner = signerKey;
    _currentConfig = SignerConfigs.getConfig(signerKey);
  }

  /// Initialize signer configuration
  void initialize() {
    // Don't set a default signer automatically
    // Let the caller explicitly set the signer based on user context
  }
}
