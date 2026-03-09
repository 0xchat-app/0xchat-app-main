import 'dart:async';
import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';

typedef ChannelsUpdatedCallBack = void Function();
typedef ChannelMessageCallBack = void Function(MessageDBISAR);
typedef ChannelMessageUpdateCallBack = void Function(MessageDBISAR, String);
typedef OfflineChannelMessageFinishCallBack = void Function();
typedef ChannelsSearchCallBack = void Function(List<ChannelDBISAR>);

class Channels {
  /// singleton
  Channels._internal();
  factory Channels() => sharedInstance;
  static final Channels sharedInstance = Channels._internal();

  static final String identifier = 'Chat-Channels';
  // {relay1:subscriptionID1, relay2:subscriptionID2, ...}
  String channelMessageSubscription = '';

  // memory storage
  String pubkey = '';
  String privkey = '';
  Map<String, ValueNotifier<ChannelDBISAR>> channels = {};
  Map<String, ValueNotifier<ChannelDBISAR>> myChannels = {};
  int maxLimit = 500;

  ChannelsUpdatedCallBack? myChannelsUpdatedCallBack;
  ChannelMessageCallBack? channelMessageCallBack;
  ChannelMessageUpdateCallBack? channelMessageUpdateCallBack;
  OfflineChannelMessageFinishCallBack? offlineChannelMessageFinishCallBack;
  Map<String, bool> offlineChannelMessageFinish = {};

  Future<void> init({ChannelsUpdatedCallBack? callBack}) async {
    privkey = Account.sharedInstance.currentPrivkey;
    pubkey = Account.sharedInstance.currentPubkey;
    myChannelsUpdatedCallBack = callBack;

    Account.sharedInstance.channelListUpdateCallback = () async {
      myChannels = _myChannels();
      _updateSubscriptions();
      myChannelsUpdatedCallBack?.call();
    };
    // subscript friend requests
    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) async {
      if (status == 1 &&
          Account.sharedInstance.me != null &&
          relayKinds.contains(RelayKind.general)) {
        _updateSubscriptions(relay: relay);
        updateChannelMetadataFromRelay('', myChannels.keys.toList(), relays: [relay]);
      }
    });
    await _loadAllChannelsFromDB();
    updateChannelMetadataFromRelay('', myChannels.keys.toList());
    _updateSubscriptions();
  }

  Future<void> _loadAllChannelsFromDB() async {
    final isar = DBISAR.sharedInstance.isar;
    List<Object?> maps = await isar.channelDBISARs.where().findAll();
    channels = {for (var channelDB in maps) (channelDB as ChannelDBISAR).channelId: ValueNotifier(channelDB)};
    myChannels = _myChannels();
    myChannelsUpdatedCallBack?.call();
  }

  void _updateChannelSubscription({String? relay}) {
    if (myChannels.isEmpty) {
      offlineChannelMessageFinishCallBack?.call();
      if (!Messages.sharedInstance.channelMessageCompleter.isCompleted) {
        Messages.sharedInstance.channelMessageCompleter.complete();
      }
      return;
    }
    if (channelMessageSubscription.isNotEmpty) {
      Connect.sharedInstance.closeRequests(channelMessageSubscription, relay: relay);
    }

    Map<String, List<Filter>> subscriptions = {};

    if (relay == null) {
      for (String relayURL in Connect.sharedInstance.relays()) {
        int channelMessageUntil = Relays.sharedInstance.getChannelMessageUntil(relayURL);
        Filter f = Filter(
            e: myChannels.keys.toList(),
            kinds: [42],
            limit: maxLimit,
            since: (channelMessageUntil + 1));
        subscriptions[relayURL] = [f];
      }
    } else {
      int channelMessageUntil = Relays.sharedInstance.getChannelMessageUntil(relay);
      Filter f = Filter(
          e: myChannels.keys.toList(),
          kinds: [42],
          limit: maxLimit,
          since: (channelMessageUntil + 1));
      subscriptions[relay] = [f];
    }

    channelMessageSubscription = Connect.sharedInstance.addSubscriptions(subscriptions,
        closeSubscription: false, eventCallBack: (event, relay) async {
      switch (event.kind) {
        case 42:
          _receiveChannelMessages(event, relay);
          break;
        default:
          LogUtils.v(() => 'channel unhandled message ${event.toJson()}');
          break;
      }
    }, eoseCallBack: (requestId, ok, relay, unCompletedRelays) {
      offlineChannelMessageFinish[relay] = true;
      if (ok.status) {
        _updateChannelMessageTime(currentUnixTimestampSeconds() - 1, relay);
      }
      if (unCompletedRelays.isEmpty) {
        offlineChannelMessageFinishCallBack?.call();
        if (!Messages.sharedInstance.channelMessageCompleter.isCompleted) {
          Messages.sharedInstance.channelMessageCompleter.complete();
        }
      }
    });
  }

  Future<bool> _checkBlockedList(String user) async {
    return Contacts.sharedInstance.inBlockList(user);
  }

  Future<void> handleMuteUser(String user) async {
    UserDBISAR? me = Account.sharedInstance.me;
    if (me!.blockedList != null && me.blockedList!.contains(user) == false) {
      me.blockedList!.add(user);
    }
    await Account.sharedInstance.syncMe();
  }

  Future<void> _receiveChannelMessages(Event event, String relay) async {
    ChannelMessage channelMessage = Nip28.getChannelMessage(event);
    if (await _checkBlockedList(channelMessage.sender)) return;
    MessageDBISAR messageDB = MessageDBISAR(
        messageId: event.id,
        sender: channelMessage.sender,
        receiver: '',
        groupId: channelMessage.channelId,
        kind: event.kind,
        tags: jsonEncode(event.tags),
        content: event.content,
        replyId: channelMessage.thread.reply?.eventId ?? '',
        createTime: event.createdAt,
        plaintEvent: jsonEncode(event),
        chatType: 2);
    var map = await MessageDBISAR.decodeContent(channelMessage.content);
    messageDB.decryptContent = map['content'];
    messageDB.type = map['contentType'];

    _updateChannelMessageTime(event.createdAt, relay);

    await Messages.saveMessageToDB(messageDB);
    channelMessageCallBack?.call(messageDB);
  }

  void _updateChannelMessageTime(int eventTime, String relay) {
    /// set channelMessageUntil channelMessageSince
    if (Relays.sharedInstance.relays.containsKey(relay)) {
      Relays.sharedInstance.setChannelMessageUntil(eventTime, relay);
      Relays.sharedInstance.setChannelMessageSince(eventTime, relay);
    } else {
      Relays.sharedInstance.relays[relay] =
          RelayDBISAR(url: relay, channelMessageUntil: eventTime, channelMessageSince: eventTime);
    }
    if (offlineChannelMessageFinish[relay] == true) {
      Relays.sharedInstance.syncRelaysToDB(r: relay);
    }
  }

  Map<String, ValueNotifier<ChannelDBISAR>> _myChannels() {
    Map<String, ValueNotifier<ChannelDBISAR>> result = {};
    UserDBISAR? me = Account.sharedInstance.me;
    if (me != null && me.channelsList != null && me.channelsList!.isNotEmpty) {
      List<String> channelList = me.channelsList!;
      for (String channelId in channelList) {
        if (channels.containsKey(channelId)) {
          result[channelId] = channels[channelId]!;
        } else {
          ChannelDBISAR channelDB = ChannelDBISAR(channelId: channelId);
          channelDB.name = channelDB.shortChannelId;
          channels[channelId] = ValueNotifier(channelDB);
          result[channelId] = channels[channelId]!;
        }
      }
    }
    return result;
  }

  static ChannelDBISAR channelToChannelDB(Channel channel) {
    return ChannelDBISAR(
        channelId: channel.channelId,
        creator: channel.owner,
        name: channel.name,
        about: channel.about,
        picture: channel.picture);
  }

  ChannelDBISAR getChannelDBFromChannel(Channel channel) {
    ChannelDBISAR? channelDB = channels[channel.channelId]?.value;
    if (channelDB == null) {
      channelDB = ChannelDBISAR(
          channelId: channel.channelId,
          creator: channel.owner,
          name: channel.name,
          about: channel.about,
          picture: channel.picture);
      if (channel.createdAt > 0) channelDB.createTime = channel.createdAt;
      if (channel.updatedAt > 0) channelDB.updateTime = channel.updatedAt;
      channels[channel.channelId] = ValueNotifier(channelDB);
    } else {
      if (channel.createdAt > 0) channelDB.createTime = channel.createdAt;
      if (channel.updatedAt >= channelDB.updateTime) {
        channelDB.updateTime = channel.updatedAt;
        channelDB.creator = channel.owner;
        channelDB.name = channel.name;
        channelDB.about = channel.about;
        channelDB.picture = channel.picture;
        channelDB.relayURL = channel.relay;
      }
    }
    return channelDB;
  }

  Future<void> syncChannelsCreationFromRelay(List<String> channelIds, List<String>? relays) async {
    Completer<void> completer = Completer<void>();
    Filter f = Filter(
      ids: channelIds,
    );
    await Connect.sharedInstance.connectRelays(relays ?? [], relayKind: RelayKind.temp);
    Connect.sharedInstance.addSubscription([f], relays: relays,
        eventCallBack: (event, relay) async {
      Channel? channel;
      if (event.kind == 40) channel = Nip28.getChannelCreation(event);
      if (event.kind == 41) channel = Nip28.getChannelMetadata(event);
      if (channel != null) {
        ChannelDBISAR channelDB = getChannelDBFromChannel(channel);
        _syncChannelToDB(channelDB);
      }
    }, eoseCallBack: (requestId, ok, relay, unRelays) {
      if (unRelays.isEmpty && !completer.isCompleted) {
        completer.complete();
        Connect.sharedInstance.closeTempConnects(relays ?? []);
      }
    });
    return completer.future;
  }

  Future<void> syncChannelsMetadataFromRelay(List<String> channelIds, List<String>? relays) async {
    Completer<void> completer = Completer<void>();
    Filter f = Filter(
      ids: channelIds,
      kinds: [41],
    );
    await Connect.sharedInstance.connectRelays(relays ?? [], relayKind: RelayKind.temp);
    Connect.sharedInstance.addSubscription([f], relays: relays, eventCallBack: (event, relay) {
      if (channels.containsKey(event.id) && channels[event.id]!.value.updateTime < event.createdAt) {
        Channel channel = Nip28.getChannelMetadata(event);
        ChannelDBISAR channelDB = getChannelDBFromChannel(channel);
        _syncChannelToDB(channelDB);
      }
    }, eoseCallBack: (requestId, ok, relay, unRelays) {
      if (unRelays.isEmpty && !completer.isCompleted) {
        completer.complete();
        Connect.sharedInstance.closeTempConnects(relays ?? []);
      }
    });
    return completer.future;
  }

  void _setChannel(ChannelDBISAR channelDB){
    if (channels.containsKey(channelDB.channelId)) {
      channels[channelDB.channelId]?.value = channelDB;
    }
    else{
      channels[channelDB.channelId] = ValueNotifier(channelDB);
    }
    if (myChannels.containsKey(channelDB.channelId)) {
      myChannels[channelDB.channelId]?.value = channelDB;
    }
  }

  Future<void> _syncChannelToDB(ChannelDBISAR channelDB) async {
    _setChannel(channelDB);
    await DBISAR.sharedInstance.saveToDB(channelDB);
  }

  Future<void> _syncMyChannelListToDB() async {
    List<String> list = myChannels.keys.toList();
    UserDBISAR? me = Account.sharedInstance.me;
    me!.channelsList = list;
    await Account.sharedInstance.syncMe();
  }

  Future<void> _syncMyChannelListToRelay({OKCallBack? callBack}) async {
    List<String> list = myChannels.keys.toList();
    Event event = await Nip51.createPublicChatList([], list, privkey, pubkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (OKEvent ok, String relay) {
      if (ok.status) {
        Account.sharedInstance.me!.lastChannelsListUpdatedTime = event.createdAt;
        _syncMyChannelListToDB();
      }
      callBack?.call(ok, relay);
    });
  }

  void _loadChannelPreMessages(String channelId, int until, int limit) {
    loadChannelMessages(channelId, null, until, limit);
  }

  void loadChannelMessages(String channelId, int? since, int? until, int? limit) {
    Filter f = Filter(e: [channelId], kinds: [42], limit: limit, until: until, since: since);
    Connect.sharedInstance.addSubscription([f], eventCallBack: (event, relay) async {
      switch (event.kind) {
        case 42:
          _receiveChannelMessages(event, relay);
          break;
        default:
          LogUtils.v(() => 'unhandled message $event');
          break;
      }
    });
  }

  Future<void> _updateSubscriptions({String? relay}) async {
    if (relay != null && !Connect.sharedInstance.relays().contains(relay)) {
      return;
    }
    _updateChannelSubscription(relay: relay);
  }

  Future<ChannelDBISAR?> createChannel(
      String name, String about, String picture, List<String> badges, String relay,
      {OKCallBack? callBack}) async {
    Completer<ChannelDBISAR?> completer = Completer<ChannelDBISAR?>();
    Map<String, String> additional = {'badges': jsonEncode(badges)};
    Event event = await Nip28.createChannel(name, about, picture, additional, pubkey, privkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) async {
      if (ok.status == true) {
        // update channel
        ChannelDBISAR channelDB = ChannelDBISAR(
          channelId: event.id,
          createTime: event.createdAt,
          creator: pubkey,
          name: name,
          about: about,
          picture: picture,
          badges: jsonEncode(badges),
          relayURL: relay,
        );
        channelDB.channelId = event.id;
        channelDB.creator = pubkey;
        channelDB.createTime = event.createdAt;
        var channel = ValueNotifier(channelDB);
        channels[channelDB.channelId] = channel;
        myChannels[channelDB.channelId] = channel;
        _updateChannelSubscription();
        await _syncChannelToDB(channelDB);
        // update my channel list
        await _syncMyChannelListToRelay();
        myChannelsUpdatedCallBack?.call();
        if (!completer.isCompleted) completer.complete(channelDB);
      } else {
        if (!completer.isCompleted) completer.complete(null);
      }
    });

    return completer.future;
  }

  Future<ChannelDBISAR?> updateChannelMetadataFromRelay(String owner, List<String> channelIds,
      {List<String>? relays}) async {
    Completer<ChannelDBISAR?> completer = Completer<ChannelDBISAR?>();
    Filter f1 = Filter(
      authors: owner.isNotEmpty ? [owner] : null,
      kinds: [41],
      e: channelIds,
    );
    Filter f2 = Filter(
      ids: channelIds,
    );
    if (relays != null) {
      await Connect.sharedInstance.connectRelays(relays, relayKind: RelayKind.temp);
    }
    Connect.sharedInstance.addSubscription([f1, f2], relays: relays, eventCallBack: (event, relay) {
      Channel? channel;
      if (event.kind == 40) channel = Nip28.getChannelCreation(event);
      if (event.kind == 41) channel = Nip28.getChannelMetadata(event);
      if(channel != null){
        ChannelDBISAR channelDB = getChannelDBFromChannel(channel);
        _syncChannelToDB(channelDB);
        if (!completer.isCompleted) completer.complete(channelDB);
      }
    }, eoseCallBack: (requestId, ok, relay, unRelays) {
      if (unRelays.isEmpty && !completer.isCompleted) completer.complete(null);
    });
    return completer.future;
  }

  Future<void> syncMyChannelsFromRelay({String? relay}) async {
    var channelIds = Account.sharedInstance.me!.channelsList ?? [];
    List<String> unknownChannels = [];
    List<String> keys = List.from(channels.keys.toList());
    for (var channelId in channelIds) {
      if (!keys.contains(channelId) || channels[channelId]?.value.createTime == 0) {
        unknownChannels.add(channelId);
        ChannelDBISAR channelDB = ChannelDBISAR(channelId: channelId);
        channelDB.name = channelDB.shortChannelId;
        var channel = ValueNotifier(channelDB);
        channels[channelId] = channel;
        myChannels[channelId] = channel;
      }
    }
    if (unknownChannels.isEmpty) return;
    await syncChannelsCreationFromRelay(unknownChannels, relay == null ? null : [relay]);
    await syncChannelsMetadataFromRelay(unknownChannels, relay == null ? null : [relay]);

    myChannelsUpdatedCallBack?.call();
  }

  Future<OKEvent> setChannel(ChannelDBISAR channelDB, {OKCallBack? callBack}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event = await Nip28.setChannelMetaData(
        channelDB.name!,
        channelDB.about!,
        channelDB.picture!,
        null,
        null,
        channelDB.badges!.isNotEmpty ? {'badges': channelDB.badges!} : null,
        channelDB.channelId,
        channelDB.relayURL!,
        pubkey,
        privkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) async {
      if (ok.status) {
        await _syncChannelToDB(channelDB);
      }
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  Future<Event?> getSendChannelMessageEvent(String channelId, MessageType type, String content,
      {String? source,
      String? channelRelay,
      String? replyMessage,
      String? replyMessageRelay,
      String? replyUser,
      String? replyUserRelay,
      String? decryptSecret}) async {
    Event event = await Nip28.sendChannelMessage(
        channelId, MessageDBISAR.getContent(type, content, source), pubkey, privkey,
        channelRelay: channelRelay,
        replyMessage: replyMessage,
        replyMessageRelay: replyMessageRelay,
        replyUser: replyUser,
        replyUserRelay: replyUserRelay,
        subContent: MessageDBISAR.getSubContent(type, content));
    return event;
  }

  Future<OKEvent> sendChannelMessage(String channelId, MessageType type, String content,
      {String? source,
      String? channelRelay,
      String? replyMessage,
      String? replyMessageRelay,
      String? replyUser,
      String? replyUserRelay,
      Event? event,
      bool local = false,
      String? decryptSecret,
      String? replaceMessageId}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    event ??= await Nip28.sendChannelMessage(
        channelId, MessageDBISAR.getContent(type, content, source), pubkey, privkey,
        channelRelay: channelRelay,
        replyMessage: replyMessage,
        replyMessageRelay: replyMessageRelay,
        replyUser: replyUser,
        replyUserRelay: replyUserRelay,
        subContent: MessageDBISAR.getSubContent(type, content));

    late MessageDBISAR messageDB;
    if (replaceMessageId != null) {
      final replaceMessageDB = await Messages.sharedInstance.loadMessageDBFromDB(replaceMessageId);
      if (replaceMessageDB == null) {
        return Future.value(OKEvent(
          event.innerEvent?.id ?? event.id,
          false,
          'The message to be replaced was not found',
        ));
      }
      replaceMessageDB.messageId = event.id;
      replaceMessageDB.content = event.content;
      messageDB = replaceMessageDB;
    } else {
      messageDB = MessageDBISAR(
          messageId: event.id,
          sender: event.pubkey,
          receiver: '',
          groupId: channelId,
          kind: event.kind,
          tags: jsonEncode(event.tags),
          replyId: replyMessage ?? '',
          content: event.content,
          decryptContent: content,
          type: MessageDBISAR.messageTypeToString(type),
          createTime: event.createdAt,
          status: 0,
          plaintEvent: jsonEncode(event),
          chatType: 2);
    }
    var map =
        await MessageDBISAR.decodeContent(MessageDBISAR.getSubContent(type, content) ?? content);
    messageDB.decryptContent = map['content'];
    messageDB.type = map['contentType'];

    if (replaceMessageId != null) {
      channelMessageUpdateCallBack?.call(messageDB, replaceMessageId);
    } else {
      channelMessageCallBack?.call(messageDB);
    }

    await Messages.saveMessageToDB(messageDB);

    if (local) {
      if (!completer.isCompleted) {
        completer.complete(OKEvent(event.id, true, ''));
      }
    } else {
      Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) async {
        messageDB.status = ok.status ? 1 : 2;
        channelMessageUpdateCallBack?.call(messageDB, messageDB.messageId);
        await Messages.saveMessageToDB(messageDB, conflictAlgorithm: ConflictAlgorithm.replace);
        if (!completer.isCompleted) completer.complete(ok);
      });
    }

    return completer.future;
  }

  Future<OKEvent> hideMessage(String messageId, String reason, {OKCallBack? callBack}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    Messages.deleteMessagesFromDB(messageIds: [messageId]);
    Event event = await Nip28.hideChannelMessage(messageId, reason, pubkey, privkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  Future<OKEvent> muteUser(String userPubkey, String reason) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event = await Nip28.muteUser(userPubkey, reason, pubkey, privkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  Future<OKEvent> joinChannel(String channelId) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    if (channels[channelId] == null) {
      channels[channelId] = ValueNotifier(ChannelDBISAR(channelId: channelId));
    }
    myChannels[channelId] = channels[channelId]!;
    _loadChannelPreMessages(channelId, currentUnixTimestampSeconds(), 100);
    _updateChannelSubscription();
    _syncMyChannelListToRelay(callBack: (ok, relay) {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  Future<OKEvent> leaveChannel(String channelId) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    myChannels.remove(channelId);
    _updateChannelSubscription();
    _syncMyChannelListToRelay(callBack: (ok, relay) {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  List<ChannelDBISAR>? fuzzySearch(String keyword) {
    if (keyword.isNotEmpty) {
      RegExp regex = RegExp(keyword, caseSensitive: false);
      List<ChannelDBISAR> filteredChannels = channels.values
          .where((channel) => regex.hasMatch(channel.value.name!) || regex.hasMatch(channel.value.about!))
          .map((e) => e.value).toList();
      return filteredChannels;
    }
    return null;
  }

  ValueNotifier<ChannelDBISAR> getChannelNotifier(String channelId) {
    if (channels.containsKey(channelId)) return channels[channelId]!;
    channels[channelId] = ValueNotifier(ChannelDBISAR(channelId: channelId));
    return channels[channelId]!;
  }

  Future<ChannelDBISAR?> searchChannel(String channelId, List<String>? relays) async {
    if (channels[channelId] == null) {
      await syncChannelsCreationFromRelay([channelId], relays);
      await syncChannelsMetadataFromRelay([channelId], relays);
    }
    // print('searchChannel 333: ${channels[channelId]?.channelId}');
    return channels[channelId]?.value;
  }

  // get 20 latest channels
  Future<List<ChannelDBISAR>> searchChannelsFromRelay(
      {List<String>? channelIds, ChannelsSearchCallBack? searchCallBack}) async {
    Completer<List<ChannelDBISAR>> completer = Completer<List<ChannelDBISAR>>();

    Filter f =
        channelIds == null ? Filter(kinds: [40], limit: 20) : Filter(ids: channelIds, kinds: [40]);
    Map<String, ChannelDBISAR> result = {};
    for(var channel in channels.values){
      result[channel.value.channelId] = channel.value;
    }
    searchCallBack?.call(channels.values.map((e) => e.value).toList());
    Connect.sharedInstance.addSubscription([f], eventCallBack: (event, relay) async {
      Channel channel = Nip28.getChannelCreation(event);
      if (!channels.containsKey(channel.channelId)) {
        ChannelDBISAR channelDB = getChannelDBFromChannel(channel);
        _syncChannelToDB(channelDB);
        result[channel.channelId] = channelDB;
        searchCallBack?.call([channelDB]);
      }
    }, eoseCallBack: (requestId, status, relay, unRelays) async {
      if (unRelays.isEmpty) {
        if (!completer.isCompleted) completer.complete(result.values.toList());
        await Future.forEach(result.values, (channel) async {
          await updateChannelMetadataFromRelay(channel.creator, [channel.channelId]);
        });
      }
    });
    return completer.future;
  }

  Future<void> muteChannel(String channelId) async {
    _setMuteChannel(channelId, true);
  }

  Future<void> unMuteChannel(String channelId) async {
    _setMuteChannel(channelId, false);
  }

  List<String> getAllUnMuteChannels() {
    return myChannels.entries.where((e) => e.value.value.mute == false).map((e) => e.key).toList();
  }

  Future<void> _setMuteChannel(String channelId, bool mute) async {
    if (myChannels.containsKey(channelId)) {
      ChannelDBISAR channelDB = myChannels[channelId]!.value;
      channelDB.mute = mute;
      await _syncChannelToDB(channelDB);
    }
  }

  static String encodeChannel(String channelId, List<String>? relays, String? author) {
    String nevent = Nip19.encodeShareableEntity('nevent', channelId, relays, author, 40);
    return Nip21.encode(nevent);
  }

  static Map<String, dynamic>? decodeChannel(String encodedChannel) {
    if (encodedChannel.startsWith('nostr:')) {
      encodedChannel = Nip21.decode(encodedChannel)!;
    }
    if (encodedChannel.startsWith('nevent') || encodedChannel.startsWith('naddr')) {
      Map result = Nip19.decodeShareableEntity(encodedChannel);
      if (result['prefix'] == 'nevent' || result['prefix'] == 'naddr') {
        return {
          'channelId': result['special'],
          'relays': result['relays'],
          'author': result['author'],
          'kind': result['kind']
        };
      }
    } else if (encodedChannel.startsWith('note')) {
      return {
        'channelId': Nip19.decodeNote(encodedChannel),
        'relays': [],
        'author': null,
        'kind': 1
      };
    }
    return null;
  }
}
