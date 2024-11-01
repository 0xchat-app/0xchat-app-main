import 'package:chatcore/chat-core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

import '../../model/moment_ui_model.dart';
import '../../utils/discovery_utils.dart';

class ReplyContactWidget extends StatefulWidget {
  final NotedUIModel? notedUIModel;
  const ReplyContactWidget({super.key, required this.notedUIModel});

  @override
  _ReplyContactWidgetState createState() => _ReplyContactWidgetState();
}

class _ReplyContactWidgetState extends State<ReplyContactWidget> {
  String? noteAuthor;
  bool isShowReplyContactWidget = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMomentUser();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notedUIModel != oldWidget.notedUIModel) {
      _getMomentUser();
    }

    if(widget.notedUIModel != null && widget.notedUIModel != null && isShowReplyContactWidget && widget.notedUIModel!.noteDB.isReply){
      _getMomentUser();
    }
  }


  void _getMomentUser() async {
    NotedUIModel? model = widget.notedUIModel;
    if (model == null || !model.noteDB.isReply) {
      isShowReplyContactWidget = false;
      noteAuthor = null;
      setState(() {});
      return;
    }

    isShowReplyContactWidget = true;

    String? getReplyId = model.noteDB.getReplyId;

    if (getReplyId == null) {
      setState(() {});
      return;
    }

    NotedUIModel? notedUIModelCache = OXMomentCacheManager.getValueNotifierNoteToCache(getReplyId);
    if(notedUIModelCache != null){

      noteAuthor = (notedUIModelCache as NotedUIModel).noteDB.author;

      _getMomentUserInfo(notedUIModelCache as NotedUIModel);
      if (mounted) {
        setState(() {});
      }
      return;
    }

    NotedUIModel? replyNotifier = await OXMomentCacheManager.getValueNotifierNoted(
      getReplyId,
      isUpdateCache: true,
      notedUIModel: model,
    );

    if(replyNotifier == null){
      if(mounted){
        setState(() {});
      }
      return;
    }

    noteAuthor = (replyNotifier as NotedUIModel).noteDB.author;

    _getMomentUserInfo(replyNotifier as NotedUIModel);
    if (mounted) {
      setState(() {});
    }
  }

  void _getMomentUserInfo(NotedUIModel notedUIModel)async {
    String pubKey = notedUIModel.noteDB.author;
    await Account.sharedInstance.getUserInfo(pubKey);
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isShowReplyContactWidget) return const SizedBox();
    if(noteAuthor == null) return  _emptyNoteAuthorWidget();
    return ValueListenableBuilder<UserDBISAR>(
      valueListenable: Account.sharedInstance.getUserNotifier(noteAuthor!),
      builder: (context, value, child) {
        return RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          text: TextSpan(
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: 14.px,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(text: Localized.text('ox_discovery.reply_destination_title')),
              TextSpan(
                text: ' @${value.name ?? ''}',
                style: TextStyle(
                  color: ThemeColor.purple2,
                  fontSize: 12.px,
                  fontWeight: FontWeight.w400,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await OXModuleService.pushPage(
                        context, 'ox_chat', 'ContactUserInfoPage', {
                      'pubkey': noteAuthor,
                    });
                    setState(() {});
                  },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _emptyNoteAuthorWidget(){
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: TextStyle(
          color: ThemeColor.color0,
          fontSize: 14.px,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(text: Localized.text('ox_discovery.reply_destination_title')),
          TextSpan(
            text: ' @ ',
            style: TextStyle(
              color: ThemeColor.purple2,
              fontSize: 12.px,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
