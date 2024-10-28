import 'dart:convert';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/page/contacts/contact_friend_remark_page.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';
import 'package:ox_common/widgets/common_gradient_tab_bar.dart';
import 'package:ox_common/widgets/common_time_dialog.dart';
import 'package:ox_common/model/chat_session_model_isar.dart';
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
import 'package:ox_theme/ox_theme.dart';

import '../session/unified_search_page.dart';
import 'contact_create_secret_chat.dart';
import 'contact_groups_widget.dart';
import 'contact_links_widget.dart';
import 'contact_media_widget.dart';

class TabModel {
  Function onTap;
  GestureTapDownCallback? onTapDown;
  final String iconName;
  final String content;
  TabModel(
      {required this.onTap,
      required this.iconName,
      required this.content,
      this.onTapDown});
}

class ContactUserInfoPage extends StatefulWidget {
  final String pubkey;
  final String? chatId;

  ContactUserInfoPage({Key? key, required this.pubkey, this.chatId})
      : super(key: key);

  @override
  State<ContactUserInfoPage> createState() => _ContactUserInfoPageState();
}

enum OtherInfoItemType { Remark, Bio, Pubkey, Badges, Mute, Moments, Link }

enum EMoreOptionType {
  secretChat,
  messageTimer,
  message,
  userOption,
}

enum EInformationType {
  media,
  badges,
  moments,
  groups,
}

extension EInformationTypeEx on EInformationType{
  String get text {
    switch(this){
      case EInformationType.media:
        return 'Media';
      case EInformationType.badges:
        return 'Badges';
      case EInformationType.moments:
        return 'Moment';
      case EInformationType.groups:
        return 'Groups';
    }
  }
}


extension MoreOptionTypeEx on EMoreOptionType {
  String get text {
    switch (this) {
      case EMoreOptionType.message:
        return 'Clear messages';
      case EMoreOptionType.messageTimer:
        return 'Enable auto-delete';
      case EMoreOptionType.secretChat:
        return "Start secret chat";
      case EMoreOptionType.userOption:
        return 'Block user';
    }
  }

  String get icon {
    switch (this) {
      case EMoreOptionType.message:
        return 'chat_clear.png';
      case EMoreOptionType.messageTimer:
        return 'chat_auto_delete.png';
      case EMoreOptionType.secretChat:
        return "chat_secret.png";
      case EMoreOptionType.userOption:
        return 'chat_block.png';
    }
  }
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
      case OtherInfoItemType.Link:
        return 'Share Link';
    }
  }
}

class _ContactUserInfoPageState extends State<ContactUserInfoPage>
    with SingleTickerProviderStateMixin {
  ChatSessionModelISAR? get _chatSessionModel {
    ChatSessionModelISAR? model =
        OXChatBinding.sharedInstance.sessionMap[widget.chatId];
    return model;
  }

  final ScrollController _scrollController = ScrollController();
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

  List<BadgeDBISAR> _badgeDBList = [];
  bool _isMute = false;
  bool _isVerifiedDNS = false;
  late UserDBISAR userDB;
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

  List<EMoreOptionType> moreOptionList = [
    EMoreOptionType.secretChat,
    EMoreOptionType.messageTimer,
    EMoreOptionType.message,
  ];

  String _userQrCodeUrl = '';
  late TabController tabController;

  final GlobalKey _moreIconKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _initData();
    _initModelList();
    getShareLink();
    tabController = TabController(length: EInformationType.values.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getShareLink() async {
    List<String> relayAddressList = await Account.sharedInstance
        .getMyGeneralRelayList()
        .map((e) => e.url)
        .toList();
    List<String> relayList = relayAddressList.take(5).toList();
    final nostrValue = Account.encodeProfile(
      OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '',
      relayList,
    );
    String link = CustomURIHelper.createNostrURI(nostrValue);
    _userQrCodeUrl =
        link.substring(0, 15) + '...' + link.substring(link.length - 15);
    setState(() {});
  }

  bool _isInBlockList() {
    return Contacts.sharedInstance.inBlockList(widget.pubkey ?? '');
  }

  void _initModelList() async {
    myPubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    if (myPubkey != widget.pubkey)
      modelList = [
        TabModel(
          onTap: () {
            if (userDB.pubKey ==
                OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
              return CommonToast.instance.show(context, "Don't call yourself");
            }
            OXModuleService.pushPage(
              context,
              'ox_calling',
              'CallPage',
              {'userDB': userDB, 'media': CallMessageType.audio.text},
            );
          },
          iconName: 'icon_chat_call.png',
          content: Localized.text('ox_chat.call'),
        ),
        TabModel(
          iconName: 'chat_camera.png',
          onTap: () {
            if (userDB.pubKey ==
                OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey) {
              return CommonToast.instance.show(context, "Don't call yourself");
            }
            OXModuleService.pushPage(
              context,
              'ox_calling',
              'CallPage',
              {'userDB': userDB, 'media': CallMessageType.video.text},
            );
          },
          content: 'Video',
        ),
        TabModel(
          onTap: () => _onChangedMute(!_isMute),
          iconName: _isMute ? 'icon_mute.png' : 'icon_unmute.png',
          content: _isMute
              ? Localized.text('ox_chat.un_mute_item')
              : Localized.text('ox_chat.mute_item'),
        ),
        TabModel(
          iconName: 'icon_chat_search.png',
          onTap: () {
            OXNavigator.pushPage(context, (context) => UnifiedSearchPage());
          },
          content: 'Search',
        ),
        TabModel(
          onTap: () {},
          onTapDown: (details) => _chatMsgControlDialogWidget(details),
          iconName: 'icon_more_gray.png',
          content: Localized.text('ox_chat.more'),
        ),
      ];

    bool isAddBlock = !_isInBlockList() &&
        !moreOptionList.contains(EMoreOptionType.userOption);
    if (isAddBlock) {
      moreOptionList.add(EMoreOptionType.userOption);
    }
    setState(() {});
  }

  void _initData() async {
    userDB = Account.sharedInstance.userCache[widget.pubkey]?.value ??
        UserDBISAR(pubKey: widget.pubkey);
    _isMute = userDB.mute ?? false;
    if (userDB.badges != null && userDB.badges!.isNotEmpty) {
      List<dynamic> badgeListDynamic = jsonDecode(userDB.badges!);
      List<String> badgeIds = badgeListDynamic.cast();
      List<BadgeDBISAR?> dbGetList =
          await BadgesHelper.getBadgeInfosFromDB(badgeIds);
      if (dbGetList.length > 0) {
        dbGetList.forEach((element) {
          if (element != null) {
            _badgeDBList.add(element);
          }
        });
        if (mounted) setState(() {});
      } else {
        List<BadgeDBISAR> badgeDB =
            await BadgesHelper.getBadgesInfoFromRelay(badgeIds);
        if (badgeDB.length > 0) {
          _badgeDBList = badgeDB;
          if (mounted) setState(() {});
        }
      }
    }
    Account.sharedInstance.reloadProfileFromRelay(userDB.pubKey).then((user) {
      userDB.updateWith(user);
      if (mounted) setState(() {});
    });
    OXChatBinding.sharedInstance.updateChatSession(userDB.pubKey,
        chatName: userDB.name, pic: userDB.picture);
    _verifiedDNS();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        useLargeTitle: false,
        centerTitle: true,
        title: '',
      ),
      body: DefaultTabController(
        length: 3, // Tab 的数量
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // CommonAppBar(),
                    Column(
                      children: [
                        _buildHeadImage(),
                        _buildHeadName(),
                        _buildHeadDesc(),
                        _buildHeadPubKey(),
                        SizedBox(
                          height: Adapt.px(16),
                        ),
                        _tabContainerView(),
                        // _contentList(),
                        _bioOrPubKeyWidget(
                            OtherInfoItemType.Link, _userQrCodeUrl),
                        userDB.about == null ||
                                userDB.about!.isEmpty ||
                                userDB.about == 'null'
                            ? SizedBox()
                            : _bioOrPubKeyWidget(
                                OtherInfoItemType.Bio, userDB.about ?? ''),
                        _delOrAddFriendBtnView(),
                        _blockStatusBtnView(),
                      ],
                    ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
                  ],
                ).setPaddingOnly(bottom: 16.px),
              ),
              SliverAppBar(
                toolbarHeight: 38,
                pinned: true,
                floating: false,
                snap: false,
                primary: false,
                backgroundColor: ThemeColor.color200,
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CommonGradientTabBar(
                      data: EInformationType.values.map((type) => type.text).toList(),
                      controller: tabController,
                    ),
                  ).setPadding(
                    EdgeInsets.symmetric(horizontal: 24.px),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: [
              ContactMediaWidget(
                userDB: userDB,
              ),
              OXModuleService.invoke(
                'ox_usercenter',
                'showUserCenterBadgeWallPage',
                [context],
                {#userDB: userDB,#isShowTabBar:false},
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.px),
                child: OXModuleService.invoke(
                  'ox_discovery',
                  'showPersonMomentsPage',
                  [context],
                  {#userDB: userDB},
                ),
              ),
              ContactGroupsWidget(
                userDB: userDB,
              ),
              // ContactLinksWidget(),
            ],
          ).setPaddingOnly(top: 8.px),
        ),
      ),
    );
  }

  Widget _tabContainerView() {
    // if (!(!_isInBlockList())) return Container();
    // bool isShowMore = widget.chatId != null;
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 0),
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 4.px,
          childAspectRatio: 1.1,
          // mainAxisExtent: _imageWH + Adapt.px(8 + 34),
        ),
        itemBuilder: (BuildContext context, int index) {
          return _tabWidget(
              onTapDown: modelList[index].onTapDown,
              content: modelList[index].content,
              onTap: modelList[index].onTap,
              iconName: modelList[index].iconName);
        },
        itemCount: modelList.length,
      ),
    );
  }

  Widget _tabWidget(
      {required onTap,
      required String iconName,
      required String content,
      GestureTapDownCallback? onTapDown}) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: (details) => onTapDown?.call(details),
      child: Container(
        key: iconName == 'icon_more_gray.png' ? _moreIconKey : null,
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
              color:   ThemeColor.color100,
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

  Widget _bioOrPubKeyWidget(OtherInfoItemType type, String content) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(16)),
        color: ThemeColor.color180,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(16), vertical: Adapt.px(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(bottom: Adapt.px(4)),
                child: Text(
                  type.text,
                  style: TextStyle(
                    fontSize: Adapt.px(14),
                    color: ThemeColor.color100,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 110.px,
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: Adapt.px(14),
                    color: ThemeColor.color0,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: null,
                ),
              ),
            ],
          ),
          type == OtherInfoItemType.Link
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    OXModuleService.invoke('ox_chat', 'showMyIdCardDialog',
                        [context], {#otherUser: userDB});
                  },
                  child: CommonImage(
                    iconName: 'icon_qrcode.png',
                    width: 20.px,
                    height: 20.px,
                    fit: BoxFit.fill,
                    package: 'ox_usercenter',
                    color: ThemeColor.color100,
                  ),
                )
              : Container(),
        ],
      ),
    ).setPaddingOnly(top: 16.px);
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
      onTap: () => _clickKey(encodedPubKey),
      child: Container(
        height: Adapt.px(33),
        margin: EdgeInsets.only(top: Adapt.px(8)),
        padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(12), vertical: Adapt.px(8)),
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
                overflow: TextOverflow.ellipsis,
              ),
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
      return const SizedBox();
    } else {
      friendsStatus = isFriend(userDB.pubKey ?? '');

      if (friendsStatus) return const SizedBox();
      showTxt = Localized.text('ox_chat.add_friend');
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
            color: myPubkey != widget.pubkey && friendsStatus
                ? ThemeColor.red
                : Colors.white,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: myPubkey == widget.pubkey ? _sendMsg : _addFriends,
    ).setPaddingOnly(top: 16.px);
  }

  Widget _blockStatusBtnView() {
    if (myPubkey == widget.pubkey) return const SizedBox();
    bool isInBlocklist = _isInBlockList();
    if (!isInBlocklist) return SizedBox();
    String btnContent = Localized.text('ox_chat.message_menu_un_block');
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
      } else {
        if (!moreOptionList.contains(EMoreOptionType.userOption)) {
          moreOptionList.add(EMoreOptionType.userOption);
          setState(() {});
        }
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
                  OKEvent event =
                      await Contacts.sharedInstance.addToBlockList(pubKey);
                  if (!event.status) {
                    CommonToast.instance
                        .show(context, Localized.text('ox_chat.block_fail'));
                  } else {
                    if (moreOptionList.contains(EMoreOptionType.userOption)) {
                      moreOptionList.remove(EMoreOptionType.userOption);
                      setState(() {});
                    }
                  }
                  OXChatBinding.sharedInstance.deleteSession([pubKey]);
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
              child: FutureBuilder<BadgeDBISAR?>(
                builder: (context, snapshot) {
                  if (snapshot.data == null) return const SizedBox();
                  return OXCachedNetworkImage(
                    imageUrl: snapshot.data?.thumb ?? '',
                    errorWidget: (context, url, error) => badgePlaceholderImage,
                    width: Adapt.px(40),
                    height: Adapt.px(40),
                    fit: BoxFit.cover,
                  );
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
    bool hasNickName = userDB.nickName != null && userDB.nickName!.isNotEmpty;
    String showName = hasNickName ? userDB.nickName! : (userDB.name ?? '');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          showName,
          style: TextStyle(
            color: ThemeColor.titleColor,
            fontSize: 20,
          ),
        ),
      ],
    ).setPaddingOnly(top: 16.px);
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
      OXCommonHintDialog.show(
        context,
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
              final OKEvent okEvent =
                  await Contacts.sharedInstance.addToContact([userDB.pubKey]);
              await OXLoading.dismiss();
              if (okEvent.status) {
                OXChatBinding.sharedInstance.contactUpdatedCallBack();
                OXChatBinding.sharedInstance.changeChatSessionTypeAll(userDB.pubKey, true);
                CommonToast.instance.show(context, Localized.text('ox_chat.sent_successfully'));
                _sendMsg();
              } else {
                CommonToast.instance.show(context, okEvent.message);
              }
            },
          ),
        ],
        isRowAction: true,
      );
    }
  }

  void _sendMsg() {
    ChatMessagePage.open(
      context: context,
      communityItem: ChatSessionModelISAR(
        chatId: userDB.pubKey,
        chatName: userDB.name,
        sender: OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey,
        receiver: userDB.pubKey,
        chatType: ChatType.chatSingle,
      ),
      isPushWithReplace: true,
    );
  }

  void _clearMessage() async {
    OXCommonHintDialog.show(context,
        title: 'Clear Message',
        content: 'Confirm whether to delete all records of the chat ?',
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                String myPubkey =
                    OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ??
                        '';
                Messages.deleteSingleChatMessagesFromDB(
                    myPubkey, userDB.pubKey);
                Messages.deleteSingleChatMessagesFromDB(
                    userDB.pubKey, myPubkey);
                OXNavigator.popToRoot(context);
              }),
        ],
        isRowAction: true);
  }

  void _chatMsgControlDialogWidget(details) {
    return _showMoreOptionMore(context, details.globalPosition);
  }

  void _selectTimeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CommonTimeDialog(
          callback: (time) async {
            if (widget.chatId == null) OXNavigator.pop(context);
            await OXChatBinding.sharedInstance
                .updateChatSession(widget.chatId!, expiration: time);
            String username = Account.sharedInstance.me?.name ?? '';
            String timeStr;
            if (time >= 24 * 3600) {
              timeStr = (time ~/ (24 * 3600)).toString() +
                  ' ' +
                  Localized.text('ox_chat.day');
            } else if (time >= 3600) {
              timeStr =
                  '${(time ~/ 3600).toString()} ${Localized.text('ox_chat.hours')} ${Localized.text('ox_chat.and')} ${((time % 3600) ~/ 60).toString()} ${Localized.text('ox_chat.minutes')}';
            } else {
              timeStr = (time ~/ 60).toString() +
                  ' ' +
                  Localized.text('ox_chat.minutes');
            }
            String setMsgContent =
                Localized.text('ox_chat.set_msg_auto_delete_system')
                    .replaceAll(r'${username}', username)
                    .replaceAll(r'${time}', timeStr);
            String disableMsgContent =
                Localized.text('ox_chat.disabled_msg_auto_delete_system')
                    .replaceAll(r'${username}', username);
            String content = time > 0 ? setMsgContent : disableMsgContent;

            _sendSystemMsg(content: content, localTextKey: content);

            setState(() {});
            CommonToast.instance
                .show(context, Localized.text('ox_chat.success'));
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

    await OXChatBinding.sharedInstance
        .updateChatSession(chatId, messageKind: kind);
    String username = Account.sharedInstance.me?.name ?? '';

    String normalDmContent = Localized.text('ox_chat.set_normal_dm_system')
        .replaceAll(r'${username}', username);
    String giftWrappedDmContent =
        Localized.text('ox_chat.set_gift_wrapped_dm_system')
            .replaceAll(r'${username}', username);
    String content = kind == 4 ? normalDmContent : giftWrappedDmContent;

    _sendSystemMsg(content: content, localTextKey: content);

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

  ///Determine if it's a friend
  bool isFriend(String pubkey) {
    UserDBISAR? user = Contacts.sharedInstance.allContacts[pubkey];
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
    } else if (type == OtherInfoItemType.Moments) {
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

  Future<BadgeDBISAR?> _getUserSelectedBadgeInfo(UserDBISAR friendDB) async {
    UserDBISAR? friendUserDB =
        await Account.sharedInstance.getUserInfo(friendDB.pubKey);
    LogUtil.e(
        'Michael: friend_user_info_page  _getUserSelectedBadgeInfo : ${friendUserDB!.name ?? ''}; badges =${friendUserDB.badges ?? 'badges null'}');
    if (friendUserDB == null) {
      return null;
    }
    String badges = friendUserDB.badges ?? '';
    if (badges.isNotEmpty) {
      List<dynamic> badgeListDynamic = jsonDecode(badges);
      List<String> badgeList = badgeListDynamic.cast();
      BadgeDBISAR? badgeDB;
      try {
        List<BadgeDBISAR?> badgeDBList =
            await BadgesHelper.getBadgeInfosFromDB(badgeList);
        badgeDB = badgeDBList.firstOrNull;
      } catch (error) {
        LogUtil.e("user selected badge info fetch failed: $error");
      }
      return badgeDB;
    }
    return null;
  }

  void _verifiedDNS() async {
    var isVerifiedDNS =
        await OXUserInfoManager.sharedInstance.checkDNS(userDB: userDB);
    if (this.mounted) {
      setState(() {
        _isVerifiedDNS = isVerifiedDNS;
      });
    }
  }

  void _sendSystemMsg({required String localTextKey, required String content}) {
    OXModuleService.invoke('ox_chat', 'sendSystemMsg', [
      context
    ], {
      Symbol('content'): content,
      Symbol('localTextKey'): localTextKey,
      Symbol('chatId'): widget.chatId,
    });
  }

  void _showMoreOptionMore(BuildContext context, Offset position) async {
    final RenderBox iconBox =
        _moreIconKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset iconPosition =
        iconBox.localToGlobal(Offset.zero, ancestor: overlay);
    final Size iconSize = iconBox.size;
    final RelativeRect position = RelativeRect.fromLTRB(
      iconPosition.dx - iconSize.width, // left
      iconPosition.dy + iconSize.height + 2, // top
      overlay.size.width - iconPosition.dx - iconSize.width, // right
      overlay.size.height - (iconPosition.dy + iconSize.height) + 2, // bottom
    );

    await showMenu(
      context: context,
      position: position,
      color: ThemeColor.color180,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      items: <PopupMenuEntry<EMoreOptionType>>[
        ...moreOptionList.map((EMoreOptionType type) {
          return PopupMenuItem<EMoreOptionType>(
            value: type,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    type.text,
                    // type == EMoreOptionType.block ? btnContent : type.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.px,
                      color: type == EMoreOptionType.userOption ? ThemeColor.red : ThemeColor.color100,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                CommonImage(
                  iconName: type.icon,
                  size: 24.px,
                  package: 'ox_chat',
                  color: type == EMoreOptionType.userOption ? ThemeColor.red : ThemeColor.color100,
                ),
              ],
            ),
          );
        }).toList()
      ],
    ).then(
      (value) async {
        if (value == null) return;
        switch (value) {
          case EMoreOptionType.userOption:
            _blockOptionFn();
            break;
          case EMoreOptionType.messageTimer:
            _selectTimeDialog();
            break;
          case EMoreOptionType.message:
            _clearMessage();
            break;
          case EMoreOptionType.secretChat:
            OXNavigator.presentPage(
              context,
              (context) => ContactCreateSecret(userDB: userDB),
            );
            break;
        }
      },
    );
  }
}
