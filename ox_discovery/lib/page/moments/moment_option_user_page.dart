import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
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
import 'package:ox_discovery/model/moment_ui_model.dart';
import 'package:ox_discovery/page/moments/moments_page.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import '../../enum/moment_enum.dart';
import '../../utils/discovery_utils.dart';
import '../../utils/moment_widgets_utils.dart';

class MomentOptionUserPage extends StatefulWidget {
  final ValueNotifier<NotedUIModel?> notedUIModel;
  final ENotificationsMomentType type;

  const MomentOptionUserPage(
      {super.key, required this.notedUIModel, required this.type});

  @override
  State<MomentOptionUserPage> createState() => _MomentOptionUserPageState();
}

class _MomentOptionUserPageState extends State<MomentOptionUserPage> {
  List<NotedUIModel> showUserDBList = [];

  Map<String,NotedUIModel> get showUserDBListMap {
    Map<String,NotedUIModel> map = {};
    showUserDBList.map((NotedUIModel notedUIModel) => map[notedUIModel.noteDB.author] = notedUIModel).toList();
    return map;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {

    NoteDBISAR? noteDB = widget.notedUIModel.value?.noteDB;
    if(noteDB == null) return;
    List<dynamic> list = [];
      switch (widget.type) {
        case ENotificationsMomentType.zaps:
          list = await Load.loadInvoicesToZapRecords(
              noteDB.zapEventIds ?? [], noteDB.private);
          break;
        case ENotificationsMomentType.repost:
          list = await Moment.sharedInstance.loadNoteIdsToNoteDBs(
              noteDB.repostEventIds ?? [], noteDB.private, false);
          break;
        case ENotificationsMomentType.quote:
          list = await Moment.sharedInstance.loadNoteIdsToNoteDBs(
              noteDB.quoteRepostEventIds ?? [], noteDB.private, false);
          break;
        case ENotificationsMomentType.like:
          list = await Moment.sharedInstance.loadNoteIdsToNoteDBs(
              noteDB.reactionEventIds ?? [], noteDB.private, false);
          break;
      }
      showUserDBList = _getUserList(list);
      if(mounted){
        setState(() {});
      }
  }

  List<NotedUIModel> _getUserList(List<dynamic> list) {
    return list.map((dynamic noteDB) {
      if (widget.type == ENotificationsMomentType.zaps) {
        ZapRecordsDBISAR zapRecordsDB = noteDB as ZapRecordsDBISAR;
        String content =
            '${Localized.text('ox_discovery.zaps')} +${ZapRecordsDBISAR.getZapAmount(zapRecordsDB.bolt11)}';
        return NotedUIModel(
          noteDB: NoteDBISAR(
            noteId: zapRecordsDB.eventId,
            author: zapRecordsDB.sender,
            content: content,
          ),
        );
      }
      return NotedUIModel(noteDB: noteDB as NoteDBISAR);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        title: '${widget.type.text} ${Localized.text('ox_discovery.by')}',
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
                    ...showUserDBListMap.values.toList().map(
                      (dynamic item) {
                        // ZapRecordsDB
                        return MomentUserItemWidget(
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
    if (showUserDBListMap.values.toList().isNotEmpty) return const SizedBox();
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
              '${Localized.text('ox_discovery.no')} ${widget.type.text} !',
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
  final ValueNotifier<NotedUIModel?> notedUIModel;
  final ENotificationsMomentType type;
  const MomentUserItemWidget(
      {super.key, required this.notedUIModel, required this.type});

  @override
  State<MomentUserItemWidget> createState() => _MomentUserItemWidgetState();
}

class _MomentUserItemWidgetState extends State<MomentUserItemWidget> {
  UserDBISAR? user;
  ValueNotifier<NotedUIModel?>? notedUIModel;
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
      _getUserDB(widget.notedUIModel.value?.noteDB.author ?? '');
    }

    if (widget.type == ENotificationsMomentType.zaps) {
      notedUIModel = widget.notedUIModel;
      _getUserDB(widget.notedUIModel.value?.noteDB.author ?? '');
    }
  }

  void _initReposted() async {
    ValueNotifier<NotedUIModel?>? modelNotifier = widget.notedUIModel;
    if(modelNotifier == null || modelNotifier.value == null) return;
    ValueNotifier<NotedUIModel?> noteNotifier = await DiscoveryUtils.getValueNotifierNoted(
      modelNotifier.value!.noteDB.repostId!,
      isUpdateCache: true,
      notedUIModel: modelNotifier.value,
    );

    if(noteNotifier.value != null){
      notedUIModel = noteNotifier as ValueNotifier<NotedUIModel>;
      _getUserDB(widget.notedUIModel.value?.noteDB.author ?? '');
    }
  }

  void _initLike() async {

    _getUserDB(widget.notedUIModel.value?.noteDB.author ?? '');
  }

  void _getUserDB(String pubKey) async {
    UserDBISAR? userDB = await Account.sharedInstance.getUserInfo(pubKey);
    if (userDB != null) {
      user = userDB;
      if(mounted){
        setState(() {});
      }
    }
  }

  String get _getContent {
    if(widget.type == ENotificationsMomentType.repost || notedUIModel == null || notedUIModel?.value == null) return '';
    return notedUIModel?.value!.getMomentShowContent ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return _userItemWidget();
  }

  Widget _userItemWidget() {
    ValueNotifier<NotedUIModel?>? modelNotifier = widget.notedUIModel;
    if(modelNotifier == null || modelNotifier.value == null) return const SizedBox();
    String pubKey = widget.notedUIModel.value!.noteDB.author;
    return ValueListenableBuilder<UserDBISAR>(
        valueListenable: Account.sharedInstance.getUserNotifier(pubKey),
        builder: (context, value, child) {
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: 12.px,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    await OXModuleService.pushPage(
                        context, 'ox_chat', 'ContactUserInfoPage', {
                      'pubkey': pubKey,
                    });
                    setState(() {});
                  },
                  child: MomentWidgetsUtils.clipImage(
                    borderRadius: 60.px,
                    imageSize: 60.px,
                    child: OXCachedNetworkImage(
                      imageUrl: value.picture ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          MomentWidgetsUtils.badgePlaceholderImage(),
                      errorWidget: (context, url, error) =>
                          MomentWidgetsUtils.badgePlaceholderImage(),
                      width: 60.px,
                      height: 60.px,
                    ),
                  ),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value.name ?? '--',
                                    style: TextStyle(
                                      color: ThemeColor.color10,
                                      fontSize: 16.px,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ).setPaddingOnly(bottom: 4.px),
                                  Text(
                                    DiscoveryUtils.getUserMomentInfo(value, '0')[1],
                                    style: TextStyle(
                                      color: ThemeColor.color120,
                                      fontSize: 12.px,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            _addFriendWidget(value),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _clickMoment,
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
                    ],
                  ).setPaddingOnly(left: 16.px),
                ),
              ],
            ),
          );
        },
    );
  }

  void _clickMoment() async {
    ValueNotifier<NotedUIModel?>? modelNotifier = notedUIModel;

    if (modelNotifier == null || modelNotifier.value == null) return;

    if (widget.type == ENotificationsMomentType.zaps || widget.type == ENotificationsMomentType.quote) {
      _getNoteToMomentPage(modelNotifier.value!.noteDB.noteId);
    }

  }

  void _getNoteToMomentPage(String noteId) async {
    ValueNotifier<NotedUIModel?> noteNotifier = await DiscoveryUtils.getValueNotifierNoted(
      noteId,
    );

    if (noteNotifier.value == null) return;
    OXNavigator.pushPage(
      context,
      (context) => MomentsPage(
        notedUIModel: noteNotifier,
      ),
    );
  }

  Widget _addFriendWidget(UserDBISAR userDB) {
    if (isFriend(userDB.pubKey)) return const SizedBox();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _addFriends,
      child: Container(
        margin: EdgeInsets.only(
          left: 4.px,
        ),
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
          Localized.text('ox_discovery.add'),
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
    UserDBISAR? userDB = user;
    if (userDB == null) return;

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

  bool isFriend(String pubKey) {
    UserDBISAR? user = Contacts.sharedInstance.allContacts[pubKey];
    return user != null;
  }
}
