import 'package:nostr_core_dart/nostr.dart';

/// Encrypted Direct Message
class Nip4 {
  /// Returns the EDMessage Encrypted Direct Message event (kind=4)
  ///
  /// ```dart
  ///  var event = Event.from(
  ///    pubkey: senderPubKey,
  ///    created_at: 12121211,
  ///    kind: 4,
  ///    tags: [
  ///      ["p", receiverPubKey],
  ///      ["e", <event-id>, <relay-url>, <marker>],
  ///    ],
  ///    content: "wLzN+Wt2vKhOiO8v+FkSzA==?iv=X0Ura57af2V5SuP80O6KkA==",
  ///  );
  ///
  ///  EDMessage eDMessage = Nip4.decode(event);
  ///```
  static Future<EDMessage?> decode(Event event, String myPubkey, String privkey) async {
    if (event.kind == 4) {
      return await _toEDMessage(event, myPubkey, privkey);
    }
    return null;
  }

  /// Returns EDMessage from event
  static Future<EDMessage> _toEDMessage(Event event, String myPubkey, String privkey) async {
    String sender = event.pubkey;
    int createdAt = event.createdAt;
    String receiver = "";
    String replyId = "";
    String content = "";
    String subContent = event.content;
    String? expiration;
    Map<String, String> emojiMap = {};
    for (var tag in event.tags) {
      if (tag[0] == "p") receiver = tag[1];
      if (tag[0] == "e") replyId = tag[1];
      if (tag[0] == "subContent") subContent = tag[1];
      if (tag[0] == "expiration") expiration = tag[1];
      // Extract emoji tags (NIP-30)
      if (tag[0] == 'emoji' && tag.length >= 3) {
        emojiMap[tag[1]] = tag[2];
      }
    }
    if (receiver.compareTo(myPubkey) == 0) {
      content = await decryptContent(subContent, sender, myPubkey, privkey);
    } else if (sender.compareTo(myPubkey) == 0) {
      content = await decryptContent(subContent, receiver, myPubkey, privkey);
    } else {
      throw Exception("not correct receiver, is not nip4 compatible");
    }

    return EDMessage(sender, receiver, createdAt, content, replyId, expiration, emojiShortcodes: emojiMap);
  }

  static Future<String> decryptContent(
      String content, String peerPubkey, String myPubkey, String privkey) async {
    int ivIndex = content.indexOf("?iv=");
    if (ivIndex <= 0) {
      print("Invalid content for dm, could not get ivIndex: $content");
      return "";
    }
    String iv = content.substring(ivIndex + "?iv=".length, content.length);
    String encString = content.substring(0, ivIndex);
    try {
      if (SignerHelper.needSigner(privkey)) {
        return await SignerHelper.decryptNip04(content, peerPubkey, myPubkey, privkey) ?? '';
      } else {
        return decrypt(privkey, '02$peerPubkey', encString, iv);
      }
    } catch (e) {
      return "";
    }
  }

  static Future<Event> encode(
      String sender, String receiver, String content, String replyId, String replyUser, String privkey,
      {String? subContent, int? expiration, Map<String, String>? emojiShortcodes}) async {
    String enContent = await encryptContent(content, receiver, sender, privkey);
    List<List<String>> tags = toTags(receiver, replyId, replyUser, expiration);
    if (subContent != null && subContent.isNotEmpty) {
      String enSubContent = await encryptContent(subContent, receiver, sender, privkey);
      tags.add(['subContent', enSubContent]);
    }
    // Add emoji tags for custom emojis (NIP-30)
    if (emojiShortcodes != null) {
      emojiShortcodes.forEach((shortcode, url) {
        tags.add(['emoji', shortcode, url]);
      });
    }
    Event event =
        await Event.from(kind: 4, tags: tags, content: enContent, pubkey: sender, privkey: privkey);
    return event;
  }

  static Future<String> encryptContent(
      String plainText, String peerPubkey, String myPubkey, String privkey) async {
    if (SignerHelper.needSigner(privkey)) {
      return await SignerHelper.encryptNip04(plainText, peerPubkey, myPubkey, privkey) ?? '';
    } else {
      return encrypt(privkey, '02$peerPubkey', plainText);
    }
  }

  /// Creates tags for NIP-4/NIP-17 messages.
  ///
  /// [relayHints] is an optional map of pubkey -> relay URL for p-tag hints.
  /// Per NIP-17, p-tags should include relay hints: ["p", "<pubkey>", "<relay-url>"]
  static List<List<String>> toTags(String p, String q, String qPubkey, int? expiration,
      {List<String>? members, Map<String, String>? relayHints}) {
    List<List<String>> result = [];
    if (p.isNotEmpty) {
      String? hint = relayHints?[p];
      result.add(hint != null ? ["p", p, hint] : ["p", p]);
    }
    for (var m in members ?? []) {
      if (m != p) {
        String? hint = relayHints?[m];
        result.add(hint != null ? ["p", m, hint] : ["p", m]);
      }
    }
    // Use 'e' tag for replies per NIP-17: ["e", "<kind-14-id>", "<relay-url>"]
    // relay-url can be empty string if not available
    if (q.isNotEmpty) result.add(["e", q, '']);
    if (expiration != null) result.add(['expiration', expiration.toString()]);
    return result;
  }
}

/// ```
class EDMessage {
  String sender;
  String receiver;
  int createdAt;
  String content;
  String replyId;
  String? expiration;
  String? groupId;
  Map<String, String>? emojiShortcodes; // Custom emoji shortcode to URL map (NIP-30)
  String? subject;
  List<String>? members;
  String? mimeType;
  String? algorithm;
  String? secret;
  String? nonce;

  /// Default constructor
  EDMessage(this.sender, this.receiver, this.createdAt, this.content, this.replyId, this.expiration,
      {this.groupId,
      this.subject,
      this.members,
      this.mimeType,
      this.algorithm,
      this.secret,
      this.nonce,
      this.emojiShortcodes});

  /// Creates an instance of EDMessage from a Map
  factory EDMessage.fromMap(Map<String, dynamic> map) {
    return EDMessage(
      map['sender'] as String,
      map['receiver'] as String,
      map['createdAt'] as int,
      map['content'] as String,
      map['replyId'] as String,
      map['expiration'] as String?,
      groupId: map['groupId'] as String?,
      subject: map['subject'] as String?,
      members: map['members'] != null ? List<String>.from(map['members'] as List) : null,
      mimeType: map['mimeType'] as String?,
      algorithm: map['algorithm'] as String?,
      secret: map['secret'] as String?,
      nonce: map['nonce'] as String?,
    );
  }

  /// Converts an instance of EDMessage to a Map
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'createdAt': createdAt,
      'content': content,
      'replyId': replyId,
      'expiration': expiration,
      'groupId': groupId,
      'subject': subject,
      'members': members,
      'mimeType': mimeType,
      'algorithm': algorithm,
      'secret': secret,
      'nonce': nonce,
    };
  }
}
