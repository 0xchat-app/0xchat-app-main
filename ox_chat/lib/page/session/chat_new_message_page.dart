import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_chat/model/community_menu_option_model.dart';
import 'package:ox_chat/page/contacts/contact_view_friends.dart';
import 'package:ox_chat/page/session/search_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_theme/ox_theme.dart';

class ChatNewMessagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatNewMessagePageState();
  }
}

class _ChatNewMessagePageState extends State<ChatNewMessagePage>
    with CommonStateViewMixin {
  final _controller = ScrollController();
  List<CommunityMenuOptionModel> _menuOptionModelList = [];

  @override
  void initState() {
    super.initState();
    _menuOptionModelList = CommunityMenuOptionModel.getOptionModelList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
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
    return Container(
      color: ThemeColor.color190,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        controller: _controller,
        slivers: [
          SliverToBoxAdapter(
            child: _topSearch(),
          ),
          SliverToBoxAdapter(
            child: _menueWidget(),
          ),
          SliverToBoxAdapter(
            child: ContractViewFriends(
              shrinkWrap: true,
              bgColor: ThemeColor.color190,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 120.px),
          ),
        ],
      ),
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
                useTheme: true,
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
        SearchPage().show(context);
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
}
