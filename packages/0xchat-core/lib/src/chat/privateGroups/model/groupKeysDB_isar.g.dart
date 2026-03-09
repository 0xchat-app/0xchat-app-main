// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupKeysDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGroupKeysDBISARCollection on Isar {
  IsarCollection<GroupKeysDBISAR> get groupKeysDBISARs => this.collection();
}

const GroupKeysDBISARSchema = CollectionSchema(
  name: r'GroupKeysDBISAR',
  id: 1463699585208843633,
  properties: {
    r'epoch': PropertySchema(
      id: 0,
      name: r'epoch',
      type: IsarType.long,
    ),
    r'groupId': PropertySchema(
      id: 1,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'mlsGroupId': PropertySchema(
      id: 2,
      name: r'mlsGroupId',
      type: IsarType.longList,
    ),
    r'secretKey': PropertySchema(
      id: 3,
      name: r'secretKey',
      type: IsarType.string,
    )
  },
  estimateSize: _groupKeysDBISAREstimateSize,
  serialize: _groupKeysDBISARSerialize,
  deserialize: _groupKeysDBISARDeserialize,
  deserializeProp: _groupKeysDBISARDeserializeProp,
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
  getId: _groupKeysDBISARGetId,
  getLinks: _groupKeysDBISARGetLinks,
  attach: _groupKeysDBISARAttach,
  version: '3.1.0+1',
);

int _groupKeysDBISAREstimateSize(
  GroupKeysDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.groupId.length * 3;
  {
    final value = object.mlsGroupId;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  bytesCount += 3 + object.secretKey.length * 3;
  return bytesCount;
}

void _groupKeysDBISARSerialize(
  GroupKeysDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.epoch);
  writer.writeString(offsets[1], object.groupId);
  writer.writeLongList(offsets[2], object.mlsGroupId);
  writer.writeString(offsets[3], object.secretKey);
}

GroupKeysDBISAR _groupKeysDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GroupKeysDBISAR(
    epoch: reader.readLongOrNull(offsets[0]) ?? 0,
    groupId: reader.readStringOrNull(offsets[1]) ?? '',
    mlsGroupId: reader.readLongList(offsets[2]),
    secretKey: reader.readStringOrNull(offsets[3]) ?? '',
  );
  object.id = id;
  return object;
}

P _groupKeysDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readLongList(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _groupKeysDBISARGetId(GroupKeysDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _groupKeysDBISARGetLinks(GroupKeysDBISAR object) {
  return [];
}

void _groupKeysDBISARAttach(
    IsarCollection<dynamic> col, Id id, GroupKeysDBISAR object) {
  object.id = id;
}

extension GroupKeysDBISARByIndex on IsarCollection<GroupKeysDBISAR> {
  Future<GroupKeysDBISAR?> getByGroupId(String groupId) {
    return getByIndex(r'groupId', [groupId]);
  }

  GroupKeysDBISAR? getByGroupIdSync(String groupId) {
    return getByIndexSync(r'groupId', [groupId]);
  }

  Future<bool> deleteByGroupId(String groupId) {
    return deleteByIndex(r'groupId', [groupId]);
  }

  bool deleteByGroupIdSync(String groupId) {
    return deleteByIndexSync(r'groupId', [groupId]);
  }

  Future<List<GroupKeysDBISAR?>> getAllByGroupId(List<String> groupIdValues) {
    final values = groupIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'groupId', values);
  }

  List<GroupKeysDBISAR?> getAllByGroupIdSync(List<String> groupIdValues) {
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

  Future<Id> putByGroupId(GroupKeysDBISAR object) {
    return putByIndex(r'groupId', object);
  }

  Id putByGroupIdSync(GroupKeysDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'groupId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByGroupId(List<GroupKeysDBISAR> objects) {
    return putAllByIndex(r'groupId', objects);
  }

  List<Id> putAllByGroupIdSync(List<GroupKeysDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'groupId', objects, saveLinks: saveLinks);
  }
}

extension GroupKeysDBISARQueryWhereSort
    on QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QWhere> {
  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GroupKeysDBISARQueryWhere
    on QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QWhereClause> {
  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterWhereClause>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterWhereClause>
      groupIdEqualTo(String groupId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupId',
        value: [groupId],
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterWhereClause>
      groupIdNotEqualTo(String groupId) {
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

extension GroupKeysDBISARQueryFilter
    on QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QFilterCondition> {
  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      epochEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'epoch',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      epochLessThan(
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      epochBetween(
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      groupIdEqualTo(
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      groupIdLessThan(
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      groupIdBetween(
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      groupIdEndsWith(
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      mlsGroupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mlsGroupId',
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      mlsGroupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mlsGroupId',
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      mlsGroupIdElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mlsGroupId',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
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

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      secretKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      secretKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'secretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      secretKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'secretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      secretKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'secretKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      secretKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'secretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      secretKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'secretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      secretKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'secretKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      secretKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'secretKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      secretKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secretKey',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterFilterCondition>
      secretKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'secretKey',
        value: '',
      ));
    });
  }
}

extension GroupKeysDBISARQueryObject
    on QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QFilterCondition> {}

extension GroupKeysDBISARQueryLinks
    on QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QFilterCondition> {}

extension GroupKeysDBISARQuerySortBy
    on QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QSortBy> {
  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy> sortByEpoch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epoch', Sort.asc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy>
      sortByEpochDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epoch', Sort.desc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy>
      sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy>
      sortBySecretKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secretKey', Sort.asc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy>
      sortBySecretKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secretKey', Sort.desc);
    });
  }
}

extension GroupKeysDBISARQuerySortThenBy
    on QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QSortThenBy> {
  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy> thenByEpoch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epoch', Sort.asc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy>
      thenByEpochDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epoch', Sort.desc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy>
      thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy>
      thenBySecretKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secretKey', Sort.asc);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QAfterSortBy>
      thenBySecretKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secretKey', Sort.desc);
    });
  }
}

extension GroupKeysDBISARQueryWhereDistinct
    on QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QDistinct> {
  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QDistinct> distinctByEpoch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'epoch');
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QDistinct> distinctByGroupId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QDistinct>
      distinctByMlsGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mlsGroupId');
    });
  }

  QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QDistinct> distinctBySecretKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secretKey', caseSensitive: caseSensitive);
    });
  }
}

extension GroupKeysDBISARQueryProperty
    on QueryBuilder<GroupKeysDBISAR, GroupKeysDBISAR, QQueryProperty> {
  QueryBuilder<GroupKeysDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GroupKeysDBISAR, int, QQueryOperations> epochProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'epoch');
    });
  }

  QueryBuilder<GroupKeysDBISAR, String, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<GroupKeysDBISAR, List<int>?, QQueryOperations>
      mlsGroupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mlsGroupId');
    });
  }

  QueryBuilder<GroupKeysDBISAR, String, QQueryOperations> secretKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secretKey');
    });
  }
}
