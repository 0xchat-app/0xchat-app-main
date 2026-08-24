import 'dart:convert';
import 'package:nostr_core_dart/nostr.dart';

/// Lists
class Nip51 {
  static List<List<String>> peoplesToTags(List<People> items) {
    List<List<String>> result = [];
    for (People item in items) {
      result.add([
        "p",
        item.pubkey,
        item.mainRelay ?? "",
        item.petName ?? "",
        item.aliasPubKey ?? "",
      ]);
    }
    return result;
  }

  static List<List<String>> bookmarksToTags(List<String> items) {
    List<List<String>> result = [];
    for (String item in items) {
      result.add(["e", item]);
    }
    return result;
  }

  static List<List<String>> simpleGroupToTags(List<SimpleGroups> items) {
    List<List<String>> result = [];
    for (var item in items) {
      result.add(["group", item.groupId, item.relay]);
    }
    return result;
  }

  static Future<String> peoplesToContent(List<People> items, String privkey, String pubkey,
      {List<String>? hashTags, List<String>? words, List<String>? threads}) async {
    var list = [];
    for (People item in items) {
      list.add([
        'p',
        item.pubkey,
        item.mainRelay ?? "",
        item.petName ?? "",
        item.aliasPubKey ?? "",
      ]);
    }
    for (var t in hashTags ?? []) {
      list.add(['t', t]);
    }
    for (var word in words ?? []) {
      list.add(['word', word]);
    }
    for (var e in threads ?? []) {
      list.add(['e', e]);
    }
    String content = jsonEncode(list);
    return await Nip4.encryptContent(content, pubkey, pubkey, privkey);
  }

  static Future<String> bookmarksToContent(
      List<String> items, String privkey, String pubkey) async {
    var list = [];
    for (String item in items) {
      list.add(['e', item]);
    }
    String content = jsonEncode(list);
    return await Nip4.encryptContent(content, pubkey, pubkey, privkey);
  }

  static Future<String> groupsToContent(
      List<SimpleGroups> items, String privkey, String pubkey) async {
    if (items.isEmpty) return '';
    var list = [];
    for (var item in items) {
      list.add(['group', item.groupId, item.relay]);
    }
    String content = jsonEncode(list);
    return await Nip4.encryptContent(content, pubkey, pubkey, privkey);
  }

  static Future<Map<String, List>?> fromContent(
      String content, String privkey, String pubkey) async {
    List<People> people = [];
    List<String> bookmarks = [];
    List<String> words = [];
    List<String> hashTags = [];
    List<SimpleGroups> groups = [];
    int ivIndex = content.indexOf("?iv=");
    String deContent = '';
    if (ivIndex <= 0) {
      /// try nip44 decrypted
      deContent = await Nip44.decryptContent(content, pubkey, pubkey, privkey);
    } else {
      /// try nip4 decrypted
      deContent = await Nip4.decryptContent(content, pubkey, pubkey, privkey);
    }
    if (deContent.isNotEmpty) {
      for (List tag in jsonDecode(deContent)) {
        if (tag[0] == "p") {
          people.add(People(tag[1], tag.length > 2 ? tag[2] : "", tag.length > 3 ? tag[3] : "",
              tag.length > 4 ? tag[4] : ""));
        } else if (tag[0] == "e") {
          // bookmark
          bookmarks.add(tag[1]);
        } else if (tag[0] == "word") {
          words.add(tag[1]);
        } else if (tag[0] == "t") {
          hashTags.add(tag[1]);
        } else if (tag[0] == "group") {
          groups.add(SimpleGroups(tag[1], tag.length > 2 ? tag[2] : ''));
        }
      }
    }

    return {
      "people": people,
      "bookmarks": bookmarks,
      "groups": groups,
      "words": words,
      "hashTags": hashTags
    };
  }

  static Future<Event> createMutePeople(
      List<People> items, List<People> encryptedItems, String privkey, String pubkey,
      {List<String>? hashTags, List<String>? words, List<String>? threads}) async {
    String content = await peoplesToContent(encryptedItems, privkey, pubkey,
        hashTags: hashTags, words: words, threads: threads);
    return Event.from(
        kind: 10000,
        tags: peoplesToTags(items),
        content: content,
        pubkey: pubkey,
        privkey: privkey);
  }

  static Future<Event> createPinEvent(
      List<String> items, List<String> encryptedItems, String privkey, String pubkey) async {
    String content = await bookmarksToContent(encryptedItems, privkey, pubkey);
    return Event.from(
        kind: 10001,
        tags: bookmarksToTags(items),
        content: content,
        pubkey: pubkey,
        privkey: privkey);
  }

  static Future<Event> createPublicChatList(
      List<String> items, List<String> encryptedItems, String privkey, String pubkey) async {
    String content = await bookmarksToContent(encryptedItems, privkey, pubkey);
    return Event.from(
        kind: 10005,
        tags: bookmarksToTags(items),
        content: content,
        pubkey: pubkey,
        privkey: privkey);
  }

  static Future<Event> createSimpleGroupList(List<SimpleGroups> items,
      List<SimpleGroups> encryptedItems, String privkey, String pubkey) async {
    String content = await groupsToContent(encryptedItems, privkey, pubkey);
    return Event.from(
        kind: 10009,
        tags: simpleGroupToTags(items),
        content: content,
        pubkey: pubkey,
        privkey: privkey);
  }

  static Future<Event> createCategorizedPeople(String identifier, List<People> items,
      List<People> encryptedItems, String privkey, String pubkey) async {
    List<List<String>> tags = peoplesToTags(items);
    tags.add(["d", identifier]);
    String content = await peoplesToContent(encryptedItems, privkey, pubkey);
    return Event.from(kind: 30000, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
  }

  static Future<Event> createCategorizedBookmarks(String identifier, List<String> items,
      List<String> encryptedItems, String privkey, String pubkey) async {
    List<List<String>> tags = bookmarksToTags(items);
    tags.add(["d", identifier]);
    String content = await bookmarksToContent(encryptedItems, privkey, pubkey);
    return Event.from(kind: 30003, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
  }

  static Future<Lists> getLists(Event event, String pubkey, String privkey) async {
    if (event.kind != 10000 &&
        event.kind != 10001 &&
        event.kind != 10005 &&
        event.kind != 10009 &&
        event.kind != 30000 &&
        event.kind != 30001 &&
        event.kind != 30003) {
      throw Exception("${event.kind} is not nip51 compatible");
    }
    String identifier = "";
    List<People> people = [];
    List<String> bookmarks = [];
    List<String> words = [];
    List<String> hashTags = [];
    List<SimpleGroups> groups = [];
    for (List tag in event.tags) {
      if (tag[0] == "p") {
        people.add(People(tag[1], tag.length > 2 ? tag[2] : "", tag.length > 3 ? tag[3] : "",
            tag.length > 4 ? tag[4] : ""));
      }
      if (tag[0] == "e") {
        bookmarks.add(tag[1]);
      }
      if (tag[0] == "word") {
        words.add(tag[1]);
      }
      if (tag[0] == "t") {
        hashTags.add(tag[1]);
      }
      if (tag[0] == "group") {
        groups.add(SimpleGroups(tag[1], tag.length > 2 ? tag[2] : ''));
      }
      if (tag[0] == "d") identifier = tag[1];
    }
    Map? content = await Nip51.fromContent(event.content, privkey, pubkey);
    if (content != null) {
      people.addAll(content["people"]);
      bookmarks.addAll(content["bookmarks"]);
      groups.addAll(content["groups"]);
      words.addAll(content["words"]);
      hashTags.addAll(content["hashTags"]);
    }
    if (event.kind == 10000) identifier = "Mute";
    if (event.kind == 10001) identifier = "Pin";
    if (event.kind == 10005) identifier = "Public chats";
    if (event.kind == 10009) identifier = "Simple groups";

    return Lists(
        event.pubkey, identifier, people, bookmarks, words, hashTags, groups, event.createdAt);
  }
}

///
class People {
  String pubkey;
  String? mainRelay;
  String? petName;
  String? aliasPubKey;

  /// Default constructor
  People(this.pubkey, this.mainRelay, this.petName, this.aliasPubKey);
}

class SimpleGroups {
  String groupId;
  String relay;
  SimpleGroups(this.groupId, this.relay);
}

class Lists {
  String owner;

  String identifier;

  List<People> people;

  List<String> bookmarks;

  List<String> words;

  List<String> hashTags;

  List<SimpleGroups> groups;

  int createTime;

  /// Default constructor
  Lists(this.owner, this.identifier, this.people, this.bookmarks, this.words, this.hashTags,
      this.groups, this.createTime);
}
