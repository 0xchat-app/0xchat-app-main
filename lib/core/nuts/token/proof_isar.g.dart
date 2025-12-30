// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProofIsarCollection on Isar {
  IsarCollection<ProofIsar> get proofIsars => this.collection();
}

const ProofIsarSchema = CollectionSchema(
  name: r'ProofIsar',
  id: -5486975512622912656,
  properties: {
    r'C': PropertySchema(
      id: 0,
      name: r'C',
      type: IsarType.string,
    ),
    r'amount': PropertySchema(
      id: 1,
      name: r'amount',
      type: IsarType.string,
    ),
    r'dleqPlainText': PropertySchema(
      id: 2,
      name: r'dleqPlainText',
      type: IsarType.string,
    ),
    r'keysetId': PropertySchema(
      id: 3,
      name: r'keysetId',
      type: IsarType.string,
    ),
    r'lastCheckedMs': PropertySchema(
      id: 4,
      name: r'lastCheckedMs',
      type: IsarType.long,
    ),
    r'secret': PropertySchema(
      id: 5,
      name: r'secret',
      type: IsarType.string,
    ),
    r'stateRaw': PropertySchema(
      id: 6,
      name: r'stateRaw',
      type: IsarType.long,
    )
  },
  estimateSize: _proofIsarEstimateSize,
  serialize: _proofIsarSerialize,
  deserialize: _proofIsarDeserialize,
  deserializeProp: _proofIsarDeserializeProp,
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
  getId: _proofIsarGetId,
  getLinks: _proofIsarGetLinks,
  attach: _proofIsarAttach,
  version: '3.1.0+1',
);

int _proofIsarEstimateSize(
  ProofIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.C.length * 3;
  bytesCount += 3 + object.amount.length * 3;
  bytesCount += 3 + object.dleqPlainText.length * 3;
  bytesCount += 3 + object.keysetId.length * 3;
  bytesCount += 3 + object.secret.length * 3;
  return bytesCount;
}

void _proofIsarSerialize(
  ProofIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.C);
  writer.writeString(offsets[1], object.amount);
  writer.writeString(offsets[2], object.dleqPlainText);
  writer.writeString(offsets[3], object.keysetId);
  writer.writeLong(offsets[4], object.lastCheckedMs);
  writer.writeString(offsets[5], object.secret);
  writer.writeLong(offsets[6], object.stateRaw);
}

ProofIsar _proofIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProofIsar(
    C: reader.readString(offsets[0]),
    amount: reader.readString(offsets[1]),
    dleqPlainText: reader.readString(offsets[2]),
    keysetId: reader.readString(offsets[3]),
    lastCheckedMs: reader.readLongOrNull(offsets[4]) ?? 0,
    secret: reader.readString(offsets[5]),
    stateRaw: reader.readLongOrNull(offsets[6]) ?? 0,
  );
  object.id = id;
  return object;
}

P _proofIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _proofIsarGetId(ProofIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _proofIsarGetLinks(ProofIsar object) {
  return [];
}

void _proofIsarAttach(IsarCollection<dynamic> col, Id id, ProofIsar object) {
  object.id = id;
}

extension ProofIsarByIndex on IsarCollection<ProofIsar> {
  Future<ProofIsar?> getBySecretKeysetId(String secret, String keysetId) {
    return getByIndex(r'secret_keysetId', [secret, keysetId]);
  }

  ProofIsar? getBySecretKeysetIdSync(String secret, String keysetId) {
    return getByIndexSync(r'secret_keysetId', [secret, keysetId]);
  }

  Future<bool> deleteBySecretKeysetId(String secret, String keysetId) {
    return deleteByIndex(r'secret_keysetId', [secret, keysetId]);
  }

  bool deleteBySecretKeysetIdSync(String secret, String keysetId) {
    return deleteByIndexSync(r'secret_keysetId', [secret, keysetId]);
  }

  Future<List<ProofIsar?>> getAllBySecretKeysetId(
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

  List<ProofIsar?> getAllBySecretKeysetIdSync(
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

  Future<Id> putBySecretKeysetId(ProofIsar object) {
    return putByIndex(r'secret_keysetId', object);
  }

  Id putBySecretKeysetIdSync(ProofIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'secret_keysetId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySecretKeysetId(List<ProofIsar> objects) {
    return putAllByIndex(r'secret_keysetId', objects);
  }

  List<Id> putAllBySecretKeysetIdSync(List<ProofIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'secret_keysetId', objects, saveLinks: saveLinks);
  }
}

extension ProofIsarQueryWhereSort
    on QueryBuilder<ProofIsar, ProofIsar, QWhere> {
  QueryBuilder<ProofIsar, ProofIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProofIsarQueryWhere
    on QueryBuilder<ProofIsar, ProofIsar, QWhereClause> {
  QueryBuilder<ProofIsar, ProofIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterWhereClause>
      secretEqualToAnyKeysetId(String secret) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'secret_keysetId',
        value: [secret],
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterWhereClause>
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterWhereClause> secretKeysetIdEqualTo(
      String secret, String keysetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'secret_keysetId',
        value: [secret, keysetId],
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterWhereClause>
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

extension ProofIsarQueryFilter
    on QueryBuilder<ProofIsar, ProofIsar, QFilterCondition> {
  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> cEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'C',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> cGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'C',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> cLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'C',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> cBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'C',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> cStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'C',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> cEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'C',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> cContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'C',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> cMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'C',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> cIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'C',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> cIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'C',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> amountEqualTo(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> amountGreaterThan(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> amountLessThan(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> amountBetween(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> amountStartsWith(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> amountEndsWith(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> amountContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> amountMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'amount',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> amountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> amountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
      dleqPlainTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dleqPlainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
      dleqPlainTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dleqPlainText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
      dleqPlainTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dleqPlainText',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
      dleqPlainTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dleqPlainText',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> keysetIdEqualTo(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> keysetIdGreaterThan(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> keysetIdLessThan(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> keysetIdBetween(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> keysetIdStartsWith(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> keysetIdEndsWith(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> keysetIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'keysetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> keysetIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'keysetId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> keysetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keysetId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
      keysetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'keysetId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
      lastCheckedMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCheckedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
      lastCheckedMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCheckedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
      lastCheckedMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCheckedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition>
      lastCheckedMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCheckedMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> secretEqualTo(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> secretGreaterThan(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> secretLessThan(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> secretBetween(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> secretStartsWith(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> secretEndsWith(
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

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> secretContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'secret',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> secretMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'secret',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> secretIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secret',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> secretIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'secret',
        value: '',
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> stateRawEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> stateRawGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> stateRawLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterFilterCondition> stateRawBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateRaw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProofIsarQueryObject
    on QueryBuilder<ProofIsar, ProofIsar, QFilterCondition> {}

extension ProofIsarQueryLinks
    on QueryBuilder<ProofIsar, ProofIsar, QFilterCondition> {}

extension ProofIsarQuerySortBy on QueryBuilder<ProofIsar, ProofIsar, QSortBy> {
  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'C', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'C', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByDleqPlainText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dleqPlainText', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByDleqPlainTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dleqPlainText', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByKeysetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByKeysetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByLastCheckedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckedMs', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByLastCheckedMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckedMs', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortBySecret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortBySecretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByStateRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateRaw', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> sortByStateRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateRaw', Sort.desc);
    });
  }
}

extension ProofIsarQuerySortThenBy
    on QueryBuilder<ProofIsar, ProofIsar, QSortThenBy> {
  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'C', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'C', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByDleqPlainText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dleqPlainText', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByDleqPlainTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dleqPlainText', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByKeysetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByKeysetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keysetId', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByLastCheckedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckedMs', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByLastCheckedMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckedMs', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenBySecret() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenBySecretDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secret', Sort.desc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByStateRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateRaw', Sort.asc);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QAfterSortBy> thenByStateRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateRaw', Sort.desc);
    });
  }
}

extension ProofIsarQueryWhereDistinct
    on QueryBuilder<ProofIsar, ProofIsar, QDistinct> {
  QueryBuilder<ProofIsar, ProofIsar, QDistinct> distinctByC(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'C', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QDistinct> distinctByAmount(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QDistinct> distinctByDleqPlainText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dleqPlainText',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QDistinct> distinctByKeysetId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keysetId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QDistinct> distinctByLastCheckedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCheckedMs');
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QDistinct> distinctBySecret(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secret', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProofIsar, ProofIsar, QDistinct> distinctByStateRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateRaw');
    });
  }
}

extension ProofIsarQueryProperty
    on QueryBuilder<ProofIsar, ProofIsar, QQueryProperty> {
  QueryBuilder<ProofIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProofIsar, String, QQueryOperations> CProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'C');
    });
  }

  QueryBuilder<ProofIsar, String, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<ProofIsar, String, QQueryOperations> dleqPlainTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dleqPlainText');
    });
  }

  QueryBuilder<ProofIsar, String, QQueryOperations> keysetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keysetId');
    });
  }

  QueryBuilder<ProofIsar, int, QQueryOperations> lastCheckedMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCheckedMs');
    });
  }

  QueryBuilder<ProofIsar, String, QQueryOperations> secretProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secret');
    });
  }

  QueryBuilder<ProofIsar, int, QQueryOperations> stateRawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateRaw');
    });
  }
}
