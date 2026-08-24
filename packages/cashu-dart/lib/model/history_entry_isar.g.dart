// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_entry_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIHistoryEntryIsarCollection on Isar {
  IsarCollection<IHistoryEntryIsar> get iHistoryEntryIsars => this.collection();
}

const IHistoryEntryIsarSchema = CollectionSchema(
  name: r'IHistoryEntryIsar',
  id: 2245623621949926598,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'fee': PropertySchema(
      id: 1,
      name: r'fee',
      type: IsarType.long,
    ),
    r'isSpent': PropertySchema(
      id: 2,
      name: r'isSpent',
      type: IsarType.bool,
    ),
    r'memo': PropertySchema(
      id: 3,
      name: r'memo',
      type: IsarType.string,
    ),
    r'mints': PropertySchema(
      id: 4,
      name: r'mints',
      type: IsarType.stringList,
    ),
    r'timestamp': PropertySchema(
      id: 5,
      name: r'timestamp',
      type: IsarType.double,
    ),
    r'typeRaw': PropertySchema(
      id: 6,
      name: r'typeRaw',
      type: IsarType.long,
    ),
    r'value': PropertySchema(
      id: 7,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _iHistoryEntryIsarEstimateSize,
  serialize: _iHistoryEntryIsarSerialize,
  deserialize: _iHistoryEntryIsarDeserialize,
  deserializeProp: _iHistoryEntryIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _iHistoryEntryIsarGetId,
  getLinks: _iHistoryEntryIsarGetLinks,
  attach: _iHistoryEntryIsarAttach,
  version: '3.1.0+1',
);

int _iHistoryEntryIsarEstimateSize(
  IHistoryEntryIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.memo.length * 3;
  bytesCount += 3 + object.mints.length * 3;
  {
    for (var i = 0; i < object.mints.length; i++) {
      final value = object.mints[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _iHistoryEntryIsarSerialize(
  IHistoryEntryIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeLong(offsets[1], object.fee);
  writer.writeBool(offsets[2], object.isSpent);
  writer.writeString(offsets[3], object.memo);
  writer.writeStringList(offsets[4], object.mints);
  writer.writeDouble(offsets[5], object.timestamp);
  writer.writeLong(offsets[6], object.typeRaw);
  writer.writeString(offsets[7], object.value);
}

IHistoryEntryIsar _iHistoryEntryIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IHistoryEntryIsar(
    amount: reader.readDouble(offsets[0]),
    fee: reader.readLongOrNull(offsets[1]),
    isSpent: reader.readBoolOrNull(offsets[2]),
    mints: reader.readStringList(offsets[4]) ?? [],
    timestamp: reader.readDouble(offsets[5]),
    typeRaw: reader.readLong(offsets[6]),
    value: reader.readString(offsets[7]),
  );
  object.id = id;
  object.memo = reader.readString(offsets[3]);
  return object;
}

P _iHistoryEntryIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _iHistoryEntryIsarGetId(IHistoryEntryIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _iHistoryEntryIsarGetLinks(
    IHistoryEntryIsar object) {
  return [];
}

void _iHistoryEntryIsarAttach(
    IsarCollection<dynamic> col, Id id, IHistoryEntryIsar object) {
  object.id = id;
}

extension IHistoryEntryIsarQueryWhereSort
    on QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QWhere> {
  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IHistoryEntryIsarQueryWhere
    on QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QWhereClause> {
  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterWhereClause>
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

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterWhereClause>
      idBetween(
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
}

extension IHistoryEntryIsarQueryFilter
    on QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QFilterCondition> {
  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      feeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fee',
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      feeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fee',
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      feeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fee',
        value: value,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      feeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fee',
        value: value,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      feeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fee',
        value: value,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      feeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fee',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
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

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
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

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
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

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      isSpentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isSpent',
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      isSpentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isSpent',
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      isSpentEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSpent',
        value: value,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      memoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      memoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      memoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      memoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'memo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      memoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      memoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      memoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'memo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      memoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'memo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      memoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memo',
        value: '',
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      memoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'memo',
        value: '',
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mints',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mints',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mints',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mints',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mints',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mints',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mints',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mints',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mints',
        value: '',
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mints',
        value: '',
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mints',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mints',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mints',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mints',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mints',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      mintsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mints',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      timestampEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      timestampGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      timestampLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      timestampBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      typeRawEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      typeRawGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      typeRawLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeRaw',
        value: value,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      typeRawBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeRaw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      valueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      valueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      valueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      valueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterFilterCondition>
      valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension IHistoryEntryIsarQueryObject
    on QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QFilterCondition> {}

extension IHistoryEntryIsarQueryLinks
    on QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QFilterCondition> {}

extension IHistoryEntryIsarQuerySortBy
    on QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QSortBy> {
  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy> sortByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByIsSpent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSpent', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByIsSpentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSpent', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByMemo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByMemoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByTypeRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeRaw', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByTypeRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeRaw', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension IHistoryEntryIsarQuerySortThenBy
    on QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QSortThenBy> {
  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy> thenByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByIsSpent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSpent', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByIsSpentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSpent', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByMemo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByMemoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memo', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByTypeRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeRaw', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByTypeRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeRaw', Sort.desc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QAfterSortBy>
      thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension IHistoryEntryIsarQueryWhereDistinct
    on QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QDistinct> {
  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QDistinct>
      distinctByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fee');
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QDistinct>
      distinctByIsSpent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSpent');
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QDistinct> distinctByMemo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'memo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QDistinct>
      distinctByMints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mints');
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QDistinct>
      distinctByTypeRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeRaw');
    });
  }

  QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QDistinct> distinctByValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension IHistoryEntryIsarQueryProperty
    on QueryBuilder<IHistoryEntryIsar, IHistoryEntryIsar, QQueryProperty> {
  QueryBuilder<IHistoryEntryIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IHistoryEntryIsar, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<IHistoryEntryIsar, int?, QQueryOperations> feeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fee');
    });
  }

  QueryBuilder<IHistoryEntryIsar, bool?, QQueryOperations> isSpentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSpent');
    });
  }

  QueryBuilder<IHistoryEntryIsar, String, QQueryOperations> memoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'memo');
    });
  }

  QueryBuilder<IHistoryEntryIsar, List<String>, QQueryOperations>
      mintsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mints');
    });
  }

  QueryBuilder<IHistoryEntryIsar, double, QQueryOperations>
      timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<IHistoryEntryIsar, int, QQueryOperations> typeRawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeRaw');
    });
  }

  QueryBuilder<IHistoryEntryIsar, String, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
