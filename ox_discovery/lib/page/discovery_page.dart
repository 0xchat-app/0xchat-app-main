import 'dart:math';
import 'dart:ui';

import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import '../enum/moment_enum.dart';
import '../model/moment_extension_model.dart';
import '../utils/album_utils.dart';
import 'moments/channel_page.dart';
import 'moments/create_moments_page.dart';
import 'moments/group_moments_page.dart';
import 'moments/public_moments_page.dart';
import 'package:ox_common/business_interface/ox_discovery/ox_discovery_model.dart';
import 'package:flutter/cupertino.dart';

enum EDiscoveryPageType{
  moment,
  channel
}


class DiscoveryPage extends StatefulWidget {

  const DiscoveryPage({Key? key}): super(key: key);

  @override
  State<DiscoveryPage> createState() => DiscoveryPageState();
}

class DiscoveryPageState extends DiscoveryPageBaseState<DiscoveryPage>
    with
        AutomaticKeepAliveClientMixin,
        OXUserInfoObserver,
        WidgetsBindingObserver,
        CommonStateViewMixin {

  int _channelCurrentIndex = 0;


  EDiscoveryPageType pageType = EDiscoveryPageType.moment;


  GlobalKey<PublicMomentsPageState> publicMomentPageKey = GlobalKey<PublicMomentsPageState>();

  EPublicMomentsPageType publicMomentsPageType = EPublicMomentsPageType.all;

  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    Connect.sharedInstance.addConnectStatusListener((relay, status, relayKinds) {
      if(mounted) setState(() {});
    });
    _isLogin = OXUserInfoManager.sharedInstance.isLogin;
  }

  void _momentPublic(){
    publicMomentPageKey.currentState?.momentScrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
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
    double momentMm = boundingTextSize(
            Localized.text('ox_discovery.moment'),
            TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Adapt.px(20),
                color: ThemeColor.titleColor))
        .width;
    double discoveryMm = boundingTextSize(
        Localized.text('ox_discovery.channel'),
        TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Adapt.px(20),
            color: ThemeColor.titleColor))
        .width;
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: AppBar(
        backgroundColor: ThemeColor.color200,
        elevation: 0,
        titleSpacing: 0.0,
        actions: _actionWidget(),
        title: Row(
          children: [
            SizedBox(
              width: Adapt.px(24),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  pageType = EDiscoveryPageType.moment;
                });
              },
              child: Container(
                constraints: BoxConstraints(maxWidth: momentMm),
                child: GradientText(Localized.text('ox_discovery.moment'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Adapt.px(20),
                        color: ThemeColor.titleColor),
                    colors: [
                     pageType == EDiscoveryPageType.moment ? ThemeColor.gradientMainStart : ThemeColor.color120,
                     pageType == EDiscoveryPageType.moment ? ThemeColor.gradientMainEnd : ThemeColor.color120,
                    ]),
              ),
            ),
            SizedBox(
              width: Adapt.px(24),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  pageType = EDiscoveryPageType.channel;
                });
              },
              child: Container(
                constraints: BoxConstraints(maxWidth: discoveryMm),
                child: GradientText(Localized.text('ox_discovery.channel'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Adapt.px(20),
                        color: ThemeColor.titleColor),
                    colors: [
                      pageType == EDiscoveryPageType.channel ? ThemeColor.gradientMainStart : ThemeColor.color120,
                      pageType == EDiscoveryPageType.channel ? ThemeColor.gradientMainEnd : ThemeColor.color120,
                    ]),
              ),
            ),
            SizedBox(
              width: Adapt.px(24),
            ),
          ],
        ),
      ),
      body: _body(),
    );
  }

  List<Widget> _actionWidget(){
    if(pageType == EDiscoveryPageType.moment) {
      return [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: CommonImage(
            iconName: "moment_option.png",
            width: Adapt.px(24),
            height: Adapt.px(24),
            color: ThemeColor.color100,
            package: 'ox_discovery',
          ),
          onTap: () {
            showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (context) => _buildMomentBottomDialog());
          },
        ),
        SizedBox(
          width: Adapt.px(20),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: CommonImage(
            iconName: "moment_add_icon.png",
            width: Adapt.px(24),
            height: Adapt.px(24),
            color: ThemeColor.color100,
            package: 'ox_discovery',
          ),
          onLongPress: (){
            OXNavigator.presentPage(context, (context) => const CreateMomentsPage(type: EMomentType.content));
          },
          onTap: () {
            CreateMomentDraft? createMomentMediaDraft = OXMomentCacheManager.sharedInstance.createMomentMediaDraft;
            if(createMomentMediaDraft!= null){
              final type = createMomentMediaDraft.type;
              final imageList = type == EMomentType.picture ? createMomentMediaDraft.imageList : null;
              final videoPath = type == EMomentType.video ? createMomentMediaDraft.videoPath : null;
              OXNavigator.presentPage(
                context,
                  (context) => CreateMomentsPage(
                    type: type,
                    imageList: imageList,
                    videoPath: videoPath,
                  ),
              );
              return;
            }
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => _buildCreateMomentBottomDialog());
          },
        ),
        SizedBox(
          width: Adapt.px(24),
        ),
      ];
    }

    return [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: CommonImage(
          iconName: "nav_more_new.png",
          width: Adapt.px(24),
          height: Adapt.px(24),
          color: ThemeColor.color100,
        ),
        onTap: () {
          showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (context) => _buildChannelBottomDialog());
        },
      ),
      _isLogin ? SizedBox(
        height: Adapt.px(24),
        child: GestureDetector(
          onTap: () {
            OXModuleService.invoke('ox_usercenter', 'showRelayPage', [context]);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonImage(
                iconName: 'icon_relay_connected_amount.png',
                width: Adapt.px(24),
                height: Adapt.px(24),
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: Adapt.px(4),
              ),
              Text(
                '${Account.sharedInstance.getConnectedRelaysCount()}/${Account.sharedInstance.getAllRelaysCount()}',
                style: TextStyle(
                  fontSize: Adapt.px(14),
                  color: ThemeColor.color100,
                ),
              ),
            ],
          ),
        ),
      ).setPaddingOnly(left: 20.px) : const SizedBox(),
      SizedBox(
        width: Adapt.px(24),
      ),
    ];
  }

  Widget _body(){
    if(pageType == EDiscoveryPageType.moment)  return PublicMomentsPage(key:publicMomentPageKey,publicMomentsPageType: publicMomentsPageType,);
    return ChannelPage(currentIndex: _channelCurrentIndex);
  }

  static Size boundingTextSize(String text, TextStyle style,
      {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
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

  Widget _buildChannelBottomDialog() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color:  ThemeColor.color160,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            Localized.text('ox_discovery.recommended_item'),
            index: 0,
            onTap: () => _updateChannelCurrentIndex(0),
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            Localized.text('ox_discovery.popular_item'),
            index: 1,
            onTap: () => _updateChannelCurrentIndex(1),
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            Localized.text('ox_discovery.latest_item'),
            index: 2,
            onTap: () => _updateChannelCurrentIndex(2),
          ),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildItem(Localized.text('ox_common.cancel'), index: 3, onTap: () {
            OXNavigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildItem(String title, {required int index, GestureTapCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: Adapt.px(56),
        child: Text(
          title,
          style: TextStyle(
            color: ThemeColor.color0,
            fontSize: Adapt.px(16),
            fontWeight: index == _channelCurrentIndex ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildCreateMomentBottomDialog() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            Localized.text('ox_discovery.choose_camera_option'),
            index: -1,
            onTap: () {
              OXNavigator.pop(context);
              AlbumUtils.openCamera(context, (List<String> imageList) {
                OXNavigator.presentPage(
                  context,
                  (context) => CreateMomentsPage(
                      type: EMomentType.picture, imageList: imageList),
                );
              });
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            Localized.text('ox_discovery.choose_image_option'),
            index: -1,
            onTap: () {
              OXNavigator.pop(context);
              AlbumUtils.openAlbum(context, type: 1,
                  callback: (List<String> imageList) {
                OXNavigator.presentPage(
                  context,
                  (context) => CreateMomentsPage(
                    type: EMomentType.picture,
                    imageList: imageList,
                  ),
                );
              });
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            Localized.text('ox_discovery.choose_video_option'),
            index: -1,
            onTap: () {
              OXNavigator.pop(context);
              AlbumUtils.openAlbum(
                  context,
                  type: 2,
                  selectCount: 1,
                  callback: (List<String> imageList) {
                OXNavigator.presentPage(
                  context,
                  (context) => CreateMomentsPage(
                    type: EMomentType.video,
                    videoPath: imageList[0],
                    videoImagePath: imageList[1],
                  ),
                );
              });
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildItem(Localized.text('ox_common.cancel'), index: 3, onTap: () {
            OXNavigator.pop(context);
          }),
          SizedBox(
            height: Adapt.px(21),
          ),
        ],
      ),
    );
  }

  Widget _buildMomentBottomDialog() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMomentItem(
            isSelect: publicMomentsPageType == EPublicMomentsPageType.all,
            EPublicMomentsPageType.all.text,
            index: 0,
            onTap: () {
              OXNavigator.pop(context);
              if(mounted){
                publicMomentsPageType = EPublicMomentsPageType.all;
              }
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildMomentItem(
            isSelect: publicMomentsPageType == EPublicMomentsPageType.contacts,
            EPublicMomentsPageType.contacts.text,
            index: 1,
            onTap: () {
              OXNavigator.pop(context);
              if(mounted){
                publicMomentsPageType = EPublicMomentsPageType.contacts;
              }
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildMomentItem(
            isSelect: publicMomentsPageType == EPublicMomentsPageType.follows,
            EPublicMomentsPageType.follows.text,
            index: 1,
            onTap: () {
              OXNavigator.pop(context);
              if(mounted){
                publicMomentsPageType = EPublicMomentsPageType.follows;
              }
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildMomentItem(
            isSelect: publicMomentsPageType == EPublicMomentsPageType.private,
            EPublicMomentsPageType.private.text,
            index: 1,
            onTap: () {
              OXNavigator.pop(context);
              if(mounted){
                publicMomentsPageType = EPublicMomentsPageType.private;
              }
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildMomentItem(Localized.text('ox_common.cancel'), index: 3, onTap: () {
            OXNavigator.pop(context);
          }),
          SizedBox(
            height: Adapt.px(21),
          ),
        ],
      ),
    );
  }

  Widget _buildMomentItem(String title,
      {required int index, GestureTapCallback? onTap,bool isSelect = false}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: Adapt.px(56),
        child: Text(
          title,
          style: TextStyle(
            color: isSelect ? ThemeColor.purple1 : ThemeColor.color0,
            fontSize: Adapt.px(16),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  void _updateChannelCurrentIndex(int index){
    setState(() {
      _channelCurrentIndex = index;
    });
    OXNavigator.pop(context);
  }


  @override
  void didLoginSuccess(UserDB? userInfo) {
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
  void didSwitchUser(UserDB? userInfo) {
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

  @override
  void updateClickNum(int num) {
    if(pageType == EDiscoveryPageType.channel) return;
    if(num == 1) return _momentPublic();
    publicMomentPageKey.currentState?.updateNotesList(true,isWrapRefresh:true);
  }
}
