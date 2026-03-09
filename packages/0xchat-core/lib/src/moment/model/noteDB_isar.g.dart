// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noteDB_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNoteDBISARCollection on Isar {
  IsarCollection<NoteDBISAR> get noteDBISARs => this.collection();
}

const NoteDBISARSchema = CollectionSchema(
  name: r'NoteDBISAR',
  id: -2324334552369827114,
  properties: {
    r'author': PropertySchema(
      id: 0,
      name: r'author',
      type: IsarType.string,
    ),
    r'content': PropertySchema(
      id: 1,
      name: r'content',
      type: IsarType.string,
    ),
    r'createAt': PropertySchema(
      id: 2,
      name: r'createAt',
      type: IsarType.long,
    ),
    r'emojiShortcode': PropertySchema(
      id: 3,
      name: r'emojiShortcode',
      type: IsarType.string,
    ),
    r'emojiShortcodesJson': PropertySchema(
      id: 4,
      name: r'emojiShortcodesJson',
      type: IsarType.string,
    ),
    r'emojiURL': PropertySchema(
      id: 5,
      name: r'emojiURL',
      type: IsarType.string,
    ),
    r'encodedNoteId': PropertySchema(
      id: 6,
      name: r'encodedNoteId',
      type: IsarType.string,
    ),
    r'findEvent': PropertySchema(
      id: 7,
      name: r'findEvent',
      type: IsarType.bool,
    ),
    r'groupId': PropertySchema(
      id: 8,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'hashTags': PropertySchema(
      id: 9,
      name: r'hashTags',
      type: IsarType.stringList,
    ),
    r'lastUpdatedTimeString': PropertySchema(
      id: 10,
      name: r'lastUpdatedTimeString',
      type: IsarType.string,
    ),
    r'mentions': PropertySchema(
      id: 11,
      name: r'mentions',
      type: IsarType.stringList,
    ),
    r'noteId': PropertySchema(
      id: 12,
      name: r'noteId',
      type: IsarType.string,
    ),
    r'pTags': PropertySchema(
      id: 13,
      name: r'pTags',
      type: IsarType.stringList,
    ),
    r'private': PropertySchema(
      id: 14,
      name: r'private',
      type: IsarType.bool,
    ),
    r'quoteRepostCount': PropertySchema(
      id: 15,
      name: r'quoteRepostCount',
      type: IsarType.long,
    ),
    r'quoteRepostCountByMe': PropertySchema(
      id: 16,
      name: r'quoteRepostCountByMe',
      type: IsarType.long,
    ),
    r'quoteRepostEventIds': PropertySchema(
      id: 17,
      name: r'quoteRepostEventIds',
      type: IsarType.stringList,
    ),
    r'quoteRepostId': PropertySchema(
      id: 18,
      name: r'quoteRepostId',
      type: IsarType.string,
    ),
    r'rawEvent': PropertySchema(
      id: 19,
      name: r'rawEvent',
      type: IsarType.string,
    ),
    r'reactedId': PropertySchema(
      id: 20,
      name: r'reactedId',
      type: IsarType.string,
    ),
    r'reactedKind': PropertySchema(
      id: 21,
      name: r'reactedKind',
      type: IsarType.string,
    ),
    r'reactionCount': PropertySchema(
      id: 22,
      name: r'reactionCount',
      type: IsarType.long,
    ),
    r'reactionCountByMe': PropertySchema(
      id: 23,
      name: r'reactionCountByMe',
      type: IsarType.long,
    ),
    r'reactionEventIds': PropertySchema(
      id: 24,
      name: r'reactionEventIds',
      type: IsarType.stringList,
    ),
    r'read': PropertySchema(
      id: 25,
      name: r'read',
      type: IsarType.bool,
    ),
    r'relayList': PropertySchema(
      id: 26,
      name: r'relayList',
      type: IsarType.stringList,
    ),
    r'reply': PropertySchema(
      id: 27,
      name: r'reply',
      type: IsarType.string,
    ),
    r'replyCount': PropertySchema(
      id: 28,
      name: r'replyCount',
      type: IsarType.long,
    ),
    r'replyCountByMe': PropertySchema(
      id: 29,
      name: r'replyCountByMe',
      type: IsarType.long,
    ),
    r'replyEventIds': PropertySchema(
      id: 30,
      name: r'replyEventIds',
      type: IsarType.stringList,
    ),
    r'replyRelay': PropertySchema(
      id: 31,
      name: r'replyRelay',
      type: IsarType.string,
    ),
    r'repostCount': PropertySchema(
      id: 32,
      name: r'repostCount',
      type: IsarType.long,
    ),
    r'repostCountByMe': PropertySchema(
      id: 33,
      name: r'repostCountByMe',
      type: IsarType.long,
    ),
    r'repostEventIds': PropertySchema(
      id: 34,
      name: r'repostEventIds',
      type: IsarType.stringList,
    ),
    r'repostId': PropertySchema(
      id: 35,
      name: r'repostId',
      type: IsarType.string,
    ),
    r'root': PropertySchema(
      id: 36,
      name: r'root',
      type: IsarType.string,
    ),
    r'rootRelay': PropertySchema(
      id: 37,
      name: r'rootRelay',
      type: IsarType.string,
    ),
    r'warning': PropertySchema(
      id: 38,
      name: r'warning',
      type: IsarType.string,
    ),
    r'zapAmount': PropertySchema(
      id: 39,
      name: r'zapAmount',
      type: IsarType.long,
    ),
    r'zapAmountByMe': PropertySchema(
      id: 40,
      name: r'zapAmountByMe',
      type: IsarType.long,
    ),
    r'zapCount': PropertySchema(
      id: 41,
      name: r'zapCount',
      type: IsarType.long,
    ),
    r'zapCountByMe': PropertySchema(
      id: 42,
      name: r'zapCountByMe',
      type: IsarType.long,
    ),
    r'zapEventIds': PropertySchema(
      id: 43,
      name: r'zapEventIds',
      type: IsarType.stringList,
    )
  },
  estimateSize: _noteDBISAREstimateSize,
  serialize: _noteDBISARSerialize,
  deserialize: _noteDBISARDeserialize,
  deserializeProp: _noteDBISARDeserializeProp,
  idName: r'id',
  indexes: {
    r'noteId': IndexSchema(
      id: -9014133502494436840,
      name: r'noteId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'noteId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _noteDBISARGetId,
  getLinks: _noteDBISARGetLinks,
  attach: _noteDBISARAttach,
  version: '3.1.0+1',
);

int _noteDBISAREstimateSize(
  NoteDBISAR object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.author.length * 3;
  bytesCount += 3 + object.content.length * 3;
  {
    final value = object.emojiShortcode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.emojiShortcodesJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.emojiURL;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.encodedNoteId.length * 3;
  bytesCount += 3 + object.groupId.length * 3;
  {
    final list = object.hashTags;
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
    final value = object.lastUpdatedTimeString;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.mentions;
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
  bytesCount += 3 + object.noteId.length * 3;
  {
    final list = object.pTags;
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
    final list = object.quoteRepostEventIds;
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
    final value = object.quoteRepostId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rawEvent;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reactedId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reactedKind;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.reactionEventIds;
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
    final list = object.relayList;
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
    final value = object.reply;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.replyEventIds;
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
    final value = object.replyRelay;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.repostEventIds;
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
    final value = object.repostId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.root;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rootRelay;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.warning;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.zapEventIds;
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
  return bytesCount;
}

void _noteDBISARSerialize(
  NoteDBISAR object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.author);
  writer.writeString(offsets[1], object.content);
  writer.writeLong(offsets[2], object.createAt);
  writer.writeString(offsets[3], object.emojiShortcode);
  writer.writeString(offsets[4], object.emojiShortcodesJson);
  writer.writeString(offsets[5], object.emojiURL);
  writer.writeString(offsets[6], object.encodedNoteId);
  writer.writeBool(offsets[7], object.findEvent);
  writer.writeString(offsets[8], object.groupId);
  writer.writeStringList(offsets[9], object.hashTags);
  writer.writeString(offsets[10], object.lastUpdatedTimeString);
  writer.writeStringList(offsets[11], object.mentions);
  writer.writeString(offsets[12], object.noteId);
  writer.writeStringList(offsets[13], object.pTags);
  writer.writeBool(offsets[14], object.private);
  writer.writeLong(offsets[15], object.quoteRepostCount);
  writer.writeLong(offsets[16], object.quoteRepostCountByMe);
  writer.writeStringList(offsets[17], object.quoteRepostEventIds);
  writer.writeString(offsets[18], object.quoteRepostId);
  writer.writeString(offsets[19], object.rawEvent);
  writer.writeString(offsets[20], object.reactedId);
  writer.writeString(offsets[21], object.reactedKind);
  writer.writeLong(offsets[22], object.reactionCount);
  writer.writeLong(offsets[23], object.reactionCountByMe);
  writer.writeStringList(offsets[24], object.reactionEventIds);
  writer.writeBool(offsets[25], object.read);
  writer.writeStringList(offsets[26], object.relayList);
  writer.writeString(offsets[27], object.reply);
  writer.writeLong(offsets[28], object.replyCount);
  writer.writeLong(offsets[29], object.replyCountByMe);
  writer.writeStringList(offsets[30], object.replyEventIds);
  writer.writeString(offsets[31], object.replyRelay);
  writer.writeLong(offsets[32], object.repostCount);
  writer.writeLong(offsets[33], object.repostCountByMe);
  writer.writeStringList(offsets[34], object.repostEventIds);
  writer.writeString(offsets[35], object.repostId);
  writer.writeString(offsets[36], object.root);
  writer.writeString(offsets[37], object.rootRelay);
  writer.writeString(offsets[38], object.warning);
  writer.writeLong(offsets[39], object.zapAmount);
  writer.writeLong(offsets[40], object.zapAmountByMe);
  writer.writeLong(offsets[41], object.zapCount);
  writer.writeLong(offsets[42], object.zapCountByMe);
  writer.writeStringList(offsets[43], object.zapEventIds);
}

NoteDBISAR _noteDBISARDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NoteDBISAR(
    author: reader.readStringOrNull(offsets[0]) ?? '',
    content: reader.readStringOrNull(offsets[1]) ?? '',
    createAt: reader.readLongOrNull(offsets[2]) ?? 0,
    emojiShortcode: reader.readStringOrNull(offsets[3]),
    emojiShortcodesJson: reader.readStringOrNull(offsets[4]),
    emojiURL: reader.readStringOrNull(offsets[5]),
    findEvent: reader.readBoolOrNull(offsets[7]) ?? false,
    groupId: reader.readStringOrNull(offsets[8]) ?? '',
    hashTags: reader.readStringList(offsets[9]),
    lastUpdatedTimeString: reader.readStringOrNull(offsets[10]),
    mentions: reader.readStringList(offsets[11]),
    noteId: reader.readStringOrNull(offsets[12]) ?? '',
    pTags: reader.readStringList(offsets[13]),
    private: reader.readBoolOrNull(offsets[14]) ?? false,
    quoteRepostCount: reader.readLongOrNull(offsets[15]) ?? 0,
    quoteRepostCountByMe: reader.readLongOrNull(offsets[16]) ?? 0,
    quoteRepostEventIds: reader.readStringList(offsets[17]),
    quoteRepostId: reader.readStringOrNull(offsets[18]),
    rawEvent: reader.readStringOrNull(offsets[19]),
    reactedId: reader.readStringOrNull(offsets[20]),
    reactedKind: reader.readStringOrNull(offsets[21]),
    reactionCount: reader.readLongOrNull(offsets[22]) ?? 0,
    reactionCountByMe: reader.readLongOrNull(offsets[23]) ?? 0,
    reactionEventIds: reader.readStringList(offsets[24]),
    read: reader.readBoolOrNull(offsets[25]) ?? false,
    relayList: reader.readStringList(offsets[26]),
    reply: reader.readStringOrNull(offsets[27]),
    replyCount: reader.readLongOrNull(offsets[28]) ?? 0,
    replyCountByMe: reader.readLongOrNull(offsets[29]) ?? 0,
    replyEventIds: reader.readStringList(offsets[30]),
    replyRelay: reader.readStringOrNull(offsets[31]),
    repostCount: reader.readLongOrNull(offsets[32]) ?? 0,
    repostCountByMe: reader.readLongOrNull(offsets[33]) ?? 0,
    repostEventIds: reader.readStringList(offsets[34]),
    repostId: reader.readStringOrNull(offsets[35]),
    root: reader.readStringOrNull(offsets[36]),
    rootRelay: reader.readStringOrNull(offsets[37]),
    warning: reader.readStringOrNull(offsets[38]),
    zapAmount: reader.readLongOrNull(offsets[39]) ?? 0,
    zapAmountByMe: reader.readLongOrNull(offsets[40]) ?? 0,
    zapCount: reader.readLongOrNull(offsets[41]) ?? 0,
    zapCountByMe: reader.readLongOrNull(offsets[42]) ?? 0,
    zapEventIds: reader.readStringList(offsets[43]),
  );
  object.id = id;
  return object;
}

P _noteDBISARDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 9:
      return (reader.readStringList(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringList(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 13:
      return (reader.readStringList(offset)) as P;
    case 14:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 15:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 16:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 17:
      return (reader.readStringList(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 23:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 24:
      return (reader.readStringList(offset)) as P;
    case 25:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 26:
      return (reader.readStringList(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    case 28:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 29:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 30:
      return (reader.readStringList(offset)) as P;
    case 31:
      return (reader.readStringOrNull(offset)) as P;
    case 32:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 33:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 34:
      return (reader.readStringList(offset)) as P;
    case 35:
      return (reader.readStringOrNull(offset)) as P;
    case 36:
      return (reader.readStringOrNull(offset)) as P;
    case 37:
      return (reader.readStringOrNull(offset)) as P;
    case 38:
      return (reader.readStringOrNull(offset)) as P;
    case 39:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 40:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 41:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 42:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 43:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _noteDBISARGetId(NoteDBISAR object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _noteDBISARGetLinks(NoteDBISAR object) {
  return [];
}

void _noteDBISARAttach(IsarCollection<dynamic> col, Id id, NoteDBISAR object) {
  object.id = id;
}

extension NoteDBISARByIndex on IsarCollection<NoteDBISAR> {
  Future<NoteDBISAR?> getByNoteId(String noteId) {
    return getByIndex(r'noteId', [noteId]);
  }

  NoteDBISAR? getByNoteIdSync(String noteId) {
    return getByIndexSync(r'noteId', [noteId]);
  }

  Future<bool> deleteByNoteId(String noteId) {
    return deleteByIndex(r'noteId', [noteId]);
  }

  bool deleteByNoteIdSync(String noteId) {
    return deleteByIndexSync(r'noteId', [noteId]);
  }

  Future<List<NoteDBISAR?>> getAllByNoteId(List<String> noteIdValues) {
    final values = noteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'noteId', values);
  }

  List<NoteDBISAR?> getAllByNoteIdSync(List<String> noteIdValues) {
    final values = noteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'noteId', values);
  }

  Future<int> deleteAllByNoteId(List<String> noteIdValues) {
    final values = noteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'noteId', values);
  }

  int deleteAllByNoteIdSync(List<String> noteIdValues) {
    final values = noteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'noteId', values);
  }

  Future<Id> putByNoteId(NoteDBISAR object) {
    return putByIndex(r'noteId', object);
  }

  Id putByNoteIdSync(NoteDBISAR object, {bool saveLinks = true}) {
    return putByIndexSync(r'noteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNoteId(List<NoteDBISAR> objects) {
    return putAllByIndex(r'noteId', objects);
  }

  List<Id> putAllByNoteIdSync(List<NoteDBISAR> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'noteId', objects, saveLinks: saveLinks);
  }
}

extension NoteDBISARQueryWhereSort
    on QueryBuilder<NoteDBISAR, NoteDBISAR, QWhere> {
  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NoteDBISARQueryWhere
    on QueryBuilder<NoteDBISAR, NoteDBISAR, QWhereClause> {
  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterWhereClause> idBetween(
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterWhereClause> noteIdEqualTo(
      String noteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'noteId',
        value: [noteId],
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterWhereClause> noteIdNotEqualTo(
      String noteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [],
              upper: [noteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [noteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [noteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [],
              upper: [noteId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension NoteDBISARQueryFilter
    on QueryBuilder<NoteDBISAR, NoteDBISAR, QFilterCondition> {
  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> authorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> authorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> authorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> authorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> authorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> authorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> authorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> authorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> contentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> contentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> createAtEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      createAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> createAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> createAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emojiShortcode',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emojiShortcode',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emojiShortcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emojiShortcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emojiShortcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emojiShortcode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emojiShortcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emojiShortcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emojiShortcode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emojiShortcode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emojiShortcode',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emojiShortcode',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emojiShortcodesJson',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emojiShortcodesJson',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emojiShortcodesJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emojiShortcodesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emojiShortcodesJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emojiShortcodesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiShortcodesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emojiShortcodesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> emojiURLIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'emojiURL',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiURLIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'emojiURL',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> emojiURLEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emojiURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiURLGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emojiURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> emojiURLLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emojiURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> emojiURLBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emojiURL',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiURLStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emojiURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> emojiURLEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emojiURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> emojiURLContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emojiURL',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> emojiURLMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emojiURL',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiURLIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emojiURL',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      emojiURLIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emojiURL',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      encodedNoteIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encodedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      encodedNoteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'encodedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      encodedNoteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'encodedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      encodedNoteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'encodedNoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      encodedNoteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'encodedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      encodedNoteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'encodedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      encodedNoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'encodedNoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      encodedNoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'encodedNoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      encodedNoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'encodedNoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      encodedNoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'encodedNoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> findEventEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'findEvent',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> groupIdEqualTo(
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> groupIdLessThan(
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> groupIdBetween(
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> groupIdStartsWith(
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> groupIdEndsWith(
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> groupIdContains(
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> groupIdMatches(
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> hashTagsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hashTags',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hashTags',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashTags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hashTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hashTags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashTags',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hashTags',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hashTags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hashTags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hashTags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hashTags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hashTags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      hashTagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hashTags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> idBetween(
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastUpdatedTimeString',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastUpdatedTimeString',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdatedTimeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdatedTimeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdatedTimeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdatedTimeString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastUpdatedTimeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastUpdatedTimeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastUpdatedTimeString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastUpdatedTimeString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdatedTimeString',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      lastUpdatedTimeStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastUpdatedTimeString',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> mentionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mentions',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mentions',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mentions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mentions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mentions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mentions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mentions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mentions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mentions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mentions',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mentions',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mentions',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mentions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mentions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mentions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mentions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mentions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      mentionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mentions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> noteIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> noteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> noteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> noteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> noteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> noteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> noteIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> noteIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'noteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> noteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      noteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'noteId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> pTagsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pTags',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> pTagsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pTags',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pTags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pTags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pTags',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pTags',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pTags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> pTagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pTags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pTags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pTags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pTags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      pTagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pTags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> privateEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'private',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quoteRepostCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quoteRepostCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quoteRepostCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quoteRepostCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostCountByMeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quoteRepostCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostCountByMeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quoteRepostCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostCountByMeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quoteRepostCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostCountByMeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quoteRepostCountByMe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'quoteRepostEventIds',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'quoteRepostEventIds',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quoteRepostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quoteRepostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quoteRepostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quoteRepostEventIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'quoteRepostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'quoteRepostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'quoteRepostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'quoteRepostEventIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quoteRepostEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'quoteRepostEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'quoteRepostEventIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'quoteRepostEventIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'quoteRepostEventIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'quoteRepostEventIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'quoteRepostEventIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostEventIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'quoteRepostEventIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'quoteRepostId',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'quoteRepostId',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quoteRepostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quoteRepostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quoteRepostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quoteRepostId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'quoteRepostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'quoteRepostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'quoteRepostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'quoteRepostId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quoteRepostId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      quoteRepostIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'quoteRepostId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rawEventIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rawEvent',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      rawEventIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rawEvent',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rawEventEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      rawEventGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rawEventLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rawEventBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawEvent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      rawEventStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rawEventEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rawEventContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawEvent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rawEventMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawEvent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      rawEventIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawEvent',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      rawEventIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawEvent',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reactedId',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reactedId',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> reactedIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reactedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reactedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> reactedIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reactedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> reactedIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reactedId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reactedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> reactedIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reactedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> reactedIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reactedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> reactedIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reactedId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reactedId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reactedId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reactedKind',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reactedKind',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reactedKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reactedKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reactedKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reactedKind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reactedKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reactedKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reactedKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reactedKind',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reactedKind',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactedKindIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reactedKind',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reactionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reactionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reactionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reactionCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionCountByMeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reactionCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionCountByMeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reactionCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionCountByMeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reactionCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionCountByMeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reactionCountByMe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reactionEventIds',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reactionEventIds',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reactionEventIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reactionEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reactionEventIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reactionEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reactionEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      reactionEventIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reactionEventIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> readEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'read',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      relayListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relayList',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      relayListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relayList',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      relayListElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relayList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      relayListElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relayList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      relayListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relayList',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      relayListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relayList',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
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

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reply',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reply',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reply',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reply',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reply',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reply',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reply',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reply',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reply',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reply',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reply',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reply',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replyCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'replyCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'replyCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'replyCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyCountByMeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replyCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyCountByMeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'replyCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyCountByMeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'replyCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyCountByMeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'replyCountByMe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'replyEventIds',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'replyEventIds',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replyEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'replyEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'replyEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'replyEventIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'replyEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'replyEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'replyEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'replyEventIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replyEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'replyEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'replyEventIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'replyEventIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'replyEventIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'replyEventIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'replyEventIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyEventIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'replyEventIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyRelayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'replyRelay',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyRelayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'replyRelay',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyRelayEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replyRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyRelayGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'replyRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyRelayLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'replyRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyRelayBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'replyRelay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyRelayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'replyRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyRelayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'replyRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyRelayContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'replyRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> replyRelayMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'replyRelay',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyRelayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replyRelay',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      replyRelayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'replyRelay',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repostCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repostCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repostCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repostCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostCountByMeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repostCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostCountByMeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repostCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostCountByMeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repostCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostCountByMeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repostCountByMe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'repostEventIds',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'repostEventIds',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repostEventIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'repostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'repostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'repostEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'repostEventIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repostEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'repostEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repostEventIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repostEventIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repostEventIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repostEventIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repostEventIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostEventIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'repostEventIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> repostIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'repostId',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'repostId',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> repostIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> repostIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> repostIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repostId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'repostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> repostIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'repostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> repostIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'repostId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> repostIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'repostId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repostId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      repostIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'repostId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'root',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'root',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'root',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'root',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'root',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'root',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'root',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'root',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'root',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'root',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'root',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'root',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      rootRelayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rootRelay',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      rootRelayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rootRelay',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootRelayEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rootRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      rootRelayGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rootRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootRelayLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rootRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootRelayBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rootRelay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      rootRelayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rootRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootRelayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rootRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootRelayContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rootRelay',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> rootRelayMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rootRelay',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      rootRelayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rootRelay',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      rootRelayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rootRelay',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> warningIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'warning',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      warningIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'warning',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> warningEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'warning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      warningGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'warning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> warningLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'warning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> warningBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'warning',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> warningStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'warning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> warningEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'warning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> warningContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'warning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> warningMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'warning',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> warningIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'warning',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      warningIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'warning',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> zapAmountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zapAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapAmountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zapAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> zapAmountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zapAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> zapAmountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zapAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapAmountByMeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zapAmountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapAmountByMeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zapAmountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapAmountByMeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zapAmountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapAmountByMeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zapAmountByMe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> zapCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> zapCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition> zapCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zapCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapCountByMeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zapCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapCountByMeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zapCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapCountByMeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zapCountByMe',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapCountByMeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zapCountByMe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'zapEventIds',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'zapEventIds',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zapEventIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'zapEventIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'zapEventIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zapEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'zapEventIds',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterFilterCondition>
      zapEventIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'zapEventIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension NoteDBISARQueryObject
    on QueryBuilder<NoteDBISAR, NoteDBISAR, QFilterCondition> {}

extension NoteDBISARQueryLinks
    on QueryBuilder<NoteDBISAR, NoteDBISAR, QFilterCondition> {}

extension NoteDBISARQuerySortBy
    on QueryBuilder<NoteDBISAR, NoteDBISAR, QSortBy> {
  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByEmojiShortcode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcode', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      sortByEmojiShortcodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcode', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      sortByEmojiShortcodesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcodesJson', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      sortByEmojiShortcodesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcodesJson', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByEmojiURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiURL', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByEmojiURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiURL', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByEncodedNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encodedNoteId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByEncodedNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encodedNoteId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByFindEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'findEvent', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByFindEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'findEvent', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      sortByLastUpdatedTimeString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTimeString', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      sortByLastUpdatedTimeStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTimeString', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByPrivateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByQuoteRepostCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostCount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      sortByQuoteRepostCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostCount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      sortByQuoteRepostCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostCountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      sortByQuoteRepostCountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostCountByMe', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByQuoteRepostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByQuoteRepostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRawEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawEvent', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRawEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawEvent', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReactedId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactedId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReactedIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactedId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReactedKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactedKind', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReactedKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactedKind', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReactionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactionCount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReactionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactionCount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReactionCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactionCountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      sortByReactionCountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactionCountByMe', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReply() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reply', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReplyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reply', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReplyCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReplyCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReplyCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      sortByReplyCountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCountByMe', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReplyRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyRelay', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByReplyRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyRelay', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRepostCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostCount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRepostCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostCount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRepostCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostCountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      sortByRepostCountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostCountByMe', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRepostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRepostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRoot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'root', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRootDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'root', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRootRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootRelay', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByRootRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootRelay', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByWarning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warning', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByWarningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warning', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByZapAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByZapAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByZapAmountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByZapAmountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmountByMe', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByZapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapCount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByZapCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapCount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByZapCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapCountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> sortByZapCountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapCountByMe', Sort.desc);
    });
  }
}

extension NoteDBISARQuerySortThenBy
    on QueryBuilder<NoteDBISAR, NoteDBISAR, QSortThenBy> {
  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByEmojiShortcode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcode', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      thenByEmojiShortcodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcode', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      thenByEmojiShortcodesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcodesJson', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      thenByEmojiShortcodesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiShortcodesJson', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByEmojiURL() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiURL', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByEmojiURLDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emojiURL', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByEncodedNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encodedNoteId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByEncodedNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encodedNoteId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByFindEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'findEvent', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByFindEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'findEvent', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      thenByLastUpdatedTimeString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTimeString', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      thenByLastUpdatedTimeStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedTimeString', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByPrivateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'private', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByQuoteRepostCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostCount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      thenByQuoteRepostCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostCount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      thenByQuoteRepostCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostCountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      thenByQuoteRepostCountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostCountByMe', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByQuoteRepostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByQuoteRepostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteRepostId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRawEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawEvent', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRawEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawEvent', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReactedId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactedId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReactedIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactedId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReactedKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactedKind', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReactedKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactedKind', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReactionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactionCount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReactionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactionCount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReactionCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactionCountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      thenByReactionCountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reactionCountByMe', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'read', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReply() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reply', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReplyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reply', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReplyCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReplyCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReplyCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      thenByReplyCountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCountByMe', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReplyRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyRelay', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByReplyRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyRelay', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRepostCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostCount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRepostCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostCount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRepostCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostCountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy>
      thenByRepostCountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostCountByMe', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRepostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostId', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRepostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repostId', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRoot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'root', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRootDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'root', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRootRelay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootRelay', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByRootRelayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootRelay', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByWarning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warning', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByWarningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warning', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByZapAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByZapAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByZapAmountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByZapAmountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapAmountByMe', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByZapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapCount', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByZapCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapCount', Sort.desc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByZapCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapCountByMe', Sort.asc);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QAfterSortBy> thenByZapCountByMeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zapCountByMe', Sort.desc);
    });
  }
}

extension NoteDBISARQueryWhereDistinct
    on QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> {
  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createAt');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByEmojiShortcode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emojiShortcode',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByEmojiShortcodesJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emojiShortcodesJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByEmojiURL(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emojiURL', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByEncodedNoteId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'encodedNoteId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByFindEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'findEvent');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByGroupId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByHashTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashTags');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct>
      distinctByLastUpdatedTimeString({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdatedTimeString',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByMentions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mentions');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByNoteId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByPTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pTags');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'private');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByQuoteRepostCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quoteRepostCount');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct>
      distinctByQuoteRepostCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quoteRepostCountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct>
      distinctByQuoteRepostEventIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quoteRepostEventIds');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByQuoteRepostId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quoteRepostId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByRawEvent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawEvent', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByReactedId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reactedId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByReactedKind(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reactedKind', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByReactionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reactionCount');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct>
      distinctByReactionCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reactionCountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByReactionEventIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reactionEventIds');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'read');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByRelayList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relayList');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByReply(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reply', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByReplyCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'replyCount');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByReplyCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'replyCountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByReplyEventIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'replyEventIds');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByReplyRelay(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'replyRelay', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByRepostCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repostCount');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByRepostCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repostCountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByRepostEventIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repostEventIds');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByRepostId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repostId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByRoot(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'root', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByRootRelay(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rootRelay', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByWarning(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'warning', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByZapAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zapAmount');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByZapAmountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zapAmountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByZapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zapCount');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByZapCountByMe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zapCountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, NoteDBISAR, QDistinct> distinctByZapEventIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zapEventIds');
    });
  }
}

extension NoteDBISARQueryProperty
    on QueryBuilder<NoteDBISAR, NoteDBISAR, QQueryProperty> {
  QueryBuilder<NoteDBISAR, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NoteDBISAR, String, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<NoteDBISAR, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> createAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createAt');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> emojiShortcodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emojiShortcode');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations>
      emojiShortcodesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emojiShortcodesJson');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> emojiURLProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emojiURL');
    });
  }

  QueryBuilder<NoteDBISAR, String, QQueryOperations> encodedNoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encodedNoteId');
    });
  }

  QueryBuilder<NoteDBISAR, bool, QQueryOperations> findEventProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'findEvent');
    });
  }

  QueryBuilder<NoteDBISAR, String, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<NoteDBISAR, List<String>?, QQueryOperations> hashTagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashTags');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations>
      lastUpdatedTimeStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdatedTimeString');
    });
  }

  QueryBuilder<NoteDBISAR, List<String>?, QQueryOperations> mentionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mentions');
    });
  }

  QueryBuilder<NoteDBISAR, String, QQueryOperations> noteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noteId');
    });
  }

  QueryBuilder<NoteDBISAR, List<String>?, QQueryOperations> pTagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pTags');
    });
  }

  QueryBuilder<NoteDBISAR, bool, QQueryOperations> privateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'private');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> quoteRepostCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quoteRepostCount');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations>
      quoteRepostCountByMeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quoteRepostCountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, List<String>?, QQueryOperations>
      quoteRepostEventIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quoteRepostEventIds');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> quoteRepostIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quoteRepostId');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> rawEventProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawEvent');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> reactedIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reactedId');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> reactedKindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reactedKind');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> reactionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reactionCount');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> reactionCountByMeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reactionCountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, List<String>?, QQueryOperations>
      reactionEventIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reactionEventIds');
    });
  }

  QueryBuilder<NoteDBISAR, bool, QQueryOperations> readProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'read');
    });
  }

  QueryBuilder<NoteDBISAR, List<String>?, QQueryOperations>
      relayListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relayList');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> replyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reply');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> replyCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'replyCount');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> replyCountByMeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'replyCountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, List<String>?, QQueryOperations>
      replyEventIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'replyEventIds');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> replyRelayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'replyRelay');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> repostCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repostCount');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> repostCountByMeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repostCountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, List<String>?, QQueryOperations>
      repostEventIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repostEventIds');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> repostIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repostId');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> rootProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'root');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> rootRelayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rootRelay');
    });
  }

  QueryBuilder<NoteDBISAR, String?, QQueryOperations> warningProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'warning');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> zapAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zapAmount');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> zapAmountByMeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zapAmountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> zapCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zapCount');
    });
  }

  QueryBuilder<NoteDBISAR, int, QQueryOperations> zapCountByMeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zapCountByMe');
    });
  }

  QueryBuilder<NoteDBISAR, List<String>?, QQueryOperations>
      zapEventIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zapEventIds');
    });
  }
}
