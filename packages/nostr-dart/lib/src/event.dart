import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:pointycastle/export.dart';
import 'package:flutter/foundation.dart';
import 'package:bip340/bip340.dart' as bip340;
import 'package:nostr_core_dart/nostr.dart';

import 'channel/channel_crypto_tool.dart';

/// The only object type that exists is the event, which has the following format on the wire:
///
/// - "id": "32-bytes hex-encoded sha256 of the the serialized event data"
/// - "pubkey": "32-bytes hex-encoded public key of the event creator",
/// - "created_at": unix timestamp in seconds,
/// - "kind": integer,
/// - "tags": [
///    ["e", "32-bytes hex of the id of another event", "recommended relay URL"],
///    ["p", "32-bytes hex of the key", "recommended relay URL"]
///  ],
/// - "content": "arbitrary string",
/// - "sig": "64-bytes signature of the sha256 hash of the serialized event data, which is the same as the 'id' field"
class Event {
  /// 32-bytes hex-encoded sha256 of the the serialized event data (hex)
  late String id;

  /// 32-bytes hex-encoded public key of the event creator (hex)
  late String pubkey;

  /// unix timestamp in seconds
  late int createdAt;

  /// -  0: set_metadata: the content is set to a stringified JSON object {name: <username>, about: <string>, picture: <url, string>} describing the user who created the event. A relay may delete past set_metadata events once it gets a new one for the same pubkey.
  /// -  1: text_note: the content is set to the text content of a note (anything the user wants to say). Non-plaintext notes should instead use kind 1000-10000 as described in NIP-16.
  /// -  2: recommend_server: the content is set to the URL (e.g., wss://somerelay.com) of a relay the event creator wants to recommend to its followers.
  late int kind;

  /// The tags array can store a tag identifier as the first element of each subarray, plus arbitrary information afterward (always as strings).
  ///
  /// This NIP defines "p" — meaning "pubkey", which points to a pubkey of someone that is referred to in the event —, and "e" — meaning "event", which points to the id of an event this event is quoting, replying to or referring to somehow.
  late List<List<String>> tags;

  /// arbitrary string
  String content = "";

  /// 64-bytes signature of the sha256 hash of the serialized event data, which is the same as the "id" field
  late String sig;

  /// subscription_id is a random string that should be used to represent a subscription.
  String? subscriptionId;

  /// innerEvent is a kind14 event in sealed DM protocol, see NIP24
  Event? innerEvent;

  /// Default constructor
  ///
  /// verify: ensure your event isValid() –> id, signature, timestamp
  ///
  ///```dart
  /// String id =
  ///     "4b697394206581b03ca5222b37449a9cdca1741b122d78defc177444e2536f49";
  /// String pubKey =
  ///     "981cc2078af05b62ee1f98cff325aac755bf5c5836a265c254447b5933c6223b";
  /// int createdAt = 1672175320;
  /// int kind = 1;
  /// List<List<String>> tags = [];
  /// String content = "Ceci est une analyse du websocket";
  /// String sig =
  ///     "797c47bef50eff748b8af0f38edcb390facf664b2367d72eb71c50b5f37bc83c4ae9cc9007e8489f5f63c66a66e101fd1515d0a846385953f5f837efb9afe885";
  ///
  /// Event event = Event(
  ///   id,
  ///   pubKey,
  ///   createdAt,
  ///   kind,
  ///   tags,
  ///   content,
  ///   sig,
  ///   verify: true,
  ///   subscriptionId: null,
  /// );
  ///```
  Event(
    this.id,
    this.pubkey,
    this.createdAt,
    this.kind,
    this.tags,
    this.content,
    this.sig, {
    this.subscriptionId,
    bool verify = true,
  }) {
    pubkey = pubkey.toLowerCase();
  }

  /// Partial constructor, you have to fill the fields yourself
  ///
  /// verify: ensure your event isValid() –> id, signature, timestamp
  ///
  /// ```dart
  /// var partialEvent = Event.partial();
  /// assert(partialEvent.isValid() == false);
  /// partialEvent.createdAt = currentUnixTimestampSeconds();
  /// partialEvent.pubkey =
  ///     "981cc2078af05b62ee1f98cff325aac755bf5c5836a265c254447b5933c6223b";
  /// partialEvent.id = partialEvent.getEventId();
  /// partialEvent.sig = partialEvent.getSignature(
  ///   "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12",
  /// );
  /// assert(partialEvent.isValid() == true);
  /// ```
  factory Event.partial({
    id = "",
    pubkey = "",
    createdAt = 0,
    kind = 1,
    tags = const <List<String>>[],
    content = "",
    sig = "",
    subscriptionId,
    bool verify = false,
  }) {
    return Event(
      id,
      pubkey,
      createdAt,
      kind,
      tags,
      content,
      sig,
      verify: verify,
    );
  }

  /// Instantiate Event object from the minimum available data
  ///
  /// ```dart
  ///Event event = Event.from(
  ///  kind: 1,
  ///  tags: [],
  ///  content: "",
  ///  privkey:
  ///      "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12",
  ///);
  ///```
  static Future<Event> from({
    int createdAt = 0,
    required int kind,
    required List<List<String>> tags,
    required String content,
    required String pubkey,
    required String privkey,
    String? subscriptionId,
    bool verify = false,
  }) async {
    if (createdAt == 0) createdAt = currentUnixTimestampSeconds();
    pubkey = pubkey.toLowerCase();

    final id = processEventId(
      pubkey,
      createdAt,
      kind,
      tags,
      content,
    );

    final sig = processSignature(
      privkey,
      id,
    );

    Event event = Event(
      id,
      pubkey,
      createdAt,
      kind,
      tags,
      content,
      sig,
      subscriptionId: subscriptionId,
      verify: verify,
    );

    if (SignerHelper.needSigner(privkey)) {
      return await SignerHelper.signEvent(event, pubkey, privkey) ?? event;
    }
    return event;
  }

  /// Deserialize an event from a JSON
  ///
  /// verify: enable/disable events checks
  ///
  /// This option adds event checks such as id, signature, non-futuristic event: default=True
  ///
  /// Performances could be a reason to disable event checks
  static Future<Event> fromJson(Map<String, dynamic> json,
      {bool verify = true}) async {
    var tags = (json['tags'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e.toString()).toList())
        .toList();
    Event event = Event(
      json['id'],
      json['pubkey'],
      json['created_at'],
      json['kind'],
      tags,
      json['content'],
      json['sig'] ?? '',
      verify: verify,
    );
    if (verify) assert(await event.isValid() == true);
    return event;
  }

  /// Serialize an event in JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'pubkey': pubkey,
        'created_at': createdAt,
        'kind': kind,
        'tags': tags,
        'content': content,
        'sig': sig
      };

  /// Serialize to nostr event message
  /// - ["EVENT", event JSON as defined above]
  /// - ["EVENT", subscription_id, event JSON as defined above]
  String serialize() {
    if (subscriptionId != null) {
      return jsonEncode(["EVENT", subscriptionId, toJson()]);
    } else {
      return jsonEncode(["EVENT", toJson()]);
    }
  }

  /// Deserialize a nostr event message
  /// - ["EVENT", event JSON as defined above]
  /// - ["EVENT", subscription_id, event JSON as defined above]
  /// ```dart
  /// Event event = Event.deserialize([
  ///   "EVENT",
  ///   {
  ///     "id": "67bd60e47d7fdddadebff890143167bcd7b5d28b2c3008eae40e0ac5ba0e6b34",
  ///     "kind": 1,
  ///     "pubkey":
  ///         "36685fa5106b1bc03ae7bea82eded855d8f56c41db4c8bdef8099e1e0f2b2afa",
  ///     "created_at": 1674403511,
  ///     "content":
  ///         "Block 773103 was just confirmed. The total value of all the non-coinbase outputs was 61,549,183,849 sats, or \$14,025,828",
  ///     "tags": [],
  ///     "sig":
  ///         "4912a6850a711a876fd2443771f69e094041f7e832df65646a75c2c77989480cce9b41aa5ea3d055c16fe5beb7d11d3d5fa29b4c4046c150b09393c4d3d16eb4"
  ///   }
  /// ]);
  /// ```
  static Future<Event> deserialize(input, {bool verify = true}) async {
    Map<String, dynamic> json = {};
    String? subscriptionId;
    if (input.length == 2) {
      json = input[1] as Map<String, dynamic>;
    } else if (input.length == 3) {
      json = input[2] as Map<String, dynamic>;
      subscriptionId = input[1] as String;
    } else {
      throw Exception('invalid input');
    }

    var tags = (json['tags'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
        .toList();

    Event event = Event(
      json['id'],
      json['pubkey'],
      json['created_at'],
      json['kind'],
      tags,
      json['content'],
      json['sig'],
      subscriptionId: subscriptionId,
      verify: verify,
    );
    if (verify) assert(await event.isValid() == true);
    return event;
  }

  /// To obtain the event.id, we sha256 the serialized event.
  /// The serialization is done over the UTF-8 JSON-serialized string (with no white space or line breaks) of the following structure:
  ///
  ///[
  ///  0,
  ///  <pubkey, as a (lowercase) hex string>,
  ///  <created_at, as a number>,
  ///  <kind, as a number>,
  ///  <tags, as an array of arrays of non-null strings>,
  ///  <content, as a string>
  ///]
  String getEventId() {
    // Included for minimum breaking changes
    return processEventId(
      pubkey,
      createdAt,
      kind,
      tags,
      content,
    );
  }

  // Support for [getEventId]
  static String processEventId(
    String pubkey,
    int createdAt,
    int kind,
    List<List<String>> tags,
    String content,
  ) {
    List data = [0, pubkey.toLowerCase(), createdAt, kind, tags, content];
    String serializedEvent = json.encode(data);
    Uint8List hash = SHA256Digest()
        .process(Uint8List.fromList(utf8.encode(serializedEvent)));
    return hex.encode(hash);
  }

  /// Each user has a keypair. Signatures, public key, and encodings are done according to the Schnorr signatures standard for the curve secp256k1
  /// 64-bytes signature of the sha256 hash of the serialized event data, which is the same as the "id" field
  String getSignature(String privateKey) {
    return processSignature(privateKey, id);
  }

  // Support for [getSignature]
  static String processSignature(
    String privateKey,
    String id,
  ) {
    if (SignerHelper.needSigner(privateKey)) return '';

    /// aux must be 32-bytes random bytes, generated at signature time.
    /// https://github.com/nbd-wtf/dart-bip340/blob/master/lib/src/bip340.dart#L10
    String aux = generate64RandomHexChars();
    return bip340.sign(privateKey, id, aux);
  }

  /// Verify if event checks such as id, signature, non-futuristic are valid
  /// Performances could be a reason to disable event checks
  Future<bool> isValid() async {
    String verifyId = getEventId();
    if (createdAt.toString().length == 10 && id == verifyId) {
      if (Platform.isAndroid || Platform.isIOS)
        return ChannelCryptoTool.verifySignature(pubkey, id, sig);
      else
        return bip340.verify(pubkey, id, sig);
    } else {
      return false;
    }
  }
}
