import 'dart:math';
import 'ox_userinfo_manager.dart';

import 'package:chatcore/chat-core.dart';

abstract mixin class OXMomentObserver {
  didNewPrivateNotesCallBack(NoteDB noteDB) {}

  didNewContactsNotesCallBack(NoteDB noteDB) {}

  didNewUserNotesCallBack(NoteDB noteDB) {}
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
    await Moment.sharedInstance.init();
    initLocalData();
  }

  initLocalData() async {
    addMomentCallBack();
    // List<NoteDB>? contactsList = await Moment.sharedInstance.loadContactsNotes();
    // List<NoteDB>? privateList = await Moment.sharedInstance.loadPrivateNotes();
    // _changeListToMap(contactsList,contactsNotesMap);
    // _changeListToMap(_mockData());
  }

  addMomentCallBack() {
    Moment.sharedInstance.newPrivateNotesCallBack = this.newPrivateNotesCallBack;
    Moment.sharedInstance.newContactsNotesCallBack = this.newContactsNotesCallBack;
    Moment.sharedInstance.newUserNotesCallBack = this.newUserNotesCallBack;
  }

  _changeListToMap(List<NoteDB>? list){
    if(list == null) return;
    for(NoteDB db in list){
      privateNotesMap[db.noteId] = db;
    }
  }

  void newPrivateNotesCallBack(NoteDB noteDB) {
    for (OXMomentObserver observer in _observers) {
      observer.didNewContactsNotesCallBack(noteDB);
    }
  }

  void newContactsNotesCallBack(NoteDB noteDB) {
    for (OXMomentObserver observer in _observers) {
      observer.didNewContactsNotesCallBack(noteDB);
    }
  }

  void newUserNotesCallBack(NoteDB noteDB) {
    for (OXMomentObserver observer in _observers) {
      observer.didNewUserNotesCallBack(noteDB);
    }
  }
}


