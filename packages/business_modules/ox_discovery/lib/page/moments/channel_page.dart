import 'dart:math';
import 'dart:ui';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/model/channel_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';


import 'package:flutter/cupertino.dart';


class ChannelPage extends StatefulWidget {
  final int currentIndex;

  const ChannelPage({Key? key,required this.currentIndex}): super(key: key);

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage>
    with
        AutomaticKeepAliveClientMixin,
        OXUserInfoObserver,
        WidgetsBindingObserver,
        CommonStateViewMixin {
  final RefreshController _refreshController = RefreshController();
  late Image _placeholderImage;

  List<ChannelModel?> _channelModelList = [];

  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    Localized.addLocaleChangedCallback(onLocaleChange);
    WidgetsBinding.instance.addObserver(this);
    String localAvatarPath = 'assets/images/icon_group_default.png';
    _placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(76),
      height: Adapt.px(76),
      package: 'ox_common',
    );
    _getHotChannels(type: widget.currentIndex + 1,context: context);

  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      if(widget.currentIndex == 2){
        _getLatestChannelList();
      }else{
        _getHotChannels(type: widget.currentIndex + 1,context: context);
      }
    }
  }

  @override
  void dispose() {
    OXUserInfoManager.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
        break;
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return OXSmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: _onRefresh,
      onLoading: null,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _topSearch(),
            commonStateViewWidget(context, bodyWidget()),
          ],
        ),
      ),
    );
  }

  Widget bodyWidget() {
    return Padding(
      padding: EdgeInsets.only(
          left: Adapt.px(24), right: Adapt.px(24), bottom: Adapt.px(120)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: hotChatViews(),
      ),
    );
  }

  void _onRefresh() async {
    if (widget.currentIndex == 2) {
      _getLatestChannelList();
    } else {
      _getHotChannels(type: widget.currentIndex + 1);
    }
    _refreshController.refreshCompleted();
  }

  List<Widget> hotChatViews() {
    double width = MediaQuery.of(context).size.width;
    return _channelModelList.map((item) {
      return Container(
          margin: EdgeInsets.only(top: Adapt.px(16.0)),
          child: GestureDetector(
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: Container(
                  width: Adapt.px(width - 24 * 2),
                  color: Colors.transparent,
                  child: Container(
                      decoration: BoxDecoration(
                        color: ThemeColor.color190,
                        borderRadius:
                        BorderRadius.all(Radius.circular(Adapt.px(16))),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Stack(
                                children: [
                                  ClipRect(
                                    child: Transform.scale(
                                      alignment: Alignment.center,
                                      scale: 1.2,
                                      child: OXCachedNetworkImage(
                                        height: Adapt.px(100),
                                        imageUrl: item?.picture ?? '',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorWidget: (context, url, error) =>
                                        _placeholderImage,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 6, sigmaY: 6),
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: Adapt.px(20), top: Adapt.px(53)),
                                padding: EdgeInsets.all(Adapt.px(1)),
                                decoration: BoxDecoration(
                                  color: ThemeColor.color190,
                                  border: Border.all(
                                      color: ThemeColor.color180,
                                      width: Adapt.px(3)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Adapt.px(8))),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Adapt.px(4))),
                                  child: OXCachedNetworkImage(
                                    imageUrl: item?.picture ?? '',
                                    height: Adapt.px(60),
                                    width: Adapt.px(60),
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                    _placeholderImage,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Adapt.px(10),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: Adapt.px(16), right: Adapt.px(16)),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              item?.channelName ?? '',
                              maxLines: 1,
                              style: TextStyle(
                                  color: ThemeColor.color0,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: Adapt.px(20),
                            margin: EdgeInsets.only(
                                left: Adapt.px(16), right: Adapt.px(16)),
                            alignment: Alignment.bottomLeft,
                            child: FutureBuilder(
                                future: _getCreator(item?.owner ?? ''),
                                builder: (context, snapshot) {
                                  return Text(
                                    '${Localized.text('ox_common.by')} ${snapshot.data}',
                                    style: TextStyle(
                                      color: ThemeColor.color100,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                  );
                                }),
                          ),
                          SizedBox(
                            height: Adapt.px(12),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Adapt.px(16),
                              ),
                              FutureBuilder(
                                initialData: const [].cast<String>(),
                                future: _getChannelMembersAvatars(
                                    item?.latestChatUsers ?? []),
                                builder: (context, snapshot) {
                                  List<String> avatars = snapshot.data ?? [];
                                  return avatars.isEmpty
                                      ? const SizedBox()
                                      : _buildAvatarStack(avatars);
                                },
                              ),
                              item?.msgCount != null
                                  ? Expanded(
                                child: Text(
                                  '${item?.msgCount} ${Localized.text('ox_discovery.msg_count')}',
                                  style: TextStyle(
                                    fontSize: Adapt.px(13),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                                  : Container(),
                            ],
                          ).setPadding(EdgeInsets.only(
                              bottom: Adapt.px(item?.msgCount != null ||
                                  item?.latestChatUsers != null
                                  ? 20
                                  : 0))),
                        ],
                      )),
                )),
            onTap: () async {
              bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
              if (isLogin) {
                LogUtil.e("groupId : ${item?.channelId}");
                OXModuleService.pushPage(
                    context, 'ox_chat', 'ChatGroupMessagePage', {
                  'chatId': item?.channelId,
                  'chatName': item?.channelName,
                  'chatType': ChatType.chatChannel,
                  'time': item?.createTimeMs,
                  'avatar': item?.picture,
                  'groupId': item?.channelId,
                });
              } else {
                await OXModuleService.pushPage(
                    context, "ox_login", "LoginPage", {});
              }
            },
          ));
    }).toList();
  }

  Widget _buildAvatarStack(List<String> avatarURLs) {
    final avatarCount = min(avatarURLs.length, 4);
    avatarURLs = avatarURLs.sublist(0, avatarCount);

    double maxWidth = Adapt.px(32);
    if (avatarURLs.length > 1) {
      maxWidth = Adapt.px(avatarURLs.length * 26);
    }

    return Container(
      margin: EdgeInsets.only(
        right: Adapt.px(10),
      ),
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: Adapt.px(32),
      ),
      child: AvatarStack(
        settings: RestrictedPositions(
          // maxCoverage: 0.1,
          // minCoverage: 0.2,
            align: StackAlign.left,
            laying: StackLaying.first),
        borderColor: ThemeColor.color180,
        height: Adapt.px(32),
        avatars: avatarURLs
            .map((url) {
          if (url.isEmpty) {
            return const AssetImage('assets/images/user_image.png',
                package: 'ox_common');
          } else {
            return OXCachedImageProviderEx.create(
              url,
              height: Adapt.px(26),
            );
          }
        })
            .toList()
            .cast<ImageProvider>(),
      ),
    );
  }

  Widget _topSearch() {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      autofocus: true,
      onTap: () {
        OXModuleService.pushPage(context, 'ox_chat', 'SearchPage', {});
      },
      child: Container(
        width: width,
        margin: EdgeInsets.symmetric(
          horizontal: Adapt.px(24),
          vertical: Adapt.px(6),
        ),
        height: Adapt.px(48),
        decoration: BoxDecoration(
          color: ThemeColor.color190,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(16))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: Adapt.px(18)),
              child: CommonImage(
                  iconName: 'icon_chat_search.png',
                  width: Adapt.px(24),
                  height: Adapt.px(24),
                  fit: BoxFit.cover,
                  package: 'ox_chat'),
            ),
            SizedBox(
              width: Adapt.px(8),
            ),
            Text(
              Localized.text('ox_chat.search'),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: Adapt.px(15),
                color: ThemeColor.color150,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerViewForIndex(String leftTitle, int index) {
    return SizedBox(
      height: Adapt.px(45),
      child: Row(
        children: [
          SizedBox(
            width: Adapt.px(24),
          ),
          Text(
            leftTitle,
            style: TextStyle(
                color: ThemeColor.titleColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // CommonImage(
          //   iconName: "more_icon_z.png",
          //   width: Adapt.px(39),
          //   height: Adapt.px(8),
          // ),
          SizedBox(
            width: Adapt.px(16),
          ),
        ],
      ),
    );
  }

  Future<void> _getHotChannels(
      {required int type, BuildContext? context}) async {
    List<ChannelModel> channels =
    await getHotChannels(type: type, context: context);

    if (channels.isEmpty) {
      if(mounted){
        setState(() {
          updateStateView(CommonStateView.CommonStateView_NoData);
        });
      }
    } else {
      if(mounted){
        setState(() {
          updateStateView(CommonStateView.CommonStateView_None);
          _channelModelList = channels;
        });
      }
    }
  }

  Future<List<UserDBISAR>> _getChannelMembers(List<String> pubKeys) async {
    List<UserDBISAR> users = [];
    for (var element in pubKeys) {
      UserDBISAR? user = await Account.sharedInstance.getUserInfo(element);
      if (user != null) {
        users.add(user);
      }
    }
    return users;
  }

  Future<List<String>> _getChannelMembersAvatars(List<String> pubKeys) async {
    List<String?> avatars = [];
    List<UserDBISAR> users = await _getChannelMembers(pubKeys);
    avatars.addAll(users.map((e) => e.picture).toList());
    return avatars.where((e) => e != null).toList().cast<String>();
  }

  Future<String> _getCreator(String pubKey) async {
    List<String> pubKeys = [pubKey];
    List<UserDBISAR> users = await _getChannelMembers(pubKeys);
    return users.first.name ?? '';
  }

  Future<void> _getLatestChannelList() async {
    try {
      OXLoading.show(status: Localized.text('ox_common.loading'));
      List<ChannelDBISAR> channelDBList =
      await Channels.sharedInstance.searchChannelsFromRelay();
      OXLoading.dismiss();
      List<ChannelModel> channels = channelDBList
          .map((channelDB) => ChannelModel.fromChannelDB(channelDB))
          .toList();
      if (channels.isEmpty) {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_NoData);
        });
      } else {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_None);
          _channelModelList = channels;
        });
      }
    } catch (error, stack) {
      OXLoading.dismiss();
      LogUtil.e("get LatestChannel failed $error\r\n$stack");
    }
  }

  @override
  void didLoginSuccess(UserDBISAR? userInfo) {
    // TODO: implement didLoginSuccess
    setState(() {});
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
    LogUtil.e("find.didLogout()");
    setState(() {});
  }

  @override
  void didSwitchUser(UserDBISAR? userInfo) {
    // TODO: implement didSwitchUser
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void didRelayStatusChange(String relay, int status) {
    setState(() {});
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  onLocaleChange() {
    if (mounted) setState(() {});
  }
}
