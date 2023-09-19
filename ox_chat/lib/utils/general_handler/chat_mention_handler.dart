
import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/widget/mention_user_list.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';

class ProfileMentionWrapper {

  ProfileMentionWrapper(this.source, [this.user]) {
    if (user == null)
      Account.sharedInstance.getUserInfo(source.pubkey).then((value) => user = value);
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
  UserDB? user;

  ProfileMentionWrapper copyWith({int? start, int? end, String? pubkey, List<String>? relays, UserDB? user}) {
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
}

class ChatMentionHandler {

  final mentionPrefix = '@';
  final mentionSuffix = ' ';

  TextEditingController _inputController = TextEditingController();
  TextEditingController get inputController => _inputController;

  List<ProfileMentionWrapper> mentions = [];

  List<UserDB> allUser = [];

  final userList = ValueNotifier<List<UserDB>>([]);

  String mentionTextString(String text) => '$mentionPrefix$text$mentionSuffix';

  void inputFieldOnTextChanged() {
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

      final target = mentionTextString(userName);
      var searchStart = searchStarrMap[userName] ?? 0;
      if (searchStart > newText.length) return ;

      final start = newText.indexOf(target, searchStart);
      if (start < 0) return ;

      final newMention = mention.copyWith(start: start, end: start + target.length - 1);
      newMentions.add(newMention);
      searchStarrMap[userName] = newMention.source.end + 1;
    });

    mentions = newMentions;
  }

  void _showUserListIfNeeded(String newText, TextSelection selection) {

    if (!newText.contains(mentionPrefix)) {
      setEmptyUserList();
      return ;
    }

    final cursorPosition = selection.start;
    if (!selection.isCollapsed) {
      setEmptyUserList();
      return ;
    }

    if (newText.endsWith(mentionPrefix)) {
      userList.value = allUser;
      return ;
    }
    final prefixStart = newText.lastIndexOf(mentionPrefix, cursorPosition);
    if (prefixStart < 0) {
      setEmptyUserList();
      return ;
    }

    // Check if the last target string's mention has been recorded.
    var isRecorded = false;
    final searchText = newText.substring(prefixStart + 1, cursorPosition).toLowerCase();
    mentions.forEach((mention) {
      if (isRecorded) return ;
      final userName = mention.user?.name;
      if (userName == null) return ;

      final target = '$mentionPrefix$userName$mentionSuffix';
      if (searchText == target) isRecorded = true;
    });

    if (isRecorded) {
      setEmptyUserList();
      return ;
    }

    // Try search user.
    final result = allUser.where((user) {
      final isNameMatch = user.name?.toLowerCase().contains(searchText) ?? false;
      final isDNSMatch = user.dns?.toLowerCase().contains(searchText) ?? false;
      final isNickNameMatch = user.nickName?.toLowerCase().contains(searchText) ?? false;
      return isNameMatch || isDNSMatch || isNickNameMatch;
    }).toList();

    userList.value = result;
  }

  void setEmptyUserList() {
    userList.value = [];
  }

  Widget buildMentionUserList() {;
    return MentionUserList(userList, mentionUserListOnPressed);
  }

  void mentionUserListOnPressed(UserDB item) {
    final originText = inputController.text;
    final selection = inputController.selection;
    final cursorPosition = selection.start;
    if (!selection.isCollapsed) {
      return ;
    }

    final prefixStart = originText.lastIndexOf(mentionPrefix, cursorPosition);
    if (prefixStart < 0) {
      return ;
    }

    final userName = item.name ?? '';
    if (userName.isEmpty) return ;

    final replaceText = mentionTextString(userName);
    final newText = originText.replaceRange(prefixStart, cursorPosition, replaceText);
    final end = prefixStart + replaceText.length;
    inputController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: end),
    );

    mentions.add(ProfileMentionWrapper.create(start: prefixStart, end: end, pubkey: item.pubKey));
  }

  void set inputController(value) {
    _inputController.removeListener(inputFieldOnTextChanged);
    _inputController = value;
    _inputController.addListener(inputFieldOnTextChanged);
  }
}