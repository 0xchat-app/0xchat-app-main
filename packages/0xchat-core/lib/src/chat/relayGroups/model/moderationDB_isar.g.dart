// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderationDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetModerationDBISARCollection on Isar {
  IsarCollection<ModerationDBISAR> get moderationDBISARs => this.collection();
}

const ModerationDBISARSchema = CollectionSchema(
  name: r'ModerationDBISAR',
  id: 4640768754965895893,
  properties: {
    r'about': PropertySchema(
      id: 0,
      name: r'about',
      type: IsarType.string,
    ),
    r'actionKind': PropertySchema(
      id: 1,
      name: r'actionKind',
      type: IsarType.long,
    ),
    r'author': PropertySchema(
      id: 2,
      name: r'author',
      type: IsarType.string,
    ),
    r'closed': PropertySchema(
      id: 3,
      name: r'closed',
      type: IsarType.bool,
    ),
    r'content': PropertySchema(
      id: 4,
      name: r'content',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 5,
      name: r'createdAt',
      type: IsarType.long,
    ),
    r'eventId': PropertySchema(
      id: 6,
      name: r'eventId',
      type: IsarType.string,
    ),
    r'groupId': PropertySchema(
      id: 7,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'moderationId': PropertySchema(
      id: 8,
      name: r'moderationId',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 9,
      name: r'name',
      type: IsarType.string,
    ),
    r'permission': PropertySchema(
      id: 10,
      name: r'permission',
      type: IsarType.string,
    ),
    r'permissions': PropertySchema(
      id: 11,
      name: r'permissions',
      type: IsarType.stringList,
    ),
    r'picture': PropertySchema(
      id: 12,
      name: r'picture',
      type: IsarType.string,
    ),
    r'pinned': PropertySchema(
      id: 13,
      name: r'pinned',
      type: IsarType.string,
    ),
    r'previous': PropertySchema(
      id: 14,
      name: r'previous',
      type: IsarType.stringList,
    ),
    r'private': PropertySchema(
      id: 15,
      name: r'private',
      type: IsarType.bool,
    ),
    r'users': PropertySchema(
      id: 16,
      name: r'users',
      type: IsarType.stringList,
    )
  },
  estimateSize: _moderationDBISAREstimateSize,
  serialize: _moderationDBISARSerialize,
  deserialize: _moderationDBISARDeserialize,
  deserializeProp: _moderationDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'moderationId': IndexSchema(
      id: 826480700473105319,
      name: r'moderationId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'moderationId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _moderationDBISARGetId,
  getLinks: _moderationDBISARGetLinks,
  attach: _moderationDBISARAttach,
  version: '3.1.0+1',
);

int _moderationDBISAREstimateSize(
  ModerationDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.about.length * 3;
  bytesCount += 3 + object.author.length * 3;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.eventId.length * 3;
  bytesCount += 3 + object.groupId.length * 3;
  bytesCount += 3 + object.moderationId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.permission.length * 3;
  {
    final list = object.permissions;
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
  bytesCount += 3 + object.picture.length * 3;
  bytesCount += 3 + object.pinned.length * 3;
  {
    final list = object.previous;
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
  {
    final list = object.users;
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

void _moderationDBISARSerialize(
  ModerationDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.about);
  writer.writeLong(offsets[1], object.actionKind);
  writer.writeString(offsets[2], object.author);
  writer.writeBool(offsets[3], object.closed);
  writer.writeString(offsets[4], object.content);
  writer.writeLong(offsets[5], object.createdAt);
  writer.writeString(offsets[6], object.eventId);
  writer.writeString(offsets[7], object.groupId);
  writer.writeString(offsets[8], object.moderationId);
  writer.writeString(offsets[9], object.name);
  writer.writeString(offsets[10], object.permission);
  writer.writeStringList(offsets[11], object.permissions);
  writer.writeString(offsets[12], object.picture);
  writer.writeString(offsets[13], object.pinned);
  writer.writeStringList(offsets[14], object.previous);
  writer.writeBool(offsets[15], object.private);
  writer.writeStringList(offsets[16], object.users);
}

ModerationDBISAR _moderationDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ModerationDBISAR(
    about: reader.readStringOrNull(offsets[0]) ?? '',
    actionKind: reader.readLongOrNull(offsets[1]) ?? 0,
    author: reader.readStringOrNull(offsets[2]) ?? '',
    closed: reader.readBoolOrNull(offsets[3]) ?? false,
    content: reader.readStringOrNull(offsets[4]) ?? '',
    createdAt: reader.readLongOrNull(offsets[5]) ?? 0,
    eventId: reader.readStringOrNull(offsets[6]) ?? '',
    groupId: reader.readStringOrNull(offsets[7]) ?? '',
    moderationId: reader.readStringOrNull(offsets[8]) ?? '',
    name: reader.readStringOrNull(offsets[9]) ?? '',
    permission: reader.readStringOrNull(offsets[10]) ?? '',
    permissions: reader.readStringList(offsets[11]),
    picture: reader.readStringOrNull(offsets[12]) ?? '',
    pinned: reader.readStringOrNull(offsets[13]) ?? '',
    previous: reader.readStringList(offsets[14]),
    private: reader.readBoolOrNull(offsets[15]) ?? false,
    users: reader.readStringList(offsets[16]),
  );
  object.id = id;
  return object;
}

P _moderationDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 9:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 10:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 11:
      return (reader.readStringList(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 13:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 14:
      return (reader.readStringList(offset)) as P;
    case 15:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 16:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _moderationDBISARGetId(ModerationDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _moderationDBISARGetLinks(ModerationDBISAR object) {
  return [];
}

void _moderationDBISARAttach(
    IsarCollection<dynamic> col, Id id, ModerationDBISAR object) {
  object.id = id;
}

extension ModerationDBISARByIndex on IsarCollection<ModerationDBISAR> {
  Future<ModerationDBISAR?> getByModerationId(String moderationId) {
    return getByIndex(r'moderationId', [moderationId]);
  }

  ModerationDBISAR? getByModerationIdSync(String moderationId) {
    return getByIndexSync(r'moderationId', [moderationId]);
  }

  Future<bool> deleteByModerationId(String moderationId) {
    return deleteByIndex(r'moderationId', [moderationId]);
  }

  bool deleteByModerationIdSync(String moderationId) {
    return deleteByIndexSync(r'moderationId', [moderationId]);
  }

  Future<List<ModerationDBISAR?>> getAllByModerationId(
      List<String> moderationIdValues) {
    final values = moderationIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'moderationId', values);
  }

  List<ModerationDBISAR?> getAllByModerationIdSync(
      List<String> moderationIdValues) {
    final values = moderationIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'moderationId', values);
  }

  Future<int> deleteAllByModerationId(List<String> moderationIdValues) {
    final values = moderationIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'moderationId', values);
  }

  int deleteAllByModerationIdSync(List<String> moderationIdValues) {
    final values = moderationIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'moderationId', values);
  }

  Future<Id> putByModerationId(ModerationDBISAR object) {
    return putByIndex(r'moderationId', object);
  }

  Id putByModerationIdSync(ModerationDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'moderationId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByModerationId(List<ModerationDBISAR> objects) {
    return putAllByIndex(r'moderationId', objects);
  }

  List<Id> putAllByModerationIdSync(List<ModerationDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'moderationId', objects, saveLinks: saveLinks);
  }
}

extension ModerationDBISARQueryWhereSort
    on QueryBuilder<ModerationDBISAR, ModerationDBISAR, QWhere> {
  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ModerationDBISARQueryWhere
    on QueryBuilder<ModerationDBISAR, ModerationDBISAR, QWhereClause> {
  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterWhereClause>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterWhereClause>
      moderationIdEqualTo(String moderationId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'moderationId',
        value: [moderationId],
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterWhereClause>
      moderationIdNotEqualTo(String moderationId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moderationId',
              lower: [],
              upper: [moderationId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moderationId',
              lower: [moderationId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moderationId',
              lower: [moderationId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'moderationId',
              lower: [],
              upper: [moderationId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ModerationDBISARQueryFilter
    on QueryBuilder<ModerationDBISAR, ModerationDBISAR, QFilterCondition> {
  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      aboutEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      aboutGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      aboutLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      aboutBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'about',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      aboutStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      aboutEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      aboutContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      aboutMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'about',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      aboutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'about',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      aboutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'about',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      actionKindEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionKind',
        value: value,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      actionKindGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionKind',
        value: value,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      actionKindLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionKind',
        value: value,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      actionKindBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionKind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      authorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      authorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      authorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      authorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      authorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      authorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      authorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      authorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      closedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'closed',
        value: value,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      createdAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      createdAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      createdAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      createdAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      eventIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      eventIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      eventIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      eventIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      eventIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      eventIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      eventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      eventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      eventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      eventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      moderationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moderationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      moderationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moderationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      moderationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moderationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      moderationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moderationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      moderationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moderationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      moderationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moderationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      moderationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moderationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      moderationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moderationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      moderationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moderationId',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      moderationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moderationId',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'permission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'permission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'permission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'permission',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'permission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'permission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'permission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'permission',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'permission',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'permission',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'permissions',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'permissions',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'permissions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'permissions',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'permissions',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'permissions',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      permissionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pictureEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pictureGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pictureLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pictureBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'picture',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pictureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pictureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pictureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pictureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'picture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pinnedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pinnedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pinnedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pinnedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pinned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pinnedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pinnedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pinnedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pinnedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pinned',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pinnedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinned',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      pinnedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pinned',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'previous',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'previous',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previous',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'previous',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'previous',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previous',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'previous',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'previous',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'previous',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'previous',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'previous',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'previous',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      previousLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'previous',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      privateEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'private',
        value: value,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'users',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'users',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'users',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'users',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'users',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'users',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'users',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'users',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'users',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'users',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'users',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'users',
        value: '',
      ));
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'users',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'users',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'users',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'users',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'users',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterFilterCondition>
      usersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'users',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ModerationDBISARQueryObject
    on QueryBuilder<ModerationDBISAR, ModerationDBISAR, QFilterCondition> {}

extension ModerationDBISARQueryLinks
    on QueryBuilder<ModerationDBISAR, ModerationDBISAR, QFilterCondition> {}

extension ModerationDBISARQuerySortBy
    on QueryBuilder<ModerationDBISAR, ModerationDBISAR, QSortBy> {
  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy> sortByAbout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByAboutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByActionKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionKind', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByActionKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionKind', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closed', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closed', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByModerationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moderationId', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByModerationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moderationId', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByPermission() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permission', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByPermissionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permission', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      sortByPrivateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.desc);
    });
  }
}

extension ModerationDBISARQuerySortThenBy
    on QueryBuilder<ModerationDBISAR, ModerationDBISAR, QSortThenBy> {
  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy> thenByAbout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByAboutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByActionKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionKind', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByActionKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionKind', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closed', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closed', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByModerationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moderationId', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByModerationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moderationId', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByPermission() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permission', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByPermissionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permission', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pinned', Sort.desc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.asc);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QAfterSortBy>
      thenByPrivateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.desc);
    });
  }
}

extension ModerationDBISARQueryWhereDistinct
    on QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct> {
  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct> distinctByAbout(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'about', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct>
      distinctByActionKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionKind');
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct> distinctByAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct>
      distinctByClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closed');
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct> distinctByEventId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct> distinctByGroupId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct>
      distinctByModerationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moderationId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct>
      distinctByPermission({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'permission', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct>
      distinctByPermissions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'permissions');
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct> distinctByPicture(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'picture', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct> distinctByPinned(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinned', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct>
      distinctByPrevious() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previous');
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct>
      distinctByPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'private');
    });
  }

  QueryBuilder<ModerationDBISAR, ModerationDBISAR, QDistinct>
      distinctByUsers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'users');
    });
  }
}

extension ModerationDBISARQueryProperty
    on QueryBuilder<ModerationDBISAR, ModerationDBISAR, QQueryProperty> {
  QueryBuilder<ModerationDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ModerationDBISAR, String, QQueryOperations> aboutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'about');
    });
  }

  QueryBuilder<ModerationDBISAR, int, QQueryOperations> actionKindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionKind');
    });
  }

  QueryBuilder<ModerationDBISAR, String, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<ModerationDBISAR, bool, QQueryOperations> closedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closed');
    });
  }

  QueryBuilder<ModerationDBISAR, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<ModerationDBISAR, int, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ModerationDBISAR, String, QQueryOperations> eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<ModerationDBISAR, String, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<ModerationDBISAR, String, QQueryOperations>
      moderationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moderationId');
    });
  }

  QueryBuilder<ModerationDBISAR, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ModerationDBISAR, String, QQueryOperations>
      permissionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'permission');
    });
  }

  QueryBuilder<ModerationDBISAR, List<String>?, QQueryOperations>
      permissionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'permissions');
    });
  }

  QueryBuilder<ModerationDBISAR, String, QQueryOperations> pictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'picture');
    });
  }

  QueryBuilder<ModerationDBISAR, String, QQueryOperations> pinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinned');
    });
  }

  QueryBuilder<ModerationDBISAR, List<String>?, QQueryOperations>
      previousProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previous');
    });
  }

  QueryBuilder<ModerationDBISAR, bool, QQueryOperations> privateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'private');
    });
  }

  QueryBuilder<ModerationDBISAR, List<String>?, QQueryOperations>
      usersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'users');
    });
  }
}
