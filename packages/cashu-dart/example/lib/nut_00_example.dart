
import 'dart:typed_data';

import 'package:cashu_dart/core/nuts/DHKE.dart';
import 'package:cashu_dart/core/nuts/nut_00.dart';
import 'package:cashu_dart/utils/tools.dart';

void main() {

  final token = Token.fromJson({
    "token": [
      {
        "mint": "https://8333.space:3338",
        "proofs": [
          {
            "id": "DSAl9nvvyfva",
            "amount": 2,
            "secret": "EhpennC9qB3iFlW8FZ_pZw",
            "C": "02c020067db727d586bc3183aecf97fcb800c3f4cc4759f69c626c9db5d8f5b5d4"
          },
          {
            "id": "DSAl9nvvyfva",
            "amount": 8,
            "secret": "TmS6Cv0YT5PU_5ATVKnukw",
            "C": "02ac910bef28cbe5d7325415d5c263026f15f9b967a079ca9779ab6e5c2db133a7"
          }
        ]
      }
    ],
    "memo": "Thank you."
  });

  final encodedToken = Nut0.encodedToken(token);

  final decodedToken = Nut0.decodedToken(encodedToken);

  print('encodedToken: $encodedToken');
  print('decodedToken: $decodedToken');
}

void hashToCurve() {
  // # Test 1 (hex encoded)
  // Message: 0000000000000000000000000000000000000000000000000000000000000000
  // Point:   0266687aadf862bd776c8fc18b8e9f8e20089714856ee233b3902a591d0d5f2925
  final secret = Uint8List.fromList(List.generate(32, (index) => 0));
  var point = DHKE.ecPointToHex(DHKE.hashToCurve(secret));
  print('point: $point');

  // # Test 2 (hex encoded)
  // Message: 0000000000000000000000000000000000000000000000000000000000000001
  // Point:   02ec4916dd28fc4c10d78e287ca5d9cc51ee1ae73cbfde08c6b37324cbfaac8bc5
  secret[secret.length - 1] = 1;
  point = DHKE.ecPointToHex(DHKE.hashToCurve(secret));
  print('point: $point');

  // # Test 3 (hex encoded)
  // # Note that this message will take a few iterations of the loop before finding a valid point
  // Message: 0000000000000000000000000000000000000000000000000000000000000002
  // Point:   02076c988b353fcbb748178ecb286bc9d0b4acf474d4ba31ba62334e46c97c416a
  secret[secret.length - 1] = 2;
  point = DHKE.ecPointToHex(DHKE.hashToCurve(secret));
  print('point: $point');
}

void blindedMessages() {
  // # Test 1
  // x: "test_message"
  // r: 0000000000000000000000000000000000000000000000000000000000000001 # hex encoded
  // B_: 02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2
  var secret = 'test_message'.asBytes();
  var r = BigInt.from(1);
  var (B_, _) = DHKE.blindMessage(secret, r);
  print('B_: $B_');

  // # Test 2
  // x: "hello"
  // r: 6d7e0abffc83267de28ed8ecc8760f17697e51252e13333ba69b4ddad1f95d05 # hex encoded
  // B_: 0249eb5dbb4fac2750991cf18083388c6ef76cde9537a6ac6f3e6679d35cdf4b0c
  secret = 'hello'.asBytes();
  r = BigInt.parse('6d7e0abffc83267de28ed8ecc8760f17697e51252e13333ba69b4ddad1f95d05', radix: 16);
  (B_, _) = DHKE.blindMessage(secret, r);
  print('B_: $B_');
}

void blindedKeys() {
  // # Test 1
  // mint private key: 0000000000000000000000000000000000000000000000000000000000000001
  // x: "test_message"
  // r: 0000000000000000000000000000000000000000000000000000000000000001 # hex encoded
  // B_: 02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2
  // C_: 02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2

}
