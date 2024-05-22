import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';

import 'package:ox_discovery/page/widgets/moment_widget.dart';

import '../../model/moment_ui_model.dart';
import '../moments/moments_page.dart';

class MomentReplyAbbreviateWidget extends StatefulWidget {
  final bool isShowReplyWidget;
  final ValueNotifier<NotedUIModel> notedUIModel;
  const MomentReplyAbbreviateWidget(
      {super.key, required this.notedUIModel, this.isShowReplyWidget = false});

  @override
  _MomentReplyAbbreviateWidgetState createState() =>
      _MomentReplyAbbreviateWidgetState();
}

class _MomentReplyAbbreviateWidgetState
    extends State<MomentReplyAbbreviateWidget> {
  ValueNotifier<NotedUIModel>? notedUIModel;

  @override
  void initState() {
    super.initState();
    _getNotedUIModel();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notedUIModel != oldWidget.notedUIModel) {
      _getNotedUIModel();
    }
  }

  void _getNotedUIModel() async {
    ValueNotifier<NotedUIModel> notedUIModelDraft = widget.notedUIModel;
    if (!notedUIModelDraft.value.noteDB.isReply || !widget.isShowReplyWidget) {
      // Preventing a bug where the internal component fails to update in a timely manner when the outer ListView.builder array is updated with a non-reply note.
      notedUIModel = null;
      setState(() {});
      return;
    }
    String? replyId = notedUIModelDraft.value.noteDB.getReplyId;
    if (replyId == null) return;
    NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(replyId);
    if (note == null) return;
    notedUIModel = ValueNotifier(NotedUIModel(noteDB: note));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<NotedUIModel>? model = notedUIModel;
    if (!widget.isShowReplyWidget || model == null) return const SizedBox();
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.px,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.px),
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
      child: MomentWidget(
        notedUIModel: model,
        isShowMomentOptionWidget: false,
        clickMomentCallback: (ValueNotifier<NotedUIModel> notedUIModel) async {
          await OXNavigator.pushPage(
              context, (context) => MomentsPage(notedUIModel: notedUIModel));
        },
      ),
    );
  }
}
