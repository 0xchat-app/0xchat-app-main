import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_discovery/model/moment_ui_model.dart';

import '../../enum/moment_enum.dart';
import '../../utils/discovery_utils.dart';
import '../../utils/moment_widgets_utils.dart';

class MomentOptionUserPage extends StatefulWidget {
  final NotedUIModel notedUIModel;
  final ENotificationsMomentType type;

  const MomentOptionUserPage(
      {super.key, required this.notedUIModel, required this.type});

  @override
  State<MomentOptionUserPage> createState() => _MomentOptionUserPageState();
}

class _MomentOptionUserPageState extends State<MomentOptionUserPage> {
  List<NotedUIModel> showUserDBList = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    Map<String, List<dynamic>> replyEventIdsList = await Moment.sharedInstance
        .loadNoteActions(widget.notedUIModel.noteDB.noteId);

    showUserDBList = _getUserList(replyEventIdsList);
    setState(() {});
  }

  List<NotedUIModel> _getUserList(Map<String, List<dynamic>> mapInfo) {
    print('===list=======${mapInfo}===$ZapRecordsDB');
    List<NoteDB> list = [];
    switch (widget.type) {
      case ENotificationsMomentType.zaps:
        list = (mapInfo['zap'] as List<NoteDB>);
        break;
      case ENotificationsMomentType.repost:
        list = (mapInfo['repost'] as List<NoteDB>);
        break;
      case ENotificationsMomentType.quote:
        list = (mapInfo['quoteRepost'] as List<NoteDB>);
        break;
      case ENotificationsMomentType.like:
        list = (mapInfo['reaction'] as List<NoteDB>);
        break;
    }

    return list.map((NoteDB noteDB) => NotedUIModel(noteDB: noteDB)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        title: '${widget.type.text} By',
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  left: 20.px,
                  right: 20.px,
                  bottom: 100.px,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: showUserDBList
                      .map(
                        (NotedUIModel notedUIModel) => MomentUserItemWidget(
                          notedUIModel: notedUIModel,
                          type: widget.type,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MomentUserItemWidget extends StatefulWidget {
  final NotedUIModel notedUIModel;
  final ENotificationsMomentType type;
  const MomentUserItemWidget(
      {super.key, required this.notedUIModel, required this.type});

  @override
  State<MomentUserItemWidget> createState() => _MomentUserItemWidgetState();
}

class _MomentUserItemWidgetState extends State<MomentUserItemWidget> {
  UserDB? user;
  NotedUIModel? notedUIModel;
  @override
  void initState() {
    super.initState();
    _getUserList();
  }

  void _getUserList() async {
    if(widget.notedUIModel.noteDB.isRepost){
      NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(widget.notedUIModel.noteDB.repostId!);
      if(note != null){
        notedUIModel = NotedUIModel(noteDB: note);
      }
    }else{
      notedUIModel = widget.notedUIModel;
    }
    setState(() {});
    _getUserDB(widget.notedUIModel.noteDB.author);

  }

  void _getUserDB(String pubKey)async{
    UserDB? userDB = await Account.sharedInstance.getUserInfo(pubKey);
    if (userDB != null) {
      user = userDB;
      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    if (user == null || notedUIModel == null) return const SizedBox();
    return _userItemWidget();
  }

  Widget _userItemWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12.px,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MomentWidgetsUtils.clipImage(
            borderRadius: 60.px,
            imageSize: 60.px,
            child: OXCachedNetworkImage(
              imageUrl: user?.picture ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  MomentWidgetsUtils.badgePlaceholderImage(),
              errorWidget: (context, url, error) =>
                  MomentWidgetsUtils.badgePlaceholderImage(),
              width: 60.px,
              height: 60.px,
            ),
          ).setPaddingOnly(right: 16.px),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    bottom: 4.px,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? '--',
                              style: TextStyle(
                                color: ThemeColor.color10,
                                fontSize: 16.px,
                                fontWeight: FontWeight.w600,
                              ),
                            ).setPaddingOnly(bottom: 4.px),
                            Text(
                              DiscoveryUtils.getUserMomentInfo(user, '0')[1],
                              style: TextStyle(
                                color: ThemeColor.color120,
                                fontSize: 12.px,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {},
                        child: Container(
                          width: 90.px,
                          height: 30.px,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: ThemeColor.color180,
                            gradient: LinearGradient(
                              colors: [
                                ThemeColor.gradientMainEnd,
                                ThemeColor.gradientMainStart,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.px,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Text(
                    notedUIModel?.getMomentShowContent ?? '',
                    style: TextStyle(
                      color: ThemeColor.color0,
                      fontSize: 12.px,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
