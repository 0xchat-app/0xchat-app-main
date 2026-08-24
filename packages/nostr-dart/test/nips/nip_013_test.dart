import 'package:nostr_core_dart/nostr.dart';
import 'package:test/test.dart';

void main() {
  group('nip013', () {
    test('Nip13.countLeadingZeroes', () {
      String hex = '0003';
      int lz = Nip13.countLeadingZeroes(hex);
      expect(lz, 14);
    });
  });
}
