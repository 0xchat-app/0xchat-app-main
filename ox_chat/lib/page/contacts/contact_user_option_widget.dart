import 'dart:convert';
import 'dart:io';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:ox_chat/page/contacts/contact_friend_remark_page.dart';
import 'package:ox_chat/page/session/chat_message_page.dart';
import 'package:ox_chat/page/session/single_search_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';

import 'package:ox_common/business_interface/ox_chat/call_message_type.dart';

import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/utils/custom_uri_helper.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/widgets/common_action_dialog.dart';
import 'package:ox_common/widgets/common_platform_widget.dart';

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
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';


import 'contact_create_secret_chat.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class TabModel {
  Function onTap;
  GestureTapDownCallback? onTapDown;
  final String iconName;
  final String content;
  TabModel({
    required this.onTap,
    required this.iconName,
    required this.content,
    this.onTapDown,
  });
}

class ContactUserOptionWidget extends StatefulWidget {
  final String pubkey;
  final String? chatId;
  final ValueNotifier<bool> isBlockStatus;

  ContactUserOptionWidget({Key? key, required this.pubkey, this.chatId,required this.isBlockStatus}) : super(key: key);

  @override
  State<ContactUserOptionWidget> createState() => _ContactUserOptionWidgetState();
}

enum EOtherInfoItemType { Remark, Bio, Pubkey, Badges, Mute, Moments, Link }

enum EMoreOptionType {
  secretChat,
  messageTimer,
  message,
  userOption,
  remark,
}

enum EInformationType {
  media,
  badges,
  moments,
  groups,
}

extension EInformationTypeEx on EInformationType {
  String get text {
    switch (this) {
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
      case EMoreOptionType.remark:
        return 'Edit remark';
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
      case EMoreOptionType.remark:
        return 'chat_remark.png';
    }
  }
}

extension OtherInfoItemStr on EOtherInfoItemType {
  String get text {
    switch (this) {
      case EOtherInfoItemType.Remark:
        return Localized.text('ox_chat.remark');
      case EOtherInfoItemType.Bio:
        return Localized.text('ox_chat.bio');
      case EOtherInfoItemType.Pubkey:
        return Localized.text('ox_chat.public_key');
      case EOtherInfoItemType.Badges:
        return Localized.text('ox_chat.badges');
      case EOtherInfoItemType.Mute:
        return Localized.text('ox_chat.mute_item');
      case EOtherInfoItemType.Moments:
        return Localized.text('ox_discovery.moment');
      case EOtherInfoItemType.Link:
        return 'Share Link';
    }
  }
}

class _ContactUserOptionWidgetState extends State<ContactUserOptionWidget> with SingleTickerProviderStateMixin {
  ChatSessionModelISAR? get _chatSessionModel {
    ChatSessionModelISAR? model =
    OXChatBinding.sharedInstance.sessionMap[widget.chatId];
    return model;
  }

  final ScrollController _scrollController = ScrollController();
  Image _avatarPlaceholderImage = Image.asset(
    'assets/images/icon_user_default.png',
    fit: BoxFit.contain,
    width: 60.px,
    height: 60.px,
    package: 'ox_common',
  );


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


  List<TabModel> modelList = [];

  List<EMoreOptionType> moreOptionList = [
    EMoreOptionType.remark,
    // EMoreOptionType.secretChat, // Secret chat temporarily disabled
    EMoreOptionType.messageTimer,
    EMoreOptionType.message,
  ];

  String _userQrCodeUrl = '';
  String _showUserQrCodeUrl = '';


  final GlobalKey _moreIconKey = GlobalKey();

  ValueNotifier<bool> isScrollBottom = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    _initData();
    _initModelList();
    getShareLink();
    _scrollController.addListener(() {
      bool isBottom = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50;
      isScrollBottom.value = isBottom;
    });
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
    _showUserQrCodeUrl = link;
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
          onTap: _sendMsg,
          iconName: 'icon_message.png',
          content:  Localized.text('ox_chat.message'),
        ),
        if(PlatformUtils.isMobile)
        TabModel(
          onTap: _clickCall,
          iconName: 'icon_chat_call.png',
          content: Localized.text('ox_chat.call'),
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
            SingleSearchPage(chatId: widget.pubkey,).show(context);
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
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Column(
            children: [
              _buildHeadImage(),
              _buildHeadName(),
              _buildHeadDesc(),
              _buildHeadPubKey(),
              _tabContainerView(),
              _bioOrLinkWidget(EOtherInfoItemType.Link, _userQrCodeUrl),
              _bioOrLinkWidget(EOtherInfoItemType.Bio, userDB.about ?? ''),
              _addFriendBtnView(),
              _blockStatusBtnView(),
            ],
          ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
        ],
      ).setPaddingOnly(bottom: 16.px),
    );
  }

  Widget _tabContainerView() {
    return Container(
      constraints: BoxConstraints(
        maxWidth:  PlatformUtils.listWidth,
      ),
      margin: EdgeInsets.only(top: 16.px),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 0),
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 4.px,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (BuildContext context, int index) {
          TabModel model = modelList[index];
          return _tabWidget(
              onTapDown: model.onTapDown,
              content: model.content,
              onTap: model.onTap,
              iconName: model.iconName);
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
              color: ThemeColor.color100,
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

  Widget _bioOrLinkWidget(EOtherInfoItemType type, String content) {
    Widget linkQrCodeWidget = const SizedBox();
    if(EOtherInfoItemType.Bio == type){
      bool isShowBio = content.isEmpty || content == 'null';
      if(isShowBio) return const SizedBox();
    }

    if(EOtherInfoItemType.Link == type){
      linkQrCodeWidget = GestureDetector(
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
      );
    }
    return GestureDetector(
      onTap: () {
        if (type == EOtherInfoItemType.Link) {
          _copyLinkDialog();
        }
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: PlatformUtils.listWidth,
        ),
        // width: double.infinity,
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
                  width: 300.px,
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
            linkQrCodeWidget,
          ],
        ),
      ).setPaddingOnly(top: 16.px),
    );
  }

  Widget _buildHeadPubKey() {
    String encodedPubKey = userDB.encodedPubkey;

    String newPubKey = '';
    Widget copyPubKeyIcon = const SizedBox();
    if (encodedPubKey.isNotEmpty) {
      final String start = encodedPubKey.substring(0, 16);
      final String end = encodedPubKey.substring(encodedPubKey.length - 16);

      newPubKey = '$start:$end';

      copyPubKeyIcon = CommonImage(
        iconName: "icon_copy.png",
        width: Adapt.px(16),
        height: Adapt.px(16),
        useTheme: true,
      );
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
            copyPubKeyIcon,
          ],
        ),
      ),
    );
  }

  Widget _addFriendBtnView() {
    bool friendsStatus = false;
    bool isMe = myPubkey == widget.pubkey;
    friendsStatus = isFriend(userDB.pubKey ?? '');
    myPubkey = OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey ?? '';
    if (friendsStatus && !isMe) return const SizedBox();

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: Adapt.px(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
          isMe  ?  'Send Message' : 'Add Contact',
          style: TextStyle(
            color: myPubkey != widget.pubkey && friendsStatus
                ? ThemeColor.red
                : Colors.white,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: isMe ? _sendMsg : _addFriends,
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
    bool isBlocked = _isInBlockList();

    if (isBlocked) {
      OKEvent event = await Contacts.sharedInstance.removeBlockList([pubKey]);
      if (event.status) {
        _updateOptionList(addOption: true);
      } else {
        CommonToast.instance.show(context, Localized.text('ox_chat.un_block_fail'));
      }
    } else {
      _showBlockDialog(pubKey);
    }
  }

  void _updateOptionList({required bool addOption}) {
    widget.isBlockStatus.value = !addOption;
    if (addOption && !moreOptionList.contains(EMoreOptionType.userOption)) {
      moreOptionList.add(EMoreOptionType.userOption);
    } else if (!addOption && moreOptionList.contains(EMoreOptionType.userOption)) {
      moreOptionList.remove(EMoreOptionType.userOption);
    }
    setState(() {});
  }

  void _showBlockDialog(String pubKey) {
    OXCommonHintDialog.show(
      context,
      title: Localized.text('ox_chat.block_dialog_title'),
      content: Localized.text('ox_chat.block_dialog_content'),
      actionList: [
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context, false);
        }),
        OXCommonHintAction.sure(
          text: Localized.text('ox_common.confirm'),
          onTap: () async {
            OKEvent event = await Contacts.sharedInstance.addToBlockList(pubKey);
            if (event.status) {
              _updateOptionList(addOption: false);
              OXChatBinding.sharedInstance.deleteSession([pubKey]);
              OXNavigator.pop(context, true);
            } else {
              CommonToast.instance.show(context, Localized.text('ox_chat.block_fail'));
            }
          },
        ),
      ],
      isRowAction: true,
    );
  }


  Future<void> _clickKey(String keyContent) async {
    await Clipboard.setData(
      ClipboardData(
        text: keyContent,
      ),
    );
    await CommonToast.instance.show(context, 'copied_to_clipboard'.commonLocalized());
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
                OXChatBinding.sharedInstance
                    .changeChatSessionTypeAll(userDB.pubKey, true);
                CommonToast.instance
                    .show(context, Localized.text('ox_chat.sent_successfully'));
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

  void _copyLinkDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(12)),
            color: ThemeColor.color180,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMomentItem(
                'Copy Link',
                index: 0,
                onTap: () async {
                  await TookKit.copyKey(context, _showUserQrCodeUrl);
                  CommonToast.instance.show(context, 'Copy successfully !');
                  OXNavigator.pop(context);
                },
              ),
              Divider(
                color: ThemeColor.color170,
                height: Adapt.px(0.5),
              ),
              Container(
                height: Adapt.px(8),
                color: ThemeColor.color190,
              ),
              _buildMomentItem(
                Localized.text('ox_common.cancel'),
                index: 3,
                onTap: () {
                  OXNavigator.pop(context);
                },
              ),
              SizedBox(
                height: Adapt.px(21),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMomentItem(String title,
      {required int index, GestureTapCallback? onTap, bool isSelect = false}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: Adapt.px(56),
        child: Text(
          title,
          style: TextStyle(
            color: isSelect ? ThemeColor.purple1 : ThemeColor.color0,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onTap: onTap,
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
                      color: type == EMoreOptionType.userOption
                          ? ThemeColor.red
                          : ThemeColor.color100,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                CommonImage(
                  iconName: type.icon,
                  size: 24.px,
                  package: 'ox_chat',
                  color: type == EMoreOptionType.userOption
                      ? ThemeColor.red
                      : ThemeColor.color100,
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
          case EMoreOptionType.remark:
            OXNavigator.pushPage(
              context,
                  (context) => ContactFriendRemarkPage(userDB: userDB),
            );
            break;
        }
      },
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
}
