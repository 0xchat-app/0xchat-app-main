// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messageDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMessageDBISARCollection on Isar {
  IsarCollection<MessageDBISAR> get messageDBISARs => this.collection();
}

const MessageDBISARSchema = CollectionSchema(
  name: r'MessageDBISAR',
  id: 6944358790731645977,
  properties: {
    r'chatType': PropertySchema(
      id: 0,
      name: r'chatType',
      type: IsarType.long,
    ),
    r'content': PropertySchema(
      id: 1,
      name: r'content',
      type: IsarType.string,
    ),
    r'createTime': PropertySchema(
      id: 2,
      name: r'createTime',
      type: IsarType.long,
    ),
    r'decryptAlgo': PropertySchema(
      id: 3,
      name: r'decryptAlgo',
      type: IsarType.string,
    ),
    r'decryptContent': PropertySchema(
      id: 4,
      name: r'decryptContent',
      type: IsarType.string,
    ),
    r'decryptNonce': PropertySchema(
      id: 5,
      name: r'decryptNonce',
      type: IsarType.string,
    ),
    r'decryptSecret': PropertySchema(
      id: 6,
      name: r'decryptSecret',
      type: IsarType.string,
    ),
    r'emojiShortcodesJson': PropertySchema(
      id: 7,
      name: r'emojiShortcodesJson',
      type: IsarType.string,
    ),
    r'expiration': PropertySchema(
      id: 8,
      name: r'expiration',
      type: IsarType.long,
    ),
    r'giftwrappedEventId': PropertySchema(
      id: 9,
      name: r'giftwrappedEventId',
      type: IsarType.string,
    ),
    r'giftwrappedEventJson': PropertySchema(
      id: 10,
      name: r'giftwrappedEventJson',
      type: IsarType.string,
    ),
    r'groupId': PropertySchema(
      id: 11,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'kind': PropertySchema(
      id: 12,
      name: r'kind',
      type: IsarType.long,
    ),
    r'messageId': PropertySchema(
      id: 13,
      name: r'messageId',
      type: IsarType.string,
    ),
    r'plaintEvent': PropertySchema(
      id: 14,
      name: r'plaintEvent',
      type: IsarType.string,
    ),
    r'previewData': PropertySchema(
      id: 15,
      name: r'previewData',
      type: IsarType.string,
    ),
    r'reactionEventIds': PropertySchema(
      id: 16,
      name: r'reactionEventIds',
      type: IsarType.stringList,
    ),
    r'read': PropertySchema(
      id: 17,
      name: r'read',
      type: IsarType.bool,
    ),
    r'receiver': PropertySchema(
      id: 18,
      name: r'receiver',
      type: IsarType.string,
    ),
    r'replyId': PropertySchema(
      id: 19,
      name: r'replyId',
      type: IsarType.string,
    ),
    r'reportList': PropertySchema(
      id: 20,
      name: r'reportList',
      type: IsarType.stringList,
    ),
    r'sender': PropertySchema(
      id: 21,
      name: r'sender',
      type: IsarType.string,
    ),
    r'sessionId': PropertySchema(
      id: 22,
      name: r'sessionId',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 23,
      name: r'status',
      type: IsarType.long,
    ),
    r'subType': PropertySchema(
      id: 24,
      name: r'subType',
      type: IsarType.string,
    ),
    r'tags': PropertySchema(
      id: 25,
      name: r'tags',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 26,
      name: r'type',
      type: IsarType.string,
    ),
    r'zapEventIds': PropertySchema(
      id: 27,
      name: r'zapEventIds',
      type: IsarType.stringList,
    )
  },
  estimateSize: _messageDBISAREstimateSize,
  serialize: _messageDBISARSerialize,
  deserialize: _messageDBISARDeserialize,
  deserializeProp: _messageDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'messageId': IndexSchema(
      id: -635287409172016016,
      name: r'messageId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'messageId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _messageDBISARGetId,
  getLinks: _messageDBISARGetLinks,
  attach: _messageDBISARAttach,
  version: '3.1.0+1',
);

int _messageDBISAREstimateSize(
  MessageDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.content.length * 3;
  {
    final value = object.decryptAlgo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.decryptContent.length * 3;
  {
    final value = object.decryptNonce;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.decryptSecret;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.emojiShortcodesJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.giftwrappedEventId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.giftwrappedEventJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.groupId.length * 3;
  bytesCount += 3 + object.messageId.length * 3;
  bytesCount += 3 + object.plaintEvent.length * 3;
  {
    final value = object.previewData;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.reactionEventIds;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.receiver.length * 3;
  bytesCount += 3 + object.replyId.length * 3;
  {
    final list = object.reportList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.sender.length * 3;
  bytesCount += 3 + object.sessionId.length * 3;
  {
    final value = object.subType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tags.length * 3;
  bytesCount += 3 + object.type.length * 3;
  {
    final list = object.zapEventIds;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _messageDBISARSerialize(
  MessageDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.chatType);
  writer.writeString(offsets[1], object.content);
  writer.writeLong(offsets[2], object.createTime);
  writer.writeString(offsets[3], object.decryptAlgo);
  writer.writeString(offsets[4], object.decryptContent);
  writer.writeString(offsets[5], object.decryptNonce);
  writer.writeString(offsets[6], object.decryptSecret);
  writer.writeString(offsets[7], object.emojiShortcodesJson);
  writer.writeLong(offsets[8], object.expiration);
  writer.writeString(offsets[9], object.giftwrappedEventId);
  writer.writeString(offsets[10], object.giftwrappedEventJson);
  writer.writeString(offsets[11], object.groupId);
  writer.writeLong(offsets[12], object.kind);
  writer.writeString(offsets[13], object.messageId);
  writer.writeString(offsets[14], object.plaintEvent);
  writer.writeString(offsets[15], object.previewData);
  writer.writeStringList(offsets[16], object.reactionEventIds);
  writer.writeBool(offsets[17], object.read);
  writer.writeString(offsets[18], object.receiver);
  writer.writeString(offsets[19], object.replyId);
  writer.writeStringList(offsets[20], object.reportList);
  writer.writeString(offsets[21], object.sender);
  writer.writeString(offsets[22], object.sessionId);
  writer.writeLong(offsets[23], object.status);
  writer.writeString(offsets[24], object.subType);
  writer.writeString(offsets[25], object.tags);
  writer.writeString(offsets[26], object.type);
  writer.writeStringList(offsets[27], object.zapEventIds);
}

MessageDBISAR _messageDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MessageDBISAR(
    chatType: reader.readLongOrNull(offsets[0]),
    content: reader.readStringOrNull(offsets[1]) ?? '',
    createTime: reader.readLongOrNull(offsets[2]) ?? 0,
    decryptAlgo: reader.readStringOrNull(offsets[3]),
    decryptContent: reader.readStringOrNull(offsets[4]) ?? '',
    decryptNonce: reader.readStringOrNull(offsets[5]),
    decryptSecret: reader.readStringOrNull(offsets[6]),
    emojiShortcodesJson: reader.readStringOrNull(offsets[7]),
    expiration: reader.readLongOrNull(offsets[8]),
    giftwrappedEventId: reader.readStringOrNull(offsets[9]),
    giftwrappedEventJson: reader.readStringOrNull(offsets[10]),
    groupId: reader.readStringOrNull(offsets[11]) ?? '',
    kind: reader.readLongOrNull(offsets[12]) ?? 0,
    messageId: reader.readStringOrNull(offsets[13]) ?? '',
    plaintEvent: reader.readStringOrNull(offsets[14]) ?? '',
    previewData: reader.readStringOrNull(offsets[15]),
    reactionEventIds: reader.readStringList(offsets[16]),
    read: reader.readBoolOrNull(offsets[17]) ?? false,
    receiver: reader.readStringOrNull(offsets[18]) ?? '',
    replyId: reader.readStringOrNull(offsets[19]) ?? '',
    sender: reader.readStringOrNull(offsets[21]) ?? '',
    sessionId: reader.readStringOrNull(offsets[22]) ?? '',
    status: reader.readLongOrNull(offsets[23]),
    subType: reader.readStringOrNull(offsets[24]),
    tags: reader.readStringOrNull(offsets[25]) ?? '',
    type: reader.readStringOrNull(offsets[26]) ?? 'text',
    zapEventIds: reader.readStringList(offsets[27]),
  );
  object.id = id;
  object.reportList = reader.readStringList(offsets[20]);
  return object;
}

P _messageDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 12:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 13:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 14:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringList(offset)) as P;
    case 17:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 18:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 19:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 20:
      return (reader.readStringList(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 22:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 23:
      return (reader.readLongOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 26:
      return (reader.readStringOrNull(offset) ?? 'text') as P;
    case 27:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _messageDBISARGetId(MessageDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _messageDBISARGetLinks(MessageDBISAR object) {
  return [];
}

void _messageDBISARAttach(
    IsarCollection<dynamic> col, Id id, MessageDBISAR object) {
  object.id = id;
}

extension MessageDBISARByIndex on IsarCollection<MessageDBISAR> {
  Future<MessageDBISAR?> getByMessageId(String messageId) {
    return getByIndex(r'messageId', [messageId]);
  }

  MessageDBISAR? getByMessageIdSync(String messageId) {
    return getByIndexSync(r'messageId', [messageId]);
  }

  Future<bool> deleteByMessageId(String messageId) {
    return deleteByIndex(r'messageId', [messageId]);
  }

  bool deleteByMessageIdSync(String messageId) {
    return deleteByIndexSync(r'messageId', [messageId]);
  }

  Future<List<MessageDBISAR?>> getAllByMessageId(List<String> messageIdValues) {
    final values = messageIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'messageId', values);
  }

  List<MessageDBISAR?> getAllByMessageIdSync(List<String> messageIdValues) {
    final values = messageIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'messageId', values);
  }

  Future<int> deleteAllByMessageId(List<String> messageIdValues) {
    final values = messageIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'messageId', values);
  }

  int deleteAllByMessageIdSync(List<String> messageIdValues) {
    final values = messageIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'messageId', values);
  }

  Future<Id> putByMessageId(MessageDBISAR object) {
    return putByIndex(r'messageId', object);
  }

  Id putByMessageIdSync(MessageDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'messageId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMessageId(List<MessageDBISAR> objects) {
    return putAllByIndex(r'messageId', objects);
  }

  List<Id> putAllByMessageIdSync(List<MessageDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'messageId', objects, saveLinks: saveLinks);
  }
}

extension MessageDBISARQueryWhereSort
    on QueryBuilder<MessageDBISAR, MessageDBISAR, QWhere> {
  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MessageDBISARQueryWhere
    on QueryBuilder<MessageDBISAR, MessageDBISAR, QWhereClause> {
  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterWhereClause>
      messageIdEqualTo(String messageId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'messageId',
        value: [messageId],
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterWhereClause>
      messageIdNotEqualTo(String messageId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'messageId',
              lower: [],
              upper: [messageId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'messageId',
              lower: [messageId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'messageId',
              lower: [messageId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'messageId',
              lower: [],
              upper: [messageId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MessageDBISARQueryFilter
    on QueryBuilder<MessageDBISAR, MessageDBISAR, QFilterCondition> {
  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      chatTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chatType',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      chatTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chatType',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      chatTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatType',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      chatTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatType',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      chatTypeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatType',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      chatTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      createTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      createTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      createTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createTime',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      createTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'decryptAlgo',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'decryptAlgo',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decryptAlgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'decryptAlgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'decryptAlgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'decryptAlgo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'decryptAlgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'decryptAlgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'decryptAlgo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'decryptAlgo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decryptAlgo',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptAlgoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decryptAlgo',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptContentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decryptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptContentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'decryptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptContentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'decryptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptContentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'decryptContent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptContentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'decryptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptContentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'decryptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptContentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'decryptContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptContentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'decryptContent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptContentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decryptContent',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptContentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decryptContent',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'decryptNonce',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'decryptNonce',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decryptNonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'decryptNonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'decryptNonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'decryptNonce',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'decryptNonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'decryptNonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'decryptNonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'decryptNonce',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decryptNonce',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptNonceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decryptNonce',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'decryptSecret',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'decryptSecret',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decryptSecret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'decryptSecret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'decryptSecret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'decryptSecret',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'decryptSecret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'decryptSecret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'decryptSecret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'decryptSecret',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decryptSecret',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      decryptSecretIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decryptSecret',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emojiShortcodesJson',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emojiShortcodesJson',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emojiShortcodesJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emojiShortcodesJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emojiShortcodesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emojiShortcodesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      expirationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiration',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      expirationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiration',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      expirationEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiration',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      expirationGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiration',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      expirationLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiration',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      expirationBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'giftwrappedEventId',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'giftwrappedEventId',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'giftwrappedEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'giftwrappedEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'giftwrappedEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'giftwrappedEventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'giftwrappedEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'giftwrappedEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'giftwrappedEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'giftwrappedEventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'giftwrappedEventId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'giftwrappedEventId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'giftwrappedEventJson',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'giftwrappedEventJson',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'giftwrappedEventJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'giftwrappedEventJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'giftwrappedEventJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'giftwrappedEventJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'giftwrappedEventJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'giftwrappedEventJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'giftwrappedEventJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'giftwrappedEventJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'giftwrappedEventJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      giftwrappedEventJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'giftwrappedEventJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      groupIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      groupIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      groupIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      groupIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      groupIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      groupIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> kindEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kind',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      kindGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kind',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      kindLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kind',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> kindBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      messageIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      messageIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      messageIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      messageIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'messageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      messageIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      messageIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      messageIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      messageIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'messageId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      messageIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      messageIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'messageId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      plaintEventEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plaintEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      plaintEventGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plaintEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      plaintEventLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plaintEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      plaintEventBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plaintEvent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      plaintEventStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'plaintEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      plaintEventEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'plaintEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      plaintEventContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'plaintEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      plaintEventMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'plaintEvent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      plaintEventIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plaintEvent',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      plaintEventIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'plaintEvent',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'previewData',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'previewData',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previewData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previewData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previewData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previewData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'previewData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'previewData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'previewData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'previewData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previewData',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      previewDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'previewData',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reactionEventIds',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reactionEventIds',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reactionEventIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reactionEventIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reactionEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reactionEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reactionEventIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> readEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'read',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      receiverEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiver',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      receiverGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiver',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      receiverLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiver',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      receiverBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiver',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      receiverStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receiver',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      receiverEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receiver',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      receiverContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receiver',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      receiverMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receiver',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      receiverIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiver',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      receiverIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receiver',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      replyIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      replyIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'replyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      replyIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'replyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      replyIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'replyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      replyIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'replyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      replyIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'replyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      replyIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'replyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      replyIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'replyId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      replyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replyId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      replyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'replyId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reportList',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reportList',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reportList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reportList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reportList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reportList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reportList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reportList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reportList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportList',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reportList',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      reportListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reportList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      senderEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      senderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      senderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      senderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      senderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      senderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      senderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      senderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      senderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sender',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      senderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sender',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      sessionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      sessionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      sessionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      sessionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      sessionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      sessionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      sessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      sessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      sessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      sessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      statusEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      statusGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      statusLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      statusBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'subType',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'subType',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subType',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      subTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subType',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> tagsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      tagsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      tagsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> tagsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      tagsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      tagsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      tagsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> tagsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'zapEventIds',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'zapEventIds',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zapEventIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'zapEventIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zapEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'zapEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterFilterCondition>
      zapEventIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension MessageDBISARQueryObject
    on QueryBuilder<MessageDBISAR, MessageDBISAR, QFilterCondition> {}

extension MessageDBISARQueryLinks
    on QueryBuilder<MessageDBISAR, MessageDBISAR, QFilterCondition> {}

extension MessageDBISARQuerySortBy
    on QueryBuilder<MessageDBISAR, MessageDBISAR, QSortBy> {
  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByChatType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatType', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByChatTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatType', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByCreateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByCreateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByDecryptAlgo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptAlgo', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByDecryptAlgoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptAlgo', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByDecryptContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptContent', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByDecryptContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptContent', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByDecryptNonce() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptNonce', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByDecryptNonceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptNonce', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByDecryptSecret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptSecret', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByDecryptSecretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptSecret', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByEmojiShortcodesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcodesJson', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByEmojiShortcodesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcodesJson', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByGiftwrappedEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftwrappedEventId', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByGiftwrappedEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftwrappedEventId', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByGiftwrappedEventJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftwrappedEventJson', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByGiftwrappedEventJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftwrappedEventJson', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByPlaintEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plaintEvent', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByPlaintEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plaintEvent', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByPreviewData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewData', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByPreviewDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewData', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByReceiver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiver', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortByReceiverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiver', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByReplyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyId', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByReplyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyId', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortBySubType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subType', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortBySubTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subType', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByTagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension MessageDBISARQuerySortThenBy
    on QueryBuilder<MessageDBISAR, MessageDBISAR, QSortThenBy> {
  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByChatType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatType', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByChatTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatType', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByCreateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByCreateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByDecryptAlgo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptAlgo', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByDecryptAlgoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptAlgo', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByDecryptContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptContent', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByDecryptContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptContent', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByDecryptNonce() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptNonce', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByDecryptNonceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptNonce', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByDecryptSecret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptSecret', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByDecryptSecretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decryptSecret', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByEmojiShortcodesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcodesJson', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByEmojiShortcodesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcodesJson', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByGiftwrappedEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftwrappedEventId', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByGiftwrappedEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftwrappedEventId', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByGiftwrappedEventJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftwrappedEventJson', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByGiftwrappedEventJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftwrappedEventJson', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByPlaintEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plaintEvent', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByPlaintEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plaintEvent', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByPreviewData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewData', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByPreviewDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewData', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByReceiver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiver', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenByReceiverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiver', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByReplyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyId', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByReplyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyId', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy>
      thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenBySubType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subType', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenBySubTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subType', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByTagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.desc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension MessageDBISARQueryWhereDistinct
    on QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> {
  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByChatType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatType');
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByCreateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createTime');
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByDecryptAlgo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decryptAlgo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct>
      distinctByDecryptContent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decryptContent',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByDecryptNonce(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decryptNonce', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByDecryptSecret(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decryptSecret',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct>
      distinctByEmojiShortcodesJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emojiShortcodesJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiration');
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct>
      distinctByGiftwrappedEventId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'giftwrappedEventId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct>
      distinctByGiftwrappedEventJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'giftwrappedEventJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByGroupId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kind');
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByMessageId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'messageId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByPlaintEvent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plaintEvent', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByPreviewData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previewData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct>
      distinctByReactionEventIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reactionEventIds');
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'read');
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByReceiver(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiver', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByReplyId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'replyId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByReportList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportList');
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctBySender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctBySessionId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctBySubType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByTags(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageDBISAR, MessageDBISAR, QDistinct>
      distinctByZapEventIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zapEventIds');
    });
  }
}

extension MessageDBISARQueryProperty
    on QueryBuilder<MessageDBISAR, MessageDBISAR, QQueryProperty> {
  QueryBuilder<MessageDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MessageDBISAR, int?, QQueryOperations> chatTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatType');
    });
  }

  QueryBuilder<MessageDBISAR, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<MessageDBISAR, int, QQueryOperations> createTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createTime');
    });
  }

  QueryBuilder<MessageDBISAR, String?, QQueryOperations> decryptAlgoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decryptAlgo');
    });
  }

  QueryBuilder<MessageDBISAR, String, QQueryOperations>
      decryptContentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decryptContent');
    });
  }

  QueryBuilder<MessageDBISAR, String?, QQueryOperations>
      decryptNonceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decryptNonce');
    });
  }

  QueryBuilder<MessageDBISAR, String?, QQueryOperations>
      decryptSecretProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decryptSecret');
    });
  }

  QueryBuilder<MessageDBISAR, String?, QQueryOperations>
      emojiShortcodesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emojiShortcodesJson');
    });
  }

  QueryBuilder<MessageDBISAR, int?, QQueryOperations> expirationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiration');
    });
  }

  QueryBuilder<MessageDBISAR, String?, QQueryOperations>
      giftwrappedEventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'giftwrappedEventId');
    });
  }

  QueryBuilder<MessageDBISAR, String?, QQueryOperations>
      giftwrappedEventJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'giftwrappedEventJson');
    });
  }

  QueryBuilder<MessageDBISAR, String, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<MessageDBISAR, int, QQueryOperations> kindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kind');
    });
  }

  QueryBuilder<MessageDBISAR, String, QQueryOperations> messageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'messageId');
    });
  }

  QueryBuilder<MessageDBISAR, String, QQueryOperations> plaintEventProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plaintEvent');
    });
  }

  QueryBuilder<MessageDBISAR, String?, QQueryOperations> previewDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previewData');
    });
  }

  QueryBuilder<MessageDBISAR, List<String>?, QQueryOperations>
      reactionEventIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reactionEventIds');
    });
  }

  QueryBuilder<MessageDBISAR, bool, QQueryOperations> readProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'read');
    });
  }

  QueryBuilder<MessageDBISAR, String, QQueryOperations> receiverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiver');
    });
  }

  QueryBuilder<MessageDBISAR, String, QQueryOperations> replyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'replyId');
    });
  }

  QueryBuilder<MessageDBISAR, List<String>?, QQueryOperations>
      reportListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportList');
    });
  }

  QueryBuilder<MessageDBISAR, String, QQueryOperations> senderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sender');
    });
  }

  QueryBuilder<MessageDBISAR, String, QQueryOperations> sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<MessageDBISAR, int?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<MessageDBISAR, String?, QQueryOperations> subTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subType');
    });
  }

  QueryBuilder<MessageDBISAR, String, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<MessageDBISAR, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<MessageDBISAR, List<String>?, QQueryOperations>
      zapEventIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zapEventIds');
    });
  }
}
