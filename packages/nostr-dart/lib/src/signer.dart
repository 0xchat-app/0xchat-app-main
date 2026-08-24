import 'dart:convert';
import 'package:nostr_core_dart/nostr.dart';

enum SignerApplication { androidSigner, remoteSigner, none }

typedef SignEventHandle = Future<Event> Function(String eventString);
typedef Nip04EncryptEventHandle = Future<String?> Function(String plainText, String peerPubkey);
typedef Nip04DecryptEventHandle = Future<String?> Function(String encryptedText, String peerPubkey);
typedef Nip44EncryptEventHandle = Future<String?> Function(String plainText, String peerPubkey);
typedef Nip44DecryptEventHandle = Future<String?> Function(String encryptedText, String peerPubkey);

class SignerHelper {
  /// singleton
  SignerHelper._internal();
  factory SignerHelper() => sharedInstance;
  static final SignerHelper sharedInstance = SignerHelper._internal();

  SignEventHandle? signEventHandle;
  Nip04EncryptEventHandle? nip04encryptEventHandle;
  Nip04DecryptEventHandle? nip04decryptEventHandle;
  Nip44EncryptEventHandle? nip44encryptEventHandle;
  Nip44DecryptEventHandle? nip44decryptEventHandle;

  static SignerApplication getSignerApplication(String privkey) {
    switch (privkey) {
      case '':
      case 'androidSigner':
        return SignerApplication.androidSigner;
      case 'remoteSigner':
        return SignerApplication.remoteSigner;
      default:
        return SignerApplication.none;
    }
  }

  static String getSignerApplicationKey(SignerApplication signerApplication, String privkey) {
    switch (signerApplication) {
      case SignerApplication.androidSigner:
        return 'androidSigner';
      case SignerApplication.remoteSigner:
        return 'remoteSigner';
      default:
        return privkey;
    }
  }

  static bool needSigner(String privkey) {
    return getSignerApplication(privkey) != SignerApplication.none;
  }

  static Future<String?> signMessage(String hexMessage, String currentUser, String privkey) async {
    SignerApplication signerApplication = getSignerApplication(privkey);
    switch (signerApplication) {
      case SignerApplication.androidSigner:
        // NIP 55: current_user should be hex pubkey, not npub
        Map<String, String>? map = await ExternalSignerTool.signMessage(
            hexMessage, hexMessage, currentUser);
        String? sign = map?['result'] ?? map?['signature'];
        return sign;
      case SignerApplication.remoteSigner:
      default:
        return null;
    }
  }

  static Future<Event?> signEvent(Event event, String currentUser, String privkey) async {
    SignerApplication signerApplication = getSignerApplication(privkey);
    final eventString = jsonEncode(event.toJson());
    switch (signerApplication) {
      case SignerApplication.androidSigner:
        // NIP 55: current_user should be hex pubkey, not npub
        Map<String, String>? map = await ExternalSignerTool.signEvent(
            eventString, event.id, currentUser);
        String? eventJson = map?['event'];
        if (eventJson != null) {
          event = await Event.fromJson(jsonDecode(eventJson));
        }
        return event;
      case SignerApplication.remoteSigner:
        return SignerHelper.sharedInstance.signEventHandle?.call(eventString);
      default:
        return null;
    }
  }

  static Future<String?> encryptNip04(
      String plainText, String peerPubkey, String myPubkey, String privkey) async {
    SignerApplication signerApplication = getSignerApplication(privkey);
    switch (signerApplication) {
      case SignerApplication.androidSigner:
        // NIP 55: current_user and pubkey should be hex pubkey, not npub
        Map<String, String>? map = await ExternalSignerTool.nip04Encrypt(
            plainText, generate64RandomHexChars(), myPubkey, peerPubkey);
        String? encryptedText = map?['result'] ?? map?['signature'];
        if (encryptedText != null) {
          plainText = encryptedText;
        }
        return plainText;
      case SignerApplication.remoteSigner:
        return SignerHelper.sharedInstance.nip04encryptEventHandle?.call(plainText, peerPubkey);
      default:
        return null;
    }
  }

  static Future<String?> decryptNip04(
      String encryptedText, String peerPubkey, String myPubkey, String privkey) async {
    SignerApplication signerApplication = getSignerApplication(privkey);
    switch (signerApplication) {
      case SignerApplication.androidSigner:
        // NIP 55: current_user and pubkey should be hex pubkey, not npub
        Map<String, String>? map = await ExternalSignerTool.nip04Decrypt(
            encryptedText, generate64RandomHexChars(), myPubkey, peerPubkey);
        String? plainText = map?['result'] ?? map?['signature'];
        if (plainText != null) {
          encryptedText = plainText;
        }
        return encryptedText;
      case SignerApplication.remoteSigner:
        return SignerHelper.sharedInstance.nip04decryptEventHandle?.call(encryptedText, peerPubkey);
      default:
        return null;
    }
  }

  static Future<String?> encryptNip44(
      String plainText, String peerPubkey, String myPubkey, String privkey) async {
    SignerApplication signerApplication = getSignerApplication(privkey);
    switch (signerApplication) {
      case SignerApplication.androidSigner:
        // NIP 55: current_user and pubkey should be hex pubkey, not npub
        Map<String, String>? map = await ExternalSignerTool.nip44Encrypt(
            plainText, generate64RandomHexChars(), myPubkey, peerPubkey);
        String? encryptedText = map?['result'] ?? map?['signature'];
        if (encryptedText != null) {
          plainText = encryptedText;
        }
        return plainText;
      case SignerApplication.remoteSigner:
        return SignerHelper.sharedInstance.nip44encryptEventHandle?.call(plainText, peerPubkey);
      default:
        return null;
    }
  }

  static Future<String?> decryptNip44(
      String encryptedText, String peerPubkey, String myPubkey, String privkey) async {
    SignerApplication signerApplication = getSignerApplication(privkey);
    switch (signerApplication) {
      case SignerApplication.androidSigner:
        // NIP 55: current_user and pubkey should be hex pubkey, not npub
        Map<String, String>? map = await ExternalSignerTool.nip44Decrypt(
            encryptedText, generate64RandomHexChars(), myPubkey, peerPubkey);
        String? plainText = map?['result'] ?? map?['signature'];
        if (plainText != null) {
          encryptedText = plainText;
        }
        return encryptedText;
      case SignerApplication.remoteSigner:
        return SignerHelper.sharedInstance.nip44decryptEventHandle?.call(encryptedText, peerPubkey);
      default:
        return null;
    }
  }
}
