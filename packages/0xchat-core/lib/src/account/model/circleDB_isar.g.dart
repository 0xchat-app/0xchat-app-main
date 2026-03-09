// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circleDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCircleDBISARCollection on Isar {
  IsarCollection<CircleDBISAR> get circleDBISARs => this.collection();
}

const CircleDBISARSchema = CollectionSchema(
  name: r'CircleDBISAR',
  id: -8541097715062409889,
  properties: {
    r'circleId': PropertySchema(
      id: 0,
      name: r'circleId',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'fileserverList': PropertySchema(
      id: 2,
      name: r'fileserverList',
      type: IsarType.stringList,
    ),
    r'groupId': PropertySchema(
      id: 3,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'iceserverList': PropertySchema(
      id: 4,
      name: r'iceserverList',
      type: IsarType.stringList,
    ),
    r'image': PropertySchema(
      id: 5,
      name: r'image',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 6,
      name: r'name',
      type: IsarType.string,
    ),
    r'pushserverList': PropertySchema(
      id: 7,
      name: r'pushserverList',
      type: IsarType.stringList,
    ),
    r'relayList': PropertySchema(
      id: 8,
      name: r'relayList',
      type: IsarType.stringList,
    )
  },
  estimateSize: _circleDBISAREstimateSize,
  serialize: _circleDBISARSerialize,
  deserialize: _circleDBISARDeserialize,
  deserializeProp: _circleDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'circleId': IndexSchema(
      id: 2024179452621641335,
      name: r'circleId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'circleId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _circleDBISARGetId,
  getLinks: _circleDBISARGetLinks,
  attach: _circleDBISARAttach,
  version: '3.1.0+1',
);

int _circleDBISAREstimateSize(
  CircleDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.circleId.length * 3;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.fileserverList.length * 3;
  {
    for (var i = 0; i < object.fileserverList.length; i++) {
      final value = object.fileserverList[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.groupId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.iceserverList.length * 3;
  {
    for (var i = 0; i < object.iceserverList.length; i++) {
      final value = object.iceserverList[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.image.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.pushserverList.length * 3;
  {
    for (var i = 0; i < object.pushserverList.length; i++) {
      final value = object.pushserverList[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.relayList.length * 3;
  {
    for (var i = 0; i < object.relayList.length; i++) {
      final value = object.relayList[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _circleDBISARSerialize(
  CircleDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.circleId);
  writer.writeString(offsets[1], object.description);
  writer.writeStringList(offsets[2], object.fileserverList);
  writer.writeString(offsets[3], object.groupId);
  writer.writeStringList(offsets[4], object.iceserverList);
  writer.writeString(offsets[5], object.image);
  writer.writeString(offsets[6], object.name);
  writer.writeStringList(offsets[7], object.pushserverList);
  writer.writeStringList(offsets[8], object.relayList);
}

CircleDBISAR _circleDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CircleDBISAR(
    circleId: reader.readString(offsets[0]),
    description: reader.readStringOrNull(offsets[1]) ?? '',
    fileserverList: reader.readStringList(offsets[2]) ?? const [],
    groupId: reader.readStringOrNull(offsets[3]),
    iceserverList: reader.readStringList(offsets[4]) ?? const [],
    image: reader.readStringOrNull(offsets[5]) ?? '',
    name: reader.readStringOrNull(offsets[6]) ?? '',
    pushserverList: reader.readStringList(offsets[7]) ?? const [],
    relayList: reader.readStringList(offsets[8]) ?? const [],
  );
  object.id = id;
  return object;
}

P _circleDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readStringList(offset) ?? const []) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? const []) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 7:
      return (reader.readStringList(offset) ?? const []) as P;
    case 8:
      return (reader.readStringList(offset) ?? const []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _circleDBISARGetId(CircleDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _circleDBISARGetLinks(CircleDBISAR object) {
  return [];
}

void _circleDBISARAttach(
    IsarCollection<dynamic> col, Id id, CircleDBISAR object) {
  object.id = id;
}

extension CircleDBISARByIndex on IsarCollection<CircleDBISAR> {
  Future<CircleDBISAR?> getByCircleId(String circleId) {
    return getByIndex(r'circleId', [circleId]);
  }

  CircleDBISAR? getByCircleIdSync(String circleId) {
    return getByIndexSync(r'circleId', [circleId]);
  }

  Future<bool> deleteByCircleId(String circleId) {
    return deleteByIndex(r'circleId', [circleId]);
  }

  bool deleteByCircleIdSync(String circleId) {
    return deleteByIndexSync(r'circleId', [circleId]);
  }

  Future<List<CircleDBISAR?>> getAllByCircleId(List<String> circleIdValues) {
    final values = circleIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'circleId', values);
  }

  List<CircleDBISAR?> getAllByCircleIdSync(List<String> circleIdValues) {
    final values = circleIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'circleId', values);
  }

  Future<int> deleteAllByCircleId(List<String> circleIdValues) {
    final values = circleIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'circleId', values);
  }

  int deleteAllByCircleIdSync(List<String> circleIdValues) {
    final values = circleIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'circleId', values);
  }

  Future<Id> putByCircleId(CircleDBISAR object) {
    return putByIndex(r'circleId', object);
  }

  Id putByCircleIdSync(CircleDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'circleId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCircleId(List<CircleDBISAR> objects) {
    return putAllByIndex(r'circleId', objects);
  }

  List<Id> putAllByCircleIdSync(List<CircleDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'circleId', objects, saveLinks: saveLinks);
  }
}

extension CircleDBISARQueryWhereSort
    on QueryBuilder<CircleDBISAR, CircleDBISAR, QWhere> {
  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CircleDBISARQueryWhere
    on QueryBuilder<CircleDBISAR, CircleDBISAR, QWhereClause> {
  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterWhereClause> circleIdEqualTo(
      String circleId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'circleId',
        value: [circleId],
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterWhereClause>
      circleIdNotEqualTo(String circleId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'circleId',
              lower: [],
              upper: [circleId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'circleId',
              lower: [circleId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'circleId',
              lower: [circleId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'circleId',
              lower: [],
              upper: [circleId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CircleDBISARQueryFilter
    on QueryBuilder<CircleDBISAR, CircleDBISAR, QFilterCondition> {
  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      circleIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'circleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      circleIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'circleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      circleIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'circleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      circleIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'circleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      circleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'circleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      circleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'circleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      circleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'circleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      circleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'circleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      circleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'circleId',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      circleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'circleId',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileserverList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fileserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fileserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fileserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fileserverList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileserverList',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fileserverList',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fileserverList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fileserverList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fileserverList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fileserverList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fileserverList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      fileserverListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fileserverList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      groupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      groupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      groupIdEqualTo(
    String? value, {
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      groupIdGreaterThan(
    String? value, {
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      groupIdLessThan(
    String? value, {
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      groupIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iceserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iceserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iceserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iceserverList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'iceserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'iceserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'iceserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'iceserverList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iceserverList',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iceserverList',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'iceserverList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'iceserverList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'iceserverList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'iceserverList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'iceserverList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      iceserverListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'iceserverList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> imageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      imageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> imageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> imageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'image',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      imageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> imageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> imageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> imageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'image',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      imageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'image',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      imageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'image',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> nameContains(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pushserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pushserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pushserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pushserverList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pushserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pushserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pushserverList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pushserverList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pushserverList',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pushserverList',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pushserverList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pushserverList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pushserverList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pushserverList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pushserverList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      pushserverListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pushserverList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relayList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relayList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayList',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relayList',
        value: '',
      ));
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterFilterCondition>
      relayListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'relayList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension CircleDBISARQueryObject
    on QueryBuilder<CircleDBISAR, CircleDBISAR, QFilterCondition> {}

extension CircleDBISARQueryLinks
    on QueryBuilder<CircleDBISAR, CircleDBISAR, QFilterCondition> {}

extension CircleDBISARQuerySortBy
    on QueryBuilder<CircleDBISAR, CircleDBISAR, QSortBy> {
  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> sortByCircleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'circleId', Sort.asc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> sortByCircleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'circleId', Sort.desc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> sortByImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image', Sort.asc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> sortByImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image', Sort.desc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CircleDBISARQuerySortThenBy
    on QueryBuilder<CircleDBISAR, CircleDBISAR, QSortThenBy> {
  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> thenByCircleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'circleId', Sort.asc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> thenByCircleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'circleId', Sort.desc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> thenByImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image', Sort.asc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> thenByImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'image', Sort.desc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CircleDBISARQueryWhereDistinct
    on QueryBuilder<CircleDBISAR, CircleDBISAR, QDistinct> {
  QueryBuilder<CircleDBISAR, CircleDBISAR, QDistinct> distinctByCircleId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'circleId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QDistinct>
      distinctByFileserverList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileserverList');
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QDistinct> distinctByGroupId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QDistinct>
      distinctByIceserverList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iceserverList');
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QDistinct> distinctByImage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'image', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QDistinct>
      distinctByPushserverList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pushserverList');
    });
  }

  QueryBuilder<CircleDBISAR, CircleDBISAR, QDistinct> distinctByRelayList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relayList');
    });
  }
}

extension CircleDBISARQueryProperty
    on QueryBuilder<CircleDBISAR, CircleDBISAR, QQueryProperty> {
  QueryBuilder<CircleDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CircleDBISAR, String, QQueryOperations> circleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'circleId');
    });
  }

  QueryBuilder<CircleDBISAR, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<CircleDBISAR, List<String>, QQueryOperations>
      fileserverListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileserverList');
    });
  }

  QueryBuilder<CircleDBISAR, String?, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<CircleDBISAR, List<String>, QQueryOperations>
      iceserverListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iceserverList');
    });
  }

  QueryBuilder<CircleDBISAR, String, QQueryOperations> imageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'image');
    });
  }

  QueryBuilder<CircleDBISAR, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CircleDBISAR, List<String>, QQueryOperations>
      pushserverListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pushserverList');
    });
  }

  QueryBuilder<CircleDBISAR, List<String>, QQueryOperations>
      relayListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relayList');
    });
  }
}
