import 'dart:typed_data';

import 'package:cashu_dart/core/nuts/v1/nut_13.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;

void main() {
  final Uint8List seed = hexToUint8List('dd44ee516b0647e80b488e8dcc56d736a148f15276bef588b37057476d4b2b25780d3688a32b37353d6995997842c0fd8b412475c891c16310471fbc86dcbda8');


  // final CashuDartPlatform initialPlatform = CashuDartPlatform.instance;
  //
  test('$Nut13 tests', () {


  });
  
	test('hdkey to uint8array', () {
		var hdkey = bip32.BIP32.fromSeed(seed);
		var privateKey = hdkey.privateKey;
		expect(privateKey?.isEmpty, false);

		var seedExpected =
			'dd44ee516b0647e80b488e8dcc56d736a148f15276bef588b37057476d4b2b25780d3688a32b37353d6995997842c0fd8b412475c891c16310471fbc86dcbda8';
		var seed_uint8_array_expected = hexToUint8List(seedExpected);
		expect(seed, seed_uint8_array_expected);
	});

  group('test secrets', () {
	var secrets = [
		'485875df74771877439ac06339e284c3acfcd9be7abf3bc20b516faeadfe77ae',
		'8f2b39e8e594a4056eb1e6dbb4b0c38ef13b1b2c751f64f810ec04ee35b77270',
		'bc628c79accd2364fd31511216a0fab62afd4a18ff77a20deded7b858c9860c8',
		'59284fd1650ea9fa17db2b3acf59ecd0f2d52ec3261dd4152785813ff27a33bf',
		'576c23393a8b31cc8da6688d9c9a96394ec74b40fdaf1f693a6bb84284334ea0'
	];
	test('derive Secret', () {
		var secret1 = Nut13.deriveSecret(seed, '009a1f293253e41e', 0);
		var secret2 = Nut13.deriveSecret(seed, '009a1f293253e41e', 1);
		var secret3 = Nut13.deriveSecret(seed, '009a1f293253e41e', 2);
		var secret4 = Nut13.deriveSecret(seed, '009a1f293253e41e', 3);
		var secret5 = Nut13.deriveSecret(seed, '009a1f293253e41e', 4);

		expect(toHexString(secret1), secrets[0]);
		expect(toHexString(secret2), secrets[1]);
		expect(toHexString(secret3), secrets[2]);
		expect(toHexString(secret4), secrets[3]);
		expect(toHexString(secret5), secrets[4]);
	});
});
  //
  // test('getPlatformVersion', () async {
  //   CashuDart cashuDartPlugin = CashuDart();
  //   MockCashuDartPlatform fakePlatform = MockCashuDartPlatform();
  //   CashuDartPlatform.instance = fakePlatform;
  //
  //   expect(await cashuDartPlugin.getPlatformVersion(), '42');
  // });
}
