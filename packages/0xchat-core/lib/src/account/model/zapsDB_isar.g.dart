// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zapsDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetZapsDBISARCollection on Isar {
  IsarCollection<ZapsDBISAR> get zapsDBISARs => this.collection();
}

const ZapsDBISARSchema = CollectionSchema(
  name: r'ZapsDBISAR',
  id: 8837430702788227006,
  properties: {
    r'allowsNostr': PropertySchema(
      id: 0,
      name: r'allowsNostr',
      type: IsarType.bool,
    ),
    r'callback': PropertySchema(
      id: 1,
      name: r'callback',
      type: IsarType.string,
    ),
    r'lnAddr': PropertySchema(
      id: 2,
      name: r'lnAddr',
      type: IsarType.string,
    ),
    r'lnURL': PropertySchema(
      id: 3,
      name: r'lnURL',
      type: IsarType.string,
    ),
    r'maxSendable': PropertySchema(
      id: 4,
      name: r'maxSendable',
      type: IsarType.long,
    ),
    r'minSendable': PropertySchema(
      id: 5,
      name: r'minSendable',
      type: IsarType.long,
    ),
    r'nostrPubkey': PropertySchema(
      id: 6,
      name: r'nostrPubkey',
      type: IsarType.string,
    )
  },
  estimateSize: _zapsDBISAREstimateSize,
  serialize: _zapsDBISARSerialize,
  deserialize: _zapsDBISARDeserialize,
  deserializeProp: _zapsDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'lnAddr': IndexSchema(
      id: 4087569467243931013,
      name: r'lnAddr',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'lnAddr',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'lnURL': IndexSchema(
      id: 6327441410752717209,
      name: r'lnURL',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'lnURL',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _zapsDBISARGetId,
  getLinks: _zapsDBISARGetLinks,
  attach: _zapsDBISARAttach,
  version: '3.1.0+1',
);

int _zapsDBISAREstimateSize(
  ZapsDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.callback.length * 3;
  bytesCount += 3 + object.lnAddr.length * 3;
  bytesCount += 3 + object.lnURL.length * 3;
  bytesCount += 3 + object.nostrPubkey.length * 3;
  return bytesCount;
}

void _zapsDBISARSerialize(
  ZapsDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.allowsNostr);
  writer.writeString(offsets[1], object.callback);
  writer.writeString(offsets[2], object.lnAddr);
  writer.writeString(offsets[3], object.lnURL);
  writer.writeLong(offsets[4], object.maxSendable);
  writer.writeLong(offsets[5], object.minSendable);
  writer.writeString(offsets[6], object.nostrPubkey);
}

ZapsDBISAR _zapsDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ZapsDBISAR(
    allowsNostr: reader.readBoolOrNull(offsets[0]) ?? false,
    callback: reader.readStringOrNull(offsets[1]) ?? '',
    lnAddr: reader.readStringOrNull(offsets[2]) ?? '',
    lnURL: reader.readStringOrNull(offsets[3]) ?? '',
    maxSendable: reader.readLongOrNull(offsets[4]) ?? 0,
    minSendable: reader.readLongOrNull(offsets[5]) ?? 0,
    nostrPubkey: reader.readStringOrNull(offsets[6]) ?? '',
  );
  object.id = id;
  return object;
}

P _zapsDBISARDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _zapsDBISARGetId(ZapsDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _zapsDBISARGetLinks(ZapsDBISAR object) {
  return [];
}

void _zapsDBISARAttach(IsarCollection<dynamic> col, Id id, ZapsDBISAR object) {
  object.id = id;
}

extension ZapsDBISARByIndex on IsarCollection<ZapsDBISAR> {
  Future<ZapsDBISAR?> getByLnAddr(String lnAddr) {
    return getByIndex(r'lnAddr', [lnAddr]);
  }

  ZapsDBISAR? getByLnAddrSync(String lnAddr) {
    return getByIndexSync(r'lnAddr', [lnAddr]);
  }

  Future<bool> deleteByLnAddr(String lnAddr) {
    return deleteByIndex(r'lnAddr', [lnAddr]);
  }

  bool deleteByLnAddrSync(String lnAddr) {
    return deleteByIndexSync(r'lnAddr', [lnAddr]);
  }

  Future<List<ZapsDBISAR?>> getAllByLnAddr(List<String> lnAddrValues) {
    final values = lnAddrValues.map((e) => [e]).toList();
    return getAllByIndex(r'lnAddr', values);
  }

  List<ZapsDBISAR?> getAllByLnAddrSync(List<String> lnAddrValues) {
    final values = lnAddrValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'lnAddr', values);
  }

  Future<int> deleteAllByLnAddr(List<String> lnAddrValues) {
    final values = lnAddrValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'lnAddr', values);
  }

  int deleteAllByLnAddrSync(List<String> lnAddrValues) {
    final values = lnAddrValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'lnAddr', values);
  }

  Future<Id> putByLnAddr(ZapsDBISAR object) {
    return putByIndex(r'lnAddr', object);
  }

  Id putByLnAddrSync(ZapsDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'lnAddr', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLnAddr(List<ZapsDBISAR> objects) {
    return putAllByIndex(r'lnAddr', objects);
  }

  List<Id> putAllByLnAddrSync(List<ZapsDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'lnAddr', objects, saveLinks: saveLinks);
  }

  Future<ZapsDBISAR?> getByLnURL(String lnURL) {
    return getByIndex(r'lnURL', [lnURL]);
  }

  ZapsDBISAR? getByLnURLSync(String lnURL) {
    return getByIndexSync(r'lnURL', [lnURL]);
  }

  Future<bool> deleteByLnURL(String lnURL) {
    return deleteByIndex(r'lnURL', [lnURL]);
  }

  bool deleteByLnURLSync(String lnURL) {
    return deleteByIndexSync(r'lnURL', [lnURL]);
  }

  Future<List<ZapsDBISAR?>> getAllByLnURL(List<String> lnURLValues) {
    final values = lnURLValues.map((e) => [e]).toList();
    return getAllByIndex(r'lnURL', values);
  }

  List<ZapsDBISAR?> getAllByLnURLSync(List<String> lnURLValues) {
    final values = lnURLValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'lnURL', values);
  }

  Future<int> deleteAllByLnURL(List<String> lnURLValues) {
    final values = lnURLValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'lnURL', values);
  }

  int deleteAllByLnURLSync(List<String> lnURLValues) {
    final values = lnURLValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'lnURL', values);
  }

  Future<Id> putByLnURL(ZapsDBISAR object) {
    return putByIndex(r'lnURL', object);
  }

  Id putByLnURLSync(ZapsDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'lnURL', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLnURL(List<ZapsDBISAR> objects) {
    return putAllByIndex(r'lnURL', objects);
  }

  List<Id> putAllByLnURLSync(List<ZapsDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'lnURL', objects, saveLinks: saveLinks);
  }
}

extension ZapsDBISARQueryWhereSort
    on QueryBuilder<ZapsDBISAR, ZapsDBISAR, QWhere> {
  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ZapsDBISARQueryWhere
    on QueryBuilder<ZapsDBISAR, ZapsDBISAR, QWhereClause> {
  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterWhereClause> lnAddrEqualTo(
      String lnAddr) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lnAddr',
        value: [lnAddr],
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterWhereClause> lnAddrNotEqualTo(
      String lnAddr) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lnAddr',
              lower: [],
              upper: [lnAddr],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lnAddr',
              lower: [lnAddr],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lnAddr',
              lower: [lnAddr],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lnAddr',
              lower: [],
              upper: [lnAddr],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterWhereClause> lnURLEqualTo(
      String lnURL) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lnURL',
        value: [lnURL],
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterWhereClause> lnURLNotEqualTo(
      String lnURL) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lnURL',
              lower: [],
              upper: [lnURL],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lnURL',
              lower: [lnURL],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lnURL',
              lower: [lnURL],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lnURL',
              lower: [],
              upper: [lnURL],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ZapsDBISARQueryFilter
    on QueryBuilder<ZapsDBISAR, ZapsDBISAR, QFilterCondition> {
  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      allowsNostrEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allowsNostr',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> callbackEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'callback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      callbackGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'callback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> callbackLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'callback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> callbackBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'callback',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      callbackStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'callback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> callbackEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'callback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> callbackContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'callback',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> callbackMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'callback',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      callbackIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'callback',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      callbackIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'callback',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnAddrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnAddrGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lnAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnAddrLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lnAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnAddrBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lnAddr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnAddrStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lnAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnAddrEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lnAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnAddrContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lnAddr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnAddrMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lnAddr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnAddrIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnAddr',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      lnAddrIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lnAddr',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnURLEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnURLGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lnURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnURLLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lnURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnURLBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lnURL',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnURLStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lnURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnURLEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lnURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnURLContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lnURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnURLMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lnURL',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition> lnURLIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lnURL',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      lnURLIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lnURL',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      maxSendableEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxSendable',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      maxSendableGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxSendable',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      maxSendableLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxSendable',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      maxSendableBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxSendable',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      minSendableEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minSendable',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      minSendableGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minSendable',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      minSendableLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minSendable',
        value: value,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      minSendableBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minSendable',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      nostrPubkeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nostrPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      nostrPubkeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nostrPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      nostrPubkeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nostrPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      nostrPubkeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nostrPubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      nostrPubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nostrPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      nostrPubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nostrPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      nostrPubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nostrPubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      nostrPubkeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nostrPubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      nostrPubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nostrPubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterFilterCondition>
      nostrPubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nostrPubkey',
        value: '',
      ));
    });
  }
}

extension ZapsDBISARQueryObject
    on QueryBuilder<ZapsDBISAR, ZapsDBISAR, QFilterCondition> {}

extension ZapsDBISARQueryLinks
    on QueryBuilder<ZapsDBISAR, ZapsDBISAR, QFilterCondition> {}

extension ZapsDBISARQuerySortBy
    on QueryBuilder<ZapsDBISAR, ZapsDBISAR, QSortBy> {
  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByAllowsNostr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowsNostr', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByAllowsNostrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowsNostr', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByCallback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'callback', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByCallbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'callback', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByLnAddr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnAddr', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByLnAddrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnAddr', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByLnURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnURL', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByLnURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnURL', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByMaxSendable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSendable', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByMaxSendableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSendable', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByMinSendable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minSendable', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByMinSendableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minSendable', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByNostrPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nostrPubkey', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> sortByNostrPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nostrPubkey', Sort.desc);
    });
  }
}

extension ZapsDBISARQuerySortThenBy
    on QueryBuilder<ZapsDBISAR, ZapsDBISAR, QSortThenBy> {
  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByAllowsNostr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowsNostr', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByAllowsNostrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowsNostr', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByCallback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'callback', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByCallbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'callback', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByLnAddr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnAddr', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByLnAddrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnAddr', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByLnURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnURL', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByLnURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lnURL', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByMaxSendable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSendable', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByMaxSendableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSendable', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByMinSendable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minSendable', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByMinSendableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minSendable', Sort.desc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByNostrPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nostrPubkey', Sort.asc);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QAfterSortBy> thenByNostrPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nostrPubkey', Sort.desc);
    });
  }
}

extension ZapsDBISARQueryWhereDistinct
    on QueryBuilder<ZapsDBISAR, ZapsDBISAR, QDistinct> {
  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QDistinct> distinctByAllowsNostr() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allowsNostr');
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QDistinct> distinctByCallback(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'callback', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QDistinct> distinctByLnAddr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lnAddr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QDistinct> distinctByLnURL(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lnURL', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QDistinct> distinctByMaxSendable() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxSendable');
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QDistinct> distinctByMinSendable() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minSendable');
    });
  }

  QueryBuilder<ZapsDBISAR, ZapsDBISAR, QDistinct> distinctByNostrPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nostrPubkey', caseSensitive: caseSensitive);
    });
  }
}

extension ZapsDBISARQueryProperty
    on QueryBuilder<ZapsDBISAR, ZapsDBISAR, QQueryProperty> {
  QueryBuilder<ZapsDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ZapsDBISAR, bool, QQueryOperations> allowsNostrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allowsNostr');
    });
  }

  QueryBuilder<ZapsDBISAR, String, QQueryOperations> callbackProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'callback');
    });
  }

  QueryBuilder<ZapsDBISAR, String, QQueryOperations> lnAddrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lnAddr');
    });
  }

  QueryBuilder<ZapsDBISAR, String, QQueryOperations> lnURLProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lnURL');
    });
  }

  QueryBuilder<ZapsDBISAR, int, QQueryOperations> maxSendableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxSendable');
    });
  }

  QueryBuilder<ZapsDBISAR, int, QQueryOperations> minSendableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minSendable');
    });
  }

  QueryBuilder<ZapsDBISAR, String, QQueryOperations> nostrPubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nostrPubkey');
    });
  }
}
