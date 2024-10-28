import 'package:chatcore/chat-core.dart';

abstract mixin class OXMomentObserver {
  didNewNotesCallBackCallBack(List<NoteDBISAR> notes) {}

  didGroupsNoteCallBack(NoteDBISAR notes) {}

  didMyZapNotificationCallBack(List<NotificationDBISAR> notifications) {}

  didNewNotificationCallBack(List<NotificationDBISAR> notifications) {}

}

class OXMomentManager {
  static final OXMomentManager sharedInstance = OXMomentManager._internal();

  OXMomentManager._internal();

  factory OXMomentManager() {
    return sharedInstance;
  }

  List<NoteDBISAR> _notes = [];
  List<NoteDBISAR> _relayGroupNotes = [];
  List<NotificationDBISAR> _notifications = [];

  List<NoteDBISAR> get notes => _notes;
  List<NoteDBISAR> get relayGroupNotes => _relayGroupNotes;
  List<NotificationDBISAR> get notifications => _notifications;

  final List<OXMomentObserver> _observers = <OXMomentObserver>[];

  void addObserver(OXMomentObserver observer) => _observers.add(observer);

  bool removeObserver(OXMomentObserver observer) => _observers.remove(observer);

  final _reactionKind = 7; // reaction kind

  Future<void> init() async {
    initLocalData();
  }

  initLocalData() async {
    addMomentCallBack();
  }

  addMomentCallBack() {}

  void clearNewNotes() {
    Moment.sharedInstance.clearNewNotes();
    _notes.clear();
  }

  void clearNewNotifications() {
    Moment.sharedInstance.clearNewNotifications();
    _notifications.clear();
    newNotificationCallBack(_notifications);
  }

  void newNotesCallBackCallBack(List<NoteDBISAR> notes) {
    notes.removeWhere((element) => element.getNoteKind() == _reactionKind);
    _notes = notes;
    List<NoteDBISAR> personalNoteDBList = [];
    for (NoteDBISAR noteDB in notes) {
      bool isGroupNoted = noteDB.groupId.isNotEmpty;
      if(!isGroupNoted) {
        personalNoteDBList.add(noteDB);
      }
    }
    for (OXMomentObserver observer in _observers) {
      observer.didNewNotesCallBackCallBack(personalNoteDBList);
    }
  }

  void newNotificationCallBack(List<NotificationDBISAR> notifications) {
    _notifications = notifications;
    for (OXMomentObserver observer in _observers) {
      observer.didNewNotificationCallBack(notifications);
    }
  }

  void myZapNotificationCallBack(List<NotificationDBISAR> notifications) {
    for (OXMomentObserver observer in _observers) {
      observer.didMyZapNotificationCallBack(notifications);
    }
  }

  void groupsNoteCallBack(NoteDBISAR notes) {
    for (OXMomentObserver observer in _observers) {
      observer.didGroupsNoteCallBack(notes);
    }
  }
}


