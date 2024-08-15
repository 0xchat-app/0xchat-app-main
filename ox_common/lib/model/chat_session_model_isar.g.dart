// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_model_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChatSessionModelISARCollection on Isar {
  IsarCollection<ChatSessionModelISAR> get chatSessionModelISARs =>
      this.collection();
}

const ChatSessionModelISARSchema = CollectionSchema(
  name: r'ChatSessionModelISAR',
  id: -8334601539652401498,
  properties: {
    r'alwaysTop': PropertySchema(
      id: 0,
      name: r'alwaysTop',
      type: IsarType.bool,
    ),
    r'avatar': PropertySchema(
      id: 1,
      name: r'avatar',
      type: IsarType.string,
    ),
    r'chatId': PropertySchema(
      id: 2,
      name: r'chatId',
      type: IsarType.string,
    ),
    r'chatName': PropertySchema(
      id: 3,
      name: r'chatName',
      type: IsarType.string,
    ),
    r'chatType': PropertySchema(
      id: 4,
      name: r'chatType',
      type: IsarType.long,
    ),
    r'content': PropertySchema(
      id: 5,
      name: r'content',
      type: IsarType.string,
    ),
    r'createTime': PropertySchema(
      id: 6,
      name: r'createTime',
      type: IsarType.long,
    ),
    r'draft': PropertySchema(
      id: 7,
      name: r'draft',
      type: IsarType.string,
    ),
    r'expiration': PropertySchema(
      id: 8,
      name: r'expiration',
      type: IsarType.long,
    ),
    r'groupId': PropertySchema(
      id: 9,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'isMentioned': PropertySchema(
      id: 10,
      name: r'isMentioned',
      type: IsarType.bool,
    ),
    r'messageKind': PropertySchema(
      id: 11,
      name: r'messageKind',
      type: IsarType.long,
    ),
    r'messageType': PropertySchema(
      id: 12,
      name: r'messageType',
      type: IsarType.string,
    ),
    r'receiver': PropertySchema(
      id: 13,
      name: r'receiver',
      type: IsarType.string,
    ),
    r'sender': PropertySchema(
      id: 14,
      name: r'sender',
      type: IsarType.string,
    ),
    r'unreadCount': PropertySchema(
      id: 15,
      name: r'unreadCount',
      type: IsarType.long,
    )
  },
  estimateSize: _chatSessionModelISAREstimateSize,
  serialize: _chatSessionModelISARSerialize,
  deserialize: _chatSessionModelISARDeserialize,
  deserializeProp: _chatSessionModelISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'chatId': IndexSchema(
      id: 1909629659142158609,
      name: r'chatId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'chatId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _chatSessionModelISARGetId,
  getLinks: _chatSessionModelISARGetLinks,
  attach: _chatSessionModelISARAttach,
  version: '3.1.0+1',
);

int _chatSessionModelISAREstimateSize(
  ChatSessionModelISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.avatar;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.chatId.length * 3;
  {
    final value = object.chatName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.content;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.draft;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.groupId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.messageType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.receiver.length * 3;
  bytesCount += 3 + object.sender.length * 3;
  return bytesCount;
}

void _chatSessionModelISARSerialize(
  ChatSessionModelISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.alwaysTop);
  writer.writeString(offsets[1], object.avatar);
  writer.writeString(offsets[2], object.chatId);
  writer.writeString(offsets[3], object.chatName);
  writer.writeLong(offsets[4], object.chatType);
  writer.writeString(offsets[5], object.content);
  writer.writeLong(offsets[6], object.createTime);
  writer.writeString(offsets[7], object.draft);
  writer.writeLong(offsets[8], object.expiration);
  writer.writeString(offsets[9], object.groupId);
  writer.writeBool(offsets[10], object.isMentioned);
  writer.writeLong(offsets[11], object.messageKind);
  writer.writeString(offsets[12], object.messageType);
  writer.writeString(offsets[13], object.receiver);
  writer.writeString(offsets[14], object.sender);
  writer.writeLong(offsets[15], object.unreadCount);
}

ChatSessionModelISAR _chatSessionModelISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChatSessionModelISAR(
    alwaysTop: reader.readBoolOrNull(offsets[0]) ?? false,
    avatar: reader.readStringOrNull(offsets[1]),
    chatId: reader.readStringOrNull(offsets[2]) ?? '',
    chatName: reader.readStringOrNull(offsets[3]),
    chatType: reader.readLongOrNull(offsets[4]) ?? 0,
    content: reader.readStringOrNull(offsets[5]),
    createTime: reader.readLongOrNull(offsets[6]) ?? 0,
    draft: reader.readStringOrNull(offsets[7]),
    expiration: reader.readLongOrNull(offsets[8]),
    groupId: reader.readStringOrNull(offsets[9]),
    isMentioned: reader.readBoolOrNull(offsets[10]) ?? false,
    messageKind: reader.readLongOrNull(offsets[11]),
    messageType: reader.readStringOrNull(offsets[12]),
    receiver: reader.readStringOrNull(offsets[13]) ?? '',
    sender: reader.readStringOrNull(offsets[14]) ?? '',
    unreadCount: reader.readLongOrNull(offsets[15]) ?? 0,
  );
  object.id = id;
  return object;
}

P _chatSessionModelISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 14:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 15:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _chatSessionModelISARGetId(ChatSessionModelISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _chatSessionModelISARGetLinks(
    ChatSessionModelISAR object) {
  return [];
}

void _chatSessionModelISARAttach(
    IsarCollection<dynamic> col, Id id, ChatSessionModelISAR object) {
  object.id = id;
}

extension ChatSessionModelISARByIndex on IsarCollection<ChatSessionModelISAR> {
  Future<ChatSessionModelISAR?> getByChatId(String chatId) {
    return getByIndex(r'chatId', [chatId]);
  }

  ChatSessionModelISAR? getByChatIdSync(String chatId) {
    return getByIndexSync(r'chatId', [chatId]);
  }

  Future<bool> deleteByChatId(String chatId) {
    return deleteByIndex(r'chatId', [chatId]);
  }

  bool deleteByChatIdSync(String chatId) {
    return deleteByIndexSync(r'chatId', [chatId]);
  }

  Future<List<ChatSessionModelISAR?>> getAllByChatId(
      List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'chatId', values);
  }

  List<ChatSessionModelISAR?> getAllByChatIdSync(List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'chatId', values);
  }

  Future<int> deleteAllByChatId(List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'chatId', values);
  }

  int deleteAllByChatIdSync(List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'chatId', values);
  }

  Future<Id> putByChatId(ChatSessionModelISAR object) {
    return putByIndex(r'chatId', object);
  }

  Id putByChatIdSync(ChatSessionModelISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'chatId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByChatId(List<ChatSessionModelISAR> objects) {
    return putAllByIndex(r'chatId', objects);
  }

  List<Id> putAllByChatIdSync(List<ChatSessionModelISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'chatId', objects, saveLinks: saveLinks);
  }
}

extension ChatSessionModelISARQueryWhereSort
    on QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QWhere> {
  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChatSessionModelISARQueryWhere
    on QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QWhereClause> {
  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterWhereClause>
      chatIdEqualTo(String chatId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chatId',
        value: [chatId],
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterWhereClause>
      chatIdNotEqualTo(String chatId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [],
              upper: [chatId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [chatId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [chatId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [],
              upper: [chatId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ChatSessionModelISARQueryFilter on QueryBuilder<ChatSessionModelISAR,
    ChatSessionModelISAR, QFilterCondition> {
  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> alwaysTopEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alwaysTop',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> avatarIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'avatar',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> avatarIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'avatar',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> avatarEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> avatarGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> avatarLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> avatarBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avatar',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> avatarStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> avatarEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      avatarContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'avatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      avatarMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'avatar',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> avatarIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatar',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> avatarIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'avatar',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      chatIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      chatIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chatId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chatName',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chatName',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chatName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chatName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      chatNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chatName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      chatNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chatName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chatName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatType',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatTypeGreaterThan(
    int value, {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatTypeLessThan(
    int value, {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> chatTypeBetween(
    int lower,
    int upper, {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> contentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'content',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> contentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'content',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> contentEqualTo(
    String? value, {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> contentGreaterThan(
    String? value, {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> contentLessThan(
    String? value, {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> contentBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> contentStartsWith(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> contentEndsWith(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> createTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> createTimeGreaterThan(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> createTimeLessThan(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> createTimeBetween(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> draftIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'draft',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> draftIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'draft',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> draftEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'draft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> draftGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'draft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> draftLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'draft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> draftBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'draft',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> draftStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'draft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> draftEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'draft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      draftContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'draft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      draftMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'draft',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> draftIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'draft',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> draftIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'draft',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> expirationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiration',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> expirationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiration',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> expirationEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiration',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> expirationGreaterThan(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> expirationLessThan(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> expirationBetween(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> groupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> groupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> groupIdEqualTo(
    String? value, {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> groupIdGreaterThan(
    String? value, {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> groupIdLessThan(
    String? value, {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> groupIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> groupIdStartsWith(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> groupIdEndsWith(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> isMentionedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMentioned',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageKindIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'messageKind',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageKindIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'messageKind',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageKindEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageKind',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageKindGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'messageKind',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageKindLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'messageKind',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageKindBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'messageKind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'messageType',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'messageType',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'messageType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      messageTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'messageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      messageTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'messageType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageType',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> messageTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'messageType',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> receiverEqualTo(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> receiverGreaterThan(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> receiverLessThan(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> receiverBetween(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> receiverStartsWith(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> receiverEndsWith(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      receiverContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receiver',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      receiverMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receiver',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> receiverIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiver',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> receiverIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receiver',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> senderEqualTo(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> senderGreaterThan(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> senderLessThan(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> senderBetween(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> senderStartsWith(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> senderEndsWith(
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

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      senderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
          QAfterFilterCondition>
      senderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> senderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sender',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> senderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sender',
        value: '',
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> unreadCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unreadCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> unreadCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unreadCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> unreadCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unreadCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR,
      QAfterFilterCondition> unreadCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unreadCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChatSessionModelISARQueryObject on QueryBuilder<ChatSessionModelISAR,
    ChatSessionModelISAR, QFilterCondition> {}

extension ChatSessionModelISARQueryLinks on QueryBuilder<ChatSessionModelISAR,
    ChatSessionModelISAR, QFilterCondition> {}

extension ChatSessionModelISARQuerySortBy
    on QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QSortBy> {
  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByAlwaysTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alwaysTop', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByAlwaysTopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alwaysTop', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatar', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatar', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByChatName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatName', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByChatNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatName', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByChatType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatType', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByChatTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatType', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByCreateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByCreateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByDraft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draft', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByDraftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draft', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByIsMentioned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMentioned', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByIsMentionedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMentioned', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByMessageKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageKind', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByMessageKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageKind', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByMessageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByMessageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByReceiver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiver', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByReceiverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiver', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByUnreadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadCount', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      sortByUnreadCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadCount', Sort.desc);
    });
  }
}

extension ChatSessionModelISARQuerySortThenBy
    on QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QSortThenBy> {
  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByAlwaysTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alwaysTop', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByAlwaysTopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alwaysTop', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatar', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatar', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByChatName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatName', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByChatNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatName', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByChatType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatType', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByChatTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatType', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByCreateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByCreateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByDraft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draft', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByDraftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draft', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByIsMentioned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMentioned', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByIsMentionedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMentioned', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByMessageKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageKind', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByMessageKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageKind', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByMessageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByMessageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageType', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByReceiver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiver', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByReceiverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiver', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByUnreadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadCount', Sort.asc);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QAfterSortBy>
      thenByUnreadCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadCount', Sort.desc);
    });
  }
}

extension ChatSessionModelISARQueryWhereDistinct
    on QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct> {
  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByAlwaysTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alwaysTop');
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByAvatar({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatar', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByChatId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByChatName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByChatType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatType');
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByContent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByCreateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createTime');
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByDraft({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'draft', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiration');
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByGroupId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByIsMentioned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMentioned');
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByMessageKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'messageKind');
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByMessageType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'messageType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByReceiver({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiver', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctBySender({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChatSessionModelISAR, ChatSessionModelISAR, QDistinct>
      distinctByUnreadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unreadCount');
    });
  }
}

extension ChatSessionModelISARQueryProperty on QueryBuilder<
    ChatSessionModelISAR, ChatSessionModelISAR, QQueryProperty> {
  QueryBuilder<ChatSessionModelISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChatSessionModelISAR, bool, QQueryOperations>
      alwaysTopProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alwaysTop');
    });
  }

  QueryBuilder<ChatSessionModelISAR, String?, QQueryOperations>
      avatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatar');
    });
  }

  QueryBuilder<ChatSessionModelISAR, String, QQueryOperations>
      chatIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatId');
    });
  }

  QueryBuilder<ChatSessionModelISAR, String?, QQueryOperations>
      chatNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatName');
    });
  }

  QueryBuilder<ChatSessionModelISAR, int, QQueryOperations> chatTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatType');
    });
  }

  QueryBuilder<ChatSessionModelISAR, String?, QQueryOperations>
      contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<ChatSessionModelISAR, int, QQueryOperations>
      createTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createTime');
    });
  }

  QueryBuilder<ChatSessionModelISAR, String?, QQueryOperations>
      draftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'draft');
    });
  }

  QueryBuilder<ChatSessionModelISAR, int?, QQueryOperations>
      expirationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiration');
    });
  }

  QueryBuilder<ChatSessionModelISAR, String?, QQueryOperations>
      groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<ChatSessionModelISAR, bool, QQueryOperations>
      isMentionedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMentioned');
    });
  }

  QueryBuilder<ChatSessionModelISAR, int?, QQueryOperations>
      messageKindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'messageKind');
    });
  }

  QueryBuilder<ChatSessionModelISAR, String?, QQueryOperations>
      messageTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'messageType');
    });
  }

  QueryBuilder<ChatSessionModelISAR, String, QQueryOperations>
      receiverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiver');
    });
  }

  QueryBuilder<ChatSessionModelISAR, String, QQueryOperations>
      senderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sender');
    });
  }

  QueryBuilder<ChatSessionModelISAR, int, QQueryOperations>
      unreadCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unreadCount');
    });
  }
}
