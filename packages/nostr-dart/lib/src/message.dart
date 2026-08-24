import 'dart:convert';

import 'package:nostr_core_dart/nostr.dart';

// Used to deserialize any kind of message that a nostr client or relay can transmit.
class Message {
  late String type;
  late dynamic message;

// nostr message deserializer
  static Future<Message> deserialize(String payload) async {
    Message m = Message();
    dynamic data = jsonDecode(payload);
    var messages = ["EVENT", "REQ", "CLOSE", "CLOSED", "NOTICE", "NOTIFY", "EOSE", "OK", "AUTH"];
    assert(messages.contains(data[0]), "Unsupported payload (or NIP) : $data");

    m.type = data[0];
    switch (m.type) {
      case "OK":
        m.message = OKEvent.deserialize(data);
        break;
      case "EVENT":
        m.message = await Event.deserialize(data, verify: false);
        break;
      case "REQ":
        m.message = Request.deserialize(data);
        break;
      case "CLOSE":
        m.message = Close.deserialize(data);
        break;
      case "CLOSED":
        m.message = Closed.deserialize(data);
        break;
      case "AUTH":
        m.message = Auth.deserialize(data);
        break;
      default:
        m.message = jsonEncode(data.sublist(1));
        break;
    }
    return m;
  }
}
