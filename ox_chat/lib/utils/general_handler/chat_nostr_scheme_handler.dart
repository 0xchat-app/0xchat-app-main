import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/model/option_model.dart';
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
      return await eventIdToMessageContent(tempMap?['channelId'], nostrScheme,
          tempMap?['relays'].cast<String>(), tempMap?['kind']);
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
      UserDBISAR? userDB = await Account.sharedInstance.getUserInfo(pubkey);
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

  static Future<String?> eventIdToMessageContent(String? eventId,
      String nostrScheme, List<String>? relays, int? kind) async {
    if (eventId == null) return null;
    Event? event;
    if (kind == null) {
      if (Channels.sharedInstance.channels.containsKey(eventId))
        kind = 40;
      else if (Moment.sharedInstance.notesCache.containsKey(eventId))
        kind = 1;
      else if (RelayGroup.sharedInstance.groups.containsKey(eventId))
        kind = 39000;
      else {
        event = await Account.loadEvent(eventId, relays: relays);
        kind = event?.kind;
      }
    }
    if (kind == null) return null;
    switch (kind) {
      case 40:
        if (Channels.sharedInstance.channels.containsKey(eventId)) {
          return channelToMessageContent(
              Channels.sharedInstance.channels[eventId]);
        } else if (event != null) {
          Channel channel = Nip28.getChannelCreation(event);
          ChannelDB channelDB =
              Channels.sharedInstance.getChannelDBFromChannel(channel);
          return channelToMessageContent(channelDB);
        }
        break;
      case 1:
        NoteDB? noteDB = await Moment.sharedInstance
            .loadNoteWithNoteId(eventId, relays: relays);
        if (noteDB != null) return await noteToMessageContent(noteDB);
        break;
      case 30023:
        if (event != null) {
          LongFormContent? longFormContent = Nip23.decode(event);
          return await longFormContentToMessageContent(
              longFormContent, nostrScheme);
        }
        break;
      case 39000:
        if (RelayGroup.sharedInstance.groups.containsKey(eventId)) {
          RelayGroupDB? relayGroupDB =
              RelayGroup.sharedInstance.groups[eventId];
          return relayGroupDBToMessageContent(relayGroupDB);
        } else if (relays != null && relays.isNotEmpty) {
          RelayGroupDB? relayGroupDB = await RelayGroup.sharedInstance
              .getGroupMetadataFromRelay(eventId, relay: relays.first);
          if (relayGroupDB != null)
            return relayGroupDBToMessageContent(relayGroupDB);
        }
        break;
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

  static String? userToMessageContent(UserDBISAR? userDB, String nostrScheme) {
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

  static String? relayGroupDBToMessageContent(RelayGroupDB? groupDB) {
    String link = CustomURIHelper.createModuleActionURI(
      module: 'ox_chat',
      action: 'groupSharePage',
      params: {
        'groupId': groupDB?.groupId ?? '',
        'groupName': groupDB?.name ?? '',
        'groupPic': groupDB?.picture ?? '',
        'groupOwner': groupDB?.author ?? '',
        'groupTypeIndex': groupDB == null || !groupDB.closed
            ? GroupType.openGroup.index
            : GroupType.closeGroup.index,
      },
    );

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

  static Future<String?> noteToMessageContent(NoteDB? noteDB) async {
    if (noteDB == null) return null;
    UserDBISAR? userDB = await Account.sharedInstance.getUserInfo(noteDB.author);
    if (userDB?.lastUpdatedTime == 0) {
      userDB =
          await Account.sharedInstance.reloadProfileFromRelay(noteDB.author);
    }
    ;

    // String resultString = nostrScheme.replaceFirst('nostr:', "");
    // final url = '${CommonConstant.njumpURL}${resultString}';
    String link =
        await OXDiscoveryInterface.getJumpMomentPageUri(noteDB.noteId);
    Map<String, dynamic> map = {};
    map['type'] = '4';
    map['content'] = {
      'authorIcon': '${userDB?.picture}',
      'authorName': '${userDB?.name}',
      'authorDNS': '${userDB?.dns}',
      'createTime': '${noteDB.createAt}',
      'note': '${noteDB.content}',
      'image': '${_extractFirstImageUrl(noteDB.content)}',
      'link': link,
    };
    return jsonEncode(map);
  }

  static Future<String?> longFormContentToMessageContent(
      LongFormContent? longFormContent, String nostrScheme) async {
    if (longFormContent == null) return null;
    UserDBISAR? userDB =
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
