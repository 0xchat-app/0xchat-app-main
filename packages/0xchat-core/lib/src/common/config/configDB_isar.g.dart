// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetConfigDBISARCollection on Isar {
  IsarCollection<ConfigDBISAR> get configDBISARs => this.collection();
}

const ConfigDBISARSchema = CollectionSchema(
  name: r'ConfigDBISAR',
  id: -953908829851357647,
  properties: {
    r'configJson': PropertySchema(
      id: 0,
      name: r'configJson',
      type: IsarType.string,
    ),
    r'd': PropertySchema(
      id: 1,
      name: r'd',
      type: IsarType.string,
    ),
    r'eventId': PropertySchema(
      id: 2,
      name: r'eventId',
      type: IsarType.string,
    ),
    r'proxyJson': PropertySchema(
      id: 3,
      name: r'proxyJson',
      type: IsarType.string,
    ),
    r'time': PropertySchema(
      id: 4,
      name: r'time',
      type: IsarType.long,
    )
  },
  estimateSize: _configDBISAREstimateSize,
  serialize: _configDBISARSerialize,
  deserialize: _configDBISARDeserialize,
  deserializeProp: _configDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'd': IndexSchema(
      id: 5041782483466037194,
      name: r'd',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'd',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _configDBISARGetId,
  getLinks: _configDBISARGetLinks,
  attach: _configDBISARAttach,
  version: '3.1.0+1',
);

int _configDBISAREstimateSize(
  ConfigDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.configJson.length * 3;
  bytesCount += 3 + object.d.length * 3;
  bytesCount += 3 + object.eventId.length * 3;
  bytesCount += 3 + object.proxyJson.length * 3;
  return bytesCount;
}

void _configDBISARSerialize(
  ConfigDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.configJson);
  writer.writeString(offsets[1], object.d);
  writer.writeString(offsets[2], object.eventId);
  writer.writeString(offsets[3], object.proxyJson);
  writer.writeLong(offsets[4], object.time);
}

ConfigDBISAR _configDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ConfigDBISAR(
    configJson: reader.readStringOrNull(offsets[0]) ?? '',
    d: reader.readStringOrNull(offsets[1]) ?? '',
    eventId: reader.readStringOrNull(offsets[2]) ?? '',
    proxyJson: reader.readStringOrNull(offsets[3]) ?? '',
    time: reader.readLongOrNull(offsets[4]) ?? 0,
  );
  object.id = id;
  return object;
}

P _configDBISARDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _configDBISARGetId(ConfigDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _configDBISARGetLinks(ConfigDBISAR object) {
  return [];
}

void _configDBISARAttach(
    IsarCollection<dynamic> col, Id id, ConfigDBISAR object) {
  object.id = id;
}

extension ConfigDBISARByIndex on IsarCollection<ConfigDBISAR> {
  Future<ConfigDBISAR?> getByD(String d) {
    return getByIndex(r'd', [d]);
  }

  ConfigDBISAR? getByDSync(String d) {
    return getByIndexSync(r'd', [d]);
  }

  Future<bool> deleteByD(String d) {
    return deleteByIndex(r'd', [d]);
  }

  bool deleteByDSync(String d) {
    return deleteByIndexSync(r'd', [d]);
  }

  Future<List<ConfigDBISAR?>> getAllByD(List<String> dValues) {
    final values = dValues.map((e) => [e]).toList();
    return getAllByIndex(r'd', values);
  }

  List<ConfigDBISAR?> getAllByDSync(List<String> dValues) {
    final values = dValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'd', values);
  }

  Future<int> deleteAllByD(List<String> dValues) {
    final values = dValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'd', values);
  }

  int deleteAllByDSync(List<String> dValues) {
    final values = dValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'd', values);
  }

  Future<Id> putByD(ConfigDBISAR object) {
    return putByIndex(r'd', object);
  }

  Id putByDSync(ConfigDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'd', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByD(List<ConfigDBISAR> objects) {
    return putAllByIndex(r'd', objects);
  }

  List<Id> putAllByDSync(List<ConfigDBISAR> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'd', objects, saveLinks: saveLinks);
  }
}

extension ConfigDBISARQueryWhereSort
    on QueryBuilder<ConfigDBISAR, ConfigDBISAR, QWhere> {
  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ConfigDBISARQueryWhere
    on QueryBuilder<ConfigDBISAR, ConfigDBISAR, QWhereClause> {
  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterWhereClause> dEqualTo(
      String d) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'd',
        value: [d],
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterWhereClause> dNotEqualTo(
      String d) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'd',
              lower: [],
              upper: [d],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'd',
              lower: [d],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'd',
              lower: [d],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'd',
              lower: [],
              upper: [d],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ConfigDBISARQueryFilter
    on QueryBuilder<ConfigDBISAR, ConfigDBISAR, QFilterCondition> {
  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      configJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      configJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      configJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      configJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'configJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      configJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      configJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      configJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'configJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      configJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'configJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      configJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      configJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'configJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> dEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> dGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> dLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> dBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> dStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> dEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> dContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> dMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> dIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'd',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      dIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'd',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
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

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      eventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      eventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      eventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      eventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      proxyJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proxyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      proxyJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proxyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      proxyJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proxyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      proxyJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proxyJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      proxyJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'proxyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      proxyJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'proxyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      proxyJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'proxyJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      proxyJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'proxyJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      proxyJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proxyJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      proxyJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'proxyJson',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> timeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition>
      timeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> timeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterFilterCondition> timeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'time',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ConfigDBISARQueryObject
    on QueryBuilder<ConfigDBISAR, ConfigDBISAR, QFilterCondition> {}

extension ConfigDBISARQueryLinks
    on QueryBuilder<ConfigDBISAR, ConfigDBISAR, QFilterCondition> {}

extension ConfigDBISARQuerySortBy
    on QueryBuilder<ConfigDBISAR, ConfigDBISAR, QSortBy> {
  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> sortByConfigJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configJson', Sort.asc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy>
      sortByConfigJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configJson', Sort.desc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> sortByD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'd', Sort.asc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> sortByDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'd', Sort.desc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> sortByProxyJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proxyJson', Sort.asc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> sortByProxyJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proxyJson', Sort.desc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> sortByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> sortByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension ConfigDBISARQuerySortThenBy
    on QueryBuilder<ConfigDBISAR, ConfigDBISAR, QSortThenBy> {
  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> thenByConfigJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configJson', Sort.asc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy>
      thenByConfigJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configJson', Sort.desc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> thenByD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'd', Sort.asc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> thenByDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'd', Sort.desc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> thenByProxyJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proxyJson', Sort.asc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> thenByProxyJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proxyJson', Sort.desc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> thenByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QAfterSortBy> thenByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension ConfigDBISARQueryWhereDistinct
    on QueryBuilder<ConfigDBISAR, ConfigDBISAR, QDistinct> {
  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QDistinct> distinctByConfigJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'configJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QDistinct> distinctByD(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QDistinct> distinctByEventId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QDistinct> distinctByProxyJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proxyJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ConfigDBISAR, ConfigDBISAR, QDistinct> distinctByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'time');
    });
  }
}

extension ConfigDBISARQueryProperty
    on QueryBuilder<ConfigDBISAR, ConfigDBISAR, QQueryProperty> {
  QueryBuilder<ConfigDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ConfigDBISAR, String, QQueryOperations> configJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'configJson');
    });
  }

  QueryBuilder<ConfigDBISAR, String, QQueryOperations> dProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'd');
    });
  }

  QueryBuilder<ConfigDBISAR, String, QQueryOperations> eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<ConfigDBISAR, String, QQueryOperations> proxyJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proxyJson');
    });
  }

  QueryBuilder<ConfigDBISAR, int, QQueryOperations> timeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'time');
    });
  }
}
