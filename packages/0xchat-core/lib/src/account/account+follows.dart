import 'dart:async';

import 'package:nostr_core_dart/nostr.dart';
import 'package:chatcore/chat-core.dart';

extension AccountFollows on Account {
  Future<bool> onFollowingList(String pubkey) async {
    return me?.followingList?.contains(pubkey) == true;
  }

  Future<List<UserDBISAR>> syncFollowingListFromDB(String pubkey) async {
    UserDBISAR? user = pubkey == currentPubkey ? me : await getUserInfo(pubkey);
    List<UserDBISAR> result = [];
    await Future.forEach(user?.followingList ?? [], (p) async {
      UserDBISAR? userDB = await getUserInfo(p);
      if (userDB != null) {
        result.add(userDB);
      }
    });
    return result;
  }

  Future<void> syncFollowingListFromRelay(String pubkey,
      {String? relay}) async {
    Completer<void> completer = Completer<void>();
    Filter f = Filter(kinds: [3], authors: [pubkey], limit: 1);
    List<Profile> profiles = [];
    int lastTimeStamp = 0;
    Map<String, List<Filter>> subscriptions = {};
    if (relay == null) {
      for (var r in Connect.sharedInstance.relays()) {
        subscriptions[r] = [f];
      }
    } else {
      subscriptions[relay] = [f];
    }
    Connect.sharedInstance.addSubscriptions(subscriptions,
        eventCallBack: (event, relay) async {
      if (event.createdAt > lastTimeStamp) {
        profiles = Nip2.decode(event);
        lastTimeStamp = event.createdAt;
      }
    }, eoseCallBack: (requestId, ok, relay, unRelays) async {
      if (unRelays.isEmpty) {
        UserDBISAR? user =
            (pubkey == currentPubkey) ? me : await getUserInfo(pubkey);
        if (user != null && profiles.isNotEmpty) {
          user.followingList = profiles.map((e) => e.key).toList();
          await Account.saveUserToDB(user);
        }
        if (!completer.isCompleted) completer.complete();
      }
    });
    return completer.future;
  }

  Future<OKEvent> _syncFollowListToRelay(List<String> pubkeys) async {
    if (pubkeys.isEmpty) return OKEvent('', false, 'invalid following list!');
    Completer<OKEvent> completer = Completer<OKEvent>();
    Event event =
        await Nip2.encode(toProfiles(pubkeys), currentPubkey, currentPrivkey);
    Connect.sharedInstance.sendEvent(event, sendCallBack: (ok, relay) {
      if (!completer.isCompleted) {
        completer.complete(ok);
      }
    });
    return completer.future;
  }

  Future<OKEvent> addFollows(List<String> pubkeys) async {
    List<String> followingList = me?.followingList ?? [];
    for (var p in pubkeys) {
      if (!followingList.contains(p)) followingList.add(p);
    }
    me?.followingList = followingList;
    syncMe();
    // Moment.sharedInstance.updateSubscriptions();
    return await _syncFollowListToRelay(followingList);
  }

  Future<OKEvent> removeFollows(List<String> pubkeys) async {
    List<String> followingList = me?.followingList ?? [];
    for (var p in pubkeys) {
      if (followingList.contains(p)) followingList.remove(p);
    }
    me?.followingList = followingList;
    syncMe();
    // Moment.sharedInstance.updateSubscriptions();
    return await _syncFollowListToRelay(followingList);
  }
}
