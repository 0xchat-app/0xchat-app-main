// import 'package:nostr_core_dart/nostr.dart';
// import 'package:test/test.dart';

// void main() {
//   group('EncryptedDirectMessage', () {
//     test('EncryptedDirectMessage.newEvent', () {
//       // DM from bob to alice
//       String bobPubKey =
//           "2d38a56c4303bc722370c50c86fc8dd3327f06a8fe59b3ff3d670738d71dd1e1";
//       String alicePubKey =
//           "0f76c800a7ea76b83a3ae87de94c6046b98311bda8885cedd8420885b50de181";
//       String bobPrivKey =
//           "826ef0e93c1278bd89945377fadb6b6b51d9eedf74ecdb64a96f1897bb670be8";
//       String plaintext = "vi veri universum vivus vici";
//       List<List<String>> tags = [
//         ["p", alicePubKey]
//       ];

//       EncryptedDirectMessage event =
//           EncryptedDirectMessage.newEvent(alicePubKey, plaintext, bobPrivKey);

//       expect(event.peerPubkey, alicePubKey);
//       expect(event.plaintext, plaintext);
//       expect(event.pubkey, bobPubKey);
//       expect(event.kind, 4);
//       expect(event.tags, tags);
//       expect(event.subscriptionId, null);
//     });
//   });
//   test('Encrypted DM Receive', () {
//     String bobPubKey =
//         "2d38a56c4303bc722370c50c86fc8dd3327f06a8fe59b3ff3d670738d71dd1e1";
//     String alicePubKey =
//         "0f76c800a7ea76b83a3ae87de94c6046b98311bda8885cedd8420885b50de181";
//     String bobPrivKey =
//         "826ef0e93c1278bd89945377fadb6b6b51d9eedf74ecdb64a96f1897bb670be8";
//     String json =
//         '["EVENT", "181555e0fec2139d27ac80a5a46801415394e61d67be7f626631760dc5997bc0", {"id": "2739cccdc3fa943ad447378e234ef1325a76f023a169b483b6fe8cab47a793e1", "pubkey": "0f76c800a7ea76b83a3ae87de94c6046b98311bda8885cedd8420885b50de181", "created_at": 1680475069, "kind": 4, "tags": [["p", "2d38a56c4303bc722370c50c86fc8dd3327f06a8fe59b3ff3d670738d71dd1e1"]], "content": "hH1HlQWY3dz7IzJlgnEgW1WNtA0KlvGgo/OC4mep/R4I6PMqJuvZ35j4OFHkMvqb?iv=jbkXPH2esn5DIP3BodpsTQ==", "sig": "ba2d80d8be4612e8438447d38373e9b014b28172d49b7b6afeff462bc25bd4edc69c6e2c145dde052de54f47f4e36d74151fad3d08d21e3cad9563edc64adcca"}]';

//     //FIXME: Ask the contributor for the secret key of this test or to do a new test with a random secret key
//     // String tempPrivateKey = userPrivateKey; // from settings.dart
//     // userPrivateKey = bobPrivKey;
//     // userPrivateKey = tempPrivateKey;

//     Message m = Message.deserialize(json);
//     Event event = m.message;
//     expect(event.id,
//         "2739cccdc3fa943ad447378e234ef1325a76f023a169b483b6fe8cab47a793e1");
//     expect(event.pubkey, alicePubKey);
//     expect(event.createdAt, 1680475069);
//     expect(event.kind, 4);
//     expect(event.tags, [
//       ["p", bobPubKey]
//     ]);
//     expect(event.content, "Secret message from alice to bob!");
//     expect(event.sig,
//         "ba2d80d8be4612e8438447d38373e9b014b28172d49b7b6afeff462bc25bd4edc69c6e2c145dde052de54f47f4e36d74151fad3d08d21e3cad9563edc64adcca");
//     expect(event.subscriptionId,
//         "181555e0fec2139d27ac80a5a46801415394e61d67be7f626631760dc5997bc0");
//   });
// }
