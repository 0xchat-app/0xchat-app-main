
import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';
import 'package:ox_common/utils/string_utils.dart';

extension CustomMessageEx on types.CustomMessage {

  static const metaTypeKey = 'type';
  static const metaContentKey = 'content';

  CustomMessageType? get customType =>
      CustomMessageTypeEx.fromValue(metadata?[CustomMessageEx.metaTypeKey]);

  static Map<String, dynamic> zapsMetaData({
    required String zapper,
    required String invoice,
    required String amount,
    required String description,
  }) {
    return _metaData(CustomMessageType.zaps, {
      'zapper': zapper,
      'invoice': invoice,
      'amount': amount,
      'description': description,
    });
  }

  static Map<String, dynamic> callMetaData({
    required String text,
    required CallMessageType type,
  }) {
    return _metaData(CustomMessageType.call, {
      'text': text,
      'type': type.value,
    });
  }

  static Map<String, dynamic> templateMetaData({
    required String title,
    required String content,
    required String icon,
    required String link,
  }) {
    return _metaData(CustomMessageType.template, {
      'title': title,
      'content': content,
      'icon': icon,
      'link': link,
    });
  }

  static Map<String, dynamic> noteMetaData({
    required String authorIcon,
    required String authorName,
    required String authorDNS,
    required String createTime,
    required String note,
    required String image,
    required String link,
  }) {
    return _metaData(CustomMessageType.note, {
      'authorIcon': authorIcon,
      'authorName': authorName,
      'authorDNS': authorDNS,
      'createTime': createTime,
      'note': note,
      'image': image,
      'link': link,
    });
  }

  static Map<String, dynamic> ecashMetaData({
    required List<String> tokenList,
    String isOpened = '',
  }) {
    return _metaData(CustomMessageType.ecash, {
      EcashMessageEx.metaTokenListKey: tokenList,
      EcashMessageEx.metaIsOpenedKey: isOpened,
    });
  }

  static Map<String, dynamic> ecashV2MetaData({
    required List<String> tokenList,
    List<String> receiverPubkeys = const [],
    List<EcashSignee> signees = const [],
    String validityDate = '',
    String isOpened = '',
  }) {
    return _metaData(CustomMessageType.ecashV2, {
      EcashV2MessageEx.metaTokenListKey: tokenList,
      EcashV2MessageEx.metaIsOpenedKey: isOpened,
      if (receiverPubkeys.isNotEmpty)
        EcashV2MessageEx.metaReceiverPubkeysKey: receiverPubkeys,
      if (signees.isNotEmpty)
        EcashV2MessageEx.metaSigneesKey: signees.map((e) => {
          EcashV2MessageEx.metaSigneesPubkeyKey: e.$1,
          EcashV2MessageEx.metaSigneesSignatureKey: e.$2,
        }).toList(),
      if (validityDate.isNotEmpty)
        EcashV2MessageEx.metaValidityDateKey: validityDate,
    });
  }

  static Map<String, dynamic> imageSendingMetaData({
    String fileId = '',
    String path = '',
    String url = '',
    int? width,
    int? height,
    String? encryptedKey,
  }) {
    return _metaData(CustomMessageType.imageSending, {
      ImageSendingMessageEx.metaFileIdKey: fileId,
      ImageSendingMessageEx.metaPathKey: path,
      ImageSendingMessageEx.metaURLKey: url,
      if (width != null)
        ImageSendingMessageEx.metaWidthKey: width,
      if (height != null)
        ImageSendingMessageEx.metaHeightKey: height,
      ImageSendingMessageEx.metaEncryptedKey: encryptedKey,
    });
  }

  static Map<String, dynamic> videoMetaData({
    required String fileId,
    String snapshotPath = '',
    String videoPath = '',
    String url = '',
    int? width,
    int? height,
    String? encryptedKey,
  }) {
    return _metaData(CustomMessageType.video, {
      VideoMessageEx.metaFileIdKey: fileId,
      VideoMessageEx.metaSnapshotPathKey: snapshotPath,
      VideoMessageEx.metaVideoPathKey: videoPath,
      VideoMessageEx.metaURLKey: url,
      if (width != null)
        VideoMessageEx.metaWidthKey: width,
      if (height != null)
        VideoMessageEx.metaHeightKey: height,
    });
  }

  static Map<String, dynamic> _metaData(
    CustomMessageType type,
    Map<String, dynamic> content,
  ) {
    return {
      CustomMessageEx.metaTypeKey: type.value,
      CustomMessageEx.metaContentKey: content,
    };
  }

  String get customContentString {
    try {
      return jsonEncode(metadata ?? {});
    } catch(e) {
      return '';
    }
  }
}

extension ZapsMessageEx on types.CustomMessage {
  String get zapper => metadata?[CustomMessageEx.metaContentKey]?['zapper'] ?? '';
  String get invoice => metadata?[CustomMessageEx.metaContentKey]?['invoice'] ?? '';
  int get amount => int.tryParse(metadata?[CustomMessageEx.metaContentKey]?['amount'] ?? '') ?? 0;
  String get description => metadata?[CustomMessageEx.metaContentKey]?['description'] ?? '';
}

extension CallMessageEx on types.CustomMessage {
  String get callText => metadata?[CustomMessageEx.metaContentKey]?['text'] ?? '';
  CallMessageType? get callType => CallMessageTypeEx.fromValue(metadata?[CustomMessageEx.metaContentKey]?['type']);
}

extension TemplateMessageEx on types.CustomMessage {
  String get title => metadata?[CustomMessageEx.metaContentKey]?['title'] ?? '';
  String get content => metadata?[CustomMessageEx.metaContentKey]?['content'] ?? '';
  String get icon => metadata?[CustomMessageEx.metaContentKey]?['icon'] ?? '';
  String get link => metadata?[CustomMessageEx.metaContentKey]?['link'] ?? '';
}

extension NoteMessageEx on types.CustomMessage {
  String get authorIcon => metadata?[CustomMessageEx.metaContentKey]?['authorIcon'] ?? '';
  String get authorName => metadata?[CustomMessageEx.metaContentKey]?['authorName'] ?? '';
  String get authorDNS => metadata?[CustomMessageEx.metaContentKey]?['authorDNS'] ?? '';
  int get createTime => int.tryParse(metadata?[CustomMessageEx.metaContentKey]?['createTime'] ?? '') ?? 0;
  String get note => metadata?[CustomMessageEx.metaContentKey]?['note'] ?? '';
  String get image => metadata?[CustomMessageEx.metaContentKey]?['image'] ?? '';
  String get link => metadata?[CustomMessageEx.metaContentKey]?['link'] ?? '';
}

extension EcashMessageEx on types.CustomMessage {

  static const metaTokenListKey = 'tokenList';
  static const metaIsOpenedKey = 'isOpened';
  static const metaMemoKey = 'memo';
  static const metaAmountKey = 'amount';
  static const metaValidityDateKey = 'validityDate';

  /// MetaData Format Example:
  /// {
  ///   'type': CustomMessageType.ecash.value,
  ///   'content':
  ///   {
  ///     'tokenList':
  ///     [
  ///       ...
  ///     ],
  ///     'isOpened': 'true',
  ///     'memo': 'xxxxx',    // temp
  ///     'amount': '21',     // temp
  ///   },
  /// }

  static updateDetailInfo(Map? metadata) {
    final tokenList = getTokenListWithMetadata(metadata);
    if (tokenList.isEmpty) return ;

    var memoStr = '';
    final totalAmount = tokenList.fold(0, (pre, token) {
      final info = Cashu.infoOfToken(token);
      if (info == null) return pre;
      memoStr = info.memo;
      return pre + info.amount;
    });

    metadata?[CustomMessageEx.metaContentKey]?[EcashMessageEx.metaMemoKey] = memoStr;
    metadata?[CustomMessageEx.metaContentKey]?[EcashMessageEx.metaAmountKey] = totalAmount.toString();
  }

  static List<String> getTokenListWithMetadata(Map? metadata) =>
      metadata?[CustomMessageEx.metaContentKey]?[EcashMessageEx.metaTokenListKey] ?? [];

  static String getDescriptionWithMetadata(Map? metadata) {
    final amount = metadata?[CustomMessageEx.metaContentKey]?[EcashMessageEx.metaMemoKey];
    if (amount == null) {
      EcashMessageEx.updateDetailInfo(metadata);
    }
    return metadata?[CustomMessageEx.metaContentKey]?[EcashMessageEx.metaMemoKey] ?? '';
  }

  static int getAmountWithMetadata(Map? metadata) {
    final amount = metadata?[CustomMessageEx.metaContentKey]?[EcashMessageEx.metaAmountKey];
    if (amount == null) {
      EcashMessageEx.updateDetailInfo(metadata);
    }
    return int.tryParse(metadata?[CustomMessageEx.metaContentKey]?[EcashMessageEx.metaAmountKey]) ?? 0;
  }

  List<String> get tokenList => EcashMessageEx.getTokenListWithMetadata(metadata);

  String get description => EcashMessageEx.getDescriptionWithMetadata(metadata);

  int get amount => EcashMessageEx.getAmountWithMetadata(metadata);

  bool get isOpened {
    return bool.tryParse(
      metadata?[CustomMessageEx.metaContentKey]?[EcashMessageEx.metaIsOpenedKey] ?? false.toString(),
      caseSensitive: false,
    ) ?? false;
  }

  void set isOpened(bool value) {
    metadata?[CustomMessageEx.metaContentKey]?[EcashMessageEx.metaIsOpenedKey] = value.toString();
  }
}

typedef EcashSignee = (String pubkey, String flag);
extension EcashV2MessageEx on types.CustomMessage {

  static const metaTokenListKey = 'tokenList';
  static const metaSigneesKey = 'signees';
  static const metaSigneesPubkeyKey = 'pubkey';
  static const metaSigneesSignatureKey = 'signature';
  static const metaReceiverPubkeysKey = 'receiverPubkeys';
  static const metaMemoKey = 'memo';
  static const metaAmountKey = 'amount';
  static const metaValidityDateKey = 'validityDate';
  static const metaIsOpenedKey = 'isOpened';

  /// MetaData Format Example:
  /// {
  ///   'type': CustomMessageType.ecashV2.value,
  ///   'content':
  ///   {
  ///     'tokenList':
  ///     [
  ///       ...
  ///     ],
  ///     'isOpened': 'true',
  ///     'signees':
  ///     [
  ///       {
  ///         'pubkey': '...',
  ///         'signature': '...',
  ///       },
  ///       ...
  ///     ],
  ///     'receiverPubkeys':
  ///     [
  ///       ...
  ///     ],
  ///     'memo': 'xxxxx',    // temp
  ///     'amount': '21',     // temp
  ///     'validityDate': '1689418329',   // temp
  ///   },
  /// }

  static updateDetailInfo(Map? metadata) {
    final tokenList = getTokenListWithMetadata(metadata);
    if (tokenList.isEmpty) return ;

    var memoStr = '';
    bool isSecretSetupFlag = false;
    final totalAmount = tokenList.fold(0, (pre, token) {
      final info = Cashu.infoOfToken(token);
      if (info == null) return pre;
      if (!isSecretSetupFlag) {
        final validityDate = info.p2pkInfo?.lockTime ?? '';
        if (validityDate.isNotEmpty) {
          metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaValidityDateKey] = validityDate;
          isSecretSetupFlag = true;
        }
      }
      memoStr = info.memo;
      return pre + info.amount;
    });

    metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaMemoKey] = memoStr;
    metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaAmountKey] = totalAmount.toString();
  }

  static List<String> getTokenListWithMetadata(Map? metadata) =>
      metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaTokenListKey] ?? [];

  static String getDescriptionWithMetadata(Map? metadata) {
    final amount = metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaMemoKey];
    if (amount == null) {
      EcashV2MessageEx.updateDetailInfo(metadata);
    }
    return metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaMemoKey] ?? '';
  }

  static int getAmountWithMetadata(Map? metadata) {
    final amount = metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaAmountKey];
    if (amount == null) {
      EcashV2MessageEx.updateDetailInfo(metadata);
    }
    return int.tryParse(metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaAmountKey]) ?? 0;
  }

  static List<EcashSignee> getSigneesWithContentMap(Map contentMap) {
    final signees = contentMap[EcashV2MessageEx.metaSigneesKey];
    if (signees is! List) return [];
    return signees.map((entry) {
      if (entry is Map) {
        return (
        entry[EcashV2MessageEx.metaSigneesPubkeyKey] as String? ?? '',
        entry[EcashV2MessageEx.metaSigneesSignatureKey] as String? ?? '',
        );
      }
      return null;
    }).where((e) => e != null && e.$1.isNotEmpty).toList().cast();
  }

  static List<EcashSignee> getSigneesWithMetadata(Map? metadata) {
    final contentMap = metadata?[CustomMessageEx.metaContentKey];
    if (contentMap is! Map) return [];
    return getSigneesWithContentMap(contentMap);
  }

  static List<String> getReceiverPubkeysWithMetadata(Map? metadata) {
    return metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaReceiverPubkeysKey] ?? [];
  }

  static String getValidityDateWithMetadata(Map? metadata) {
    final result = metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaValidityDateKey] ?? '';
    if (result is! String || result.isEmpty) {
      EcashV2MessageEx.updateDetailInfo(metadata);
    }
    return metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaValidityDateKey] ?? '';
  }

  static bool getIsOpenedWithMetadata(Map? metadata) {
    return bool.tryParse(
      metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaIsOpenedKey] ?? false.toString(),
      caseSensitive: false,
    ) ?? false;
  }

  List<String> get tokenList => EcashV2MessageEx.getTokenListWithMetadata(metadata);

  String get description => EcashV2MessageEx.getDescriptionWithMetadata(metadata);

  int get amount => EcashV2MessageEx.getAmountWithMetadata(metadata);

  List<EcashSignee> get signees => EcashV2MessageEx.getSigneesWithMetadata(metadata);

  List<String> get receiverPubkeys => EcashV2MessageEx.getReceiverPubkeysWithMetadata(metadata);

  String get validityDate => EcashV2MessageEx.getValidityDateWithMetadata(metadata);

  bool get isOpened => EcashV2MessageEx.getIsOpenedWithMetadata(metadata);

  void set isOpened(bool value) {
    metadata?[CustomMessageEx.metaContentKey]?[EcashV2MessageEx.metaIsOpenedKey] = value.toString();
  }
}


extension ImageSendingMessageEx on types.CustomMessage {
  static const metaFileIdKey = 'fileId';
  static const metaPathKey = 'path';
  static const metaURLKey = 'url';
  static const metaWidthKey = 'width';
  static const metaHeightKey = 'height';
  static const metaEncryptedKey = 'encrypted';

  String get fileId => metadata?[CustomMessageEx.metaContentKey]?[metaFileIdKey] ?? '';
  String get path => metadata?[CustomMessageEx.metaContentKey]?[metaPathKey] ?? '';
  // This property could be a remote URL or an image encoded in Base64 format.
  String get url => metadata?[CustomMessageEx.metaContentKey]?[metaURLKey] ?? '';
  int? get width => metadata?[CustomMessageEx.metaContentKey]?[metaWidthKey];
  int? get height => metadata?[CustomMessageEx.metaContentKey]?[metaHeightKey];
  String? get encryptedKey => metadata?[CustomMessageEx.metaContentKey]?[metaEncryptedKey];
}

extension VideoMessageEx on types.CustomMessage {
  static const metaFileIdKey = 'fileId';
  static const metaSnapshotPathKey = 'snapshotPath';
  static const metaVideoPathKey = 'videoPath';
  static const metaURLKey = 'url';
  static const metaWidthKey = 'width';
  static const metaHeightKey = 'height';

  String get fileId => metadata?[CustomMessageEx.metaContentKey]?[metaFileIdKey] ?? '';
  String get snapshotPath => metadata?[CustomMessageEx.metaContentKey]?[metaSnapshotPathKey] ?? '';
  String get videoPath => metadata?[CustomMessageEx.metaContentKey]?[metaVideoPathKey] ?? '';
  String get url => metadata?[CustomMessageEx.metaContentKey]?[metaURLKey] ?? '';
  int? get width => metadata?[CustomMessageEx.metaContentKey]?[metaWidthKey];
  int? get height => metadata?[CustomMessageEx.metaContentKey]?[metaHeightKey];

  void set snapshotPath(String value) {
    metadata?[CustomMessageEx.metaContentKey]?[metaSnapshotPathKey] = value;
  }
}