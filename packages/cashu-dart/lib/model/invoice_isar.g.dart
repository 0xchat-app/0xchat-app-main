// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIInvoiceIsarCollection on Isar {
  IsarCollection<IInvoiceIsar> get iInvoiceIsars => this.collection();
}

const IInvoiceIsarSchema = CollectionSchema(
  name: r'IInvoiceIsar',
  id: 7584952186958784353,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.string,
    ),
    r'expiry': PropertySchema(
      id: 1,
      name: r'expiry',
      type: IsarType.long,
    ),
    r'mintURL': PropertySchema(
      id: 2,
      name: r'mintURL',
      type: IsarType.string,
    ),
    r'paid': PropertySchema(
      id: 3,
      name: r'paid',
      type: IsarType.bool,
    ),
    r'quote': PropertySchema(
      id: 4,
      name: r'quote',
      type: IsarType.string,
    ),
    r'request': PropertySchema(
      id: 5,
      name: r'request',
      type: IsarType.string,
    )
  },
  estimateSize: _iInvoiceIsarEstimateSize,
  serialize: _iInvoiceIsarSerialize,
  deserialize: _iInvoiceIsarDeserialize,
  deserializeProp: _iInvoiceIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'quote_mintURL': IndexSchema(
      id: -3132804030053064756,
      name: r'quote_mintURL',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'quote',
          type: IndexType.hash,
          caseSensitive: true,
        ),
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
  getId: _iInvoiceIsarGetId,
  getLinks: _iInvoiceIsarGetLinks,
  attach: _iInvoiceIsarAttach,
  version: '3.1.0+1',
);

int _iInvoiceIsarEstimateSize(
  IInvoiceIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.amount.length * 3;
  bytesCount += 3 + object.mintURL.length * 3;
  bytesCount += 3 + object.quote.length * 3;
  bytesCount += 3 + object.request.length * 3;
  return bytesCount;
}

void _iInvoiceIsarSerialize(
  IInvoiceIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.amount);
  writer.writeLong(offsets[1], object.expiry);
  writer.writeString(offsets[2], object.mintURL);
  writer.writeBool(offsets[3], object.paid);
  writer.writeString(offsets[4], object.quote);
  writer.writeString(offsets[5], object.request);
}

IInvoiceIsar _iInvoiceIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IInvoiceIsar(
    amount: reader.readString(offsets[0]),
    expiry: reader.readLong(offsets[1]),
    mintURL: reader.readString(offsets[2]),
    paid: reader.readBool(offsets[3]),
    quote: reader.readString(offsets[4]),
    request: reader.readString(offsets[5]),
  );
  object.id = id;
  return object;
}

P _iInvoiceIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _iInvoiceIsarGetId(IInvoiceIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _iInvoiceIsarGetLinks(IInvoiceIsar object) {
  return [];
}

void _iInvoiceIsarAttach(
    IsarCollection<dynamic> col, Id id, IInvoiceIsar object) {
  object.id = id;
}

extension IInvoiceIsarByIndex on IsarCollection<IInvoiceIsar> {
  Future<IInvoiceIsar?> getByQuoteMintURL(String quote, String mintURL) {
    return getByIndex(r'quote_mintURL', [quote, mintURL]);
  }

  IInvoiceIsar? getByQuoteMintURLSync(String quote, String mintURL) {
    return getByIndexSync(r'quote_mintURL', [quote, mintURL]);
  }

  Future<bool> deleteByQuoteMintURL(String quote, String mintURL) {
    return deleteByIndex(r'quote_mintURL', [quote, mintURL]);
  }

  bool deleteByQuoteMintURLSync(String quote, String mintURL) {
    return deleteByIndexSync(r'quote_mintURL', [quote, mintURL]);
  }

  Future<List<IInvoiceIsar?>> getAllByQuoteMintURL(
      List<String> quoteValues, List<String> mintURLValues) {
    final len = quoteValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([quoteValues[i], mintURLValues[i]]);
    }

    return getAllByIndex(r'quote_mintURL', values);
  }

  List<IInvoiceIsar?> getAllByQuoteMintURLSync(
      List<String> quoteValues, List<String> mintURLValues) {
    final len = quoteValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([quoteValues[i], mintURLValues[i]]);
    }

    return getAllByIndexSync(r'quote_mintURL', values);
  }

  Future<int> deleteAllByQuoteMintURL(
      List<String> quoteValues, List<String> mintURLValues) {
    final len = quoteValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([quoteValues[i], mintURLValues[i]]);
    }

    return deleteAllByIndex(r'quote_mintURL', values);
  }

  int deleteAllByQuoteMintURLSync(
      List<String> quoteValues, List<String> mintURLValues) {
    final len = quoteValues.length;
    assert(mintURLValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([quoteValues[i], mintURLValues[i]]);
    }

    return deleteAllByIndexSync(r'quote_mintURL', values);
  }

  Future<Id> putByQuoteMintURL(IInvoiceIsar object) {
    return putByIndex(r'quote_mintURL', object);
  }

  Id putByQuoteMintURLSync(IInvoiceIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'quote_mintURL', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByQuoteMintURL(List<IInvoiceIsar> objects) {
    return putAllByIndex(r'quote_mintURL', objects);
  }

  List<Id> putAllByQuoteMintURLSync(List<IInvoiceIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'quote_mintURL', objects, saveLinks: saveLinks);
  }
}

extension IInvoiceIsarQueryWhereSort
    on QueryBuilder<IInvoiceIsar, IInvoiceIsar, QWhere> {
  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IInvoiceIsarQueryWhere
    on QueryBuilder<IInvoiceIsar, IInvoiceIsar, QWhereClause> {
  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterWhereClause>
      quoteEqualToAnyMintURL(String quote) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'quote_mintURL',
        value: [quote],
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterWhereClause>
      quoteNotEqualToAnyMintURL(String quote) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quote_mintURL',
              lower: [],
              upper: [quote],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quote_mintURL',
              lower: [quote],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quote_mintURL',
              lower: [quote],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quote_mintURL',
              lower: [],
              upper: [quote],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterWhereClause>
      quoteMintURLEqualTo(String quote, String mintURL) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'quote_mintURL',
        value: [quote, mintURL],
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterWhereClause>
      quoteEqualToMintURLNotEqualTo(String quote, String mintURL) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quote_mintURL',
              lower: [quote],
              upper: [quote, mintURL],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quote_mintURL',
              lower: [quote, mintURL],
              includeLower: false,
              upper: [quote],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quote_mintURL',
              lower: [quote, mintURL],
              includeLower: false,
              upper: [quote],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quote_mintURL',
              lower: [quote],
              upper: [quote, mintURL],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IInvoiceIsarQueryFilter
    on QueryBuilder<IInvoiceIsar, IInvoiceIsar, QFilterCondition> {
  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> amountEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      amountGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      amountLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> amountBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      amountStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      amountEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      amountContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> amountMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'amount',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      amountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      amountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> expiryEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiry',
        value: value,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      expiryGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiry',
        value: value,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      expiryLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiry',
        value: value,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> expiryBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiry',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> idBetween(
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

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
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

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
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

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
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

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
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

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
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

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
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

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      mintURLContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mintURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      mintURLMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mintURL',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      mintURLIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      mintURLIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mintURL',
        value: '',
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> paidEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paid',
        value: value,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> quoteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      quoteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> quoteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> quoteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      quoteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'quote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> quoteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'quote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> quoteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'quote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition> quoteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'quote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      quoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quote',
        value: '',
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      quoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'quote',
        value: '',
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      requestEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'request',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      requestGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'request',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      requestLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'request',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      requestBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'request',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      requestStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'request',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      requestEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'request',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      requestContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'request',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      requestMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'request',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      requestIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'request',
        value: '',
      ));
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterFilterCondition>
      requestIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'request',
        value: '',
      ));
    });
  }
}

extension IInvoiceIsarQueryObject
    on QueryBuilder<IInvoiceIsar, IInvoiceIsar, QFilterCondition> {}

extension IInvoiceIsarQueryLinks
    on QueryBuilder<IInvoiceIsar, IInvoiceIsar, QFilterCondition> {}

extension IInvoiceIsarQuerySortBy
    on QueryBuilder<IInvoiceIsar, IInvoiceIsar, QSortBy> {
  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByExpiry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiry', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByExpiryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiry', Sort.desc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paid', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paid', Sort.desc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByQuote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quote', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByQuoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quote', Sort.desc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByRequest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'request', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> sortByRequestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'request', Sort.desc);
    });
  }
}

extension IInvoiceIsarQuerySortThenBy
    on QueryBuilder<IInvoiceIsar, IInvoiceIsar, QSortThenBy> {
  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByExpiry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiry', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByExpiryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiry', Sort.desc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByMintURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByMintURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mintURL', Sort.desc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paid', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paid', Sort.desc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByQuote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quote', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByQuoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quote', Sort.desc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByRequest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'request', Sort.asc);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QAfterSortBy> thenByRequestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'request', Sort.desc);
    });
  }
}

extension IInvoiceIsarQueryWhereDistinct
    on QueryBuilder<IInvoiceIsar, IInvoiceIsar, QDistinct> {
  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QDistinct> distinctByAmount(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QDistinct> distinctByExpiry() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiry');
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QDistinct> distinctByMintURL(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mintURL', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QDistinct> distinctByPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paid');
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QDistinct> distinctByQuote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quote', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IInvoiceIsar, IInvoiceIsar, QDistinct> distinctByRequest(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'request', caseSensitive: caseSensitive);
    });
  }
}

extension IInvoiceIsarQueryProperty
    on QueryBuilder<IInvoiceIsar, IInvoiceIsar, QQueryProperty> {
  QueryBuilder<IInvoiceIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IInvoiceIsar, String, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<IInvoiceIsar, int, QQueryOperations> expiryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiry');
    });
  }

  QueryBuilder<IInvoiceIsar, String, QQueryOperations> mintURLProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mintURL');
    });
  }

  QueryBuilder<IInvoiceIsar, bool, QQueryOperations> paidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paid');
    });
  }

  QueryBuilder<IInvoiceIsar, String, QQueryOperations> quoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quote');
    });
  }

  QueryBuilder<IInvoiceIsar, String, QQueryOperations> requestProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'request');
    });
  }
}
