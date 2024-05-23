import 'package:chatcore/chat-core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_module_service/ox_module_service.dart';

import '../../model/moment_ui_model.dart';

class ReplyContactWidget extends StatefulWidget {
  final ValueNotifier<NotedUIModel>? notedUIModel;
  const ReplyContactWidget({super.key, required this.notedUIModel});

  @override
  _ReplyContactWidgetState createState() => _ReplyContactWidgetState();
}

class _ReplyContactWidgetState extends State<ReplyContactWidget> {
  UserDB? momentUserDB;
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
  }

  void _getMomentUser() async {
    NotedUIModel? model = widget.notedUIModel?.value;
    if (model == null || !model.noteDB.isReply) {
      isShowReplyContactWidget = false;
      momentUserDB = null;
      setState(() {});
      return;
    }
    isShowReplyContactWidget = true;
    if (mounted) {
      setState(() {});
    }
    String? getReplyId = model.noteDB.getReplyId;

    if (getReplyId == null) return;

    if (NotedUIModelCache.map[getReplyId] == null) {
      NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(getReplyId);
      if (note == null) return;
      NotedUIModelCache.map[getReplyId] = NotedUIModel(noteDB: note);
    }

    noteAuthor = NotedUIModelCache.map[getReplyId]!.noteDB.author;
    UserDB? user = await Account.sharedInstance.getUserInfo(noteAuthor!);

    momentUserDB = user;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isShowReplyContactWidget) return const SizedBox();
    return ValueListenableBuilder<UserDB>(
        valueListenable: Account.sharedInstance.userCache[noteAuthor] ??
            ValueNotifier(UserDB(pubKey: noteAuthor ?? '')),
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
                const TextSpan(text: 'Reply to'),
                TextSpan(
                  text: ' @${value.name ?? ''}',
                  style: TextStyle(
                    color: ThemeColor.purple2,
                    fontSize: 12.px,
                    fontWeight: FontWeight.w400,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (momentUserDB == null) return;
                      await OXModuleService.pushPage(
                          context, 'ox_chat', 'ContactUserInfoPage', {
                        'pubkey': momentUserDB?.pubKey,
                      });
                      setState(() {});
                    },
                ),
              ],
            ),
          );
        });
  }
}
