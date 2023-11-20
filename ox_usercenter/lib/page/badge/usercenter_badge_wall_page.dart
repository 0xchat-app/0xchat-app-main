import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/model/badge_model.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/page/badge/usercenter_badge_detail_page.dart';
import 'package:chatcore/chat-core.dart';
import 'package:nostr_core_dart/nostr.dart';

///Title: usercenter_badge_wall_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/6 16:21
class UsercenterBadgeWallPage extends StatefulWidget {
  final UserDB? userDB;

  const UsercenterBadgeWallPage({Key? key, required this.userDB}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UsercenterBadgeWallPageState();
  }
}

class _UsercenterBadgeWallPageState extends State<UsercenterBadgeWallPage> {
  List<BadgeModel> _defaultBadgeModelList = [];
  List<BadgeModel> _currentUserBadgeModelList = [];
  final double _imageWH = (Adapt.screenW() - Adapt.px(48 + 32 + 48)) / 3;
  UserDB? _mUserInfo;
  BadgeModel? _selectedBadgeModel;

  @override
  void initState() {
    super.initState();
    _mUserInfo = widget.userDB;
    initData();
  }

  initData() async {
    String userPubkey = _mUserInfo?.pubKey ?? '';
    await _getDefaultBadge();
    await _getUserBadges(userPubkey);
    await _getUserProfileBadge(userPubkey);
  }

  Future<void> _getDefaultBadge() async {
     _defaultBadgeModelList = await BadgeModel.getDefaultBadge();
     if(mounted){
       setState(() {
       });
     }
  }
  
  Future<void> _getUserBadges(String userPubkey) async {
    try{
      List<BadgeAwardDB?> badgeAwardFromDB = await BadgesHelper.getUserBadgesFromDB(userPubkey) ?? [];
      LogUtil.d("current user badge award form DB: $badgeAwardFromDB");
      //user have badge
      if (badgeAwardFromDB.isNotEmpty) {
        _getCurrentUserBadgeModelList(badgeAwardFromDB);
      }
      BadgesHelper.sharedInstance.getUserBadgeAwardsFromRelay(userPubkey).then((badgeAwardFromRelay) {
        if(badgeAwardFromRelay != null){
          LogUtil.d("current user badge award form Relay: $badgeAwardFromRelay");
          if(!listEquals(badgeAwardFromDB, badgeAwardFromRelay)){
            _getCurrentUserBadgeModelList(badgeAwardFromRelay);
          }
        }
      });
    }catch(error,stack){
      LogUtil.e("get user badge award failed: $error\r\n$stack");
    }
  }

  _getCurrentUserBadgeModelList(List<BadgeAwardDB?> badgeAwardDBList){
    _currentUserBadgeModelList.clear();
    if (badgeAwardDBList.isNotEmpty) {
      for (var badgeAwardDB in badgeAwardDBList) {
        for (var badgeModel in _defaultBadgeModelList) {
          if (badgeAwardDB?.identifies == badgeModel.identifies) {
            badgeModel.obtainedTime = badgeAwardDB?.awardTime;
            _currentUserBadgeModelList.add(badgeModel);
          }
        }
      }
      if(mounted){
        setState(() {
        });
      }
      LogUtil.d("current user badge model: $_currentUserBadgeModelList");
    }
  }

  //get the badge set by the user
  Future<void> _getUserProfileBadge(String userPubkey) async {
    String badges = _mUserInfo?.badges ?? '';
    try {
      if(badges.isNotEmpty){
        List<dynamic> badgeListDynamic = jsonDecode(badges);
        List<String> badgeList = badgeListDynamic.cast();
        List<BadgeDB?> badgeDBList = await BadgesHelper.getBadgeInfosFromDB(badgeList);
        if(badgeDBList.isNotEmpty){
          _selectedBadgeModel = BadgeModel.fromBadgeDB(badgeDBList.first!);
        }else{
          _selectedBadgeModel = null;
        }
      }else{
        List<BadgeDB?>? badgeDBList = await BadgesHelper.getProfileBadgesFromRelay(userPubkey);
        if (badgeDBList != null && badgeDBList.isNotEmpty) {
          _selectedBadgeModel = BadgeModel.fromBadgeDB(badgeDBList.first!);
        } else {
          _selectedBadgeModel = null;
        }
      }
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      LogUtil.e("get user profile Badge failed: $error");
    }
  }

  //user set badge
  Future<void> _setUserProfileBadge(BadgeModel badgeModel) async {
    try{
      List<String> id = [badgeModel.badgeId!];
      OKEvent okEvent = await BadgesHelper.setProfileBadges(id);
      //after user set profile Badge complete, update profile database
      if(okEvent.status){
        setState(() {
          _selectedBadgeModel = badgeModel;
        });
        String badges = '["${badgeModel.badgeId}"]';
        _mUserInfo?.badges = badges;
        UserDB? tempUserDB = await Account.sharedInstance.updateProfile(_mUserInfo!);
        if(tempUserDB == null){
          CommonToast.instance.show(context, 'Fail to update profile badge ');
        }
      }
    }catch(error){
      LogUtil.e('User set profile badge failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_usercenter.badges'),
      ),
      backgroundColor: ThemeColor.color190,
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(
        left: Adapt.px(24),
        top: Adapt.px(12),
        right: Adapt.px(24),
        bottom: Adapt.px(44),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _topView(),
            Container(
              margin: EdgeInsets.only(top: Adapt.px(24)),
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(16)),
              decoration: BoxDecoration(
                color: ThemeColor.color180,
                borderRadius: BorderRadius.circular(Adapt.px(12)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    Localized.text('ox_usercenter.0xchat_badge_collection'),
                    style: TextStyle(
                      color: ThemeColor.color100,
                      fontSize: Adapt.px(14),
                    ),
                  ),
                  SizedBox(
                    height: Adapt.px(16),
                  ),
                  Container(
                    height: (_imageWH + Adapt.px(44)) * ((_defaultBadgeModelList.length / 3).ceil()),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: Adapt.px(16),
                        mainAxisExtent: _imageWH + Adapt.px(44),
                      ),
                      itemBuilder: _itemBuilder,
                      itemCount: _defaultBadgeModelList.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapForBadge(int index,bool isHad) async {
    bool isSelected = _defaultBadgeModelList[index].identifies == _selectedBadgeModel?.identifies;
    BadgeModel badgeModel;
    if(isHad){
      badgeModel = _currentUserBadgeModelList.firstWhere((element) => element.identifies == _defaultBadgeModelList[index].identifies);
    }else{
      badgeModel = _defaultBadgeModelList[index];
    }
    var result = await OXNavigator.pushPage(context, (context) => UserCenterBadgeDetailPage(badgeModel: badgeModel ,isHad: isHad,isSelected: isSelected,userDB: _mUserInfo,));
    if (result != null && result is BadgeModel) {
      await _setUserProfileBadge(result);
    }
  }

  Widget _itemBuilder(context, index) {
    BadgeModel _model = _defaultBadgeModelList[index];
    bool isHad = _currentUserBadgeModelList.where((element) => element.identifies == _model.identifies).toList().isNotEmpty;

    Widget placeholderImage = CommonImage(
      iconName: 'icon_badge_default.png',
      fit: BoxFit.cover,
      width: _imageWH,
      height: _imageWH,
      useTheme: true,
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // if(_mUserInfo == null) return;
        // if(_mUserInfo?.pubKey == OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey){
        //
        // }
        _onTapForBadge(index,isHad);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(_imageWH / 2),
                child: Opacity(
                  opacity: isHad ? 1 : 0.36,
                  child: OXCachedNetworkImage(
                    imageUrl: _model.thumbUrl ?? '',
                    fit: BoxFit.contain,
                    placeholder: (context, url) => placeholderImage,
                    errorWidget: (context, url, error) => placeholderImage,
                    width: _imageWH,
                    height: _imageWH,
                  ),
                ),
              ),
              _model.identifies != _selectedBadgeModel?.identifies
                  ? Container()
                  : Positioned(
                    right: Adapt.px(2),
                    top: Adapt.px(2),
                    child: CommonImage(
                      iconName: 'icon_pic_selected.png',
                      width: Adapt.px(20),
                      fit: BoxFit.fill,
                      height: Adapt.px(20),
                    ),
                  ),
            ],
          ),
          SizedBox(
            height: Adapt.px(12),
          ),
          Container(
            child: Text(
              _model.badgeName ?? '',
              style: TextStyle(
                fontSize: Adapt.px(14),
                color: ThemeColor.color100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topView(){
    CommonImage defaultProfileBadge = CommonImage(
      iconName: 'icon_badge_default.png',
      fit: BoxFit.cover,
      width: Adapt.px(80),
      height: Adapt.px(80),
      useTheme: true,
    );
    return Container(
      height: Adapt.px(140),
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.circular(Adapt.px(12)),
      ),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(14), vertical: Adapt.px(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  Localized.text('ox_usercenter.badge_award'),
                  style: TextStyle(
                    color: ThemeColor.color100,
                    fontSize: Adapt.px(14),
                  ),
                ),
                Container(
                  width: Adapt.px(80),
                  height: Adapt.px(80),
                  margin: EdgeInsets.only(top: Adapt.px(8)),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Adapt.px(80)),
                    border: Border.all(
                      width: Adapt.px(2),
                      color: ThemeColor.gradientMainStart,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        ThemeColor.gradientMainEnd.withOpacity(0.24),
                        ThemeColor.gradientMainStart.withOpacity(0.24),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Text(
                    '${_currentUserBadgeModelList.length}/${_defaultBadgeModelList.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: Adapt.px(28),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  Localized.text('ox_usercenter.profile_badge'),
                  style: TextStyle(
                    color: ThemeColor.color100,
                    fontSize: Adapt.px(14),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: Adapt.px(8)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Adapt.px(80)),
                    child: _selectedBadgeModel != null
                        ? OXCachedNetworkImage(
                            imageUrl: _selectedBadgeModel?.thumbUrl ?? '',
                            fit: BoxFit.contain,
                            placeholder: (context, url) => defaultProfileBadge,
                            errorWidget: (context, url, error) => defaultProfileBadge,
                            width: Adapt.px(80),
                            height: Adapt.px(80),
                          )
                        : defaultProfileBadge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
