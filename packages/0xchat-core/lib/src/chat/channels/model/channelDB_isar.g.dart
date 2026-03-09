// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channelDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChannelDBISARCollection on Isar {
  IsarCollection<ChannelDBISAR> get channelDBISARs => this.collection();
}

const ChannelDBISARSchema = CollectionSchema(
  name: r'ChannelDBISAR',
  id: -6165771135908169389,
  properties: {
    r'about': PropertySchema(
      id: 0,
      name: r'about',
      type: IsarType.string,
    ),
    r'badges': PropertySchema(
      id: 1,
      name: r'badges',
      type: IsarType.string,
    ),
    r'channelId': PropertySchema(
      id: 2,
      name: r'channelId',
      type: IsarType.string,
    ),
    r'createTime': PropertySchema(
      id: 3,
      name: r'createTime',
      type: IsarType.long,
    ),
    r'creator': PropertySchema(
      id: 4,
      name: r'creator',
      type: IsarType.string,
    ),
    r'mute': PropertySchema(
      id: 5,
      name: r'mute',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'picture': PropertySchema(
      id: 7,
      name: r'picture',
      type: IsarType.string,
    ),
    r'relayURL': PropertySchema(
      id: 8,
      name: r'relayURL',
      type: IsarType.string,
    ),
    r'updateTime': PropertySchema(
      id: 9,
      name: r'updateTime',
      type: IsarType.long,
    )
  },
  estimateSize: _channelDBISAREstimateSize,
  serialize: _channelDBISARSerialize,
  deserialize: _channelDBISARDeserialize,
  deserializeProp: _channelDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'channelId': IndexSchema(
      id: -8352446570702114471,
      name: r'channelId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'channelId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _channelDBISARGetId,
  getLinks: _channelDBISARGetLinks,
  attach: _channelDBISARAttach,
  version: '3.1.0+1',
);

int _channelDBISAREstimateSize(
  ChannelDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.about;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.badges;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.channelId.length * 3;
  bytesCount += 3 + object.creator.length * 3;
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
    final value = object.relayURL;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _channelDBISARSerialize(
  ChannelDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.about);
  writer.writeString(offsets[1], object.badges);
  writer.writeString(offsets[2], object.channelId);
  writer.writeLong(offsets[3], object.createTime);
  writer.writeString(offsets[4], object.creator);
  writer.writeBool(offsets[5], object.mute);
  writer.writeString(offsets[6], object.name);
  writer.writeString(offsets[7], object.picture);
  writer.writeString(offsets[8], object.relayURL);
  writer.writeLong(offsets[9], object.updateTime);
}

ChannelDBISAR _channelDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChannelDBISAR(
    about: reader.readStringOrNull(offsets[0]),
    badges: reader.readStringOrNull(offsets[1]),
    channelId: reader.readStringOrNull(offsets[2]) ?? '',
    createTime: reader.readLongOrNull(offsets[3]) ?? 0,
    creator: reader.readStringOrNull(offsets[4]) ?? '',
    mute: reader.readBoolOrNull(offsets[5]),
    name: reader.readStringOrNull(offsets[6]),
    picture: reader.readStringOrNull(offsets[7]),
    relayURL: reader.readStringOrNull(offsets[8]),
    updateTime: reader.readLongOrNull(offsets[9]) ?? 0,
  );
  object.id = id;
  return object;
}

P _channelDBISARDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _channelDBISARGetId(ChannelDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _channelDBISARGetLinks(ChannelDBISAR object) {
  return [];
}

void _channelDBISARAttach(
    IsarCollection<dynamic> col, Id id, ChannelDBISAR object) {
  object.id = id;
}

extension ChannelDBISARByIndex on IsarCollection<ChannelDBISAR> {
  Future<ChannelDBISAR?> getByChannelId(String channelId) {
    return getByIndex(r'channelId', [channelId]);
  }

  ChannelDBISAR? getByChannelIdSync(String channelId) {
    return getByIndexSync(r'channelId', [channelId]);
  }

  Future<bool> deleteByChannelId(String channelId) {
    return deleteByIndex(r'channelId', [channelId]);
  }

  bool deleteByChannelIdSync(String channelId) {
    return deleteByIndexSync(r'channelId', [channelId]);
  }

  Future<List<ChannelDBISAR?>> getAllByChannelId(List<String> channelIdValues) {
    final values = channelIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'channelId', values);
  }

  List<ChannelDBISAR?> getAllByChannelIdSync(List<String> channelIdValues) {
    final values = channelIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'channelId', values);
  }

  Future<int> deleteAllByChannelId(List<String> channelIdValues) {
    final values = channelIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'channelId', values);
  }

  int deleteAllByChannelIdSync(List<String> channelIdValues) {
    final values = channelIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'channelId', values);
  }

  Future<Id> putByChannelId(ChannelDBISAR object) {
    return putByIndex(r'channelId', object);
  }

  Id putByChannelIdSync(ChannelDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'channelId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByChannelId(List<ChannelDBISAR> objects) {
    return putAllByIndex(r'channelId', objects);
  }

  List<Id> putAllByChannelIdSync(List<ChannelDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'channelId', objects, saveLinks: saveLinks);
  }
}

extension ChannelDBISARQueryWhereSort
    on QueryBuilder<ChannelDBISAR, ChannelDBISAR, QWhere> {
  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChannelDBISARQueryWhere
    on QueryBuilder<ChannelDBISAR, ChannelDBISAR, QWhereClause> {
  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterWhereClause>
      channelIdEqualTo(String channelId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'channelId',
        value: [channelId],
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterWhereClause>
      channelIdNotEqualTo(String channelId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'channelId',
              lower: [],
              upper: [channelId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'channelId',
              lower: [channelId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'channelId',
              lower: [channelId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'channelId',
              lower: [],
              upper: [channelId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ChannelDBISARQueryFilter
    on QueryBuilder<ChannelDBISAR, ChannelDBISAR, QFilterCondition> {
  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'about',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'about',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'about',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'about',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'about',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      aboutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'about',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'badges',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'badges',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'badges',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'badges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'badges',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'badges',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      badgesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'badges',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      channelIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      channelIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      channelIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      channelIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channelId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      channelIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'channelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      channelIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'channelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      channelIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'channelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      channelIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'channelId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      channelIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      channelIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'channelId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      createTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      createTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      createTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      createTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      creatorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'creator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      creatorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'creator',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      creatorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'creator',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      creatorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'creator',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      muteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mute',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      muteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mute',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition> muteEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mute',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'picture',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'picture',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureEqualTo(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureGreaterThan(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureLessThan(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureBetween(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureStartsWith(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureEndsWith(
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

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'picture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      pictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relayURL',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relayURL',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relayURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relayURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relayURL',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relayURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relayURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relayURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relayURL',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayURL',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      relayURLIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relayURL',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      updateTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      updateTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      updateTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterFilterCondition>
      updateTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChannelDBISARQueryObject
    on QueryBuilder<ChannelDBISAR, ChannelDBISAR, QFilterCondition> {}

extension ChannelDBISARQueryLinks
    on QueryBuilder<ChannelDBISAR, ChannelDBISAR, QFilterCondition> {}

extension ChannelDBISARQuerySortBy
    on QueryBuilder<ChannelDBISAR, ChannelDBISAR, QSortBy> {
  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByAbout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByAboutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByBadges() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badges', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByBadgesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badges', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByChannelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelId', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy>
      sortByChannelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelId', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByCreateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy>
      sortByCreateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByCreator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creator', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByCreatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creator', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByMuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByRelayURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayURL', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy>
      sortByRelayURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayURL', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> sortByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy>
      sortByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }
}

extension ChannelDBISARQuerySortThenBy
    on QueryBuilder<ChannelDBISAR, ChannelDBISAR, QSortThenBy> {
  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByAbout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByAboutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByBadges() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badges', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByBadgesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badges', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByChannelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelId', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy>
      thenByChannelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelId', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByCreateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy>
      thenByCreateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createTime', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByCreator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creator', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByCreatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'creator', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByMuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByRelayURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayURL', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy>
      thenByRelayURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relayURL', Sort.desc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy> thenByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QAfterSortBy>
      thenByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }
}

extension ChannelDBISARQueryWhereDistinct
    on QueryBuilder<ChannelDBISAR, ChannelDBISAR, QDistinct> {
  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QDistinct> distinctByAbout(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'about', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QDistinct> distinctByBadges(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'badges', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QDistinct> distinctByChannelId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'channelId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QDistinct> distinctByCreateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createTime');
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QDistinct> distinctByCreator(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'creator', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QDistinct> distinctByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mute');
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QDistinct> distinctByPicture(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'picture', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QDistinct> distinctByRelayURL(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relayURL', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelDBISAR, ChannelDBISAR, QDistinct> distinctByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updateTime');
    });
  }
}

extension ChannelDBISARQueryProperty
    on QueryBuilder<ChannelDBISAR, ChannelDBISAR, QQueryProperty> {
  QueryBuilder<ChannelDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChannelDBISAR, String?, QQueryOperations> aboutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'about');
    });
  }

  QueryBuilder<ChannelDBISAR, String?, QQueryOperations> badgesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'badges');
    });
  }

  QueryBuilder<ChannelDBISAR, String, QQueryOperations> channelIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channelId');
    });
  }

  QueryBuilder<ChannelDBISAR, int, QQueryOperations> createTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createTime');
    });
  }

  QueryBuilder<ChannelDBISAR, String, QQueryOperations> creatorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'creator');
    });
  }

  QueryBuilder<ChannelDBISAR, bool?, QQueryOperations> muteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mute');
    });
  }

  QueryBuilder<ChannelDBISAR, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ChannelDBISAR, String?, QQueryOperations> pictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'picture');
    });
  }

  QueryBuilder<ChannelDBISAR, String?, QQueryOperations> relayURLProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relayURL');
    });
  }

  QueryBuilder<ChannelDBISAR, int, QQueryOperations> updateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updateTime');
    });
  }
}
