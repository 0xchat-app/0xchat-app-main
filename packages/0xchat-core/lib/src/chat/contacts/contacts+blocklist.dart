import 'dart:async';

import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

extension BlockList on Contacts {
  bool inBlockList(String pubkey) {
    return blockList != null && blockList!.contains(pubkey);
  }

  /// sync
  Future<void> syncBlockListFromDB() async {
    blockList = Account.sharedInstance.me?.blockedList;
  }

  Future<void> _syncBlockListToDB() async {
    Account.sharedInstance.me?.blockedList = blockList;
    await Account.sharedInstance.syncMe();
  }

  Future<void> _syncBlockListToRelay({OKCallBack? okCallBack}) async {
    if (blockList != null) {
      List<People> list = [];
      for (String pubkey in blockList!) {
        People p = People(pubkey, '', '', '');
        list.add(p);
      }
      Event event = await Nip51.createMutePeople([], list, privkey, pubkey,
          hashTags: Account.sharedInstance.me?.blockedHashTags,
          words: Account.sharedInstance.me?.blockedWords,
          threads: Account.sharedInstance.me?.blockedThreads);
      if (event.content.isNotEmpty) {
        Connect.sharedInstance.sendEvent(event, sendCallBack: (OKEvent ok, String relay) {
          if (ok.status) {
            Account.sharedInstance.me!.lastBlockListUpdatedTime = event.createdAt;
          }
          okCallBack?.call(ok, relay);
        });
      } else {
        throw Exception('_syncBlockListToRelay error!, $blockList');
      }
    } else {
      okCallBack?.call(OKEvent('', false, 'blockList is empty'), '');
    }
  }

  Future<OKEvent> addToBlockList(String blockPubkey) async {
    if (blockPubkey == pubkey) {
      return OKEvent(blockPubkey, false, 'can not block self');
    }

    Completer<OKEvent> completer = Completer<OKEvent>();

    blockList ??= [];
    if (!blockList!.contains(blockPubkey)) {
      blockList!.add(blockPubkey);
      _syncBlockListToRelay(okCallBack: (OKEvent ok, String relay) {
        if (!completer.isCompleted) completer.complete(ok);
      });
      _syncBlockListToDB();
    } else {
      if (!completer.isCompleted) {
        completer.complete(OKEvent(blockPubkey, false, 'blockPubkey already exit'));
      }
    }

    return completer.future;
  }

  Future<OKEvent> removeBlockList(List<String> blockPubkeys) async {
    Completer<OKEvent> completer = Completer<OKEvent>();
    if (blockList != null && blockList!.isNotEmpty) {
      for (var p in blockPubkeys) {
        blockList!.remove(p);
      }
      _syncBlockListToRelay(okCallBack: (OKEvent ok, String relay) {
        if (!completer.isCompleted) completer.complete(ok);
      });
      _syncBlockListToDB();
    } else {
      if (!completer.isCompleted) {
        completer.complete(OKEvent('', false, 'blockList empty'));
      }
    }
    return completer.future;
  }
}
