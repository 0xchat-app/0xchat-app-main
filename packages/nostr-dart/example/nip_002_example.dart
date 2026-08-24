import 'package:nostr_core_dart/nostr.dart';

void main() {
  // Decode profiles from an event of kind=3
  var event = Event.from(
    kind: 3,
    tags: [
      ["p", "91cf9..4e5ca", "wss://alicerelay.com/", "alice"],
      ["p", "14aeb..8dad4", "wss://bobrelay.com/nostr", "bob"],
      ["p", "612ae..e610f", "ws://carolrelay.com/ws", "carol"],
    ],
    content: "",
    privkey: "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12",
  );

  List<Profile> someProfiles = Nip2.decode(event);
  assert(someProfiles[0].key == "91cf9..4e5ca");
  assert(someProfiles[1].relay == "wss://bobrelay.com/nostr");
  assert(someProfiles[2].petname == "carol");

  // Instantiate a new nip2 profile
  String key = "91cf9..4e5ca";
  String relay = "wss://alicerelay.com/";
  String petname = "alice";
  var alice = Profile(key, relay, petname);

  List<Profile> profiles = [
    alice,
    Profile("21df6d143fb96c2ec9d63726bf9edc71", "", "erin")
  ];

  // Encode profiles to nostr event.tags
  List<List<String>> tags = Nip2.toTags(profiles);
  assert(tags[1][0] == "p");
  assert(tags[1][3] == "erin");

  // Decode event.tags to profiles list
  List<Profile> newProfiles = Nip2.toProfiles([
    ["p", "91cf9..4e5ca", "wss://alicerelay.com/", "alice"],
    ["p", "14aeb..8dad4", "wss://bobrelay.com/nostr", "bob"],
    ["p", "612ae..e610f", "ws://carolrelay.com/ws", "carol"]
  ]);
  assert(newProfiles[2].petname == "carol");
}
