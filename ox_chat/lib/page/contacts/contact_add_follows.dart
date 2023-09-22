import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:flutter/services.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'contact_user_info_page.dart';

enum FollowsFriendStatus {
  hasFollows,
  selectFollows,
  unSelectFollows,
}

class DiyUserDB {
  bool isSelect;
  UserDB db;
  DiyUserDB(this.isSelect, this.db);
}

extension GetFollowsFriendStatusPic on FollowsFriendStatus {
  String get picName {
    switch (this) {
      case FollowsFriendStatus.hasFollows:
        return 'icon_has_follows.png';
      case FollowsFriendStatus.selectFollows:
        return 'icon_select_follows.png';
      case FollowsFriendStatus.unSelectFollows:
        return 'icon_unSelect_follows.png';
    }
  }
}

class ContactAddFollows extends StatefulWidget {
  @override
  _ContactAddFollowsState createState() => new _ContactAddFollowsState();
}

class _ContactAddFollowsState extends State<ContactAddFollows> {
  // full follows
  List<DiyUserDB>? userMapList = null;
  // select follows
  List<DiyUserDB> selectFollowsList = [];
  // unSelect follows
  List<DiyUserDB> unSelectFollowsList = [];
  // contacts List
  List<DiyUserDB> contactsFollowsList = [];

  @override
  void initState() {
    super.initState();
    _getFollowList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getFollowList() async {
    await OXLoading.show();
    String pubKey = OXUserInfoManager.sharedInstance.currentUserInfo!.pubKey;
    List userMap = await Account.sharedInstance.syncFollowListFromRelay(pubKey);
    await OXLoading.dismiss();
    List<DiyUserDB> db = [];

    userMap.forEach((info) => {db.add(new DiyUserDB(false, info))});
    userMapList = db;
    _resetFollowsData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_chat.import_follows'),
        backgroundColor: ThemeColor.color190,
        actions: [
          _appBarActionWidget(),
          SizedBox(
            width: Adapt.px(24),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Adapt.px(24),
                  vertical: Adapt.px(12),
                ),
                child: Text(
                  Localized.text('ox_chat.import_follows_tips'),
                  style: TextStyle(
                    color: ThemeColor.color0,
                    fontSize: Adapt.px(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    userMapList != null && userMapList!.length > 0
                        ? ListView.builder(
                            padding: EdgeInsets.only(
                              left: Adapt.px(24),
                              right: Adapt.px(24),
                              bottom: Adapt.px(100),
                            ),
                            primary: false,
                            itemCount: userMapList!.length,
                            itemBuilder: (context, index) {
                              return _followsFriendWidget(index);
                            },
                          )
                        : _emptyWidget(),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: Adapt.px(37),
                      child: _addContactBtnView(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBarActionWidget() {
    bool isAllFriends =
        unSelectFollowsList.length == 0 && selectFollowsList.length == 0;
    if (userMapList == null || userMapList?.length == 0 || isAllFriends)
      return Container(
        width: Adapt.px(24),
      );
    bool isSelectAll = unSelectFollowsList.length == 0;
    String content = isSelectAll ? 'None' : 'All';
    return GestureDetector(
      onTap: () {
        userMapList!.forEach((DiyUserDB useDB) {
          useDB.isSelect = !isSelectAll;
        });
        _resetFollowsData();
        setState(() {});
      },
      child: Center(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                ThemeColor.gradientMainEnd,
                ThemeColor.gradientMainStart,
              ],
            ).createShader(Offset.zero & bounds.size);
          },
          child: Text(
            content,
            style: TextStyle(
              fontSize: Adapt.px(16),
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _followsFriendWidget(int index) {
    DiyUserDB userInfo = userMapList![index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Adapt.px(4),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  //
                  _followsUserPicWidget(userInfo),
                  _followsUserInfoWidget(userInfo),
                ],
              ),
            ),
            _followsStatusView(index),
          ],
        ),
      ),
    );
  }

  Widget _followsUserPicWidget(DiyUserDB userInfo) {
    UserDB userDB = userInfo.db;
    Widget picWidget;
    if ((userDB.picture != null && userDB.picture!.isNotEmpty)) {
      picWidget = CachedNetworkImage(
        imageUrl: userInfo.db.picture ?? '',
        fit: BoxFit.contain,
        placeholder: (context, url) => _badgePlaceholderImage,
        errorWidget: (context, url, error) => _badgePlaceholderImage,
        width: Adapt.px(40),
        height: Adapt.px(40),
      );
    } else {
      picWidget = CommonImage(
        iconName: 'user_image.png',
        width: Adapt.px(40),
        height: Adapt.px(40),
      );
    }

    return GestureDetector(
      onTap: () async {
        await OXNavigator.pushPage(
            context, (context) => ContactUserInfoPage(userDB: userDB));
        _resetFollowsData();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          Adapt.px(40),
        ),
        child: picWidget,
      ),
    );
    //
  }

  Image _badgePlaceholderImage = Image.asset(
    'assets/images/user_image.png',
    fit: BoxFit.cover,
    width: Adapt.px(32),
    height: Adapt.px(32),
    package: 'ox_common',
  );

  Widget _followsUserInfoWidget(DiyUserDB userInfo) {
    UserDB userDB = userInfo.db;
    String? nickName = userDB.nickName;
    String name = (nickName != null && nickName.isNotEmpty)
        ? nickName
        : userDB.name ?? '';
    String encodedPubKey = userDB.encodedPubkey ?? '';
    int pubKeyLength = encodedPubKey.length;
    String encodedPubKeyShow =
        '${encodedPubKey.substring(0, 10)}...${encodedPubKey.substring(pubKeyLength - 10, pubKeyLength)}';

    return Container(
      padding: EdgeInsets.only(
        left: Adapt.px(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Text(
            name,
            style: TextStyle(
              color: _isContacts(userInfo.db.pubKey)
                  ? ThemeColor.color100
                  : ThemeColor.color0,
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w600,
            ),
          )),
          Container(
            child: Text(
              encodedPubKeyShow,
              style: TextStyle(
                color: ThemeColor.color120,
                fontSize: Adapt.px(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addContactBtnView() {
    if (userMapList == null || userMapList!.length == 0 || selectFollowsList.length == 0) return Container();
    return GestureDetector(
      onTap: _addContactsFn,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Adapt.px(24),
        ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
                fontSize: Adapt.px(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(5)),
              child: Text(
                selectFollowsList.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Adapt.px(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              'Contacts',
              style: TextStyle(
                color: Colors.white,
                fontSize: Adapt.px(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _followsStatusView(int index) {
    DiyUserDB userDB = userMapList![index];
    String picName = '';
    bool isContacts = _isContacts(userDB.db.pubKey);
    if (isContacts) {
      picName = FollowsFriendStatus.hasFollows.picName;
    } else {
      picName = userDB.isSelect
          ? FollowsFriendStatus.selectFollows.picName
          : FollowsFriendStatus.unSelectFollows.picName;
    }

    return GestureDetector(
      onTap: () {
        if (isContacts) return;
        userMapList![index].isSelect = !userDB.isSelect;
        _resetFollowsData();
      },
      child: Container(
        padding: EdgeInsets.all(Adapt.px(8)),
        child: assetIcon(
          picName,
          24.0,
          24.0,
          useTheme: false,
        ),
      ),
    );
  }

  Widget _emptyWidget() {
    if (userMapList == null) return Container();
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 87.0),
      child: Column(
        children: <Widget>[
          CommonImage(
            iconName: 'icon_no_login.png',
            width: Adapt.px(90),
            height: Adapt.px(90),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: MyText(
              Localized.text('ox_chat.import_follows_no_data'),
              14,
              ThemeColor.gray02,
            ),
          ),
        ],
      ),
    );
  }

  void _addContactsFn() async {
    await OXLoading.show();
    List<String> selectFollowPubKey = [];
    selectFollowsList.forEach((DiyUserDB info) {
      selectFollowPubKey.add(info.db.pubKey ?? '');
    });
    final OKEvent okEvent =
        await Contacts.sharedInstance.addToContact(selectFollowPubKey);
    await OXLoading.dismiss();
    if (okEvent.status) {
      OXChatBinding.sharedInstance.contactUpdatedCallBack();
      for(var pubkey in selectFollowPubKey) {
        OXChatBinding.sharedInstance.changeChatSessionTypeAll(pubkey, true);
      }
      OXNavigator.pop(context, true);
    } else {
      CommonToast.instance.show(context, okEvent.message);
    }
  }

  bool _isContacts(String pubKey) {
    Map<String, UserDB> allContacts = Contacts.sharedInstance.allContacts;
    bool isContacts = allContacts[pubKey] != null;
    return isContacts;
  }

  void _resetFollowsData() {
    List<DiyUserDB> selectFollows = [];
    List<DiyUserDB> unSelectFollows = [];
    List<DiyUserDB> contactsFollows = [];

    userMapList!.forEach((DiyUserDB info) {
      if (_isContacts(info.db.pubKey)) return contactsFollows.add(info);
      info.isSelect ? selectFollows.add(info) : unSelectFollows.add(info);
    });

    selectFollowsList = selectFollows;
    unSelectFollowsList = unSelectFollows;
    contactsFollowsList = contactsFollows;

    setState(() {});
  }
}
