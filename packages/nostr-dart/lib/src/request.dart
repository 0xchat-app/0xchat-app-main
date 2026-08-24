import 'dart:convert';
import 'package:nostr_core_dart/src/filter.dart';

/// Used to request events and subscribe to new updates.
class Request {
  /// subscription_id is a random string that should be used to represent a subscription.
  late String subscriptionId;

  /// filters is a JSON object that determines what events will be sent in that subscription
  late List<Filter> filters;

  Request(this.subscriptionId, this.filters);

  /// Serialize to nostr request message
  /// - ["REQ", subscription_id, filter JSON, filter JSON, ...]
  String serialize() {
    var theFilters = jsonEncode(filters.map((item) => item.toJson()).toList());
    var header = jsonEncode(["REQ", subscriptionId]);
    return '${header.substring(0, header.length - 1)},${theFilters.substring(1, theFilters.length)}';
  }

  /// Deserialize a nostr request message
  /// - ["REQ", subscription_id, filter JSON, filter JSON, ...]
  Request.deserialize(input) {
    assert(input.length >= 3);
    subscriptionId = input[1];
    filters = [];
    for (var i = 2; i < input.length; i++) {
      filters.add(Filter.fromJson(input[i]));
    }
  }
}
