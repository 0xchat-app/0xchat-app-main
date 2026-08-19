// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mint_info_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMintInfoIsarCollection on Isar {
  IsarCollection<MintInfoIsar> get mintInfoIsars => this.collection();
}

const MintInfoIsarSchema = CollectionSchema(
  name: r'MintInfoIsar',
  id: -3400831940875607994,
  properties: {
    r'contactJsonRaw': PropertySchema(
      id: 0,
      name: r'contactJsonRaw',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'descriptionLong': PropertySchema(
      id: 2,
      name: r'descriptionLong',
      type: IsarType.string,
    ),
    r'mintURL': PropertySchema(
      id: 3,
      name: r'mintURL',
      type: IsarType.string,
    ),
    r'motd': PropertySchema(
      id: 4,
      name: r'motd',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'nutsJsonRaw': PropertySchema(
      id: 6,
      name: r'nutsJsonRaw',
      type: IsarType.string,
    ),
    r'pubkey': PropertySchema(
      id: 7,
      name: r'pubkey',
      type: IsarType.string,
    ),
    r'version': PropertySchema(
      id: 8,
      name: r'version',
      type: IsarType.string,
    )
  },
  estimateSize: _mintInfoIsarEstimateSize,
  serialize: _mintInfoIsarSerialize,
  deserialize: _mintInfoIsarDeserialize,
  deserializeProp: _mintInfoIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'mintURL': IndexSchema(
      id: 5052576169555451409,
      name: r'mintURL',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mintURL',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _mintInfoIsarGetId,
  getLinks: _mintInfoIsarGetLinks,
  attach: _mintInfoIsarAttach,
  version: '3.1.0+1',
);

int _mintInfoIsarEstimateSize(
  MintInfoIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.contactJsonRaw.length * 3;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.descriptionLong.length * 3;
  bytesCount += 3 + object.mintURL.length * 3;
  bytesCount += 3 + object.motd.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.nutsJsonRaw.length * 3;
  bytesCount += 3 + object.pubkey.length * 3;
  bytesCount += 3 + object.version.length * 3;
  return bytesCount;
}

void _mintInfoIsarSerialize(
  MintInfoIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.contactJsonRaw);
  writer.writeString(offsets[1], object.description);
  writer.writeString(offsets[2], object.descriptionLong);
  writer.writeString(offsets[3], object.mintURL);
  writer.writeString(offsets[4], object.motd);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.nutsJsonRaw);
  writer.writeString(offsets[7], object.pubkey);
  writer.writeString(offsets[8], object.version);
}

MintInfoIsar _mintInfoIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MintInfoIsar(
    contactJsonRaw: reader.readString(offsets[0]),
    description: reader.readString(offsets[1]),
    descriptionLong: reader.readString(offsets[2]),
    mintURL: reader.readString(offsets[3]),
    motd: reader.readString(offsets[4]),
    name: reader.readString(offsets[5]),
    nutsJsonRaw: reader.readString(offsets[6]),
    pubkey: reader.readString(offsets[7]),
    version: reader.readString(offsets[8]),
  );
  object.id = id;
  return object;
}

P _mintInfoIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mintInfoIsarGetId(MintInfoIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mintInfoIsarGetLinks(MintInfoIsar object) {
  return [];
}

void _mintInfoIsarAttach(
    IsarCollection<dynamic> col, Id id, MintInfoIsar object) {
  object.id = id;
}

extension MintInfoIsarByIndex on IsarCollection<MintInfoIsar> {
  Future<MintInfoIsar?> getByMintURL(String mintURL) {
    return getByIndex(r'mintURL', [mintURL]);
  }

  MintInfoIsar? getByMintURLSync(String mintURL) {
    return getByIndexSync(r'mintURL', [mintURL]);
  }

  Future<bool> deleteByMintURL(String mintURL) {
    return deleteByIndex(r'mintURL', [mintURL]);
  }

  bool deleteByMintURLSync(String mintURL) {
    return deleteByIndexSync(r'mintURL', [mintURL]);
  }

  Future<List<MintInfoIsar?>> getAllByMintURL(List<String> mintURLValues) {
    final values = mintURLValues.map((e) => [e]).toList();
    return getAllByIndex(r'mintURL', values);
  }

  List<MintInfoIsar?> getAllByMintURLSync(List<String> mintURLValues) {
    final values = mintURLValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'mintURL', values);
  }

  Future<int> deleteAllByMintURL(List<String> mintURLValues) {
    final values = mintURLValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'mintURL', values);
  }

  int deleteAllByMintURLSync(List<String> mintURLValues) {
    final values = mintURLValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'mintURL', values);
  }

  Future<Id> putByMintURL(MintInfoIsar object) {
    return putByIndex(r'mintURL', object);
  }

  Id putByMintURLSync(MintInfoIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'mintURL', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMintURL(List<MintInfoIsar> objects) {
    return putAllByIndex(r'mintURL', objects);
  }

  List<Id> putAllByMintURLSync(List<MintInfoIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'mintURL', objects, saveLinks: saveLinks);
  }
}

extension MintInfoIsarQueryWhereSort
    on QueryBuilder<MintInfoIsar, MintInfoIsar, QWhere> {
  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MintInfoIsarQueryWhere
    on QueryBuilder<MintInfoIsar, MintInfoIsar, QWhereClause> {
  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterWhereClause> mintURLEqualTo(
      String mintURL) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mintURL',
        value: [mintURL],
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterWhereClause> mintURLNotEqualTo(
      String mintURL) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintURL',
              lower: [],
              upper: [mintURL],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintURL',
              lower: [mintURL],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintURL',
              lower: [mintURL],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mintURL',
              lower: [],
              upper: [mintURL],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MintInfoIsarQueryFilter
    on QueryBuilder<MintInfoIsar, MintInfoIsar, QFilterCondition> {
  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      contactJsonRawEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      contactJsonRawGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contactJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      contactJsonRawLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contactJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      contactJsonRawBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contactJsonRaw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      contactJsonRawStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contactJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      contactJsonRawEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contactJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      contactJsonRawContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contactJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      contactJsonRawMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contactJsonRaw',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      contactJsonRawIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactJsonRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      contactJsonRawIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contactJsonRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionLongEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descriptionLong',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionLongGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'descriptionLong',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionLongLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'descriptionLong',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionLongBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'descriptionLong',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionLongStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'descriptionLong',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionLongEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'descriptionLong',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionLongContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descriptionLong',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionLongMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descriptionLong',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionLongIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descriptionLong',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      descriptionLongIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'descriptionLong',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      mintURLEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      mintURLGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      mintURLLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      mintURLBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mintURL',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      mintURLStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      mintURLEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      mintURLContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      mintURLMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mintURL',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      mintURLIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      mintURLIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> motdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'motd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      motdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'motd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> motdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'motd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> motdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'motd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      motdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'motd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> motdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'motd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> motdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'motd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> motdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'motd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      motdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'motd',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      motdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'motd',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> nameContains(
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nutsJsonRawEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nutsJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nutsJsonRawGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nutsJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nutsJsonRawLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nutsJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nutsJsonRawBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nutsJsonRaw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nutsJsonRawStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nutsJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nutsJsonRawEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nutsJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nutsJsonRawContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nutsJsonRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nutsJsonRawMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nutsJsonRaw',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nutsJsonRawIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nutsJsonRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      nutsJsonRawIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nutsJsonRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> pubkeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      pubkeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      pubkeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> pubkeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pubkey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      pubkeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      pubkeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      pubkeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pubkey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition> pubkeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pubkey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      pubkeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      pubkeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pubkey',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      versionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      versionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      versionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      versionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      versionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      versionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      versionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      versionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'version',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      versionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: '',
      ));
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterFilterCondition>
      versionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'version',
        value: '',
      ));
    });
  }
}

extension MintInfoIsarQueryObject
    on QueryBuilder<MintInfoIsar, MintInfoIsar, QFilterCondition> {}

extension MintInfoIsarQueryLinks
    on QueryBuilder<MintInfoIsar, MintInfoIsar, QFilterCondition> {}

extension MintInfoIsarQuerySortBy
    on QueryBuilder<MintInfoIsar, MintInfoIsar, QSortBy> {
  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      sortByContactJsonRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactJsonRaw', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      sortByContactJsonRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactJsonRaw', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      sortByDescriptionLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptionLong', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      sortByDescriptionLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptionLong', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByMotd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motd', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByMotdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motd', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByNutsJsonRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutsJsonRaw', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      sortByNutsJsonRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutsJsonRaw', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension MintInfoIsarQuerySortThenBy
    on QueryBuilder<MintInfoIsar, MintInfoIsar, QSortThenBy> {
  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      thenByContactJsonRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactJsonRaw', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      thenByContactJsonRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactJsonRaw', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      thenByDescriptionLong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptionLong', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      thenByDescriptionLongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptionLong', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByMotd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motd', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByMotdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motd', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByNutsJsonRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutsJsonRaw', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy>
      thenByNutsJsonRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nutsJsonRaw', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByPubkey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByPubkeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pubkey', Sort.desc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension MintInfoIsarQueryWhereDistinct
    on QueryBuilder<MintInfoIsar, MintInfoIsar, QDistinct> {
  QueryBuilder<MintInfoIsar, MintInfoIsar, QDistinct> distinctByContactJsonRaw(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contactJsonRaw',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QDistinct> distinctByDescriptionLong(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'descriptionLong',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QDistinct> distinctByMintURL(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mintURL', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QDistinct> distinctByMotd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'motd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QDistinct> distinctByNutsJsonRaw(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nutsJsonRaw', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QDistinct> distinctByPubkey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pubkey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MintInfoIsar, MintInfoIsar, QDistinct> distinctByVersion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version', caseSensitive: caseSensitive);
    });
  }
}

extension MintInfoIsarQueryProperty
    on QueryBuilder<MintInfoIsar, MintInfoIsar, QQueryProperty> {
  QueryBuilder<MintInfoIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MintInfoIsar, String, QQueryOperations>
      contactJsonRawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contactJsonRaw');
    });
  }

  QueryBuilder<MintInfoIsar, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<MintInfoIsar, String, QQueryOperations>
      descriptionLongProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'descriptionLong');
    });
  }

  QueryBuilder<MintInfoIsar, String, QQueryOperations> mintURLProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mintURL');
    });
  }

  QueryBuilder<MintInfoIsar, String, QQueryOperations> motdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'motd');
    });
  }

  QueryBuilder<MintInfoIsar, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<MintInfoIsar, String, QQueryOperations> nutsJsonRawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nutsJsonRaw');
    });
  }

  QueryBuilder<MintInfoIsar, String, QQueryOperations> pubkeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pubkey');
    });
  }

  QueryBuilder<MintInfoIsar, String, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}
