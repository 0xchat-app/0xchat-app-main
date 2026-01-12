import 'dart:async';
import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';

import '../enum/moment_enum.dart';
import '../enum/visible_type.dart';
import '../model/moment_extension_model.dart';

class MomentDraftManager {
  static final MomentDraftManager shared = MomentDraftManager._internal();

  MomentDraftManager._internal();

  final String _localKey = 'MomentDraftManagerDraft';

  // Keys for drafts (only one draft per type)
  final String _keyMomentDraft = 'momentDraft';
  final String _keyGroupMomentDraft = 'groupMomentDraft';

  Completer? _setupCompleter;

  Future<void> setup() async {
    if (_setupCompleter != null && !_setupCompleter!.isCompleted) {
      return _setupCompleter!.future;
    }
    _setupCompleter = Completer();
    await _loadDrafts();
    if (!_setupCompleter!.isCompleted) {
      _setupCompleter!.complete();
    }
  }

  Future<void> _loadDrafts() async {
    try {
      final jsonMap = await OXCacheManager.defaultOXCacheManager.getData(
        _localKey,
        defaultValue: <String, dynamic>{},
      ) as Map;

      // Load drafts into OXMomentCacheManager
      final cacheManager = OXMomentCacheManager.sharedInstance;

      // Load personal draft (unified)
      if (jsonMap.containsKey(_keyMomentDraft)) {
        final draftJson = jsonMap[_keyMomentDraft];
        if (draftJson != null) {
          cacheManager.createMomentMediaDraft = _draftFromJson(draftJson);
        }
      }

      // Load group draft (unified)
      if (jsonMap.containsKey(_keyGroupMomentDraft)) {
        final draftJson = jsonMap[_keyGroupMomentDraft];
        if (draftJson != null) {
          cacheManager.createGroupMomentMediaDraft = _draftFromJson(draftJson);
        }
      }
    } catch (e) {
      // Handle error silently, start with empty drafts
    }
  }

  Future<void> saveDraft({
    required bool isGroup,
    CreateMomentDraft? draft,
  }) async {
    await _ensureSetup();

    // Use unified key (only one draft per type)
    final key = isGroup ? _keyGroupMomentDraft : _keyMomentDraft;
    final jsonMap = await OXCacheManager.defaultOXCacheManager.getData(
      _localKey,
      defaultValue: <String, dynamic>{},
    ) as Map;

    if (draft == null) {
      jsonMap.remove(key);
    } else {
      jsonMap[key] = _draftToJson(draft);
    }

    await OXCacheManager.defaultOXCacheManager.saveData(_localKey, jsonMap);

    // Update in-memory cache
    final cacheManager = OXMomentCacheManager.sharedInstance;
    if (isGroup) {
      cacheManager.createGroupMomentMediaDraft = draft;
    } else {
      cacheManager.createMomentMediaDraft = draft;
    }
  }

  Future<void> _ensureSetup() async {
    if (_setupCompleter == null || !_setupCompleter!.isCompleted) {
      await setup();
    } else {
      await _setupCompleter!.future;
    }
  }

  Map<String, dynamic> _draftToJson(CreateMomentDraft draft) {
    return {
      'type': draft.type.name,
      'content': draft.content,
      'visibleType': draft.visibleType.name,
      'imageList': draft.imageList,
      'videoPath': draft.videoPath,
      'videoImagePath': draft.videoImagePath,
      'draftCueUserMap': draft.draftCueUserMap?.map((key, value) => MapEntry(
            key,
            {
              'pubKey': value.pubKey,
              'name': value.name,
              'picture': value.picture,
              'dns': value.dns,
            },
          )),
      'selectedContacts': draft.selectedContacts?.map((user) => {
            'pubKey': user.pubKey,
            'name': user.name,
            'picture': user.picture,
            'dns': user.dns,
          }).toList(),
    };
  }

  CreateMomentDraft? _draftFromJson(dynamic json) {
    if (json == null) return null;

    try {
      final map = json is Map ? json : jsonDecode(json.toString()) as Map;

      // Parse type
      final typeStr = map['type'] as String?;
      EMomentType? type;
      if (typeStr != null) {
        type = EMomentType.values.firstWhere(
          (e) => e.name == typeStr,
          orElse: () => EMomentType.content,
        );
      }

      // Parse visibleType
      final visibleTypeStr = map['visibleType'] as String?;
      VisibleType? visibleType;
      if (visibleTypeStr != null) {
        visibleType = VisibleType.values.firstWhere(
          (e) => e.name == visibleTypeStr,
          orElse: () => VisibleType.everyone,
        );
      }

      // Parse draftCueUserMap
      Map<String, UserDBISAR>? draftCueUserMap;
      if (map['draftCueUserMap'] != null) {
        final cueUserMapJson = map['draftCueUserMap'] as Map?;
        if (cueUserMapJson != null) {
          draftCueUserMap = {};
          cueUserMapJson.forEach((key, value) {
            if (value is Map) {
              final pubKey = value['pubKey'] as String?;
              if (pubKey != null) {
                // Create a minimal UserDBISAR from saved data
                final user = UserDBISAR(
                  pubKey: pubKey,
                  name: value['name'] as String?,
                  picture: value['picture'] as String?,
                  dns: value['dns'] as String?,
                );
                draftCueUserMap![key.toString()] = user;
              }
            }
          });
        }
      }

      // Parse selectedContacts
      List<UserDBISAR>? selectedContacts;
      if (map['selectedContacts'] != null) {
        final contactsJson = map['selectedContacts'] as List?;
        if (contactsJson != null) {
          selectedContacts = contactsJson.map((item) {
            if (item is Map) {
              return UserDBISAR(
                pubKey: item['pubKey'] as String? ?? '',
                name: item['name'] as String?,
                picture: item['picture'] as String?,
                dns: item['dns'] as String?,
              );
            }
            return null;
          }).whereType<UserDBISAR>().toList();
        }
      }

      return CreateMomentDraft(
        type: type ?? EMomentType.content,
        visibleType: visibleType ?? VisibleType.everyone,
        content: map['content'] as String? ?? '',
        imageList: (map['imageList'] as List?)?.map((e) => e.toString()).toList(),
        videoPath: map['videoPath'] as String?,
        videoImagePath: map['videoImagePath'] as String?,
        draftCueUserMap: draftCueUserMap,
        selectedContacts: selectedContacts,
      );
    } catch (e) {
      return null;
    }
  }
}

