import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:pointycastle/export.dart';
import 'package:kepler/kepler.dart';
import 'package:bip340/bip340.dart' as bip340;
import 'package:nostr_core_dart/nostr.dart';

/// generates 32 random bytes converted in hex
String generate64RandomHexChars() {
  final random = Random.secure();
  final randomBytes = List<int>.generate(32, (i) => random.nextInt(256));
  return hex.encode(randomBytes);
}

/// current unix timestamp in seconds
int currentUnixTimestampSeconds() {
  return DateTime.now().millisecondsSinceEpoch ~/ 1000;
}

String bytesToHex(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

Uint8List hexToBytes(String hex) {
  List<int> bytes = [];
  for (int i = 0; i < hex.length; i += 2) {
    bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return Uint8List.fromList(bytes);
}

// Encrypt data using self private key in nostr format ( with trailing ?iv=)
String encrypt(String privateString, String publicString, String plainText) {
  Uint8List uintInputText = Utf8Encoder().convert(plainText);
  final encryptedString =
      encryptRaw(privateString, publicString, uintInputText);
  return encryptedString;
}

String encryptRaw(
    String privateString, String publicString, Uint8List uintInputText) {
  final secretIV = Kepler.byteSecret(privateString, publicString);
  final key = Uint8List.fromList(secretIV[0]);

  // generate iv  https://stackoverflow.com/questions/63630661/aes-engine-not-initialised-with-pointycastle-securerandom
  FortunaRandom fr = FortunaRandom();
  final sGen = Random.secure();
  fr.seed(KeyParameter(
      Uint8List.fromList(List.generate(32, (_) => sGen.nextInt(255)))));
  final iv = fr.nextBytes(16);

  CipherParameters params = PaddedBlockCipherParameters(
      ParametersWithIV(KeyParameter(key), iv), null);

  PaddedBlockCipherImpl cipherImpl =
      PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESEngine()));

  cipherImpl.init(
      true, // means to encrypt
      params
          as PaddedBlockCipherParameters<CipherParameters?, CipherParameters?>);

  // allocate space
  final Uint8List outputEncodedText = Uint8List(uintInputText.length + 16);

  var offset = 0;
  while (offset < uintInputText.length - 16) {
    offset += cipherImpl.processBlock(
        uintInputText, offset, outputEncodedText, offset);
  }

  //add padding
  offset +=
      cipherImpl.doFinal(uintInputText, offset, outputEncodedText, offset);
  final Uint8List finalEncodedText = outputEncodedText.sublist(0, offset);

  String stringIv = base64.encode(iv);
  String outputPlainText = base64.encode(finalEncodedText);
  outputPlainText = "$outputPlainText?iv=$stringIv";
  return outputPlainText;
}

// pointy castle source https://github.com/PointyCastle/pointycastle/blob/master/tutorials/aes-cbc.md
// https://github.com/bcgit/pc-dart/blob/master/tutorials/aes-cbc.md
// 3 https://github.com/Dhuliang/flutter-bsv/blob/42a2d92ec6bb9ee3231878ffe684e1b7940c7d49/lib/src/aescbc.dart

/// Decrypt data using self private key
String decrypt(String privateString, String publicString, String b64encoded,
    [String b64IV = ""]) {
  Uint8List deData = base64.decode(b64encoded);
  final rawData = decryptRaw(privateString, publicString, deData, b64IV);
  return Utf8Decoder().convert(rawData.toList());
}

Uint8List decryptRaw(
    String privateString, String publicString, Uint8List cipherText,
    [String b64IV = ""]) {
  List<List<int>> byteSecret = Kepler.byteSecret(privateString, publicString);
  final secretIV = byteSecret;
  final key = Uint8List.fromList(secretIV[0]);
  final iv =
      b64IV.length > 6 ? base64.decode(b64IV) : Uint8List.fromList(secretIV[1]);

  CipherParameters params = PaddedBlockCipherParameters(
      ParametersWithIV(KeyParameter(key), iv), null);

  PaddedBlockCipherImpl cipherImpl =
      PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESEngine()));

  cipherImpl.init(
      false,
      params
          as PaddedBlockCipherParameters<CipherParameters?, CipherParameters?>);
  final Uint8List finalPlainText =
      Uint8List(cipherText.length); // allocate space

  var offset = 0;
  while (offset < cipherText.length - 16) {
    offset +=
        cipherImpl.processBlock(cipherText, offset, finalPlainText, offset);
  }
  //remove padding
  offset += cipherImpl.doFinal(cipherText, offset, finalPlainText, offset);
  return finalPlainText.sublist(0, offset);
}

/// tweakAdd
BigInt decodeBigInt(Uint8List bytes) {
  BigInt result = BigInt.from(0);
  for (int i = 0; i < bytes.length; i++) {
    result += BigInt.from(bytes[i]) << (8 * (bytes.length - i - 1));
  }
  return result;
}

Uint8List encodeBigInt(BigInt number) {
  int size = (number.bitLength + 7) ~/ 8;
  Uint8List result = Uint8List(size);
  for (int i = 0; i < size; i++) {
    result[size - i - 1] =
        ((number >> (8 * i)) & BigInt.from(0xff)).toInt() & 0xff;
  }
  return result;
}

Uint8List tweakAdd(Uint8List privateKey, Uint8List tweak, {int? salt}) {
  // Load the secp256k1 curve parameters
  ECDomainParameters params = ECCurve_secp256k1();
  BigInt n = params.n;

  // Convert the private key and tweak to BigInt
  BigInt privateKeyBigInt = decodeBigInt(privateKey);
  BigInt tweakBigInt = decodeBigInt(tweak);
  if (salt != null) {
    tweakBigInt += BigInt.from(salt);
  }

  // Add the private key and tweak (mod n)
  BigInt derivedPrivateKeyBigInt = (privateKeyBigInt + tweakBigInt) % n;

  // Convert the derived private key back to Uint8List
  Uint8List derivedPrivateKey = encodeBigInt(derivedPrivateKeyBigInt);

  return derivedPrivateKey;
}

/// encrypt & decrypt PrivateKey
Uint8List generateKeyFromPassword(String password, int length) {
  Uint8List salt = Uint8List.fromList(utf8.encode("0xchat.com"));
  final scrypt = Scrypt()..init(ScryptParameters(16384, 8, 1, 32, salt));

  return scrypt.process(Uint8List.fromList(utf8.encode(password)));
}

Uint8List encryptPrivateKey(Uint8List privateKey, String password) {
  // Generate a key based on the password
  final Uint8List key = generateKeyFromPassword(password, 32);

  // Create the AES cipher in ECB mode
  final BlockCipher cipher = AESEngine();

  // Initialize the cipher with the key
  cipher.init(true, KeyParameter(key));

  // Encrypt the private key
  Uint8List encryptedPrivateKey = Uint8List(privateKey.length);
  for (int offset = 0; offset < privateKey.length; offset += cipher.blockSize) {
    cipher.processBlock(privateKey, offset, encryptedPrivateKey, offset);
  }

  return encryptedPrivateKey;
}

Uint8List decryptPrivateKey(Uint8List encryptedPrivateKey, String password) {
  // Generate a key based on the password
  final Uint8List key = generateKeyFromPassword(password, 32);

  // Create the AES cipher in ECB mode
  final BlockCipher cipher = AESEngine();

  // Initialize the cipher with the key
  cipher.init(false, KeyParameter(key));

  // Decrypt the private key
  Uint8List privateKey = Uint8List(encryptedPrivateKey.length);
  for (int offset = 0;
      offset < encryptedPrivateKey.length;
      offset += cipher.blockSize) {
    cipher.processBlock(encryptedPrivateKey, offset, privateKey, offset);
  }

  return privateKey;
}

String generateStrongPassword(int length) {
  final random = Random.secure();
  const lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
  const upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numbers = '0123456789';
  const specialCharacters = r'!@#$%^&*()_+-=[]{}|;:,.<>?';

  final characters =
      '$lowerCaseLetters$upperCaseLetters$numbers$specialCharacters';

  // generateStrongPassword
  return List.generate(
      length, (index) => characters[random.nextInt(characters.length)]).join();
}

Future<String> signData(List data, String pubkey, String private) async {
  String serializedData = json.encode(data);
  if (SignerHelper.needSigner(private)) {
    return await SignerHelper.signMessage(serializedData, pubkey, private) ?? '';
  }
  Uint8List hash =
      SHA256Digest().process(Uint8List.fromList(utf8.encode(serializedData)));
  String aux = generate64RandomHexChars();
  return  bip340.sign(private, hex.encode(hash), aux);
}
