import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:nostr_core_dart/nostr.dart';

void main() async {
  // Uint8List sharekey = Nip44v2.shareSecret(
  //     'a1e37752c9fdc1273be53f68c5f74be7c8905728e8de75800b94262f9497c86e',
  //     '03bb7947065dde12ba991ea045132581d0954f042c84e06d8c00066e23c1a800');
  // print('sharekey: ${bytesToHex(sharekey)}');
  //
  // final messageKeys = Nip44v2.getMessageKeys(hexToBytes('a1a3d60f3470a8612633924e91febf96dc5366ce130f658b1f0fc652c20b3b54'), hexToBytes('e1e6f880560d6d149ed83dcc7e5861ee62a5ee051f7fde9975fe5d25d2a02d72'));
  // print('chacha_key: ${bytesToHex(messageKeys['chacha_key']!)}');
  // print('chacha_nonce: ${bytesToHex(messageKeys['chacha_nonce']!)}');
  // print('hmac_key: ${bytesToHex(messageKeys['hmac_key']!)}');

  String encryptstring = await Nip44v2.encrypt(
      '🙈 🙉 🙊 0️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟 Powerلُلُصّبُلُلصّبُررً ॣ ॣh ॣ ॣ冗',
      hexToBytes(
          '75fe686d21a035f0c7cd70da64ba307936e5ca0b20710496a6b6b5f573377bdd'),
      hexToBytes(
          "a3e219242d85465e70adcd640b564b3feff57d2ef8745d5e7a0663b2dccceb54"));
  print(encryptstring);

  String decryptstring = await Nip44v2.decrypt(encryptstring, hexToBytes(
      '75fe686d21a035f0c7cd70da64ba307936e5ca0b20710496a6b6b5f573377bdd'));
  print(decryptstring);

}
