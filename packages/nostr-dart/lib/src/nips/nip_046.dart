import 'dart:convert';
import 'dart:core';
import 'package:nostr_core_dart/nostr.dart';

class Nip46 {
  static String createNostrConnectUrl({
    required String clientPubKey,
    required String secret,
    required List<String> relays,
    String? perms,
    String? name,
    String? url,
    String? image,
  }) {
    Uri uri = Uri.parse('nostrconnect://$clientPubKey');

    Map<String, String> queryParams = {
      'relay': relays.map((e) => e).join('&relay='),
      'secret': secret,
    };

    if (perms != null && perms.isNotEmpty) {
      queryParams['perms'] = perms;
    }
    if (name != null) {
      queryParams['name'] = name;
    }
    if (url != null) {
      queryParams['url'] = url;
    }
    if (image != null) {
      queryParams['image'] = image;
    }

    uri = uri.replace(queryParameters: queryParams);
    return uri.toString();
  }

  static RemoteSignerConnection parseNostrConnectUri(String uri) {
    uri = Uri.decodeComponent(uri);
    RemoteSignerConnection remoteSignerConnection = RemoteSignerConnection('', [], null);

    if (!uri.startsWith('nostrconnect://')) {
      throw ArgumentError('Invalid nostr connect URI format.');
    }

    final parts = uri.substring(9).split('?');
    if (parts.isEmpty || parts[0].isEmpty) {
      throw ArgumentError('Missing remote signer pubkey.');
    }
    remoteSignerConnection.clientPubkey = parts[0];

    if (parts.length > 1) {
      final queryParams = parts[1].split('&');
      for (var param in queryParams) {
        final keyValue = param.split('=');
        if (keyValue.length == 2) {
          final key = keyValue[0];
          final value = keyValue[1];

          if (key == 'relay') {
            remoteSignerConnection.relays.add(value);
          }
          if (key == 'secret') {
            remoteSignerConnection.secret = value;
          }
        }
      }
    }

    return remoteSignerConnection;
  }

  static RemoteSignerConnection parseBunkerUri(String uri) {
    uri = Uri.decodeComponent(uri);

    RemoteSignerConnection remoteSignerConnection = RemoteSignerConnection('', [], null);

    if (!uri.startsWith('bunker://')) {
      throw ArgumentError('Invalid bunker URI format.');
    }

    final parts = uri.substring(9).split('?');
    if (parts.isEmpty || parts[0].isEmpty) {
      throw ArgumentError('Missing remote signer pubkey.');
    }
    remoteSignerConnection.remotePubkey = parts[0];

    if (parts.length > 1) {
      final queryParams = parts[1].split('&');
      for (var param in queryParams) {
        final keyValue = param.split('=');
        if (keyValue.length == 2) {
          final key = keyValue[0];
          final value = keyValue[1];

          if (key == 'relay') {
            remoteSignerConnection.relays.add(value);
          }
          if (key == 'secret') {
            remoteSignerConnection.secret = value;
          }
        }
      }
    }

    return remoteSignerConnection;
  }

  static String generateNostrConnectUri({
    required String clientPubkey,
    required List<String> relays,
    required Map<String, dynamic> metadata,
    required String secret,
  }) {
    if (clientPubkey.isEmpty) {
      throw ArgumentError('Client public key cannot be empty.');
    }
    if (relays.isEmpty) {
      throw ArgumentError('At least one relay must be provided.');
    }
    if (metadata.isEmpty) {
      throw ArgumentError('Metadata cannot be empty.');
    }
    if (secret.isEmpty) {
      throw ArgumentError('Secret cannot be empty.');
    }

    final encodedMetadata = Uri.encodeComponent(metadataToJson(metadata));

    final relayParams = relays.map((relay) => 'relay=$relay').join('&');

    return 'nostrconnect://$clientPubkey?$relayParams&metadata=$encodedMetadata&secret=$secret';
  }

  static String metadataToJson(Map<String, dynamic> metadata) {
    try {
      return const JsonEncoder().convert(metadata);
    } catch (e) {
      throw ArgumentError('Invalid metadata format: $e');
    }
  }

  static Future<Event> encode(
      String remoteSigner, String id, NIP46Command command, String pubkey, String privkey) async {
    var content = {'id': id, 'method': command.type.toValue(), 'params': command.params};
    var encryptedContent =
        await Nip44.encryptContent(jsonEncode(content), remoteSigner, pubkey, privkey);
    return Event.from(
        kind: 24133,
        tags: [
          ["p", remoteSigner]
        ],
        content: encryptedContent,
        pubkey: pubkey,
        privkey: privkey);
  }

  static Future<NIP46CommandResult> decode(Event event, String myPubkey, String privkey) async {
    if (event.kind == 24133) {
      String encryptedContent = event.content;
      int ivIndex = encryptedContent.indexOf("?iv=");
      String content;
      if (ivIndex <= 0) {
        content = await Nip44.decryptContent(encryptedContent, event.pubkey, myPubkey, privkey);
      } else {
        content = await Nip4.decryptContent(encryptedContent, event.pubkey, myPubkey, privkey);
      }
      return NIP46CommandResult.fromJson(jsonDecode(content));
    }
    throw Exception("${event.kind} is not nip46 compatible");
  }
}

class RemoteSignerConnection {
  String remotePubkey;
  List<String> relays;
  String? secret;
  String? clientPubkey;
  String? clientPrivkey;

  RemoteSignerConnection(this.remotePubkey, this.relays, this.secret);
}

enum CommandType {
  connect,
  sign_event,
  ping,
  get_relays,
  get_public_key,
  nip04_encrypt,
  nip04_decrypt,
  nip44_encrypt,
  nip44_decrypt,
}

extension CommandTypeExtension on CommandType {
  String toValue() {
    return toString().split('.').last;
  }
}

class NIP46Command {
  final CommandType type;
  final List<dynamic> params;

  NIP46Command({
    required this.type,
    required this.params,
  });

  // Factory constructors for each command type for better usability
  factory NIP46Command.connect(
    String remoteSignerPubkey, [
    String? optionalSecret,
    String? optionalRequestedPermissions,
  ]) {
    return NIP46Command(
      type: CommandType.connect,
      params: [remoteSignerPubkey, optionalSecret, optionalRequestedPermissions],
    );
  }

  factory NIP46Command.signEvent(String eventString) {
    return NIP46Command(
      type: CommandType.sign_event,
      params: [eventString],
    );
  }

  factory NIP46Command.ping() {
    return NIP46Command(
      type: CommandType.ping,
      params: [],
    );
  }

  factory NIP46Command.getRelays() {
    return NIP46Command(
      type: CommandType.get_relays,
      params: [],
    );
  }

  factory NIP46Command.getPublicKey() {
    return NIP46Command(
      type: CommandType.get_public_key,
      params: [],
    );
  }

  factory NIP46Command.nip04Encrypt(String thirdPartyPubkey, String plaintext) {
    return NIP46Command(
      type: CommandType.nip04_encrypt,
      params: [thirdPartyPubkey, plaintext],
    );
  }

  factory NIP46Command.nip04Decrypt(String thirdPartyPubkey, String ciphertext) {
    return NIP46Command(
      type: CommandType.nip04_decrypt,
      params: [thirdPartyPubkey, ciphertext],
    );
  }

  factory NIP46Command.nip44Encrypt(String thirdPartyPubkey, String plaintext) {
    return NIP46Command(
      type: CommandType.nip44_encrypt,
      params: [thirdPartyPubkey, plaintext],
    );
  }

  factory NIP46Command.nip44Decrypt(String thirdPartyPubkey, String ciphertext) {
    return NIP46Command(
      type: CommandType.nip44_decrypt,
      params: [thirdPartyPubkey, ciphertext],
    );
  }
}

class NIP46CommandResult {
  final String id;
  final CommandType? command;
  final dynamic result;
  final String? error;

  NIP46CommandResult({
    required this.id,
    this.command,
    this.result,
    this.error,
  });

  static NIP46CommandResult fromResponse(
    String id,
    CommandType command,
    dynamic response, [
    String? error,
  ]) {
    if (error != null) {
      return NIP46CommandResult(id: id, command: command, error: error);
    }

    switch (command) {
      case CommandType.connect:
        if (response is String && (response == "ack" || response.isNotEmpty)) {
          return NIP46CommandResult(id: id, command: command, result: response);
        }
        break;

      case CommandType.sign_event:
        if (response is String) {
          return NIP46CommandResult(
              id: id, command: command, result: response); // JSON Stringified event
        }
        break;

      case CommandType.ping:
        if (response == "pong") {
          return NIP46CommandResult(id: id, command: command, result: response);
        }
        break;

      case CommandType.get_relays:
        if (response is Map<String, Map<String, bool>>) {
          return NIP46CommandResult(id: id, command: command, result: response);
        }
        break;

      case CommandType.get_public_key:
        if (response is String) {
          return NIP46CommandResult(id: id, command: command, result: response);
        }
        break;

      case CommandType.nip04_encrypt:
      case CommandType.nip44_encrypt:
        if (response is String) {
          return NIP46CommandResult(id: id, command: command, result: response); // Ciphertext
        }
        break;

      case CommandType.nip04_decrypt:
      case CommandType.nip44_decrypt:
        if (response is String) {
          return NIP46CommandResult(id: id, command: command, result: response); // Plaintext
        }
        break;
    }

    throw Exception("Invalid response for command $command: $response");
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "command": command.toString().split('.').last,
      "result": result,
      "error": error,
    };
  }

  factory NIP46CommandResult.fromJson(Map<String, dynamic> json) {
    return NIP46CommandResult(
      id: json['id'],
      result: json['result'],
      error: json['error'],
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
