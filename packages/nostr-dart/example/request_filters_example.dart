import 'dart:io';
import 'package:nostr_core_dart/nostr.dart';

void main() async {
// Create a subscription message request with one or many filters
  Request requestWithFilter = Request(generate64RandomHexChars(), [
    Filter(
      kinds: [0, 1, 2, 7],
      since: 1674063680,
      limit: 450,
    )
  ]);

  // Connecting to a nostr relay using websocket
  WebSocket webSocket = await WebSocket.connect(
    'wss://relay.nostr.info', // or any nostr relay
  );
  // if the current socket fail try another one
  // wss://nostr.sandwich.farm
  // wss://relay.damus.io

  // Send a request message to the WebSocket server
  webSocket.add(requestWithFilter.serialize());

  // Listen for events from the WebSocket server
  await Future.delayed(Duration(seconds: 1));
  webSocket.listen((event) {
    print('Received event: $event');
  });

  // Close the WebSocket connection
  await webSocket.close();
}
