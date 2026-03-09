import 'dart:async';
import 'dart:convert';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:isar/isar.dart';
import 'package:http/http.dart' as http;

part 'messageDB_isar.g.dart';

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  template,
  encryptedImage,
  encryptedVideo,
  encryptedAudio,
  encryptedFile,
  system,
  call
}

extension MessageDBISARExtensions on MessageDBISAR {
  MessageDBISAR withGrowableLevels() => this
    ..reportList = reportList?.toList()
    ..reactionEventIds = reactionEventIds?.toList()
    ..zapEventIds = zapEventIds?.toList();
}

@collection
class MessageDBISAR {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String messageId; //event id

  String sender; // pubkey
  String receiver; // friend pubkey
  String groupId; // channel or group id
  String sessionId; // secret chat id
  int kind;
  String tags;
  String content; // content
  int createTime;
  bool read;
  String replyId;

  // additional,
  String decryptContent;
  String type;
  int? status; // 0 sending, 1 sent, 2 fail 3 recall

  List<String>? reportList; // hide message ids list, not save to DB

  String plaintEvent;

  /// add type
  int? chatType; // 0 private chat 1 group chat 2 channel chat 3 secret chat 4 relay group chat
  String? subType; // subtype of template/system type

  /// add previewData
  String? previewData;

  /// add disappearing time
  int? expiration;

  /// add decryptSecret
  String? decryptSecret;
  String? decryptNonce;
  String? decryptAlgo;
  // actions
  List<String>? reactionEventIds;
  List<String>? zapEventIds;

  String? giftwrappedEventId;
  String? giftwrappedEventJson;

  /// Custom emojis in message content (NIP-30)
  /// Stored as JSON string: {"shortcode1": "url1", "shortcode2": "url2"}
  String? emojiShortcodesJson;

  MessageDBISAR({
    this.messageId = '',
    this.sender = '',
    this.receiver = '',
    this.groupId = '',
    this.sessionId = '',
    this.kind = 0,
    this.tags = '',
    this.content = '',
    this.createTime = 0,
    this.read = false,
    this.replyId = '',
    this.decryptContent = '',
    this.type = 'text',
    this.status = 1,
    this.plaintEvent = '',
    this.chatType,
    this.subType,
    this.previewData,
    this.expiration,
    this.decryptSecret,
    this.decryptNonce,
    this.decryptAlgo,
    this.reactionEventIds,
    this.zapEventIds,
    this.giftwrappedEventId,
    this.giftwrappedEventJson,
    this.emojiShortcodesJson,
  });

  // Get emoji shortcodes as Map (NIP-30)
  @ignore
  Map<String, String> get emojiShortcodes {
    if (emojiShortcodesJson == null || emojiShortcodesJson!.isEmpty) {
      return {};
    }
    try {
      final decoded = jsonDecode(emojiShortcodesJson!);
      if (decoded is Map) {
        return Map<String, String>.from(decoded);
      }
    } catch (e) {
      // Invalid JSON, return empty map
    }
    return {};
  }

  static MessageDBISAR fromMap(Map<String, Object?> map) {
    return _messageInfoFromMap(map);
  }

  static String messageTypeToString(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.video:
        return 'video';
      case MessageType.audio:
        return 'audio';
      case MessageType.file:
        return 'file';
      case MessageType.template:
        return 'template';
      case MessageType.encryptedImage:
        return 'encryptedImage';
      case MessageType.encryptedVideo:
        return 'encryptedVideo';
      case MessageType.encryptedAudio:
        return 'encryptedAudio';
      case MessageType.encryptedFile:
        return 'encryptedFile';
      case MessageType.system:
        return 'system';
      case MessageType.call:
        return 'call';
      default:
        return 'text';
    }
  }

  static MessageType stringtoMessageType(String type) {
    switch (type) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'audio':
        return MessageType.audio;
      case 'file':
        return MessageType.file;
      case 'template':
        return MessageType.template;
      case 'encryptedImage':
        return MessageType.encryptedImage;
      case 'encryptedVideo':
        return MessageType.encryptedVideo;
      case 'encryptedAudio':
        return MessageType.encryptedAudio;
      case 'encryptedFile':
        return MessageType.encryptedFile;
      case 'system':
        return MessageType.system;
      case 'call':
        return MessageType.call;
      default:
        return MessageType.text;
    }
  }

  static bool isImageBase64(String str) {
    final base64Pattern = r'^data:image\/[a-zA-Z0-9\+\-\.]+;base64,';
    if (RegExp(base64Pattern).hasMatch(str)) {
      final base64Data = str.split(',').last;
      return _isValidBase64(base64Data);
    }
    return false;
  }

  static bool _isValidBase64(String str) {
    final base64RegExp = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return base64RegExp.hasMatch(str);
  }

  static Future<MessageType> identifyUrl(String urlString) async {
    final Uri uri;
    if (isImageBase64(urlString)) return MessageType.image;
    
    // Don't try to parse emoji shortcodes or other non-URL text as URLs (NIP-30)
    final emojiPattern = RegExp(r'^:[a-zA-Z0-9_]+:$');
    if (emojiPattern.hasMatch(urlString)) {
      return MessageType.text;
    }
    
    try {
      uri = Uri.parse(urlString);
      if (uri.host.isEmpty) return MessageType.text;
    } catch (e) {
      // Silently return text type for invalid URIs instead of printing errors
      // Common cases: emoji shortcodes, plain text, etc.
      return MessageType.text;
    }

    final String path = uri.path.toLowerCase();
    final String? mimeType = uri.queryParameters['m']?.toLowerCase();

    if (path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.gif') ||
        path.endsWith('.bmp') ||
        path.endsWith('.svg') ||
        path.endsWith('.webp') ||
        path.endsWith('.heic')) {
      return MessageType.image;
    } else if (path.endsWith('.mp3') ||
        path.endsWith('.wav') ||
        path.endsWith('.flac') ||
        path.endsWith('.m4a') ||
        path.endsWith('.aac') ||
        path.endsWith('.ogg')) {
      return MessageType.audio;
    } else if (path.endsWith('.mp4') ||
        path.endsWith('.avi') ||
        path.endsWith('.mov') ||
        path.endsWith('.flv') ||
        path.endsWith('.wmv') ||
        path.endsWith('.mkv') ||
        path.endsWith('.webm')) {
      return MessageType.video;
    }
    // else if (path.endsWith('.pdf') ||
    //     path.endsWith('.doc') ||
    //     path.endsWith('.docx') ||
    //     path.endsWith('.xls') ||
    //     path.endsWith('.xlsx') ||
    //     path.endsWith('.ppt') ||
    //     path.endsWith('.pptx') ||
    //     path.endsWith('.txt') ||
    //     path.endsWith('.csv')) {
    //   return MessageType.file;
    // }

    if (mimeType != null) {
      if (mimeType.startsWith('image/')) {
        return MessageType.image;
      } else if (mimeType.startsWith('audio/')) {
        return MessageType.audio;
      } else if (mimeType.startsWith('video/')) {
        return MessageType.video;
      }
      // else if (mimeType.startsWith('application/')) {
      //   return MessageType.file;
      // }
    }

    if (uri.queryParameters.containsKey('blurhash')) {
      return MessageType.image;
    }

    try {
      final response = await http.head(uri);
      final contentType = response.headers['content-type'];

      if (contentType != null) {
        if (contentType.startsWith('image/')) {
          return MessageType.image;
        } else if (contentType.startsWith('audio/')) {
          return MessageType.audio;
        } else if (contentType.startsWith('video/')) {
          return MessageType.video;
        }
        // else if (contentType.startsWith('application/')) {
        //   return MessageType.file;
        // }
      }
    } catch (e) {
      print(e);
    }

    return MessageType.text;
  }

  static Future<Map<String, dynamic>> decodeContent(String content) async {
    var result =
        await ThreadPoolManager.sharedInstance.runOtherTask(() => _decodeContentInIsolate(content));
    return result;
  }

  static Future<Map<String, dynamic>> _decodeContentInIsolate(String content) async {
    content = content.trim();
    try {
      Map<String, dynamic> map = jsonDecode(content);
      if (map.containsKey('contentType') && map.containsKey('content')) {
        String type = map['contentType'];
        if (type == 'text' ||
            type == 'image' ||
            type == 'video' ||
            type == 'audio' ||
            type == 'file' ||
            type == 'template' ||
            type == 'encryptedImage' ||
            type == 'encryptedVideo' ||
            type == 'encryptedAudio' ||
            type == 'encryptedFile' ||
            type == 'system' ||
            type == 'call') return map;
      }
      return {'contentType': 'text', 'content': content};
    } catch (e) {
      LogUtils.v(() => 'decodeContent fail: $content, error msg: ${e.toString()}');
      
      // Check if content is emoji shortcode (NIP-30) - format: :shortcode:
      // If so, treat as text and don't try to parse as URL
      final emojiPattern = RegExp(r'^:[a-zA-Z0-9_]+:$');
      if (emojiPattern.hasMatch(content)) {
        return {'contentType': 'text', 'content': content};
      }
      
      // Check if content looks like a URL before trying to parse it
      // Only try to identify URL if content matches common URL patterns
      final urlPattern = RegExp(
        r'^(https?:\/\/|www\.|[a-zA-Z0-9-]+\.[a-zA-Z]{2,})',
        caseSensitive: false,
      );
      
      // If content doesn't look like a URL at all, treat as text
      if (!urlPattern.hasMatch(content)) {
        return {'contentType': 'text', 'content': content};
      }
      
      // Only call identifyUrl for content that looks like it could be a URL
      MessageType type = await identifyUrl(content).timeout(
        Duration(seconds: 1),
        onTimeout: () {
          return MessageType.text;
        },
      );
      return {'contentType': messageTypeToString(type), 'content': content};
    }
  }

  static String getContent(MessageType type, String content, String? source) {
    if (source != null && source.isNotEmpty == true) return source;
    switch (type) {
      case MessageType.text:
      case MessageType.image:
      case MessageType.video:
      case MessageType.audio:
      case MessageType.encryptedImage:
      case MessageType.encryptedVideo:
      case MessageType.encryptedAudio:
      case MessageType.encryptedFile:
        return content;
      case MessageType.file:
        return '[You\'ve received a file via 0xChat!]';
      case MessageType.template:
        if (Zaps.isLightningInvoice(content) || getNostrScheme(content) != null) {
          return content;
        }
        return '[You\'ve received a template via 0xChat!]';
      // case MessageType.encryptedImage:
      //   return '[You\'ve received an end-to-end encrypted image via 0xChat!]';
      // case MessageType.encryptedVideo:
      //   return '[You\'ve received an end-to-end encrypted video via 0xChat!]';
      // case MessageType.encryptedAudio:
      //   return '[You\'ve received an end-to-end encrypted audio via 0xChat!]';
      // case MessageType.encryptedFile:
      //   return '[You\'ve received an end-to-end encrypted file via 0xChat!]';
      case MessageType.system:
        return '[You\'ve received a system message via 0xChat!]';
      case MessageType.call:
        return '[You\'ve received a call via 0xChat!]';
      default:
        return content;
    }
  }

  static String? getSubContent(MessageType type, String content) {
    switch (type) {
      case MessageType.text:
      case MessageType.image:
      case MessageType.video:
      case MessageType.audio:
      case MessageType.encryptedImage:
      case MessageType.encryptedVideo:
      case MessageType.encryptedAudio:
      case MessageType.encryptedFile:
        return null;
      case MessageType.file:
      case MessageType.template:
      case MessageType.system:
      case MessageType.call:
        return jsonEncode({'contentType': messageTypeToString(type), 'content': content});
      default:
        return null;
    }
  }

  static String mimeTypeToTpyeString(String mimeType) {
    if (mimeType.startsWith('image/')) {
      return 'encryptedImage';
    } else if (mimeType.startsWith('audio/')) {
      return 'encryptedAudio';
    } else if (mimeType.startsWith('video/')) {
      return 'encryptedVideo';
    }
    return 'encryptedFile';
  }

  static String tpyeStringToMimeType(MessageType type) {
    if (type == MessageType.encryptedImage) {
      return 'image/png';
    } else if (type == MessageType.encryptedAudio) {
      return 'audio/mp3';
    } else if (type == MessageType.encryptedVideo) {
      return 'video/mp4';
    }
    return '';
  }

  static Future<MessageDBISAR?> fromPrivateMessage(Event event, String receiver, String privkey,
      {int chatType = 0, String? privateGroupId}) async {
    EDMessage? message;
    if (event.kind == 4) {
      message = await Contacts.sharedInstance.decodeNip4Event(event, receiver, privkey);
    } else if (event.kind == 44) {
      message = await Contacts.sharedInstance.decodeNip44Event(event, receiver, privkey);
    } else if (event.kind == 14 || event.kind == 15) {
      message = await Contacts.sharedInstance.decodeKind14Event(event, receiver);
      if (message?.groupId?.isNotEmpty == true) {
        Groups.sharedInstance.createPrivateGroup(
            message!.sender, message.groupId!, message.subject, message.members,
            createAt: event.createdAt);
        chatType = 1;
      }
    }
    if (message == null) return null;
    MessageDBISAR messageDB = MessageDBISAR(
        messageId: event.id,
        sender: message.sender,
        receiver: message.receiver,
        groupId: privateGroupId ?? message.groupId ?? '',
        kind: event.kind,
        tags: jsonEncode(event.tags),
        content: message.content,
        createTime: event.createdAt,
        replyId: message.replyId,
        plaintEvent: jsonEncode(event),
        chatType: chatType,
        expiration: message.expiration == null ? null : int.parse(message.expiration!),
        decryptAlgo: message.algorithm,
        decryptNonce: message.nonce,
        decryptSecret: message.secret);
    var map = await decodeContent(message.content);
    messageDB.decryptContent = map['content'];
    messageDB.type = map['contentType'];
    if (map['decryptSecret'] != null) {
      messageDB.decryptSecret = map['decryptSecret'];
    }
    if (message.mimeType != null) {
      messageDB.type = mimeTypeToTpyeString(message.mimeType!);
    }
    return messageDB;
  }

  static Future<void> savePreviewData(String messageId, String previewData) async {
    final isar = DBISAR.sharedInstance.isar;

    final message = await isar.messageDBISARs.filter().messageIdEqualTo(messageId).findFirst();

    if (message != null) {
      message.previewData = previewData;
      await DBISAR.sharedInstance.saveToDB(message);
    }
  }

  static String? getNostrScheme(String content) {
    final regexNostr = r'((nostr:)?(npub|note|nprofile|nevent|nrelay|naddr)[0-9a-zA-Z]+)';
    final urlRegexp = RegExp(regexNostr);
    final match = urlRegexp.firstMatch(content);
    return match?.group(0);
  }
}

MessageDBISAR _messageInfoFromMap(Map<String, dynamic> map) {
  return MessageDBISAR(
    messageId: map['messageId'].toString(),
    sender: map['sender'].toString(),
    receiver: map['receiver'].toString(),
    groupId: map['groupId'].toString(),
    sessionId: map['sessionId'].toString(),
    kind: map['kind'],
    tags: map['tags'].toString(),
    content: map['content'].toString(),
    createTime: map['createTime'],
    read: map['read'],
    replyId: map['replyId'].toString(),
    decryptContent: map['decryptContent'].toString(),
    type: map['type'],
    status: map['status'],
    plaintEvent: map['plaintEvent'].toString(),
    chatType: map['chatType'],
    subType: map['subType']?.toString(),
    previewData: map['previewData']?.toString(),
    expiration: map['expiration'],
    decryptSecret: map['decryptSecret']?.toString(),
    reactionEventIds: UserDBISAR.decodeStringList(map['reactionEventIds'].toString()),
    zapEventIds: UserDBISAR.decodeStringList(map['zapEventIds'].toString()),
    giftwrappedEventId: map['giftwrappedEventId']?.toString(),
    giftwrappedEventJson: map['giftwrappedEventJson']?.toString(),
  );
}
