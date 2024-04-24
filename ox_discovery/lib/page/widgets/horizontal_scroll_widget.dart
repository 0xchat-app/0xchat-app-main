import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';

import '../../utils/moment_widgets_utils.dart';

class MomentInfo{
  final UserDB userDB;
  final NoteDB noteDB;
  MomentInfo({required this.userDB,required this.noteDB});
}

class HorizontalScrollWidget extends StatefulWidget {
  final List<String> quoteList;
  const HorizontalScrollWidget({super.key, required this.quoteList});

  @override
  _HorizontalScrollWidgetState createState() => _HorizontalScrollWidgetState();
}

class _HorizontalScrollWidgetState extends State<HorizontalScrollWidget> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  double _height = 290;
  List<MomentInfo> noteList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNoteList();

  }

  void _getNoteList() async {
    for (String quote in widget.quoteList) {
      final noteInfo = NoteDB.decodeNote(quote);

      if(noteInfo == null) continue;
      NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(noteInfo['channelId']);
      if (note != null) {
        UserDB? user = await Account.sharedInstance.getUserInfo(note.author);
        if (user != null) {
          noteList.add(MomentInfo(userDB: user,noteDB: note));
        }
      }
    }
    _setPageViewHeight(noteList,0);

    setState(() {});
  }

  void _setPageViewHeight(List<MomentInfo> list,int index){
    final textPainter = TextPainter(
      text: TextSpan(text: MomentContentAnalyzeUtils((list[index].noteDB.content)).getMomentShowContent.trim(), style: TextStyle(fontSize: 16.0)), // 设定文本样式
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 60);
    bool isOneLine = textPainter.didExceedMaxLines;
    List<String> getImage = MomentContentAnalyzeUtils((list[index].noteDB.content)).getMediaList(1);
    _height = getImage.isEmpty ? 120 : 300;
    if(list.length == 1){
      _height -= 35;
    }
    _height = isOneLine ? _height - 17 : _height;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height.px,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                _setPageViewHeight(noteList,page);
                setState(() {
                  _currentPage = page;
                });
              },
              children: noteList.map((MomentInfo noteInfo) {
                final textPainter = TextPainter(
                  text: TextSpan(text: MomentContentAnalyzeUtils((noteInfo.noteDB.content)).getMomentShowContent.trim(), style: TextStyle(fontSize: 16.0)), // 设定文本样式
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                );
                textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 60);
                bool isOneLine = textPainter.didExceedMaxLines;
                return MomentWidgetsUtils.quoteMoment(
                    noteInfo.userDB, noteInfo.noteDB,isOneLine);
              }).toList(),
            ),
          ),
          noteList.length > 1 ? Container(
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
          ) : SizedBox(),
        ],
      ),
    );
  }
}
