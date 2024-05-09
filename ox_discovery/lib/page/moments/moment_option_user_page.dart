import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/model/moment_extension_model.dart';
import 'package:ox_discovery/model/moment_ui_model.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
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
    List<dynamic> list = [];
    switch (widget.type) {
      case ENotificationsMomentType.zaps:
        list = (mapInfo['zap'] as List<ZapRecordsDB>);
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

    return list.map((dynamic noteDB) {
      if(widget.type == ENotificationsMomentType.zaps){
        String content = 'Zaps +${ZapRecordsDB.getZapAmount(noteDB.bolt11)}';
        return NotedUIModel(noteDB: NoteDB(author: (noteDB as ZapRecordsDB).sender,content: content ));
      }
     return NotedUIModel(noteDB: noteDB);
    }).toList();
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
                  children: [
                    _noDataWidget(),
                    ...showUserDBList.map(
                    (dynamic item) {
                // ZapRecordsDB
                return MomentUserItemWidget(
                wrapNotedUIModel: widget.notedUIModel,
                notedUIModel: item,
                type: widget.type,
              );
            },
            ).toList()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noDataWidget() {
    if(showUserDBList.isNotEmpty)  return const SizedBox();
    return Padding(
      padding: EdgeInsets.only(
        top: 100.px,
      ),
      child: Center(
        child: Column(
          children: [
            CommonImage(
              iconName: 'icon_no_data.png',
              width: Adapt.px(90),
              height: Adapt.px(90),
            ),
            Text(
              'No ${widget.type.text} !',
              style: TextStyle(
                fontSize: 16.px,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color100,
              ),
            ).setPaddingOnly(
              top: 24.px,
            ),
          ],
        ),
      ),
    );
  }
}

class MomentUserItemWidget extends StatefulWidget {
  final NotedUIModel wrapNotedUIModel;
  final NotedUIModel notedUIModel;
  final ENotificationsMomentType type;
  const MomentUserItemWidget(
      {super.key, required this.notedUIModel, required this.type,required this.wrapNotedUIModel});

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
    if (widget.type == ENotificationsMomentType.repost) {
      _initReposted();
    }

    if (widget.type == ENotificationsMomentType.like) {
      _initLike();
    }

    if (widget.type == ENotificationsMomentType.quote) {
      notedUIModel = widget.notedUIModel;
      _getUserDB(widget.notedUIModel.noteDB.author);
    }

    if (widget.type == ENotificationsMomentType.zaps) {
      notedUIModel = widget.notedUIModel;
      _getUserDB(widget.notedUIModel.noteDB.author);
    }
  }

  void _initReposted() async {
    NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(widget.notedUIModel.noteDB.repostId!);
    if (note != null) {
      NotedUIModel newNoted = NotedUIModel(noteDB: note);
      notedUIModel = newNoted;
      _getUserDB(widget.notedUIModel.noteDB.author);
    }
  }

  void _initLike() async {
    if(widget.wrapNotedUIModel.noteDB.isRepost){
      NoteDB? note = await Moment.sharedInstance.loadNoteWithNoteId(widget.wrapNotedUIModel.noteDB.repostId!);
      if (note != null) {
        NotedUIModel newNoted = NotedUIModel(noteDB: note);
        notedUIModel = newNoted;

      }
    }else{
      notedUIModel = widget.wrapNotedUIModel;
    }
    _getUserDB(widget.notedUIModel.noteDB.author);
  }

  void _getUserDB(String pubKey) async {
    UserDB? userDB = await Account.sharedInstance.getUserInfo(pubKey);
    if (userDB != null) {
      user = userDB;
      setState(() {});
    }
  }

  String get _getContent{
    return notedUIModel?.getMomentShowContent ?? '';
  }

  @override
  Widget build(BuildContext context) {
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
          GestureDetector(
            onTap: () {
              if(user == null) return;
              OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
                'pubkey':user?.pubKey ?? '',
              });
            },
            child: MomentWidgetsUtils.clipImage(
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
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      _addFriendWidget(),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // if(widget.type == ENotificationsMomentType.quote){
                    //     // OXNavigator.pushPage(context, (context) => null)
                    // }
                  },
                  child: Container(
                    child: Text(
                      _getContent,
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: 12.px,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addFriendWidget(){
    UserDB? userDB = user;
    if(userDB == null || isFriend(userDB.pubKey)) return const SizedBox();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _addFriends,
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
    );
  }



  void _addFriends() async {
    UserDB? userDB = user;
    if(userDB == null) return;

    if (isFriend(userDB.pubKey) == false) {
      OXCommonHintDialog.show(context,
          content: Localized.text('ox_chat.add_contact_dialog_title'),
          actionList: [
            OXCommonHintAction.cancel(onTap: () {
              OXNavigator.pop(context, false);
            }),
            OXCommonHintAction.sure(
                text: Localized.text('ox_common.confirm'),
                onTap: () async {
                  OXNavigator.pop(context, true);
                  await OXLoading.show();
                  final OKEvent okEvent = await Contacts.sharedInstance
                      .addToContact([userDB.pubKey]);
                  await OXLoading.dismiss();
                  if (okEvent.status) {
                    OXChatBinding.sharedInstance.contactUpdatedCallBack();
                    OXChatBinding.sharedInstance
                        .changeChatSessionTypeAll(userDB.pubKey, true);
                    CommonToast.instance.show(
                        context, Localized.text('ox_chat.sent_successfully'));
                  } else {
                    CommonToast.instance.show(context, okEvent.message);
                  }
                }),
          ],
          isRowAction: true);
    }
  }


  bool isFriend(String pubkey) {
    UserDB? user = Contacts.sharedInstance.allContacts[pubkey];
    return user != null;
  }
}
