// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_search_user_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecentSearchUserISARCollection on Isar {
  IsarCollection<RecentSearchUserISAR> get recentSearchUserISARs =>
      this.collection();
}

const RecentSearchUserISARSchema = CollectionSchema(
  name: r'RecentSearchUserISAR',
  id: 5706466903360985314,
  properties: {
    r'pubKey': PropertySchema(
      id: 0,
      name: r'pubKey',
      type: IsarType.string,
    )
  },
  estimateSize: _recentSearchUserISAREstimateSize,
  serialize: _recentSearchUserISARSerialize,
  deserialize: _recentSearchUserISARDeserialize,
  deserializeProp: _recentSearchUserISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'pubKey': IndexSchema(
      id: -1355330614492892055,
      name: r'pubKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'pubKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _recentSearchUserISARGetId,
  getLinks: _recentSearchUserISARGetLinks,
  attach: _recentSearchUserISARAttach,
  version: '3.1.0+1',
);

int _recentSearchUserISAREstimateSize(
  RecentSearchUserISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.pubKey.length * 3;
  return bytesCount;
}

void _recentSearchUserISARSerialize(
  RecentSearchUserISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.pubKey);
}

RecentSearchUserISAR _recentSearchUserISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecentSearchUserISAR(
    pubKey: reader.readString(offsets[0]),
  );
  object.id = id;
  return object;
}

P _recentSearchUserISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recentSearchUserISARGetId(RecentSearchUserISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recentSearchUserISARGetLinks(
    RecentSearchUserISAR object) {
  return [];
}

void _recentSearchUserISARAttach(
    IsarCollection<dynamic> col, Id id, RecentSearchUserISAR object) {
  object.id = id;
}

extension RecentSearchUserISARByIndex on IsarCollection<RecentSearchUserISAR> {
  Future<RecentSearchUserISAR?> getByPubKey(String pubKey) {
    return getByIndex(r'pubKey', [pubKey]);
  }

  RecentSearchUserISAR? getByPubKeySync(String pubKey) {
    return getByIndexSync(r'pubKey', [pubKey]);
  }

  Future<bool> deleteByPubKey(String pubKey) {
    return deleteByIndex(r'pubKey', [pubKey]);
  }

  bool deleteByPubKeySync(String pubKey) {
    return deleteByIndexSync(r'pubKey', [pubKey]);
  }

  Future<List<RecentSearchUserISAR?>> getAllByPubKey(
      List<String> pubKeyValues) {
    final values = pubKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'pubKey', values);
  }

  List<RecentSearchUserISAR?> getAllByPubKeySync(List<String> pubKeyValues) {
    final values = pubKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'pubKey', values);
  }

  Future<int> deleteAllByPubKey(List<String> pubKeyValues) {
    final values = pubKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'pubKey', values);
  }

  int deleteAllByPubKeySync(List<String> pubKeyValues) {
    final values = pubKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'pubKey', values);
  }

  Future<Id> putByPubKey(RecentSearchUserISAR object) {
    return putByIndex(r'pubKey', object);
  }

  Id putByPubKeySync(RecentSearchUserISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'pubKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPubKey(List<RecentSearchUserISAR> objects) {
    return putAllByIndex(r'pubKey', objects);
  }

  List<Id> putAllByPubKeySync(List<RecentSearchUserISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'pubKey', objects, saveLinks: saveLinks);
  }
}

extension RecentSearchUserISARQueryWhereSort
    on QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QWhere> {
  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecentSearchUserISARQueryWhere
    on QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QWhereClause> {
  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterWhereClause>
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

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterWhereClause>
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

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterWhereClause>
      pubKeyEqualTo(String pubKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pubKey',
        value: [pubKey],
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterWhereClause>
      pubKeyNotEqualTo(String pubKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubKey',
              lower: [],
              upper: [pubKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubKey',
              lower: [pubKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubKey',
              lower: [pubKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pubKey',
              lower: [],
              upper: [pubKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RecentSearchUserISARQueryFilter on QueryBuilder<RecentSearchUserISAR,
    RecentSearchUserISAR, QFilterCondition> {
  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
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

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
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

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
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

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
      QAfterFilterCondition> pubKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
      QAfterFilterCondition> pubKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
      QAfterFilterCondition> pubKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
      QAfterFilterCondition> pubKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pubKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
      QAfterFilterCondition> pubKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
      QAfterFilterCondition> pubKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
          QAfterFilterCondition>
      pubKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pubKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
          QAfterFilterCondition>
      pubKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pubKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
      QAfterFilterCondition> pubKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubKey',
        value: '',
      ));
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR,
      QAfterFilterCondition> pubKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pubKey',
        value: '',
      ));
    });
  }
}

extension RecentSearchUserISARQueryObject on QueryBuilder<RecentSearchUserISAR,
    RecentSearchUserISAR, QFilterCondition> {}

extension RecentSearchUserISARQueryLinks on QueryBuilder<RecentSearchUserISAR,
    RecentSearchUserISAR, QFilterCondition> {}

extension RecentSearchUserISARQuerySortBy
    on QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QSortBy> {
  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterSortBy>
      sortByPubKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.asc);
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterSortBy>
      sortByPubKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.desc);
    });
  }
}

extension RecentSearchUserISARQuerySortThenBy
    on QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QSortThenBy> {
  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterSortBy>
      thenByPubKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.asc);
    });
  }

  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QAfterSortBy>
      thenByPubKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.desc);
    });
  }
}

extension RecentSearchUserISARQueryWhereDistinct
    on QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QDistinct> {
  QueryBuilder<RecentSearchUserISAR, RecentSearchUserISAR, QDistinct>
      distinctByPubKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubKey', caseSensitive: caseSensitive);
    });
  }
}

extension RecentSearchUserISARQueryProperty on QueryBuilder<
    RecentSearchUserISAR, RecentSearchUserISAR, QQueryProperty> {
  QueryBuilder<RecentSearchUserISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecentSearchUserISAR, String, QQueryOperations>
      pubKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubKey');
    });
  }
}
