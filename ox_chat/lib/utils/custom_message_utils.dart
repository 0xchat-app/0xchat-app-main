
import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/custom_message_type.dart';

extension CustomMessageEx on types.CustomMessage {
  CustomMessageType? get customType =>
      CustomMessageTypeEx.fromValue(metadata?['type']);

  static Map<String, dynamic> zapsMetaData({
    required String zapper,
    required String invoice,
    required String amount,
    required String description,
  }) {
    return {
      'type': CustomMessageType.zaps.value,
      'content': {
        'zapper': zapper,
        'invoice': invoice,
        'amount': amount,
        'description': description,
      },
    };
  }

  static Map<String, dynamic> callMetaData({
    required String text,
    required CallMessageType type,
  }) {
    return {
      'type': CustomMessageType.call.value,
      'content': {
        'text': text,
        'type': type.value,
      },
    };
  }

  static Map<String, dynamic> templateMetaData({
    required String title,
    required String content,
    required String icon,
    required String link,
  }) {
    return {
      'type': CustomMessageType.template.value,
      'content': {
        'title': title,
        'content': content,
        'icon': icon,
        'link': link,
      },
    };
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
    return {
      'type': CustomMessageType.note.value,
      'content': {
        'authorIcon': authorIcon,
        'authorName': authorName,
        'authorDNS': authorDNS,
        'createTime': createTime,
        'note': note,
        'image': image,
        'link': link,
      },
    };
  }

  static Map<String, dynamic> ecashMetaData({
    required List<String> tokenList,
    String isOpened = '',
  }) {
    return {
      'type': CustomMessageType.ecash.value,
      'content': {
        'tokenList': tokenList,
        'isOpened': isOpened,
      },
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
  String get zapper => metadata?['content']?['zapper'] ?? '';
  String get invoice => metadata?['content']?['invoice'] ?? '';
  int get amount => int.tryParse(metadata?['content']?['amount'] ?? '') ?? 0;
  String get description => metadata?['content']?['description'] ?? '';
}

extension CallMessageEx on types.CustomMessage {
  String get callText => metadata?['content']?['text'] ?? '';
  CallMessageType? get callType => CallMessageTypeEx.fromValue(metadata?['content']?['type']);
}

extension TemplateMessageEx on types.CustomMessage {
  String get title => metadata?['content']?['title'] ?? '';
  String get content => metadata?['content']?['content'] ?? '';
  String get icon => metadata?['content']?['icon'] ?? '';
  String get link => metadata?['content']?['link'] ?? '';
}

extension NoteMessageEx on types.CustomMessage {
  String get authorIcon => metadata?['content']?['authorIcon'] ?? '';
  String get authorName => metadata?['content']?['authorName'] ?? '';
  String get authorDNS => metadata?['content']?['authorDNS'] ?? '';
  int get createTime => int.tryParse(metadata?['content']?['createTime'] ?? '') ?? 0;
  String get note => metadata?['content']?['note'] ?? '';
  String get image => metadata?['content']?['image'] ?? '';
  String get link => metadata?['content']?['link'] ?? '';
}

extension EcashMessageEx on types.CustomMessage {

  static updateDetailInfo(Map? metadata) {
    final tokenList = getTokenListWithMetadata(metadata);
    if (tokenList.isEmpty) return ;

    var memoStr = '';
    final totalAmount = tokenList.fold(0, (pre, token) {
      final info = Cashu.infoOfToken(token);
      if (info == null) return pre;
      final (memo, amount) = info;
      memoStr = memo;
      return pre + amount;
    });

    metadata?['content']?['memo'] = memoStr;
    metadata?['content']?['amount'] = totalAmount.toString();
  }

  static List<String> getTokenListWithMetadata(Map? metadata) =>
      metadata?['content']?['tokenList'] ?? [];

  static getDescriptionWithMetadata(Map? metadata) {
    final amount = metadata?['content']?['memo'];
    if (amount == null) {
      EcashMessageEx.updateDetailInfo(metadata);
    }
    return metadata?['content']?['memo'] ?? '';
  }

  static getAmountWithMetadata(Map? metadata) {
    final amount = metadata?['content']?['amount'];
    if (amount == null) {
      EcashMessageEx.updateDetailInfo(metadata);
    }
    return int.tryParse(metadata?['content']?['amount']) ?? 0;
  }

  List<String> get tokenList => EcashMessageEx.getTokenListWithMetadata(metadata);

  String get description => EcashMessageEx.getDescriptionWithMetadata(metadata);

  int get amount  => EcashMessageEx.getAmountWithMetadata(metadata);

  bool get isOpened {
    return bool.tryParse(
      metadata?['content']?['isOpened'] ?? false.toString(),
      caseSensitive: false,
    ) ?? false;
  }
  void set isOpened(bool value) {
    metadata?['content']?['isOpened'] = value.toString();
  }
}
