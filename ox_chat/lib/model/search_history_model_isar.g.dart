// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_model_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSearchHistoryModelISARCollection on Isar {
  IsarCollection<SearchHistoryModelISAR> get searchHistoryModelISARs =>
      this.collection();
}

const SearchHistoryModelISARSchema = CollectionSchema(
  name: r'SearchHistoryModelISAR',
  id: 4137625194349242368,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    ),
    r'picture': PropertySchema(
      id: 1,
      name: r'picture',
      type: IsarType.string,
    ),
    r'pubKey': PropertySchema(
      id: 2,
      name: r'pubKey',
      type: IsarType.string,
    ),
    r'searchTxt': PropertySchema(
      id: 3,
      name: r'searchTxt',
      type: IsarType.string,
    )
  },
  estimateSize: _searchHistoryModelISAREstimateSize,
  serialize: _searchHistoryModelISARSerialize,
  deserialize: _searchHistoryModelISARDeserialize,
  deserializeProp: _searchHistoryModelISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'searchTxt': IndexSchema(
      id: 2286854133733332504,
      name: r'searchTxt',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'searchTxt',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _searchHistoryModelISARGetId,
  getLinks: _searchHistoryModelISARGetLinks,
  attach: _searchHistoryModelISARAttach,
  version: '3.1.0+1',
);

int _searchHistoryModelISAREstimateSize(
  SearchHistoryModelISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.picture;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pubKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.searchTxt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _searchHistoryModelISARSerialize(
  SearchHistoryModelISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
  writer.writeString(offsets[1], object.picture);
  writer.writeString(offsets[2], object.pubKey);
  writer.writeString(offsets[3], object.searchTxt);
}

SearchHistoryModelISAR _searchHistoryModelISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SearchHistoryModelISAR(
    name: reader.readStringOrNull(offsets[0]),
    picture: reader.readStringOrNull(offsets[1]),
    pubKey: reader.readStringOrNull(offsets[2]),
    searchTxt: reader.readStringOrNull(offsets[3]),
  );
  object.id = id;
  return object;
}

P _searchHistoryModelISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _searchHistoryModelISARGetId(SearchHistoryModelISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _searchHistoryModelISARGetLinks(
    SearchHistoryModelISAR object) {
  return [];
}

void _searchHistoryModelISARAttach(
    IsarCollection<dynamic> col, Id id, SearchHistoryModelISAR object) {
  object.id = id;
}

extension SearchHistoryModelISARByIndex
    on IsarCollection<SearchHistoryModelISAR> {
  Future<SearchHistoryModelISAR?> getBySearchTxt(String? searchTxt) {
    return getByIndex(r'searchTxt', [searchTxt]);
  }

  SearchHistoryModelISAR? getBySearchTxtSync(String? searchTxt) {
    return getByIndexSync(r'searchTxt', [searchTxt]);
  }

  Future<bool> deleteBySearchTxt(String? searchTxt) {
    return deleteByIndex(r'searchTxt', [searchTxt]);
  }

  bool deleteBySearchTxtSync(String? searchTxt) {
    return deleteByIndexSync(r'searchTxt', [searchTxt]);
  }

  Future<List<SearchHistoryModelISAR?>> getAllBySearchTxt(
      List<String?> searchTxtValues) {
    final values = searchTxtValues.map((e) => [e]).toList();
    return getAllByIndex(r'searchTxt', values);
  }

  List<SearchHistoryModelISAR?> getAllBySearchTxtSync(
      List<String?> searchTxtValues) {
    final values = searchTxtValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'searchTxt', values);
  }

  Future<int> deleteAllBySearchTxt(List<String?> searchTxtValues) {
    final values = searchTxtValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'searchTxt', values);
  }

  int deleteAllBySearchTxtSync(List<String?> searchTxtValues) {
    final values = searchTxtValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'searchTxt', values);
  }

  Future<Id> putBySearchTxt(SearchHistoryModelISAR object) {
    return putByIndex(r'searchTxt', object);
  }

  Id putBySearchTxtSync(SearchHistoryModelISAR object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'searchTxt', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySearchTxt(List<SearchHistoryModelISAR> objects) {
    return putAllByIndex(r'searchTxt', objects);
  }

  List<Id> putAllBySearchTxtSync(List<SearchHistoryModelISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'searchTxt', objects, saveLinks: saveLinks);
  }
}

extension SearchHistoryModelISARQueryWhereSort
    on QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QWhere> {
  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SearchHistoryModelISARQueryWhere on QueryBuilder<
    SearchHistoryModelISAR, SearchHistoryModelISAR, QWhereClause> {
  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterWhereClause> searchTxtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchTxt',
        value: [null],
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterWhereClause> searchTxtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'searchTxt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterWhereClause> searchTxtEqualTo(String? searchTxt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'searchTxt',
        value: [searchTxt],
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterWhereClause> searchTxtNotEqualTo(String? searchTxt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchTxt',
              lower: [],
              upper: [searchTxt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchTxt',
              lower: [searchTxt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchTxt',
              lower: [searchTxt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'searchTxt',
              lower: [],
              upper: [searchTxt],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SearchHistoryModelISARQueryFilter on QueryBuilder<
    SearchHistoryModelISAR, SearchHistoryModelISAR, QFilterCondition> {
  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> nameEqualTo(
    String? value, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> nameGreaterThan(
    String? value, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> nameLessThan(
    String? value, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'picture',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pictureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'picture',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pictureEqualTo(
    String? value, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pictureGreaterThan(
    String? value, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pictureLessThan(
    String? value, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pictureBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pictureStartsWith(
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pictureEndsWith(
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
          QAfterFilterCondition>
      pictureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
          QAfterFilterCondition>
      pictureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'picture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pubKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pubKey',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pubKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pubKey',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pubKeyEqualTo(
    String? value, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pubKeyGreaterThan(
    String? value, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pubKeyLessThan(
    String? value, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pubKeyBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
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

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pubKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubKey',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> pubKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pubKey',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> searchTxtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'searchTxt',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> searchTxtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'searchTxt',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> searchTxtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchTxt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> searchTxtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'searchTxt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> searchTxtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'searchTxt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> searchTxtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'searchTxt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> searchTxtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'searchTxt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> searchTxtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'searchTxt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
          QAfterFilterCondition>
      searchTxtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'searchTxt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
          QAfterFilterCondition>
      searchTxtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'searchTxt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> searchTxtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchTxt',
        value: '',
      ));
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR,
      QAfterFilterCondition> searchTxtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'searchTxt',
        value: '',
      ));
    });
  }
}

extension SearchHistoryModelISARQueryObject on QueryBuilder<
    SearchHistoryModelISAR, SearchHistoryModelISAR, QFilterCondition> {}

extension SearchHistoryModelISARQueryLinks on QueryBuilder<
    SearchHistoryModelISAR, SearchHistoryModelISAR, QFilterCondition> {}

extension SearchHistoryModelISARQuerySortBy
    on QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QSortBy> {
  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      sortByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      sortByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      sortByPubKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      sortByPubKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      sortBySearchTxt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchTxt', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      sortBySearchTxtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchTxt', Sort.desc);
    });
  }
}

extension SearchHistoryModelISARQuerySortThenBy on QueryBuilder<
    SearchHistoryModelISAR, SearchHistoryModelISAR, QSortThenBy> {
  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      thenByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      thenByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      thenByPubKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      thenByPubKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubKey', Sort.desc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      thenBySearchTxt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchTxt', Sort.asc);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QAfterSortBy>
      thenBySearchTxtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchTxt', Sort.desc);
    });
  }
}

extension SearchHistoryModelISARQueryWhereDistinct
    on QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QDistinct> {
  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QDistinct>
      distinctByPicture({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'picture', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QDistinct>
      distinctByPubKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SearchHistoryModelISAR, SearchHistoryModelISAR, QDistinct>
      distinctBySearchTxt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchTxt', caseSensitive: caseSensitive);
    });
  }
}

extension SearchHistoryModelISARQueryProperty on QueryBuilder<
    SearchHistoryModelISAR, SearchHistoryModelISAR, QQueryProperty> {
  QueryBuilder<SearchHistoryModelISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SearchHistoryModelISAR, String?, QQueryOperations>
      nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<SearchHistoryModelISAR, String?, QQueryOperations>
      pictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'picture');
    });
  }

  QueryBuilder<SearchHistoryModelISAR, String?, QQueryOperations>
      pubKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubKey');
    });
  }

  QueryBuilder<SearchHistoryModelISAR, String?, QQueryOperations>
      searchTxtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchTxt');
    });
  }
}
