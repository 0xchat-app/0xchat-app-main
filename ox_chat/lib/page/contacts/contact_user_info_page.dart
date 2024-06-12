import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/page/contacts/contact_friend_remark_page.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/widgets/common_time_dialog.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_action_dialog.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

import 'contact_create_secret_chat.dart';

class TabModel {
  Function onTap;
  final String iconName;
  final String content;
  TabModel(
      {required this.onTap, required this.iconName, required this.content});
}

class ContactUserInfoPage extends StatefulWidget {
  final String pubkey;
  final String? chatId;
  final bool isSecretChat;

  ContactUserInfoPage(
      {Key? key, required this.pubkey, this.chatId, this.isSecretChat = false})
      : super(key: key);

  @override
  State<ContactUserInfoPage> createState() => _ContactUserInfoPageState();
}

enum OtherInfoItemType {
  Remark,
  Bio,
  Pubkey,
  Badges,
  Mute,
  Moments
}

extension OtherInfoItemStr on OtherInfoItemType {
  String get text {
    switch (this) {
      case OtherInfoItemType.Remark:
        return Localized.text('ox_chat.remark');
      case OtherInfoItemType.Bio:
        return Localized.text('ox_chat.bio');
      case OtherInfoItemType.Pubkey:
        return Localized.text('ox_chat.public_key');
      case OtherInfoItemType.Badges:
        return Localized.text('ox_chat.badges');
      case OtherInfoItemType.Mute:
        return Localized.text('ox_chat.mute_item');
      case OtherInfoItemType.Moments:
        return Localized.text('ox_discovery.moment');
    }
  }
}

class _ContactUserInfoPageState extends State<ContactUserInfoPage> {

  ChatSessionModel? get _chatSessionModel {
    ChatSessionModel? model =
    OXChatBinding.sharedInstance.sessionMap[widget.chatId];
    return model;
  }

  Image _avatarPlaceholderImage = Image.asset(
    'assets/images/icon_user_default.png',
    fit: BoxFit.contain,
    width: Adapt.px(60),
    height: Adapt.px(60),
    package: 'ox_common',
  );

  Widget _badgePlaceholderImage = CommonImage(
    iconName: 'icon_badge_default.png',
    fit: BoxFit.cover,
    width: Adapt.px(32),
    height: Adapt.px(32),
    useTheme: true,
  );

  bool _publicKeyCopied = false;

  List<BadgeDB> _badgeDBList = [];
  bool _isMute = false;
  bool _isVerifiedDNS = false;
  late UserDB userDB;
  String myPubkey = '';

  // auto delete
  int get _autoDelExTime {
    int? autoDelExpiration = _chatSessionModel?.expiration;
    if (autoDelExpiration == null) return 0;
    return autoDelExpiration;
  }

  // safe chat
  // safe chat: kind = 1059
  // disable safe chat: kind = 4
  bool get _safeChatStatus {
    int? safeMsgKind = _chatSessionModel?.messageKind;
    if (safeMsgKind == null) return true;
    return safeMsgKind == 1059;
  }

  List<TabModel> modelList = [];

  @override
  void initState() {
    super.initState();
    _initData();
    _initModelList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _isInBlockList() {
    return Contacts.sharedInstance.inBlockList(widget.pubkey ?? '');
  }

  void _initModelList() async {
    myPubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    if (myPubkey != widget.pubkey)
      modelList = [
        TabModel(
          iconName: 'icon_message.png',
          onTap: _sendMsg,
          content: Localized.text('ox_chat.send_message'),
        ),
        TabModel(
          onTap: () {
            OXNavigator.presentPage(
              context,
              (context) => ContactCreateSecret(userDB: userDB),
            );
          },
          iconName: 'icon_secret.png',
          content: Localized.text('ox_chat.secret_chat'),
        ),
        TabModel(
          onTap: () {
            _clickCall();
          },
          iconName: 'icon_chat_call.png',
          content: Localized.text('ox_chat.call'),
        ),
        TabModel(
          onTap: () => _onChangedMute(!_isMute),
          iconName: _isMute ? 'icon_session_mute.png' : 'icon_mute.png',
          content: _isMute ? Localized.text('ox_chat.un_mute_item') : Localized.text('ox_chat.mute_item'),
        ),
        if (widget.chatId != null)
          TabModel(
            onTap: _chatMsgControlDialogWidget,
            iconName: 'icon_more_gray.png',
            content: Localized.text('ox_chat.more'),
          ),
      ];

    setState(() {});
  }

  void _initData() async {
    userDB = Account.sharedInstance.userCache[widget.pubkey]?.value ?? UserDB(pubKey: widget.pubkey);
    _isMute = userDB.mute ?? false;
    if (userDB.badges != null && userDB.badges!.isNotEmpty) {
      List<dynamic> badgeListDynamic = jsonDecode(userDB.badges!);
      List<String> badgeIds = badgeListDynamic.cast();
      List<BadgeDB?> dbGetList =
          await BadgesHelper.getBadgeInfosFromDB(badgeIds);
      if (dbGetList.length > 0) {
        dbGetList.forEach((element) {
          if (element != null) {
            _badgeDBList.add(element);
          }
        });
        if (mounted) setState(() {});
      } else {
        List<BadgeDB> badgeDB =
            await BadgesHelper.getBadgesInfoFromRelay(badgeIds);
        if (badgeDB.length > 0) {
          _badgeDBList = badgeDB;
          if (mounted) setState(() {});
        }
      }
    }
    Account.sharedInstance.reloadProfileFromRelay(userDB.pubKey).then((user) {
      userDB.updateWith(user);
      if(mounted) setState(() {});
    });
    OXChatBinding.sharedInstance.updateChatSession(userDB.pubKey,
        chatName: userDB.name, pic: userDB.picture);
    _verifiedDNS();
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
            _buildHeadPubKey(),
            SizedBox(
              height: Adapt.px(24),
            ),
            _tabContainerView(),
            _contentList(),
            userDB.about == null ||
                    userDB.about!.isEmpty ||
                    userDB.about == 'null'
                ? SizedBox()
                : _bioOrPubKeyWidget(
                        OtherInfoItemType.Bio, userDB.about ?? '')
                    .setPadding(
                    EdgeInsets.only(
                      top: Adapt.px(24),
                    ),
                  ),
            SizedBox(
              height: Adapt.px(24),
            ),
            _bioOrPubKeyWidget(
                OtherInfoItemType.Pubkey, userDB.encodedPubkey),
            SizedBox(
              height: Adapt.px(24),
            ),
            _delOrAddFriendBtnView(),
            if (myPubkey != widget.pubkey) _blockStatusBtnView(),
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
    bool isShowMore = widget.chatId != null;
    return Container(
      margin: EdgeInsets.only(
        bottom: 16.px,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 0),
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isShowMore ? 5 : 4,
          crossAxisSpacing: isShowMore ? 4.px : 20.px,
          childAspectRatio:  1.1,
          // mainAxisExtent: _imageWH + Adapt.px(8 + 34),
        ),
        itemBuilder: (BuildContext context, int index) {
          return _tabWidget(
              content: modelList[index].content,
              onTap: modelList[index].onTap,
              iconName: modelList[index].iconName);
        },
        itemCount: modelList.length,
      ),
    );
  }

  Widget _tabWidget(
      {required onTap, required String iconName, required String content}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Adapt.px(8),
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            ),
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
          isFriend(userDB.pubKey ?? '')
              ? _itemView(
                  iconName: 'icon_remark.png',
                  iconPackage: 'ox_chat',
                  type: OtherInfoItemType.Remark,
                  rightHint: userDB.nickName,
                )
              : Container(),
          isFriend(userDB.pubKey ?? '')
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
          Divider(
            height: Adapt.px(0.5),
            color: ThemeColor.color160,
          ),
          _itemView(
            iconName: 'icon_moment.png',
            iconPackage: 'ox_usercenter',
            type: OtherInfoItemType.Moments,
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
                          useTheme: !_publicKeyCopied,
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

  Widget _buildHeadPubKey() {
    String encodedPubKey = userDB.encodedPubkey;

    String newPubKey = '';
    if (encodedPubKey.isNotEmpty) {
      final String start = encodedPubKey.substring(0, 16);
      final String end = encodedPubKey.substring(encodedPubKey.length - 16);

      newPubKey = '$start:$end';
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap:() => _clickKey(encodedPubKey),
      child: Container(
        height: Adapt.px(33),
        margin: EdgeInsets.only(top: Adapt.px(8)),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(12),vertical: Adapt.px(8)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(12)),
          color: ThemeColor.color180,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              newPubKey,
              style: TextStyle(
                  fontSize: Adapt.px(12),
                  fontWeight: FontWeight.w400,
                  color: ThemeColor.color0,
                  overflow: TextOverflow.ellipsis),
            ),
            SizedBox(width: Adapt.px(8)),
            encodedPubKey.isNotEmpty
                ? CommonImage(
                    iconName: "icon_copy.png",
                    width: Adapt.px(16),
                    height: Adapt.px(16),
                    useTheme: true,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _delOrAddFriendBtnView() {
    bool friendsStatus = false;
    String showTxt = '';
    if (myPubkey == widget.pubkey) {
      showTxt = Localized.text('ox_chat.send_message');
    } else {
      if (_isInBlockList()) return Container();
      friendsStatus = isFriend(userDB.pubKey ?? '');
      showTxt = isFriend(userDB.pubKey ?? '') == false ? Localized.text('ox_chat.add_friend') : Localized.text('ox_chat.remove_contacts');
    }
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
                    ThemeColor.gradientMainEnd,
                    ThemeColor.gradientMainStart,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
        ),
        alignment: Alignment.center,
        child: Text(
          showTxt,
          style: TextStyle(
            color: myPubkey != widget.pubkey && friendsStatus ? ThemeColor.red : Colors.white,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: myPubkey == widget.pubkey ? _sendMsg : (friendsStatus ? _removeFriend : _addFriends),
    );
  }

  Widget _blockStatusBtnView() {
    bool isInBlocklist = _isInBlockList();
    String btnContent = isInBlocklist
        ? Localized.text('ox_chat.message_menu_un_block')
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
            color: ThemeColor.color0,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: _blockOptionFn,
    );
  }

  void _blockOptionFn() async {
    String pubKey = userDB.pubKey ?? '';
    if (_isInBlockList()) {
      OKEvent event = await Contacts.sharedInstance.removeBlockList([pubKey]);
      if (!event.status) {
        CommonToast.instance
            .show(context, Localized.text('ox_chat.un_block_fail'));
      }
    } else {
      OXCommonHintDialog.show(context,
          title: Localized.text('ox_chat.block_dialog_title'),
          content: Localized.text('ox_chat.block_dialog_content'),
          actionList: [
            OXCommonHintAction.cancel(onTap: () {
              OXNavigator.pop(context, false);
            }),
            OXCommonHintAction.sure(
                text: Localized.text('ox_common.confirm'),
                onTap: () async {
                  OKEvent event =  await Contacts.sharedInstance.addToBlockList(pubKey);
                  if(!event.status){
                    CommonToast.instance.show(context, Localized.text('ox_chat.block_fail'));
                  }
                  OXChatBinding.sharedInstance.deleteSession(pubKey);
                  OXNavigator.pop(context, true);
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
    return Container(
      width: double.infinity,
      height: Adapt.px(52),
      alignment: Alignment.center,
      child: ListTile(
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
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: ListView.separated(
                                itemCount: _badgeDBList.length,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) => Divider(height: 1),
                                itemBuilder: (context, index) {
                                  BadgeDB tempItem = _badgeDBList[index];
                                  LogUtil.e('Michael: _badgeDBList.length =${_badgeDBList.length}');
                                  return OXCachedNetworkImage(
                                    imageUrl: tempItem.thumb ?? '',
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => _badgePlaceholderImage,
                                    errorWidget: (context, url, error) => _badgePlaceholderImage,
                                    width: Adapt.px(32),
                                    height: Adapt.px(32),
                                  );
                                }),
                          ),
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
      ),
    );
  }

  Widget _buildHeadImage() {
    Widget badgePlaceholderImage = CommonImage(
      iconName: 'icon_badge_default.png',
      fit: BoxFit.cover,
      width: Adapt.px(24),
      height: Adapt.px(24),
      useTheme: true,
    );

    return InkWell(
      onTap: () {
        OXModuleService.pushPage(
          context,
          'ox_usercenter',
          'AvatarPreviewPage',
          {
            'userDB': userDB,
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
                child: OXCachedNetworkImage(
                  imageUrl: userDB.picture ?? '',
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
                      color: ThemeColor.color200,
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
                  return (snapshot.data != null)
                      ? OXCachedNetworkImage(
                          imageUrl: snapshot.data?.thumb ?? '',
                          errorWidget: (context, url, error) =>
                              badgePlaceholderImage,
                          width: Adapt.px(40),
                          height: Adapt.px(40),
                          fit: BoxFit.cover,
                        )
                      : Container();
                },
                future: _getUserSelectedBadgeInfo(userDB),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadName() {
    String showName =
        userDB.nickName != null && userDB.nickName!.isNotEmpty
            ? userDB.nickName!
            : (userDB.name ?? '');
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
    if (userDB.dns == null || userDB.dns == 'null') {
      return SizedBox();
    }
    String dns = userDB.dns ?? '';
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dns,
            maxLines: 1,
            style:
                TextStyle(color: ThemeColor.color120, fontSize: Adapt.px(14)),
            // overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            width: Adapt.px(4),
          ),
          dns.isNotEmpty && _isVerifiedDNS
              ? CommonImage(
            iconName: "icon_npi05_verified.png",
            width: Adapt.px(16),
            height: Adapt.px(16),
            package: 'ox_common',
          )
              : Container(),
        ],
      ),
    );
  }

  void _addFriends() async {
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
                    _sendMsg();
                  } else {
                    CommonToast.instance.show(context, okEvent.message);
                  }
                }),
          ],
          isRowAction: true);
    }
  }

  void _sendMsg() {
    if(widget.chatId != null){
      OXNavigator.pop(context);
      return;
    }
    OXNavigator.pushReplacement(
      context,
      ChatMessagePage(
        communityItem: ChatSessionModel(
          chatId: userDB.pubKey,
          chatName: userDB.name,
          sender: OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
          receiver: userDB.pubKey,
          chatType: ChatType.chatSingle,
        ),
      ),
    );
  }

  void _removeFriend() async {
    OXCommonHintDialog.show(context,
        title: Localized.text('ox_chat.remove_contacts'),
        content: Localized.text('ox_chat.remove_contacts_dialog_content')
            .replaceAll(r'${name}', '${userDB.name}'),
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                await OXLoading.show();
                final OKEvent okEvent = await Contacts.sharedInstance
                    .removeContact(userDB.pubKey ?? '');
                await OXLoading.dismiss();
                OXNavigator.pop(context);
                if (okEvent.status) {
                  OXChatBinding.sharedInstance.contactUpdatedCallBack();
                  setState(() {});
                  CommonToast.instance.show(context,
                      Localized.text('ox_chat.remove_contacts_success_toast'));
                } else {
                  CommonToast.instance.show(context, okEvent.message);
                }
              }),
        ],
        isRowAction: true);
  }

  void _chatMsgControlDialogWidget() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Opacity(
            opacity: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: Adapt.px(widget.isSecretChat ? 142 : 195),
              decoration: BoxDecoration(
                color: ThemeColor.color180,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _chatControlDialogItemWidget(
                      isSelect: _autoDelExTime != 0,
                      content:
                      Localized.text('ox_chat.option_auto_delete').replaceAll(r'${option}', '${_autoDelExTime > 0 ? Localized.text('ox_chat.set') : Localized.text('ox_chat.enable')}'),
                      onTap: _updateAutoDel),
                  Divider(
                    height: Adapt.px(0.5),
                    color: ThemeColor.color160,
                  ),
                  !widget.isSecretChat ? _chatControlDialogItemWidget(
                      isSelect: _safeChatStatus,
                      content:
                      Localized.text('ox_chat.option_gift_wrap_dm').replaceAll(r'${option}', '${_safeChatStatus ? Localized.text('ox_chat.disable') : Localized.text('ox_chat.enable')} '),
                      onTap: _updateSafeChat) : Container(),
                  Container(
                    height: Adapt.px(8),
                    color: ThemeColor.color190,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      OXNavigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: Adapt.px(17),
                      ),
                      width: double.infinity,
                      height: Adapt.px(80),
                      color: ThemeColor.color180,
                      child: Text(
                        Localized.text('ox_common.cancel'),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 16, color: ThemeColor.color0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectTimeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CommonTimeDialog(
          callback: (time) async {
            if(widget.chatId == null) OXNavigator.pop(context);
            await OXChatBinding.sharedInstance.updateChatSession(widget.chatId!, expiration: time);
            String username = Account.sharedInstance.me?.name ?? '';

            String setMsgContent = Localized.text('ox_chat.set_msg_auto_delete_system').replaceAll(r'${username}', username).replaceAll(r'${time}', (time ~/ (24*3600)).toString());
            String disableMsgContent = Localized.text('ox_chat.disabled_msg_auto_delete_system').replaceAll(r'${username}', username);
            String content =  time > 0 ? setMsgContent : disableMsgContent;

            _sendSystemMsg(content: content,localTextKey: content);

            setState(() {});
            CommonToast.instance.show(context, Localized.text('ox_chat.success'));
            OXNavigator.pop(context);
            OXNavigator.pop(context);
          },
          expiration: _autoDelExTime,
        );
      },
    );
  }

  void _updateSafeChat() async {
    String? chatId = widget.chatId;
    if (chatId == null) return;

    int kind = _safeChatStatus ? 4 : 1059;

    await OXChatBinding.sharedInstance.updateChatSession(chatId, messageKind: kind);
    String username = Account.sharedInstance.me?.name ?? '';


    String normalDmContent = Localized.text('ox_chat.set_normal_dm_system').replaceAll(r'${username}', username);
    String giftWrappedDmContent = Localized.text('ox_chat.set_gift_wrapped_dm_system').replaceAll(r'${username}', username);
    String content =  kind == 4 ? normalDmContent : giftWrappedDmContent;

    _sendSystemMsg(content:content, localTextKey:content);

    CommonToast.instance.show(context, 'Success');
    OXNavigator.pop(context);
    setState(() {});
  }

  void _updateAutoDel() async {
    String? chatId = widget.chatId;
    if (chatId == null) return;
    OXNavigator.pop(context);
    _selectTimeDialog();
  }

  Widget _chatControlDialogItemWidget(
      {required bool isSelect,
      required GestureTapCallback onTap,
      required String content}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: Adapt.px(17),
        ),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Adapt.px(16),
            fontWeight: isSelect ? FontWeight.w600 : FontWeight.w400,
            color: ThemeColor.color0,
          ),
        ),
      ),
    );
  }

  void _clickCall() async {
    if (userDB.pubKey ==
        OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
      CommonToast.instance.show(context, "Don't call yourself");
    } else {
      OXActionModel? oxActionModel = await OXActionDialog.show(
        context,
        data: [
          OXActionModel(
              identify: 0,
              text: 'str_video_call'.localized(),
              iconName: 'icon_call_video.png',
              package: 'ox_chat',
              isUseTheme: true),
          OXActionModel(
              identify: 1,
              text: 'str_voice_call'.localized(),
              iconName: 'icon_call_voice.png',
              package: 'ox_chat',
              isUseTheme: true),
        ],
        backGroundColor: ThemeColor.color180,
        separatorCancelColor: ThemeColor.color190,
      );
      if (oxActionModel != null) {
        OXModuleService.pushPage(
          context,
          'ox_calling',
          'CallPage',
          {
            'userDB': userDB,
            'media': oxActionModel.identify == 1
                ? CallMessageType.audio.text
                : CallMessageType.video.text,
          },
        );
      }
    }
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
      await Contacts.sharedInstance.muteFriend(userDB.pubKey);
    } else {
      await Contacts.sharedInstance.unMuteFriend(userDB.pubKey);
    }
    final bool result =
        await OXUserInfoManager.sharedInstance.setNotification();
    await OXLoading.dismiss();
    if (result) {
      OXChatBinding.sharedInstance.sessionUpdate();
      setState(() {
        _isMute = value;
        userDB.mute = value;
        _initModelList();
      });
    } else {
      CommonToast.instance
          .show(context, Localized.text('ox_chat.mute_fail_toast'));
    }
  }

  void _itemClick(OtherInfoItemType type) async {
    if (type == OtherInfoItemType.Remark) {
      LogUtil.e('Michael: goto ContactFriendsRemarkPage');
      String? result = await OXNavigator.pushPage(
        context,
        (context) => ContactFriendRemarkPage(
          userDB: userDB,
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
          'userDB': userDB,
        },
      );
    } else if(type == OtherInfoItemType.Moments) {
      OXModuleService.pushPage(
        context,
        'ox_discovery',
        'PersonMomentsPage',
        {
          'userDB': userDB,
        },
      );
    }
  }

  Future<BadgeDB?> _getUserSelectedBadgeInfo(UserDB friendDB) async {
    UserDB? friendUserDB = await Account.sharedInstance.getUserInfo(friendDB.pubKey);
    LogUtil.e(
        'Michael: friend_user_info_page  _getUserSelectedBadgeInfo : ${friendUserDB!.name ?? ''}; badges =${friendUserDB.badges ?? 'badges null'}');
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

  void _verifiedDNS() async {
    var isVerifiedDNS = await OXUserInfoManager.sharedInstance.checkDNS(userDB: userDB);
    if (this.mounted) {
      setState(() {
        _isVerifiedDNS = isVerifiedDNS;
      });
    }
  }

  void _sendSystemMsg({required String localTextKey,required String content}){
    OXModuleService.invoke('ox_chat', 'sendSystemMsg', [
      context
    ], {
      Symbol('content'): content,
      Symbol('localTextKey'): localTextKey,
      Symbol('chatId'): widget.chatId,
    });

  }
}
