import 'dart:convert';

import 'package:bip340/bip340.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:test/test.dart';

void main() {
  group('Event', () {
    test('Default constructor', () {
      String id =
          "4b697394206581b03ca5222b37449a9cdca1741b122d78defc177444e2536f49";
      String pubKey =
          "981cc2078af05b62ee1f98cff325aac755bf5c5836a265c254447b5933c6223b";
      int createdAt = 1672175320;
      int kind = 1;
      List<List<String>> tags = [];
      String content = "Ceci est une analyse du websocket";
      String sig =
          "797c47bef50eff748b8af0f38edcb390facf664b2367d72eb71c50b5f37bc83c4ae9cc9007e8489f5f63c66a66e101fd1515d0a846385953f5f837efb9afe885";

      Event event = Event(
        id,
        pubKey,
        createdAt,
        kind,
        tags,
        content,
        sig,
        verify: true,
        subscriptionId: null,
      );

      expect(event.id, id);
      expect(event.pubkey, pubKey);
      expect(event.createdAt, createdAt);
      expect(event.kind, kind);
      expect(event.tags, tags);
      expect(event.content, content);
      expect(event.sig, sig);
      expect(event.subscriptionId, null);
    });

    test('Constructor.from', () {
      int createdAt = 1672175320;
      int kind = 1;
      List<List<String>> tags = [];
      String content = "Ceci est une analyse du websocket";
      String privkey =
          "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12";

      Event event = Event.from(
        createdAt: createdAt,
        kind: kind,
        tags: tags,
        content: content,
        privkey: privkey,
      );

      expect(
        event.id,
        "4b697394206581b03ca5222b37449a9cdca1741b122d78defc177444e2536f49",
      );
      expect(
        event.pubkey,
        "981cc2078af05b62ee1f98cff325aac755bf5c5836a265c254447b5933c6223b",
      );
      expect(event.createdAt, createdAt);
      expect(event.kind, kind);
      expect(event.tags, tags);
      expect(event.content, content);
      expect(verify(event.pubkey, event.id, event.sig), true);
    });

    test('Constructor.from generated createdAt', () {
      Event event = Event.from(
        kind: 1,
        tags: [],
        content: "",
        privkey:
            "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12",
      );
      expect(event.createdAt != 0, isTrue);
    });

    test('Constructor.fromJson', () {
      var json = {
        "kind": 1,
        "pubkey":
            "0ba0206887bd61579bf65ec09d7806bea32c64be1cf2c978cf031a811cd238db",
        "content": "dart-nostr",
        "tags": [],
        "created_at": 1672477962,
        "sig":
            "246970954e7b74e7fe381a4c818fed739ee59444cb536dadf45fbbce33bd7455ae7cd678c347c4a0c6e0a4483d18c7e26b7abe76f4cc73234f774e0e0d65204b",
        "id": "047663d895d56aefa3f528935c7ce7dc8939eb721a0ec76ef2e558a8257955d2"
      };
      Event event = Event.fromJson(json);
      expect(event.id, json['id']);
      expect(event.pubkey, json['pubkey']);
      expect(event.createdAt, json['created_at']);
      expect(event.kind, json['kind']);
      expect(event.tags, json['tags']);
      expect(event.content, json['content']);
      expect(event.sig, json['sig']);
    });

    test('Constructor.toJson', () {
      Map<String, dynamic> json = jsonDecode(
          '{"id":"f9b8c5b7a8692b0f5b8ca9f2c29ff84d6baa5a60d14cbf1c54bd2bb77ee8b41f","kind":1,"pubkey":"891b945271cd3c65dc22cb9e77ba08f5cd165ad8d9fba370b740f7db95f98b10","created_at":1675015139,"content":"Authorize just this time...I have commitment issues.","tags":[["e","343ed9c6ca7a0a8f33f8cfed04b6cea4a4dda50a649daffaf85d6410507c5c7c","wss://relay.damus.io","reply"],["p","7b6461d02c6f0be1cacdcf968c4246105a2db51c7770993bf8bb25e59cedffa7"]],"sig":"bd63b762379bd06e536ccb943f909f075bd512315fbf2407be19f03ee9d3ef5b4a70205aa7a8e68cb8c2d250f56ef8f5074339abd741d32dbd18d16641a339ef"}');
      Event event = Event.fromJson(json);
      Map<String, dynamic> toJson = event.toJson();
      expect(toJson, json);
    });
  });

  test('Constructor.serialize', () {
    var serialized = [
      "EVENT",
      {
        "id":
            "047663d895d56aefa3f528935c7ce7dc8939eb721a0ec76ef2e558a8257955d2",
        "pubkey":
            "0ba0206887bd61579bf65ec09d7806bea32c64be1cf2c978cf031a811cd238db",
        "created_at": 1672477962,
        "kind": 1,
        "tags": [],
        "content": "dart-nostr",
        "sig":
            "246970954e7b74e7fe381a4c818fed739ee59444cb536dadf45fbbce33bd7455ae7cd678c347c4a0c6e0a4483d18c7e26b7abe76f4cc73234f774e0e0d65204b",
      }
    ];
    var serializedWithSubscriptionId = [
      "EVENT",
      "subscription_id",
      {
        "id":
            "047663d895d56aefa3f528935c7ce7dc8939eb721a0ec76ef2e558a8257955d2",
        "pubkey":
            "0ba0206887bd61579bf65ec09d7806bea32c64be1cf2c978cf031a811cd238db",
        "created_at": 1672477962,
        "kind": 1,
        "tags": [],
        "content": "dart-nostr",
        "sig":
            "246970954e7b74e7fe381a4c818fed739ee59444cb536dadf45fbbce33bd7455ae7cd678c347c4a0c6e0a4483d18c7e26b7abe76f4cc73234f774e0e0d65204b",
      }
    ];

    Event event = Event.fromJson(serialized[1] as Map<String, dynamic>);
    expect(event.serialize(), jsonEncode(serialized));
    Event eventWithSubscriptionId =
        Event.deserialize(serializedWithSubscriptionId);
    expect(
      eventWithSubscriptionId.serialize(),
      jsonEncode(serializedWithSubscriptionId),
    );
  });

  test('Constructor.deserialize', () {
    var serialized = [
      "EVENT",
      "0954524188078879",
      {
        "id":
            "f9b8c5b7a8692b0f5b8ca9f2c29ff84d6baa5a60d14cbf1c54bd2bb77ee8b41f",
        "kind": 1,
        "pubkey":
            "891b945271cd3c65dc22cb9e77ba08f5cd165ad8d9fba370b740f7db95f98b10",
        "created_at": 1675015139,
        "content": "Authorize just this time...I have commitment issues.",
        "tags": [
          [
            "e",
            "343ed9c6ca7a0a8f33f8cfed04b6cea4a4dda50a649daffaf85d6410507c5c7c",
            "wss://relay.damus.io",
            "reply"
          ],
          [
            "p",
            "7b6461d02c6f0be1cacdcf968c4246105a2db51c7770993bf8bb25e59cedffa7"
          ]
        ],
        "sig":
            "bd63b762379bd06e536ccb943f909f075bd512315fbf2407be19f03ee9d3ef5b4a70205aa7a8e68cb8c2d250f56ef8f5074339abd741d32dbd18d16641a339ef"
      }
    ];
    Event event = Event.deserialize(serialized);
    expect(event.subscriptionId, serialized[1]);
    var json = serialized[2] as Map<String, dynamic>;
    expect(event.id, json['id']);
    expect(event.pubkey, json['pubkey']);
    expect(event.createdAt, json['created_at']);
    expect(event.kind, json['kind']);
    expect(event.tags, json['tags']);
    expect(event.content, json['content']);
    expect(event.sig, json['sig']);

    var serializeWithoutSubscriptionId = [
      "EVENT",
      {
        "id":
            "67bd60e47d7fdddadebff890143167bcd7b5d28b2c3008eae40e0ac5ba0e6b34",
        "kind": 1,
        "pubkey":
            "36685fa5106b1bc03ae7bea82eded855d8f56c41db4c8bdef8099e1e0f2b2afa",
        "created_at": 1674403511,
        "content":
            "Block 773103 was just confirmed. The total value of all the non-coinbase outputs was 61,549,183,849 sats, or \$14,025,828",
        "tags": [],
        "sig":
            "4912a6850a711a876fd2443771f69e094041f7e832df65646a75c2c77989480cce9b41aa5ea3d055c16fe5beb7d11d3d5fa29b4c4046c150b09393c4d3d16eb4"
      }
    ];
    Event eventWithoutSubscriptionId =
        Event.deserialize(serializeWithoutSubscriptionId);
    expect(eventWithoutSubscriptionId.subscriptionId, null);
  });

  test('Fake event (verify=false) with empty tag', () {
    var json = jsonDecode(
      '{"kind": 1, "pubkey":"0ba0206887bd61579bf65ec09d7806bea32c64be1cf2c978cf031a811cd238db","content": "dart-nostr","tags": [["p","052acd328f1c1d48e86fff3e34ada4bfc60578116f4f68f296602530529656a2",""]],"created_at": 1672477962,"sig":"246970954e7b74e7fe381a4c818fed739ee59444cb536dadf45fbbce33bd7455ae7cd678c347c4a0c6e0a4483d18c7e26b7abe76f4cc73234f774e0e0d65204b","id": "047663d895d56aefa3f528935c7ce7dc8939eb721a0ec76ef2e558a8257955d2"}',
    );
    Event event = Event.fromJson(json, verify: false);
    expect(event.tags[0][2], equals(""));
  });

  test('Event.deserialize throw', () {
    Event event = Event(
        '92025e05149429f8fdfd88269aa21aaeefed1d4e5bec7c4ce9cff386c55a7639',
        'c773d875158d367b9aadfc61de320ca2dfbbbc506519741c2aaf466135bd549f',
        1685609904,
        10100,
        [
          [
            "p",
            "8257bec205ae33441a3c231a21ebec3e19781cafa65c9d5f72e4e1e2333da85e"
          ]
        ],
        'ZfGX4zApxAHr7ia0kML27NoFWn54cG05SnX0ybBz9MG7LJN87xIBqIt7BhG/310sVdCvfVcgJcSIGq4d0JyqJ8QMP5UFQvHigfwxQ+if6fMSA7ToxyAsjCdhzOqwLUn5nn41bHnW1XihCbKG8Vcs7BGTej2zgIHZgIf1vjykVhZnZ3SEfBbwObed3ZWbVoyc3gQeHqk0WQ1CTtC3nD4xFUG6/5LhGqq6UYNThS78417MuuanK9GivlCdBbjG2u3OdEx7tqxqjZiL8PL6xXZnw38//8MfKiDpLGIoN/N+aXMxImLKZskpJmxjZUnPLDwy6oBT3wbJF6L3hUhV7kCYArh0FmqHT6RibExSHZ3vwWUzUEjYPFLIHD94WOgzu12TQ7s/4mRFwXoAQBwmxOi9th0rST4cckv4luqKCiJ6LsQ=?iv=f59jD5q26UIvJhlfKbGglA==',
        'cf30c50dbdd719b0e89250d94253fed7b27bf0a1178c846a32f867f6bca36743da68ad2b5e2a0375639d57becba7cc70ea850f5f4da42fde06941ac6816260');
    expect(event.isValid(), true);
  });

  test('Event.partial', () {
    var emptyEvent = Event.partial();
    expect(emptyEvent.isValid(), false);
    emptyEvent.createdAt = currentUnixTimestampSeconds();
    emptyEvent.pubkey =
        "981cc2078af05b62ee1f98cff325aac755bf5c5836a265c254447b5933c6223b";
    emptyEvent.id = emptyEvent.getEventId();
    emptyEvent.sig = emptyEvent.getSignature(
      "5ee1c8000ab28edd64d74a7d951ac2dd559814887b1b9e1ac7c5f89e96125c12",
    );
    expect(emptyEvent.isValid(), true);
  });
}
