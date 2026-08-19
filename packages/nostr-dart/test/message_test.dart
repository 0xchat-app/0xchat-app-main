import 'package:nostr_core_dart/nostr.dart';
import 'package:test/test.dart';

void main() {
  group('Message', () {
    test('EVENT', () {
      String payload =
          '["EVENT","0954524188078879",{"id":"da5107e5aa00978e0dd9bb3c09b2303af414fe4c10600b3c61bb938675d191af","kind":1,"pubkey":"da0cc82154bdf4ce8bf417eaa2d2fa99aa65c96c77867d6656fccdbf8e781b18","created_at":1675015235,"content":"#[0] test","tags":[["p","939ddb0c77d18ccd1ebb44c7a32b9cdc29b489e710c54db7cf1383ee86674a24"]],"sig":"f2b507e1039084d07477ccd2876ee0eb9e80f214be80e4e2ab28ad60dc5858297bbd9bf177be230b571c0015deb05c12eb02b659586fd3573cfa84c9292400b5"}]';
      var msg = Message.deserialize(payload);
      expect(msg.type, "EVENT");
      expect(msg.message.id,
          "da5107e5aa00978e0dd9bb3c09b2303af414fe4c10600b3c61bb938675d191af");
    });
    test('REQ', () {
      String payload =
          '["REQ","22055752544101437",{"kinds":[0,1,2,7],"since":1674320733,"limit":450}]';
      var msg = Message.deserialize(payload);
      expect(msg.type, "REQ");
      expect(msg.message.filters[0].limit, 450);
    });
    test('CLOSE', () {
      String payload = '["CLOSE","anyrandomstring"]';
      var msg = Message.deserialize(payload);
      expect(msg.type, "CLOSE");
      expect(msg.message.subscriptionId, "anyrandomstring");
    });
    test('NOTICE', () {
      String payload =
          '["NOTICE", "restricted: we can\'t serve DMs to unauthenticated users, does your client implement NIP-42?"]';
      var msg = Message.deserialize(payload);
      expect(msg.type, "NOTICE");
    });

    test('EOSE', () {
      String payload = '["EOSE", "random"]';
      var msg = Message.deserialize(payload);
      expect(msg.type, "EOSE");
    });

    test('OK', () {
      String payload =
          '["OK", "b1a649ebe8b435ec71d3784793f3bbf4b93e64e17568a741aecd4c7ddeafce30", true, ""]';
      var msg = Message.deserialize(payload);
      expect(msg.type, "OK");
    });
  });
}
