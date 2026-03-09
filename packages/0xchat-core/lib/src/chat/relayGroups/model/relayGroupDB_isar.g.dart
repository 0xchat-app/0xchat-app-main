// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relayGroupDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRelayGroupDBISARCollection on Isar {
  IsarCollection<RelayGroupDBISAR> get relayGroupDBISARs => this.collection();
}

const RelayGroupDBISARSchema = CollectionSchema(
  name: r'RelayGroupDBISAR',
  id: -7802843868436977726,
  properties: {
    r'about': PropertySchema(
      id: 0,
      name: r'about',
      type: IsarType.string,
    ),
    r'adminsString': PropertySchema(
      id: 1,
      name: r'adminsString',
      type: IsarType.string,
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
    r'groupId': PropertySchema(
      id: 4,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'identifier': PropertySchema(
      id: 5,
      name: r'identifier',
      type: IsarType.string,
    ),
    r'lastAdminsUpdatedTime': PropertySchema(
      id: 6,
      name: r'lastAdminsUpdatedTime',
      type: IsarType.long,
    ),
    r'lastMembersUpdatedTime': PropertySchema(
      id: 7,
      name: r'lastMembersUpdatedTime',
      type: IsarType.long,
    ),
    r'lastUpdatedTime': PropertySchema(
      id: 8,
      name: r'lastUpdatedTime',
      type: IsarType.long,
    ),
    r'level': PropertySchema(
      id: 9,
      name: r'level',
      type: IsarType.long,
    ),
    r'members': PropertySchema(
      id: 10,
      name: r'members',
      type: IsarType.stringList,
    ),
    r'mute': PropertySchema(
      id: 11,
      name: r'mute',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 12,
      name: r'name',
      type: IsarType.string,
    ),
    r'picture': PropertySchema(
      id: 13,
      name: r'picture',
      type: IsarType.string,
    ),
    r'pinned': PropertySchema(
      id: 14,
      name: r'pinned',
      type: IsarType.stringList,
    ),
    r'point': PropertySchema(
      id: 15,
      name: r'point',
      type: IsarType.long,
    ),
    r'private': PropertySchema(
      id: 16,
      name: r'private',
      type: IsarType.bool,
    ),
    r'relay': PropertySchema(
      id: 17,
      name: r'relay',
      type: IsarType.string,
    ),
    r'relayPubkey': PropertySchema(
      id: 18,
      name: r'relayPubkey',
      type: IsarType.string,
    )
  },
  estimateSize: _relayGroupDBISAREstimateSize,
  serialize: _relayGroupDBISARSerialize,
  deserialize: _relayGroupDBISARDeserialize,
  deserializeProp: _relayGroupDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'groupId': IndexSchema(
      id: -8523216633229774932,
      name: r'groupId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'groupId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _relayGroupDBISARGetId,
  getLinks: _relayGroupDBISARGetLinks,
  attach: _relayGroupDBISARAttach,
  version: '3.1.0+1',
);

int _relayGroupDBISAREstimateSize(
  RelayGroupDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.about.length * 3;
  {
    final value = object.adminsString;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.author.length * 3;
  bytesCount += 3 + object.groupId.length * 3;
  bytesCount += 3 + object.identifier.length * 3;
  {
    final list = object.members;
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
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.picture.length * 3;
  {
    final list = object.pinned;
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
  bytesCount += 3 + object.relay.length * 3;
  bytesCount += 3 + object.relayPubkey.length * 3;
  return bytesCount;
}

void _relayGroupDBISARSerialize(
  RelayGroupDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.about);
  writer.writeString(offsets[1], object.adminsString);
  writer.writeString(offsets[2], object.author);
  writer.writeBool(offsets[3], object.closed);
  writer.writeString(offsets[4], object.groupId);
  writer.writeString(offsets[5], object.identifier);
  writer.writeLong(offsets[6], object.lastAdminsUpdatedTime);
  writer.writeLong(offsets[7], object.lastMembersUpdatedTime);
  writer.writeLong(offsets[8], object.lastUpdatedTime);
  writer.writeLong(offsets[9], object.level);
  writer.writeStringList(offsets[10], object.members);
  writer.writeBool(offsets[11], object.mute);
  writer.writeString(offsets[12], object.name);
  writer.writeString(offsets[13], object.picture);
  writer.writeStringList(offsets[14], object.pinned);
  writer.writeLong(offsets[15], object.point);
  writer.writeBool(offsets[16], object.private);
  writer.writeString(offsets[17], object.relay);
  writer.writeString(offsets[18], object.relayPubkey);
}

RelayGroupDBISAR _relayGroupDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RelayGroupDBISAR(
    about: reader.readStringOrNull(offsets[0]) ?? '',
    adminsString: reader.readStringOrNull(offsets[1]),
    author: reader.readStringOrNull(offsets[2]) ?? '',
    closed: reader.readBoolOrNull(offsets[3]) ?? false,
    groupId: reader.readStringOrNull(offsets[4]) ?? '',
    lastAdminsUpdatedTime: reader.readLongOrNull(offsets[6]) ?? 0,
    lastMembersUpdatedTime: reader.readLongOrNull(offsets[7]) ?? 0,
    lastUpdatedTime: reader.readLongOrNull(offsets[8]) ?? 0,
    level: reader.readLongOrNull(offsets[9]) ?? 0,
    members: reader.readStringList(offsets[10]),
    mute: reader.readBoolOrNull(offsets[11]) ?? false,
    name: reader.readStringOrNull(offsets[12]) ?? '',
    picture: reader.readStringOrNull(offsets[13]) ?? '',
    pinned: reader.readStringList(offsets[14]),
    point: reader.readLongOrNull(offsets[15]) ?? 0,
    private: reader.readBoolOrNull(offsets[16]) ?? false,
    relay: reader.readStringOrNull(offsets[17]) ?? '',
    relayPubkey: reader.readStringOrNull(offsets[18]) ?? '',
  );
  object.id = id;
  return object;
}

P _relayGroupDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 7:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 8:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 9:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 10:
      return (reader.readStringList(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 12:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 13:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 14:
      return (reader.readStringList(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 16:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 17:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 18:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _relayGroupDBISARGetId(RelayGroupDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _relayGroupDBISARGetLinks(RelayGroupDBISAR object) {
  return [];
}

void _relayGroupDBISARAttach(
    IsarCollection<dynamic> col, Id id, RelayGroupDBISAR object) {
  object.id = id;
}

extension RelayGroupDBISARByIndex on IsarCollection<RelayGroupDBISAR> {
  Future<RelayGroupDBISAR?> getByGroupId(String groupId) {
    return getByIndex(r'groupId', [groupId]);
  }

  RelayGroupDBISAR? getByGroupIdSync(String groupId) {
    return getByIndexSync(r'groupId', [groupId]);
  }

  Future<bool> deleteByGroupId(String groupId) {
    return deleteByIndex(r'groupId', [groupId]);
  }

  bool deleteByGroupIdSync(String groupId) {
    return deleteByIndexSync(r'groupId', [groupId]);
  }

  Future<List<RelayGroupDBISAR?>> getAllByGroupId(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'groupId', values);
  }

  List<RelayGroupDBISAR?> getAllByGroupIdSync(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'groupId', values);
  }

  Future<int> deleteAllByGroupId(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'groupId', values);
  }

  int deleteAllByGroupIdSync(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'groupId', values);
  }

  Future<Id> putByGroupId(RelayGroupDBISAR object) {
    return putByIndex(r'groupId', object);
  }

  Id putByGroupIdSync(RelayGroupDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'groupId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByGroupId(List<RelayGroupDBISAR> objects) {
    return putAllByIndex(r'groupId', objects);
  }

  List<Id> putAllByGroupIdSync(List<RelayGroupDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'groupId', objects, saveLinks: saveLinks);
  }
}

extension RelayGroupDBISARQueryWhereSort
    on QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QWhere> {
  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RelayGroupDBISARQueryWhere
    on QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QWhereClause> {
  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterWhereClause>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterWhereClause>
      groupIdEqualTo(String groupId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupId',
        value: [groupId],
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterWhereClause>
      groupIdNotEqualTo(String groupId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RelayGroupDBISARQueryFilter
    on QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QFilterCondition> {
  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      aboutContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      aboutMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'about',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      aboutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'about',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      aboutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'about',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'adminsString',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'adminsString',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adminsString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'adminsString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'adminsString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'adminsString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'adminsString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'adminsString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'adminsString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'adminsString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adminsString',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      adminsStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'adminsString',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      authorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      authorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      closedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'closed',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      identifierEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      identifierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      identifierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      identifierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'identifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      identifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      identifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      identifierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      identifierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'identifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      identifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'identifier',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      identifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'identifier',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastAdminsUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAdminsUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastAdminsUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAdminsUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastAdminsUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAdminsUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastAdminsUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAdminsUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastMembersUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMembersUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastMembersUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMembersUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastMembersUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMembersUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastMembersUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMembersUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastUpdatedTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastUpdatedTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastUpdatedTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdatedTime',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      lastUpdatedTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdatedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      levelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      levelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      levelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      levelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'members',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'members',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'members',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'members',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'members',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'members',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      membersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      muteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mute',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pictureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pictureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'picture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pinned',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pinned',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedElementEqualTo(
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedElementGreaterThan(
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedElementLessThan(
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedElementBetween(
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedElementStartsWith(
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedElementEndsWith(
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

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pinned',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinned',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pinned',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pinnedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pointEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'point',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pointGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'point',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pointLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'point',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      pointBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'point',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      privateEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'private',
        value: value,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relay',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relay',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relay',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayPubkeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayPubkeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relayPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayPubkeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relayPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayPubkeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relayPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relayPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relayPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relayPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relayPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterFilterCondition>
      relayPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relayPubkey',
        value: '',
      ));
    });
  }
}

extension RelayGroupDBISARQueryObject
    on QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QFilterCondition> {}

extension RelayGroupDBISARQueryLinks
    on QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QFilterCondition> {}

extension RelayGroupDBISARQuerySortBy
    on QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QSortBy> {
  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> sortByAbout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByAboutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByAdminsString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adminsString', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByAdminsStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adminsString', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closed', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closed', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifier', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifier', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByLastAdminsUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAdminsUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByLastAdminsUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAdminsUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByLastMembersUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMembersUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByLastMembersUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMembersUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByLastUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByLastUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> sortByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByMuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> sortByPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'point', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'point', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByPrivateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> sortByRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByRelayPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayPubkey', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      sortByRelayPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayPubkey', Sort.desc);
    });
  }
}

extension RelayGroupDBISARQuerySortThenBy
    on QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QSortThenBy> {
  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> thenByAbout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByAboutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByAdminsString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adminsString', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByAdminsStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adminsString', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closed', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closed', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifier', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifier', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByLastAdminsUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAdminsUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByLastAdminsUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAdminsUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByLastMembersUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMembersUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByLastMembersUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMembersUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByLastUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByLastUpdatedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTime', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> thenByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByMuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> thenByPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'point', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'point', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByPrivateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy> thenByRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.desc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByRelayPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayPubkey', Sort.asc);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QAfterSortBy>
      thenByRelayPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayPubkey', Sort.desc);
    });
  }
}

extension RelayGroupDBISARQueryWhereDistinct
    on QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct> {
  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct> distinctByAbout(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'about', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByAdminsString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adminsString', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct> distinctByAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closed');
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct> distinctByGroupId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByIdentifier({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'identifier', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByLastAdminsUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAdminsUpdatedTime');
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByLastMembersUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMembersUpdatedTime');
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByLastUpdatedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdatedTime');
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level');
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByMembers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'members');
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct> distinctByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mute');
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct> distinctByPicture(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'picture', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinned');
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'point');
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'private');
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct> distinctByRelay(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relay', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QDistinct>
      distinctByRelayPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relayPubkey', caseSensitive: caseSensitive);
    });
  }
}

extension RelayGroupDBISARQueryProperty
    on QueryBuilder<RelayGroupDBISAR, RelayGroupDBISAR, QQueryProperty> {
  QueryBuilder<RelayGroupDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RelayGroupDBISAR, String, QQueryOperations> aboutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'about');
    });
  }

  QueryBuilder<RelayGroupDBISAR, String?, QQueryOperations>
      adminsStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adminsString');
    });
  }

  QueryBuilder<RelayGroupDBISAR, String, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<RelayGroupDBISAR, bool, QQueryOperations> closedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closed');
    });
  }

  QueryBuilder<RelayGroupDBISAR, String, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<RelayGroupDBISAR, String, QQueryOperations>
      identifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'identifier');
    });
  }

  QueryBuilder<RelayGroupDBISAR, int, QQueryOperations>
      lastAdminsUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAdminsUpdatedTime');
    });
  }

  QueryBuilder<RelayGroupDBISAR, int, QQueryOperations>
      lastMembersUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMembersUpdatedTime');
    });
  }

  QueryBuilder<RelayGroupDBISAR, int, QQueryOperations>
      lastUpdatedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdatedTime');
    });
  }

  QueryBuilder<RelayGroupDBISAR, int, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<RelayGroupDBISAR, List<String>?, QQueryOperations>
      membersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'members');
    });
  }

  QueryBuilder<RelayGroupDBISAR, bool, QQueryOperations> muteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mute');
    });
  }

  QueryBuilder<RelayGroupDBISAR, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<RelayGroupDBISAR, String, QQueryOperations> pictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'picture');
    });
  }

  QueryBuilder<RelayGroupDBISAR, List<String>?, QQueryOperations>
      pinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinned');
    });
  }

  QueryBuilder<RelayGroupDBISAR, int, QQueryOperations> pointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'point');
    });
  }

  QueryBuilder<RelayGroupDBISAR, bool, QQueryOperations> privateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'private');
    });
  }

  QueryBuilder<RelayGroupDBISAR, String, QQueryOperations> relayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relay');
    });
  }

  QueryBuilder<RelayGroupDBISAR, String, QQueryOperations>
      relayPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relayPubkey');
    });
  }
}
