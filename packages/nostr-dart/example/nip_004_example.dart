import 'package:nostr_core_dart/nostr.dart';

void main() async {
  var sender = Keychain.generate();
  print(sender.private);
  var receiver = Keychain.generate();
  print(receiver.public);
  Event event =
      Nip4.encode(receiver.public, "content", "", sender.private);
  print(event.content);

  EDMessage edMessage = Nip4.decode(event, receiver.public, receiver.private);
  print(edMessage.content);
}
