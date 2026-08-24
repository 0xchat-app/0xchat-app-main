
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../utils/crypto_utils.dart';
import '../utils/tools.dart';
import 'nuts/DHKE.dart';
import 'nuts/define.dart';
import 'nuts/nut_00.dart';

typedef SecretCreator = String Function(int amount);

class DHKEHelper {

  static BlindedMessageData _createBlindedMessages({
    required String keysetId,
    required List<int> amounts,
    SecretCreator? secretCreator,
  }) {

    List<BlindedMessage> blindedMessages = [];
    List<String> pSecrets = [];
    List<BigInt> rs = [];

    for (var i = 0; i < amounts.length; i++) {
      final amount = amounts[i];
      final secret = secretCreator?.call(amount) ?? CryptoUtils.randomPrivateKey().asBase64String();
      final (B_, r) = DHKE.blindMessage(secret);
      if (B_.isEmpty) continue;

      final blindedMessage = BlindedMessage(
        id: keysetId,
        amount: amount,
        B_: B_,
      );
      blindedMessages.add(blindedMessage);
      pSecrets.add(secret);
      rs.add(r);
    }

    return (
      blindedMessages,
      pSecrets,
      rs,
      amounts,
    );
  }

  static BlindedMessageData createBlindedMessages({
    required String keysetId,
    required int amount,
    SecretCreator? secretCreator,
  }) {
    List<int> amounts = splitAmount(amount);
    return _createBlindedMessages(
      keysetId: keysetId,
      amounts: amounts,
      secretCreator: secretCreator,
    );
  }

  static List<int> splitAmount(int value) {
    if (value == 0) return [];
    List<int> chunks = [];
    for (int i = 0; i < 32; i++) {
      int mask = 1 << i;
      if ((value & mask) != 0) {
        chunks.add(pow(2, i).toInt());
      }
    }
    return chunks;
  }

  static BlindedMessageData createBlankOutputs({
    required String keysetId,
    required int amount,
  }) {
    var count = 1;
    if (amount != 0) {
      count = max(1, (log(amount) / ln2).ceil());
    }
    final amounts = List.generate(count, (index) => 0);
    return _createBlindedMessages(
      keysetId: keysetId,
      amounts: amounts,
    );
  }

  static Uint8List get domainSeparator => 'Secp256k1_HashToCurve_Cashu_'.asBytes();

  static String hashToCurve(String message) {

    Uint8List messageBytes = message.asBytes();
    Uint8List msgToHash = Uint8List.fromList(
      sha256
          .convert([...domainSeparator, ...messageBytes])
          .bytes,
    );

    int counter = 0;
    while (counter < 1 << 16) {
      Uint8List hash = Uint8List.fromList(
        sha256.convert([...msgToHash, ...byteBufferFromInt(counter)]).bytes,
      );
      try {
        // will error if point does not lie on curve
        final point = '02${hash.asHex()}'.pointFromHex();
        return point.ecPointToHex();
      } catch (e) {
        counter++;
      }
    }
    throw Exception("No valid point found");
  }

  static Uint8List byteBufferFromInt(int value) {
    var buffer = Uint8List(4);
    ByteData.view(buffer.buffer).setUint32(0, value, Endian.little);
    return buffer;
  }
}