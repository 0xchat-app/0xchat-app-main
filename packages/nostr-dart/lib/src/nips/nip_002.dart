import 'package:nostr_core_dart/nostr.dart';

/// Contact List and Petnames
///
/// A special event with kind 3, meaning "contact list" is defined as having a list of p tags, one for each of the followed/known profiles one is following.
///
/// Each tag entry should contain the key for the profile, a relay URL where events from that key can be found
/// (can be set to an empty string if not needed), and a local name (or "petname") for that profile (can also be set to an empty string or not provided),
/// i.e., ["p", "32-bytes hex key", "main relay URL", "petname"].
/// The content can be anything and should be ignored.
class Nip2 {
  /// Returns the profils from a contact list event (kind=3)
  ///
  /// ```dart
  ///  var event = Event.from(
  ///    kind: 3,
  ///    tags: [
  ///      ["p", "91cf9..4e5ca", "wss://alicerelay.com/", "alice"],
  ///      ["p", "14aeb..8dad4", "wss://bobrelay.com/nostr", "bob"],
  ///      ["p", "612ae..e610f", "ws://carolrelay.com/ws", "carol"],
  ///    ],
  ///    content: "",
  ///    privkey: "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12",
  ///  );
  ///
  ///  List<Profile> profiles = Nip2.decode(event);
  ///```
  static List<Profile> decode(Event event) {
    if (event.kind == 3) {
      return toProfiles(event.tags);
    }
    throw Exception("${event.kind} is not nip2 compatible");
  }

  /// Returns profiles from event.tags
  ///
  /// ```dart
  /// List<List<String>> tags = [
  ///   ["p", "91cf9..4e5ca", "wss://alicerelay.com/", "alice"],
  ///   ["p", "14aeb..8dad4", "wss://bobrelay.com/nostr", "bob"],
  ///   ["p", "612ae..e610f", "ws://carolrelay.com/ws", "carol"]
  /// ];
  /// List<Profile> profiles = Nip2.toProfiles(tags);
  /// ```
  static List<Profile> toProfiles(List<List<String>> tags) {
    List<Profile> result = [];
    for (var tag in tags) {
      if (tag[0] == "p") {
        result.add(Profile(tag[1], tag.length > 2 ? tag[2] : '',
            tag.length > 3 ? tag[3] : ''));
      }
    }
    return result;
  }

  /// Returns tags from profiles list
  ///
  /// ```dart
  /// List<Profile> profiles = [Profile("21df6d143fb96c2ec9d63726bf9edc71", "ws://erinrelay.com/ws", "erin")];
  /// List<List<String>> tags = Nip2.toTags(profiles);
  /// ```
  static List<List<String>> toTags(List<Profile> profiles) {
    List<List<String>> result = [];
    for (var profile in profiles) {
      result.add(["p", profile.key, profile.relay, profile.petname]);
    }
    return result;
  }

  static Future<Event> encode(
      List<Profile> profiles, String pubkey, String privkey) {
    return Event.from(
        kind: 3,
        tags: toTags(profiles),
        content: '',
        pubkey: pubkey,
        privkey: privkey);
  }
}

/// Each tag entry should contain the key for the profile, a relay URL where events from that key can be found
/// (can be set to an empty string if not needed), and a local name (or "petname") for that profile (can also be set to an empty string or not provided),
/// i.e., ["p", "32-bytes hex key", "main relay URL", "petname"].
/// The content can be anything and should be ignored.
///
/// ```dart
/// String key = "91cf9..4e5ca";
/// String relay = "wss://alicerelay.com/";
/// String petname = "alice";
/// var profile = Profile(key, relay, petname);
/// ```
class Profile {
  /// Each tag entry should contain the key for the profile,
  String key;

  /// A relay URL where events from that key can be found (can be set to an empty string if not needed)
  String relay;

  /// A local name (or "petname") for that profile (can also be set to an empty string or not provided)
  String petname;

  /// Default constructor
  Profile(this.key, this.relay, this.petname);
}
