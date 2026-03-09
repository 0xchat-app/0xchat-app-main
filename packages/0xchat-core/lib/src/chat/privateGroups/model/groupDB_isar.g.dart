// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGroupDBISARCollection on Isar {
  IsarCollection<GroupDBISAR> get groupDBISARs => this.collection();
}

const GroupDBISARSchema = CollectionSchema(
  name: r'GroupDBISAR',
  id: -6096750642329496351,
  properties: {
    r'about': PropertySchema(
      id: 0,
      name: r'about',
      type: IsarType.string,
    ),
    r'adminPubkeys': PropertySchema(
      id: 1,
      name: r'adminPubkeys',
      type: IsarType.stringList,
    ),
    r'epoch': PropertySchema(
      id: 2,
      name: r'epoch',
      type: IsarType.long,
    ),
    r'groupId': PropertySchema(
      id: 3,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'isDirectMessage': PropertySchema(
      id: 4,
      name: r'isDirectMessage',
      type: IsarType.bool,
    ),
    r'isMLSGroup': PropertySchema(
      id: 5,
      name: r'isMLSGroup',
      type: IsarType.bool,
    ),
    r'members': PropertySchema(
      id: 6,
      name: r'members',
      type: IsarType.stringList,
    ),
    r'mlsGroupId': PropertySchema(
      id: 7,
      name: r'mlsGroupId',
      type: IsarType.longList,
    ),
    r'mute': PropertySchema(
      id: 8,
      name: r'mute',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 9,
      name: r'name',
      type: IsarType.string,
    ),
    r'owner': PropertySchema(
      id: 10,
      name: r'owner',
      type: IsarType.string,
    ),
    r'picture': PropertySchema(
      id: 11,
      name: r'picture',
      type: IsarType.string,
    ),
    r'pinned': PropertySchema(
      id: 12,
      name: r'pinned',
      type: IsarType.stringList,
    ),
    r'relay': PropertySchema(
      id: 13,
      name: r'relay',
      type: IsarType.string,
    ),
    r'updateTime': PropertySchema(
      id: 14,
      name: r'updateTime',
      type: IsarType.long,
    ),
    r'welcomeEventString': PropertySchema(
      id: 15,
      name: r'welcomeEventString',
      type: IsarType.string,
    ),
    r'welcomeWrapperEventId': PropertySchema(
      id: 16,
      name: r'welcomeWrapperEventId',
      type: IsarType.string,
    )
  },
  estimateSize: _groupDBISAREstimateSize,
  serialize: _groupDBISARSerialize,
  deserialize: _groupDBISARDeserialize,
  deserializeProp: _groupDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'groupId': IndexSchema(
      id: -8523216633229774932,
      name: r'groupId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'groupId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _groupDBISARGetId,
  getLinks: _groupDBISARGetLinks,
  attach: _groupDBISARAttach,
  version: '3.1.0+1',
);

int _groupDBISAREstimateSize(
  GroupDBISAR object,
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
    final list = object.adminPubkeys;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.groupId.length * 3;
  {
    final list = object.members;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.mlsGroupId;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.owner.length * 3;
  {
    final value = object.picture;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.pinned;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.relay;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.welcomeEventString;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.welcomeWrapperEventId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _groupDBISARSerialize(
  GroupDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.about);
  writer.writeStringList(offsets[1], object.adminPubkeys);
  writer.writeLong(offsets[2], object.epoch);
  writer.writeString(offsets[3], object.groupId);
  writer.writeBool(offsets[4], object.isDirectMessage);
  writer.writeBool(offsets[5], object.isMLSGroup);
  writer.writeStringList(offsets[6], object.members);
  writer.writeLongList(offsets[7], object.mlsGroupId);
  writer.writeBool(offsets[8], object.mute);
  writer.writeString(offsets[9], object.name);
  writer.writeString(offsets[10], object.owner);
  writer.writeString(offsets[11], object.picture);
  writer.writeStringList(offsets[12], object.pinned);
  writer.writeString(offsets[13], object.relay);
  writer.writeLong(offsets[14], object.updateTime);
  writer.writeString(offsets[15], object.welcomeEventString);
  writer.writeString(offsets[16], object.welcomeWrapperEventId);
}

GroupDBISAR _groupDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GroupDBISAR(
    about: reader.readStringOrNull(offsets[0]),
    adminPubkeys: reader.readStringList(offsets[1]),
    epoch: reader.readLongOrNull(offsets[2]) ?? 0,
    groupId: reader.readStringOrNull(offsets[3]) ?? '',
    isDirectMessage: reader.readBoolOrNull(offsets[4]) ?? false,
    isMLSGroup: reader.readBoolOrNull(offsets[5]) ?? false,
    members: reader.readStringList(offsets[6]),
    mlsGroupId: reader.readLongList(offsets[7]),
    mute: reader.readBoolOrNull(offsets[8]) ?? false,
    name: reader.readStringOrNull(offsets[9]) ?? '',
    owner: reader.readStringOrNull(offsets[10]) ?? '',
    picture: reader.readStringOrNull(offsets[11]),
    pinned: reader.readStringList(offsets[12]),
    relay: reader.readStringOrNull(offsets[13]),
    updateTime: reader.readLongOrNull(offsets[14]) ?? 0,
    welcomeEventString: reader.readStringOrNull(offsets[15]),
    welcomeWrapperEventId: reader.readStringOrNull(offsets[16]),
  );
  object.id = id;
  return object;
}

P _groupDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 6:
      return (reader.readStringList(offset)) as P;
    case 7:
      return (reader.readLongList(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 9:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 10:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringList(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _groupDBISARGetId(GroupDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _groupDBISARGetLinks(GroupDBISAR object) {
  return [];
}

void _groupDBISARAttach(
    IsarCollection<dynamic> col, Id id, GroupDBISAR object) {
  object.id = id;
}

extension GroupDBISARByIndex on IsarCollection<GroupDBISAR> {
  Future<GroupDBISAR?> getByGroupId(String groupId) {
    return getByIndex(r'groupId', [groupId]);
  }

  GroupDBISAR? getByGroupIdSync(String groupId) {
    return getByIndexSync(r'groupId', [groupId]);
  }

  Future<bool> deleteByGroupId(String groupId) {
    return deleteByIndex(r'groupId', [groupId]);
  }

  bool deleteByGroupIdSync(String groupId) {
    return deleteByIndexSync(r'groupId', [groupId]);
  }

  Future<List<GroupDBISAR?>> getAllByGroupId(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'groupId', values);
  }

  List<GroupDBISAR?> getAllByGroupIdSync(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'groupId', values);
  }

  Future<int> deleteAllByGroupId(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'groupId', values);
  }

  int deleteAllByGroupIdSync(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'groupId', values);
  }

  Future<Id> putByGroupId(GroupDBISAR object) {
    return putByIndex(r'groupId', object);
  }

  Id putByGroupIdSync(GroupDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'groupId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByGroupId(List<GroupDBISAR> objects) {
    return putAllByIndex(r'groupId', objects);
  }

  List<Id> putAllByGroupIdSync(List<GroupDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'groupId', objects, saveLinks: saveLinks);
  }
}

extension GroupDBISARQueryWhereSort
    on QueryBuilder<GroupDBISAR, GroupDBISAR, QWhere> {
  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GroupDBISARQueryWhere
    on QueryBuilder<GroupDBISAR, GroupDBISAR, QWhereClause> {
  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterWhereClause> groupIdEqualTo(
      String groupId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupId',
        value: [groupId],
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterWhereClause> groupIdNotEqualTo(
      String groupId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension GroupDBISARQueryFilter
    on QueryBuilder<GroupDBISAR, GroupDBISAR, QFilterCondition> {
  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> aboutIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'about',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      aboutIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'about',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> aboutEqualTo(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> aboutLessThan(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> aboutBetween(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> aboutStartsWith(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> aboutEndsWith(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> aboutContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'about',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> aboutMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'about',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> aboutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'about',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      aboutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'about',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'adminPubkeys',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'adminPubkeys',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adminPubkeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'adminPubkeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'adminPubkeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'adminPubkeys',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'adminPubkeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'adminPubkeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'adminPubkeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'adminPubkeys',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adminPubkeys',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'adminPubkeys',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminPubkeys',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminPubkeys',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminPubkeys',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminPubkeys',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminPubkeys',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      adminPubkeysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminPubkeys',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> epochEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'epoch',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      epochGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'epoch',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> epochLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'epoch',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> epochBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'epoch',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> groupIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      groupIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> groupIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> groupIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      groupIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> groupIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> groupIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> groupIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> idBetween(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      isDirectMessageEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDirectMessage',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      isMLSGroupEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMLSGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'members',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'members',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'members',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'members',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'members',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'members',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'members',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      membersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'members',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mlsGroupId',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mlsGroupId',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mlsGroupId',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mlsGroupId',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mlsGroupId',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mlsGroupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mlsGroupId',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mlsGroupId',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mlsGroupId',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mlsGroupId',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mlsGroupId',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      mlsGroupIdLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mlsGroupId',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> muteEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mute',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> nameContains(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> ownerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'owner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      ownerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'owner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> ownerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'owner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> ownerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'owner',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> ownerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'owner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> ownerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'owner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> ownerContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'owner',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> ownerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'owner',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> ownerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'owner',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      ownerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'owner',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'picture',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pictureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'picture',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> pictureEqualTo(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> pictureLessThan(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> pictureBetween(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> pictureEndsWith(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> pictureContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'picture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> pictureMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'picture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'picture',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> pinnedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pinned',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pinned',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pinned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pinned',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pinned',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pinned',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pinned',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      pinnedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pinned',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> relayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relay',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      relayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relay',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> relayEqualTo(
    String? value, {
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      relayGreaterThan(
    String? value, {
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> relayLessThan(
    String? value, {
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> relayBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> relayStartsWith(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> relayEndsWith(
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> relayContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> relayMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relay',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition> relayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relay',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      relayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relay',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      updateTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'welcomeEventString',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'welcomeEventString',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'welcomeEventString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'welcomeEventString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'welcomeEventString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'welcomeEventString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'welcomeEventString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'welcomeEventString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'welcomeEventString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'welcomeEventString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'welcomeEventString',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeEventStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'welcomeEventString',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'welcomeWrapperEventId',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'welcomeWrapperEventId',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'welcomeWrapperEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'welcomeWrapperEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'welcomeWrapperEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'welcomeWrapperEventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'welcomeWrapperEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'welcomeWrapperEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'welcomeWrapperEventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'welcomeWrapperEventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'welcomeWrapperEventId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterFilterCondition>
      welcomeWrapperEventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'welcomeWrapperEventId',
        value: '',
      ));
    });
  }
}

extension GroupDBISARQueryObject
    on QueryBuilder<GroupDBISAR, GroupDBISAR, QFilterCondition> {}

extension GroupDBISARQueryLinks
    on QueryBuilder<GroupDBISAR, GroupDBISAR, QFilterCondition> {}

extension GroupDBISARQuerySortBy
    on QueryBuilder<GroupDBISAR, GroupDBISAR, QSortBy> {
  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByAbout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByAboutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByEpoch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epoch', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByEpochDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epoch', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByIsDirectMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDirectMessage', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy>
      sortByIsDirectMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDirectMessage', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByIsMLSGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMLSGroup', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByIsMLSGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMLSGroup', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByMuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByOwner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'owner', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByOwnerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'owner', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> sortByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy>
      sortByWelcomeEventString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'welcomeEventString', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy>
      sortByWelcomeEventStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'welcomeEventString', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy>
      sortByWelcomeWrapperEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'welcomeWrapperEventId', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy>
      sortByWelcomeWrapperEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'welcomeWrapperEventId', Sort.desc);
    });
  }
}

extension GroupDBISARQuerySortThenBy
    on QueryBuilder<GroupDBISAR, GroupDBISAR, QSortThenBy> {
  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByAbout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByAboutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'about', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByEpoch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epoch', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByEpochDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epoch', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByIsDirectMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDirectMessage', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy>
      thenByIsDirectMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDirectMessage', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByIsMLSGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMLSGroup', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByIsMLSGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMLSGroup', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByMuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mute', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByOwner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'owner', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByOwnerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'owner', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByPicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByPictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'picture', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relay', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy> thenByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy>
      thenByWelcomeEventString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'welcomeEventString', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy>
      thenByWelcomeEventStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'welcomeEventString', Sort.desc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy>
      thenByWelcomeWrapperEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'welcomeWrapperEventId', Sort.asc);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QAfterSortBy>
      thenByWelcomeWrapperEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'welcomeWrapperEventId', Sort.desc);
    });
  }
}

extension GroupDBISARQueryWhereDistinct
    on QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> {
  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByAbout(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'about', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByAdminPubkeys() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adminPubkeys');
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByEpoch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'epoch');
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByGroupId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct>
      distinctByIsDirectMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDirectMessage');
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByIsMLSGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMLSGroup');
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByMembers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'members');
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByMlsGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mlsGroupId');
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByMute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mute');
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByOwner(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'owner', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByPicture(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'picture', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pinned');
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByRelay(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relay', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct> distinctByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updateTime');
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct>
      distinctByWelcomeEventString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'welcomeEventString',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupDBISAR, GroupDBISAR, QDistinct>
      distinctByWelcomeWrapperEventId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'welcomeWrapperEventId',
          caseSensitive: caseSensitive);
    });
  }
}

extension GroupDBISARQueryProperty
    on QueryBuilder<GroupDBISAR, GroupDBISAR, QQueryProperty> {
  QueryBuilder<GroupDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GroupDBISAR, String?, QQueryOperations> aboutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'about');
    });
  }

  QueryBuilder<GroupDBISAR, List<String>?, QQueryOperations>
      adminPubkeysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adminPubkeys');
    });
  }

  QueryBuilder<GroupDBISAR, int, QQueryOperations> epochProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'epoch');
    });
  }

  QueryBuilder<GroupDBISAR, String, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<GroupDBISAR, bool, QQueryOperations> isDirectMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDirectMessage');
    });
  }

  QueryBuilder<GroupDBISAR, bool, QQueryOperations> isMLSGroupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMLSGroup');
    });
  }

  QueryBuilder<GroupDBISAR, List<String>?, QQueryOperations> membersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'members');
    });
  }

  QueryBuilder<GroupDBISAR, List<int>?, QQueryOperations> mlsGroupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mlsGroupId');
    });
  }

  QueryBuilder<GroupDBISAR, bool, QQueryOperations> muteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mute');
    });
  }

  QueryBuilder<GroupDBISAR, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<GroupDBISAR, String, QQueryOperations> ownerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'owner');
    });
  }

  QueryBuilder<GroupDBISAR, String?, QQueryOperations> pictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'picture');
    });
  }

  QueryBuilder<GroupDBISAR, List<String>?, QQueryOperations> pinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pinned');
    });
  }

  QueryBuilder<GroupDBISAR, String?, QQueryOperations> relayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relay');
    });
  }

  QueryBuilder<GroupDBISAR, int, QQueryOperations> updateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updateTime');
    });
  }

  QueryBuilder<GroupDBISAR, String?, QQueryOperations>
      welcomeEventStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'welcomeEventString');
    });
  }

  QueryBuilder<GroupDBISAR, String?, QQueryOperations>
      welcomeWrapperEventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'welcomeWrapperEventId');
    });
  }
}
