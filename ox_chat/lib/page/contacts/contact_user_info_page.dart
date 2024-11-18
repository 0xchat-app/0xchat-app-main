

import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/widgets/common_gradient_tab_bar.dart';


import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';

import 'package:ox_common/widgets/common_appbar.dart';

import 'package:ox_module_service/ox_module_service.dart';

import 'contact_groups_widget.dart';
import 'contact_media_widget.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'contact_user_option_widget.dart';


class ContactUserInfoPage extends StatefulWidget {
  final String pubkey;
  final String? chatId;

  ContactUserInfoPage({Key? key, required this.pubkey, this.chatId}) : super(key: key);

  @override
  State<ContactUserInfoPage> createState() => _ContactUserInfoPageState();
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

class _ContactUserInfoPageState extends State<ContactUserInfoPage> with SingleTickerProviderStateMixin {

  final ScrollController _scrollController = ScrollController();
  late UserDBISAR userDB;
  String myPubkey = '';

  List<TabModel> modelList = [];

  List<EMoreOptionType> moreOptionList = [
    EMoreOptionType.secretChat,
    EMoreOptionType.messageTimer,
    EMoreOptionType.message,
  ];

  late TabController tabController;

  int? lastTimestamp;
  final int pageSize = 51;
  bool hasLatMore = false;

  List<types.CustomMessage> messagesList = [];

  ValueNotifier<bool> isScrollBottom = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    _initData();
    tabController = TabController(length: EInformationType.values.length, vsync: this);
    _scrollController.addListener(() {
      bool isBottom = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50;
      isScrollBottom.value = isBottom;
    });
  }

  void _initData(){
    userDB = Account.sharedInstance.userCache[widget.pubkey]?.value ?? UserDBISAR(pubKey: widget.pubkey);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
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
        length: EInformationType.values.length, // Tab 的数量
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              ContactUserOptionWidget(pubkey: widget.pubkey, chatId: widget.chatId,),
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
                      data: EInformationType.values
                          .map((type) => type.text)
                          .toList(),
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
                isScrollBottom:isScrollBottom,
                userDB: userDB,
              ),
              OXModuleService.invoke(
                'ox_usercenter',
                'showUserCenterBadgeWallPage',
                [context],
                {
                  #userDB: userDB,
                  #isShowTabBar: false,
                  #isShowBadgeAwards: false
                },
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
            ],
          ).setPaddingOnly(top: 8.px),
        ),
      ),
    );
  }
}
