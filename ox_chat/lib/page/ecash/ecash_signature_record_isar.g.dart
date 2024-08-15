// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecash_signature_record_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEcashSignatureRecordISARCollection on Isar {
  IsarCollection<EcashSignatureRecordISAR> get ecashSignatureRecordISARs =>
      this.collection();
}

const EcashSignatureRecordISARSchema = CollectionSchema(
  name: r'EcashSignatureRecordISAR',
  id: -1538742290209920238,
  properties: {
    r'messageId': PropertySchema(
      id: 0,
      name: r'messageId',
      type: IsarType.string,
    )
  },
  estimateSize: _ecashSignatureRecordISAREstimateSize,
  serialize: _ecashSignatureRecordISARSerialize,
  deserialize: _ecashSignatureRecordISARDeserialize,
  deserializeProp: _ecashSignatureRecordISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'messageId': IndexSchema(
      id: -635287409172016016,
      name: r'messageId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'messageId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _ecashSignatureRecordISARGetId,
  getLinks: _ecashSignatureRecordISARGetLinks,
  attach: _ecashSignatureRecordISARAttach,
  version: '3.1.0+1',
);

int _ecashSignatureRecordISAREstimateSize(
  EcashSignatureRecordISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.messageId.length * 3;
  return bytesCount;
}

void _ecashSignatureRecordISARSerialize(
  EcashSignatureRecordISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.messageId);
}

EcashSignatureRecordISAR _ecashSignatureRecordISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EcashSignatureRecordISAR(
    messageId: reader.readString(offsets[0]),
  );
  object.id = id;
  return object;
}

P _ecashSignatureRecordISARDeserializeProp<P>(
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

Id _ecashSignatureRecordISARGetId(EcashSignatureRecordISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ecashSignatureRecordISARGetLinks(
    EcashSignatureRecordISAR object) {
  return [];
}

void _ecashSignatureRecordISARAttach(
    IsarCollection<dynamic> col, Id id, EcashSignatureRecordISAR object) {
  object.id = id;
}

extension EcashSignatureRecordISARByIndex
    on IsarCollection<EcashSignatureRecordISAR> {
  Future<EcashSignatureRecordISAR?> getByMessageId(String messageId) {
    return getByIndex(r'messageId', [messageId]);
  }

  EcashSignatureRecordISAR? getByMessageIdSync(String messageId) {
    return getByIndexSync(r'messageId', [messageId]);
  }

  Future<bool> deleteByMessageId(String messageId) {
    return deleteByIndex(r'messageId', [messageId]);
  }

  bool deleteByMessageIdSync(String messageId) {
    return deleteByIndexSync(r'messageId', [messageId]);
  }

  Future<List<EcashSignatureRecordISAR?>> getAllByMessageId(
      List<String> messageIdValues) {
    final values = messageIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'messageId', values);
  }

  List<EcashSignatureRecordISAR?> getAllByMessageIdSync(
      List<String> messageIdValues) {
    final values = messageIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'messageId', values);
  }

  Future<int> deleteAllByMessageId(List<String> messageIdValues) {
    final values = messageIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'messageId', values);
  }

  int deleteAllByMessageIdSync(List<String> messageIdValues) {
    final values = messageIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'messageId', values);
  }

  Future<Id> putByMessageId(EcashSignatureRecordISAR object) {
    return putByIndex(r'messageId', object);
  }

  Id putByMessageIdSync(EcashSignatureRecordISAR object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'messageId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMessageId(List<EcashSignatureRecordISAR> objects) {
    return putAllByIndex(r'messageId', objects);
  }

  List<Id> putAllByMessageIdSync(List<EcashSignatureRecordISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'messageId', objects, saveLinks: saveLinks);
  }
}

extension EcashSignatureRecordISARQueryWhereSort on QueryBuilder<
    EcashSignatureRecordISAR, EcashSignatureRecordISAR, QWhere> {
  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EcashSignatureRecordISARQueryWhere on QueryBuilder<
    EcashSignatureRecordISAR, EcashSignatureRecordISAR, QWhereClause> {
  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
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

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
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

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterWhereClause> messageIdEqualTo(String messageId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'messageId',
        value: [messageId],
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterWhereClause> messageIdNotEqualTo(String messageId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'messageId',
              lower: [],
              upper: [messageId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'messageId',
              lower: [messageId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'messageId',
              lower: [messageId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'messageId',
              lower: [],
              upper: [messageId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension EcashSignatureRecordISARQueryFilter on QueryBuilder<
    EcashSignatureRecordISAR, EcashSignatureRecordISAR, QFilterCondition> {
  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
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

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
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

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
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

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterFilterCondition> messageIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterFilterCondition> messageIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterFilterCondition> messageIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterFilterCondition> messageIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'messageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterFilterCondition> messageIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterFilterCondition> messageIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
          QAfterFilterCondition>
      messageIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'messageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
          QAfterFilterCondition>
      messageIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'messageId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterFilterCondition> messageIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'messageId',
        value: '',
      ));
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR,
      QAfterFilterCondition> messageIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'messageId',
        value: '',
      ));
    });
  }
}

extension EcashSignatureRecordISARQueryObject on QueryBuilder<
    EcashSignatureRecordISAR, EcashSignatureRecordISAR, QFilterCondition> {}

extension EcashSignatureRecordISARQueryLinks on QueryBuilder<
    EcashSignatureRecordISAR, EcashSignatureRecordISAR, QFilterCondition> {}

extension EcashSignatureRecordISARQuerySortBy on QueryBuilder<
    EcashSignatureRecordISAR, EcashSignatureRecordISAR, QSortBy> {
  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR, QAfterSortBy>
      sortByMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.asc);
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR, QAfterSortBy>
      sortByMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.desc);
    });
  }
}

extension EcashSignatureRecordISARQuerySortThenBy on QueryBuilder<
    EcashSignatureRecordISAR, EcashSignatureRecordISAR, QSortThenBy> {
  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR, QAfterSortBy>
      thenByMessageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.asc);
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR, QAfterSortBy>
      thenByMessageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'messageId', Sort.desc);
    });
  }
}

extension EcashSignatureRecordISARQueryWhereDistinct on QueryBuilder<
    EcashSignatureRecordISAR, EcashSignatureRecordISAR, QDistinct> {
  QueryBuilder<EcashSignatureRecordISAR, EcashSignatureRecordISAR, QDistinct>
      distinctByMessageId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'messageId', caseSensitive: caseSensitive);
    });
  }
}

extension EcashSignatureRecordISARQueryProperty on QueryBuilder<
    EcashSignatureRecordISAR, EcashSignatureRecordISAR, QQueryProperty> {
  QueryBuilder<EcashSignatureRecordISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EcashSignatureRecordISAR, String, QQueryOperations>
      messageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'messageId');
    });
  }
}
