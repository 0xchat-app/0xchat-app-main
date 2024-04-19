import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';

import '../../utils/moment_widgets_utils.dart';

class HorizontalScrollWidget extends StatefulWidget {
  final List<String> quoteList;
  const HorizontalScrollWidget({super.key, required this.quoteList});

  @override
  _HorizontalScrollWidgetState createState() => _HorizontalScrollWidgetState();
}

class _HorizontalScrollWidgetState extends State<HorizontalScrollWidget> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<Map<String, dynamic>> noteList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNoteList();
  }

  void _getNoteList() async {
    for (String quote in widget.quoteList) {
      final noteInfo = NoteDB.decodeNote(quote);
      NoteDB? note =
          await Moment.sharedInstance.loadNote(noteInfo!['channelId']);

      if (note != null) {
        UserDB? user = await Account.sharedInstance.getUserInfo(note.author);
        if (user != null) {
          noteList.add({'userDB': user, 'noteDB': note});
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290.px,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: noteList.map((Map<String, dynamic> noteInfoMap) {
                return MomentWidgetsUtils.quoteMoment(
                    noteInfoMap['userDB'], noteInfoMap['noteDB']);
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: noteList.map((Map<String, dynamic> info) {
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
          ),
        ],
      ),
    );
  }
}
