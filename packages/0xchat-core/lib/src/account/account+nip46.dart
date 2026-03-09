import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';

extension AccountNIP46 on Account {
  Future<bool> _checkNIP46Pubkey(String pubkey) async {
    if (me == null || me?.remoteSignerURI == null) return false;
    await connectToRemoteSigner(me!.remoteSignerURI!, true, pubkey);
    String? getPubkey = await sendGetPubicKey();
    if (getPubkey == null || getPubkey != pubkey) return false;
    return true;
  }

  Future<UserDBISAR?> loginWithNip46Pubkey(String pubkey) async {
    await loginWithPubKey(pubkey, SignerApplication.remoteSigner);
    _checkNIP46Pubkey(pubkey);
    return me;
  }

  Future<UserDBISAR?> loginWithNip46URI(String uri) async {
    if (uri.startsWith('bunker://')) {
      return _loginWithBunkerURI(uri);
    } else if (uri.startsWith('nostrconnect://')) {
      return _loginWithNostrConnectURI(uri);
    }
    return null;
  }

  Future<UserDBISAR?> _loginWithBunkerURI(String uri) async {
    await connectToRemoteSigner(uri, false, '');
    String? getPubkey = await sendGetPubicKey();
    if (getPubkey == null) return null;
    UserDBISAR? userDBISAR = await loginWithPubKey(getPubkey, SignerApplication.remoteSigner);
    if (userDBISAR != null) {
      userDBISAR.remoteSignerURI = uri;
      userDBISAR.clientPrivateKey ??= currentRemoteConnection!.clientPrivkey;
      await Account.saveUserToDB(userDBISAR);
    }
    return userDBISAR;
  }

  Future<UserDBISAR?> _loginWithNostrConnectURI(String uri) async {
    await loginWithPubKey(currentRemoteConnection!.remotePubkey, SignerApplication.remoteSigner);
    if (me != null) {
      me!.remoteSignerURI = uri;
      me!.clientPrivateKey = currentRemoteConnection!.clientPrivkey;
      me!.remotePubkey = currentRemoteConnection!.remotePubkey;
      await syncMe();
    }
    return me;
  }

  static String createNostrConnectURI({List<String> relays = const ['wss://relay.nsec.app']}) {
    Keychain newKeychain = Keychain.generate();
    String secret = generate64RandomHexChars();
    Account.sharedInstance.tempRemoteConnection = RemoteSignerConnection('', relays, secret);
    Account.sharedInstance.tempRemoteConnection!.clientPrivkey = newKeychain.private;
    Account.sharedInstance.tempRemoteConnection!.clientPubkey = newKeychain.public;
    Account.sharedInstance.tempRemoteConnection!.relays = relays;
    String perms = SignerPermissionModel.defaultPermissionsForNIP46();
    String name = '0xchat-${Platform.operatingSystem}';
    String url = 'www.0xchat.com';
    String image = 'https://www.0xchat.com/favicon1.png';
    return Nip46.createNostrConnectUrl(
        clientPubKey: newKeychain.public,
        secret: secret,
        relays: relays,
        perms: null,
        name: name,
        url: url,
        image: image);
  }

  Future<String> getPublicKeyWithNostrConnectURI(String uri) async {
    nip46connectionStatusCallback?.call(NIP46ConnectionStatus.waitingForSigning);
    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) async {
      if (status == 1 && tempRemoteConnection!.relays.contains(relay)) {
        updateNIP46Subscription(relay: relay, connection: tempRemoteConnection);
        for (var event in unsentNIP46EventQueue) {
          Connect.sharedInstance.sendEvent(event, toRelays: tempRemoteConnection!.relays);
        }
        unsentNIP46EventQueue.clear();
      }
    });
    Connect.sharedInstance
        .connectRelays(tempRemoteConnection!.relays, relayKind: RelayKind.remoteSigner);
    updateNIP46Subscription(connection: tempRemoteConnection);
    Completer<NIP46CommandResult> completer = Completer<NIP46CommandResult>();
    String secret = tempRemoteConnection!.secret!;
    resultCompleters[secret] = completer;
    await completer.future;
    currentRemoteConnection = tempRemoteConnection;
    String? pubkey = await sendGetPubicKey();
    if (pubkey != null) {
      currentRemoteConnection!.remotePubkey = pubkey;
    }
    nip46connectionStatusCallback?.call(NIP46ConnectionStatus.approvedSigning);
    return pubkey ?? '';
  }

  void initNIP46Callback() {
    SignerHelper.sharedInstance.signEventHandle = (String eventString) async {
      return await sendSignEvent(eventString);
    };
    SignerHelper.sharedInstance.nip04encryptEventHandle =
        (String plainText, String peerPubkey) async {
      return await sendNip04Encrypt(peerPubkey, plainText);
    };
    SignerHelper.sharedInstance.nip04decryptEventHandle =
        (String encryptedText, String peerPubkey) async {
      return await sendNip04Decrypt(peerPubkey, encryptedText);
    };
    SignerHelper.sharedInstance.nip44encryptEventHandle =
        (String plainText, String peerPubkey) async {
      return await sendNip44Encrypt(peerPubkey, plainText);
    };
    SignerHelper.sharedInstance.nip44decryptEventHandle =
        (String encryptedText, String peerPubkey) async {
      return await sendNip44Decrypt(peerPubkey, encryptedText);
    };
  }

  Future<OKEvent> connectToRemoteSigner(String uri, bool autoLogin, String remotePubkey) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    late RemoteSignerConnection remoteSignerConnection;
    if (uri.startsWith('bunker://')) {
      remoteSignerConnection = Nip46.parseBunkerUri(uri);
    } else if (uri.startsWith('nostrconnect://')) {
      remoteSignerConnection = Nip46.parseNostrConnectUri(uri);
    }
    currentRemoteConnection = remoteSignerConnection;
    currentRemoteConnection!.clientPrivkey = me?.clientPrivateKey;
    if (currentRemoteConnection!.remotePubkey.isEmpty) {
      currentRemoteConnection!.remotePubkey = me?.remotePubkey ?? remotePubkey;
    }
    if (currentRemoteConnection!.clientPrivkey == null) {
      Keychain newKeychain = Keychain.generate();
      currentRemoteConnection!.clientPrivkey = newKeychain.private;
      currentRemoteConnection!.clientPubkey = newKeychain.public;
    } else {
      currentRemoteConnection!.clientPubkey =
          Keychain(currentRemoteConnection!.clientPrivkey!).public;
    }
    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) async {
      if (status == 1 && remoteSignerConnection.relays.contains(relay)) {
        nip46connectionStatusCallback?.call(NIP46ConnectionStatus.connected);
        updateNIP46Subscription(relay: relay, connection: currentRemoteConnection);
        if (!autoLogin) {
          await sendConnect();
        } else {
          for (var event in unsentNIP46EventQueue) {
            Connect.sharedInstance.sendEvent(event, toRelays: currentRemoteConnection!.relays);
          }
          unsentNIP46EventQueue.clear();
        }
        if (!completer.isCompleted) completer.complete(OKEvent(uri, true, ''));
      }
      else if(status != 1 && remoteSignerConnection.relays.contains(relay)){
        // lost connection
        nip46connectionStatusCallback?.call(NIP46ConnectionStatus.disconnected);
      }
    });

    await Connect.sharedInstance
        .connectRelays(remoteSignerConnection.relays, relayKind: RelayKind.remoteSigner);
    return completer.future;
  }

  Future<String?> sendGetPubicKey() async {
    if (currentRemoteConnection == null) return null;
    NIP46Command command = NIP46Command.getPublicKey();
    var id = generate64RandomHexChars();
    Event event = await Nip46.encode(currentRemoteConnection!.remotePubkey, id, command,
        currentRemoteConnection!.clientPubkey!, currentRemoteConnection!.clientPrivkey!);
    NIP46CommandResult result = await sendToRemoteSigner(event, id);
    return result.result;
  }

  void updateNIP46Subscription({String? relay, RemoteSignerConnection? connection}) {
    if (connection == null) return;
    Map<String, List<Filter>> subscriptions = {};
    if (relay == null) {
      for (String relayURL in connection.relays) {
        Filter f = Filter(
            kinds: [24133], p: [connection.clientPubkey!], since: currentUnixTimestampSeconds());
        subscriptions[relayURL] = [f];
      }
    } else {
      Filter f = Filter(
          kinds: [24133], p: [connection.clientPubkey!], since: currentUnixTimestampSeconds());
      subscriptions[relay] = [f];
    }

    Connect.sharedInstance.addSubscriptions(subscriptions, closeSubscription: false,
        eventCallBack: (event, relay) async {
      switch (event.kind) {
        case 24133:
          NIP46CommandResult result =
              await Nip46.decode(event, connection.clientPubkey!, connection.clientPrivkey!);

          nip46commandResultCallback?.call(result);
          if (result.result == 'auth_url') {
            LogUtils.v(() => 'connect waiting for auth... ${result.toString()}');
            return;
          }
          String resultId = result.id;
          if (result.result == connection.secret) {
            LogUtils.v(() => 'nostr connect success... ${result.toString()}');
            resultId = result.result;
            connection.remotePubkey = event.pubkey;
          }
          Completer? completer = resultCompleters[resultId];
          if (completer != null && !completer.isCompleted) completer.complete(result);
          resultCompleters.remove(resultId);
          break;
        default:
          LogUtils.v(() => 'moment unhandled message ${event.toJson()}');
          break;
      }
    }, eoseCallBack: (requestId, ok, relay, unCompletedRelays) {});
  }

  Future<NIP46CommandResult> sendToRemoteSigner(Event event, String id) {
    Completer<NIP46CommandResult> completer = Completer<NIP46CommandResult>();
    resultCompleters[id] = completer;
    bool hasConnected = false;
    for (var relay in currentRemoteConnection!.relays) {
      if (Connect.sharedInstance.webSockets[relay]?.connectStatus == 1) {
        hasConnected = true;
        break;
      }
    }
    if (!hasConnected) {
      unsentNIP46EventQueue.add(event);
    } else {
      Connect.sharedInstance.sendEvent(event, toRelays: currentRemoteConnection!.relays);
    }
    return completer.future;
  }

  Future<bool> sendConnect() async {
    NIP46Command command = NIP46Command.connect(currentRemoteConnection!.remotePubkey,
        currentRemoteConnection!.secret, SignerPermissionModel.defaultPermissionsForNIP46());
    var id = generate64RandomHexChars();
    Event event = await Nip46.encode(currentRemoteConnection!.remotePubkey, id, command,
        currentRemoteConnection!.clientPubkey!, currentRemoteConnection!.clientPrivkey!);
    NIP46CommandResult result = await sendToRemoteSigner(event, id);

    if (result.result != 'ack') {
      print('sendConnect connected false');
      return false;
    }
    print('sendConnect connected success');
    return true;
  }

  Future<Event> sendSignEvent(String eventString) async {
    NIP46Command command = NIP46Command.signEvent(eventString);
    var id = generate64RandomHexChars();
    Event event = await Nip46.encode(currentRemoteConnection!.remotePubkey, id, command,
        currentRemoteConnection!.clientPubkey!, currentRemoteConnection!.clientPrivkey!);
    NIP46CommandResult result = await sendToRemoteSigner(event, id);
    if (result.error == null && result.result != null) {
      return await Event.fromJson(jsonDecode(result.result));
    }
    return result.result;
  }

  Future<void> sendGetRelays() async {
    NIP46Command command = NIP46Command.getRelays();
    var id = generate64RandomHexChars();
    Event event = await Nip46.encode(currentRemoteConnection!.remotePubkey, id, command,
        currentRemoteConnection!.clientPubkey!, currentRemoteConnection!.clientPrivkey!);
    NIP46CommandResult result = await sendToRemoteSigner(event, id);
    return result.result;
  }

  Future<String> sendGetPublicKey() async {
    NIP46Command command = NIP46Command.getPublicKey();
    var id = generate64RandomHexChars();
    Event event = await Nip46.encode(currentRemoteConnection!.remotePubkey, id, command,
        currentRemoteConnection!.clientPubkey!, currentRemoteConnection!.clientPrivkey!);
    NIP46CommandResult result = await sendToRemoteSigner(event, id);
    return result.result;
  }

  Future<String> sendNip04Encrypt(String thirdPartyPubkey, String plaintext) async {
    NIP46Command command = NIP46Command.nip04Encrypt(thirdPartyPubkey, plaintext);
    var id = generate64RandomHexChars();
    Event event = await Nip46.encode(currentRemoteConnection!.remotePubkey, id, command,
        currentRemoteConnection!.clientPubkey!, currentRemoteConnection!.clientPrivkey!);
    NIP46CommandResult result = await sendToRemoteSigner(event, id);
    return result.result;
  }

  Future<String> sendNip04Decrypt(String thirdPartyPubkey, String ciphertext) async {
    NIP46Command command = NIP46Command.nip04Decrypt(thirdPartyPubkey, ciphertext);
    var id = generate64RandomHexChars();
    Event event = await Nip46.encode(currentRemoteConnection!.remotePubkey, id, command,
        currentRemoteConnection!.clientPubkey!, currentRemoteConnection!.clientPrivkey!);
    NIP46CommandResult result = await sendToRemoteSigner(event, id);
    return result.result;
  }

  Future<String> sendNip44Encrypt(String thirdPartyPubkey, String plaintext) async {
    NIP46Command command = NIP46Command.nip44Encrypt(thirdPartyPubkey, plaintext);
    var id = generate64RandomHexChars();
    Event event = await Nip46.encode(currentRemoteConnection!.remotePubkey, id, command,
        currentRemoteConnection!.clientPubkey!, currentRemoteConnection!.clientPrivkey!);
    NIP46CommandResult result = await sendToRemoteSigner(event, id);
    return result.result;
  }

  Future<String> sendNip44Decrypt(String thirdPartyPubkey, String ciphertext) async {
    NIP46Command command = NIP46Command.nip44Decrypt(thirdPartyPubkey, ciphertext);
    var id = generate64RandomHexChars();
    Event event = await Nip46.encode(currentRemoteConnection!.remotePubkey, id, command,
        currentRemoteConnection!.clientPubkey!, currentRemoteConnection!.clientPrivkey!);
    NIP46CommandResult result = await sendToRemoteSigner(event, id);
    return result.result;
  }
}
