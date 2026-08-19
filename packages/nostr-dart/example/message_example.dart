import 'package:nostr_core_dart/nostr.dart';

void main() async {
  var eventPayload =
      '["EVENT","3979053091133091",{"id":"a60679692533b308f1d862c2a5ca5c08a304e5157b1df5cde0ff0454b9920605","pubkey":"7c579328cf9028a4548d5117afa4f8448fb510ca9023f576b7bc90fc5be6ce7e","created_at":1674405882,"kind":1,"tags":[],"content":"GM gm gm! Currently bathing my brain in coffee âï¸  hahaha. How many other nostrinos love coffee? ð¤ªð¤","sig":"10262aa6a83e0b744cda2097f06f7354357512b82846f6ef23ef7d997136b64815c343b613a0635a27da7e628c96ac2475f66dd72513c1fb8ce6560824eb25b8"}]';
  var event = Message.deserialize(eventPayload);
  assert(event.type == "EVENT");
  assert(event.message.id ==
      "a60679692533b308f1d862c2a5ca5c08a304e5157b1df5cde0ff0454b9920605");

  String requestPayload =
      '["REQ","22055752544101437",{"kinds":[0,1,2,7],"since":1674320733,"limit":450}]';
  var req = Message.deserialize(requestPayload);
  assert(req.type == "REQ");
  assert(req.message.filters[0].limit == 450);

  String closePayload = '["CLOSE","anyrandomstring"]';
  var close = Message.deserialize(closePayload);
  assert(close.type == "CLOSE");
  assert(close.message.subscriptionId == "anyrandomstring");

  String noticePayload =
      '["NOTICE", "restricted: we can\'t serve DMs to unauthenticated users, does your client implement NIP-42?"]';
  var notice = Message.deserialize(noticePayload);
  assert(notice.type == "NOTICE");

  String eosePayload = '["EOSE", "random"]';
  var eose = Message.deserialize(eosePayload);
  assert(eose.type == "EOSE");

  String okPayload =
      '["OK", "b1a649ebe8b435ec71d3784793f3bbf4b93e64e17568a741aecd4c7ddeafce30", true, ""]';
  var ok = Message.deserialize(okPayload);
  assert(ok.type == "OK");
}
