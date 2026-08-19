import 'package:nostr_core_dart/nostr.dart';

void main() async {
  String subscriptionId = generate64RandomHexChars();
  var close1 = Close(subscriptionId);
  assert(close1.subscriptionId == subscriptionId);

  var close2 = Close(subscriptionId);
  assert(close2.serialize() == '["CLOSE","$subscriptionId"]');

  var close3 = Close.deserialize(["CLOSE", subscriptionId]);
  assert(close3.subscriptionId == subscriptionId);
}
