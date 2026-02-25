// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyset_info_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetKeysetInfoIsarCollection on Isar {
  IsarCollection<KeysetInfoIsar> get keysetInfoIsars => this.collection();
}

const KeysetInfoIsarSchema = CollectionSchema(
  name: r'KeysetInfoIsar',
  id: 8982442326780623304,
  properties: {
    r'active': PropertySchema(
      id: 0,
      name: r'active',
      type: IsarType.bool,
    ),
    r'finalExpiry': PropertySchema(
      id: 1,
      name: r'finalExpiry',
      type: IsarType.long,
    ),
    r'inputFeePPK': PropertySchema(
      id: 2,
      name: r'inputFeePPK',
      type: IsarType.long,
    ),
    r'keysetId': PropertySchema(
      id: 3,
      name: r'keysetId',
      type: IsarType.string,
    ),
    r'keysetRaw': PropertySchema(
      id: 4,
      name: r'keysetRaw',
      type: IsarType.string,
    ),
    r'mintURL': PropertySchema(
      id: 5,
      name: r'mintURL',
      type: IsarType.string,
    ),
    r'unit': PropertySchema(
      id: 6,
      name: r'unit',
      type: IsarType.string,
    )
  },
  estimateSize: _keysetInfoIsarEstimateSize,
  serialize: _keysetInfoIsarSerialize,
  deserialize: _keysetInfoIsarDeserialize,
  deserializeProp: _keysetInfoIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'keysetId_mintURL': IndexSchema(
      id: -3044305653571086590,
      name: r'keysetId_mintURL',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'keysetId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'mintURL',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _keysetInfoIsarGetId,
  getLinks: _keysetInfoIsarGetLinks,
  attach: _keysetInfoIsarAttach,
  version: '3.1.0+1',
);

int _keysetInfoIsarEstimateSize(
  KeysetInfoIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.keysetId.length * 3;
  bytesCount += 3 + object.keysetRaw.length * 3;
  bytesCount += 3 + object.mintURL.length * 3;
  bytesCount += 3 + object.unit.length * 3;
  return bytesCount;
}

void _keysetInfoIsarSerialize(
  KeysetInfoIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.active);
  writer.writeLong(offsets[1], object.finalExpiry);
  writer.writeLong(offsets[2], object.inputFeePPK);
  writer.writeString(offsets[3], object.keysetId);
  writer.writeString(offsets[4], object.keysetRaw);
  writer.writeString(offsets[5], object.mintURL);
  writer.writeString(offsets[6], object.unit);
}

KeysetInfoIsar _keysetInfoIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = KeysetInfoIsar(
    active: reader.readBool(offsets[0]),
    finalExpiry: reader.readLongOrNull(offsets[1]),
    inputFeePPK: reader.readLongOrNull(offsets[2]) ?? 0,
    keysetId: reader.readString(offsets[3]),
    keysetRaw: reader.readStringOrNull(offsets[4]) ?? '',
    mintURL: reader.readString(offsets[5]),
    unit: reader.readString(offsets[6]),
  );
  object.id = id;
  return object;
}

P _keysetInfoIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _keysetInfoIsarGetId(KeysetInfoIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _keysetInfoIsarGetLinks(KeysetInfoIsar object) {
  return [];
}

void _keysetInfoIsarAttach(
    IsarCollection<dynamic> col, Id id, KeysetInfoIsar object) {
  object.id = id;
}

extension KeysetInfoIsarByIndex on IsarCollection<KeysetInfoIsar> {
  Future<KeysetInfoIsar?> getByKeysetIdMintURL(
      String keysetId, String mintURL) {
    return getByIndex(r'keysetId_mintURL', [keysetId, mintURL]);
  }

  KeysetInfoIsar? getByKeysetIdMintURLSync(String keysetId, String mintURL) {
    return getByIndexSync(r'keysetId_mintURL', [keysetId, mintURL]);
  }

  Future<bool> deleteByKeysetIdMintURL(String keysetId, String mintURL) {
    return deleteByIndex(r'keysetId_mintURL', [keysetId, mintURL]);
  }

  bool deleteByKeysetIdMintURLSync(String keysetId, String mintURL) {
    return deleteByIndexSync(r'keysetId_mintURL', [keysetId, mintURL]);
  }

  Future<List<KeysetInfoIsar?>> getAllByKeysetIdMintURL(
      List<String> keysetIdValues, List<String> mintURLValues) {
    final len = keysetIdValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([keysetIdValues[i], mintURLValues[i]]);
    }

    return getAllByIndex(r'keysetId_mintURL', values);
  }

  List<KeysetInfoIsar?> getAllByKeysetIdMintURLSync(
      List<String> keysetIdValues, List<String> mintURLValues) {
    final len = keysetIdValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([keysetIdValues[i], mintURLValues[i]]);
    }

    return getAllByIndexSync(r'keysetId_mintURL', values);
  }

  Future<int> deleteAllByKeysetIdMintURL(
      List<String> keysetIdValues, List<String> mintURLValues) {
    final len = keysetIdValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([keysetIdValues[i], mintURLValues[i]]);
    }

    return deleteAllByIndex(r'keysetId_mintURL', values);
  }

  int deleteAllByKeysetIdMintURLSync(
      List<String> keysetIdValues, List<String> mintURLValues) {
    final len = keysetIdValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([keysetIdValues[i], mintURLValues[i]]);
    }

    return deleteAllByIndexSync(r'keysetId_mintURL', values);
  }

  Future<Id> putByKeysetIdMintURL(KeysetInfoIsar object) {
    return putByIndex(r'keysetId_mintURL', object);
  }

  Id putByKeysetIdMintURLSync(KeysetInfoIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'keysetId_mintURL', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKeysetIdMintURL(List<KeysetInfoIsar> objects) {
    return putAllByIndex(r'keysetId_mintURL', objects);
  }

  List<Id> putAllByKeysetIdMintURLSync(List<KeysetInfoIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'keysetId_mintURL', objects,
        saveLinks: saveLinks);
  }
}

extension KeysetInfoIsarQueryWhereSort
    on QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QWhere> {
  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension KeysetInfoIsarQueryWhere
    on QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QWhereClause> {
  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterWhereClause>
      keysetIdEqualToAnyMintURL(String keysetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'keysetId_mintURL',
        value: [keysetId],
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterWhereClause>
      keysetIdNotEqualToAnyMintURL(String keysetId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keysetId_mintURL',
              lower: [],
              upper: [keysetId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keysetId_mintURL',
              lower: [keysetId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keysetId_mintURL',
              lower: [keysetId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keysetId_mintURL',
              lower: [],
              upper: [keysetId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterWhereClause>
      keysetIdMintURLEqualTo(String keysetId, String mintURL) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'keysetId_mintURL',
        value: [keysetId, mintURL],
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterWhereClause>
      keysetIdEqualToMintURLNotEqualTo(String keysetId, String mintURL) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keysetId_mintURL',
              lower: [keysetId],
              upper: [keysetId, mintURL],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keysetId_mintURL',
              lower: [keysetId, mintURL],
              includeLower: false,
              upper: [keysetId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keysetId_mintURL',
              lower: [keysetId, mintURL],
              includeLower: false,
              upper: [keysetId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keysetId_mintURL',
              lower: [keysetId],
              upper: [keysetId, mintURL],
              includeUpper: false,
            ));
      }
    });
  }
}

extension KeysetInfoIsarQueryFilter
    on QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QFilterCondition> {
  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      activeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'active',
        value: value,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      finalExpiryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'finalExpiry',
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      finalExpiryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'finalExpiry',
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      finalExpiryEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finalExpiry',
        value: value,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      finalExpiryGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finalExpiry',
        value: value,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      finalExpiryLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finalExpiry',
        value: value,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      finalExpiryBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finalExpiry',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
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

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
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

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition> idBetween(
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

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      inputFeePPKEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inputFeePPK',
        value: value,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      inputFeePPKGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inputFeePPK',
        value: value,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      inputFeePPKLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inputFeePPK',
        value: value,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      inputFeePPKBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inputFeePPK',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keysetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'keysetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'keysetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'keysetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'keysetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'keysetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'keysetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'keysetId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keysetId',
        value: '',
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'keysetId',
        value: '',
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetRawEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keysetRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetRawGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'keysetRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetRawLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'keysetRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetRawBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'keysetRaw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetRawStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'keysetRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetRawEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'keysetRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetRawContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'keysetRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetRawMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'keysetRaw',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetRawIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keysetRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      keysetRawIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'keysetRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      mintURLEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      mintURLGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      mintURLLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      mintURLBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mintURL',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      mintURLStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      mintURLEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      mintURLContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      mintURLMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mintURL',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      mintURLIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      mintURLIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      unitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      unitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      unitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      unitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      unitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      unitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: '',
      ));
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterFilterCondition>
      unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unit',
        value: '',
      ));
    });
  }
}

extension KeysetInfoIsarQueryObject
    on QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QFilterCondition> {}

extension KeysetInfoIsarQueryLinks
    on QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QFilterCondition> {}

extension KeysetInfoIsarQuerySortBy
    on QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QSortBy> {
  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> sortByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      sortByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      sortByFinalExpiry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalExpiry', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      sortByFinalExpiryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalExpiry', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      sortByInputFeePPK() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputFeePPK', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      sortByInputFeePPKDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputFeePPK', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> sortByKeysetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      sortByKeysetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> sortByKeysetRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetRaw', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      sortByKeysetRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetRaw', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> sortByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      sortByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> sortByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> sortByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension KeysetInfoIsarQuerySortThenBy
    on QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QSortThenBy> {
  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> thenByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      thenByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      thenByFinalExpiry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalExpiry', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      thenByFinalExpiryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalExpiry', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      thenByInputFeePPK() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputFeePPK', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      thenByInputFeePPKDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputFeePPK', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> thenByKeysetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      thenByKeysetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> thenByKeysetRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetRaw', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      thenByKeysetRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetRaw', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> thenByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy>
      thenByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> thenByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QAfterSortBy> thenByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension KeysetInfoIsarQueryWhereDistinct
    on QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QDistinct> {
  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QDistinct> distinctByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'active');
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QDistinct>
      distinctByFinalExpiry() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalExpiry');
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QDistinct>
      distinctByInputFeePPK() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inputFeePPK');
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QDistinct> distinctByKeysetId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keysetId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QDistinct> distinctByKeysetRaw(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keysetRaw', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QDistinct> distinctByMintURL(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mintURL', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QDistinct> distinctByUnit(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unit', caseSensitive: caseSensitive);
    });
  }
}

extension KeysetInfoIsarQueryProperty
    on QueryBuilder<KeysetInfoIsar, KeysetInfoIsar, QQueryProperty> {
  QueryBuilder<KeysetInfoIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<KeysetInfoIsar, bool, QQueryOperations> activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'active');
    });
  }

  QueryBuilder<KeysetInfoIsar, int?, QQueryOperations> finalExpiryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalExpiry');
    });
  }

  QueryBuilder<KeysetInfoIsar, int, QQueryOperations> inputFeePPKProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inputFeePPK');
    });
  }

  QueryBuilder<KeysetInfoIsar, String, QQueryOperations> keysetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keysetId');
    });
  }

  QueryBuilder<KeysetInfoIsar, String, QQueryOperations> keysetRawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keysetRaw');
    });
  }

  QueryBuilder<KeysetInfoIsar, String, QQueryOperations> mintURLProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mintURL');
    });
  }

  QueryBuilder<KeysetInfoIsar, String, QQueryOperations> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unit');
    });
  }
}
