import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/page/session/chat_secret_message_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ContactRequest extends StatefulWidget {
  ContactRequest({Key? key}) : super(key: key);

  @override
  _ContactRequestState createState() => _ContactRequestState();
}

class _ContactRequestState extends State<ContactRequest> with CommonStateViewMixin, OXChatObserver {
  late List<ChatSessionModel> _strangerSessionModelList;

  @override
  void initState() {
    super.initState();
    OXChatBinding.sharedInstance.addObserver(this);
    _initData();
  }

  @override
  void dispose() {
    OXChatBinding.sharedInstance.removeObserver(this);
    super.dispose();
  }

  void _initData() async {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (isLogin == false) {
      updateStateView(CommonStateView.CommonStateView_NotLogin);
      setState(() {});
      return;
    }
    if (OXChatBinding.sharedInstance.strangerSessionList.length == 0) {
      updateStateView(CommonStateView.CommonStateView_NoData);
    }
    _strangerSessionModelList = OXChatBinding.sharedInstance.strangerSessionList;
    _strangerSessionModelList.sort((session1, session2) {
      var session2CreatedTime = session2.createTime;
      var session1CreatedTime = session1.createTime;
      return session2CreatedTime.compareTo(session1CreatedTime);
    });
    if (_strangerSessionModelList.length > 0) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
      });
    } else {
      bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
      if (isLogin == false) {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_NotLogin);
        });
      } else {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_NoData);
        });
      }
    }
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        title: Localized.text('ox_chat.string_request_title'),
        useLargeTitle: false,
        centerTitle: true,
        canBack: false,
        backgroundColor: ThemeColor.color200,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: CommonImage(
            iconName: "icon_back_left_arrow.png",
            width: Adapt.px(24),
            height: Adapt.px(24),
            useTheme: true,
          ),
          onPressed: () {
            OXNavigator.pop(context);
          },
        ),
      ),
      body: commonStateViewWidget(
        context,
        Container(
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: [
              SliverFixedExtentList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (_strangerSessionModelList.length < 1) {
                      return Container();
                    }
                    ChatSessionModel item = _strangerSessionModelList[index];
                    return _buildItemView(item, index);
                  }, childCount: _strangerSessionModelList.length),
                  itemExtent: Adapt.px(106)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemView(ChatSessionModel item, int index) {
    return Slidable(
      key: ValueKey("$index"),
      endActionPane: ActionPane(
        extentRatio: 0.23,
        motion: const ScrollMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (BuildContext _) async {
              OXCommonHintDialog.show(context,
                  content: Localized.text('ox_chat.secret_message_delete_tips'),
                  actionList: [
                    OXCommonHintAction.cancel(onTap: () {
                      OXNavigator.pop(context);
                    }),
                    OXCommonHintAction.sure(
                        text: Localized.text('ox_common.confirm'),
                        onTap: () async {
                          OXNavigator.pop(context);
                          final int count = await OXChatBinding.sharedInstance.deleteSession([item.chatId], isStranger: true);
                          Contacts.sharedInstance.close(item.chatId);
                          if (count > 0) {
                            _initData();
                          }
                        }),
                  ],
                  isRowAction: true);
            },
            backgroundColor: ThemeColor.red1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                assetIcon('icon_chat_delete.png', 32, 32),
                Text(
                  'delete'.localized(),
                  style: TextStyle(color: Colors.white, fontSize: Adapt.px(12)),
                ),
              ],
            ),
          ),
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _setAllRead(item);
          if (item.chatType == ChatType.chatSecretStranger) {
            OXNavigator.pushPage(
              context,
                  (context) =>
                  ChatSecretMessagePage(
                    communityItem: item,
                  ),
            );
          } else {
            OXNavigator.pushPage(
                context,
                    (context) =>
                    ChatMessagePage(
                      communityItem: item,
                    ));
          }
        },
        child: Container(
          height: Adapt.px(106),
          margin: EdgeInsets.symmetric(
            horizontal: Adapt.px(20),
            vertical: Adapt.px(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(item),
              SizedBox(width: Adapt.px(16),),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildItemName(item),
                        ),
                        FutureBuilder<bool>(
                          builder: (context, snapshot) {
                            return _buildReadWidget(item, snapshot.data ?? false);
                          },
                          future: _getChatSessionMute(item),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Adapt.px(2),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.content ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Adapt.px(14),
                              color: ThemeColor.color120,
                              letterSpacing: Adapt.px(0.4),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          OXDateUtils.convertTimeFormatString3(
                            (item.createTime ?? 0) * 1000,
                          ),
                          style: TextStyle(fontSize: Adapt.px(14), color: ThemeColor.color100, letterSpacing: Adapt.px(0.4), fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Adapt.px(6),
                    ),
                    _buildNotAddStatus(item),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemName(ChatSessionModel item) {
    UserDBISAR? otherDB = Account.sharedInstance.userCache[item.getOtherPubkey]?.value;
    String showName = otherDB?.getUserShowName() ?? '';
    return item.chatType == ChatType.chatSecret || item.chatType == ChatType.chatSecretStranger
        ? Row(
            children: [
              CommonImage(
                iconName: 'icon_lock_secret.png',
                width: Adapt.px(16),
                height: Adapt.px(16),
                package: 'ox_chat',
              ),
              SizedBox(
                width: Adapt.px(4),
              ),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      ThemeColor.gradientMainEnd,
                      ThemeColor.gradientMainStart,
                    ],
                  ).createShader(Offset.zero & bounds.size);
                },
                child: Text(
                  showName,
                  style: TextStyle(
                    fontSize: Adapt.px(16),
                    color: ThemeColor.color0,
                    letterSpacing: Adapt.px(0.4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        : Text(
            showName,
            style: TextStyle(
              fontSize: Adapt.px(16),
              color: ThemeColor.color0,
              letterSpacing: Adapt.px(0.4),
              fontWeight: FontWeight.w600,
            ),
          );
  }

  //Unadded status
  Widget _buildNotAddStatus(ChatSessionModel item) {
    return Row(
      children: [
        Expanded(
          child: _buildOperateButton(
            "ox_chat.add_contact_block",
            width: Adapt.px(131),
            height: Adapt.px(30),
            onTap: () {
              _blockOnTap(item);
            },
          ),
        ),
        SizedBox(
          width: Adapt.px(12),
        ),
        _buildOperateButton(
          "ox_chat.add_contact_confirm",
          width: Adapt.px(131),
          height: Adapt.px(30),
          linearGradient: LinearGradient(
            colors: [
              ThemeColor.gradientMainEnd.withOpacity(0.24),
              ThemeColor.gradientMainStart.withOpacity(0.24),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          onTap: () {
            _confirmOnTap(item);
          },
        ),
      ],
    );
  }

  Widget _buildAvatar(ChatSessionModel item) {
    UserDBISAR? otherDB = Account.sharedInstance.userCache[item.getOtherPubkey]?.value;
    String showPicUrl = otherDB?.picture ?? '';
    return OXUserAvatar(
      user: otherDB,
      imageUrl: showPicUrl,
      size: Adapt.px(60),
      isClickable: true,
      onReturnFromNextPage: () {
        setState(() { });
      },
    );
  }

  Future<bool> _getChatSessionMute(ChatSessionModel csModel) async {
    bool isMute = false;
    if (csModel.chatType == ChatType.chatStranger || csModel.chatType == ChatType.chatSecretStranger) {
      UserDBISAR? tempUserDB = await Account.sharedInstance.getUserInfo(csModel.chatId);
      if (tempUserDB != null) {
        isMute = tempUserDB.mute ?? false;
      }
    } else if (csModel.chatType == ChatType.chatChannel) {
      ChannelDBISAR? channelDB = Channels.sharedInstance.channels[csModel.chatId];
      if (channelDB != null) {
        isMute = channelDB.mute ?? false;
      }
    }
    return isMute;
  }

  Widget _buildReadWidget(ChatSessionModel announceItem, bool isMute) {
    int read = announceItem.unreadCount;
    if (isMute) {
      if (read > 0) {
        return ClipOval(
          child: Container(
            alignment: Alignment.center,
            color: ThemeColor.color110,
            width: Adapt.px(12),
            height: Adapt.px(12),
          ),
        );
      } else {
        return SizedBox();
      }
    }
    if (read > 0 && read < 10) {
      return ClipOval(
        child: Container(
          alignment: Alignment.center,
          color: ThemeColor.red1,
          width: Adapt.px(17),
          height: Adapt.px(17),
          child: Text(
            read.toString(),
            style: _Style.read(),
          ),
        ),
      );
    } else if (read >= 10 && read < 100) {
      return Container(
        alignment: Alignment.center,
        width: Adapt.px(22),
        height: Adapt.px(20),
        decoration: BoxDecoration(
          color: ThemeColor.red1,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(13.5))),
        ),
        padding: EdgeInsets.symmetric(vertical: Adapt.px(3), horizontal: Adapt.px(3)),
        child: Text(
          read.toString(),
          style: _Style.read(),
        ),
      );
    } else if (read >= 100) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ThemeColor.red1,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(13.5))),
        ),
        padding: EdgeInsets.symmetric(vertical: Adapt.px(3), horizontal: Adapt.px(3)),
        child: Text(
          '99+',
          style: _Style.read(),
        ),
      );
    }
    return Container();
  }

  Widget _buildOperateButton(String title,
      {double? width, double? height, Color? textColor, Color? bgColor, VoidCallback? onTap, LinearGradient? linearGradient}) {
    return GestureDetector(
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        alignment: Alignment.center,
        child: Text(
          Localized.text(title),
          style: TextStyle(fontSize: Adapt.px(15), color: textColor),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(8)),
          color: bgColor ?? ThemeColor.color180,
          gradient: linearGradient,
        ),
      ),
      onTap: onTap,
    );
  }

  void _setAllRead(ChatSessionModel item) {
    setState(() {
      item.unreadCount = 0;
    });
    OXChatBinding.sharedInstance.updateChatSession(item.chatId ?? '', unreadCount: 0);
  }

  void _confirmOnTap(ChatSessionModel item) async {
    OXCommonHintDialog.show(context,
        content: 'Add to private contacts?',
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                await OXLoading.show();
                String pubkey = (item.sender != OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey ? item.sender : item.receiver) ?? '';
                final OKEvent okEvent = await Contacts.sharedInstance.addToContact([pubkey]);
                await OXLoading.dismiss();
                if (okEvent.status) {
                  OXChatBinding.sharedInstance.contactUpdatedCallBack();
                  OXChatBinding.sharedInstance.changeChatSessionTypeAll(pubkey, true);
                  CommonToast.instance.show(context, Localized.text('ox_chat.added_successfully'));
                  OXNavigator.pop(context);
                  setState(() {});
                } else {
                  CommonToast.instance.show(context, okEvent.message);
                }
              }),
        ],
        isRowAction: true);
  }

  void _blockOnTap(ChatSessionModel item) async {
    OXCommonHintDialog.show(context,
        content: 'Block this user?\nAfter blocking, you will no longer receive messages from them.',
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                await OXLoading.show();
                final OKEvent okEvent = await Contacts.sharedInstance.addToBlockList(item.chatId);
                await OXLoading.dismiss();
                if (okEvent.status) {
                  OXChatBinding.sharedInstance.deleteSession([item.chatId]);
                  CommonToast.instance.show(context, Localized.text('ox_chat.rejected_successfully'));
                  OXNavigator.pop(context);
                  setState(() {});
                } else {
                  CommonToast.instance.show(context, okEvent.message);
                }
              }),
        ],
        isRowAction: true);
  }

  @override
  void didSessionUpdate() {
    _initData();
  }
}

class _Style {
  static TextStyle read() {
    return new TextStyle(
      fontSize: Adapt.px(12),
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
  }
}
