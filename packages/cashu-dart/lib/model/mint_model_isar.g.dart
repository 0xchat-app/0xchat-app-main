// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mint_model_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIMintIsarCollection on Isar {
  IsarCollection<IMintIsar> get iMintIsars => this.collection();
}

const IMintIsarSchema = CollectionSchema(
  name: r'IMintIsar',
  id: 5891811416298861336,
  properties: {
    r'balance': PropertySchema(
      id: 0,
      name: r'balance',
      type: IsarType.long,
    ),
    r'maxNutsVersion': PropertySchema(
      id: 1,
      name: r'maxNutsVersion',
      type: IsarType.long,
    ),
    r'mintURL': PropertySchema(
      id: 2,
      name: r'mintURL',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _iMintIsarEstimateSize,
  serialize: _iMintIsarSerialize,
  deserialize: _iMintIsarDeserialize,
  deserializeProp: _iMintIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'mintURL': IndexSchema(
      id: 5052576169555451409,
      name: r'mintURL',
      unique: true,
      replace: false,
      properties: [
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
  getId: _iMintIsarGetId,
  getLinks: _iMintIsarGetLinks,
  attach: _iMintIsarAttach,
  version: '3.1.0+1',
);

int _iMintIsarEstimateSize(
  IMintIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mintURL.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _iMintIsarSerialize(
  IMintIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.balance);
  writer.writeLong(offsets[1], object.maxNutsVersion);
  writer.writeString(offsets[2], object.mintURL);
  writer.writeString(offsets[3], object.name);
}

IMintIsar _iMintIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IMintIsar(
    balance: reader.readLongOrNull(offsets[0]) ?? 0,
    maxNutsVersion: reader.readLongOrNull(offsets[1]) ?? 0,
    mintURL: reader.readString(offsets[2]),
    name: reader.readStringOrNull(offsets[3]) ?? '',
  );
  object.id = id;
  return object;
}

P _iMintIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _iMintIsarGetId(IMintIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _iMintIsarGetLinks(IMintIsar object) {
  return [];
}

void _iMintIsarAttach(IsarCollection<dynamic> col, Id id, IMintIsar object) {
  object.id = id;
}

extension IMintIsarByIndex on IsarCollection<IMintIsar> {
  Future<IMintIsar?> getByMintURL(String mintURL) {
    return getByIndex(r'mintURL', [mintURL]);
  }

  IMintIsar? getByMintURLSync(String mintURL) {
    return getByIndexSync(r'mintURL', [mintURL]);
  }

  Future<bool> deleteByMintURL(String mintURL) {
    return deleteByIndex(r'mintURL', [mintURL]);
  }

  bool deleteByMintURLSync(String mintURL) {
    return deleteByIndexSync(r'mintURL', [mintURL]);
  }

  Future<List<IMintIsar?>> getAllByMintURL(List<String> mintURLValues) {
    final values = mintURLValues.map((e) => [e]).toList();
    return getAllByIndex(r'mintURL', values);
  }

  List<IMintIsar?> getAllByMintURLSync(List<String> mintURLValues) {
    final values = mintURLValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'mintURL', values);
  }

  Future<int> deleteAllByMintURL(List<String> mintURLValues) {
    final values = mintURLValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'mintURL', values);
  }

  int deleteAllByMintURLSync(List<String> mintURLValues) {
    final values = mintURLValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'mintURL', values);
  }

  Future<Id> putByMintURL(IMintIsar object) {
    return putByIndex(r'mintURL', object);
  }

  Id putByMintURLSync(IMintIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'mintURL', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMintURL(List<IMintIsar> objects) {
    return putAllByIndex(r'mintURL', objects);
  }

  List<Id> putAllByMintURLSync(List<IMintIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'mintURL', objects, saveLinks: saveLinks);
  }
}

extension IMintIsarQueryWhereSort
    on QueryBuilder<IMintIsar, IMintIsar, QWhere> {
  QueryBuilder<IMintIsar, IMintIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IMintIsarQueryWhere
    on QueryBuilder<IMintIsar, IMintIsar, QWhereClause> {
  QueryBuilder<IMintIsar, IMintIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterWhereClause> mintURLEqualTo(
      String mintURL) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mintURL',
        value: [mintURL],
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterWhereClause> mintURLNotEqualTo(
      String mintURL) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintURL',
              lower: [],
              upper: [mintURL],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintURL',
              lower: [mintURL],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintURL',
              lower: [mintURL],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintURL',
              lower: [],
              upper: [mintURL],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IMintIsarQueryFilter
    on QueryBuilder<IMintIsar, IMintIsar, QFilterCondition> {
  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> balanceEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balance',
        value: value,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> balanceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'balance',
        value: value,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> balanceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'balance',
        value: value,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> balanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'balance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> idBetween(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition>
      maxNutsVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxNutsVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition>
      maxNutsVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxNutsVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition>
      maxNutsVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxNutsVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition>
      maxNutsVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxNutsVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> mintURLEqualTo(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> mintURLGreaterThan(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> mintURLLessThan(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> mintURLBetween(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> mintURLStartsWith(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> mintURLEndsWith(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> mintURLContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> mintURLMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mintURL',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> mintURLIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition>
      mintURLIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension IMintIsarQueryObject
    on QueryBuilder<IMintIsar, IMintIsar, QFilterCondition> {}

extension IMintIsarQueryLinks
    on QueryBuilder<IMintIsar, IMintIsar, QFilterCondition> {}

extension IMintIsarQuerySortBy on QueryBuilder<IMintIsar, IMintIsar, QSortBy> {
  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> sortByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> sortByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> sortByMaxNutsVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxNutsVersion', Sort.asc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> sortByMaxNutsVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxNutsVersion', Sort.desc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> sortByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> sortByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IMintIsarQuerySortThenBy
    on QueryBuilder<IMintIsar, IMintIsar, QSortThenBy> {
  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> thenByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.asc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> thenByBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balance', Sort.desc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> thenByMaxNutsVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxNutsVersion', Sort.asc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> thenByMaxNutsVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxNutsVersion', Sort.desc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> thenByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> thenByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IMintIsarQueryWhereDistinct
    on QueryBuilder<IMintIsar, IMintIsar, QDistinct> {
  QueryBuilder<IMintIsar, IMintIsar, QDistinct> distinctByBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balance');
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QDistinct> distinctByMaxNutsVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxNutsVersion');
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QDistinct> distinctByMintURL(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mintURL', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IMintIsar, IMintIsar, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension IMintIsarQueryProperty
    on QueryBuilder<IMintIsar, IMintIsar, QQueryProperty> {
  QueryBuilder<IMintIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IMintIsar, int, QQueryOperations> balanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balance');
    });
  }

  QueryBuilder<IMintIsar, int, QQueryOperations> maxNutsVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxNutsVersion');
    });
  }

  QueryBuilder<IMintIsar, String, QQueryOperations> mintURLProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mintURL');
    });
  }

  QueryBuilder<IMintIsar, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
