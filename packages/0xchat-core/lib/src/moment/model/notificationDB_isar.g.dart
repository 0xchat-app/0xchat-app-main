// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificationDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationDBISARCollection on Isar {
  IsarCollection<NotificationDBISAR> get notificationDBISARs =>
      this.collection();
}

const NotificationDBISARSchema = CollectionSchema(
  name: r'NotificationDBISAR',
  id: 4809137493972279863,
  properties: {
    r'associatedNoteId': PropertySchema(
      id: 0,
      name: r'associatedNoteId',
      type: IsarType.string,
    ),
    r'author': PropertySchema(
      id: 1,
      name: r'author',
      type: IsarType.string,
    ),
    r'content': PropertySchema(
      id: 2,
      name: r'content',
      type: IsarType.string,
    ),
    r'createAt': PropertySchema(
      id: 3,
      name: r'createAt',
      type: IsarType.long,
    ),
    r'kind': PropertySchema(
      id: 4,
      name: r'kind',
      type: IsarType.long,
    ),
    r'notificationId': PropertySchema(
      id: 5,
      name: r'notificationId',
      type: IsarType.string,
    ),
    r'zapAmount': PropertySchema(
      id: 6,
      name: r'zapAmount',
      type: IsarType.long,
    )
  },
  estimateSize: _notificationDBISAREstimateSize,
  serialize: _notificationDBISARSerialize,
  deserialize: _notificationDBISARDeserialize,
  deserializeProp: _notificationDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'notificationId': IndexSchema(
      id: 1533036797414670656,
      name: r'notificationId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'notificationId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _notificationDBISARGetId,
  getLinks: _notificationDBISARGetLinks,
  attach: _notificationDBISARAttach,
  version: '3.1.0+1',
);

int _notificationDBISAREstimateSize(
  NotificationDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.associatedNoteId.length * 3;
  bytesCount += 3 + object.author.length * 3;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.notificationId.length * 3;
  return bytesCount;
}

void _notificationDBISARSerialize(
  NotificationDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.associatedNoteId);
  writer.writeString(offsets[1], object.author);
  writer.writeString(offsets[2], object.content);
  writer.writeLong(offsets[3], object.createAt);
  writer.writeLong(offsets[4], object.kind);
  writer.writeString(offsets[5], object.notificationId);
  writer.writeLong(offsets[6], object.zapAmount);
}

NotificationDBISAR _notificationDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationDBISAR(
    associatedNoteId: reader.readStringOrNull(offsets[0]) ?? '',
    author: reader.readStringOrNull(offsets[1]) ?? '',
    content: reader.readStringOrNull(offsets[2]) ?? '',
    createAt: reader.readLongOrNull(offsets[3]) ?? 0,
    kind: reader.readLongOrNull(offsets[4]) ?? 0,
    notificationId: reader.readStringOrNull(offsets[5]) ?? '',
    zapAmount: reader.readLongOrNull(offsets[6]) ?? 0,
  );
  object.id = id;
  return object;
}

P _notificationDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationDBISARGetId(NotificationDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notificationDBISARGetLinks(
    NotificationDBISAR object) {
  return [];
}

void _notificationDBISARAttach(
    IsarCollection<dynamic> col, Id id, NotificationDBISAR object) {
  object.id = id;
}

extension NotificationDBISARByIndex on IsarCollection<NotificationDBISAR> {
  Future<NotificationDBISAR?> getByNotificationId(String notificationId) {
    return getByIndex(r'notificationId', [notificationId]);
  }

  NotificationDBISAR? getByNotificationIdSync(String notificationId) {
    return getByIndexSync(r'notificationId', [notificationId]);
  }

  Future<bool> deleteByNotificationId(String notificationId) {
    return deleteByIndex(r'notificationId', [notificationId]);
  }

  bool deleteByNotificationIdSync(String notificationId) {
    return deleteByIndexSync(r'notificationId', [notificationId]);
  }

  Future<List<NotificationDBISAR?>> getAllByNotificationId(
      List<String> notificationIdValues) {
    final values = notificationIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'notificationId', values);
  }

  List<NotificationDBISAR?> getAllByNotificationIdSync(
      List<String> notificationIdValues) {
    final values = notificationIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'notificationId', values);
  }

  Future<int> deleteAllByNotificationId(List<String> notificationIdValues) {
    final values = notificationIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'notificationId', values);
  }

  int deleteAllByNotificationIdSync(List<String> notificationIdValues) {
    final values = notificationIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'notificationId', values);
  }

  Future<Id> putByNotificationId(NotificationDBISAR object) {
    return putByIndex(r'notificationId', object);
  }

  Id putByNotificationIdSync(NotificationDBISAR object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'notificationId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNotificationId(List<NotificationDBISAR> objects) {
    return putAllByIndex(r'notificationId', objects);
  }

  List<Id> putAllByNotificationIdSync(List<NotificationDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'notificationId', objects, saveLinks: saveLinks);
  }
}

extension NotificationDBISARQueryWhereSort
    on QueryBuilder<NotificationDBISAR, NotificationDBISAR, QWhere> {
  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationDBISARQueryWhere
    on QueryBuilder<NotificationDBISAR, NotificationDBISAR, QWhereClause> {
  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterWhereClause>
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

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterWhereClause>
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

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterWhereClause>
      notificationIdEqualTo(String notificationId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'notificationId',
        value: [notificationId],
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterWhereClause>
      notificationIdNotEqualTo(String notificationId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notificationId',
              lower: [],
              upper: [notificationId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notificationId',
              lower: [notificationId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notificationId',
              lower: [notificationId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notificationId',
              lower: [],
              upper: [notificationId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension NotificationDBISARQueryFilter
    on QueryBuilder<NotificationDBISAR, NotificationDBISAR, QFilterCondition> {
  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      associatedNoteIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'associatedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      associatedNoteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'associatedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      associatedNoteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'associatedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      associatedNoteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'associatedNoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      associatedNoteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'associatedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      associatedNoteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'associatedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      associatedNoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'associatedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      associatedNoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'associatedNoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      associatedNoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'associatedNoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      associatedNoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'associatedNoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      authorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      authorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      authorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      authorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      authorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      authorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      authorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      authorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      createAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      createAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      createAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      createAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      kindEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kind',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      kindGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kind',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      kindLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kind',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      kindBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      notificationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      notificationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      notificationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      notificationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notificationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      notificationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      notificationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      notificationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notificationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      notificationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notificationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      notificationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      notificationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notificationId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      zapAmountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zapAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      zapAmountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zapAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      zapAmountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zapAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterFilterCondition>
      zapAmountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zapAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NotificationDBISARQueryObject
    on QueryBuilder<NotificationDBISAR, NotificationDBISAR, QFilterCondition> {}

extension NotificationDBISARQueryLinks
    on QueryBuilder<NotificationDBISAR, NotificationDBISAR, QFilterCondition> {}

extension NotificationDBISARQuerySortBy
    on QueryBuilder<NotificationDBISAR, NotificationDBISAR, QSortBy> {
  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByAssociatedNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associatedNoteId', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByAssociatedNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associatedNoteId', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByZapAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmount', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      sortByZapAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmount', Sort.desc);
    });
  }
}

extension NotificationDBISARQuerySortThenBy
    on QueryBuilder<NotificationDBISAR, NotificationDBISAR, QSortThenBy> {
  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByAssociatedNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associatedNoteId', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByAssociatedNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associatedNoteId', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByZapAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmount', Sort.asc);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QAfterSortBy>
      thenByZapAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmount', Sort.desc);
    });
  }
}

extension NotificationDBISARQueryWhereDistinct
    on QueryBuilder<NotificationDBISAR, NotificationDBISAR, QDistinct> {
  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QDistinct>
      distinctByAssociatedNoteId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'associatedNoteId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QDistinct>
      distinctByAuthor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QDistinct>
      distinctByContent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QDistinct>
      distinctByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createAt');
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QDistinct>
      distinctByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kind');
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QDistinct>
      distinctByNotificationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationDBISAR, NotificationDBISAR, QDistinct>
      distinctByZapAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zapAmount');
    });
  }
}

extension NotificationDBISARQueryProperty
    on QueryBuilder<NotificationDBISAR, NotificationDBISAR, QQueryProperty> {
  QueryBuilder<NotificationDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationDBISAR, String, QQueryOperations>
      associatedNoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'associatedNoteId');
    });
  }

  QueryBuilder<NotificationDBISAR, String, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<NotificationDBISAR, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<NotificationDBISAR, int, QQueryOperations> createAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createAt');
    });
  }

  QueryBuilder<NotificationDBISAR, int, QQueryOperations> kindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kind');
    });
  }

  QueryBuilder<NotificationDBISAR, String, QQueryOperations>
      notificationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationId');
    });
  }

  QueryBuilder<NotificationDBISAR, int, QQueryOperations> zapAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zapAmount');
    });
  }
}
