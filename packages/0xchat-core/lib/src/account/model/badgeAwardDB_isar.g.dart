// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badgeAwardDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBadgeAwardDBISARCollection on Isar {
  IsarCollection<BadgeAwardDBISAR> get badgeAwardDBISARs => this.collection();
}

const BadgeAwardDBISARSchema = CollectionSchema(
  name: r'BadgeAwardDBISAR',
  id: -879714027544675096,
  properties: {
    r'awardId': PropertySchema(
      id: 0,
      name: r'awardId',
      type: IsarType.string,
    ),
    r'awardTime': PropertySchema(
      id: 1,
      name: r'awardTime',
      type: IsarType.long,
    ),
    r'badgeId': PropertySchema(
      id: 2,
      name: r'badgeId',
      type: IsarType.string,
    ),
    r'badgeOwner': PropertySchema(
      id: 3,
      name: r'badgeOwner',
      type: IsarType.string,
    ),
    r'creator': PropertySchema(
      id: 4,
      name: r'creator',
      type: IsarType.string,
    ),
    r'identifies': PropertySchema(
      id: 5,
      name: r'identifies',
      type: IsarType.string,
    ),
    r'relay': PropertySchema(
      id: 6,
      name: r'relay',
      type: IsarType.string,
    )
  },
  estimateSize: _badgeAwardDBISAREstimateSize,
  serialize: _badgeAwardDBISARSerialize,
  deserialize: _badgeAwardDBISARDeserialize,
  deserializeProp: _badgeAwardDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'awardId': IndexSchema(
      id: -9091548775077802725,
      name: r'awardId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'awardId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _badgeAwardDBISARGetId,
  getLinks: _badgeAwardDBISARGetLinks,
  attach: _badgeAwardDBISARAttach,
  version: '3.1.0+1',
);

int _badgeAwardDBISAREstimateSize(
  BadgeAwardDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.awardId.length * 3;
  bytesCount += 3 + object.badgeId.length * 3;
  bytesCount += 3 + object.badgeOwner.length * 3;
  bytesCount += 3 + object.creator.length * 3;
  bytesCount += 3 + object.identifies.length * 3;
  bytesCount += 3 + object.relay.length * 3;
  return bytesCount;
}

void _badgeAwardDBISARSerialize(
  BadgeAwardDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.awardId);
  writer.writeLong(offsets[1], object.awardTime);
  writer.writeString(offsets[2], object.badgeId);
  writer.writeString(offsets[3], object.badgeOwner);
  writer.writeString(offsets[4], object.creator);
  writer.writeString(offsets[5], object.identifies);
  writer.writeString(offsets[6], object.relay);
}

BadgeAwardDBISAR _badgeAwardDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BadgeAwardDBISAR(
    awardId: reader.readStringOrNull(offsets[0]) ?? '',
    awardTime: reader.readLongOrNull(offsets[1]) ?? 0,
    badgeId: reader.readStringOrNull(offsets[2]) ?? '',
    badgeOwner: reader.readStringOrNull(offsets[3]) ?? '',
    creator: reader.readStringOrNull(offsets[4]) ?? '',
    identifies: reader.readStringOrNull(offsets[5]) ?? '',
    relay: reader.readStringOrNull(offsets[6]) ?? '',
  );
  object.id = id;
  return object;
}

P _badgeAwardDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _badgeAwardDBISARGetId(BadgeAwardDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _badgeAwardDBISARGetLinks(BadgeAwardDBISAR object) {
  return [];
}

void _badgeAwardDBISARAttach(
    IsarCollection<dynamic> col, Id id, BadgeAwardDBISAR object) {
  object.id = id;
}

extension BadgeAwardDBISARByIndex on IsarCollection<BadgeAwardDBISAR> {
  Future<BadgeAwardDBISAR?> getByAwardId(String awardId) {
    return getByIndex(r'awardId', [awardId]);
  }

  BadgeAwardDBISAR? getByAwardIdSync(String awardId) {
    return getByIndexSync(r'awardId', [awardId]);
  }

  Future<bool> deleteByAwardId(String awardId) {
    return deleteByIndex(r'awardId', [awardId]);
  }

  bool deleteByAwardIdSync(String awardId) {
    return deleteByIndexSync(r'awardId', [awardId]);
  }

  Future<List<BadgeAwardDBISAR?>> getAllByAwardId(List<String> awardIdValues) {
    final values = awardIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'awardId', values);
  }

  List<BadgeAwardDBISAR?> getAllByAwardIdSync(List<String> awardIdValues) {
    final values = awardIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'awardId', values);
  }

  Future<int> deleteAllByAwardId(List<String> awardIdValues) {
    final values = awardIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'awardId', values);
  }

  int deleteAllByAwardIdSync(List<String> awardIdValues) {
    final values = awardIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'awardId', values);
  }

  Future<Id> putByAwardId(BadgeAwardDBISAR object) {
    return putByIndex(r'awardId', object);
  }

  Id putByAwardIdSync(BadgeAwardDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'awardId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAwardId(List<BadgeAwardDBISAR> objects) {
    return putAllByIndex(r'awardId', objects);
  }

  List<Id> putAllByAwardIdSync(List<BadgeAwardDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'awardId', objects, saveLinks: saveLinks);
  }
}

extension BadgeAwardDBISARQueryWhereSort
    on QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QWhere> {
  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BadgeAwardDBISARQueryWhere
    on QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QWhereClause> {
  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterWhereClause>
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

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterWhereClause>
      awardIdEqualTo(String awardId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'awardId',
        value: [awardId],
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterWhereClause>
      awardIdNotEqualTo(String awardId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'awardId',
              lower: [],
              upper: [awardId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'awardId',
              lower: [awardId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'awardId',
              lower: [awardId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'awardId',
              lower: [],
              upper: [awardId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BadgeAwardDBISARQueryFilter
    on QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QFilterCondition> {
  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'awardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'awardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'awardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'awardId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'awardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'awardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'awardId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'awardId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'awardId',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'awardId',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'awardTime',
        value: value,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'awardTime',
        value: value,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'awardTime',
        value: value,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      awardTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'awardTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'badgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'badgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'badgeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'badgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'badgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'badgeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'badgeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badgeId',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'badgeId',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeOwnerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badgeOwner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeOwnerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'badgeOwner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeOwnerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'badgeOwner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeOwnerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'badgeOwner',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeOwnerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'badgeOwner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeOwnerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'badgeOwner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeOwnerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'badgeOwner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeOwnerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'badgeOwner',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeOwnerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badgeOwner',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      badgeOwnerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'badgeOwner',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      creatorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      creatorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'creator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      creatorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'creator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      creatorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'creator',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      creatorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'creator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      creatorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'creator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      creatorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'creator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      creatorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'creator',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      creatorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creator',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      creatorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'creator',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
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

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
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

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
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

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      identifiesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'identifies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      identifiesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'identifies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      identifiesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'identifies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      identifiesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'identifies',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      identifiesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'identifies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      identifiesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'identifies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      identifiesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'identifies',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      identifiesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'identifies',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      identifiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'identifies',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      identifiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'identifies',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      relayEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      relayGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      relayLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      relayBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      relayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      relayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      relayContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      relayMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relay',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      relayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relay',
        value: '',
      ));
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterFilterCondition>
      relayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relay',
        value: '',
      ));
    });
  }
}

extension BadgeAwardDBISARQueryObject
    on QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QFilterCondition> {}

extension BadgeAwardDBISARQueryLinks
    on QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QFilterCondition> {}

extension BadgeAwardDBISARQuerySortBy
    on QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QSortBy> {
  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByAwardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awardId', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByAwardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awardId', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByAwardTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awardTime', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByAwardTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awardTime', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByBadgeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeId', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByBadgeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeId', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByBadgeOwner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeOwner', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByBadgeOwnerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeOwner', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByCreator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creator', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByCreatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creator', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByIdentifies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifies', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByIdentifiesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifies', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy> sortByRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      sortByRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.desc);
    });
  }
}

extension BadgeAwardDBISARQuerySortThenBy
    on QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QSortThenBy> {
  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByAwardId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awardId', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByAwardIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awardId', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByAwardTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awardTime', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByAwardTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'awardTime', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByBadgeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeId', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByBadgeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeId', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByBadgeOwner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeOwner', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByBadgeOwnerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeOwner', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByCreator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creator', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByCreatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creator', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByIdentifies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifies', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByIdentifiesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifies', Sort.desc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy> thenByRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.asc);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QAfterSortBy>
      thenByRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.desc);
    });
  }
}

extension BadgeAwardDBISARQueryWhereDistinct
    on QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QDistinct> {
  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QDistinct> distinctByAwardId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'awardId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QDistinct>
      distinctByAwardTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'awardTime');
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QDistinct> distinctByBadgeId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'badgeId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QDistinct>
      distinctByBadgeOwner({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'badgeOwner', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QDistinct> distinctByCreator(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creator', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QDistinct>
      distinctByIdentifies({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'identifies', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QDistinct> distinctByRelay(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relay', caseSensitive: caseSensitive);
    });
  }
}

extension BadgeAwardDBISARQueryProperty
    on QueryBuilder<BadgeAwardDBISAR, BadgeAwardDBISAR, QQueryProperty> {
  QueryBuilder<BadgeAwardDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BadgeAwardDBISAR, String, QQueryOperations> awardIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'awardId');
    });
  }

  QueryBuilder<BadgeAwardDBISAR, int, QQueryOperations> awardTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'awardTime');
    });
  }

  QueryBuilder<BadgeAwardDBISAR, String, QQueryOperations> badgeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'badgeId');
    });
  }

  QueryBuilder<BadgeAwardDBISAR, String, QQueryOperations>
      badgeOwnerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'badgeOwner');
    });
  }

  QueryBuilder<BadgeAwardDBISAR, String, QQueryOperations> creatorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creator');
    });
  }

  QueryBuilder<BadgeAwardDBISAR, String, QQueryOperations>
      identifiesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'identifies');
    });
  }

  QueryBuilder<BadgeAwardDBISAR, String, QQueryOperations> relayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relay');
    });
  }
}
