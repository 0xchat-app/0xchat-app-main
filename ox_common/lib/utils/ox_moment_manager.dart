import 'package:chatcore/chat-core.dart';

abstract mixin class OXMomentObserver {
  didNewNotesCallBackCallBack(List<NoteDB> notes) {}

  didNewNotificationCallBack(List<NotificationDB> notifications) {}

  didMyZapNotificationCallBack(List<NotificationDB> notifications) {}
}

class OXMomentManager {
  static final OXMomentManager sharedInstance = OXMomentManager._internal();

  OXMomentManager._internal();

  factory OXMomentManager() {
    return sharedInstance;
  }

  List<NoteDB> _notes = [];
  List<NotificationDB> _notifications = [];

  List<NoteDB> get notes => _notes;
  List<NotificationDB> get notifications => _notifications;

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

  addMomentCallBack() {
  }


  void clearNewNotes() {
    Moment.sharedInstance.clearNewNotes();
    _notes.clear();
  }

  void clearNewNotifications() {
    Moment.sharedInstance.clearNewNotifications();
    _notifications.clear();
    newNotificationCallBack(_notifications);
  }

  void newNotesCallBackCallBack(List<NoteDB> notes) {
    notes.removeWhere((element) => element.getNoteKind() == _reactionKind);
    _notes = notes;
    for (OXMomentObserver observer in _observers) {
      observer.didNewNotesCallBackCallBack(notes);
    }
  }

  void newNotificationCallBack(List<NotificationDB> notifications) {
    _notifications = notifications;
    for (OXMomentObserver observer in _observers) {
      observer.didNewNotificationCallBack(notifications);
    }
  }

  void myZapNotificationCallBack(List<NotificationDB> notifications) {
    for (OXMomentObserver observer in _observers) {
      observer.didMyZapNotificationCallBack(notifications);
    }
  }
}


