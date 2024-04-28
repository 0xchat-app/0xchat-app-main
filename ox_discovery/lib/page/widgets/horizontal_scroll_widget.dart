import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_discovery/utils/discovery_utils.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';
import '../../utils/moment_widgets_utils.dart';

class MomentInfo {
  final UserDB userDB;
  final NoteDB noteDB;
  MomentInfo({required this.userDB, required this.noteDB});
}

class HorizontalScrollWidget extends StatefulWidget {
  final List<String>? quoteList;
  final NoteDB? noteDB;
  const HorizontalScrollWidget({super.key, this.quoteList,this.noteDB});

  @override
  _HorizontalScrollWidgetState createState() => _HorizontalScrollWidgetState();
}

class _HorizontalScrollWidgetState extends State<HorizontalScrollWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  double _height = 290;
  List<MomentInfo> noteList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNoteList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height.px,
      child: Column(
        children: <Widget>[
          _pageViewWidget(),
          _navigationControllerWidget(),
        ],
      ),
    );
  }

  Widget _pageViewWidget(){
    return Expanded(
      child: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          _setPageViewHeight(noteList, page);
          setState(() {
            _currentPage = page;
          });
        },
        children: _showNoteItemWidget(),
      ),
    );
  }

  List<Widget> _showNoteItemWidget() {
    return noteList.map((MomentInfo noteInfo) {
      String text = MomentContentAnalyzeUtils((noteInfo.noteDB.content)).getMomentShowContent;
      bool isOneLine = _getTextLine(text) > 1;
      return MomentWidgetsUtils.quoteMoment(
        noteInfo.userDB,
        noteInfo.noteDB,
        isOneLine,
      );
    }).toList();
  }

  Widget _navigationControllerWidget() {
    if (noteList.isEmpty ||  noteList.length == 1) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: noteList.map((MomentInfo info) {
          int findIndex = noteList.indexOf(info);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 10,
            width: (findIndex == _currentPage) ? 30 : 10,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: (findIndex == _currentPage)
                  ? ThemeColor.color100
                  : ThemeColor.color100.withOpacity(0.5),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _getNoteList() async {
    List<String>? quoteList = widget.quoteList;
    NoteDB? noteDB = widget.noteDB;
    if(quoteList != null){
      for (String quote in quoteList) {
        final noteInfo = NoteDB.decodeNote(quote);
        if (noteInfo == null) continue;

        NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(noteInfo['channelId']);
        if (note != null) {
          UserDB? user = await Account.sharedInstance.getUserInfo(note.author);
          if (user != null) {
            noteList.add(MomentInfo(userDB: user, noteDB: note));
          }
        }
      }
    }

    if(noteDB != null){
      UserDB? user = await Account.sharedInstance.getUserInfo(noteDB.author);
      if (user != null) {
        noteList.add(MomentInfo(userDB: user, noteDB: noteDB));
      }
    }

    _setPageViewHeight(noteList, 0);

    setState(() {});
  }


  int _getTextLine(String text) {
    double width = MediaQuery.of(context).size.width - 60;
    int line = DiscoveryUtils.getTextLine(text, width, null)['lineCount'];
    return line;
  }

  void _setPageViewHeight(List<MomentInfo> list, int index) {
    MomentContentAnalyzeUtils utils = MomentContentAnalyzeUtils((list[index].noteDB.content));
    bool isOneLine = _getTextLine(utils.getMomentShowContent) > 1;
    List<String> getImage = utils.getMediaList(1);
    _height = getImage.isEmpty ? 120 : 300;
    if (list.length == 1) {
      _height -= 35; // Navigation bar height
    }
    _height = isOneLine ? _height - 17 : _height; // Text height
    _height  = _height + 5;
    setState(() {});
  }
}
