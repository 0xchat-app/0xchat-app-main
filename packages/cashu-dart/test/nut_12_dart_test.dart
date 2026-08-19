
import 'package:cashu_dart/cashu_dart.dart';
import 'package:cashu_dart/core/nuts/v1/nut_12.dart';
import 'package:cashu_dart/utils/crypto_utils.dart';
import 'package:cashu_dart/utils/tools.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('DLEQ.hashE - success', () {
    final R1 = '020000000000000000000000000000000000000000000000000000000000000001'.pointFromHex();
    final R2 = '020000000000000000000000000000000000000000000000000000000000000001'.pointFromHex();
    final K = '020000000000000000000000000000000000000000000000000000000000000001'.pointFromHex();
    final C_ = '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2'.pointFromHex();

    const hashE = 'a4dc034b74338c28c6bc3ea49731f2a24440fc7c4affc08b31a93fc9fbe6401e';

    expect(DLEQ.hashE([R1, R2, K, C_]).asHex(), hashE);
  });

  test('DLEQ.hashE - fail', () {
    final R1 = '020000000000000000000000000000000000000000000000000000000000000002'.pointFromHex();
    final R2 = '020000000000000000000000000000000000000000000000000000000000000001'.pointFromHex();
    final K = '020000000000000000000000000000000000000000000000000000000000000001'.pointFromHex();
    final C_ = '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2'.pointFromHex();

    const hashE = 'a4dc034b74338c28c6bc3ea49731f2a24440fc7c4affc08b31a93fc9fbe6401e';

    expect(DLEQ.hashE([R1, R2, K, C_]).asHex(), isNot(hashE));
  });

  test('DLQE.verify - success', () {
    const A = '0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798';
    const B_ = '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2';
    const C_ = '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2';
    const e = '9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73d9';
    const s = '9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73da';

    final result = DLEQ.verify(
      AHex: A,
      B_Hex: B_,
      C_Hex: C_,
      eHex: e,
      sHex: s,
    );

    expect(result, true);
  });

  test('DLQE.verify - fail', () {
    const A = '0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798';
    const B_ = '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2';
    const C_ = '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2';
    const e = '9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73d1';
    const s = '9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73da';

    final result = DLEQ.verify(
      AHex: A,
      B_Hex: B_,
      C_Hex: C_,
      eHex: e,
      sHex: s,
    );

    expect(result, false);
  });

  test('Nut12.verifyBlindSignature - success', () {
    const A = '0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798';
    const B_ = '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2';
    final signature = BlindedSignature.fromServerMap({
      'amount': 8,
      'id': '00882760bfa2eb41',
      'C_': '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2',
      'dleq': {
        'e': '9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73d9',
        's': '9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73da'
      }
    });

    final result = Nut12.verifyBlindSignature(
      signature: signature,
      B_: B_,
      publicKey: A,
    );

    expect(result, true);
  });

  test('Nut12.verifyBlindSignature - fail', () {
    const A = '0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798';
    const B_ = '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2';
    final signature = BlindedSignature.fromServerMap({
      'amount': 8,
      'id': '00882760bfa2eb41',
      'C_': '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2',
      'dleq': {
        'e': '9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73da',
        's': '9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73d9'
      }
    });

    final result = Nut12.verifyBlindSignature(
      signature: signature,
      B_: B_,
      publicKey: A,
    );

    expect(result, false);
  });

  test('Nut12.verifyBlindSignature - miss dleq - null', () {
    const A = '0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798';
    const B_ = '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2';
    final signature1 = BlindedSignature.fromServerMap({
      'amount': 8,
      'id': '00882760bfa2eb41',
      'C_': '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2',
      'dleq': {}
    });
    final signature2 = BlindedSignature.fromServerMap({
      'amount': 8,
      'id': '00882760bfa2eb41',
      'C_': '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2',
    });
    final signature3 = BlindedSignature.fromServerMap({
      'amount': 8,
      'id': '00882760bfa2eb41',
      'C_': '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2',
      'dleq': {
        'e': '9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73da',
      }
    });
    final signature4 = BlindedSignature.fromServerMap({
      'amount': 8,
      'id': '00882760bfa2eb41',
      'C_': '02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2',
      'dleq': {
        's': '9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73d9'
      }
    });

    final result1 = Nut12.verifyBlindSignature(
      signature: signature1,
      B_: B_,
      publicKey: A,
    );
    final result2 = Nut12.verifyBlindSignature(
      signature: signature2,
      B_: B_,
      publicKey: A,
    );
    final result3 = Nut12.verifyBlindSignature(
      signature: signature3,
      B_: B_,
      publicKey: A,
    );
    final result4 = Nut12.verifyBlindSignature(
      signature: signature4,
      B_: B_,
      publicKey: A,
    );

    expect(result1, null);
    expect(result2, null);
    expect(result3, null);
    expect(result4, null);
  });

  test('Nut12.verifyProof - success', () {
    const A = '0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798';
    final proof = ProofIsar.fromServerJson({
      'amount': 1,
      'id': '00882760bfa2eb41',
      'secret': 'daf4dd00a2b68a0858a80450f52c8a7d2ccf87d375e43e216e0c571f089f63e9',
      'C': '024369d2d22a80ecf78f3937da9d5f30c1b9f74f0c32684d583cca0fa6a61cdcfc',
      'dleq': {
        'e': 'b31e58ac6527f34975ffab13e70a48b6d2b0d35abc4b03f0151f09ee1a9763d4',
        's': '8fbae004c59e754d71df67e392b6ae4e29293113ddc2ec86592a0431d16306d8',
        'r': 'a6d13fcd7a18442e6076f5e1e7c887ad5de40a019824bdfa9fe740d302e8d861'
      }
    });

    final result = Nut12.verifyProof(
      proof: proof,
      publicKey: A,
    );

    expect(result, true);
  });

  test('Nut12.verifyProof - fail', () {
    const A = '0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798';
    final proof = ProofIsar.fromServerJson({
      'amount': 1,
      'id': '00882760bfa2eb41',
      'secret': 'daf4dd00a2b68a0858a80450f52c8a7d2ccf87d375e43e216e0c571f089f63e9',
      'C': '024369d2d22a80ecf78f3937da9d5f30c1b9f74f0c32684d583cca0fa6a61cdcfc',
      'dleq': {
        'e': '8fbae004c59e754d71df67e392b6ae4e29293113ddc2ec86592a0431d16306d8',
        's': 'b31e58ac6527f34975ffab13e70a48b6d2b0d35abc4b03f0151f09ee1a9763d4',
        'r': 'a6d13fcd7a18442e6076f5e1e7c887ad5de40a019824bdfa9fe740d302e8d861'
      }
    });

    final result = Nut12.verifyProof(
      proof: proof,
      publicKey: A,
    );

    expect(result, false);
  });

  test('Nut12.verifyProof - miss dleq - null', () {
    const A = '0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798';
    final proof1 = ProofIsar.fromServerJson({
      'amount': 1,
      'id': '00882760bfa2eb41',
      'secret': 'daf4dd00a2b68a0858a80450f52c8a7d2ccf87d375e43e216e0c571f089f63e9',
      'C': '024369d2d22a80ecf78f3937da9d5f30c1b9f74f0c32684d583cca0fa6a61cdcfc',
    });
    final proof2 = ProofIsar.fromServerJson({
      'amount': 1,
      'id': '00882760bfa2eb41',
      'secret': 'daf4dd00a2b68a0858a80450f52c8a7d2ccf87d375e43e216e0c571f089f63e9',
      'C': '024369d2d22a80ecf78f3937da9d5f30c1b9f74f0c32684d583cca0fa6a61cdcfc',
      'dleq': {}
    });
    final proof3 = ProofIsar.fromServerJson({
      'amount': 1,
      'id': '00882760bfa2eb41',
      'secret': 'daf4dd00a2b68a0858a80450f52c8a7d2ccf87d375e43e216e0c571f089f63e9',
      'C': '024369d2d22a80ecf78f3937da9d5f30c1b9f74f0c32684d583cca0fa6a61cdcfc',
      'dleq': {
        'e': '8fbae004c59e754d71df67e392b6ae4e29293113ddc2ec86592a0431d16306d8',
        's': 'b31e58ac6527f34975ffab13e70a48b6d2b0d35abc4b03f0151f09ee1a9763d4',
      }
    });

    final result1 = Nut12.verifyProof(
      proof: proof1,
      publicKey: A,
    );
    final result2 = Nut12.verifyProof(
      proof: proof2,
      publicKey: A,
    );
    final result3 = Nut12.verifyProof(
      proof: proof3,
      publicKey: A,
    );

    expect(result1, null);
    expect(result2, null);
    expect(result3, null);
  });
}
