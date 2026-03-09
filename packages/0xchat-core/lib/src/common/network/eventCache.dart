import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:sqflite_sqlcipher/sqlite_api.dart';

class EventCache {
  /// singleton
  EventCache._internal();
  factory EventCache() => sharedInstance;
  static final EventCache sharedInstance = EventCache._internal();

  Set<String> cacheIds = {};
  //cache kinds
  List<int> kinds = [4, 1059, 42, 1, 6, 7, 9, 10, 11, 12, 9735];

  final cacheTimeStamp = 24 * 60 * 60 * 7;

  Future<void> loadAllEventsFromDB() async {
    List<EventDBISAR> eventDBs = await DBISAR.sharedInstance.isar.eventDBISARs.where().findAll();
    List<int> expiredEvents = [];
    for (var eventDB in eventDBs) {
      if (eventDB.expiration != null &&
          eventDB.expiration! > 0 &&
          eventDB.expiration! < currentUnixTimestampSeconds()) {
        expiredEvents.add(eventDB.id);
        continue;
      }
      cacheIds.add(eventDB.eventId);
    }

    if (expiredEvents.isEmpty) return;
    DBISAR.sharedInstance.isar.writeTxn(() async {
      int result = await DBISAR.sharedInstance.isar.eventDBISARs.deleteAll(expiredEvents);
      LogUtils.v(() => 'Deleted event caches: $result');
    });
  }

  Future<EventDBISAR?> loadEventFromDB(String eventId) async {
    return await DBISAR.sharedInstance.isar.eventDBISARs
        .where()
        .eventIdEqualTo(eventId)
        .findFirst();
  }

  Future<void> saveEventToDBImmediately(EventDBISAR eventDB) async {
    // Immediately save to database instead of using buffered saveToDB
    await DBISAR.sharedInstance.isar.writeTxn(() async {
      await DBISAR.sharedInstance.isar.eventDBISARs.put(eventDB);
    });
  }

  Future<void> saveEventToDB(EventDBISAR eventDB) async {
    await DBISAR.sharedInstance.saveToDB(eventDB);
  }

  Future<bool> eventExit(Event event) async {
    EventDBISAR? eventDB = await loadEventFromDB(event.id);
    return eventDB != null;
  }

  Future<void> receiveEvent(Event event, String relay) async {
    if (event.kind == 1 || event.kind == 6) {
        if (Moment.sharedInstance.currentFilterType == 0) {
          return;
        }
    }
    if (cacheIds.contains(event.id)) {
      return;
    }
    cacheIds.add(event.id);
    if (!kinds.contains(event.kind)) return;
    EventDBISAR? eventDB =
        EventDBISAR(eventId: event.id, expiration: currentUnixTimestampSeconds() + cacheTimeStamp);
    eventDB.eventReceiveStatus.add(EventStatusISAR(relay: relay, status: true, message: ''));
    await saveEventToDB(eventDB);
  }

  Future<void> sendEvent(Event event, String relay, bool status, String message) async {
    cacheIds.add(event.id);
    EventDBISAR? eventDB = await loadEventFromDB(event.id);
    eventDB ??=
        EventDBISAR(eventId: event.id, expiration: currentUnixTimestampSeconds() + cacheTimeStamp);
    eventDB.eventSendStatus.add(EventStatusISAR(relay: relay, status: status, message: message));
    await saveEventToDB(eventDB);
  }

  /// Update eventSendStatus in EventDBISAR
  /// [eventId] The event ID
  /// [relay] The relay server address
  /// [status] The status from OK event
  /// [message] The message from OK event
  Future<void> updateEventSendStatus(
      String eventId, String relay, bool status, String message) async {
    try {
      EventDBISAR? eventDB = await loadEventFromDB(eventId);
      eventDB ??= EventDBISAR(
        eventId: eventId,
      );
      // Check if status for this relay already exists, update it; otherwise add new one
      List<EventStatusISAR> sendStatuses = eventDB.eventSendStatus;
      int existingIndex = sendStatuses.indexWhere((s) => s.relay == relay);
      if (existingIndex >= 0) {
        // Update existing status
        sendStatuses[existingIndex] = EventStatusISAR(
          relay: relay,
          status: status,
          message: message,
        );
      } else {
        // Add new status
        sendStatuses.add(EventStatusISAR(
          relay: relay,
          status: status,
          message: message,
        ));
      }
      eventDB.eventSendStatus = sendStatuses;
      await saveEventToDBImmediately(eventDB);
    } catch (e) {
      LogUtils.e(() => 'Failed to update eventSendStatus: $e');
    }
  }

  static Future<void> resendEventToRelays(
      String eventString, List<String> relays, OKCallBack? sendCallBack) async {
    await Connect.sharedInstance.connectRelays(relays, relayKind: RelayKind.temp);
    Connect.sharedInstance.sendEvent(await Event.fromJson(jsonDecode(eventString)),
        toRelays: relays, sendCallBack: (ok, relay) {
      sendCallBack?.call(ok, relay);
    });
  }
}
