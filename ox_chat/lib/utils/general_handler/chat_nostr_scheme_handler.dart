import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

class ChatNostrSchemeHandle {
  static String? getNostrScheme(String content) {
    final regexNostr =
        r'nostr:(npub|nsec|note|nprofile|nevent|nrelay|naddr)[0-9a-zA-Z]{8,}(?=\s|$)';
    final urlRegexp = RegExp(regexNostr, caseSensitive: false);
    final match = urlRegexp.firstMatch(content);
    return match?[0];
  }

  static Future<String?> tryDecodeNostrScheme(String content) async {
    String? nostrScheme = getNostrScheme(content);
    if(nostrScheme == null) return null;
    else if(nostrScheme.startsWith('nostr:npub') || nostrScheme.startsWith('nostr:nprofile')){
      final tempMap = Account.decodeProfile(content);
      return await pubkeyToMessageContent(tempMap?['pubkey']);
    }
    else if(nostrScheme.startsWith('nostr:note') || nostrScheme.startsWith('nostr:nevent')){
      final tempMap = Channels.decodeChannel(content);
      return await eventIdToMessageContent(tempMap?['channelId']);
    }
    return null;
  }

  static Future<String?> pubkeyToMessageContent(String? pubkey) async {
    if (pubkey != null) {
      UserDB? userDB = await Account.sharedInstance.getUserInfo(pubkey);
      return userToMessageContent(userDB);
    }
    return null;
  }

  static Future<String?> eventIdToMessageContent(String? eventId) async {
    if (eventId != null) {
      // check local group id
      GroupDB? groupDB = Groups.sharedInstance.groups[eventId];
      if (groupDB != null) return groupDBToMessageContent(groupDB);
      // check local channel id
      ChannelDB? channelDB = Channels.sharedInstance.channels[eventId];
      if (channelDB != null) return channelToMessageContent(channelDB);
      // check online
      Event? event = await Account.loadEvent(eventId);
      if (event != null) {
        switch (event.kind) {
          case 1:
            Note? note = Nip1.decodeNote(event);
            return noteToMessageContent(note);
          case 40:
            Channel channel = Nip28.getChannelCreation(event);
            ChannelDB channelDB = Channels.channelToChannelDB(channel);
            return channelToMessageContent(channelDB);
          case 41:
            Channel channel = Nip28.getChannelMetadata(event);
            ChannelDB channelDB = Channels.channelToChannelDB(channel);
            return channelToMessageContent(channelDB);
        }
      }
    }
    return null;
  }

  static Future<String?> userToMessageContent(UserDB? userDB) async {
    Map<String, dynamic> map = {};
    map['type'] = '3';
    map['content'] = {
      'title': '${userDB?.name}',
      'content': '${userDB?.about}',
      'icon': '${userDB?.picture}',
      'link': ''
    };
    return jsonEncode(map);
  }

  static Future<String?> channelToMessageContent(ChannelDB? channelDB) async {
    Map<String, dynamic> map = {};
    map['type'] = '3';
    map['content'] = {
      'title': '${channelDB?.name}',
      'content': '${channelDB?.about}',
      'icon': '${channelDB?.picture}',
      'link': ''
    };
    return jsonEncode(map);
  }

  static Future<String?> groupDBToMessageContent(GroupDB? groupDB) async {
    Map<String, dynamic> map = {};
    map['type'] = '3';
    map['content'] = {
      'title': '${groupDB?.name}',
      'content': '${groupDB?.about}',
      'icon': '${groupDB?.picture}',
      'link': ''
    };
    return jsonEncode(map);
  }

  static Future<String?> noteToMessageContent(Note? note) async {
    UserDB? userDB = await Account.sharedInstance.getUserInfo(note!.pubkey);
    Map<String, dynamic> map = {};
    map['type'] = '4';
    map['content'] = {
      'authorIcon': '${userDB?.picture}',
      'authorName': '${userDB?.name}',
      'authorDNS': '${userDB?.dns}',
      'createTime': '${note.createAt}',
      'note': '${note.content}',
      'image': '${_extractFirstImageUrl(note.content)}',
      'link': '',
    };
    return jsonEncode(map);
  }

  static String _extractFirstImageUrl(String text) {
    RegExp regExp = RegExp(r'(http[s]?:\/\/.*\.(?:png|jpg|gif|jpeg))');
    RegExpMatch? match = regExp.firstMatch(text);
    if (match != null) {
      return match.group(0) ?? '';
    }
    return '';
  }
}
