
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/widget/mention_user_list.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

typedef UserListGetter = Future<List<UserDBISAR>> Function();

extension ChatSessionModelMentionEx on ChatSessionModel {

  bool get isSupportMention => userListGetter != null;

  UserListGetter? get userListGetter {
    switch (this.chatType) {
      case ChatType.chatGroup:
        return _userListGetterByGroupMember;
      case ChatType.chatChannel:
        return _userListGetterByMessageList;
      default:
        return null;
    }
  }

  Future<List<UserDBISAR>> _userListGetterByMessageList() async {
    final completer = Completer<List<UserDBISAR>>();
    final myPubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey;
    ChatDataCache.shared.getSessionMessage(this).then((messageList) {
      final userList = Set<UserDBISAR>();
      messageList.forEach((msg) {
        final userDB = msg.author.sourceObject;
        if (userDB is UserDBISAR) {
          if (userDB.pubKey != myPubkey) {
            userList.add(userDB);
          }
        }
      });
      completer.complete(userList.toList());
    });
    return completer.future;
  }

  Future<List<UserDBISAR>> _userListGetterByGroupMember() async {
    final completer = Completer<List<UserDBISAR>>();
    final members = Groups.sharedInstance.groups[groupId]?.members;
    if (members == null) {
      completer.complete([]);
    } else {
      Account.sharedInstance.getUserInfos(members).then((users) {
        completer.complete(users.values.toList());
      });
    }
    return completer.future;
  }
}

class ProfileMentionWrapper {

  ProfileMentionWrapper(this.source, [this.user]) {
    if (user == null) {
      final userFuture = Account.sharedInstance.getUserInfo(source.pubkey);
      if (userFuture is Future<UserDBISAR?>) {
        userFuture.then((value){
          user = value;
        });
      } else {
        user = userFuture;
      }
    }
  }

  factory ProfileMentionWrapper.create({
    required int start,
    required int end,
    required String pubkey,
    List<String> relays = const [],
  }) {
    return ProfileMentionWrapper(ProfileMention(start, end, pubkey, relays));
  }

  ProfileMention source;
  UserDBISAR? user;

  ProfileMentionWrapper copyWith({int? start, int? end, String? pubkey, List<String>? relays, UserDBISAR? user}) {
    return ProfileMentionWrapper(
      ProfileMention(
        start ?? this.source.start,
        end ?? this.source.end,
        pubkey ?? this.source.pubkey,
        relays ?? this.source.relays,
      ),
      user ?? this.user,
    );
  }

  @override
  String toString() {
    return '[ProfileMentionWrapper]start: ${this.source.start}, end: ${this.source.end}, pubkey: ${this.source.pubkey}';
  }
}

const _mentionPrefix = '@';
const _mentionSuffix = ' ';

class ChatMentionHandler {

  TextEditingController _inputController = TextEditingController();

  List<ProfileMentionWrapper> mentions = [];

  List<UserDBISAR> allUser = [];

  final userList = ValueNotifier<List<UserDBISAR>>([]);
}

extension ChatMentionMessageEx on ChatMentionHandler {
  String? tryEncoder(types.Message message) {
    if (mentions.isNotEmpty && message is types.TextMessage) {
      final originText = message.text;
      _updateMentions(originText);
      return Nip27.encodeProfileMention(mentions.map((e) => e.source).toList(), originText);
    }
    return null;
  }

  static String? tryDecoder(String text, { Function(List<ProfileMention>)? mentionsCallback }) {
    List<ProfileMention> mentions = Nip27.decodeProfileMention(text);
    if (mentions.isEmpty) return null;
    mentionsCallback?.call(mentions);
    mentions.reversed.forEach((mention) {
      final user = Account.sharedInstance.getUserInfo(mention.pubkey);
      var userName = '';
      if (user is UserDBISAR) {
        userName = user.name ?? userName;
      }
      text = text.replaceRange(mention.start, mention.end, '$_mentionPrefix$userName');
    });
    return text;
  }
}

extension ChatMentionInputFieldEx on ChatMentionHandler {

  TextEditingController get inputController => _inputController;
  void set inputController(value) {
    _inputController.removeListener(_inputFieldOnTextChanged);
    _inputController = value;
    _inputController.addListener(_inputFieldOnTextChanged);
  }

  void addMentionText(UserDBISAR user) {

    final userName = user.name ?? '';
    final mentionText = _mentionTextString(userName);
    final originText = inputController.text;
    final selection = inputController.selection;
    final mentionTextStart = selection.end;
    final mentionTextEnd = mentionTextStart + mentionText.length;

    final newText = originText.replaceRange(mentionTextStart, mentionTextStart, mentionText);
    inputController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: mentionTextEnd),
    );

    final mention = ProfileMentionWrapper.create(
      start: mentionTextStart,
      end: mentionTextEnd,
      pubkey: user.pubKey,
    );
    mentions.add(mention);
  }

  String _mentionTextString(String text) => '$_mentionPrefix$text$_mentionSuffix';

  void _inputFieldOnTextChanged() {
    final newText = inputController.text;
    _updateMentions(newText);
    _showUserListIfNeeded(newText, inputController.selection);
  }

  void _updateMentions(String newText) {
    final newMentions = <ProfileMentionWrapper>[];
    final Map<String, int> searchStarrMap = {};

    mentions.forEach((mention) {
      final userName = mention.user?.name;
      if (userName == null) return ;

      final target = _mentionTextString(userName);
      var searchStart = searchStarrMap[userName] ?? 0;
      if (searchStart > newText.length) return ;

      final start = newText.indexOf(target, searchStart);
      if (start < 0) return ;

      final newMention = mention.copyWith(start: start, end: start + target.length - 1);
      newMentions.add(newMention);
      searchStarrMap[userName] = newMention.source.end + 1;
    });

    mentions.clear();
    mentions.addAll(newMentions);
  }

  void _showUserListIfNeeded(String newText, TextSelection selection) {

    final cursorPosition = selection.start;
    if (!selection.isCollapsed || cursorPosition <= 0) {
      _updateUserListValue([]);
      return ;
    }

    final text = newText.substring(0, cursorPosition);

    if (!text.contains(_mentionPrefix)) {
      _updateUserListValue([]);
      return ;
    }

    final lastCharIndex = cursorPosition - 1;
    if (text.substring(lastCharIndex, lastCharIndex + _mentionPrefix.length) == _mentionPrefix) {
      _updateUserListValue(allUser);
      return ;
    }

    final prefixStart = text.lastIndexOf(_mentionPrefix);
    if (prefixStart < 0) {
      _updateUserListValue([]);
      return ;
    }

    // Check if the last target string's mention has been recorded.
    var isRecorded = false;
    final searchText = newText.substring(prefixStart + 1, cursorPosition).toLowerCase();
    mentions.forEach((mention) {
      if (isRecorded) return ;
      final userName = mention.user?.name;
      if (userName == null) return ;

      final target = '$_mentionPrefix$userName$_mentionSuffix';
      if (searchText == target) isRecorded = true;
    });

    if (isRecorded) {
      _updateUserListValue([]);
      return ;
    }

    // Try search user.
    final result = allUser.where((user) {
      final isNameMatch = user.name?.toLowerCase().contains(searchText) ?? false;
      final isDNSMatch = user.dns?.toLowerCase().contains(searchText) ?? false;
      final isNickNameMatch = user.nickName?.toLowerCase().contains(searchText) ?? false;
      return isNameMatch || isDNSMatch || isNickNameMatch;
    }).toList();

    _updateUserListValue(result);
  }
}

extension ChatMentionUserListEx on ChatMentionHandler {

  void _updateUserListValue(List<UserDBISAR> value) {
    userList.value = value;
  }

  Widget buildMentionUserList() {
    return MentionUserList(userList, mentionUserListOnPressed);
  }

  void mentionUserListOnPressed(UserDBISAR item) {
    final originText = inputController.text;
    final selection = inputController.selection;
    final cursorPosition = selection.start;
    if (!selection.isCollapsed) {
      return ;
    }

    final prefixStart = originText.lastIndexOf(_mentionPrefix, cursorPosition);
    if (prefixStart < 0) {
      return ;
    }

    final userName = item.name ?? '';
    if (userName.isEmpty) return ;

    final replaceText = _mentionTextString(userName);
    final newText = originText.replaceRange(prefixStart, cursorPosition, replaceText);
    final end = prefixStart + replaceText.length;
    inputController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: end),
    );

    final mention = ProfileMentionWrapper.create(
      start: prefixStart,
      end: end,
      pubkey: item.pubKey,
    );
    mentions.add(mention);
  }
}