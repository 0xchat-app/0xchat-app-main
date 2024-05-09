import 'package:chatcore/chat-core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_module_service/ox_module_service.dart';

import '../../model/moment_ui_model.dart';

class ReplyContactWidget extends StatefulWidget {
  final NotedUIModel? notedUIModel;
  const ReplyContactWidget({super.key, required this.notedUIModel});

  @override
  _ReplyContactWidgetState createState() => _ReplyContactWidgetState();
}

class _ReplyContactWidgetState extends State<ReplyContactWidget> {
  UserDB? momentUserDB;

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
    NotedUIModel? model = widget.notedUIModel;

    if(model == null || !model.noteDB.isReply || model.noteDB.root == null) {
      momentUserDB = null;
      setState(() {});
      return;
    }

    NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(model.noteDB.root!);
    if(note == null) return;
    UserDB? user = await Account.sharedInstance.getUserInfo(note.author);
    momentUserDB = user;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(momentUserDB == null) return const SizedBox();
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
            text: ' @${momentUserDB?.name}',
            style: TextStyle(
              color: ThemeColor.purple2,
              fontSize: 12.px,
              fontWeight: FontWeight.w400,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
                  'pubkey': momentUserDB?.pubKey,
                });
              },
          ),
        ],
      ),
    );;
  }
}
