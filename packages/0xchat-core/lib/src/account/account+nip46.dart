import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';

/// How long to wait for a relay of the remote signer to become reachable.
const Duration _nip46RelayConnectTimeout = Duration(seconds: 30);

/// How long to wait for the remote signer to answer a command.
const Duration _nip46CommandTimeout = Duration(seconds: 60);

/// How long to wait once the signer replied with an `auth_url`, the user has to
/// authorize the request in a browser before the real answer shows up.
const Duration _nip46AuthTimeout = Duration(minutes: 3);

extension AccountNIP46 on Account {
  Future<bool> _checkNIP46Pubkey(String pubkey) async {
    if (me == null || me?.remoteSignerURI == null) return false;
    OKEvent connectResult = await connectToRemoteSigner(me!.remoteSignerURI!, true, pubkey);
    if (!connectResult.status) {
      LogUtils.e(() => 'check NIP46 pubkey failed: ${connectResult.message}');
      return false;
    }
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
    OKEvent connectResult = await connectToRemoteSigner(uri, false, '');
    if (!connectResult.status) {
      LogUtils.e(() => 'login with bunker URI failed: ${connectResult.message}');
      return null;
    }
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
    _replaceNIP46ConnectStatusListener((relay, status, relayKinds) async {
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
    // The user has to approve the pairing in the signer, but the wait still
    // has to end: without a deadline the caller spins forever.
    _startNIP46CommandTimeout(secret, _nip46AuthTimeout);
    NIP46CommandResult connectResult = await completer.future;
    if (connectResult.error != null) {
      LogUtils.e(() => 'nostr connect failed: ${connectResult.error}');
      nip46connectionStatusCallback?.call(NIP46ConnectionStatus.disconnected);
      return '';
    }
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

  /// Connects to the remote signer described by [uri].
  ///
  /// The returned [OKEvent] tells whether the signer is usable, callers must
  /// not keep talking to it when the status is false. Every wait in here is
  /// bounded: a relay or a signer that never answers ends up as a failed
  /// OKEvent instead of a future that never completes.
  Future<OKEvent> connectToRemoteSigner(String uri, bool autoLogin, String remotePubkey) async {
    late RemoteSignerConnection remoteSignerConnection;
    if (uri.startsWith('bunker://')) {
      remoteSignerConnection = Nip46.parseBunkerUri(uri);
    } else if (uri.startsWith('nostrconnect://')) {
      remoteSignerConnection = Nip46.parseNostrConnectUri(uri);
    } else {
      return OKEvent(uri, false, 'unsupported remote signer URI');
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
    if (remoteSignerConnection.relays.isEmpty) {
      return OKEvent(uri, false, 'the remote signer URI contains no relay');
    }

    Completer<String> relayConnected = Completer<String>();
    void handleRelayConnected(String relay) {
      nip46connectionStatusCallback?.call(NIP46ConnectionStatus.connected);
      updateNIP46Subscription(relay: relay, connection: currentRemoteConnection);
      if (autoLogin) {
        for (var event in unsentNIP46EventQueue) {
          Connect.sharedInstance.sendEvent(event, toRelays: currentRemoteConnection!.relays);
        }
        unsentNIP46EventQueue.clear();
      }
      if (!relayConnected.isCompleted) {
        relayConnected.complete(relay);
      } else if (!autoLogin) {
        // Reconnected after the initial handshake, re-announce this client.
        sendConnect();
      }
    }

    // Only one remote signer connection is active at a time, so drop the
    // listener of the previous one instead of piling them up: a stale listener
    // keeps talking to the signer of an account that is no longer logged in.
    _replaceNIP46ConnectStatusListener((relay, status, relayKinds) async {
      if (!remoteSignerConnection.relays.contains(relay)) return;
      if (status == 1) {
        handleRelayConnected(relay);
      } else {
        // lost connection
        nip46connectionStatusCallback?.call(NIP46ConnectionStatus.disconnected);
      }
    });

    await Connect.sharedInstance
        .connectRelays(remoteSignerConnection.relays, relayKind: RelayKind.remoteSigner);

    // Connect.connect() returns without reporting a status change when the
    // socket is already open, which is the common case when another account is
    // logged in on the same relay. Nothing would ever complete the wait below.
    if (!relayConnected.isCompleted) {
      for (var relay in remoteSignerConnection.relays) {
        if (Connect.sharedInstance.webSockets[relay]?.connectStatus == 1) {
          handleRelayConnected(relay);
          break;
        }
      }
    }

    String connectedRelay =
        await relayConnected.future.timeout(_nip46RelayConnectTimeout, onTimeout: () => '');
    if (connectedRelay.isEmpty) {
      nip46connectionStatusCallback?.call(NIP46ConnectionStatus.disconnected);
      return OKEvent(uri, false, 'timed out connecting to the remote signer relay');
    }

    if (!autoLogin) {
      NIP46CommandResult result = await sendConnectCommand();
      if (result.error != null) {
        return OKEvent(uri, false, result.error!);
      }
      if (result.result != 'ack') {
        // Not every signer answers the connect command with an ack, the real
        // gate is whether it hands out the public key afterwards.
        LogUtils.e(() => 'remote signer answered connect with ${result.result}');
      }
    }
    return OKEvent(uri, true, '');
  }

  /// Drops the commands pending on the remote signer.
  ///
  /// Called on logout: the signer of the account that is going away will never
  /// answer them, so they are failed right away instead of being left hanging
  /// until their deadline, and no queued command is replayed to the signer of
  /// whichever account is logged in next.
  void resetNIP46State() {
    for (var timer in nip46CommandTimers.values) {
      timer.cancel();
    }
    nip46CommandTimers.clear();
    for (var entry in resultCompleters.entries) {
      if (!entry.value.isCompleted) {
        entry.value.complete(NIP46CommandResult(id: entry.key, error: 'logged out'));
      }
    }
    resultCompleters.clear();
    unsentNIP46EventQueue.clear();
  }

  /// Registers [listener] as the only connection status listener of the remote
  /// signer, removing the one registered by a previous connection.
  void _replaceNIP46ConnectStatusListener(ConnectStatusCallBack listener) {
    ConnectStatusCallBack? previous = nip46ConnectStatusListener;
    if (previous != null) {
      Connect.sharedInstance.removeConnectStatusListener(previous);
    }
    nip46ConnectStatusListener = listener;
    Connect.sharedInstance.addConnectStatusListener(listener);
  }

  /// Fails the pending command [id] after [duration] so that a signer that
  /// never answers surfaces an error instead of blocking its caller forever.
  void _startNIP46CommandTimeout(String id, Duration duration, {void Function()? onTimeout}) {
    nip46CommandTimers.remove(id)?.cancel();
    nip46CommandTimers[id] = Timer(duration, () {
      nip46CommandTimers.remove(id);
      Completer<NIP46CommandResult>? completer = resultCompleters.remove(id);
      if (completer == null || completer.isCompleted) return;
      onTimeout?.call();
      LogUtils.e(() => 'remote signer command $id timed out');
      completer.complete(
          NIP46CommandResult(id: id, error: 'the remote signer did not respond in time'));
    });
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
            // The real answer only arrives once the user authorized the request
            // in a browser, so give the command a longer deadline.
            if (resultCompleters.containsKey(result.id)) {
              _startNIP46CommandTimeout(result.id, _nip46AuthTimeout);
            }
            return;
          }
          String resultId = result.id;
          if (result.result == connection.secret) {
            LogUtils.v(() => 'nostr connect success... ${result.toString()}');
            resultId = result.result;
            connection.remotePubkey = event.pubkey;
          }
          nip46CommandTimers.remove(resultId)?.cancel();
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
    _startNIP46CommandTimeout(id, _nip46CommandTimeout, onTimeout: () {
      // Drop the event so a later connection does not replay a dead command.
      unsentNIP46EventQueue.remove(event);
    });
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

  Future<NIP46CommandResult> sendConnectCommand() async {
    NIP46Command command = NIP46Command.connect(currentRemoteConnection!.remotePubkey,
        currentRemoteConnection!.secret, SignerPermissionModel.defaultPermissionsForNIP46());
    var id = generate64RandomHexChars();
    Event event = await Nip46.encode(currentRemoteConnection!.remotePubkey, id, command,
        currentRemoteConnection!.clientPubkey!, currentRemoteConnection!.clientPrivkey!);
    return await sendToRemoteSigner(event, id);
  }

  Future<bool> sendConnect() async {
    NIP46CommandResult result = await sendConnectCommand();
    if (result.result != 'ack') {
      LogUtils.e(() => 'sendConnect connected false: ${result.error ?? result.result}');
      return false;
    }
    LogUtils.v(() => 'sendConnect connected success');
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
