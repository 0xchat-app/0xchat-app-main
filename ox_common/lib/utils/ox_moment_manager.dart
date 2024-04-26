import 'package:chatcore/chat-core.dart';

abstract mixin class OXMomentObserver {
  didNewNotesCallBackCallBack(List<NoteDB> notes) {}

  didNewNotificationCallBack(List<NotificationDB> notifications) {}
}

class OXMomentManager {
  static final OXMomentManager sharedInstance = OXMomentManager._internal();

  OXMomentManager._internal();

  Map<String, NoteDB> contactsNotesMap = Map();
  Map<String, NoteDB> privateNotesMap = Map();

  factory OXMomentManager() {
    return sharedInstance;
  }

  final List<OXMomentObserver> _observers = <OXMomentObserver>[];

  void addObserver(OXMomentObserver observer) => _observers.add(observer);

  bool removeObserver(OXMomentObserver observer) => _observers.remove(observer);

  Future<void> init() async {
    initLocalData();
  }

  initLocalData() async {
    addMomentCallBack();
    // _changeListToMap(contactsList,contactsNotesMap);
    // _changeListToMap(_mockData());
  }

  addMomentCallBack() {
  }

  _changeListToMap(List<NoteDB>? list){
    if(list == null) return;
    for(NoteDB db in list){
      privateNotesMap[db.noteId] = db;
    }
  }

  void newNotesCallBackCallBack(List<NoteDB> notes) {
    for (OXMomentObserver observer in _observers) {
      observer.didNewNotesCallBackCallBack(notes);
    }
  }

  void newNotificationCallBack(List<NotificationDB> notifications) {
    for (OXMomentObserver observer in _observers) {
      observer.didNewNotificationCallBack(notifications);
    }
  }
}


