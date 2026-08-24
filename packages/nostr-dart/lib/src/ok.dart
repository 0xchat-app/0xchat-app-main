import 'dart:convert';

class OKEvent {
  late String eventId;
  late bool status;
  late String message;

  /// Default constructor
  OKEvent(this.eventId, this.status, this.message);

  String serialize() {
    return jsonEncode(["OK", eventId, status, message]);
  }

  /// Deserialize a nostr ok message
  /// - ["OK", eventId, true, '']
  OKEvent.deserialize(input) {
    assert(input.length >= 4);
    eventId = input[1];
    status = input[2];
    message = input[3];
  }
}
