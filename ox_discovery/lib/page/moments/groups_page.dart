import 'dart:ui';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_discovery/enum/group_type.dart';
import 'package:ox_discovery/model/group_model.dart';
import 'package:ox_theme/ox_theme.dart';
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
import 'package:ox_common/widgets/custom_avatar_stack.dart';

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
    _initData();
  }

  _initData() {
    bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
    if(isLogin) {
      widget.groupType == GroupType.openGroup ? _getRelayGroupList() : _getChannelList();
    } else {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_NotLogin);
      });
    }
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

  Future<void> _updateGroupList() async {
    if (widget.groupType == GroupType.openGroup) {
      _groupList.clear();
      await _getRelayGroupList();
    } else {
      _groupList.clear();
      await _getChannelList();
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
      itemCount: _groupList.values.length,
      itemBuilder: (context, index) {
        final group = _groupList.values.elementAt(index);
        return _buildHotGroupCard(group);
      },
    );
  }

  Widget _buildHotGroupCard(GroupModel group) {
    double width = MediaQuery.of(context).size.width;
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
                borderRadius: BorderRadius.circular(16.px),
              ),
              child: Column(
                children: [
                  _buildCardBackgroundWidget(group.picture ?? ''),
                  _buildGroupInfoWidget(group),
                  _buildCreatorWidget(group.creator ?? ''),
                  _buildMembersInfoWidget(group.members ?? []),
                ],
              ),
            ),
          ),
        ),
        onTap: () => _hotGroupCardOnTap(group),
      ),
    );
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
            // Positioned.fill(
            //   child: ClipRect(
            //     child: BackdropFilter(
            //       filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            //       child: Container(
            //         color: Colors.transparent,
            //       ),
            //     ),
            //   ),
            // ),
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
    return CustomAvatarStack(
      maxAvatars: 5,
      imageUrls: avatarURLs,
      avatarSize: 32.px,
      spacing: 8.px,
      borderColor: ThemeColor.color180,
    );
  }

  Widget _buildMembersInfoWidget(List<String> members) {
    if (members.isEmpty) return const SizedBox();
    final count = members.length;
    return Row(
      children: [
        FutureBuilder(
          future: _getMembersAvatars(members),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return _buildAvatarStack(snapshot.data ?? []);
            }
            return const SizedBox();
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
    await Future.forEach(
      pubKeys,
      (element) async {
        UserDBISAR? user = await Account.sharedInstance.getUserInfo(element);
        if (user != null) {
          users.add(user);
        }
      },
    );
    return users;
  }

  Future<List<String>> _getMembersAvatars(List<String> pubKeys) async {
    List<String> avatars = [];
    List<UserDBISAR> users = await _getMembers(pubKeys);
    avatars.addAll(users.map((e) => e.picture ?? '').toList());
    return avatars;
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
          if(widget.groupType == GroupType.channel) return;
          for(var group in groups){
            _groupList[group.groupId] = GroupModel.fromRelayGroupDB(group);
          }
          if(mounted){
            setState(() {
              updateStateView(CommonStateView.CommonStateView_None);
              var sortedEntries = _groupList.entries.toList()
                ..sort((a, b) => (b.value.members?.length ?? 0).compareTo(a.value.members?.length ?? 0));
              _groupList = Map<String, GroupModel>.fromEntries(sortedEntries);
            });
          }
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
    if (mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
        _initData();
      });
    }
  }

  @override
  void didLogout() {
    if (mounted) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_NotLogin);
      });
    }
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