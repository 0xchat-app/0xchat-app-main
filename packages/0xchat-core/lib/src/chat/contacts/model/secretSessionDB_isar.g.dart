// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secretSessionDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSecretSessionDBISARCollection on Isar {
  IsarCollection<SecretSessionDBISAR> get secretSessionDBISARs =>
      this.collection();
}

const SecretSessionDBISARSchema = CollectionSchema(
  name: r'SecretSessionDBISAR',
  id: 2417633045335612265,
  properties: {
    r'expiration': PropertySchema(
      id: 0,
      name: r'expiration',
      type: IsarType.long,
    ),
    r'interval': PropertySchema(
      id: 1,
      name: r'interval',
      type: IsarType.long,
    ),
    r'lastUpdateTime': PropertySchema(
      id: 2,
      name: r'lastUpdateTime',
      type: IsarType.long,
    ),
    r'myAliasPrivkey': PropertySchema(
      id: 3,
      name: r'myAliasPrivkey',
      type: IsarType.string,
    ),
    r'myAliasPubkey': PropertySchema(
      id: 4,
      name: r'myAliasPubkey',
      type: IsarType.string,
    ),
    r'myPubkey': PropertySchema(
      id: 5,
      name: r'myPubkey',
      type: IsarType.string,
    ),
    r'otherFields': PropertySchema(
      id: 6,
      name: r'otherFields',
      type: IsarType.string,
    ),
    r'relay': PropertySchema(
      id: 7,
      name: r'relay',
      type: IsarType.string,
    ),
    r'sessionId': PropertySchema(
      id: 8,
      name: r'sessionId',
      type: IsarType.string,
    ),
    r'sharePubkey': PropertySchema(
      id: 9,
      name: r'sharePubkey',
      type: IsarType.string,
    ),
    r'shareSecretKey': PropertySchema(
      id: 10,
      name: r'shareSecretKey',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 11,
      name: r'status',
      type: IsarType.long,
    ),
    r'toAliasPubkey': PropertySchema(
      id: 12,
      name: r'toAliasPubkey',
      type: IsarType.string,
    ),
    r'toPubkey': PropertySchema(
      id: 13,
      name: r'toPubkey',
      type: IsarType.string,
    )
  },
  estimateSize: _secretSessionDBISAREstimateSize,
  serialize: _secretSessionDBISARSerialize,
  deserialize: _secretSessionDBISARDeserialize,
  deserializeProp: _secretSessionDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'sessionId': IndexSchema(
      id: 6949518585047923839,
      name: r'sessionId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'sessionId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _secretSessionDBISARGetId,
  getLinks: _secretSessionDBISARGetLinks,
  attach: _secretSessionDBISARAttach,
  version: '3.1.0+1',
);

int _secretSessionDBISAREstimateSize(
  SecretSessionDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.myAliasPrivkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.myAliasPubkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.myPubkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.otherFields;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.relay;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sessionId.length * 3;
  {
    final value = object.sharePubkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.shareSecretKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.toAliasPubkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.toPubkey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _secretSessionDBISARSerialize(
  SecretSessionDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.expiration);
  writer.writeLong(offsets[1], object.interval);
  writer.writeLong(offsets[2], object.lastUpdateTime);
  writer.writeString(offsets[3], object.myAliasPrivkey);
  writer.writeString(offsets[4], object.myAliasPubkey);
  writer.writeString(offsets[5], object.myPubkey);
  writer.writeString(offsets[6], object.otherFields);
  writer.writeString(offsets[7], object.relay);
  writer.writeString(offsets[8], object.sessionId);
  writer.writeString(offsets[9], object.sharePubkey);
  writer.writeString(offsets[10], object.shareSecretKey);
  writer.writeLong(offsets[11], object.status);
  writer.writeString(offsets[12], object.toAliasPubkey);
  writer.writeString(offsets[13], object.toPubkey);
}

SecretSessionDBISAR _secretSessionDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SecretSessionDBISAR(
    expiration: reader.readLongOrNull(offsets[0]),
    interval: reader.readLongOrNull(offsets[1]),
    lastUpdateTime: reader.readLongOrNull(offsets[2]) ?? 0,
    myAliasPrivkey: reader.readStringOrNull(offsets[3]),
    myAliasPubkey: reader.readStringOrNull(offsets[4]),
    myPubkey: reader.readStringOrNull(offsets[5]),
    otherFields: reader.readStringOrNull(offsets[6]),
    relay: reader.readStringOrNull(offsets[7]),
    sessionId: reader.readStringOrNull(offsets[8]) ?? '',
    sharePubkey: reader.readStringOrNull(offsets[9]),
    shareSecretKey: reader.readStringOrNull(offsets[10]),
    status: reader.readLongOrNull(offsets[11]),
    toAliasPubkey: reader.readStringOrNull(offsets[12]),
    toPubkey: reader.readStringOrNull(offsets[13]),
  );
  object.id = id;
  return object;
}

P _secretSessionDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _secretSessionDBISARGetId(SecretSessionDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _secretSessionDBISARGetLinks(
    SecretSessionDBISAR object) {
  return [];
}

void _secretSessionDBISARAttach(
    IsarCollection<dynamic> col, Id id, SecretSessionDBISAR object) {
  object.id = id;
}

extension SecretSessionDBISARByIndex on IsarCollection<SecretSessionDBISAR> {
  Future<SecretSessionDBISAR?> getBySessionId(String sessionId) {
    return getByIndex(r'sessionId', [sessionId]);
  }

  SecretSessionDBISAR? getBySessionIdSync(String sessionId) {
    return getByIndexSync(r'sessionId', [sessionId]);
  }

  Future<bool> deleteBySessionId(String sessionId) {
    return deleteByIndex(r'sessionId', [sessionId]);
  }

  bool deleteBySessionIdSync(String sessionId) {
    return deleteByIndexSync(r'sessionId', [sessionId]);
  }

  Future<List<SecretSessionDBISAR?>> getAllBySessionId(
      List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'sessionId', values);
  }

  List<SecretSessionDBISAR?> getAllBySessionIdSync(
      List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'sessionId', values);
  }

  Future<int> deleteAllBySessionId(List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'sessionId', values);
  }

  int deleteAllBySessionIdSync(List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'sessionId', values);
  }

  Future<Id> putBySessionId(SecretSessionDBISAR object) {
    return putByIndex(r'sessionId', object);
  }

  Id putBySessionIdSync(SecretSessionDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'sessionId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySessionId(List<SecretSessionDBISAR> objects) {
    return putAllByIndex(r'sessionId', objects);
  }

  List<Id> putAllBySessionIdSync(List<SecretSessionDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'sessionId', objects, saveLinks: saveLinks);
  }
}

extension SecretSessionDBISARQueryWhereSort
    on QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QWhere> {
  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SecretSessionDBISARQueryWhere
    on QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QWhereClause> {
  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterWhereClause>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterWhereClause>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterWhereClause>
      sessionIdEqualTo(String sessionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sessionId',
        value: [sessionId],
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterWhereClause>
      sessionIdNotEqualTo(String sessionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SecretSessionDBISARQueryFilter on QueryBuilder<SecretSessionDBISAR,
    SecretSessionDBISAR, QFilterCondition> {
  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      expirationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiration',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      expirationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiration',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      expirationEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiration',
        value: value,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      intervalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'interval',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      intervalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'interval',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      intervalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      intervalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      intervalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      intervalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'interval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      lastUpdateTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      lastUpdateTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      lastUpdateTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      lastUpdateTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'myAliasPrivkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'myAliasPrivkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'myAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'myAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'myAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'myAliasPrivkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'myAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'myAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'myAliasPrivkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'myAliasPrivkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'myAliasPrivkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPrivkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'myAliasPrivkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'myAliasPubkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'myAliasPubkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'myAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'myAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'myAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'myAliasPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'myAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'myAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'myAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'myAliasPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'myAliasPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myAliasPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'myAliasPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'myPubkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'myPubkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'myPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'myPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'myPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'myPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'myPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'myPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'myPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'myPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'myPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      myPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'myPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'otherFields',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'otherFields',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'otherFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'otherFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'otherFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'otherFields',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'otherFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'otherFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'otherFields',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'otherFields',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'otherFields',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      otherFieldsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'otherFields',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      relayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relay',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      relayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relay',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      relayEqualTo(
    String? value, {
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      relayGreaterThan(
    String? value, {
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      relayLessThan(
    String? value, {
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      relayBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      relayContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      relayMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relay',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      relayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relay',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      relayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relay',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sharePubkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sharePubkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sharePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sharePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sharePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sharePubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sharePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sharePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sharePubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sharePubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sharePubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      sharePubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sharePubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shareSecretKey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shareSecretKey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shareSecretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shareSecretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shareSecretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shareSecretKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shareSecretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shareSecretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shareSecretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shareSecretKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shareSecretKey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      shareSecretKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shareSecretKey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      statusEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
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

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'toAliasPubkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'toAliasPubkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toAliasPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'toAliasPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'toAliasPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toAliasPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toAliasPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'toAliasPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'toPubkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'toPubkey',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'toPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'toPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'toPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'toPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterFilterCondition>
      toPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'toPubkey',
        value: '',
      ));
    });
  }
}

extension SecretSessionDBISARQueryObject on QueryBuilder<SecretSessionDBISAR,
    SecretSessionDBISAR, QFilterCondition> {}

extension SecretSessionDBISARQueryLinks on QueryBuilder<SecretSessionDBISAR,
    SecretSessionDBISAR, QFilterCondition> {}

extension SecretSessionDBISARQuerySortBy
    on QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QSortBy> {
  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByLastUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdateTime', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByLastUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdateTime', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByMyAliasPrivkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myAliasPrivkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByMyAliasPrivkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myAliasPrivkey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByMyAliasPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myAliasPubkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByMyAliasPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myAliasPubkey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByMyPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myPubkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByMyPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myPubkey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByOtherFields() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherFields', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByOtherFieldsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherFields', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortBySharePubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharePubkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortBySharePubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharePubkey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByShareSecretKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareSecretKey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByShareSecretKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareSecretKey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByToAliasPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPubkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByToAliasPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPubkey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByToPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toPubkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      sortByToPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toPubkey', Sort.desc);
    });
  }
}

extension SecretSessionDBISARQuerySortThenBy
    on QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QSortThenBy> {
  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByLastUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdateTime', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByLastUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdateTime', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByMyAliasPrivkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myAliasPrivkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByMyAliasPrivkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myAliasPrivkey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByMyAliasPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myAliasPubkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByMyAliasPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myAliasPubkey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByMyPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myPubkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByMyPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'myPubkey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByOtherFields() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherFields', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByOtherFieldsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherFields', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenBySharePubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharePubkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenBySharePubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharePubkey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByShareSecretKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareSecretKey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByShareSecretKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shareSecretKey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByToAliasPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPubkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByToAliasPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAliasPubkey', Sort.desc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByToPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toPubkey', Sort.asc);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QAfterSortBy>
      thenByToPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toPubkey', Sort.desc);
    });
  }
}

extension SecretSessionDBISARQueryWhereDistinct
    on QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct> {
  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiration');
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'interval');
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByLastUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdateTime');
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByMyAliasPrivkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'myAliasPrivkey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByMyAliasPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'myAliasPubkey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByMyPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'myPubkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByOtherFields({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'otherFields', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByRelay({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relay', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctBySessionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctBySharePubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sharePubkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByShareSecretKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shareSecretKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByToAliasPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'toAliasPubkey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QDistinct>
      distinctByToPubkey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'toPubkey', caseSensitive: caseSensitive);
    });
  }
}

extension SecretSessionDBISARQueryProperty
    on QueryBuilder<SecretSessionDBISAR, SecretSessionDBISAR, QQueryProperty> {
  QueryBuilder<SecretSessionDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SecretSessionDBISAR, int?, QQueryOperations>
      expirationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiration');
    });
  }

  QueryBuilder<SecretSessionDBISAR, int?, QQueryOperations> intervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interval');
    });
  }

  QueryBuilder<SecretSessionDBISAR, int, QQueryOperations>
      lastUpdateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdateTime');
    });
  }

  QueryBuilder<SecretSessionDBISAR, String?, QQueryOperations>
      myAliasPrivkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'myAliasPrivkey');
    });
  }

  QueryBuilder<SecretSessionDBISAR, String?, QQueryOperations>
      myAliasPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'myAliasPubkey');
    });
  }

  QueryBuilder<SecretSessionDBISAR, String?, QQueryOperations>
      myPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'myPubkey');
    });
  }

  QueryBuilder<SecretSessionDBISAR, String?, QQueryOperations>
      otherFieldsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'otherFields');
    });
  }

  QueryBuilder<SecretSessionDBISAR, String?, QQueryOperations> relayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relay');
    });
  }

  QueryBuilder<SecretSessionDBISAR, String, QQueryOperations>
      sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<SecretSessionDBISAR, String?, QQueryOperations>
      sharePubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sharePubkey');
    });
  }

  QueryBuilder<SecretSessionDBISAR, String?, QQueryOperations>
      shareSecretKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shareSecretKey');
    });
  }

  QueryBuilder<SecretSessionDBISAR, int?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<SecretSessionDBISAR, String?, QQueryOperations>
      toAliasPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'toAliasPubkey');
    });
  }

  QueryBuilder<SecretSessionDBISAR, String?, QQueryOperations>
      toPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'toPubkey');
    });
  }
}
