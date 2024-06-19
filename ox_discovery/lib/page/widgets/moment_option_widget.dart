import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/mixin/common_navigator_observer_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_moment_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/zaps/zaps_action_handler.dart';
import 'package:ox_discovery/page/moments/moment_zap_page.dart';
import 'package:ox_discovery/page/widgets/zap_done_animation.dart';
import 'package:ox_localizable/ox_localizable.dart';

import '../../enum/moment_enum.dart';
import '../../model/moment_ui_model.dart';
import '../moments/create_moments_page.dart';
import '../moments/reply_moments_page.dart';

import 'package:flutter/services.dart';
import 'package:nostr_core_dart/nostr.dart';



class MomentOptionWidget extends StatefulWidget {
  final ValueNotifier<NotedUIModel> notedUIModel;
  final bool isShowMomentOptionWidget;
  const MomentOptionWidget({super.key,required this.notedUIModel,this.isShowMomentOptionWidget = true});

  @override
  _MomentOptionWidgetState createState() => _MomentOptionWidgetState();
}

class _MomentOptionWidgetState extends State<MomentOptionWidget>
    with SingleTickerProviderStateMixin, NavigatorObserverMixin, OXMomentObserver {

  late ValueNotifier<NotedUIModel> notedUIModel;
  late final AnimationController _shakeController;
  bool _isShowAnimation = false;

  final List<EMomentOptionType> momentOptionTypeList = [
    EMomentOptionType.reply,
    EMomentOptionType.repost,
    EMomentOptionType.like,
    EMomentOptionType.zaps,
  ];


  @override
  void initState() {
    super.initState();
    OXMomentManager.sharedInstance.addObserver(this);
    _shakeController = AnimationController(duration:const Duration(milliseconds: 800),vsync: this);
    _shakeController.addListener(_resetAnimation);
    _init();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notedUIModel != oldWidget.notedUIModel) {
      _init();
    }
  }

  @override
  Future<void> didPopNext() async {
    if (_isShowAnimation) {
      await _shakeController.forward();
      _isShowAnimation = false;
      _updateNoteDB();
    }
  }

  @override
  didMyZapNotificationCallBack(List<NotificationDB> notifications) {
    final noteDB = widget.notedUIModel.value.noteDB;
    if (notifications.first.associatedNoteId == noteDB.noteId) {
      _isShowAnimation = true;
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _shakeController.removeListener(_resetAnimation);
    OXMomentManager.sharedInstance.removeObserver(this);
    super.dispose();
  }

  void _getMomentUserInfo()async {
    String pubKey = widget.notedUIModel.value.noteDB.author;
    await Account.sharedInstance.getUserInfo(pubKey);
    if(mounted){
      setState(() {});
    }
  }

  void _resetAnimation() {
    if(_shakeController.isCompleted) {
      _shakeController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.isShowMomentOptionWidget) return const SizedBox();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){},
      child: Container(
        height: 41.px,
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
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: momentOptionTypeList.map((EMomentOptionType type) {
            return ValueListenableBuilder<NotedUIModel>(
              valueListenable: widget.notedUIModel,
              builder: (context, model, child) => _showItemWidget(type,model),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _showItemWidget(EMomentOptionType type,NotedUIModel model){
    bool isZap = type == EMomentOptionType.zaps;
    Widget iconTextWidget = _iconTextWidget(
      type: type,
      isSelect: _isClickByMe(type,model),
      onTap: () => _onTapCallback(type)(),
      clickNum: _getClickNum(type,model),
    );
    if(isZap){
      return Expanded(
        child: ZapDoneAnimation(
          controller: _shakeController,
          child: iconTextWidget,
        ),
      );
    }
    return Expanded(child: iconTextWidget);
  }

  GestureTapCallback _onTapCallback(EMomentOptionType type) {
    switch (type) {
      case EMomentOptionType.reply:
        return () async{
          await OXNavigator.presentPage(context, (context) => ReplyMomentsPage(notedUIModel: notedUIModel),fullscreenDialog:true);
          _updateNoteDB();
        };
      case EMomentOptionType.repost:
        return () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => _buildBottomDialog());

      case EMomentOptionType.like:
        return () async {
          if(notedUIModel.value.noteDB.reactionCountByMe > 0) return;
          OKEvent event = await Moment.sharedInstance.sendReaction(notedUIModel.value.noteDB.noteId);
          if(event.status){
            _updateNoteDB();
            CommonToast.instance.show(context, Localized.text('ox_discovery.like_success_tips'));
          }
        };
      case EMomentOptionType.zaps:
        return _handleZap;
    }
  }

  Widget _iconTextWidget({
    required EMomentOptionType type,
    required bool isSelect,
    GestureTapCallback? onTap,
    int? clickNum,
  }) {
    final content = clickNum == null || clickNum == 0 ? type.text : clickNum.toString();
    Color textColors = isSelect ? ThemeColor.gradientMainStart : ThemeColor.color80;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
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
              OKEvent event =  await Moment.sharedInstance.sendRepost(notedUIModel.value.noteDB.noteId, null);
              if(event.status){
                _updateNoteDB();
                CommonToast.instance.show(context, Localized.text('ox_discovery.repost_success_tips'));
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
              OXNavigator.presentPage(context, (context) => CreateMomentsPage(type: EMomentType.quote,notedUIModel: notedUIModel));
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
              Localized.text('ox_common.cancel'),
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


  int _getClickNum(EMomentOptionType type,NotedUIModel model){
    NoteDB noteDB = model.noteDB;
    switch(type){
      case EMomentOptionType.repost:
       return (noteDB.repostCount) + (noteDB.quoteRepostCount);
      case EMomentOptionType.like:
        return noteDB.reactionCount;
      case EMomentOptionType.zaps:
        return noteDB.zapAmount;
      case EMomentOptionType.reply:
        return noteDB.replyCount;
    }
  }

  bool _isClickByMe(EMomentOptionType type,NotedUIModel model){
    NoteDB noteDB = model.noteDB;
    switch(type){
      case EMomentOptionType.repost:
        return noteDB.repostCountByMe > 0;
      case EMomentOptionType.like:
        return noteDB.reactionCountByMe > 0;
      case EMomentOptionType.zaps:
        return noteDB.zapAmountByMe > 0;
      case EMomentOptionType.reply:
        return noteDB.replyCountByMe > 0;
    }
  }

  void _init(){
    notedUIModel = widget.notedUIModel;
    _getMomentUserInfo();
    setState(() {});
  }


  void _updateNoteDB() async {
    NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(widget.notedUIModel.value.noteDB.noteId);
    if(note == null) return;
    if(mounted){
      setState(() {
        notedUIModel = ValueNotifier(NotedUIModel(noteDB: note));
      });
    }

  }

  _handleZap() async {
    UserDB? user = await Account.sharedInstance.getUserInfo(notedUIModel.value.noteDB.author);
    if(user == null) return;
    ZapsActionHandler handler = await ZapsActionHandler.create(
      userDB: user,
      isAssistedProcess: false,
      preprocessCallback: _zapsDoneCallback,
    );
    await handler.handleZap(context: context,);
  }

  _zapsDoneCallback() async {
    await _shakeController.forward();
    NoteDB newNote = widget.notedUIModel.value.noteDB;
    newNote.zapAmount = newNote.zapAmount + 3;
    if(mounted){
      setState(() {
        notedUIModel = ValueNotifier(NotedUIModel(noteDB: newNote));
      });
    }
    _isShowAnimation = true;
  }
}
