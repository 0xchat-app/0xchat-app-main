// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zapRecordsDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetZapRecordsDBISARCollection on Isar {
  IsarCollection<ZapRecordsDBISAR> get zapRecordsDBISARs => this.collection();
}

const ZapRecordsDBISARSchema = CollectionSchema(
  name: r'ZapRecordsDBISAR',
  id: 8771200882324926452,
  properties: {
    r'bolt11': PropertySchema(
      id: 0,
      name: r'bolt11',
      type: IsarType.string,
    ),
    r'content': PropertySchema(
      id: 1,
      name: r'content',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'eventId': PropertySchema(
      id: 3,
      name: r'eventId',
      type: IsarType.string,
    ),
    r'findEvent': PropertySchema(
      id: 4,
      name: r'findEvent',
      type: IsarType.bool,
    ),
    r'paidAt': PropertySchema(
      id: 5,
      name: r'paidAt',
      type: IsarType.long,
    ),
    r'preimage': PropertySchema(
      id: 6,
      name: r'preimage',
      type: IsarType.string,
    ),
    r'recipient': PropertySchema(
      id: 7,
      name: r'recipient',
      type: IsarType.string,
    ),
    r'sender': PropertySchema(
      id: 8,
      name: r'sender',
      type: IsarType.string,
    ),
    r'zapper': PropertySchema(
      id: 9,
      name: r'zapper',
      type: IsarType.string,
    )
  },
  estimateSize: _zapRecordsDBISAREstimateSize,
  serialize: _zapRecordsDBISARSerialize,
  deserialize: _zapRecordsDBISARDeserialize,
  deserializeProp: _zapRecordsDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'bolt11': IndexSchema(
      id: -8263078770439975857,
      name: r'bolt11',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'bolt11',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _zapRecordsDBISARGetId,
  getLinks: _zapRecordsDBISARGetLinks,
  attach: _zapRecordsDBISARAttach,
  version: '3.1.0+1',
);

int _zapRecordsDBISAREstimateSize(
  ZapRecordsDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bolt11.length * 3;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.eventId.length * 3;
  bytesCount += 3 + object.preimage.length * 3;
  bytesCount += 3 + object.recipient.length * 3;
  bytesCount += 3 + object.sender.length * 3;
  bytesCount += 3 + object.zapper.length * 3;
  return bytesCount;
}

void _zapRecordsDBISARSerialize(
  ZapRecordsDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bolt11);
  writer.writeString(offsets[1], object.content);
  writer.writeString(offsets[2], object.description);
  writer.writeString(offsets[3], object.eventId);
  writer.writeBool(offsets[4], object.findEvent);
  writer.writeLong(offsets[5], object.paidAt);
  writer.writeString(offsets[6], object.preimage);
  writer.writeString(offsets[7], object.recipient);
  writer.writeString(offsets[8], object.sender);
  writer.writeString(offsets[9], object.zapper);
}

ZapRecordsDBISAR _zapRecordsDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ZapRecordsDBISAR(
    bolt11: reader.readStringOrNull(offsets[0]) ?? '',
    content: reader.readStringOrNull(offsets[1]) ?? '',
    description: reader.readStringOrNull(offsets[2]) ?? '',
    eventId: reader.readStringOrNull(offsets[3]) ?? '',
    findEvent: reader.readBoolOrNull(offsets[4]) ?? false,
    paidAt: reader.readLongOrNull(offsets[5]) ?? 0,
    preimage: reader.readStringOrNull(offsets[6]) ?? '',
    recipient: reader.readStringOrNull(offsets[7]) ?? '',
    sender: reader.readStringOrNull(offsets[8]) ?? '',
    zapper: reader.readStringOrNull(offsets[9]) ?? '',
  );
  object.id = id;
  return object;
}

P _zapRecordsDBISARDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 9:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _zapRecordsDBISARGetId(ZapRecordsDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _zapRecordsDBISARGetLinks(ZapRecordsDBISAR object) {
  return [];
}

void _zapRecordsDBISARAttach(
    IsarCollection<dynamic> col, Id id, ZapRecordsDBISAR object) {
  object.id = id;
}

extension ZapRecordsDBISARByIndex on IsarCollection<ZapRecordsDBISAR> {
  Future<ZapRecordsDBISAR?> getByBolt11(String bolt11) {
    return getByIndex(r'bolt11', [bolt11]);
  }

  ZapRecordsDBISAR? getByBolt11Sync(String bolt11) {
    return getByIndexSync(r'bolt11', [bolt11]);
  }

  Future<bool> deleteByBolt11(String bolt11) {
    return deleteByIndex(r'bolt11', [bolt11]);
  }

  bool deleteByBolt11Sync(String bolt11) {
    return deleteByIndexSync(r'bolt11', [bolt11]);
  }

  Future<List<ZapRecordsDBISAR?>> getAllByBolt11(List<String> bolt11Values) {
    final values = bolt11Values.map((e) => [e]).toList();
    return getAllByIndex(r'bolt11', values);
  }

  List<ZapRecordsDBISAR?> getAllByBolt11Sync(List<String> bolt11Values) {
    final values = bolt11Values.map((e) => [e]).toList();
    return getAllByIndexSync(r'bolt11', values);
  }

  Future<int> deleteAllByBolt11(List<String> bolt11Values) {
    final values = bolt11Values.map((e) => [e]).toList();
    return deleteAllByIndex(r'bolt11', values);
  }

  int deleteAllByBolt11Sync(List<String> bolt11Values) {
    final values = bolt11Values.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'bolt11', values);
  }

  Future<Id> putByBolt11(ZapRecordsDBISAR object) {
    return putByIndex(r'bolt11', object);
  }

  Id putByBolt11Sync(ZapRecordsDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'bolt11', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBolt11(List<ZapRecordsDBISAR> objects) {
    return putAllByIndex(r'bolt11', objects);
  }

  List<Id> putAllByBolt11Sync(List<ZapRecordsDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'bolt11', objects, saveLinks: saveLinks);
  }
}

extension ZapRecordsDBISARQueryWhereSort
    on QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QWhere> {
  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ZapRecordsDBISARQueryWhere
    on QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QWhereClause> {
  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterWhereClause>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterWhereClause>
      bolt11EqualTo(String bolt11) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bolt11',
        value: [bolt11],
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterWhereClause>
      bolt11NotEqualTo(String bolt11) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bolt11',
              lower: [],
              upper: [bolt11],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bolt11',
              lower: [bolt11],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bolt11',
              lower: [bolt11],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bolt11',
              lower: [],
              upper: [bolt11],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ZapRecordsDBISARQueryFilter
    on QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QFilterCondition> {
  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      bolt11EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      bolt11GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      bolt11LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      bolt11Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bolt11',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      bolt11StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      bolt11EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      bolt11Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bolt11',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      bolt11Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bolt11',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      bolt11IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bolt11',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      bolt11IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bolt11',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      eventIdEqualTo(
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      eventIdLessThan(
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      eventIdBetween(
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      eventIdEndsWith(
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      eventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      eventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      eventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      eventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      findEventEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'findEvent',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      paidAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paidAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      paidAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paidAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      paidAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paidAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      paidAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paidAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      preimageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      preimageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      preimageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      preimageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preimage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      preimageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      preimageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      preimageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preimage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      preimageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preimage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      preimageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preimage',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      preimageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preimage',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      recipientEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      recipientGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      recipientLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      recipientBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recipient',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      recipientStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      recipientEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      recipientContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recipient',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      recipientMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recipient',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      recipientIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recipient',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      recipientIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recipient',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      senderEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      senderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      senderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      senderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      senderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      senderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      senderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      senderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      senderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sender',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      senderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sender',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      zapperEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zapper',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      zapperGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zapper',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      zapperLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zapper',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      zapperBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zapper',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      zapperStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'zapper',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      zapperEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'zapper',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      zapperContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'zapper',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      zapperMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'zapper',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      zapperIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zapper',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterFilterCondition>
      zapperIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'zapper',
        value: '',
      ));
    });
  }
}

extension ZapRecordsDBISARQueryObject
    on QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QFilterCondition> {}

extension ZapRecordsDBISARQueryLinks
    on QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QFilterCondition> {}

extension ZapRecordsDBISARQuerySortBy
    on QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QSortBy> {
  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByBolt11() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bolt11', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByBolt11Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bolt11', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByFindEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'findEvent', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByFindEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'findEvent', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByPaidAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByPreimage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByPreimageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByRecipient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByRecipientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByZapper() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapper', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      sortByZapperDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapper', Sort.desc);
    });
  }
}

extension ZapRecordsDBISARQuerySortThenBy
    on QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QSortThenBy> {
  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByBolt11() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bolt11', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByBolt11Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bolt11', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByFindEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'findEvent', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByFindEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'findEvent', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByPaidAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByPreimage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByPreimageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preimage', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByRecipient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByRecipientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipient', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenBySender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenBySenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sender', Sort.desc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByZapper() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapper', Sort.asc);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QAfterSortBy>
      thenByZapperDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapper', Sort.desc);
    });
  }
}

extension ZapRecordsDBISARQueryWhereDistinct
    on QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QDistinct> {
  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QDistinct> distinctByBolt11(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bolt11', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QDistinct> distinctByEventId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QDistinct>
      distinctByFindEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'findEvent');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QDistinct>
      distinctByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paidAt');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QDistinct>
      distinctByPreimage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preimage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QDistinct>
      distinctByRecipient({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recipient', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QDistinct> distinctBySender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QDistinct> distinctByZapper(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zapper', caseSensitive: caseSensitive);
    });
  }
}

extension ZapRecordsDBISARQueryProperty
    on QueryBuilder<ZapRecordsDBISAR, ZapRecordsDBISAR, QQueryProperty> {
  QueryBuilder<ZapRecordsDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, String, QQueryOperations> bolt11Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bolt11');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, String, QQueryOperations> eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, bool, QQueryOperations> findEventProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'findEvent');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, int, QQueryOperations> paidAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paidAt');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, String, QQueryOperations> preimageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preimage');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, String, QQueryOperations> recipientProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recipient');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, String, QQueryOperations> senderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sender');
    });
  }

  QueryBuilder<ZapRecordsDBISAR, String, QQueryOperations> zapperProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zapper');
    });
  }
}
