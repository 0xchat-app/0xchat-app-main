// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lightning_invoice_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLightningInvoiceIsarCollection on Isar {
  IsarCollection<LightningInvoiceIsar> get lightningInvoiceIsars =>
      this.collection();
}

const LightningInvoiceIsarSchema = CollectionSchema(
  name: r'LightningInvoiceIsar',
  id: -1612312075956243431,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.string,
    ),
    r'hash': PropertySchema(
      id: 1,
      name: r'hash',
      type: IsarType.string,
    ),
    r'mintURL': PropertySchema(
      id: 2,
      name: r'mintURL',
      type: IsarType.string,
    ),
    r'pr': PropertySchema(
      id: 3,
      name: r'pr',
      type: IsarType.string,
    )
  },
  estimateSize: _lightningInvoiceIsarEstimateSize,
  serialize: _lightningInvoiceIsarSerialize,
  deserialize: _lightningInvoiceIsarDeserialize,
  deserializeProp: _lightningInvoiceIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'hash_mintURL': IndexSchema(
      id: -8811729844125040378,
      name: r'hash_mintURL',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'hash',
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
  getId: _lightningInvoiceIsarGetId,
  getLinks: _lightningInvoiceIsarGetLinks,
  attach: _lightningInvoiceIsarAttach,
  version: '3.1.0+1',
);

int _lightningInvoiceIsarEstimateSize(
  LightningInvoiceIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.amount.length * 3;
  bytesCount += 3 + object.hash.length * 3;
  bytesCount += 3 + object.mintURL.length * 3;
  bytesCount += 3 + object.pr.length * 3;
  return bytesCount;
}

void _lightningInvoiceIsarSerialize(
  LightningInvoiceIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.amount);
  writer.writeString(offsets[1], object.hash);
  writer.writeString(offsets[2], object.mintURL);
  writer.writeString(offsets[3], object.pr);
}

LightningInvoiceIsar _lightningInvoiceIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LightningInvoiceIsar(
    amount: reader.readString(offsets[0]),
    hash: reader.readString(offsets[1]),
    mintURL: reader.readString(offsets[2]),
    pr: reader.readString(offsets[3]),
  );
  object.id = id;
  return object;
}

P _lightningInvoiceIsarDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _lightningInvoiceIsarGetId(LightningInvoiceIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _lightningInvoiceIsarGetLinks(
    LightningInvoiceIsar object) {
  return [];
}

void _lightningInvoiceIsarAttach(
    IsarCollection<dynamic> col, Id id, LightningInvoiceIsar object) {
  object.id = id;
}

extension LightningInvoiceIsarByIndex on IsarCollection<LightningInvoiceIsar> {
  Future<LightningInvoiceIsar?> getByHashMintURL(String hash, String mintURL) {
    return getByIndex(r'hash_mintURL', [hash, mintURL]);
  }

  LightningInvoiceIsar? getByHashMintURLSync(String hash, String mintURL) {
    return getByIndexSync(r'hash_mintURL', [hash, mintURL]);
  }

  Future<bool> deleteByHashMintURL(String hash, String mintURL) {
    return deleteByIndex(r'hash_mintURL', [hash, mintURL]);
  }

  bool deleteByHashMintURLSync(String hash, String mintURL) {
    return deleteByIndexSync(r'hash_mintURL', [hash, mintURL]);
  }

  Future<List<LightningInvoiceIsar?>> getAllByHashMintURL(
      List<String> hashValues, List<String> mintURLValues) {
    final len = hashValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([hashValues[i], mintURLValues[i]]);
    }

    return getAllByIndex(r'hash_mintURL', values);
  }

  List<LightningInvoiceIsar?> getAllByHashMintURLSync(
      List<String> hashValues, List<String> mintURLValues) {
    final len = hashValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([hashValues[i], mintURLValues[i]]);
    }

    return getAllByIndexSync(r'hash_mintURL', values);
  }

  Future<int> deleteAllByHashMintURL(
      List<String> hashValues, List<String> mintURLValues) {
    final len = hashValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([hashValues[i], mintURLValues[i]]);
    }

    return deleteAllByIndex(r'hash_mintURL', values);
  }

  int deleteAllByHashMintURLSync(
      List<String> hashValues, List<String> mintURLValues) {
    final len = hashValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([hashValues[i], mintURLValues[i]]);
    }

    return deleteAllByIndexSync(r'hash_mintURL', values);
  }

  Future<Id> putByHashMintURL(LightningInvoiceIsar object) {
    return putByIndex(r'hash_mintURL', object);
  }

  Id putByHashMintURLSync(LightningInvoiceIsar object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'hash_mintURL', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByHashMintURL(List<LightningInvoiceIsar> objects) {
    return putAllByIndex(r'hash_mintURL', objects);
  }

  List<Id> putAllByHashMintURLSync(List<LightningInvoiceIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'hash_mintURL', objects, saveLinks: saveLinks);
  }
}

extension LightningInvoiceIsarQueryWhereSort
    on QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QWhere> {
  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LightningInvoiceIsarQueryWhere
    on QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QWhereClause> {
  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterWhereClause>
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterWhereClause>
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterWhereClause>
      hashEqualToAnyMintURL(String hash) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'hash_mintURL',
        value: [hash],
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterWhereClause>
      hashNotEqualToAnyMintURL(String hash) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash_mintURL',
              lower: [],
              upper: [hash],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash_mintURL',
              lower: [hash],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash_mintURL',
              lower: [hash],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash_mintURL',
              lower: [],
              upper: [hash],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterWhereClause>
      hashMintURLEqualTo(String hash, String mintURL) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'hash_mintURL',
        value: [hash, mintURL],
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterWhereClause>
      hashEqualToMintURLNotEqualTo(String hash, String mintURL) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash_mintURL',
              lower: [hash],
              upper: [hash, mintURL],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash_mintURL',
              lower: [hash, mintURL],
              includeLower: false,
              upper: [hash],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash_mintURL',
              lower: [hash, mintURL],
              includeLower: false,
              upper: [hash],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hash_mintURL',
              lower: [hash],
              upper: [hash, mintURL],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LightningInvoiceIsarQueryFilter on QueryBuilder<LightningInvoiceIsar,
    LightningInvoiceIsar, QFilterCondition> {
  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> amountEqualTo(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> amountGreaterThan(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> amountLessThan(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> amountBetween(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> amountStartsWith(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> amountEndsWith(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
          QAfterFilterCondition>
      amountContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
          QAfterFilterCondition>
      amountMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'amount',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> amountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> amountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> hashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> hashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> hashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> hashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> hashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> hashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
          QAfterFilterCondition>
      hashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
          QAfterFilterCondition>
      hashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> hashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hash',
        value: '',
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> hashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hash',
        value: '',
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> mintURLEqualTo(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> mintURLGreaterThan(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> mintURLLessThan(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> mintURLBetween(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> mintURLStartsWith(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> mintURLEndsWith(
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

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
          QAfterFilterCondition>
      mintURLContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
          QAfterFilterCondition>
      mintURLMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mintURL',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> mintURLIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> mintURLIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> prEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> prGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> prLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> prBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> prStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> prEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
          QAfterFilterCondition>
      prContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
          QAfterFilterCondition>
      prMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> prIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pr',
        value: '',
      ));
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar,
      QAfterFilterCondition> prIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pr',
        value: '',
      ));
    });
  }
}

extension LightningInvoiceIsarQueryObject on QueryBuilder<LightningInvoiceIsar,
    LightningInvoiceIsar, QFilterCondition> {}

extension LightningInvoiceIsarQueryLinks on QueryBuilder<LightningInvoiceIsar,
    LightningInvoiceIsar, QFilterCondition> {}

extension LightningInvoiceIsarQuerySortBy
    on QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QSortBy> {
  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      sortByHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.asc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      sortByHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.desc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      sortByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      sortByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      sortByPr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pr', Sort.asc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      sortByPrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pr', Sort.desc);
    });
  }
}

extension LightningInvoiceIsarQuerySortThenBy
    on QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QSortThenBy> {
  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      thenByHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.asc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      thenByHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.desc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      thenByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      thenByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      thenByPr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pr', Sort.asc);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QAfterSortBy>
      thenByPrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pr', Sort.desc);
    });
  }
}

extension LightningInvoiceIsarQueryWhereDistinct
    on QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QDistinct> {
  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QDistinct>
      distinctByAmount({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QDistinct>
      distinctByHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QDistinct>
      distinctByMintURL({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mintURL', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LightningInvoiceIsar, LightningInvoiceIsar, QDistinct>
      distinctByPr({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pr', caseSensitive: caseSensitive);
    });
  }
}

extension LightningInvoiceIsarQueryProperty on QueryBuilder<
    LightningInvoiceIsar, LightningInvoiceIsar, QQueryProperty> {
  QueryBuilder<LightningInvoiceIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LightningInvoiceIsar, String, QQueryOperations>
      amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<LightningInvoiceIsar, String, QQueryOperations> hashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hash');
    });
  }

  QueryBuilder<LightningInvoiceIsar, String, QQueryOperations>
      mintURLProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mintURL');
    });
  }

  QueryBuilder<LightningInvoiceIsar, String, QQueryOperations> prProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pr');
    });
  }
}
