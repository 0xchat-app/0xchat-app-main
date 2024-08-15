// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecash_info_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEcashReceiptHistoryISARCollection on Isar {
  IsarCollection<EcashReceiptHistoryISAR> get ecashReceiptHistoryISARs =>
      this.collection();
}

const EcashReceiptHistoryISARSchema = CollectionSchema(
  name: r'EcashReceiptHistoryISAR',
  id: 9055414904183290387,
  properties: {
    r'isMe': PropertySchema(
      id: 0,
      name: r'isMe',
      type: IsarType.bool,
    ),
    r'timestamp': PropertySchema(
      id: 1,
      name: r'timestamp',
      type: IsarType.long,
    ),
    r'tokenMD5': PropertySchema(
      id: 2,
      name: r'tokenMD5',
      type: IsarType.string,
    )
  },
  estimateSize: _ecashReceiptHistoryISAREstimateSize,
  serialize: _ecashReceiptHistoryISARSerialize,
  deserialize: _ecashReceiptHistoryISARDeserialize,
  deserializeProp: _ecashReceiptHistoryISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'tokenMD5': IndexSchema(
      id: -2125642813364730839,
      name: r'tokenMD5',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'tokenMD5',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _ecashReceiptHistoryISARGetId,
  getLinks: _ecashReceiptHistoryISARGetLinks,
  attach: _ecashReceiptHistoryISARAttach,
  version: '3.1.0+1',
);

int _ecashReceiptHistoryISAREstimateSize(
  EcashReceiptHistoryISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.tokenMD5.length * 3;
  return bytesCount;
}

void _ecashReceiptHistoryISARSerialize(
  EcashReceiptHistoryISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isMe);
  writer.writeLong(offsets[1], object.timestamp);
  writer.writeString(offsets[2], object.tokenMD5);
}

EcashReceiptHistoryISAR _ecashReceiptHistoryISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EcashReceiptHistoryISAR(
    isMe: reader.readBool(offsets[0]),
    timestamp: reader.readLongOrNull(offsets[1]),
    tokenMD5: reader.readString(offsets[2]),
  );
  object.id = id;
  return object;
}

P _ecashReceiptHistoryISARDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ecashReceiptHistoryISARGetId(EcashReceiptHistoryISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ecashReceiptHistoryISARGetLinks(
    EcashReceiptHistoryISAR object) {
  return [];
}

void _ecashReceiptHistoryISARAttach(
    IsarCollection<dynamic> col, Id id, EcashReceiptHistoryISAR object) {
  object.id = id;
}

extension EcashReceiptHistoryISARByIndex
    on IsarCollection<EcashReceiptHistoryISAR> {
  Future<EcashReceiptHistoryISAR?> getByTokenMD5(String tokenMD5) {
    return getByIndex(r'tokenMD5', [tokenMD5]);
  }

  EcashReceiptHistoryISAR? getByTokenMD5Sync(String tokenMD5) {
    return getByIndexSync(r'tokenMD5', [tokenMD5]);
  }

  Future<bool> deleteByTokenMD5(String tokenMD5) {
    return deleteByIndex(r'tokenMD5', [tokenMD5]);
  }

  bool deleteByTokenMD5Sync(String tokenMD5) {
    return deleteByIndexSync(r'tokenMD5', [tokenMD5]);
  }

  Future<List<EcashReceiptHistoryISAR?>> getAllByTokenMD5(
      List<String> tokenMD5Values) {
    final values = tokenMD5Values.map((e) => [e]).toList();
    return getAllByIndex(r'tokenMD5', values);
  }

  List<EcashReceiptHistoryISAR?> getAllByTokenMD5Sync(
      List<String> tokenMD5Values) {
    final values = tokenMD5Values.map((e) => [e]).toList();
    return getAllByIndexSync(r'tokenMD5', values);
  }

  Future<int> deleteAllByTokenMD5(List<String> tokenMD5Values) {
    final values = tokenMD5Values.map((e) => [e]).toList();
    return deleteAllByIndex(r'tokenMD5', values);
  }

  int deleteAllByTokenMD5Sync(List<String> tokenMD5Values) {
    final values = tokenMD5Values.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'tokenMD5', values);
  }

  Future<Id> putByTokenMD5(EcashReceiptHistoryISAR object) {
    return putByIndex(r'tokenMD5', object);
  }

  Id putByTokenMD5Sync(EcashReceiptHistoryISAR object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'tokenMD5', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTokenMD5(List<EcashReceiptHistoryISAR> objects) {
    return putAllByIndex(r'tokenMD5', objects);
  }

  List<Id> putAllByTokenMD5Sync(List<EcashReceiptHistoryISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'tokenMD5', objects, saveLinks: saveLinks);
  }
}

extension EcashReceiptHistoryISARQueryWhereSort
    on QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QWhere> {
  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EcashReceiptHistoryISARQueryWhere on QueryBuilder<
    EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QWhereClause> {
  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
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

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
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

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterWhereClause> tokenMD5EqualTo(String tokenMD5) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tokenMD5',
        value: [tokenMD5],
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterWhereClause> tokenMD5NotEqualTo(String tokenMD5) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tokenMD5',
              lower: [],
              upper: [tokenMD5],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tokenMD5',
              lower: [tokenMD5],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tokenMD5',
              lower: [tokenMD5],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tokenMD5',
              lower: [],
              upper: [tokenMD5],
              includeUpper: false,
            ));
      }
    });
  }
}

extension EcashReceiptHistoryISARQueryFilter on QueryBuilder<
    EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QFilterCondition> {
  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
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

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
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

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
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

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> isMeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMe',
        value: value,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> timestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timestamp',
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> timestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timestamp',
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> timestampEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> timestampGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> timestampLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> timestampBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> tokenMD5EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tokenMD5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> tokenMD5GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tokenMD5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> tokenMD5LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tokenMD5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> tokenMD5Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tokenMD5',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> tokenMD5StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tokenMD5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> tokenMD5EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tokenMD5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
          QAfterFilterCondition>
      tokenMD5Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tokenMD5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
          QAfterFilterCondition>
      tokenMD5Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tokenMD5',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> tokenMD5IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tokenMD5',
        value: '',
      ));
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR,
      QAfterFilterCondition> tokenMD5IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tokenMD5',
        value: '',
      ));
    });
  }
}

extension EcashReceiptHistoryISARQueryObject on QueryBuilder<
    EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QFilterCondition> {}

extension EcashReceiptHistoryISARQueryLinks on QueryBuilder<
    EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QFilterCondition> {}

extension EcashReceiptHistoryISARQuerySortBy
    on QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QSortBy> {
  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      sortByIsMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMe', Sort.asc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      sortByIsMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMe', Sort.desc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      sortByTokenMD5() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenMD5', Sort.asc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      sortByTokenMD5Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenMD5', Sort.desc);
    });
  }
}

extension EcashReceiptHistoryISARQuerySortThenBy on QueryBuilder<
    EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QSortThenBy> {
  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      thenByIsMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMe', Sort.asc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      thenByIsMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMe', Sort.desc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      thenByTokenMD5() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenMD5', Sort.asc);
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QAfterSortBy>
      thenByTokenMD5Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenMD5', Sort.desc);
    });
  }
}

extension EcashReceiptHistoryISARQueryWhereDistinct on QueryBuilder<
    EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QDistinct> {
  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QDistinct>
      distinctByIsMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMe');
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QDistinct>
      distinctByTokenMD5({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tokenMD5', caseSensitive: caseSensitive);
    });
  }
}

extension EcashReceiptHistoryISARQueryProperty on QueryBuilder<
    EcashReceiptHistoryISAR, EcashReceiptHistoryISAR, QQueryProperty> {
  QueryBuilder<EcashReceiptHistoryISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, bool, QQueryOperations> isMeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMe');
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, int?, QQueryOperations>
      timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<EcashReceiptHistoryISAR, String, QQueryOperations>
      tokenMD5Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tokenMD5');
    });
  }
}
