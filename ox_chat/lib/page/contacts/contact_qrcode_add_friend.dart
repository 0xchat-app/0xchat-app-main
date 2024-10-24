
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/widgets/common_network_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ox_chat/page/contacts/contact_add_friend.dart';
import 'package:ox_chat/page/contacts/my_idcard_dialog.dart';
import 'package:ox_chat/utils/widget_tool.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/scan_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/base_page_state.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_scan_page.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_theme/ox_theme.dart';
import '../../model/friends_recommend_model.dart';


///Title: community_qrcode_add_friend
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2023
///@author Michael
class CommunityQrcodeAddFriend extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CommunityQrcodeAddFriendState();
  }
}

class _CommunityQrcodeAddFriendState extends BasePageState<CommunityQrcodeAddFriend> {

  FriendsRecommendModel? homeModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFindData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        useLargeTitle: false,
        centerTitle: true,
        title: Localized.text('ox_chat.add_friend'),
      ),
      body: _body(),
    );
  }

  @override
  String get routeName => 'CommunityQrcodeAddFriend';

  Widget _body() {
    int count =  homeModel?.relatedFriendList?.length ?? 0;
    return NestedScrollView(
        headerSliverBuilder: (BuildContext, bool) {
          return [_getHeadWidget()];
        },
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                  List.generate(count , (int index) {
                    return itemBuilder(context, index);
                  })
              ),
            ),
          ],
        )
    );
  }

  Widget _getHeadWidget() {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _searchWidget(),
          _myCardWidget(),
          _getTitleWidget()
        ],
      ),
    );
  }

  Widget _getTitleWidget(){

    return Container(
      height: Adapt.px(52),
      child: Row(
        children: [
          SizedBox(width: Adapt.px(24),),
          Text(Localized.text('ox_chat.add_contact_suggestion'), style: TextStyle(fontWeight: FontWeight.w600, color: ThemeColor.color10, fontSize: 14),),
          Spacer(),
          GestureDetector(
            child: Text(Localized.text('ox_chat.refresh_text'), style: TextStyle(fontWeight: FontWeight.w600, color: ThemeManager.colors('ox_common.color_818CF8'), fontSize: 14),),
            onTap: (){
              getFindData();
            },
          ),
          SizedBox(width: Adapt.px(24),),
        ],
      ),
    );
  }


  Widget _myCardWidget() {
    return Container(
      margin: EdgeInsets.only(left: Adapt.px(24), right: Adapt.px(24), top: Adapt.px(16)),
      height: Adapt.px(105),
      width: double.infinity,
      // decoration: BoxDecoration(
      //     color: ThemeColor.X1D1D1D,
      //     borderRadius: BorderRadius.all(Radius.circular(Adapt.px(12))),
      //   ),
      child: Row(
        children: [
          Expanded(child: GestureDetector(
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  SizedBox(height: Adapt.px(20),),
                  _itemView('icon_scan_qr.png'),
                  SizedBox(height: Adapt.px(7),),
                  MyText(
                    Localized.text('ox_common.scan_qr_code'),
                    12,
                    ThemeColor.white02,
                  ),
                ],
              ),
            ),
            onTap: (){
              _gotoScan();
            },
          )),

          Expanded(child: GestureDetector(
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  SizedBox(height: Adapt.px(20),),
                  _itemView('icon_business_card.png'),
                  SizedBox(height: Adapt.px(7),),
                  MyText(
                    'my_card'.localized(),
                    12,
                    ThemeColor.white02,
                  ),
                ],
              ),
            ),
            onTap: (){
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return MyIdCardDialog();
                  });
            },
          )),
        ],
      ),
    );
  }

  Widget _itemView(String iconName) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: CommonImage(
            iconName: 'icon_btn_bg.png',
            size: 60.px,
            color: ThemeColor.gray5,
          ),
        ),
        Center(
          child: CommonImage(
            iconName: iconName,
            size: 24.px,
            color: ThemeColor.color0,
          ),
        ),
      ],
    );
  }

  Widget _searchWidget() {
    return InkWell(
      onTap: () {
        OXNavigator.pushPage(context, (context) => CommunityContactAddFriend());
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        width: double.infinity,
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
              margin: EdgeInsets.only(right: Adapt.px(8), left: Adapt.px(16)),
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
              Localized.text('ox_chat.please_enter_user_address'),
              17,
              ThemeColor.color160,
            ),
          ],
        ),
      ),
    );
  }

  void _gotoScan() async {
    if (await Permission.camera.request().isGranted) {
      String? result =
      await OXNavigator.pushPage(context, (context) => CommonScanPage());
      if (result != null) {
        ScanUtils.analysis(context, result);
      }
    } else {
      OXCommonHintDialog.show(context,
          content: Localized.text('yl_home.str_permission_camera_hint'),
          actionList: [
            OXCommonHintAction(
                text: () => Localized.text('yl_home.str_go_to_settings'),
                onTap: () {
                  openAppSettings();
                  OXNavigator.pop(context);
                })
          ]);
    }
  }

  Widget itemBuilder(BuildContext context, int index) {
    String localAvatarPath = 'assets/images/user_image.png';
    Image placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(60),
      height: Adapt.px(60),
      package: 'ox_common',
    );
    return Container(
      height: Adapt.px(98),
      child: Row(
        children: [
          SizedBox(
            width: Adapt.px(20),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(19)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(60)),
              child: OXCachedNetworkImage(
                imageUrl:
                homeModel?.relatedFriendList?[index].headerUrl ?? "",
                fit: BoxFit.cover,
                placeholder: (context, url) => placeholderImage,
                errorWidget: (context, url, error) => placeholderImage,
                width: Adapt.px(60),
                height: Adapt.px(60),
              ),
            ),
          ),
          SizedBox(
            width: Adapt.px(16),
          ),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Adapt.px(18),),
                  Container(
                    height: Adapt.px(20),
                    child: Text(homeModel?.relatedFriendList?[index].nickname ?? '', style: TextStyle(fontWeight: FontWeight.w600, color: ThemeColor.color10, fontSize: 16),),
                  ),

                  SizedBox(height: Adapt.px(2),),
              Container(
                height: Adapt.px(20),
                child: Text(
                  "From Wallet Address",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: ThemeColor.color120,
                      fontSize: 14),
                ),
              ),
              SizedBox(height: Adapt.px(2),),
                  Container(
                    height: Adapt.px(30),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            width: Adapt.px(131),
                            height: Adapt.px(30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
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
                            child: Text(
                              "Add Contact",
                              style: TextStyle(fontSize: Adapt.px(14), fontWeight: FontWeight.w400, color: ThemeColor.color0),
                            ),
                          ),
                          onTap: (){
                            // ChatMethodChannelUtils.gotoFriendInfoView(
                            //   userId: homeModel?.relatedFriendList?[index].userUid ?? '',
                            //   friendSourceUserUid: homeModel?.relatedFriendList?[index].userUid ?? '',
                            //   friendUserAvatarName: homeModel?.relatedFriendList?[index].headerUrl ?? '',
                            //   friendUserNickname: homeModel?.relatedFriendList?[index].nickname ?? '',
                            // );
                          },
                        )
                        ,
                        Spacer(),
                        GestureDetector(
                          child: Container(
                            width: Adapt.px(131),
                            height: Adapt.px(30),
                            alignment: Alignment.center,
                            child: Text(
                              "Remove",
                              style: TextStyle(fontSize: Adapt.px(14), fontWeight: FontWeight.w400, color: ThemeColor.color0),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ThemeColor.color180,
                            ),
                          ),
                          onTap: (){
                            homeModel?.relatedFriendList?.removeAt(index);
                            if (mounted) setState(() {});
                          },
                        ),
                        SizedBox(
                          width: Adapt.px(20),
                        )
                      ],
                    ),
                  )

                ],
              )

          )
        ],
      ),
    );
  }

  getFindData() async {
    // String dataStr = await ChatMethodChannelUtils.getFindData();
    // homeModel = FriendsRecommendModel.fromJson(json.decode(dataStr));
    // if (mounted) setState(() {});
    // LogUtil.e('dataStr ====== ${dataStr}');
  }
}
