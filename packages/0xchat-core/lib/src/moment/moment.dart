import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

typedef NewNotesCallBack = void Function(List<NoteDBISAR>);
typedef NewNotificationCallBack = void Function(List<NotificationDBISAR>);
typedef OfflineMomentFinishCallBack = void Function();

class Moment {
  /// singleton
  Moment._internal();
  factory Moment() => sharedInstance;
  static final Moment sharedInstance = Moment._internal();

  /// memory storage
  String pubkey = '';
  String privkey = '';
  Map<String, NoteDBISAR> notesCache = {};
  List<NoteDBISAR> newNotes = [];
  List<NotificationDBISAR> newNotifications = [];
  NewNotesCallBack? newNotesCallBack;
  NewNotificationCallBack? newNotificationCallBack;
  NewNotificationCallBack? myZapNotificationCallBack;
  OfflineMomentFinishCallBack? offlineMomentFinishCallBack;

  String notesSubscription = '';
  Map<String, bool> offlineMomentFinish = {};

  int latestNoteTime = 0;
  int latestNotificationTime = 0;
  int limit = 50;
  
  /// Current filter type: 0=global, 1=contacts, 2=reacted, 3=private
  /// Used to automatically determine authors when authors parameter is null
  int currentFilterType = 1; // Default to contacts

  Future<void> init() async {
    privkey = Account.sharedInstance.currentPrivkey;
    pubkey = Account.sharedInstance.currentPubkey;
  }

  void closeSubscriptions({String? relay}) {
    if (notesSubscription.isNotEmpty) {
      Connect.sharedInstance.closeRequests(notesSubscription, relay: relay);
    }
  }

  /// Subscribe moments.
  /// [filterType] Required parameter to determine authors:
  ///   - contacts (1): use contacts + self
  ///   - global (0): null (global feed)
  ///   - other types: null
  Future<void> updateSubscriptions({required int filterType, String? relay, List<String>? relays}) async {
    // Update currentFilterType for reference
    currentFilterType = filterType;
    
    // Determine authors based on filterType
    List<String>? finalAuthors;
    if (filterType == 1) {
      // contacts type: automatically add contacts + self
      finalAuthors = Contacts.sharedInstance.allContacts.keys.toList();
      finalAuthors.add(pubkey);
    }
    
    // Close all old subscriptions first when switching filter types
    closeSubscriptions();

    Map<String, List<Filter>> subscriptions = {};
    List<String> targetRelays = [];
    bool needConnectRelays = false;
    
    if (relays != null && relays.isNotEmpty) {
      targetRelays = relays;
      needConnectRelays = true;
    } else if (relay != null) {
      targetRelays = [relay];
      needConnectRelays = true;
    } else {
      // For global feed (filterType == 0), use recommendGlobalRelays if no relays specified
      if (filterType == 0) {
        targetRelays = Relays.sharedInstance.recommendGlobalRelays;
        needConnectRelays = true;
      } else {
        targetRelays = Connect.sharedInstance.relays();
      }
    }
    if (targetRelays.isEmpty) {
      return;
    }

    // Connect relays first if needed (when relays are explicitly provided or using recommendGlobalRelays)
    if (needConnectRelays) {
      await Connect.sharedInstance.connectRelays(targetRelays, relayKind: RelayKind.general);
    }

    for (String relayURL in targetRelays) {
      int momentUntil = Relays.sharedInstance.getMomentUntil(relayURL);
      Filter f1 = Filter(
          kinds: [1, 6],
          authors: finalAuthors,
          since: momentUntil,
          limit: limit);
      Filter f2 = Filter(
          authors: [pubkey], kinds: [7], since: momentUntil, limit: limit);
      subscriptions[relayURL] = [f1, f2];
    }

    notesSubscription = Connect.sharedInstance.addSubscriptions(subscriptions,
        eventCallBack: (event, relay) async {
      updateMomentTime(event.createdAt, relay);
      if (Contacts.sharedInstance.inBlockList(event.pubkey)) return;
      switch (event.kind) {
        case 1:
          handleNoteEvent(event, relay, false);
          break;
        case 6:
          handleRepostsEvent(event, relay, false);
          break;
        case 7:
          handleReactionEvent(event, relay, false);
          break;
        default:
          break;
      }
    }, eoseCallBack: (requestId, ok, relay, unCompletedRelays) {
      offlineMomentFinish[relay] = true;
      if (ok.status) {
        updateMomentTime(currentUnixTimestampSeconds() - 1, relay);
      }
      if (unCompletedRelays.isEmpty) {
        offlineMomentFinishCallBack?.call();
      }
    }, closeSubscription: false);
  }

  void updateMomentTime(int eventTime, String relay) {
    /// set setMomentSince setMomentUntil
    if (Relays.sharedInstance.relays.containsKey(relay)) {
      Relays.sharedInstance.setMomentSince(eventTime, relay);
      Relays.sharedInstance.setMomentUntil(eventTime, relay);
    } else {
      Relays.sharedInstance.relays[relay] = RelayDBISAR(
          url: relay, momentSince: eventTime, momentUntil: eventTime);
    }
    if (offlineMomentFinish[relay] == true) {
      Relays.sharedInstance.syncRelaysToDB(r: relay);
    }
  }

  void clearNewNotes() {
    newNotes.clear();
  }

  void clearNewNotifications() {
    newNotifications.clear();
  }
}
