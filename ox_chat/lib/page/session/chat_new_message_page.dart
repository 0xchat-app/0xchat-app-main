import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/model/community_menu_option_model.dart';
import 'package:ox_chat/page/contacts/contact_view_friends.dart';
import 'package:ox_chat/page/session/search_page.dart';
import 'package:ox_chat/page/session/unified_search_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_chat/widget/contact.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_chat_binding.dart';
import 'package:ox_common/utils/ox_chat_observer.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:chatcore/chat-core.dart';

class ChatNewMessagePage extends StatefulWidget {
  ChatNewMessagePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChatNewMessagePageState();
  }
}

class _ChatNewMessagePageState extends State<ChatNewMessagePage>
    with CommonStateViewMixin, OXChatObserver {
  final _controller = ScrollController();
  List<CommunityMenuOptionModel> _menuOptionModelList = [];
  GlobalKey<ContactWidgetState> contractWidgetKey = new GlobalKey<ContactWidgetState>();
  List<UserDBISAR> userList = [];

  @override
  void initState() {
    super.initState();
    OXChatBinding.sharedInstance.addObserver(this);
    _menuOptionModelList = CommunityMenuOptionModel.getOptionModelList();
    _loadData();
  }

  @override
  void dispose() {
    OXChatBinding.sharedInstance.removeObserver(this);
    super.dispose();
  }

  void _loadData() {
    Iterable<UserDBISAR> tempList =  Contacts.sharedInstance.allContacts.values;
    userList.clear();
    if (tempList.isNotEmpty) userList.addAll(tempList);
    _showView();
  }

  void _showView() {
    if (this.mounted) {
      contractWidgetKey.currentState?.updateContactData(userList);
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.px),
        child: SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.px),
                topRight: Radius.circular(20.px)),
            child: CommonAppBarNoPreferredSize(
              backgroundColor: ThemeColor.color190,
              title: 'str_title_new_message'.localized(),
              useLargeTitle: false,
              isClose: true,
              centerTitle: false,
              canBack: false,
              actions: [
                SizedBox(width: 48.px),
              ],
            ),
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return ContactWidget(
      key: contractWidgetKey,
      data: userList,
      physics: const BouncingScrollPhysics(),
      topWidget: _topView(),
      bgColor: ThemeColor.color190,
    );
  }

  Widget _topView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _topSearch(),
        _menueWidget(),
      ],
    );
  }

  Widget _menueWidget() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
      scrollDirection: Axis.vertical,
      itemCount: _menuOptionModelList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _getNewItemWidget(index);
      },
    );
  }

  Widget _getNewItemWidget(int index) {
    CommunityMenuOptionModel model = _menuOptionModelList[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 52.px,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32.px,
              height: 32.px,
              alignment: Alignment.center,
              child: CommonImage(
                iconName: model.iconName,
                size: 24.px,
                color: ThemeColor.color100,
              ),
            ),
            SizedBox(width: 12.px),
            MyText(model.content, 14, ThemeColor.color0),
          ],
        ),
      ),
      onTap: () {
        CommunityMenuOptionModel.optionsOnTap(context, model.optionModel);
      },
    );
  }

  Widget _topSearch() {
    return GestureDetector(
      onTap: () {
        UnifiedSearchPage().show(context);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 24.px, vertical: 6.px),
        height: 48.px,
        decoration: BoxDecoration(
          color: ThemeColor.color180,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(16))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: Adapt.px(18)),
              child: assetIcon(
                'icon_chat_search.png',
                24,
                24,
              ),
            ),
            SizedBox(
              width: Adapt.px(8),
            ),
            MyText(
              'search'.localized(),
              15,
              ThemeColor.color150,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didContactUpdatedCallBack() {
    LogUtil.e('Michael: chat_new_message didFriendUpdatedCallBack friends.length=${Contacts.sharedInstance.allContacts.length}');
    _loadData();
  }
}
