import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/page/contacts/contact_channel_create.dart';
import 'package:ox_chat/page/contacts/my_idcard_dialog.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

///Title: message_channel_detail_page
///Description: ()
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/12 16:48

class ContactChanneDetailsPage extends StatefulWidget {
  ChannelDB channelDB;

  ContactChanneDetailsPage({
    Key? key,
    required this.channelDB,
  }) : super(key: key);

  @override
  State<ContactChanneDetailsPage> createState() => _ContactChanneDetailsPageState();
}

enum OtherInfoItemType {
  QRCode,
  ChannelID,
  Relay,
  Mute,
}

extension OtherInfoItemStr on OtherInfoItemType {
  String get text {
    switch (this) {
      case OtherInfoItemType.QRCode:
        return 'QR code';
      case OtherInfoItemType.ChannelID:
        return 'ChannelID';
      case OtherInfoItemType.Relay:
        return 'Relay';
      case OtherInfoItemType.Mute:
        return 'Mute';
    }
  }
}

class _ContactChanneDetailsPageState extends State<ContactChanneDetailsPage> {
  late List<BadgeDB> _badgeDBList;
  final double _imageWH = (Adapt.screenW() - Adapt.px(48 + 18)) / 3;
  bool _isMute = false;
  String? _showCreator;
  late String _badgeRequirementsHint;
  bool _isJoinChannel = false;
  final String badgeRequirementsHint = 'Only users who have met the badge requirements are authorized to send messages.';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _badgeDBList = [];
    _badgeRequirementsHint = 'No badge is required in this channel.';
    _isMute = widget.channelDB.mute ?? false;
    if (widget.channelDB.creator != null && widget.channelDB.creator!.isNotEmpty) {
      final UserDB? userFromDB = await Account.getUserFromDB(pubkey: widget.channelDB.creator!);
      if (userFromDB != null) {
        if (userFromDB.name == null || userFromDB.name!.isEmpty) {
          Map usersMap = await Account.syncProfilesFromRelay([widget.channelDB.creator!]);
          UserDB? user = usersMap[widget.channelDB.creator!];
          if (user == null || user.name!.isEmpty) {
            _showCreator = userFromDB.encodedPubkey;
          } else {
            _showCreator = user?.name ?? '';
          }
        } else {
          _showCreator = userFromDB.name!;
        }
      } else {
        _showCreator = widget.channelDB.creator!;
      }
      setState(() {});
    } else {
      _showCreator = '';
    }
    if (widget.channelDB.badges != null && widget.channelDB.badges!.isNotEmpty) {
      List<dynamic> badgeIds = jsonDecode(widget.channelDB.badges!);
      List<String> badgeList = badgeIds.cast();
      if(badgeList.isNotEmpty) {
        List<BadgeDB?> dbGetList = await BadgesHelper.getBadgeInfosFromDB(badgeList);
        if (dbGetList.length > 0) {
          dbGetList.forEach((element) {
            if (element != null) {
              _badgeDBList.add(element);
            }
          });
          _badgeRequirementsHint = badgeRequirementsHint;
          setState(() {});
        } else {
          List<BadgeDB> badgeDB = await BadgesHelper.getBadgesInfoFromRelay(badgeList);
          if (badgeDB.length > 0) {
            _badgeDBList = badgeDB;
            _badgeRequirementsHint = badgeRequirementsHint;
            if (mounted) {
              setState(() {});
            }
          }
        }
      }
    }

    _isJoinChannel = Channels.sharedInstance.myChannels.containsKey(widget.channelDB.channelId);
  }

  @override
  Widget build(BuildContext context) {
    Image _placeholderImage = Image.asset(
      'assets/images/icon_group_default.png',
      fit: BoxFit.cover,
      width: Adapt.px(32),
      height: Adapt.px(32),
      package: 'ox_chat',
    );

    bool isCreator = OXUserInfoManager.sharedInstance.isCurrentUser(widget.channelDB.creator!);
    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          ///in case,list is not full screen and remove ios Bouncing
          physics: ClampingScrollPhysics(),
          slivers: <Widget>[
            ExtendedSliverAppbar(
              toolBarColor: Colors.transparent,
              title: Text(
                widget.channelDB.name!,
                style: const TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: CommonImage(
                  iconName: "icon_back_left_arrow.png",
                  width: Adapt.px(24),
                  height: Adapt.px(24),
                ),
                onPressed: () {
                  OXNavigator.pop(context);
                },
              ),
              background: Container(
                color: ThemeColor.color190,
                height: Adapt.px(390),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: widget.channelDB.picture!,
                        placeholder: (context, url) => _placeholderImage,
                        errorWidget: (context, url, error) => _placeholderImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: Adapt.px(268),
                            ),
                            Container(
                              height: Adapt.px(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  color: ThemeColor.color190),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: isCreator ? Container(
                margin: EdgeInsets.only(
                  right: Adapt.px(14),
                ),
                color: Colors.transparent,
                child: OXButton(
                  highlightColor: Colors.transparent,
                  color: Colors.transparent,
                  minWidth: Adapt.px(44),
                  height: Adapt.px(44),
                  child: CommonImage(
                    iconName: 'icon_edit.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                  ),
                  onPressed: () {
                    OXNavigator.pushPage(context, (context) => ChatChannelCreate(channelCreateType: ChannelCreateType.edit,channelDB: widget.channelDB,));
                  },
                ),
              ) : Container(),
            ),
            SliverPinnedToBoxAdapter(
              child: Container(
                color: ThemeColor.color190,
                height: Adapt.px(2),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  Widget returnWidget = Container();
                  if (index == 0) {
                    returnWidget = Container(
                      color: ThemeColor.color190,
                      padding: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.channelDB.name!,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: Adapt.px(20), color: ThemeColor.titleColor),
                            ),
                          ),
                          SizedBox(
                            height: Adapt.px(10),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'By',
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: Adapt.px(15), color: ThemeColor.color0),
                                  maxLines: 1,
                                ),
                                SizedBox(
                                  width: Adapt.px(4),
                                ),
                                _showCreator == null
                                    ? Container(
                                        width: Adapt.px(12),
                                        height: Adapt.px(12),
                                        margin: EdgeInsets.only(left: Adapt.px(2), top: Adapt.px(4)),
                                        child: CircularProgressIndicator(
                                          strokeWidth: Adapt.px(2),
                                          backgroundColor: Colors.transparent,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                        ),
                                      )
                                    : SizedBox(
                                        width: Adapt.screenW() - Adapt.px(100),
                                        child: Text(
                                          _showCreator!,
                                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: Adapt.px(15), color: ThemeColor.color0),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Adapt.px(20),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              Localized.text("ox_usercenter.DESCRIPTION"),
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: Adapt.px(14), color: ThemeColor.color100),
                            ),
                          ),
                          SizedBox(
                            height: Adapt.px(8),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.channelDB.about!,
                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: Adapt.px(14), color: ThemeColor.color100),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (index == 1) {
                    returnWidget = Container(
                        color: ThemeColor.color190,
                        padding: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Adapt.px(24),
                            ),
                            Container(
                              child: Text(
                                'Badge Requirements',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: Adapt.px(14), color: ThemeColor.color100),
                              ),
                            ),
                            SizedBox(
                              height: Adapt.px(8),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _badgeRequirementsHint,
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: Adapt.px(14), color: ThemeColor.color100),
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              height: Adapt.px(8),
                            ),
                            _getChildrenWidget(),
                            SizedBox(
                              height: Adapt.px(24),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: ThemeColor.color180,
                              ),
                              child: Column(
                                children: [
                                  _itemView(
                                    iconName: 'icon_channel_id.png',
                                    iconPackage: 'ox_chat',
                                    type: OtherInfoItemType.ChannelID,
                                    rightHint: widget.channelDB.channelId,
                                  ),
                                  Divider(
                                    height: Adapt.px(0.5),
                                    color: ThemeColor.color160,
                                  ),
                                  _itemView(
                                    iconName: 'icon_settings_qrcode.png',
                                    iconPackage: 'ox_usercenter',
                                    type: OtherInfoItemType.QRCode,
                                  ),
                                  Divider(
                                    height: Adapt.px(0.5),
                                    color: ThemeColor.color160,
                                  ),
                                  _itemView(
                                    iconName: 'icon_settings_relays.png',
                                    iconPackage: 'ox_usercenter',
                                    type: OtherInfoItemType.Relay,
                                    rightHint: widget.channelDB.relayURL, // widget.channelDB.fromRelay
                                  ),
                                  Visibility(
                                    visible: _isJoinChannel,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Divider(
                                          height: Adapt.px(0.5),
                                          color: ThemeColor.color160,
                                        ),
                                        _itemView(
                                          iconName: 'icon_mute.png',
                                          iconPackage: 'ox_common',
                                          type: OtherInfoItemType.Mute,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Adapt.px(24),
                            ),
                            Visibility(
                              visible: _isJoinChannel,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _leaveChannel();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ThemeColor.color180,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  width: double.infinity,
                                  height: Adapt.px(48),
                                  child: Text(
                                    'Leave',
                                    style: TextStyle(fontSize: Adapt.px(16), color: ThemeColor.color100),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ],
                        ));
                  } else if (index == 2) {
                    returnWidget = Container(
                      height: Adapt.px(300),
                      color: ThemeColor.color190,
                    );
                  }
                  return returnWidget;
                },
                childCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemView({
    String? iconName,
    String? iconPackage,
    OtherInfoItemType type = OtherInfoItemType.ChannelID,
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
          ? _switchMute()
          : type == OtherInfoItemType.QRCode
              ? CommonImage(
                  iconName: 'icon_arrow_more.png',
                  width: Adapt.px(24),
                  height: Adapt.px(24),
                )
              : Container(
                  width: Adapt.px(100),
                  child: Text(
                    truncateString(rightHint ?? '', 8),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Adapt.px(16),
                      color: ThemeColor.color100,
                    ),
                  ),
                ),
      onTap: () async {
        if (type == OtherInfoItemType.QRCode) {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return MyIdCardDialog(
                  type: CommonConstant.qrCodeChannel,
                  channelDB: widget.channelDB,
                );
              });
        } else if (type == OtherInfoItemType.ChannelID) {
          await TookKit.copyKey(context, rightHint ?? '');
        }
      },
    );
  }

  String truncateString(String str, int truncateAfter) {
    // Add three for the length of the '...'
    final endIndex = (truncateAfter ~/ 2);
    final startIndex = str.length - (truncateAfter ~/ 2);

    return (str.length <= truncateAfter) ? str : '${str.substring(0, endIndex)}...${str.substring(startIndex)}';
  }

  Widget _getChildrenWidget() {
    if (_badgeDBList.length < 1) {
      return Container();
    }
    return Container(
      // height: (_imageWH + Adapt.px(42)) * ((_badgeDBList.length / 3).ceil()),
      alignment: Alignment.topLeft,
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 0),
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: Adapt.px(9),
          // mainAxisExtent: _imageWH + Adapt.px(8 + 34),
        ),
        itemBuilder: _benefitsBuilder,
        itemCount: _badgeDBList.length,
      ),
    );
  }

  Widget _benefitsBuilder(context, index) {
    BadgeDB badgeModel = _badgeDBList[index];
    return Container(
      height: _imageWH,
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            height: Adapt.px(36),
            width: Adapt.px(36),
            imageUrl: badgeModel.image ?? '',
            placeholder: (context, url) => Container(
              color: ThemeColor.gray5,
            ),
            errorWidget: (context, url, error) => Container(
              color: ThemeColor.gray5,
            ),
          ),
          SizedBox(
            height: Adapt.px(8),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              badgeModel.name ?? '',
              style: TextStyle(
                fontSize: Adapt.px(12),
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
                color: ThemeColor.color70,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchMute() {
    return Switch(
      value: _isMute,
      activeColor: Colors.white,
      activeTrackColor: ThemeColor.gradientMainStart,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: ThemeColor.color160,
      onChanged: _onChangedMute,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  void _onChangedMute(bool value) async {
    await OXLoading.show();
    if (value) {
      await Channels.sharedInstance.muteChannel(widget.channelDB.channelId!);
    } else {
      await Channels.sharedInstance.unMuteChannel(widget.channelDB.channelId!);
    }
    final bool result = await OXUserInfoManager.sharedInstance.setNotification();
    await OXLoading.dismiss();
    if (result) {
      OXChatBinding.sharedInstance.sessionUpdate();
      setState(() {
        _isMute = value;
        widget.channelDB.mute = value;
      });
    } else {
      CommonToast.instance.show(context, 'Change failed, please try again later.');
    }
  }

  void _leaveChannel() async {
    OXCommonHintDialog.show(context,
        title: 'Tips',
        content: 'Are you sure you want to leave the channel?',
        actionList: [
          OXCommonHintAction.cancel(onTap: () {
            OXNavigator.pop(context);
          }),
          OXCommonHintAction.sure(
              text: Localized.text('ox_common.confirm'),
              onTap: () async {
                await OXLoading.show();
                final OKEvent okEvent = await Channels.sharedInstance.leaveChannel(widget.channelDB.channelId!);
                await OXLoading.dismiss();
                if (okEvent.status) {
                  OXChatBinding.sharedInstance.channelsUpdatedCallBack();
                  OXNavigator.popToRoot(context);
                } else {
                  OXNavigator.pop(context);
                  CommonToast.instance.show(context, okEvent.message);
                }
              }),
        ],
        isRowAction: true);
  }
}
