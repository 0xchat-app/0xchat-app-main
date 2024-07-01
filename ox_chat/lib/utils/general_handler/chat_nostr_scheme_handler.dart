import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_common/business_interface/ox_discovery/interface.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';

class ChatNostrSchemeHandle {
  static String? getNostrScheme(String content) {
    final regexNostr =
        r'^(?:\s+)?(nostr:)?(npub|note|nprofile|nevent|nrelay|naddr)[0-9a-zA-Z]{8,}(?=\s*$)';
    final urlRegexp = RegExp(regexNostr);
    final match = urlRegexp.firstMatch(content);
    return match?[0];
  }

  static Future<String?> tryDecodeNostrScheme(String content) async {
    String? nostrScheme = getNostrScheme(content);
    if (nostrScheme == null)
      return null;
    else if (nostrScheme.startsWith('nostr:nprofile') ||
        nostrScheme.startsWith('nprofile') ||
        nostrScheme.startsWith('npub')) {
      final tempMap = Account.decodeProfile(content);
      return await pubkeyToMessageContent(tempMap?['pubkey'], nostrScheme);
    } else if (nostrScheme.startsWith('nostr:note') ||
        nostrScheme.startsWith('nostr:nevent') ||
        nostrScheme.startsWith('nevent') ||
        nostrScheme.startsWith('note')) {
      final tempMap = Channels.decodeChannel(content);
      return await eventIdToMessageContent(
          tempMap?['channelId'], nostrScheme, tempMap?['relays']);
    } else if (nostrScheme.startsWith('nostr:naddr') ||
        nostrScheme.startsWith('naddr')) {
      if (nostrScheme.startsWith('nostr:')) {
        nostrScheme = Nip21.decode(nostrScheme)!;
      }
      Map result = Nip19.decodeShareableEntity(nostrScheme);
      return await addressToMessageContent(
          result['special'], result['author'], nostrScheme);
    }
    return null;
  }

  static Future<String?> pubkeyToMessageContent(
      String? pubkey, String nostrScheme) async {
    if (pubkey != null) {
      UserDB? userDB = await Account.sharedInstance.getUserInfo(pubkey);
      if (userDB?.lastUpdatedTime == 0) {
        userDB = await Account.sharedInstance.reloadProfileFromRelay(pubkey);
      }
      return userToMessageContent(userDB, nostrScheme);
    }
    return null;
  }

  static Future<ChannelDB> _loadChannelOnline(Channel channel) async {
    ChannelDB? channelDB = await Channels.sharedInstance
        .updateChannelMetadataFromRelay(channel.owner, channel.channelId);
    return channelDB ?? ChannelDB(channelId: channel.channelId);
  }

  static Future<String?> addressToMessageContent(
      String? d, String? pubkey, String nostrScheme) async {
    if (d == null || pubkey == null) return null;
    Event? event = await Account.loadAddress(d, pubkey);
    if (event != null) {
      switch (event.kind) {
        case 30023:
          LongFormContent? longFormContent = Nip23.decode(event);
          return await longFormContentToMessageContent(
              longFormContent, nostrScheme);
      }
    }
    return null;
  }

  static Future<String?> eventIdToMessageContent(
      String? eventId, String nostrScheme, List<String>? relays) async {
    if (eventId != null) {
      // check local group id
      GroupDB? groupDB = Groups.sharedInstance.groups[eventId];
      if (groupDB != null) return groupDBToMessageContent(groupDB);
      // check local channel id
      ChannelDB? channelDB = Channels.sharedInstance.channels[eventId];
      if (channelDB != null) return channelToMessageContent(channelDB);
      // check local moment
      NoteDB? noteDB = Moment.sharedInstance.notesCache[eventId];
      noteDB ??= await Moment.sharedInstance.loadNoteFromDBWithNoteId(eventId);
      if (noteDB != null) {
        Note note = Note(noteDB.noteId, noteDB.author, noteDB.createAt, null,
            noteDB.content, null, '', '');
        return await noteToMessageContent(note);
      }

      // check online
      Event? event = await Account.loadEvent(eventId, relays: relays);
      if (event != null) {
        switch (event.kind) {
          case 1:
            Note? note = Nip1.decodeNote(event);
            return await noteToMessageContent(note);
          case 30023:
            LongFormContent? longFormContent = Nip23.decode(event);
            return await longFormContentToMessageContent(
                longFormContent, nostrScheme);
          case 40:
            Channel channel = Nip28.getChannelCreation(event);
            ChannelDB channelDB = await _loadChannelOnline(channel);
            return await channelToMessageContent(channelDB);
          case 41:
            Channel channel = Nip28.getChannelMetadata(event);
            ChannelDB channelDB =
                Channels.sharedInstance.getChannelDBFromChannel(channel);
            return await channelToMessageContent(channelDB);
        }
      }
    }
    return null;
  }

  static String blankToMessageContent() {
    Map<String, dynamic> map = {};
    map['type'] = '3';
    map['content'] = {
      'title': 'Loading...',
      'content': 'Loading...',
      'icon': '',
      'link': ''
    };
    return jsonEncode(map);
  }

  static String? userToMessageContent(UserDB? userDB, String nostrScheme) {
    String link = CustomURIHelper.createModuleActionURI(
        module: 'ox_chat',
        action: 'contactUserInfoPage',
        params: {'pubkey': userDB?.pubKey});
    Map<String, dynamic> map = {};
    map['type'] = '3';
    map['content'] = {
      'title': '${userDB?.name}',
      'content': '${userDB?.about}',
      'icon': '${userDB?.picture}',
      'link': link
    };
    return jsonEncode(map);
  }

  static String channelToMessageContent(ChannelDB? channelDB) {
    String link = CustomURIHelper.createModuleActionURI(
        module: 'ox_chat',
        action: 'contactChanneDetailsPage',
        params: {'channelId': channelDB?.channelId ?? ''});
    Map<String, dynamic> map = {};
    map['type'] = '3';
    map['content'] = {
      'title': '${channelDB?.name}',
      'content': '${channelDB?.about}',
      'icon': '${channelDB?.picture}',
      'link': link
    };
    return jsonEncode(map);
  }

  static String? groupDBToMessageContent(GroupDB? groupDB) {
    String link = CustomURIHelper.createModuleActionURI(
        module: 'ox_chat',
        action: 'groupInfoPage',
        params: {'groupId': groupDB?.groupId ?? ''});

    Map<String, dynamic> map = {};
    map['type'] = '3';
    map['content'] = {
      'title': '${groupDB?.name}',
      'content': '${groupDB?.about}',
      'icon': '${groupDB?.picture}',
      'link': link
    };
    return jsonEncode(map);
  }

  static Future<String?> noteToMessageContent(Note? note) async {
    if (note == null) return null;
    UserDB? userDB = await Account.sharedInstance.getUserInfo(note.pubkey);
    if (userDB?.lastUpdatedTime == 0) {
      userDB = await Account.sharedInstance.reloadProfileFromRelay(note.pubkey);
    }
    ;

    // String resultString = nostrScheme.replaceFirst('nostr:', "");
    // final url = '${CommonConstant.njumpURL}${resultString}';
    String link = await OXDiscoveryInterface.getJumpMomentPageUri(note.nodeId);
    Map<String, dynamic> map = {};
    map['type'] = '4';
    map['content'] = {
      'authorIcon': '${userDB?.picture}',
      'authorName': '${userDB?.name}',
      'authorDNS': '${userDB?.dns}',
      'createTime': '${note.createdAt}',
      'note': '${note.content}',
      'image': '${_extractFirstImageUrl(note.content)}',
      'link': link,
    };
    return jsonEncode(map);
  }

  static Future<String?> longFormContentToMessageContent(
      LongFormContent? longFormContent, String nostrScheme) async {
    if (longFormContent == null) return null;
    UserDB? userDB =
        await Account.sharedInstance.getUserInfo(longFormContent.pubkey);
    if (userDB?.lastUpdatedTime == 0) {
      userDB = await Account.sharedInstance
          .reloadProfileFromRelay(longFormContent.pubkey);
    }
    ;

    String resultString = nostrScheme.replaceFirst('nostr:', "");
    final url = '${CommonConstant.njumpURL}${resultString}';
    String link = CustomURIHelper.createModuleActionURI(
        module: 'ox_chat', action: 'commonWebview', params: {'url': url});

    String note = '';
    if (longFormContent.title != null)
      note = '$note${longFormContent.title}\n\n';
    if (longFormContent.hashtags?.isNotEmpty == true) {
      for (int i = 0; i < longFormContent.hashtags!.length; i++) {
        String hashtag = longFormContent.hashtags![i];
        hashtag = hashtag.replaceAll(' ', '_');
        if (i == 0) {
          note = '$note#$hashtag';
        } else {
          note = '$note #$hashtag';
        }
      }
      note = '$note\n\n';
    }
    note = '$note${longFormContent.summary ?? longFormContent.content}';

    Map<String, dynamic> map = {};
    map['type'] = '4';
    map['content'] = {
      'authorIcon': '${userDB?.picture}',
      'authorName': '${userDB?.name}',
      'authorDNS': '${userDB?.dns}',
      'createTime':
          '${longFormContent.publishedAt ?? longFormContent.createAt}',
      'note': note,
      'image':
          '${longFormContent.image ?? _extractFirstImageUrl(longFormContent.content)}',
      'link': link,
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
