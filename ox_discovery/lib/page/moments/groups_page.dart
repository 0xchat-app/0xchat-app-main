import 'dart:math';
import 'dart:ui';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/enum/group_type.dart';
import 'package:ox_discovery/model/group_model.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

class GroupsPage extends StatefulWidget {
  final GroupType groupType;

  const GroupsPage({Key? key,required this.groupType}): super(key: key);

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage>
    with
        AutomaticKeepAliveClientMixin,
        OXUserInfoObserver,
        WidgetsBindingObserver,
        CommonStateViewMixin {
  final RefreshController _refreshController = RefreshController();

  Map<String, GroupModel> _groupList = {};

  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    Localized.addLocaleChangedCallback(onLocaleChange);
    WidgetsBinding.instance.addObserver(this);
    _getRelayGroupList();
  }

  @override
  void didUpdateWidget(covariant GroupsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.groupType != oldWidget.groupType) {
      _updateGroupList();
    }
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

  void _updateGroupList() {
    if (widget.groupType == GroupType.openGroup) {
      _groupList.clear();
      _getRelayGroupList();
    } else {
      _groupList.clear();
      _getChannelList();
    }
  }

  void _onRefresh() async {
    _updateGroupList();
    _refreshController.refreshCompleted();
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
            commonStateViewWidget(context, _buildBodyWidget()),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: 24.px,
        right: 24.px,
        bottom: 120.px,
      ),
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _buildHotGroupCard(),
        );
      },
    );
  }

  List<Widget> _buildHotGroupCard() {
    double width = MediaQuery.of(context).size.width;
    return _groupList.values.map((item) {
      return Container(
          margin: EdgeInsets.only(top: 16.px),
          child: GestureDetector(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16.px),
                child: Container(
                  width: Adapt.px(width - 24 * 2),
                  color: Colors.transparent,
                  child: Container(
                      decoration: BoxDecoration(
                        color: ThemeColor.color190,
                        borderRadius:BorderRadius.circular(16.px)
                      ),
                      child: Column(
                        children: [
                          _buildCardBackgroundWidget(item.picture ?? ''),
                          _buildGroupInfoWidget(item),
                          _buildCreatorWidget(item.creator ?? ''),
                          _buildMembersInfoWidget(item.members ?? []),
                        ],
                  ),
                ),
              ),
            ),
          onTap: () => _hotGroupCardOnTap(item),
        ),
      );
    }).toList();
  }

  Widget _placeholderImage({double? width, double? height}) {
    String localAvatarPath = 'assets/images/icon_group_default.png';
    return Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: width,
      height: height,
      package: 'ox_common',
    );
  }

  Widget _buildCardBackgroundWidget(String picture) {
    return Stack(
      children: [
        Stack(
          children: [
            ClipRect(
              child: Transform.scale(
                alignment: Alignment.center,
                scale: 1.2,
                child: picture.isNotEmpty
                    ? OXCachedNetworkImage(
                        height: 100.px,
                        imageUrl: picture,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (context, url, error) => _placeholderImage(),
                      )
                    : _placeholderImage(height: 100.px, width: double.infinity),
              ),
            ),
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 20.px, top: 53.px),
          padding: EdgeInsets.all(1.px),
          decoration: BoxDecoration(
            color: ThemeColor.color190,
            border: Border.all(
              color: ThemeColor.color180,
              width: 3.px,
            ),
            borderRadius: BorderRadius.circular(8.px),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.px),
            child: picture.isNotEmpty
                ? OXCachedNetworkImage(
                    imageUrl: picture,
                    height: 60.px,
                    width: 60.px,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => _placeholderImage(),
                  )
                : _placeholderImage(height: 60.px, width: 60.px),
          ),
        )
      ],
    ).setPaddingOnly(bottom: 10.px);
  }

  Widget _buildGroupInfoWidget(GroupModel group) {
    return Container(
      margin: EdgeInsets.only(left: 16.px, right: 16.px,bottom: 8.px),
      alignment: Alignment.bottomLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonImage(
            iconName: group.type.typeIcon,
            size: 28.px,
            package: 'ox_chat',
          ).setPaddingOnly(right: 10.px),
          Expanded(
            child: Text(
              group.name,
              maxLines: 1,
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorWidget(String pubkey) {
    if (pubkey.isEmpty) return const SizedBox();
    return Container(
      height: Adapt.px(20),
      margin: EdgeInsets.only(left: 16.px, right: 16.px),
      alignment: Alignment.bottomLeft,
      child: FutureBuilder(
          future: _getCreator(pubkey),
          builder: (context, snapshot) {
            return Text(
              '${Localized.text('ox_common.by')} ${snapshot.data}',
              style: TextStyle(
                color: ThemeColor.color100,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
              ),
              maxLines: 1,
            );
          }),
    ).setPaddingOnly(bottom: 12.px);
  }

  Widget _buildAvatarStack(List<String> avatarURLs) {
    final avatarCount = min(avatarURLs.length, 5);
    avatarURLs = avatarURLs.sublist(0, avatarCount);

    double maxWidth = Adapt.px(32);
    if (avatarURLs.length > 1) {
      maxWidth = Adapt.px(avatarURLs.length * 26);
    }

    return Container(
      margin: EdgeInsets.only(right: 10.px,),
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: 32.px,
      ),
      child: AvatarStack(
        settings: RestrictedPositions(
          // maxCoverage: 0.1,
          // minCoverage: 0.2,
          align: StackAlign.left,
          laying: StackLaying.first,
        ),
        borderColor: ThemeColor.color180,
        height: 32.px,
        avatars: avatarURLs
            .map((url) {
              if (url.isEmpty) {
                return const AssetImage(
                  'assets/images/user_image.png',
                  package: 'ox_common',
                );
              } else {
                return OXCachedNetworkImageProviderEx.create(
                  context,
                  url,
                  height: 26.px,
                );
              }
            })
            .toList()
            .cast<ImageProvider>(),
      ),
    );
  }

  Widget _buildMembersInfoWidget(List<String> members) {
    if (members.isEmpty) return const SizedBox();
    final count = members.length;
    return Row(
      children: [
        FutureBuilder(
          initialData: const [].cast<String>(),
          future: _getMembersAvatars(members),
          builder: (context, snapshot) {
            List<String> avatars = snapshot.data ?? [];
            return avatars.isEmpty
                ? const SizedBox()
                : _buildAvatarStack(avatars);
          },
        ),
        SizedBox(width: 5.px,),
        Expanded(
          child: Text(
            count > 1 ? '$count ${Localized.text('ox_discovery.members')}' : '$count ${Localized.text('ox_discovery.member')}',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: ThemeColor.color0,
            ),
          ),
        ),
      ],
    ).setPaddingOnly(left: 16.px, bottom: 20.px);
  }

  Widget _topSearch() {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      autofocus: true,
      onTap: () {
        OXModuleService.pushPage(context, 'ox_chat', 'SearchPage', {'searchPageType': 6});
      },
      child: Container(
        width: width,
        margin: EdgeInsets.symmetric(
          horizontal: 24.px,
          vertical: 6.px,
        ),
        height: 48.px,
        decoration: BoxDecoration(
          color: ThemeColor.color190,
          borderRadius: BorderRadius.circular(16.px),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: 18.px),
              child: CommonImage(
                  iconName: 'icon_chat_search.png',
                  width: 24.px,
                  height: 24.px,
                  fit: BoxFit.cover,
                  package: 'ox_chat'),
            ),
            SizedBox(
              width: 8.px,
            ),
            Text(
              Localized.text('ox_chat.search_discovery'),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                color: ThemeColor.color150,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<UserDBISAR>> _getMembers(List<String> pubKeys) async {
    List<UserDBISAR> users = [];
    for (var element in pubKeys) {
      UserDBISAR? user = await Account.sharedInstance.getUserInfo(element);
      if (user != null) {
        users.add(user);
      }
    }
    return users;
  }

  Future<List<String>> _getMembersAvatars(List<String> pubKeys) async {
    List<String?> avatars = [];
    List<UserDBISAR> users = await _getMembers(pubKeys);
    avatars.addAll(users.map((e) => e.picture).toList());
    return avatars.where((e) => e != null).toList().cast<String>();
  }

  Future<String> _getCreator(String pubKey) async {
    List<String> pubKeys = [pubKey];
    List<UserDBISAR> users = await _getMembers(pubKeys);
    return users.first.name ?? '';
  }

  Future<void> _getChannelList() async {
    await Channels.sharedInstance.searchChannelsFromRelay(searchCallBack: (channels){
      for(var channel in channels){
        _groupList[channel.channelId] = GroupModel.fromChannelDB(channel);
      }
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
        var sortedEntries = _groupList.entries.toList()
          ..sort((a, b) => b.value.createTime.compareTo(a.value.createTime));
        _groupList = Map<String, GroupModel>.fromEntries(sortedEntries);
      });
    });
  }

  Future<void> _getRelayGroupList() async {
    await RelayGroup.sharedInstance
        .searchAllGroupsFromRelays((groups) {
          for(var group in groups){
            _groupList[group.groupId] = GroupModel.fromRelayGroupDB(group);
          }
          setState(() {
            updateStateView(CommonStateView.CommonStateView_None);
            var sortedEntries = _groupList.entries.toList()
              ..sort((a, b) => (b.value.members?.length ?? 0).compareTo(a.value.members?.length ?? 0));
            _groupList = Map<String, GroupModel>.fromEntries(sortedEntries);
          });
    });
  }

  void _hotGroupCardOnTap(GroupModel group) async {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if (isLogin) {
      if (group.type == GroupType.openGroup || group.type == GroupType.closeGroup) {
        OXModuleService.pushPage(
          context,
          'ox_chat',
          'ChatRelayGroupMsgPage',
          {
            'chatId': group.groupId,
            'chatName': group.name,
            'chatType': ChatType.chatRelayGroup,
            'time': group.createTimeMs,
            'avatar': group.picture,
            'groupId': group.groupId,
          },
        );
      } else if (group.type == GroupType.channel) {
        OXModuleService.pushPage(
          context,
          'ox_chat',
          'ChatGroupMessagePage',
          {
            'chatId': group.groupId,
            'chatName': group.name,
            'chatType': ChatType.chatChannel,
            'time': group.createTimeMs,
            'avatar': group.picture,
            'groupId': group.groupId,
          },
        );
      }
    } else {
      await OXModuleService.pushPage(context, "ox_login", "LoginPage", {});
    }
  }

  @override
  void dispose() {
    OXUserInfoManager.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  onLocaleChange() {
    if (mounted) setState(() {});
  }
}