import 'package:nostr_core_dart/nostr.dart';

Future<void> main() async {
  var sender = Keychain.generate();
  var receiver = Keychain.generate();
  var random = Keychain.generate();
  Event realEvent = await Nip44.encode(receiver.public, "sljdk", '', sender.private);

  print(realEvent.toJson());

  Event wrapEvent = await Nip59.encode(realEvent, receiver.public);

  print(wrapEvent.toJson());

  Event decodeEvent = await Nip59.decode(wrapEvent, receiver.private);

  print('decodeEvent: ${decodeEvent.toJson()}' );

  EDMessage message = await Nip44.decode(decodeEvent, receiver.public, receiver.private);

  print(message.content);
}