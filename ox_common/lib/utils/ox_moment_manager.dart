import 'dart:math';
import 'ox_userinfo_manager.dart';

import 'package:chatcore/chat-core.dart';

String content1 =
    "IIUC the geohash asdfasd1f.png asdfasdf.jpg  description provided asdfasdf.mp4 here should work: https://github.com/sandwichfarm/nostr-geotags?tab=readme-ov-file#example-response  --&gt; the driver could mention the radius they want to be available at, so can the person searching, ratings could be based on WoT.  What do you think nostr:npub1arkn0xxxll4llgy9qxkrncn3vc4l69s0dz8ef3zadykcwe7ax3dqrrh43w ?nostr:note1zhps6wp7rqchwlmp8s9wq3taramg849lczhds3h4wxvdm5vccc6qxa9zr8";
String content2 =
    "mmmIIUC the geohash des3cription provided asdfasdf.mp4 here should work: https://github.com/sandwichfarm/nostr-geotags?tab=readme-ov-file#example-response  --&gt; the driver could mention the radius they want to be available at, so can the person searching, ratings could be based on WoT.  What do you think nostr:npub1arkn0xxxll4llgy9qxkrncn3vc4l69s0dz8ef3zadykcwe7ax3dqrrh43w ?nostr:note1zhps6wp7rqchwlmp8s9wq3taramg849lczhds3h4wxvdm5vccc6qxa9zr8";
String content3 =
    "IIUC the geoha2sh description provid here should work: https://github.com/sandwichfarm/nostr-geotags?tab=readme-ov-file#example-response  --&gt; the driver could mention the radius they want to be available at, so can the person searching, ratings could be based on WoT.  What do you think nostr:npub1arkn0xxxll4llgy9qxkrncn3vc4l69s0dz8ef3zadykcwe7ax3dqrrh43w ?nostr:note1zhps6wp7rqchwlmp8s9wq3taramg849lczhds3h4wxvdm5vccc6qxa9zr8";
String content4 =
    "the driver c123ould mention the radius they want to be available at, so can the person searching, ratings could be based on WoT.  What do you think";
String content5 =
    "IIUC the23 geohash asdfasdf.png asdfasdf.jpg  description provided asdfasdf.mp4 here should work: https://github.com/sandwichfarm/nostr-geotags?tab=readme-ov-file#example-response  --&gt; the driver could mention the radius they want to be available at, so can the person searching, ratings could be based on WoT.  What do you think nostr:npub1arkn0xxxll4llgy9qxkrncn3vc4l69s0dz8ef3zadykcwe7ax3dqrrh43w ?nostr:note1zhps6wp7rqchwlmp8s9wq3taramg849lczhds3h4wxvdm5vccc6qxa9zr8";

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
    // await Moment.sharedInstance.init();
    initLocalData();
  }

  initLocalData() async {
    addMomentCallBack();
    // List<NoteDB>? contactsList = await Moment.sharedInstance.loadContactsNotes();
    // List<NoteDB>? privateList = await Moment.sharedInstance.loadPrivateNotes();
    // _changeListToMap(contactsList,contactsNotesMap);
    _changeListToMap(_mockData());
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

  _mockData(){
    List<String> contentList = [content1,content2,content3,content4,content5];
    List<NoteDB> list = contentList.map((String content) {
      var random = Random();
      int randomNumber = random.nextInt(1001);
      final note = NoteDB(
        noteId: randomNumber.toString(), //event id
        author: OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '',
        createAt: DateTime.now().millisecond,
        content: content,
        root: 'aa',
        private: true,
        replyCount: randomNumber,
        repostCount: randomNumber,
        reactionCount: randomNumber,
        zapCount: randomNumber,
        zapAmount: randomNumber,
      );
      return note;
    }).toList();
    return list;
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


NoteDB draftNoteDB = NoteDB(
  noteId: '12341234', //event id
  author: OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '',
  createAt: DateTime.now().millisecond,
  content: content1,
  root: 'aa',
  private: true,
  replyCount: 1,
  repostCount: 1,
  reactionCount: 1,
  zapCount: 1,
  zapAmount: 1,
);


