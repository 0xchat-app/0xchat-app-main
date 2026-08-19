import 'package:nostr_core_dart/nostr.dart';
import 'package:test/test.dart';

void main() {
  group('nip002', () {
    test('Profile constructor', () {
      String key = "91cf9..4e5ca";
      String relay = "wss://alicerelay.com/";
      String petname = "alice";
      var profile = Profile(key, relay, petname);
      expect(profile.key, key);
      expect(profile.relay, relay);
      expect(profile.petname, petname);
    });

    test('Nip2.tagsToProfiles', () {
      List<List<String>> tags = [
        ["p", "91cf9..4e5ca", "wss://alicerelay.com/", "alice"],
        ["p", "14aeb..8dad4", "wss://bobrelay.com/nostr", "bob"],
        ["p", "612ae..e610f", "ws://carolrelay.com/ws", "carol"]
      ];
      List<Profile> profiles = Nip2.toProfiles(tags);
      expect(profiles[0].key, tags[0][1]);
      expect(profiles[1].relay, tags[1][2]);
      expect(profiles[2].petname, tags[2][3]);
    });

    test('Nip2.profilesToTags', () {
      String key = "21df6d143fb96c2ec9d63726bf9edc71";
      String relay = "";
      String petname = "erin";
      List<Profile> profiles = [Profile(key, relay, petname)];
      List<List<String>> tags = Nip2.toTags(profiles);
      expect(tags[0][0], "p");
      expect(tags[0][1], key);
      expect(tags[0][2], relay);
      expect(tags[0][3], petname);
    });

    test('Nip2.decode', () {
      var event = Event.from(
        kind: 3,
        tags: [
          ["p", "91cf9..4e5ca", "wss://alicerelay.com/", "alice"],
          ["p", "14aeb..8dad4", "wss://bobrelay.com/nostr", "bob"],
          ["p", "612ae..e610f", "ws://carolrelay.com/ws", "carol"],
        ],
        content: "",
        privkey:
            "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12",
      );

      List<Profile> profiles = Nip2.decode(event);
      expect(profiles[0].key, "91cf9..4e5ca");
      expect(profiles[1].relay, "wss://bobrelay.com/nostr");
      expect(profiles[2].petname, "carol");
    });

    test('Nip2.decode throws Exception', () {
      var event = Event.from(
        kind: 6,
        tags: [],
        content: "",
        privkey:
            "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12",
      );
      expect(() => Nip2.decode(event), throwsException);
    });
  });
}
