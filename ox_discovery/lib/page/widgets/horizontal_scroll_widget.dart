import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_discovery/utils/discovery_utils.dart';
import 'package:ox_discovery/utils/moment_content_analyze_utils.dart';
import '../../model/moment_extension_model.dart';
import '../../model/moment_ui_model.dart';
import '../../utils/moment_widgets_utils.dart';
import 'moment_quote_widget.dart';

class HorizontalScrollWidget extends StatefulWidget {
  final ValueNotifier<NotedUIModel>? notedUIModel;
  final ValueNotifier<NotedUIModel>? onlyShowNotedUIModel;

  const HorizontalScrollWidget(
      {super.key, this.notedUIModel, this.onlyShowNotedUIModel});

  @override
  _HorizontalScrollWidgetState createState() => _HorizontalScrollWidgetState();
}

class _HorizontalScrollWidgetState extends State<HorizontalScrollWidget> {
  // List<MomentInfo> noteList = [];

  Map<String, NotedUIModel?> noteListMap = {};
  NotedUIModel? notedUIModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNoteList();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notedUIModel != oldWidget.notedUIModel ||
        widget.onlyShowNotedUIModel != oldWidget.onlyShowNotedUIModel) {
      if (mounted) {
        setState(() {
          noteListMap = {};
        });
      }
      _getNoteList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.px,
      ),
      child: _pageViewWidget(),
    );
  }

  Widget _pageViewWidget() {
    return _showNoteItemWidget();
  }

  Widget _showNoteItemWidget() {
    if (notedUIModel == null) return const SizedBox();
    double width = MediaQuery.of(context).size.width - 48;
    return MomentQuoteWidget(
        notedUIModel: notedUIModel!, isOneLine: false, width: width);
  }

  void _getNoteList() async {
    if (widget.onlyShowNotedUIModel == null) {
      List<String> noteId = [];

      NotedUIModel? notedUIModel = widget.notedUIModel?.value;
      if (notedUIModel != null && notedUIModel.noteDB.isQuoteRepost) {
        noteId.add(notedUIModel.noteDB.quoteRepostId!);
      }

      for (String id in noteId) {
        _processQuote(id);
      }
    } else {
      notedUIModel = widget.onlyShowNotedUIModel!.value;
    }

    if (mounted) {
      setState(() {});
    }
  }

  _processQuote(String noteId) async {
    if (NotedUIModelCache.map[noteId] == null) {
      NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(noteId);
      if (note == null) {
        noteListMap[DateTime.now().millisecond.toString()] = null;
        if (mounted) {
          setState(() {});
        }
        return;
      }
      NotedUIModelCache.map[noteId] = NotedUIModel(noteDB: note);
    }

    NotedUIModel newNoted = NotedUIModelCache.map[noteId]!;
    notedUIModel = newNoted;
    if (mounted) {
      setState(() {});
    }
  }

  // int _getTextLine(String text) {
  //   if (mounted) {
  //     double width = MediaQuery.of(context).size.width - 72;
  //     int line = DiscoveryUtils.getTextLine(text, width, 12, null)['lineCount'];
  //     return line;
  //   }
  //   return 1;
  // }
}
