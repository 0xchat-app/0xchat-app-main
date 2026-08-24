import 'package:nostr_core_dart/nostr.dart';

/// This NIP defines how to do WebRTC communication over nostr.
/// https://github.com/jacany/nips/blob/webrtc/100.md
///
enum SignalingState {
  disconnect,
  offer,
  answer,
  candidate,
}

class Signaling {
  String sender;
  String receiver;
  String content;
  SignalingState state;
  String? offerId;
  String? groupid;  

  Signaling(this.sender, this.receiver, this.content, this.state, this.offerId, this.groupid);
}

class Nip100 {
  static Future<Event> close(
      String friend, String content, String offerId, String pubkey, String privkey,
      {String? groupid}) async {
    List<List<String>> tags = [];
    tags.add(['type', 'disconnect']);
    tags.add(['p', friend]);
    tags.add(['e', offerId]);
    if (groupid != null) {
      tags.add(['h', groupid]);
    }
    return await Event.from(
        kind: 25050, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
  }

  static Future<Event> offer(String friend, String content, String offerId, String pubkey, String privkey,
      {String? groupid}) async {
    List<List<String>> tags = [];
    tags.add(['type', 'offer']);
    tags.add(['p', friend]);
    tags.add(['e', offerId]);
    if (groupid != null) {
      tags.add(['h', groupid]);
    }
    return await Event.from(
        kind: 25050, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
  }

  static Future<Event> answer(
      String friend, String content, String offerId, String pubkey, String privkey,
      {String? groupid}) async {
    List<List<String>> tags = [];
    tags.add(['type', 'answer']);
    tags.add(['p', friend]);
    tags.add(['e', offerId]);
    if (groupid != null) {
      tags.add(['h', groupid]);
    }
    return await Event.from(
        kind: 25050, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
  }

  static Future<Event> candidate(
      String friend, String content, String offerId, String pubkey, String privkey,
      {String? groupid}) async {
    List<List<String>> tags = [];
    tags.add(['type', 'candidate']);
    tags.add(['p', friend]);
    tags.add(['e', offerId]);
    if (groupid != null) {
      tags.add(['h', groupid]);
    }
    return await Event.from(
        kind: 25050, tags: tags, content: content, pubkey: pubkey, privkey: privkey);
  }

  static Signaling decode(Event event, String pubkey) {
    if (event.kind == 25050) {
      String? type, friend, offerId, groupid;
      for (var tag in event.tags) {
        if (tag[0] == "p") friend = tag[1];
        if (tag[0] == "type") type = tag[1];
        if (tag[0] == "e") offerId = tag[1];
        if (tag[0] == "h") groupid = tag[1];
      }
      offerId ??= event.id;
      if (friend != null && friend == pubkey) {
        try {
          return Signaling(
              event.pubkey, friend, event.content, typeToState(type!), offerId, groupid);
        } catch (e) {
          throw Exception(e);
        }
      } else {
        throw Exception("${event.kind} is not valid p2p calling event");
      }
    }
    throw Exception("${event.kind} is not nip100 compatible");
  }

  static SignalingState typeToState(String type) {
    switch (type) {
      case 'disconnect':
        return SignalingState.disconnect;
      case 'offer':
        return SignalingState.offer;
      case 'answer':
        return SignalingState.answer;
      case 'candidate':
        return SignalingState.candidate;
      default:
        throw Exception('not valid type');
    }
  }
}
