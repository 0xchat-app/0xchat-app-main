import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_discovery/utils/discovery_utils.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';
import '../../model/moment_ui_model.dart';
import '../../utils/moment_widgets_utils.dart';

class MomentInfo {
  final UserDB? userDB;
  final NotedUIModel? notedUIModel;
  MomentInfo({required this.userDB, required this.notedUIModel});
}

class HorizontalScrollWidget extends StatefulWidget {
  final List<String>? quoteList;
  final NotedUIModel? notedUIModel;
  final NotedUIModel? onlyShowNotedUIModel;

  const HorizontalScrollWidget({super.key, this.quoteList,this.notedUIModel,this.onlyShowNotedUIModel});

  @override
  _HorizontalScrollWidgetState createState() => _HorizontalScrollWidgetState();
}

class _HorizontalScrollWidgetState extends State<HorizontalScrollWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  double _height = 290;
  // List<MomentInfo> noteList = [];

  Map<String,MomentInfo> noteListMap = {};


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNoteList();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notedUIModel != oldWidget.notedUIModel || widget.quoteList != oldWidget.quoteList || widget.onlyShowNotedUIModel != oldWidget.onlyShowNotedUIModel) {
      _getNoteList();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.px,
      ),
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
          _setPageViewHeight(noteListMap.values.toList(), page);
          setState(() {
            _currentPage = page;
          });
        },
        children: _showNoteItemWidget(),
      ),
    );
  }

  List<Widget> _showNoteItemWidget() {
    double width = MediaQuery.of(context).size.width - 48;

    return noteListMap.values.toList().map((MomentInfo noteInfo) {
      NotedUIModel? notedUIModel = noteInfo.notedUIModel;
      UserDB? userDB = noteInfo.userDB;
      if(notedUIModel != null && userDB != null ){
        String text = notedUIModel.getMomentShowContent;
        bool isOneLine = _getTextLine(text) ==  1;
        return MomentWidgetsUtils.quoteMoment(
          context,
          userDB,
          notedUIModel,
          isOneLine,
          width
        );
      }

      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.px,
            color: ThemeColor.color160,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              11.5.px,
            ),
          ),
        ),
        child: Center(
          child: Text(
            'Reference not found !',
            style: TextStyle(
              color: ThemeColor.color100,
              fontSize: 16.px,
            ),
          ),
        ),
      );

    }).toList();
  }

  Widget _navigationControllerWidget() {
    List<MomentInfo> list =  noteListMap.values.toList();

    if (list.isEmpty ||  list.length == 1) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list.map((MomentInfo info) {
          int findIndex = list.indexOf(info);
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
    if(widget.onlyShowNotedUIModel == null){
      await _processQuoteList();
      await _processSingleNote();

    }else{
      UserDB? user = await Account.sharedInstance.getUserInfo(widget.onlyShowNotedUIModel!.noteDB.author);
      noteListMap[widget.onlyShowNotedUIModel!.noteDB.noteId] = MomentInfo(userDB: user, notedUIModel: widget.onlyShowNotedUIModel!);
    }
    _setPageViewHeight(noteListMap.values.toList(), 0);
    setState(() {});
  }

  Future<void> _processQuoteList() async {
    if (widget.quoteList != null) {
      var futures = <Future>[];
      for (String quote in widget.quoteList!) {
        futures.add(_processQuote(quote));
      }
      await Future.wait(futures);
    }
    setState(() {});
  }

  Future<void> _processQuote(String quote) async {
    final noteInfo = NoteDB.decodeNote(quote);
    if (noteInfo == null) return;
    NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(noteInfo['channelId']);
    if (note != null) {
      UserDB? user = await Account.sharedInstance.getUserInfo(note.author);
      if (user != null) {
        noteListMap[note.noteId] = MomentInfo(userDB: user, notedUIModel: NotedUIModel(noteDB: note));
      }
    } else {
      noteListMap[DateTime.now().millisecond.toString()] = MomentInfo(userDB: null, notedUIModel: null);
    }
    setState(() {});
  }

  Future<void> _processSingleNote() async {
    NotedUIModel? notedUIModel = widget.notedUIModel;

    if (notedUIModel != null) {

      NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(notedUIModel.noteDB.quoteRepostId ?? '');

      if (note != null) {
          UserDB? user = await Account.sharedInstance.getUserInfo(note.author);
          if (user != null) {
            noteListMap[note.noteId] = MomentInfo(userDB: user, notedUIModel: NotedUIModel(noteDB: note));
          }
      }
    }
  }

  int _getTextLine(String text) {
    double width = MediaQuery.of(context).size.width - 72;
    int line = DiscoveryUtils.getTextLine(text, width,12, null)['lineCount'];
    return line;
  }

  void _setPageViewHeight(List<MomentInfo> list, int index) {
    NotedUIModel? notedUIModel = list[index].notedUIModel;
    if(notedUIModel == null) {
      _height = 251;
      setState(() {});
      return;
    }

    bool isOneLine = _getTextLine(notedUIModel.getMomentShowContent) == 1;
    List<String> getImage = notedUIModel.getImageList;
    _height = getImage.isEmpty ? 78 + 35 : 251 + 35;
    if (list.length == 1) {
      _height  = _height -  35; // Navigation bar height
    }
    _height = isOneLine ? _height - 17 : _height; // Text height
    setState(() {});
  }
}
