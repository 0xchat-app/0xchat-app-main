import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

class DiyUserDB {
  bool isSelect;
  UserDB db;
  DiyUserDB(this.isSelect, this.db);
}

class SelectMentionPage extends StatefulWidget {
  const SelectMentionPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelectMentionPageState();
  }
}

class _SelectMentionPageState extends State<SelectMentionPage> {
  Map<String, DiyUserDB> contactsMap = {};

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getContactsMap();
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: ThemeColor.color200,
        appBar: CommonAppBar(
          backgroundColor: ThemeColor.color200,
          useLargeTitle: false,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              OXNavigator.pop(context);
            },
            child: Center(
              child: CommonImage(
                iconName: "close_icon.png",
                size: 24.px,
                package: 'ox_discovery',
              ).setPaddingOnly(left: 24.px),
            ),
          ),
          title: 'Select mention',
          actions: [
            _appBarActionWidget(),
            SizedBox(
              width: Adapt.px(24),
            ),
          ],
        ),
        body: _body(),
      ),
    );
  }

  Widget _appBarActionWidget() {
    return GestureDetector(
      child: CommonImage(
        iconName: "icon_done.png",
        width: Adapt.px(24),
        height: Adapt.px(24),
        useTheme: true,
      ),
      onTap: () {
        OXNavigator.pop(context, _getMentionSelectUserList());
      },
    );
  }

  Widget _body() {
    return Column(
      children: [
        _searchWidget(),
        SizedBox(height: 12.px),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(
              left: Adapt.px(24),
              right: Adapt.px(24),
              bottom: Adapt.px(100),
            ),
            primary: false,
            itemCount: contactsMap.values.length,
            itemBuilder: (context, index) {
              return _mentionFriendWidget(index);
            },
          ),
        )
      ],
    );
  }

  Widget _mentionFriendWidget(int index) {
    DiyUserDB userInfo = contactsMap.values.toList()[index];
    if (userInfo.db.name != null &&
        !(userInfo.db.name!.contains(_textController.text)) &&
        !(userInfo.db.encodedPubkey.contains(_textController.text))) {
      return const SizedBox();
    }

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
            Row(
              children: [
                _mentionsUserPicWidget(userInfo),
                _mentionsUserInfoWidget(userInfo),
              ],
            ),
            _followsStatusView(index),
          ],
        ),
      ),
    );
  }

  Widget _followsStatusView(int index) {
    DiyUserDB userDB = contactsMap.values.toList()[index];
    String picName = '';
    picName = userDB.isSelect
        ? 'icon_select_follows.png'
        : 'icon_unSelect_follows.png';

    return GestureDetector(
      onTap: () {
        // if (isContacts) return;
        (contactsMap[userDB.db.pubKey] as DiyUserDB).isSelect =
            !userDB.isSelect;
        setState(() {});
        // _resetFollowsData();
      },
      child: Container(
        padding: EdgeInsets.all(Adapt.px(8)),
        child: CommonImage(
          iconName: picName,
          size: 24.px,
          useTheme: false,
          package: 'ox_chat',
        ),
      ),
    );
  }

  Widget _mentionsUserInfoWidget(DiyUserDB userInfo) {
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
          Text(
            name,
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: Adapt.px(16),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            encodedPubKeyShow,
            style: TextStyle(
              color: ThemeColor.color120,
              fontSize: Adapt.px(14),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mentionsUserPicWidget(DiyUserDB userInfo) {
    UserDB userDB = userInfo.db;
    Widget picWidget;
    if ((userDB.picture != null && userDB.picture!.isNotEmpty)) {
      picWidget = OXCachedNetworkImage(
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
        OXModuleService.pushPage(context, 'ox_chat', 'ContactUserInfoPage', {
          'pubkey': userDB.pubKey,
        });
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

  final Image _badgePlaceholderImage = Image.asset(
    'assets/images/user_image.png',
    fit: BoxFit.cover,
    width: Adapt.px(32),
    height: Adapt.px(32),
    package: 'ox_common',
  );

  void _editCompletion() async {
    String text = _textController.text.trim();
    String? info;
    if (text.startsWith('npub')) {
      info = UserDB.decodePubkey(text)!;
    } else if (text.contains('@')) {
      info = await Account.getDNSPubkey(text.substring(0, text.indexOf('@')),
          text.substring(text.indexOf('@') + 1));
    }
    if (info == null) return;
    UserDB? user = await Account.sharedInstance.getUserInfo(info);

    if (user == null) return;
    contactsMap = {
      ...{user.pubKey: DiyUserDB(true, user)},
      ...contactsMap
    };
    _textController.text = '';
    setState(() {});
  }

  Widget _searchWidget() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: Adapt.px(24),
        vertical: Adapt.px(6),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.px,
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
          Expanded(
              child: TextField(
            controller: _textController,
            minLines: 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: Localized.text('ox_chat.please_enter_user_address'),
            ),
          )),
          GestureDetector(
            onTap: _editCompletion,
            child: Container(
              margin: EdgeInsets.only(right: Adapt.px(8), left: Adapt.px(16)),
              child: CommonImage(
                iconName: 'icon_chat_search.png',
                size: 24.px,
                package: 'ox_chat',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noDataWidget() {
    return Padding(
      padding: EdgeInsets.only(
        top: 100.px,
      ),
      child: Center(
        child: Column(
          children: [
            CommonImage(
              iconName: 'icon_no_data.png',
              width: Adapt.px(90),
              height: Adapt.px(90),
            ),
            Text(
              'No friends !',
              style: TextStyle(
                fontSize: 16.px,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color100,
              ),
            ).setPaddingOnly(
              top: 24.px,
            ),
          ],
        ),
      ),
    );
  }

  List<UserDB> _getMentionSelectUserList() {
    List<UserDB> selectMentionsList = [];
    contactsMap.values.map((DiyUserDB diyUserDB) {
      if (diyUserDB.isSelect) {
        selectMentionsList.add(diyUserDB.db);
      }
    }).toList();
    return selectMentionsList;
  }

  void _getContactsMap() {
    List<UserDB> tempList = Contacts.sharedInstance.allContacts.values.toList();
    for (var info in tempList) {
      contactsMap[info.pubKey] = DiyUserDB(false, info);
    }
    setState(() {});
  }
}
