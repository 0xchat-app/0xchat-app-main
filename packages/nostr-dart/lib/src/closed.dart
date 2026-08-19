import 'dart:convert';

/// used to indicate that a subscription was ended on the server side
class Closed {
  /// subscription_id is a random string that should be used to represent a subscription.
  late String subscriptionId;

  late String message;

  /// Default constructor
  Closed(this.subscriptionId);

  /// Serialize to nostr close message
  /// - ["CLOSED", subscription_id, message]
  String serialize() {
    return jsonEncode(["CLOSED", subscriptionId, message]);
  }

  /// Deserialize a nostr close message
  /// - ["CLOSED", subscription_id, message]
  Closed.deserialize(input) {
    assert(input.length >= 3);
    subscriptionId = input[1];
    message = input[2];
  }
}
