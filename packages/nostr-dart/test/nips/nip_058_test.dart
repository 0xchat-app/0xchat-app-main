import 'package:nostr_core_dart/nostr.dart';
import 'package:test/test.dart';

void main() {
  group('nip058', () {
    test('setBadgeDefinition', () {
      var sender = Keychain.generate();
      print(sender.public);
      print(sender.private);
      Event event = Nip58.setBadgeDefinition(
          'bravery',
          'medal of bravery',
          'awarded to users demonstrating bravery',
          BadgeImage(
              'https://www.0xchat.com/ipfs/qmwqmvsutpfkbtaz9xlk4t1tsjxpjen8hcgxuqkzzxrugv',
              '1024x1024'),
          BadgeImage(
              'https://www.0xchat.com/ipfs/qmwqmvsutpfkbtaz9xlk4t1tsjxpjen8hcgxuqkzzxrugv',
              '256x256'),
          sender.private);

      print(event.serialize());
    });
  });
}
