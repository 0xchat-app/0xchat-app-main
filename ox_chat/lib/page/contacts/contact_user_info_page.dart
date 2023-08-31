import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/manager/chat_user_cache.dart';
import 'package:ox_chat/page/contacts/contact_friend_remark_page.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/utils/user_report.dart';
import 'package:ox_chat/widget/report_dialog.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

import 'contact_create_secret_chat.dart';

class ContactUserInfoPage extends StatefulWidget {
  final UserDB userDB;

  ContactUserInfoPage({Key? key, required this.userDB}) : super(key: key);

  @override
  State<ContactUserInfoPage> createState() => _ContactUserInfoPageState();
}

enum OtherInfoItemType {
  Remark,
  Bio,
  Pubkey,
  Badges,
  Mute,
}

extension OtherInfoItemStr on OtherInfoItemType {
  String get text {
    switch (this) {
      case OtherInfoItemType.Remark:
        return 'Remark';
      case OtherInfoItemType.Bio:
        return 'Bio';
      case OtherInfoItemType.Pubkey:
        return 'Pubkey';
      case OtherInfoItemType.Badges:
        return 'Badges';
      case OtherInfoItemType.Mute:
        return 'Mute';
    }
  }
}

class _ContactUserInfoPageState extends State<ContactUserInfoPage> {
  Image _avatarPlaceholderImage = Image.asset(
    'assets/images/icon_user_default.png',
    fit: BoxFit.contain,
    width: Adapt.px(60),
    height: Adapt.px(60),
    package: 'ox_chat',
  );

  Image _badgePlaceholderImage = Image.asset(
    'assets/images/icon_badge_default.png',
    fit: BoxFit.cover,
    width: Adapt.px(32),
    height: Adapt.px(32),
    package: 'ox_common',
  );

  bool _publicKeyCopied = false;

  List<BadgeDB> _badgeDBList = [];
  bool _isMute = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _isInBlockList() {
    return Contacts.sharedInstance.inBlockList(widget.userDB.pubKey ?? '');
  }

  void _initData() async {
    _isMute = widget.userDB.mute ?? false;
    if (widget.userDB.badges != null && widget.userDB.badges!.isNotEmpty) {
      List<dynamic> badgeListDynamic = jsonDecode(widget.userDB.badges!);
      List<String> badgeIds = badgeListDynamic.cast();
      List<BadgeDB?> dbGetList =
          await BadgesHelper.getBadgeInfosFromDB(badgeIds);
      if (dbGetList.length > 0) {
        dbGetList.forEach((element) {
          if (element != null) {
            _badgeDBList.add(element);
          }
        });
        setState(() {});
      } else {
        List<BadgeDB> badgeDB =
            await BadgesHelper.getBadgesInfoFromRelay(badgeIds);
        if (badgeDB.length > 0) {
          _badgeDBList = badgeDB;
          if (mounted) {
            setState(() {});
          }
        }
      }
    }
    if (widget.userDB.pubKey != null) {
      Map usersMap =
          await Account.syncProfilesFromRelay([widget.userDB.pubKey!]);
      UserDB? user = usersMap[widget.userDB.pubKey!];
      if (user != null) {
        widget.userDB.updateWith(user);
        setState(() {});
        ChatUserCache.shared.updateUserInfo(widget.userDB);
        OXChatBinding.sharedInstance.updateChatSession(widget.userDB.pubKey!,
            chatName: widget.userDB.name, pic: widget.userDB.picture);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_chat.details'),
        backgroundColor: ThemeColor.color200,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeadImage(),
            SizedBox(
              height: Adapt.px(16),
            ),
            _buildHeadName(),
            _buildHeadDesc(),
            SizedBox(
              height: Adapt.px(24),
            ),
            _tabContainerView(),
            _contentList(),
            widget.userDB.about == null ||
                    widget.userDB.about!.isEmpty ||
                    widget.userDB.about == 'null'
                ? SizedBox()
                : _bioOrPubKeyWidget(
                        OtherInfoItemType.Bio, widget.userDB.about ?? '')
                    .setPadding(
                    EdgeInsets.only(
                      top: Adapt.px(24),
                    ),
                  ),
            SizedBox(
              height: Adapt.px(24),
            ),
            _bioOrPubKeyWidget(
                OtherInfoItemType.Pubkey, widget.userDB.encodedPubkey),
            SizedBox(
              height: Adapt.px(24),
            ),
            _delOrAddFriendBtnView(),
            _blockStatusBtnView(),
            SizedBox(
              height: Adapt.px(44),
            ),
          ],
        ),
      ).setPadding(EdgeInsets.only(
          left: Adapt.px(24), right: Adapt.px(24), top: Adapt.px(16))),
    );
  }

  Widget _tabContainerView() {
    if (!(!_isInBlockList())) return Container();
    return Container(
      padding: EdgeInsets.only(
        bottom: Adapt.px(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tabWidget(
            onTap: _sendMsg,
            iconName: 'icon_message.png',
            content: 'Message',
          ),
          _tabWidget(
            onTap: () {
              OXNavigator.presentPage(
                context,
                (context) => ContactCreateSecret(userDB: widget.userDB),
              );
            },
            iconName: 'icon_secret.png',
            content: 'Secret Chat',
          ),
          _tabWidget(
            onTap: () => {},
            iconName: 'icon_lightning.png',
            content: 'Zaps',
          ),
          _tabWidget(
            onTap: () => _onChangedMute(!_isMute),
            iconName: _isMute ? 'icon_session_mute.png' : 'icon_mute.png',
            content: _isMute ? 'Unmute' : 'Mute',
          ),
        ],
      ),
    );
  }

  Widget _tabWidget(
      {required onTap, required String iconName, required String content}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Adapt.px(76.5),
        padding: EdgeInsets.symmetric(
          vertical: Adapt.px(14),
        ),
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.all(
            Radius.circular(
              Adapt.px(16),
            ),
          ),
        ),
        child: Column(
          children: [
            CommonImage(
              iconName: iconName,
              width: Adapt.px(24),
              height: Adapt.px(24),
              package: 'ox_chat',
            ),
            SizedBox(
              height: Adapt.px(2),
            ),
            Text(
              content,
              style: TextStyle(
                color: ThemeColor.color80,
                fontSize: Adapt.px(10),
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _contentList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ThemeColor.color180,
      ),
      child: Column(
        children: [
          isFriend(widget.userDB.pubKey ?? '')
              ? _itemView(
                  iconName: 'icon_remark.png',
                  iconPackage: 'ox_chat',
                  type: OtherInfoItemType.Remark,
                  rightHint: widget.userDB.nickName,
                )
              : Container(),
          isFriend(widget.userDB.pubKey ?? '')
              ? Divider(
                  height: Adapt.px(0.5),
                  color: ThemeColor.color160,
                )
              : Container(),
          _itemView(
            iconName: 'icon_settings_badges.png',
            iconPackage: 'ox_usercenter',
            type: OtherInfoItemType.Badges,
          ),
        ],
      ),
    );
  }

  Widget _bioOrPubKeyWidget(OtherInfoItemType type, String content) {
    String copyStatusIcon =
        _publicKeyCopied ? 'icon_copyied_success.png' : 'icon_copy.png';
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color190,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(16), vertical: Adapt.px(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(bottom: Adapt.px(12)),
            child: Text(
              type.text,
              style: TextStyle(
                fontSize: Adapt.px(14),
                color: ThemeColor.color100,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  content,
                  style: TextStyle(
                      fontSize: Adapt.px(14),
                      color: ThemeColor.color0,
                      fontWeight: FontWeight.w400),
                  maxLines: null,
                ),
              ),
              type == OtherInfoItemType.Pubkey
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => _clickKey(content),
                      child: Container(
                        width: Adapt.px(48),
                        alignment: Alignment.center,
                        child: CommonImage(
                          iconName: copyStatusIcon,
                          width: Adapt.px(24),
                          height: Adapt.px(24),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _delOrAddFriendBtnView() {
    if (_isInBlockList()) return Container();
    bool friendsStatus = isFriend(widget.userDB.pubKey ?? '');

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: Adapt.px(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ThemeColor.color180,
          gradient: friendsStatus
              ? null
              : LinearGradient(
                  colors: [
                    ThemeColor.gradientMainEnd.withOpacity(0.24),
                    ThemeColor.gradientMainStart.withOpacity(0.24),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
        ),
        alignment: Alignment.center,
        child: Text(
          isFriend(widget.userDB.pubKey ?? '') == false
              ? Localized.text('ox_chat.add_friend')
              : Localized.text('ox_chat.remove_contacts'),
          style: TextStyle(
            color: friendsStatus ? ThemeColor.red : Colors.white,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: friendsStatus ? _removeFriend : _addFriends,
    );
  }

  Widget _blockStatusBtnView() {
    bool isInBlocklist = _isInBlockList();
    String btnContent = isInBlocklist
        ? 'unblock'
        : Localized.text('ox_chat.message_menu_block');
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(
          top: Adapt.px(16),
        ),
        width: double.infinity,
        height: Adapt.px(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ThemeColor.color180,
        ),
        alignment: Alignment.center,
        child: Text(
          btnContent,
          style: TextStyle(
            color: Colors.white,
            fontSize: Adapt.px(16),
          ),
        ),
      ),
      onTap: _blockOptionFn,
    );
  }

  void _blockOptionFn() async{
    String pubKey = widget.userDB.pubKey ?? '';
    if (_isInBlockList()) {
      OKEvent event = await Contacts.sharedInstance.removeBlockList([pubKey]);
      if(event.status){
        CommonToast.instance.show(context, 'UnBlock success !');
      }
    } else {
      OXCommonHintDialog.show(context,
          title: 'Block this user ?',
          content:
              'After blocking, you will no longer receive messages from them.',
          actionList: [
            OXCommonHintAction.cancel(onTap: () {
              OXNavigator.pop(context, false);
            }),
            OXCommonHintAction.sure(
                text: 'Confirm',
                onTap: () async {
                  OKEvent event =  await Contacts.sharedInstance.addToBlockList(pubKey);
                  if(event.status){
                    CommonToast.instance.show(context, 'Block success !');
                    OXNavigator.pop(context, true);
                  }
                }),
          ],
          isRowAction: true);
    }
    setState(() {});
  }

  Future<void> _clickKey(String keyContent) async {
    await Clipboard.setData(
      ClipboardData(
        text: keyContent,
      ),
    );
    await CommonToast.instance
        .show(context, 'copied_to_clipboard'.commonLocalized());
    _publicKeyCopied = true;
    setState(() {});
  }

  Widget _itemView({
    String? iconName,
    String? iconPackage,
    OtherInfoItemType type = OtherInfoItemType.Remark,
    String? rightHint,
  }) {
    return ListTile(
      leading: CommonImage(
        iconName: iconName ?? '',
        width: Adapt.px(32),
        height: Adapt.px(32),
        package: iconPackage ?? 'ox_chat',
      ),
      title: Text(
        type.text,
        style: TextStyle(
          fontSize: Adapt.px(16),
          color: ThemeColor.color0,
        ),
      ),
      trailing: type == OtherInfoItemType.Mute
          ? Switch(
              value: _isMute,
              activeColor: Colors.white,
              activeTrackColor: ThemeColor.gradientMainStart,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: ThemeColor.color160,
              onChanged: _onChangedMute,
              materialTapTargetSize: MaterialTapTargetSize.padded,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                type == OtherInfoItemType.Badges
                    ? Container(
                        width: Adapt.px(100),
                        child: ListView.separated(
                            itemCount: _badgeDBList.length,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1),
                            itemBuilder: (context, index) {
                              BadgeDB tempItem = _badgeDBList[index];
                              return CachedNetworkImage(
                                imageUrl: tempItem.thumb ?? '',
                                fit: BoxFit.contain,
                                placeholder: (context, url) =>
                                    _badgePlaceholderImage,
                                errorWidget: (context, url, error) =>
                                    _badgePlaceholderImage,
                                width: Adapt.px(32),
                                height: Adapt.px(32),
                              );
                            }),
                      )
                    : Container(),
                CommonImage(
                  iconName: 'icon_arrow_more.png',
                  width: Adapt.px(24),
                  height: Adapt.px(24),
                ),
              ],
            ),
      onTap: () {
        _itemClick(type);
      },
    );
  }

  Widget _buildHeadImage() {
    Image badgePlaceholderImage = Image.asset(
      'assets/images/icon_badge_default.png',
      fit: BoxFit.cover,
      width: Adapt.px(24),
      height: Adapt.px(24),
      package: 'ox_common',
    );
    return InkWell(
      onTap: () {
        OXModuleService.pushPage(
          context,
          'ox_usercenter',
          'AvatarPreviewPage',
          {
            'userDB': widget.userDB,
          },
        );
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        width: Adapt.px(100),
        height: Adapt.px(100),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Adapt.px(100)),
                child: CachedNetworkImage(
                  imageUrl: widget.userDB.picture ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _avatarPlaceholderImage,
                  errorWidget: (context, url, error) => _avatarPlaceholderImage,
                  width: Adapt.px(100),
                  height: Adapt.px(100),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Container(
                  width: Adapt.px(91),
                  height: Adapt.px(91),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(Adapt.px(91)),
                    border: Border.all(
                      width: Adapt.px(3),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: FutureBuilder<BadgeDB?>(
                builder: (context, snapshot) {
                  return (snapshot.data != null && snapshot.data!.thumb != null)
                      ? CachedNetworkImage(
                          imageUrl: snapshot.data?.thumb ?? '',
                          errorWidget: (context, url, error) =>
                              badgePlaceholderImage,
                          width: Adapt.px(24),
                          height: Adapt.px(24),
                          fit: BoxFit.cover,
                        )
                      : Container();
                },
                future: _getUserSelectedBadgeInfo(widget.userDB),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadName() {
    String showName =
        widget.userDB.nickName != null && widget.userDB.nickName!.isNotEmpty
            ? widget.userDB.nickName!
            : (widget.userDB.name ?? '');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          showName,
          style: TextStyle(color: ThemeColor.titleColor, fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildHeadDesc() {
    if (widget.userDB.dns == null || widget.userDB.dns == 'null') {
      return SizedBox();
    }
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.userDB.dns ?? '',
            maxLines: 1,
            style:
                TextStyle(color: ThemeColor.color120, fontSize: Adapt.px(14)),
            // overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            width: Adapt.px(4),
          ),
        ],
      ),
    );
  }

  void _addFriends() async {
    if (widget.userDB.pubKey == null) {
      return;
    }
    if (isFriend(widget.userDB.pubKey ?? '') == false) {
      OXCommonHintDialog.show(context,
          content:
              'Add to private contacts?',
          actionList: [
            OXCommonHintAction.cancel(onTap: () {
              OXNavigator.pop(context, false);
            }),
            OXCommonHintAction.sure(
                text: 'confirm',
                onTap: () async {
                  await OXLoading.show();
                  LogUtil.e(
                      'Michael: widget.userDB.pubKey =${widget.userDB.pubKey!}; widget.userDB.toAliasPubkey =${widget.userDB.toAliasPubkey!}');
                  final OKEvent okEvent = await Contacts.sharedInstance
                      .addToContact([widget.userDB.pubKey!]);
                  await OXLoading.dismiss();
                  if (okEvent.status) {
                    OXChatBinding.sharedInstance.contactUpdatedCallBack();
                    CommonToast.instance.show(
                        context, Localized.text('ox_chat.sent_successfully'));
                  } else {
                    CommonToast.instance.show(context, okEvent.message);
                  }
                  OXNavigator.pop(context, true);
                }),
          ],
          isRowAction: true);
    }
  }

  void _sendMsg() {
    if (!isFriend(widget.userDB.pubKey ?? '')) {
      CommonToast.instance.show(
          context, Localized.text('ox_chat.not_friends_send_message_prompts'));
      return;
    }
    OXNavigator.pushPage(
      context,
      (context) => ChatMessagePage(
        communityItem: ChatSessionModel(
          chatId: widget.userDB.pubKey,
          chatName: widget.userDB.name,
          sender: OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
          receiver: widget.userDB.pubKey,
          chatType: ChatType.chatSingle,
        ),
      ),
    );
  }

  void _removeFriend() async {
    if (widget.userDB.pubKey == null) {
      return;
    }
    OXCommonHintDialog.show(context,
        title: 'Delete Contact',
        content:
            'Are you sure you want to delete the contact ${widget.userDB.name}?',
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                await OXLoading.show();
                final OKEvent okEvent = await Contacts.sharedInstance
                    .removeContact(widget.userDB.pubKey ?? '');
                await OXLoading.dismiss();
                OXChatBinding.sharedInstance.changeChatSessionTypeAll(widget.userDB.pubKey, false);
                OXNavigator.pop(context);
                if (okEvent.status) {
                  setState(() {});
                  CommonToast.instance.show(context, 'Deleted successfully');
                } else {
                  CommonToast.instance.show(context, okEvent.message);
                }
              }),
        ],
        isRowAction: true);
  }

  void _reportUser() async {
    if (widget.userDB.pubKey == null) {
      return;
    }
    final result = await ReportDialog.show(context,
        target: UserReportTarget(pubKey: widget.userDB.pubKey ?? ''));
    if (result != null) {
      CommonToast.instance.show(context, 'Report Success');
    }
    OXNavigator.pop(context);
    return;
  }

  ///Determine if it's a friend
  bool isFriend(String pubkey) {
    UserDB? user = Contacts.sharedInstance.allContacts[pubkey];
    LogUtil.e("user?.aliasPubkey ${user?.aliasPubkey}");
    return user != null;
  }

  void _onChangedMute(bool value) async {
    await OXLoading.show();
    if (value) {
      await Contacts.sharedInstance.muteFriend(widget.userDB.pubKey!);
    } else {
      await Contacts.sharedInstance.unMuteFriend(widget.userDB.pubKey!);
    }
    final bool result =
        await OXUserInfoManager.sharedInstance.setNotification();
    await OXLoading.dismiss();
    if (result) {
      OXChatBinding.sharedInstance.sessionUpdate();
      setState(() {
        _isMute = value;
        widget.userDB.mute = value;
      });
    } else {
      CommonToast.instance
          .show(context, 'Mute(Unmute) failed, please try again later.');
    }
  }

  void _itemClick(OtherInfoItemType type) async {
    if (type == OtherInfoItemType.Remark) {
      LogUtil.e('Michael: goto ContactFriendsRemarkPage');
      String? result = await OXNavigator.pushPage(
        context,
        (context) => ContactFriendRemarkPage(
          userDB: widget.userDB,
        ),
      );
      if (result != null) {
        setState(() {});
      }
    } else if (type == OtherInfoItemType.Badges) {
      OXModuleService.pushPage(
        context,
        'ox_usercenter',
        'UsercenterBadgeWallPage',
        {
          'userDB': widget.userDB,
        },
      );
    }
  }

  Future<BadgeDB?> _getUserSelectedBadgeInfo(UserDB friendDB) async {
    UserDB? friendUserDB = Contacts.sharedInstance.allContacts[friendDB.pubKey];
    LogUtil.e(
        'Michael: friend_user_info_page  _getUserSelectedBadgeInfo : ${friendUserDB!.name ?? ''}; badges =${friendUserDB?.badges ?? 'badges null'}');
    if (friendUserDB == null) {
      return null;
    }
    String badges = friendUserDB.badges ?? '';
    if (badges.isNotEmpty) {
      List<dynamic> badgeListDynamic = jsonDecode(badges);
      List<String> badgeList = badgeListDynamic.cast();
      BadgeDB? badgeDB;
      try {
        List<BadgeDB?> badgeDBList =
            await BadgesHelper.getBadgeInfosFromDB(badgeList);
        badgeDB = badgeDBList.first;
      } catch (error) {
        LogUtil.e("user selected badge info fetch failed: $error");
      }
      return badgeDB;
    }
    return null;
  }
}
