import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';

import 'package:ox_discovery/page/widgets/moment_widget.dart';

import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';
import '../../utils/moment_widgets_utils.dart';
import '../moments/moments_page.dart';
import 'moment_rich_text_widget.dart';

class MomentQuoteWidget extends StatefulWidget {
  final String notedId;

  const MomentQuoteWidget(
      {super.key, required this.notedId});

  @override
  MomentQuoteWidgetState createState() =>
      MomentQuoteWidgetState();
}

class MomentQuoteWidgetState extends State<MomentQuoteWidget> {

  UserDB? momentUser;

  NotedUIModel? notedUIModel;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notedId != oldWidget.notedId) {
      _initData();
    }
  }


  @override
  Widget build(BuildContext context) {
    return quoteMoment();
  }

  void _initData()async{
    String notedId = widget.notedId;
    if(NotedUIModelCache.map[notedId] == null){
      NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(notedId);
      if(note == null) return;
      NotedUIModel newNotedModel = NotedUIModel(noteDB: note);
      NotedUIModelCache.map[notedId] = newNotedModel;
    }

    notedUIModel = NotedUIModelCache.map[notedId];
    _getMomentUser(NotedUIModelCache.map[notedId]!);
    if(mounted){
      setState(() {});
    }
  }

  void _getMomentUser(NotedUIModel notedUIModel) async {
    UserDB? user = await Account.sharedInstance.getUserInfo(notedUIModel.noteDB.author);
    momentUser = user;
    if(mounted){
      setState(() {});
    }
  }

  Widget _getImageWidget() {
    NotedUIModel? model = notedUIModel;
    if(model == null) return const SizedBox();
    List<String> _getImagePathList = model.getImageList;
    if (_getImagePathList.isEmpty) return const SizedBox();
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(11.5.px),
        topRight: Radius.circular(11.5.px),
      ),
      child: Container(
        height: 172.px,
        color: ThemeColor.color100,
        child: OXCachedNetworkImage(
          imageUrl: _getImagePathList[0],
          fit: BoxFit.cover,
          placeholder: (context, url) => MomentWidgetsUtils.badgePlaceholderContainer(height:172,),
          errorWidget: (context, url, error) => MomentWidgetsUtils.badgePlaceholderContainer(size:172,),
          height: 172.px,
        ),
      ),
    );
  }

  Widget quoteMoment() {
    NotedUIModel? model = notedUIModel;
    if(model == null) return _emptyNotedWidget();
    return GestureDetector(
      onTap: () {
        OXNavigator.pushPage(
            context, (context) => MomentsPage(notedUIModel: ValueNotifier(model)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.px),
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
        child: Column(
          children: [
            _getImageWidget(),
            Container(
              padding: EdgeInsets.all(12.px),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      MomentWidgetsUtils.clipImage(
                        borderRadius: 40.px,
                        imageSize: 40.px,
                        child: OXCachedNetworkImage(
                          imageUrl: momentUser?.picture ?? '',
                          fit: BoxFit.cover,
                          width: 20.px,
                          height: 20.px,
                          placeholder: (context, url) => MomentWidgetsUtils.badgePlaceholderImage(size:20),
                          errorWidget: (context, url, error) => MomentWidgetsUtils.badgePlaceholderImage(size:20),
                        ),
                      ),
                      Text(
                        momentUser?.name ?? '--',
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.w500,
                          color: ThemeColor.color0,
                        ),
                      ).setPadding(
                        EdgeInsets.symmetric(
                          horizontal: 4.px,
                        ),
                      ),
                      Text(
                        DiscoveryUtils.getUserMomentInfo(momentUser, model.createAtStr)[0],
                        style: TextStyle(
                          fontSize: 12.px,
                          fontWeight: FontWeight.w400,
                          color: ThemeColor.color120,
                        ),
                      )
                    ],
                  ).setPaddingOnly(bottom: 4.px),
                  MomentRichTextWidget(
                    text: model.noteDB.content,
                    textSize: 12.px,
                    maxLines: 1,
                    isShowAllContent: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyNotedWidget(){
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
  }
}

// void _getNoteList() async {
//   if (widget.onlyShowNotedUIModel == null) {
//     List<String> noteId = [];
//     for (String quote in widget.quoteList!) {
//       final noteInfo = NoteDB.decodeNote(quote);
//       if (noteInfo == null) return;
//       noteId.add(quote);
//     }
//
//     NotedUIModel? notedUIModel = widget.notedUIModel?.value;
//     if (notedUIModel != null && notedUIModel.noteDB.isQuoteRepost) {
//       noteId.add(notedUIModel.noteDB.quoteRepostId!);
//     }
//
//     for (String id in noteId) {
//       _processQuote(id);
//     }
//   } else {
//     noteListMap[widget.onlyShowNotedUIModel!.value.noteDB.noteId] = widget.onlyShowNotedUIModel!.value;
//   }
//
//   if (mounted) {
//     _setPageViewHeight(noteListMap.values.toList(), 0);
//     setState(() {});
//   }
// }
//
// _processQuote(String noteId) async {
//   if (NotedUIModelCache.map[noteId] == null) {
//     NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(noteId);
//     if (note == null) {
//       noteListMap[DateTime.now().millisecond.toString()] = null;
//       if (mounted) {
//         setState(() {});
//       }
//       return;
//     }
//     NotedUIModelCache.map[noteId] = NotedUIModel(noteDB: note);
//   }
//
//   NotedUIModel newNoted = NotedUIModelCache.map[noteId]!;
//
//   noteListMap[noteId] = newNoted;
//   if (mounted) {
//     setState(() {});
//   }
// }
