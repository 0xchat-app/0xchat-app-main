// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unblinding_data_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUnblindingDataIsarCollection on Isar {
  IsarCollection<UnblindingDataIsar> get unblindingDataIsars =>
      this.collection();
}

const UnblindingDataIsarSchema = CollectionSchema(
  name: r'UnblindingDataIsar',
  id: 7377238640107104271,
  properties: {
    r'C_': PropertySchema(
      id: 0,
      name: r'C_',
      type: IsarType.string,
    ),
    r'actionTypeRaw': PropertySchema(
      id: 1,
      name: r'actionTypeRaw',
      type: IsarType.long,
    ),
    r'actionValue': PropertySchema(
      id: 2,
      name: r'actionValue',
      type: IsarType.string,
    ),
    r'amount': PropertySchema(
      id: 3,
      name: r'amount',
      type: IsarType.string,
    ),
    r'dleqPlainText': PropertySchema(
      id: 4,
      name: r'dleqPlainText',
      type: IsarType.string,
    ),
    r'keysetId': PropertySchema(
      id: 5,
      name: r'keysetId',
      type: IsarType.string,
    ),
    r'mintURL': PropertySchema(
      id: 6,
      name: r'mintURL',
      type: IsarType.string,
    ),
    r'r': PropertySchema(
      id: 7,
      name: r'r',
      type: IsarType.string,
    ),
    r'secret': PropertySchema(
      id: 8,
      name: r'secret',
      type: IsarType.string,
    ),
    r'unit': PropertySchema(
      id: 9,
      name: r'unit',
      type: IsarType.string,
    )
  },
  estimateSize: _unblindingDataIsarEstimateSize,
  serialize: _unblindingDataIsarSerialize,
  deserialize: _unblindingDataIsarDeserialize,
  deserializeProp: _unblindingDataIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'secret_keysetId': IndexSchema(
      id: -9104079757759622334,
      name: r'secret_keysetId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'secret',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'keysetId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _unblindingDataIsarGetId,
  getLinks: _unblindingDataIsarGetLinks,
  attach: _unblindingDataIsarAttach,
  version: '3.1.0+1',
);

int _unblindingDataIsarEstimateSize(
  UnblindingDataIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.C_.length * 3;
  bytesCount += 3 + object.actionValue.length * 3;
  bytesCount += 3 + object.amount.length * 3;
  bytesCount += 3 + object.dleqPlainText.length * 3;
  bytesCount += 3 + object.keysetId.length * 3;
  bytesCount += 3 + object.mintURL.length * 3;
  bytesCount += 3 + object.r.length * 3;
  bytesCount += 3 + object.secret.length * 3;
  bytesCount += 3 + object.unit.length * 3;
  return bytesCount;
}

void _unblindingDataIsarSerialize(
  UnblindingDataIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.C_);
  writer.writeLong(offsets[1], object.actionTypeRaw);
  writer.writeString(offsets[2], object.actionValue);
  writer.writeString(offsets[3], object.amount);
  writer.writeString(offsets[4], object.dleqPlainText);
  writer.writeString(offsets[5], object.keysetId);
  writer.writeString(offsets[6], object.mintURL);
  writer.writeString(offsets[7], object.r);
  writer.writeString(offsets[8], object.secret);
  writer.writeString(offsets[9], object.unit);
}

UnblindingDataIsar _unblindingDataIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UnblindingDataIsar(
    C_: reader.readString(offsets[0]),
    actionTypeRaw: reader.readLong(offsets[1]),
    actionValue: reader.readString(offsets[2]),
    amount: reader.readString(offsets[3]),
    dleqPlainText: reader.readString(offsets[4]),
    keysetId: reader.readString(offsets[5]),
    mintURL: reader.readString(offsets[6]),
    r: reader.readString(offsets[7]),
    secret: reader.readString(offsets[8]),
    unit: reader.readString(offsets[9]),
  );
  object.id = id;
  return object;
}

P _unblindingDataIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _unblindingDataIsarGetId(UnblindingDataIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _unblindingDataIsarGetLinks(
    UnblindingDataIsar object) {
  return [];
}

void _unblindingDataIsarAttach(
    IsarCollection<dynamic> col, Id id, UnblindingDataIsar object) {
  object.id = id;
}

extension UnblindingDataIsarByIndex on IsarCollection<UnblindingDataIsar> {
  Future<UnblindingDataIsar?> getBySecretKeysetId(
      String secret, String keysetId) {
    return getByIndex(r'secret_keysetId', [secret, keysetId]);
  }

  UnblindingDataIsar? getBySecretKeysetIdSync(String secret, String keysetId) {
    return getByIndexSync(r'secret_keysetId', [secret, keysetId]);
  }

  Future<bool> deleteBySecretKeysetId(String secret, String keysetId) {
    return deleteByIndex(r'secret_keysetId', [secret, keysetId]);
  }

  bool deleteBySecretKeysetIdSync(String secret, String keysetId) {
    return deleteByIndexSync(r'secret_keysetId', [secret, keysetId]);
  }

  Future<List<UnblindingDataIsar?>> getAllBySecretKeysetId(
      List<String> secretValues, List<String> keysetIdValues) {
    final len = secretValues.length;
    assert(keysetIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([secretValues[i], keysetIdValues[i]]);
    }

    return getAllByIndex(r'secret_keysetId', values);
  }

  List<UnblindingDataIsar?> getAllBySecretKeysetIdSync(
      List<String> secretValues, List<String> keysetIdValues) {
    final len = secretValues.length;
    assert(keysetIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([secretValues[i], keysetIdValues[i]]);
    }

    return getAllByIndexSync(r'secret_keysetId', values);
  }

  Future<int> deleteAllBySecretKeysetId(
      List<String> secretValues, List<String> keysetIdValues) {
    final len = secretValues.length;
    assert(keysetIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([secretValues[i], keysetIdValues[i]]);
    }

    return deleteAllByIndex(r'secret_keysetId', values);
  }

  int deleteAllBySecretKeysetIdSync(
      List<String> secretValues, List<String> keysetIdValues) {
    final len = secretValues.length;
    assert(keysetIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([secretValues[i], keysetIdValues[i]]);
    }

    return deleteAllByIndexSync(r'secret_keysetId', values);
  }

  Future<Id> putBySecretKeysetId(UnblindingDataIsar object) {
    return putByIndex(r'secret_keysetId', object);
  }

  Id putBySecretKeysetIdSync(UnblindingDataIsar object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'secret_keysetId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySecretKeysetId(List<UnblindingDataIsar> objects) {
    return putAllByIndex(r'secret_keysetId', objects);
  }

  List<Id> putAllBySecretKeysetIdSync(List<UnblindingDataIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'secret_keysetId', objects, saveLinks: saveLinks);
  }
}

extension UnblindingDataIsarQueryWhereSort
    on QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QWhere> {
  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UnblindingDataIsarQueryWhere
    on QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QWhereClause> {
  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterWhereClause>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterWhereClause>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterWhereClause>
      secretEqualToAnyKeysetId(String secret) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'secret_keysetId',
        value: [secret],
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterWhereClause>
      secretNotEqualToAnyKeysetId(String secret) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'secret_keysetId',
              lower: [],
              upper: [secret],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'secret_keysetId',
              lower: [secret],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'secret_keysetId',
              lower: [secret],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'secret_keysetId',
              lower: [],
              upper: [secret],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterWhereClause>
      secretKeysetIdEqualTo(String secret, String keysetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'secret_keysetId',
        value: [secret, keysetId],
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterWhereClause>
      secretEqualToKeysetIdNotEqualTo(String secret, String keysetId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'secret_keysetId',
              lower: [secret],
              upper: [secret, keysetId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'secret_keysetId',
              lower: [secret, keysetId],
              includeLower: false,
              upper: [secret],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'secret_keysetId',
              lower: [secret, keysetId],
              includeLower: false,
              upper: [secret],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'secret_keysetId',
              lower: [secret],
              upper: [secret, keysetId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension UnblindingDataIsarQueryFilter
    on QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QFilterCondition> {
  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      c_EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'C_',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      c_GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'C_',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      c_LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'C_',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      c_Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'C_',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      c_StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'C_',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      c_EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'C_',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      c_Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'C_',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      c_Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'C_',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      c_IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'C_',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      c_IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'C_',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionTypeRawEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionTypeRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionTypeRawGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionTypeRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionTypeRawLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionTypeRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionTypeRawBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionTypeRaw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionValueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionValueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionValueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionValueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actionValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actionValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionValueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actionValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionValueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actionValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionValue',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      actionValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actionValue',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      amountEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      amountGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      amountLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      amountBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      amountStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      amountEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      amountContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      amountMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'amount',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      amountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      amountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      dleqPlainTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dleqPlainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      dleqPlainTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dleqPlainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      dleqPlainTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dleqPlainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      dleqPlainTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dleqPlainText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      dleqPlainTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dleqPlainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      dleqPlainTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dleqPlainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      dleqPlainTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dleqPlainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      dleqPlainTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dleqPlainText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      dleqPlainTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dleqPlainText',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      dleqPlainTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dleqPlainText',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      keysetIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'keysetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      keysetIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'keysetId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      keysetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keysetId',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      keysetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'keysetId',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      mintURLContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      mintURLMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mintURL',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      mintURLIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      mintURLIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      rEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'r',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      rGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'r',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      rLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'r',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      rBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'r',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      rStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'r',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      rEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'r',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      rContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'r',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      rMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'r',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      rIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'r',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      rIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'r',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      secretEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      secretGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      secretLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      secretBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'secret',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      secretStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      secretEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      secretContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      secretMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'secret',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      secretIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secret',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      secretIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'secret',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
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

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      unitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      unitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unit',
        value: '',
      ));
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterFilterCondition>
      unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unit',
        value: '',
      ));
    });
  }
}

extension UnblindingDataIsarQueryObject
    on QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QFilterCondition> {}

extension UnblindingDataIsarQueryLinks
    on QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QFilterCondition> {}

extension UnblindingDataIsarQuerySortBy
    on QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QSortBy> {
  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByC_() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'C_', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByC_Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'C_', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByActionTypeRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionTypeRaw', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByActionTypeRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionTypeRaw', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByActionValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionValue', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByActionValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionValue', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByDleqPlainText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dleqPlainText', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByDleqPlainTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dleqPlainText', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByKeysetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByKeysetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy> sortByR() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'r', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByRDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'r', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortBySecret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortBySecretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      sortByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension UnblindingDataIsarQuerySortThenBy
    on QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QSortThenBy> {
  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByC_() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'C_', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByC_Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'C_', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByActionTypeRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionTypeRaw', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByActionTypeRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionTypeRaw', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByActionValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionValue', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByActionValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionValue', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByDleqPlainText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dleqPlainText', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByDleqPlainTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dleqPlainText', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByKeysetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByKeysetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy> thenByR() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'r', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByRDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'r', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenBySecret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenBySecretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.desc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.asc);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QAfterSortBy>
      thenByUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unit', Sort.desc);
    });
  }
}

extension UnblindingDataIsarQueryWhereDistinct
    on QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QDistinct> {
  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QDistinct> distinctByC_(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'C_', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QDistinct>
      distinctByActionTypeRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionTypeRaw');
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QDistinct>
      distinctByActionValue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionValue', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QDistinct>
      distinctByAmount({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QDistinct>
      distinctByDleqPlainText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dleqPlainText',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QDistinct>
      distinctByKeysetId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keysetId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QDistinct>
      distinctByMintURL({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mintURL', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QDistinct> distinctByR(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'r', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QDistinct>
      distinctBySecret({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secret', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QDistinct>
      distinctByUnit({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unit', caseSensitive: caseSensitive);
    });
  }
}

extension UnblindingDataIsarQueryProperty
    on QueryBuilder<UnblindingDataIsar, UnblindingDataIsar, QQueryProperty> {
  QueryBuilder<UnblindingDataIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UnblindingDataIsar, String, QQueryOperations> C_Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'C_');
    });
  }

  QueryBuilder<UnblindingDataIsar, int, QQueryOperations>
      actionTypeRawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionTypeRaw');
    });
  }

  QueryBuilder<UnblindingDataIsar, String, QQueryOperations>
      actionValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionValue');
    });
  }

  QueryBuilder<UnblindingDataIsar, String, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<UnblindingDataIsar, String, QQueryOperations>
      dleqPlainTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dleqPlainText');
    });
  }

  QueryBuilder<UnblindingDataIsar, String, QQueryOperations>
      keysetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keysetId');
    });
  }

  QueryBuilder<UnblindingDataIsar, String, QQueryOperations> mintURLProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mintURL');
    });
  }

  QueryBuilder<UnblindingDataIsar, String, QQueryOperations> rProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'r');
    });
  }

  QueryBuilder<UnblindingDataIsar, String, QQueryOperations> secretProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secret');
    });
  }

  QueryBuilder<UnblindingDataIsar, String, QQueryOperations> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unit');
    });
  }
}
