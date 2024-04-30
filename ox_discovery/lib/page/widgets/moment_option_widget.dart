import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';

import '../../enum/moment_enum.dart';
import '../moments/create_moments_page.dart';
import '../moments/reply_moments_page.dart';

import 'package:flutter/services.dart';
import 'package:nostr_core_dart/nostr.dart';



class MomentOptionWidget extends StatefulWidget {
  final NoteDB noteDB;
  const MomentOptionWidget({super.key,required this.noteDB});

  @override
  _MomentOptionWidgetState createState() => _MomentOptionWidgetState();
}

class _MomentOptionWidgetState extends State<MomentOptionWidget> {

  late NoteDB noteDB;

  final List<EMomentOptionType> momentOptionTypeList = [
    EMomentOptionType.reply,
    EMomentOptionType.repost,
    EMomentOptionType.like,
    EMomentOptionType.zaps,
  ];


  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              Adapt.px(8),
            ),
          ),
          color: ThemeColor.color180,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.px,
          vertical: 12.px,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: momentOptionTypeList.map((EMomentOptionType type) {

            return _iconTextWidget(
              type: type,
              isSelect: _getClickNum(type) > 0,
              onTap: () {
                _onTapCallback(type)();
              },
              clickNum: _getClickNum(type),
            );
          }).toList(),
        ),
      ),
    );
  }

  GestureTapCallback _onTapCallback(EMomentOptionType type) {
    switch (type) {
      case EMomentOptionType.reply:
        return () async{
          await OXNavigator.pushPage(context, (context) => ReplyMomentsPage(noteDB: noteDB));
          _updateNoteDB();
        };
      case EMomentOptionType.repost:
        return () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => _buildBottomDialog());

      case EMomentOptionType.like:
        return () async {
          if(noteDB.reactionCountByMe > 0) return;
          OKEvent event = await Moment.sharedInstance.sendReaction(noteDB.noteId);
          if(event.status){
            _updateNoteDB();
            CommonToast.instance.show(context, 'reaction success !');
          }
        };
      case EMomentOptionType.zaps:
        return () {};
    }
  }

  Widget _iconTextWidget({
    required EMomentOptionType type,
    required bool isSelect,
    GestureTapCallback? onTap,
    int? clickNum,
  }) {
    final content =
        clickNum == null || clickNum == 0 ? type.text : clickNum.toString();
    Color textColors = isSelect ? ThemeColor.gradientMainStart : ThemeColor.color80;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: 4.px,
            ),
            child: CommonImage(
              iconName: type.getIconName,
              size: 16.px,
              package: 'ox_discovery',
              color: textColors,
            ),
          ),
          Text(
            content,
            style: TextStyle(
              color: textColors,
              fontSize: 12.px,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomDialog() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            EMomentQuoteType.repost,
            index: 0,
            onTap: () async {
              OXNavigator.pop(context);
              OKEvent event =  await Moment.sharedInstance.sendRepost(noteDB.noteId, null);
              if(event.status){
                _updateNoteDB();
                CommonToast.instance.show(context, 'repost success !');
              }
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            EMomentQuoteType.quote,
            index: 1,
            onTap: () {
              OXNavigator.pop(context);
              OXNavigator.presentPage(context, (context) => CreateMomentsPage(type: EMomentType.quote,noteDB: noteDB));
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            EMomentQuoteType.share,
            index: 1,
            onTap: () {
              OXNavigator.pop(context);
              OXNavigator.presentPage(
                context,
                (context) => CreateMomentsPage(type: EMomentType.quote),
              );
            },
          ),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          GestureDetector(
            onTap: () {
              OXNavigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: Adapt.px(16),
                fontWeight: FontWeight.w400,
              ),
            ),
          ).setPadding(EdgeInsets.symmetric(
            vertical: 10.px,
          )),
          SizedBox(
            height: Adapt.px(21),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    EMomentQuoteType type, {
    required int index,
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: Adapt.px(56),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImage(
              iconName: type.getIconName,
              size: 24.px,
              package: 'ox_discovery',
              color: ThemeColor.color0,
            ),
            SizedBox(
              width: 10.px,
            ),
            Text(
              type.text,
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: Adapt.px(16),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  int _getClickNum(EMomentOptionType type){
    switch(type){
      case EMomentOptionType.repost:
       return noteDB.repostEventIds?.length ?? 0;
      case EMomentOptionType.like:
        return noteDB.reactionEventIds?.length ?? 0;
      case EMomentOptionType.zaps:
        return noteDB.zapEventIds?.length ?? 0;
      case EMomentOptionType.reply:
        return noteDB.replyEventIds?.length ?? 0;
    }
  }

  void _init(){
    noteDB = widget.noteDB;
    setState(() {});
  }


  void _updateNoteDB() async {
    NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(widget.noteDB.noteId);
    if(note == null) return;
    setState(() {
      noteDB = note;
    });
  }
}
