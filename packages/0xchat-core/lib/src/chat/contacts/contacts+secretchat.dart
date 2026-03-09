import 'dart:async';
import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:isar/isar.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';

extension SecretChat on Contacts {
  Future<void> saveSecretDB(SecretSessionDBISAR secretSessionDB) async {
    await DBISAR.sharedInstance.saveToDB(secretSessionDB);
  }

  Future<void> _connectToRelay(String? relay) async {
    if (relay != null &&
        relay.isNotEmpty &&
        !Connect.sharedInstance.relays(relayKinds: [RelayKind.secretChat]).contains(relay)) {
      await Connect.sharedInstance.connect(relay, relayKind: RelayKind.secretChat);
    }
  }

  Future<OKEvent> request(String toPubkey, String chatRelay,
      {int? interval, int? expiration}) async {
    Keychain randomKey = Keychain.generate();

    /// default 24 hours
    expiration ??= currentUnixTimestampSeconds() + 24 * 60 * 60;
    OKEvent okEvent = await _sendRequestEvent(toPubkey, randomKey.public,
        expiration: expiration, interval: interval, relay: chatRelay);
    if (okEvent.status) {
      // connect the chat relay
      await _connectToRelay(chatRelay);
      SecretSessionDBISAR secretSessionDB = SecretSessionDBISAR(
          sessionId: okEvent.eventId,
          myPubkey: pubkey,
          myAliasPubkey: randomKey.public,
          myAliasPrivkey: randomKey.private,
          toPubkey: toPubkey,
          lastUpdateTime: currentUnixTimestampSeconds(),
          status: 0,
          relay: chatRelay,
          interval: interval,
          expiration: expiration);
      await saveSecretDB(secretSessionDB);
      secretSessionMap[secretSessionDB.sessionId] = secretSessionDB;
    }
    return okEvent;
  }

  Future<OKEvent> _sendRequestEvent(String friendPubkey, String aliasPubkey,
      {int? expiration, int? interval, String? relay}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event = await Nip101.request(aliasPubkey, friendPubkey, pubkey, privkey,
        expiration: expiration, interval: interval, relay: relay);

    /// expired 24 hours later
    Event sealedEvent =
        await Nip17.encode(event, friendPubkey, pubkey, privkey, expiration: expiration);
    Connect.sharedInstance.sendEvent(sealedEvent, sendCallBack: (ok, relay) {
      if (!completer.isCompleted) {
        completer.complete(OKEvent(event.id, ok.status, ok.message));
      }
    });
    return completer.future;
  }

  static Future<SecretSessionDBISAR?> searchSecretSessionFromDB(String sessionId) async {
    final isar = DBISAR.sharedInstance.isar;
    return await isar.secretSessionDBISARs.filter().sessionIdEqualTo(sessionId).findFirst();
  }

  static Future<bool> deleteSecretSessionFromDB(String sessionId) async {
    final isar = DBISAR.sharedInstance.isar;
    await isar.writeTxn(() async {
      await isar.secretSessionDBISARs.deleteBySessionId(sessionId);
    });
    return true;
  }

  Future<OKEvent> accept(String sessionId) async {
    SecretSessionDBISAR? db = secretSessionMap[sessionId];
    if (db != null) {
      // connect the chat relay
      await _connectToRelay(db.relay);
      Keychain randomKey = Keychain.generate();
      OKEvent okEvent = await _sendAcceptEvent(randomKey.public, db.toPubkey!, sessionId);
      if (okEvent.status) {
        db.shareSecretKey = bytesToHex(Nip44.shareSecret(randomKey.private, db.toAliasPubkey!));
        db.sharePubkey = Keychain.getPublicKey(db.shareSecretKey!);
        db.status = 2;
        db.lastUpdateTime = currentUnixTimestampSeconds();
        await saveSecretDB(db);
        subscriptSecretChat();
      }
      return okEvent;
    }
    return OKEvent(sessionId, false, 'sessionId not found');
  }

  Future<OKEvent> _sendAcceptEvent(String myAliasPubkey, String toPubkey, String sessionId) async {
    Completer<OKEvent> completer = Completer<OKEvent>();

    Event event = await Nip101.accept(myAliasPubkey, toPubkey, sessionId, pubkey, privkey);
    Event sealedEvent = await Nip17.encode(event, toPubkey, pubkey, privkey);
    Connect.sharedInstance.sendEvent(sealedEvent, sendCallBack: (ok, relay) async {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  Future<OKEvent> reject(String sessionId) async {
    SecretSessionDBISAR? db = secretSessionMap[sessionId];
    if (db != null) {
      OKEvent okEvent = await _sendRejectEvent(db.toPubkey!, sessionId);
      if (okEvent.status) {
        await deleteSecretSessionFromDB(sessionId);
        secretSessionMap.remove(sessionId);
      }
      return okEvent;
    }
    return OKEvent(sessionId, false, 'sessionId not found');
  }

  Future<OKEvent> _sendRejectEvent(String toPubkey, String sessionId) async {
    Completer<OKEvent> completer = Completer<OKEvent>();

    Event event = await Nip101.reject(toPubkey, sessionId, pubkey, privkey);
    Event sealedEvent = await Nip17.encode(event, toPubkey, pubkey, privkey);
    Connect.sharedInstance.sendEvent(sealedEvent, sendCallBack: (ok, relay) async {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  Future<OKEvent> update(String sessionId) async {
    SecretSessionDBISAR? db = secretSessionMap[sessionId];
    if (db != null && db.status != 5) {
      Keychain randomKey = Keychain.generate();
      OKEvent okEvent = await _sendUpdateEvent(randomKey.public, db.toPubkey!, sessionId);
      if (okEvent.status) {
        db.myAliasPubkey = randomKey.public;
        db.myAliasPrivkey = randomKey.private;
        if (db.toAliasPubkey != null && db.toAliasPubkey!.isNotEmpty) {
          db.shareSecretKey = bytesToHex(Nip44.shareSecret(randomKey.private, db.toAliasPubkey!));
          db.sharePubkey = Keychain.getPublicKey(db.shareSecretKey!);
          db.status = 2;
          await subscriptSecretChat();
        } else {
          db.status = 5;
        }
        db.lastUpdateTime = currentUnixTimestampSeconds();
        await saveSecretDB(db);
      }
      return okEvent;
    }
    return OKEvent(sessionId, false, 'sessionId not found or in update status');
  }

  Future<OKEvent> _sendUpdateEvent(String myAliasPubkey, String toPubkey, String sessionId) async {
    Completer<OKEvent> completer = Completer<OKEvent>();

    Event event = await Nip101.update(myAliasPubkey, toPubkey, sessionId, pubkey, privkey);
    Event sealedEvent = await Nip17.encode(event, toPubkey, pubkey, privkey);
    Connect.sharedInstance.sendEvent(sealedEvent, sendCallBack: (ok, relay) async {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  Future<OKEvent> close(String sessionId) async {
    SecretSessionDBISAR? db = secretSessionMap[sessionId];
    if (db != null) {
      OKEvent okEvent = await _sendCloseEvent(db.toPubkey!, sessionId);
      await deleteSecretSessionFromDB(sessionId);
      secretSessionMap.remove(sessionId);
      return okEvent;
    }
    return OKEvent(sessionId, false, 'sessionId not found');
  }

  Future<OKEvent> _sendCloseEvent(String toPubkey, String sessionId) async {
    Completer<OKEvent> completer = Completer<OKEvent>();

    Event event = await Nip101.close(toPubkey, sessionId, pubkey, privkey);
    Event sealedEvent = await Nip17.encode(event, toPubkey, pubkey, privkey);
    Connect.sharedInstance.sendEvent(sealedEvent, sendCallBack: (ok, relay) async {
      if (!completer.isCompleted) completer.complete(ok);
    });
    return completer.future;
  }

  SecretSessionDBISAR _exchangeSessionToSessionDB(KeyExchangeSession session) {
    int status = 0;
    switch (session.kind) {
      case 10100:
        status = 1;
        break;
      case 10101:
        status = 2;
        break;
      case 10102:
        status = 3;
        break;
      case 10103:
        status = 4;
        break;
      case 10104:
        status = 5;
        break;
    }
    return SecretSessionDBISAR(
        sessionId: session.sessionId,
        interval: session.interval,
        expiration: session.expiration,
        relay: session.relay,
        lastUpdateTime: session.createTime,
        status: status);
  }

  Future<void> handleSecretSession(Event event, String relay, String giftWrapEventId) async {
    MessageDBISAR messageDB = MessageDBISAR(messageId: giftWrapEventId);
    await Messages.saveMessageToDB(messageDB);
    switch (event.kind) {
      case 10100:
        handleRequest(event, relay);
        break;
      case 10101:
        handleAccept(event, relay);
        break;
      case 10102:
        handleReject(event, relay);
        break;
      case 10103:
        handleClose(event, relay);
        break;
      case 10104:
        handleUpdate(event, relay);
        break;
    }
  }

  Future<void> handleRequest(Event event, String relay) async {
    /// get keyExchangeSession
    KeyExchangeSession keyExchangeSession = Nip101.getRequest(event);
    SecretSessionDBISAR secretSessionDB = _exchangeSessionToSessionDB(keyExchangeSession);
    if (secretSessionMap.containsKey(secretSessionDB.sessionId)) {
      return;
    }
    secretSessionDB.myPubkey = pubkey;
    secretSessionDB.toPubkey = keyExchangeSession.fromPubkey;
    secretSessionDB.toAliasPubkey = keyExchangeSession.fromAliasPubkey;
    secretSessionDB.status = 1;
    secretSessionDB.lastUpdateTime = keyExchangeSession.createTime;
    await saveSecretDB(secretSessionDB);

    /// add to secretSessionMap
    secretSessionMap[secretSessionDB.sessionId] = secretSessionDB;

    /// callback
    secretChatRequestCallBack?.call(secretSessionDB);
  }

  Future<void> handleAccept(Event event, String relay) async {
    /// get alias
    KeyExchangeSession session = Nip101.getAccept(event);
    SecretSessionDBISAR? secretSessionDB = secretSessionMap[session.sessionId];
    if (secretSessionDB != null &&
        session.fromPubkey == secretSessionDB.toPubkey &&
        event.createdAt > secretSessionDB.lastUpdateTime) {
      secretSessionDB.toAliasPubkey = session.fromAliasPubkey;
      secretSessionDB.shareSecretKey = bytesToHex(
          Nip44.shareSecret(secretSessionDB.myAliasPrivkey!, secretSessionDB.toAliasPubkey!));
      secretSessionDB.sharePubkey = Keychain.getPublicKey(secretSessionDB.shareSecretKey!);
      secretSessionDB.status = 2;
      secretSessionDB.lastUpdateTime = session.createTime;
      await saveSecretDB(secretSessionDB);

      subscriptSecretChat();

      /// callback
      secretChatAcceptCallBack?.call(secretSessionDB);
    }
  }

  Future<void> handleReject(Event event, String relay) async {
    /// get alias
    KeyExchangeSession session = Nip101.getReject(event);
    SecretSessionDBISAR? secretSessionDB = secretSessionMap[session.sessionId];
    if (secretSessionDB != null &&
        session.fromPubkey == secretSessionDB.toPubkey &&
        event.createdAt > secretSessionDB.lastUpdateTime) {
      secretSessionDB.status = 3;
      secretSessionDB.lastUpdateTime = session.createTime;
      await saveSecretDB(secretSessionDB);

      /// callback
      secretChatRejectCallBack?.call(secretSessionDB);
    }
  }

  Future<void> handleUpdate(Event event, String relay) async {
    /// get alias
    KeyExchangeSession session = Nip101.getUpdate(event);
    SecretSessionDBISAR? secretSessionDB = secretSessionMap[session.sessionId];

    if (secretSessionDB != null &&
        session.fromPubkey == secretSessionDB.toPubkey &&
        event.createdAt > secretSessionDB.lastUpdateTime) {
      secretSessionDB.toAliasPubkey = session.fromAliasPubkey;
      if (secretSessionDB.myAliasPrivkey != null && secretSessionDB.myAliasPrivkey!.isNotEmpty) {
        secretSessionDB.shareSecretKey = bytesToHex(
            Nip44.shareSecret(secretSessionDB.myAliasPrivkey!, secretSessionDB.toAliasPubkey!));
        secretSessionDB.sharePubkey = Keychain.getPublicKey(secretSessionDB.shareSecretKey!);
        secretSessionDB.status = 2;
        secretSessionMap[secretSessionDB.sessionId] = secretSessionDB;
        await subscriptSecretChat();
      } else {
        await saveSecretDB(secretSessionDB);
        await update(secretSessionDB.sessionId);
      }
      secretSessionDB.lastUpdateTime = session.createTime;
      await saveSecretDB(secretSessionDB);

      /// callback
      secretChatUpdateCallBack?.call(secretSessionDB);
    }
  }

  Future<void> handleClose(Event event, String relay) async {
    /// get alias
    KeyExchangeSession session = Nip101.getClose(event);
    SecretSessionDBISAR? secretSessionDB = secretSessionMap[session.sessionId];
    if (secretSessionDB != null &&
        session.fromPubkey == secretSessionDB.toPubkey &&
        event.createdAt > secretSessionDB.lastUpdateTime) {
      secretSessionDB.status = 4;
      secretSessionMap.remove(secretSessionDB.sessionId);
      subscriptSecretChat();

      /// callback
      secretChatCloseCallBack?.call(secretSessionDB);
    }
  }

  Future<void> _handleSecretMessage(String sessionId, Event event, String giftWrapEventId) async {
    MessageDBISAR? messageDB =
        await MessageDBISAR.fromPrivateMessage(event, pubkey, privkey, chatType: 3);
    if (messageDB != null) {
      messageDB.sessionId = sessionId;
      await Messages.saveMessageToDB(messageDB);
      secretChatMessageCallBack?.call(messageDB);
    }
  }

  Future<Event?> getSendSecretMessageEvent(
    String sessionId,
    String toPubkey,
    String replyId,
    String replyUser,
    MessageType type,
    String content,
    int? expiration, {
    String? source,
    EncryptedFile? encryptedFile,
  }) async {
    expiration = expiration != null ? (expiration + currentUnixTimestampSeconds()) : null;
    SecretSessionDBISAR? sessionDB = secretSessionMap[sessionId];
    if (sessionDB != null &&
        sessionDB.shareSecretKey != null &&
        sessionDB.shareSecretKey!.isNotEmpty) {
      return await Nip17.encodeInnerEvent(
        toPubkey,
        MessageDBISAR.getContent(type, content, source),
        replyId,
        replyUser,
        pubkey,
        privkey,
        subContent: MessageDBISAR.getSubContent(type, content),
        expiration: expiration,
        encryptedFile: encryptedFile,
      );
    }
    return null;
  }

  Future<OKEvent> sendSecretMessage(String sessionId, String toPubkey, String replayId,
      String replyUser, MessageType type, String content,
      {Event? event,
      bool local = false,
      int? expiration,
      String? source,
      EncryptedFile? encryptedFile,
      String? replaceMessageId}) async {
    Completer<OKEvent> completer = Completer<OKEvent>();

    SecretSessionDBISAR? sessionDB = secretSessionMap[sessionId];
    if (sessionDB != null) {
      /// check chat relay
      _connectToRelay(sessionDB.relay);
      event ??= await getSendSecretMessageEvent(
          sessionId, toPubkey, replayId, replyUser, type, content, expiration,
          encryptedFile: encryptedFile, source: source);
      expiration = expiration != null ? (expiration + currentUnixTimestampSeconds()) : null;

      late MessageDBISAR messageDB;
      if (replaceMessageId != null) {
        final replaceMessageDB =
            await Messages.sharedInstance.loadMessageDBFromDB(replaceMessageId);
        if (replaceMessageDB == null) {
          return Future.value(OKEvent(
            event?.innerEvent?.id ?? event!.id,
            false,
            'The message to be replaced was not found',
          ));
        }
        replaceMessageDB.messageId = event!.id;
        replaceMessageDB.content = event.content;
        messageDB = replaceMessageDB;
      } else {
        messageDB = MessageDBISAR(
          messageId: event!.id,
          sender: pubkey,
          receiver: toPubkey,
          groupId: '',
          sessionId: sessionId,
          kind: event.kind,
          tags: jsonEncode(event.tags),
          content: event.content,
          createTime: event.createdAt,
          decryptContent: content,
          type: MessageDBISAR.messageTypeToString(type),
          status: 0,
          plaintEvent: jsonEncode(event),
          chatType: 3,
          expiration: expiration,
          decryptSecret: encryptedFile?.secret,
          decryptNonce: encryptedFile?.nonce,
          decryptAlgo: encryptedFile?.algorithm,
        );
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
        secretChatMessageUpdateCallBack?.call(messageDB, replaceMessageId);
      } else {
        secretChatMessageCallBack?.call(messageDB);
      }

      await Messages.saveMessageToDB(messageDB);

      if (local) {
        if (!completer.isCompleted) {
          completer.complete(OKEvent(event.id, true, ''));
        }
      } else {
        Event? giftwrappedEvent = await Contacts.sharedInstance.encodeNip17Event(event, toPubkey,
            sealedReceiver: sessionDB.sharePubkey!, sealedPrivkey: sessionDB.shareSecretKey!);
        Connect.sharedInstance.sendEvent(giftwrappedEvent!, toRelays: [sessionDB.relay ?? ''],
            sendCallBack: (ok, relay) async {
          messageDB.status = ok.status ? 1 : 2;
          secretChatMessageUpdateCallBack?.call(messageDB, messageDB.messageId);
          await Messages.saveMessageToDB(messageDB, conflictAlgorithm: ConflictAlgorithm.replace);
          if (!completer.isCompleted) completer.complete(ok);

          /// rotate shared key
          if (ok.status &&
              sessionDB.interval != null &&
              sessionDB.interval! > 0 &&
              messageDB.createTime > (sessionDB.interval! + sessionDB.lastUpdateTime) &&
              sessionDB.status != 5) {
            await update(sessionDB.sessionId);
          }
        });
        EventCache.sharedInstance.receiveEvent(event, '');
      }
    } else {
      if (!completer.isCompleted) {
        completer.complete(OKEvent(sessionId, false, 'unknown session'));
      }
    }
    return completer.future;
  }

  Future<void> syncSecretSessionFromDB() async {
    final isar = DBISAR.sharedInstance.isar;
    List<SecretSessionDBISAR> secretSessions = await isar.secretSessionDBISARs.where().findAll();
    for (var session in secretSessions) {
      secretSessionMap[session.sessionId] = session;

      /// connect to session relay
      _connectToRelay(session.relay);
    }
  }

  SecretSessionDBISAR? _getSessionFromPubkey(String pubkey) {
    for (var value in secretSessionMap.values) {
      if (value.sharePubkey == pubkey) {
        return value;
      }
    }
    return null;
  }

  Future<void> subscriptSecretChat({String? relay}) async {
    if (secretSessionSubscription.isNotEmpty) {
      await Connect.sharedInstance.closeRequests(secretSessionSubscription, relay: relay);
    }

    List<String> pubkeys = [];
    secretSessionMap.forEach((key, value) {
      if (value.status == 2 || value.status == 5) {
        if (value.sharePubkey!.isNotEmpty) pubkeys.add(value.sharePubkey!);
      }
    });
    if (pubkeys.isEmpty) {
      offlineSecretMessageFinishCallBack?.call();
      if (!Messages.sharedInstance.secretChatMessageCompleter.isCompleted) {
        Messages.sharedInstance.secretChatMessageCompleter.complete();
      }
      return;
    }
    Map<String, List<Filter>> subscriptions = {};
    if (relay == null) {
      List<String> relays = Connect.sharedInstance.relays(relayKinds: [RelayKind.general]);
      relays.addAll(Connect.sharedInstance.relays(relayKinds: [RelayKind.secretChat]));
      for (var r in relays) {
        int friendRequestUntil = Relays.sharedInstance.getFriendRequestUntil(r);
        Filter f = Filter(
            kinds: [1059],
            authors: pubkeys,
            since: friendRequestUntil > offset2 ? (friendRequestUntil - offset2 + 1) : 1);
        subscriptions[r] = [f];
      }
    } else {
      int friendRequestUntil = Relays.sharedInstance.getFriendRequestUntil(relay);
      Filter f = Filter(
          kinds: [1059],
          authors: pubkeys,
          since: friendRequestUntil > offset2 ? (friendRequestUntil - offset2 + 1) : 1);
      subscriptions[relay] = [f];
    }
    secretSessionSubscription = Connect.sharedInstance.addSubscriptions(subscriptions,
        closeSubscription: false, eventCallBack: (event, relay) async {
      SecretSessionDBISAR? session = _getSessionFromPubkey(event.pubkey);
      if (session != null) {
        Event? innerEvent =
            await Nip17.decode(event, pubkey, privkey, sealedPrivkey: session.shareSecretKey!);
        if (innerEvent != null && !inBlockList(innerEvent.pubkey)) {
          updateFriendRequestTime(innerEvent.createdAt, relay);
          switch (innerEvent.kind) {
            case 14:
            case 15:
              _handleSecretMessage(session.sessionId, innerEvent, event.id);
              break;
            default:
              print('secretchat unhandled message ${event.toJson()}');
              break;
          }
        }
      }
    }, eoseCallBack: (requestId, ok, relay, unCompletedRelays) {
      offlineSecretMessageFinish[relay] = true;
      if (ok.status) {
        updateFriendRequestTime(currentUnixTimestampSeconds() - 1, relay);
      }
      if (unCompletedRelays.isEmpty) {
        offlineSecretMessageFinishCallBack?.call();
        if (!Messages.sharedInstance.secretChatMessageCompleter.isCompleted) {
          Messages.sharedInstance.secretChatMessageCompleter.complete();
        }
      }
    });
  }

  void updateFriendRequestTime(int eventTime, String relay) {
    if (Relays.sharedInstance.relays.containsKey(relay)) {
      Relays.sharedInstance.setFriendRequestSince(eventTime, relay);
      Relays.sharedInstance.setFriendRequestUntil(eventTime, relay);
    } else {
      Relays.sharedInstance.relays[relay] =
          RelayDBISAR(url: relay, friendRequestUntil: eventTime, friendRequestSince: eventTime);
    }
    if (offlineSecretMessageFinish[relay] == true) {
      Relays.sharedInstance.syncRelaysToDB(r: relay);
    }
  }
}
