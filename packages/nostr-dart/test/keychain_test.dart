import 'package:nostr_core_dart/nostr.dart';
import 'package:test/test.dart';

void main() {
  group('Keychain', () {
    test('Default constructor', () {
      var hex =
          "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12";
      var keys = Keychain(hex);
      expect(keys.private, hex);
      expect(
        keys.public,
        "981cc2078af05b62ee1f98cff325aac755bf5c5836a265c254447b5933c6223b",
      );
    });

    test('Keychain with invalid public key (public.length != 64)', () {
      var hex =
          "ea7daa0537b93aa3ae4495a274ecc05077e3dc168809d77a7afa4ec1db0fb3bd";

      var keys = Keychain(hex);
      expect(keys.public.length, 64);
    });

    test('Keychain with invalid private key (private.length != 64)', () {
      expect(
          () => Keychain(
                "",
              ),
          throwsA(isA<AssertionError>()));
    });

    test('Keychain.generate', () {
      var keys = Keychain.generate();
      expect(keys.public.length, 64);
      expect(keys.private.length, 64);
    });

    test('Keychain.verify', () {
      var hex =
          "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12";
      var keys = Keychain(hex);
      var message =
          "4b697394206581b03ca5222b37449a9cdca1741b122d78defc177444e2536f49";
      var signature =
          "797c47bef50eff748b8af0f38edcb390facf664b2367d72eb71c50b5f37bc83c4ae9cc9007e8489f5f63c66a66e101fd1515d0a846385953f5f837efb9afe885";

      expect(
          Keychain.verify(
            keys.public,
            message,
            signature,
          ),
          true);
    });
  });
}
