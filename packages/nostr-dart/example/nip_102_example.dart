import 'dart:convert';

import 'package:nostr_core_dart/nostr.dart';

void main() async {
  var sender = Keychain.generate();
  var member1 = Keychain.generate();
  var member2 = Keychain.generate();

  Event event = Nip102.metadata(sender.public, 'groupName test', [member1.public, member2.public], sender.public, sender.private, pinned: ['pin messages1', 'pin messages2'], relays: ['relay1', 'relay2']);
  GroupMetadata groupMetadata = Nip102.getMetadata(event);
  print('${groupMetadata.groupKey}, ${groupMetadata.members.toList()}, ${groupMetadata.owner},  ${groupMetadata.pinned?.toList()},  ${groupMetadata.relays?.toList()}');

  Event event2 = Nip102.request(sender.public, 'request to join', sender.private);
  GroupActions groupActions = Nip102.getActions(event2);
  print('${groupActions.groupKey}, ${groupActions.state}, ${groupActions.content}');

  Event event3 = Nip102.message(sender.public, 'group message', 'replyId', sender.private);
  EDMessage edMessage = Nip102.getMessage(event3);
  print('${edMessage.content}, ${edMessage.sender}, ${edMessage.receiver}');
}