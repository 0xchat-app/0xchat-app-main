import 'package:nostr_core_dart/nostr.dart';

/// Badges
class Nip58 {
  // {
  //   "pubkey": "alice",
  //   "kind": 30009,
  //   "tags": [
  //     ["d", "bravery"],
  //     ["name", "Medal of Bravery"],
  //     ["description", "Awarded to users demonstrating bravery"],
  //     ["image", "https://nostr.academy/awards/bravery.png", "1024x1024"],
  //     ["thumb", "https://nostr.academy/awards/bravery_256x256.png", "256x256"],
  //   ],
  //   ...
  // }
  static Badge? getBadgeDefinition(Event event) {
    if (event.kind == 30009) {
      String? identifies, name, description;
      BadgeImage? image, thumb;
      for (var tag in event.tags) {
        if (tag[0] == 'd') identifies = tag[1];
        if (tag[0] == 'name') name = tag[1];
        if (tag[0] == 'description') description = tag[1];
        if (tag[0] == 'image') image = BadgeImage(tag[1], tag[2]);
        if (tag[0] == 'thumb') thumb = BadgeImage(tag[1], tag[2]);
      }
      return Badge(event.id, identifies!, name!, description!, image!, thumb!,
          event.pubkey, event.createdAt);
    } else {
      throw Exception(
          "${event.kind} is not nip58(Badge Definition) compatible");
    }
  }

  static Future<Event> setBadgeDefinition(
      String identifies,
      String name,
      String description,
      BadgeImage image,
      BadgeImage thumb,
      String pubkey,
      String privkey) async {
    List<List<String>> tags = [];
    tags.add(['d', identifies]);
    tags.add(['name', name]);
    tags.add(['description', description]);
    tags.add(['image', image.url, image.size]);
    tags.add(['thumb', thumb.url, thumb.size]);
    return await Event.from(
        kind: 30009, tags: tags, content: '', pubkey: pubkey, privkey: privkey);
  }

  // {
  //   "id": "<badge award event id>",
  //   "kind": 8,
  //   "pubkey": "alice",
  //   "tags": [
  //     ["a", "30009:alice:bravery"],
  //     ["p", "bob", "wss://relay"],
  //     ["p", "charlie", "wss://relay"],
  //   ],
  //   ...
  // }
  static BadgeAward? getBadgeAward(Event event) {
    if (event.kind == 8) {
      EventCoordinates? coordinates;
      List<People> users = [];
      for (var tag in event.tags) {
        if (tag[0] == 'a') coordinates = Nip33.getEventCoordinates(tag);
        if (tag[0] == 'p') {
          users.add(People(tag[1], tag.length > 2 ? tag[2] : null, null, null));
        }
      }
      if (coordinates != null &&
          coordinates.kind == 30009 &&
          coordinates.pubkey == event.pubkey) {
        return BadgeAward(event.id, event.createdAt, coordinates.identifier,
            coordinates.pubkey, users);
      } else {
        throw Exception("${event.kind} is not nip58(Badge Award) compatible");
      }
    } else {
      throw Exception("${event.kind} is not nip58(Badge Award) compatible");
    }
  }

  // {
  //   "kind": 30008,
  //   "pubkey": "bob",
  //   "tags": [
  //     ["d", "profile_badges"],
  //     ["a", "30009:alice:bravery"],
  //     ["e", "<bravery badge award event id>", "wss://nostr.academy"],
  //     ["a", "30009:alice:honor"],
  //     ["e", "<honor badge award event id>", "wss://nostr.academy"],
  //   ],
  //   ...
  // }
  static List<BadgeAward> getProfileBadges(Event event) {
    if (event.kind == 30008) {
      var tag = event.tags[0];
      Map<String, BadgeAward> result = {};
      if (tag[0] == 'd') {
        for (int i = 1; i < event.tags.length; i += 2) {
          if (event.tags[i][0] == 'a' && event.tags[i + 1][0] == 'e') {
            BadgeAward? badgeAward =
                tagsToBadge(event.tags[i], event.tags[i + 1]);
            if (badgeAward != null) result[badgeAward.awardId] = badgeAward;
          }
        }
        return result.values.toList();
      } else {
        throw Exception("${event.kind} is not nip58(Profile Badge) compatible");
      }
    }
    throw Exception("${event.kind} is not nip58(Profile Badge) compatible");
  }

  static BadgeAward? tagsToBadge(List<String> tag1, List<String> tag2) {
    if (tag1[0] == 'a' && tag2[0] == 'e') {
      EventCoordinates coordinates = Nip33.getEventCoordinates(tag1);
      BadgeAward badgeAward = BadgeAward(
          tag2[1], null, coordinates.identifier, coordinates.pubkey, null);
      if (tag2.length > 2) badgeAward.relay = tag2[2];
      return badgeAward;
    }
    return null;
  }

  static Future<Event> setProfileBadges(
      List<BadgeAward> badgeAwards, String pubkey, String privkey) async {
    return await Event.from(
        kind: 30008,
        tags: badgeAwardsToTags(badgeAwards),
        content: '',
        pubkey: pubkey,
        privkey: privkey);
  }

  static List<List<String>> badgeAwardsToTags(List<BadgeAward> badgeAwards) {
    List<List<String>> tags = [
      ["d", "profile_badges"]
    ];
    for (BadgeAward badgeAward in badgeAwards) {
      EventCoordinates coordinates = EventCoordinates(
          30009, badgeAward.creator!, badgeAward.identifies!, null);
      List<String> aTag = Nip33.coordinatesToTag(coordinates);
      tags.add(aTag);
      List<String> eTag = ['e', badgeAward.awardId, badgeAward.relay ?? ''];
      tags.add(eTag);
    }
    return tags;
  }
}

class BadgeImage {
  String url;
  String size;

  BadgeImage(this.url, this.size);
}

class Badge {
  String badgeId; // event id
  String identifies;
  String name;
  String description;
  BadgeImage image;
  BadgeImage thumb;

  String creator;
  int createTime;

  Badge(this.badgeId, this.identifies, this.name, this.description, this.image,
      this.thumb, this.creator, this.createTime);
}

class BadgeAward {
  String awardId; // event id
  int? awardTime;
  String? identifies;
  String? creator;
  List<People>? users;
  String? relay;

  BadgeAward(
      this.awardId, this.awardTime, this.identifies, this.creator, this.users);
}
