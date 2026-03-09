// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEventDBISARCollection on Isar {
  IsarCollection<EventDBISAR> get eventDBISARs => this.collection();
}

const EventDBISARSchema = CollectionSchema(
  name: r'EventDBISAR',
  id: -229809567576281012,
  properties: {
    r'eventId': PropertySchema(
      id: 0,
      name: r'eventId',
      type: IsarType.string,
    ),
    r'eventReceiveStatusJson': PropertySchema(
      id: 1,
      name: r'eventReceiveStatusJson',
      type: IsarType.string,
    ),
    r'eventSendStatusJson': PropertySchema(
      id: 2,
      name: r'eventSendStatusJson',
      type: IsarType.string,
    ),
    r'expiration': PropertySchema(
      id: 3,
      name: r'expiration',
      type: IsarType.long,
    ),
    r'rawData': PropertySchema(
      id: 4,
      name: r'rawData',
      type: IsarType.string,
    )
  },
  estimateSize: _eventDBISAREstimateSize,
  serialize: _eventDBISARSerialize,
  deserialize: _eventDBISARDeserialize,
  deserializeProp: _eventDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'eventId': IndexSchema(
      id: -2707901133518603130,
      name: r'eventId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'eventId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _eventDBISARGetId,
  getLinks: _eventDBISARGetLinks,
  attach: _eventDBISARAttach,
  version: '3.1.0+1',
);

int _eventDBISAREstimateSize(
  EventDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.eventId.length * 3;
  {
    final value = object.eventReceiveStatusJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.eventSendStatusJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.rawData.length * 3;
  return bytesCount;
}

void _eventDBISARSerialize(
  EventDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.eventId);
  writer.writeString(offsets[1], object.eventReceiveStatusJson);
  writer.writeString(offsets[2], object.eventSendStatusJson);
  writer.writeLong(offsets[3], object.expiration);
  writer.writeString(offsets[4], object.rawData);
}

EventDBISAR _eventDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EventDBISAR(
    eventId: reader.readStringOrNull(offsets[0]) ?? '',
    expiration: reader.readLongOrNull(offsets[3]),
    rawData: reader.readStringOrNull(offsets[4]) ?? '',
  );
  object.eventReceiveStatusJson = reader.readStringOrNull(offsets[1]);
  object.eventSendStatusJson = reader.readStringOrNull(offsets[2]);
  object.id = id;
  return object;
}

P _eventDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _eventDBISARGetId(EventDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _eventDBISARGetLinks(EventDBISAR object) {
  return [];
}

void _eventDBISARAttach(
    IsarCollection<dynamic> col, Id id, EventDBISAR object) {
  object.id = id;
}

extension EventDBISARByIndex on IsarCollection<EventDBISAR> {
  Future<EventDBISAR?> getByEventId(String eventId) {
    return getByIndex(r'eventId', [eventId]);
  }

  EventDBISAR? getByEventIdSync(String eventId) {
    return getByIndexSync(r'eventId', [eventId]);
  }

  Future<bool> deleteByEventId(String eventId) {
    return deleteByIndex(r'eventId', [eventId]);
  }

  bool deleteByEventIdSync(String eventId) {
    return deleteByIndexSync(r'eventId', [eventId]);
  }

  Future<List<EventDBISAR?>> getAllByEventId(List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'eventId', values);
  }

  List<EventDBISAR?> getAllByEventIdSync(List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'eventId', values);
  }

  Future<int> deleteAllByEventId(List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'eventId', values);
  }

  int deleteAllByEventIdSync(List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'eventId', values);
  }

  Future<Id> putByEventId(EventDBISAR object) {
    return putByIndex(r'eventId', object);
  }

  Id putByEventIdSync(EventDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'eventId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEventId(List<EventDBISAR> objects) {
    return putAllByIndex(r'eventId', objects);
  }

  List<Id> putAllByEventIdSync(List<EventDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'eventId', objects, saveLinks: saveLinks);
  }
}

extension EventDBISARQueryWhereSort
    on QueryBuilder<EventDBISAR, EventDBISAR, QWhere> {
  QueryBuilder<EventDBISAR, EventDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EventDBISARQueryWhere
    on QueryBuilder<EventDBISAR, EventDBISAR, QWhereClause> {
  QueryBuilder<EventDBISAR, EventDBISAR, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterWhereClause> eventIdEqualTo(
      String eventId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'eventId',
        value: [eventId],
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterWhereClause> eventIdNotEqualTo(
      String eventId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [],
              upper: [eventId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [eventId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [eventId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [],
              upper: [eventId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension EventDBISARQueryFilter
    on QueryBuilder<EventDBISAR, EventDBISAR, QFilterCondition> {
  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> eventIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> eventIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> eventIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> eventIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> eventIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> eventIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eventReceiveStatusJson',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eventReceiveStatusJson',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventReceiveStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventReceiveStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventReceiveStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventReceiveStatusJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventReceiveStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventReceiveStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventReceiveStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventReceiveStatusJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventReceiveStatusJson',
        value: '',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventReceiveStatusJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventReceiveStatusJson',
        value: '',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eventSendStatusJson',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eventSendStatusJson',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventSendStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventSendStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventSendStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventSendStatusJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventSendStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventSendStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventSendStatusJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventSendStatusJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventSendStatusJson',
        value: '',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      eventSendStatusJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventSendStatusJson',
        value: '',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      expirationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiration',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      expirationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiration',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      expirationEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiration',
        value: value,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      expirationGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiration',
        value: value,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      expirationLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiration',
        value: value,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      expirationBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> idBetween(
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

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> rawDataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      rawDataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> rawDataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> rawDataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      rawDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> rawDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> rawDataContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition> rawDataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      rawDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawData',
        value: '',
      ));
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterFilterCondition>
      rawDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawData',
        value: '',
      ));
    });
  }
}

extension EventDBISARQueryObject
    on QueryBuilder<EventDBISAR, EventDBISAR, QFilterCondition> {}

extension EventDBISARQueryLinks
    on QueryBuilder<EventDBISAR, EventDBISAR, QFilterCondition> {}

extension EventDBISARQuerySortBy
    on QueryBuilder<EventDBISAR, EventDBISAR, QSortBy> {
  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy>
      sortByEventReceiveStatusJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventReceiveStatusJson', Sort.asc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy>
      sortByEventReceiveStatusJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventReceiveStatusJson', Sort.desc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy>
      sortByEventSendStatusJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventSendStatusJson', Sort.asc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy>
      sortByEventSendStatusJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventSendStatusJson', Sort.desc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> sortByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.asc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> sortByExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.desc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> sortByRawData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawData', Sort.asc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> sortByRawDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawData', Sort.desc);
    });
  }
}

extension EventDBISARQuerySortThenBy
    on QueryBuilder<EventDBISAR, EventDBISAR, QSortThenBy> {
  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy>
      thenByEventReceiveStatusJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventReceiveStatusJson', Sort.asc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy>
      thenByEventReceiveStatusJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventReceiveStatusJson', Sort.desc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy>
      thenByEventSendStatusJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventSendStatusJson', Sort.asc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy>
      thenByEventSendStatusJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventSendStatusJson', Sort.desc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> thenByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.asc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> thenByExpirationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiration', Sort.desc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> thenByRawData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawData', Sort.asc);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QAfterSortBy> thenByRawDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawData', Sort.desc);
    });
  }
}

extension EventDBISARQueryWhereDistinct
    on QueryBuilder<EventDBISAR, EventDBISAR, QDistinct> {
  QueryBuilder<EventDBISAR, EventDBISAR, QDistinct> distinctByEventId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QDistinct>
      distinctByEventReceiveStatusJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventReceiveStatusJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QDistinct>
      distinctByEventSendStatusJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventSendStatusJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QDistinct> distinctByExpiration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiration');
    });
  }

  QueryBuilder<EventDBISAR, EventDBISAR, QDistinct> distinctByRawData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawData', caseSensitive: caseSensitive);
    });
  }
}

extension EventDBISARQueryProperty
    on QueryBuilder<EventDBISAR, EventDBISAR, QQueryProperty> {
  QueryBuilder<EventDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EventDBISAR, String, QQueryOperations> eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<EventDBISAR, String?, QQueryOperations>
      eventReceiveStatusJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventReceiveStatusJson');
    });
  }

  QueryBuilder<EventDBISAR, String?, QQueryOperations>
      eventSendStatusJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventSendStatusJson');
    });
  }

  QueryBuilder<EventDBISAR, int?, QQueryOperations> expirationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiration');
    });
  }

  QueryBuilder<EventDBISAR, String, QQueryOperations> rawDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawData');
    });
  }
}
