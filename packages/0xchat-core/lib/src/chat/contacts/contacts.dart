import 'dart:async';
import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';

typedef SecretChatRequestCallBack = void Function(SecretSessionDBISAR);
typedef SecretChatAcceptCallBack = void Function(SecretSessionDBISAR);
typedef SecretChatRejectCallBack = void Function(SecretSessionDBISAR);
typedef SecretChatUpdateCallBack = void Function(SecretSessionDBISAR);
typedef SecretChatCloseCallBack = void Function(SecretSessionDBISAR);
typedef PrivateChatMessageCallBack = void Function(MessageDBISAR);
typedef PrivateChatMessageUpdateCallBack = void Function(MessageDBISAR, String);
typedef SecretChatMessageCallBack = void Function(MessageDBISAR);
typedef SecretChatMessageUpdateCallBack = void Function(MessageDBISAR, String);
typedef ContactUpdatedCallBack = void Function();
typedef OfflinePrivateMessageFinishCallBack = void Function();

enum CallMessageState { disconnect, offer, answer, reject, timeout, cancel, inCalling }

class CallMessage {
  String callId;
  String sender;
  String receiver;
  CallMessageState state;
  int start;
  int end;
  String media;

  CallMessage(
      this.callId, this.sender, this.receiver, this.state, this.start, this.end, this.media);
}

class Contacts {
  static final String identifier = 'Chat-Friends';
  static final String blockListidentifier = 'Chat-Block';

  /// singleton
  Contacts._internal();
  factory Contacts() => sharedInstance;
  static final Contacts sharedInstance = Contacts._internal();

  /// memory storage
  String pubkey = '';
  String privkey = '';
  Map<String, UserDBISAR> allContacts = {};
  Map<String, SecretSessionDBISAR> secretSessionMap = {};
  String secretSessionSubscription = '';
  String friendMessageSubscription = '';
  int lastFriendListUpdateTime = 0;
  List<String>? blockList;
  Map<String, CallMessage> callMessages = {};
  int maxLimit = 2048;
  int offset2 = 24 * 60 * 60 * 3;

  /// callbacks
  SecretChatRequestCallBack? secretChatRequestCallBack;
  SecretChatAcceptCallBack? secretChatAcceptCallBack;
  SecretChatRejectCallBack? secretChatRejectCallBack;
  SecretChatUpdateCallBack? secretChatUpdateCallBack;
  SecretChatCloseCallBack? secretChatCloseCallBack;
  SecretChatMessageCallBack? secretChatMessageCallBack;
  SecretChatMessageUpdateCallBack? secretChatMessageUpdateCallBack;
  PrivateChatMessageCallBack? privateChatMessageCallBack;
  PrivateChatMessageUpdateCallBack? privateChatMessageUpdateCallBack;
  ContactUpdatedCallBack? contactUpdatedCallBack;
  OfflinePrivateMessageFinishCallBack? offlinePrivateMessageFinishCallBack;
  OfflinePrivateMessageFinishCallBack? offlineSecretMessageFinishCallBack;
  Map<String, bool> offlinePrivateMessageFinish = {};
  Map<String, bool> offlineSecretMessageFinish = {};

  void Function(String friend, SignalingState state, String data, String? offerId)?
      onCallStateChange;

  Future<void> init({ContactUpdatedCallBack? callBack}) async {
    privkey = Account.sharedInstance.currentPrivkey;
    pubkey = Account.sharedInstance.currentPubkey;
    contactUpdatedCallBack = callBack;

    Account.sharedInstance.contactListUpdateCallback = () async {
      await _syncContactsFromDB();
    };
    // subscript friend requests
    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) async {
      if (status == 1 &&
          Account.sharedInstance.me != null &&
          (relayKinds.contains(RelayKind.general) ||
              relayKinds.contains(RelayKind.inbox) ||
              relayKinds.contains(RelayKind.dm) ||
              relayKinds.contains(RelayKind.circleRelay))) {
        _subscriptMessages(relay: relay);
        _updateSubscriptions(relay: relay);
      }
    });
    _subscriptMessages();
    // sync friend list from DB & relays
    await syncBlockListFromDB();
    await _syncContactsFromDB();
    await syncSecretSessionFromDB();

    _updateSubscriptions();
  }

  Future<void> _updateSubscriptions({String? relay}) async {
    subscriptSecretChat(relay: relay);
  }

  /// contact list
  Future<void> _syncContactsToDB(String list) async {
    Account.sharedInstance.me?.friendsList = list;
    await Account.sharedInstance.syncMe();
  }

  Future<void> _syncContactsToRelay({OKCallBack? okCallBack}) async {
    List<People> friendList = [];
    for (UserDBISAR user in allContacts.values) {
      People p = People(user.pubKey, user.mainRelay, user.nickName, user.aliasPubkey);
      friendList.add(p);
    }
    Event event = await Nip51.createCategorizedPeople(identifier, [], friendList, privkey, pubkey);
    if (event.content.isNotEmpty) {
      Connect.sharedInstance.sendEvent(event, sendCallBack: (OKEvent ok, String relay) async {
        if (ok.status) {
          Account.sharedInstance.me!.lastFriendsListUpdatedTime = event.createdAt;
          await _syncContactsToDB(event.content);
        }
        okCallBack?.call(ok, relay);
      });
    } else {
      throw Exception('_syncFriendsToRelay error content!, $friendList');
    }
  }

  Future<void> syncContactsProfiles(List<People> peoples) async {
    await _syncContactsProfilesFromDB(peoples);
    List<People> friendList = [];
    for (UserDBISAR user in allContacts.values) {
      People p = People(user.pubKey, user.mainRelay, user.nickName, user.aliasPubkey);
      friendList.add(p);
    }
    Event event = await Nip51.createCategorizedPeople(identifier, [], friendList, privkey, pubkey);
    if (event.content.isNotEmpty) {
      _syncContactsToDB(event.content);
    } else {
      throw Exception('_syncFriendsToDB error content!, $friendList');
    }
  }

  Future<void> _syncContactsProfilesFromDB(List<People> peoples) async {
    allContacts.clear();
    await Future.forEach(peoples, (p) async {
      UserDBISAR? user = await Account.sharedInstance.getUserInfo(p.pubkey);
      if (user != null) {
        user.nickName = p.petName;
        allContacts[user.pubKey] = user;
      }
    });
  }

  Future<OKEvent> addToContact(List<String> pubkeys) async {
    Completer<OKEvent> completer = Completer<OKEvent>();

    await Future.forEach(pubkeys, (friendPubkey) async {
      UserDBISAR? friend = await Account.sharedInstance.getUserInfo(friendPubkey);
      friend ??= UserDBISAR(pubKey: friendPubkey);
      allContacts[friendPubkey] = friend;
    });
    _syncContactsToRelay(okCallBack: (OKEvent ok, String relay) {
      if (!completer.isCompleted) completer.complete(ok);
    });
    contactUpdatedCallBack?.call();
    return completer.future;
  }

  Future<OKEvent> removeContact(String friendPubkey) async {
    Completer<OKEvent> completer = Completer<OKEvent>();

    UserDBISAR? friend = allContacts.remove(friendPubkey);
    if (friend != null) {
      _syncContactsToRelay(okCallBack: (OKEvent ok, String relay) {
        if (!completer.isCompleted) completer.complete(ok);
      });
      contactUpdatedCallBack?.call();
    }
    return completer.future;
  }

  Future<OKEvent> updateContactNickName(String friendPubkey, String nickName) async {
    Completer<OKEvent> completer = Completer<OKEvent>();

    UserDBISAR? friend = allContacts[friendPubkey];
    if (friend != null) {
      friend.nickName = nickName;
      await Account.saveUserToDB(friend);
      _syncContactsToRelay(okCallBack: (ok, relay) {
        if (!completer.isCompleted) completer.complete(ok);
      });
    } else if (!completer.isCompleted) {
      completer.complete(OKEvent(friendPubkey, false, ''));
    }
    return completer.future;
  }

  List<UserDBISAR>? fuzzySearch(String keyword) {
    if (keyword.isNotEmpty) {
      RegExp regex = RegExp(keyword, caseSensitive: false);
      List<UserDBISAR> filteredFriends = allContacts.values
          .where((person) =>
              regex.hasMatch(person.name ?? '') ||
              regex.hasMatch(person.dns ?? '') ||
              regex.hasMatch(person.nickName ?? ''))
          .toList();
      return filteredFriends;
    }
    return null;
  }

  Future<void> muteFriend(String friendPubkey) async {
    _setMuteFriend(friendPubkey, true);
  }

  Future<void> unMuteFriend(String friendPubkey) async {
    _setMuteFriend(friendPubkey, false);
  }

  List<String> getAllUnMuteContacts() {
    return allContacts.entries
        .where((e) => e.value.mute == false)
        .map((e) => e.value.pubKey)
        .toList();
  }

  Future<void> _setMuteFriend(String friendPubkey, bool mute) async {
    if (allContacts.containsKey(friendPubkey)) {
      UserDBISAR friend = allContacts[friendPubkey]!;
      friend.mute = mute;
      await Account.saveUserToDB(friend);
    }
  }

  Uint8List? getFriendSharedSecret(String friendPubkey) {
    return Nip44.shareSecret(privkey, friendPubkey);
  }

  /// sync contacts
  Future<void> _syncContactsFromDB() async {
    String? list = Account.sharedInstance.me?.friendsList;
    if (list != null && list.isNotEmpty && list != 'null') {
      Map? map = await Nip51.fromContent(list, privkey, pubkey);
      if (map != null) {
        List<People> friendsList = map['people'];
        for (var p in friendsList) {
          UserDBISAR userDB = UserDBISAR(pubKey: p.pubkey);
          userDB.name = userDB.shortEncodedPubkey;
          allContacts[p.pubkey] = userDB;
        }
        contactUpdatedCallBack?.call();
        await Future.forEach(friendsList, (p) async {
          UserDBISAR? user = await Account.sharedInstance.getUserInfo(p.pubkey);
          if (user != null) {
            user.nickName = p.petName;
            allContacts[user.pubKey] = user;
          }
        });
        contactUpdatedCallBack?.call();
      }
    }
  }

  Future<void> _subscriptMessages({String? relay}) async {
    if (friendMessageSubscription.isNotEmpty) {
      await Connect.sharedInstance.closeRequests(friendMessageSubscription, relay: relay);
    }

    Map<String, List<Filter>> subscriptions = {};
    if (relay == null) {
      List<String> relays = Connect.sharedInstance.relays(relayKinds: [RelayKind.inbox]);
      relays.addAll(Connect.sharedInstance.relays(relayKinds: [RelayKind.dm]));
      relays.addAll(Connect.sharedInstance.relays(relayKinds: [RelayKind.general]));
      relays.addAll(Connect.sharedInstance.relays(relayKinds: [RelayKind.circleRelay]));
      for (String relayURL in relays) {
        int friendMessageUntil = Relays.sharedInstance.getFriendMessageUntil(relayURL);

        /// all messages, contacts & unknown contacts
        Filter f1 = Filter(
            kinds: [4, 1059],
            p: [pubkey],
            since: friendMessageUntil > offset2 ? (friendMessageUntil - offset2 + 1) : 1,
            limit: maxLimit);
        Filter f2 =
            Filter(kinds: [4], authors: [pubkey], since: (friendMessageUntil + 1), limit: maxLimit);
        subscriptions[relayURL] = [f1, f2];
      }
    } else {
      int friendMessageUntil = Relays.sharedInstance.getFriendMessageUntil(relay);

      /// all messages, contacts & unknown contacts
      Filter f1 = Filter(
          kinds: [4, 1059],
          p: [pubkey],
          since: friendMessageUntil > offset2 ? (friendMessageUntil - offset2 + 1) : 1,
          limit: maxLimit);
      Filter f2 =
          Filter(kinds: [4], authors: [pubkey], since: (friendMessageUntil + 1), limit: maxLimit);
      subscriptions[relay] = [f1, f2];
    }
    friendMessageSubscription = Connect.sharedInstance.addSubscriptions(subscriptions,
        closeSubscription: false, eventCallBack: (event, relay) async {
      if (!ChatCoreManager().isAcceptedEventKind(event.kind)) return;
      if (event.kind == 4) {
        updateFriendMessageTime(event.createdAt, relay);
        if (!inBlockList(event.pubkey)) handlePrivateMessage(event, relay);
      } else if (event.kind == 1059) {
        Event? innerEvent = await decodeNip17Event(event);
        if (innerEvent == null || EventCache.sharedInstance.cacheIds.contains(innerEvent.id)) {
          return;
        }
        EventCache.sharedInstance.receiveEvent(innerEvent, relay);
        if (!inBlockList(innerEvent.pubkey) &&
            ChatCoreManager().isAcceptedEventKind(innerEvent.kind)) {
          updateFriendMessageTime(innerEvent.createdAt, relay);
          switch (innerEvent.kind) {
            /// MLS Welcome Message
            case 444:
              Groups.sharedInstance.handleWelcomeMessageEvent(event.id, innerEvent, relay);
              break;
            case 14:
            case 15:
              handlePrivateMessage(innerEvent, relay);
              break;
            case 10100:
            case 10101:
            case 10102:
            case 10103:
            case 10104:
              handleSecretSession(innerEvent, relay, event.id);
              break;
            case 25050:
              handleCallEvent(innerEvent, relay);
              break;
            case 1:
              Moment.sharedInstance.handleNoteEvent(innerEvent, relay, true);
              break;
            case 6:
              Moment.sharedInstance.handleRepostsEvent(innerEvent, relay, true);
              break;
            case 7:
              Moment.sharedInstance.handleReactionEvent(innerEvent, relay, true);
              break;
            default:
              LogUtils.v(() => 'contacts unhandled message ${innerEvent.toJson()}');
              break;
          }
        }
      }
    }, eoseCallBack: (requestId, ok, relay, unCompletedRelays) {
      offlinePrivateMessageFinish[relay] = true;
      if (ok.status) {
        updateFriendMessageTime(currentUnixTimestampSeconds() - 1, relay);
      }
      if (unCompletedRelays.isEmpty) {
        offlinePrivateMessageFinishCallBack?.call();
        if (!Messages.sharedInstance.contactMessageCompleter.isCompleted) {
          Messages.sharedInstance.contactMessageCompleter.complete();
        }
      }
    });
  }

  Future<void> handlePrivateMessage(Event event, String relay, {String? privateGroupId}) async {
    MessageDBISAR? messageDB = await MessageDBISAR.fromPrivateMessage(event, pubkey, privkey,
        privateGroupId: privateGroupId);
    if (messageDB != null) {
      await Messages.saveMessageToDB(messageDB);
      if (messageDB.groupId.isNotEmpty) {
        // private group
        Groups.sharedInstance.groupMessageCallBack?.call(messageDB);
      } else {
        // private chat
        privateChatMessageCallBack?.call(messageDB);
      }
    }
  }

  Future<Event?> getSendMessageEvent(
      String friendPubkey, String replyId, String replyUser, MessageType type, String content,
      {String? source, int? kind, int? expiration, EncryptedFile? encryptedFile}) async {
    Event? event;
    expiration = expiration != null ? (expiration + currentUnixTimestampSeconds()) : null;
    event ??= await Nip17.encodeInnerEvent(friendPubkey,
        MessageDBISAR.getContent(type, content, source), replyId, replyUser, pubkey, privkey,
        subContent: MessageDBISAR.getSubContent(type, content),
        expiration: expiration,
        encryptedFile: encryptedFile);
    return event;
  }

  Future<OKEvent> sendPrivateMessage(
      String toPubkey, String replyId, String replyUser, MessageType type, String content,
      {Event? event,
      int? kind,
      String? subContent,
      int? expiration,
      bool local = false,
      String? source,
      EncryptedFile? encryptedFile,
      String? replaceMessageId}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    event ??= await getSendMessageEvent(toPubkey, replyId, replyUser, type, content,
        kind: kind, expiration: expiration, encryptedFile: encryptedFile, source: source);
    if (event == null) return OKEvent('', false, 'event == null');
    expiration = expiration != null ? (expiration + currentUnixTimestampSeconds()) : null;
    late MessageDBISAR messageDB;
    if (replaceMessageId != null) {
      final replaceMessageDB = await Messages.sharedInstance.loadMessageDBFromDB(replaceMessageId);
      if (replaceMessageDB == null) {
        return Future.value(OKEvent(
          event.id,
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
          sender: pubkey,
          receiver: toPubkey,
          groupId: '',
          kind: event.kind,
          tags: jsonEncode(event.tags),
          content: event.content,
          replyId: replyId,
          createTime: event.createdAt,
          decryptContent: content,
          type: MessageDBISAR.messageTypeToString(type),
          status: 0,
          plaintEvent: jsonEncode(event),
          chatType: 0,
          expiration: expiration,
          decryptSecret: encryptedFile?.secret,
          decryptNonce: encryptedFile?.nonce,
          decryptAlgo: encryptedFile?.algorithm);
    }
    var map =
        await MessageDBISAR.decodeContent(MessageDBISAR.getSubContent(type, content) ?? content);
    messageDB.decryptContent = map['content'];
    messageDB.type = map['contentType'];
    if (encryptedFile?.mimeType != null &&
        (messageDB.type == 'image' ||
            messageDB.type == 'video' ||
            messageDB.type == 'audio' ||
            messageDB.type == 'file')) {
      messageDB.type = MessageDBISAR.mimeTypeToTpyeString(encryptedFile!.mimeType);
    }

    if (replaceMessageId != null) {
      privateChatMessageUpdateCallBack?.call(messageDB, replaceMessageId);
    } else {
      privateChatMessageCallBack?.call(messageDB);
    }

    await Messages.saveMessageToDB(messageDB);

    if (local) {
      if (!completer.isCompleted) {
        completer.complete(OKEvent(event.id, true, ''));
      }
    } else {
      // send to user
      Event? giftwrappedEvent = await Contacts.sharedInstance.encodeNip17Event(event, toPubkey);
      UserDBISAR? toUser = await Account.sharedInstance.getUserInfo(toPubkey);
      List<String>? dmRelays = toUser?.dmRelayList;
      List<String>? inboxRelays = toUser?.inboxRelayList;
      List<String>? myGeneralRelays = Account.sharedInstance.me?.relayList;
      List<String> userRelays = [...(dmRelays ?? []), ...(inboxRelays ?? [])];
      bool hasConnected = false;
      for (var relay in userRelays) {
        if (Connect.sharedInstance.webSockets[relay]?.connectStatus == 1) {
          hasConnected = true;
          break;
        }
      }
      if (!hasConnected) {
        userRelays = [...(myGeneralRelays ?? [])];
        // if (!completer.isCompleted) {
        //   completer.complete(OKEvent(event.id, false, 'Unable to connect to user DM relays'));
        // }
        // return completer.future;
      }
      Connect.sharedInstance.sendEvent(giftwrappedEvent!, toRelays: userRelays,
          sendCallBack: (ok, relay) async {
        messageDB.status = ok.status ? 1 : 2;
        messageDB.giftwrappedEventId = giftwrappedEvent.id;
        messageDB.giftwrappedEventJson = jsonEncode(giftwrappedEvent.toJson());
        privateChatMessageUpdateCallBack?.call(messageDB, messageDB.messageId);
        await Messages.saveMessageToDB(messageDB, conflictAlgorithm: ConflictAlgorithm.replace);
        if (!completer.isCompleted) {
          completer.complete(OKEvent(event!.id, ok.status, ok.message));
        }
        if (ok.status) {
          // send to self
          Event? giftwrappedEventToSelf =
              await Contacts.sharedInstance.encodeNip17Event(event!, pubkey);
          UserDBISAR? me = await Account.sharedInstance.getUserInfo(pubkey);
          List<String>? myDMRelays = me?.dmRelayList;
          List<String>? myInboxRelays = me?.inboxRelayList;
          List<String> myRelays = [...(myDMRelays ?? []), ...(myInboxRelays ?? [])];
          Connect.sharedInstance.sendEvent(giftwrappedEventToSelf!, toRelays: myRelays);
        }
      });

      EventCache.sharedInstance.receiveEvent(event, '');
    }
    return completer.future;
  }

  Future<bool> connectUserDMRelays(String pubkey) async {
    UserDBISAR? toUser = await Account.sharedInstance.getUserInfo(pubkey);
    List<String>? dmRelays = toUser?.dmRelayList ?? [];
    List<String>? inboxRelays = toUser?.inboxRelayList ?? [];
    var relays = [...dmRelays, ...inboxRelays];
    if (relays.isEmpty) return true;
    for (var relay in relays) {
      if (Connect.sharedInstance.webSockets[relay]?.connectStatus == 1) return true;
    }
    await Connect.sharedInstance.connectRelays(relays, relayKind: RelayKind.temp);
    for (var relay in relays) {
      int? status = Connect.sharedInstance.webSockets[relay]?.connectStatus;
      if (status == 1 || status == 0) return true;
    }
    return false;
  }

  Future<void> closeUserDMRelays(String pubkey) async {
    UserDBISAR? toUser = await Account.sharedInstance.getUserInfo(pubkey);
    List<String>? dmRelays = toUser?.dmRelayList ?? [];
    List<String>? inboxRelays = toUser?.inboxRelayList ?? [];
    var relays = [...dmRelays, ...inboxRelays];
    relays.addAll(toUser?.relayList ?? []);
    if (relays.isNotEmpty) {
      await Connect.sharedInstance.closeTempConnects(relays);
    }
  }

  Future<void> closeUserGeneralRelays(String pubkey) async {
    UserDBISAR? toUser = await Account.sharedInstance.getUserInfo(pubkey);
    List<String>? relays = toUser?.relayList;
    if (relays?.isNotEmpty == true) {
      await Connect.sharedInstance.closeTempConnects(relays!);
    }
  }

  void updateFriendMessageTime(int eventTime, String relay) {
    /// set friendMessageUntil friendMessageSince
    if (Relays.sharedInstance.relays.containsKey(relay)) {
      Relays.sharedInstance.setFriendMessageUntil(eventTime, relay);
      Relays.sharedInstance.setFriendMessageSince(eventTime, relay);
    } else {
      Relays.sharedInstance.relays[relay] =
          RelayDBISAR(url: relay, friendMessageUntil: eventTime, friendMessageSince: eventTime);
    }
    if (offlinePrivateMessageFinish[relay] == true) {
      Relays.sharedInstance.syncRelaysToDB(r: relay);
    }
  }
}
