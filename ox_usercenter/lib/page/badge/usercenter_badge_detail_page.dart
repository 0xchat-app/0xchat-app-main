import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:ox_common/model/badge_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/page/set_up/donate_page.dart';

class UserCenterBadgeDetailPage extends StatefulWidget {
  final BadgeModel badgeModel;
  final bool isHad;
  final bool? isSelected;

  const UserCenterBadgeDetailPage(
      {Key? key,
      required this.badgeModel,
      required this.isHad,
      this.isSelected})
      : super(key: key);

  @override
  State<UserCenterBadgeDetailPage> createState() =>
      _UserCenterBadgeDetailPageState();
}

class _UserCenterBadgeDetailPageState extends State<UserCenterBadgeDetailPage> {

  final GlobalKey<PullToRefreshNotificationState> refreshKey =
      GlobalKey<PullToRefreshNotificationState>();
  StreamController<void> onBuildController = StreamController<void>.broadcast();
  StreamController<bool> followButtonController = StreamController<bool>();
  int listlength = 100;
  double maxDragOffset = 100;
  bool showFollowButton = false;
  final double _imageWH = (Adapt.screenW() - Adapt.px(48 + 18)) / 3;

  @override
  void dispose() {
    onBuildController.close();
    followButtonController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    Image placeholderImage = Image.asset(
      'assets/images/icon_badge_default.png',
      fit: BoxFit.cover,
      width: Adapt.screenW() * 0.6,
      height: Adapt.screenW() * 0.6,
      package: 'ox_common',
    );
    return Scaffold(
      body: SafeArea(
        top: false,
        child: PullToRefreshNotification(
          pullBackOnRefresh: true,
          onRefresh: onRefresh,
          key: refreshKey,
          maxDragOffset: maxDragOffset,
          child: CustomScrollView(
            ///in case,list is not full screen and remove ios Bouncing
            physics: const AlwaysScrollableClampingScrollPhysics(),
            slivers: <Widget>[
              PullToRefreshContainer(
                  (PullToRefreshScrollNotificationInfo? info) {
                final double offset = info?.dragOffset ?? 0.0;
                Widget actions = const Icon(
                  Icons.more_horiz,
                  color: Colors.transparent,
                );
                if (info?.refreshWidget != null) {
                  actions = const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.transparent),
                      strokeWidth: 3,
                    ),
                  );
                }

                actions = Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                    actions,
                  ],
                );
                return ExtendedSliverAppbar(
                  toolBarColor: Colors.transparent,
                  onBuild: (
                    BuildContext context,
                    double shrinkOffset,
                    double? minExtent,
                    double maxExtent,
                    bool overlapsContent,
                  ) {
                    if (shrinkOffset > 0) {
                      onBuildController.sink.add(null);
                    }
                  },
                  isOpacityFadeWithToolbar: false,
                  isOpacityFadeWithTitle: false,
                  title: Text(
                    widget.badgeModel.badgeName ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  leading: const BackButton(
                    onPressed: null,
                    color: Colors.white,
                  ),
                  background: Container(
                    decoration: BoxDecoration(
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
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          width: Adapt.screenW() - Adapt.px(90),
                          height: Adapt.px(384),
                          margin: EdgeInsets.only(
                              top: kToolbarHeight +
                                  statusBarHeight +
                                  Adapt.px(22)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Adapt.px(12)),
                            color: ThemeColor.color190,
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: widget.badgeModel.badgeImageUrl ?? '',
                                placeholder: (context, url) => placeholderImage,
                                errorWidget: (context, url, error) => placeholderImage,
                                width: Adapt.screenW() * 0.6,
                                height: Adapt.screenW() * 0.6,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                height: Adapt.px(16),
                              ),
                              Text(
                                widget.badgeModel.badgeName ?? '',
                                style: TextStyle(
                                  fontSize: Adapt.px(20),
                                  fontWeight: FontWeight.w400,
                                  color: ThemeColor.color0,
                                ),
                              ),
                              SizedBox(
                                height: Adapt.px(8),
                              ),
                              Text(
                                widget.badgeModel.howToGet ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: Adapt.px(14),
                                  color: ThemeColor.color0,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: Adapt.px(4)),
                                child: Text(
                                  widget.badgeModel.obtainedTime != null ? (OXDateUtils.formatTimestamp((widget.badgeModel.obtainedTime!) * 1000, pattern: 'yyyy.MM.dd') + ' obtained') : 'Not yet obtained',
                                  style: TextStyle(
                                    fontSize: Adapt.px(14),
                                    color: ThemeColor.color100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: kToolbarHeight + statusBarHeight,
                            bottom: 0,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: offset,
                                ),
                                SizedBox(
                                  height: Adapt.px(450),
                                ),
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                      color: ThemeColor.color190),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: actions,
                  ),
                );
              }),
              //pinned box
              SliverPinnedToBoxAdapter(
                child: Container(
                  color: Colors.transparent,
                  height: 0.01,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Widget returnWidget = Container();
                    if (index == 0) {
                      returnWidget = Container(
                        color: ThemeColor.color190,
                        padding: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.badgeModel.badgeName ?? '',
                                style: TextStyle(
                                    fontSize: Adapt.px(20),
                                    color: ThemeColor.color0),
                              ),
                            ),
                            SizedBox(
                              height: Adapt.px(4),
                            ),
                            Text(
                              "by ${widget.badgeModel.creator ?? ''}",
                              style: TextStyle(
                                  fontSize: Adapt.px(15),
                                  color: ThemeColor.color0),
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: Adapt.px(24),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Description',
                                style: TextStyle(
                                    fontSize: Adapt.px(14),
                                    fontWeight: FontWeight.w600,
                                    color: ThemeColor.color100),
                              ),
                            ),
                            SizedBox(
                              height: Adapt.px(8),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.badgeModel.description ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: Adapt.px(14),
                                  color: ThemeColor.color100,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (index == 1) {
                      returnWidget = Container();
                    }
                    else if (index == 2) {
                      returnWidget = Container(
                          // height: 300,
                          color: ThemeColor.color190,
                          padding: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Adapt.px(24),
                              ),
                              Text(
                                'Benefits',
                                style: TextStyle(fontSize: Adapt.px(14), color: ThemeColor.color100),
                              ),
                              _getChildrenWidget(),
                            ],
                          ));
                    }
                    else if (index == 3) {
                      returnWidget = Container(
                        color: ThemeColor.color190,
                        padding: EdgeInsets.symmetric(horizontal: Adapt.px(24)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Adapt.px(20),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  Localized.text(
                                      "ox_usercenter.ABOUT_THE_CREATOR"),
                                  style: TextStyle(
                                      fontSize: Adapt.px(14),
                                      fontWeight: FontWeight.w600,
                                      color: ThemeColor.color100),
                                ),
                              ),
                              SizedBox(
                                height: Adapt.px(8),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.badgeModel.creatorAbout ?? '',
                                  style: TextStyle(
                                      fontSize: Adapt.px(14),
                                      fontWeight: FontWeight.w400,
                                      color: ThemeColor.color100),
                                ),
                              ),
                              SizedBox(
                                height: Adapt.px(24),
                              ),
                              SizedBox(
                                height: Adapt.px(0),
                              ),
                            ]),
                      );
                    }
                    return returnWidget;
                  },
                  childCount: 4,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: Adapt.px(80),
        decoration: BoxDecoration(
          color: ThemeColor.color190,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: Adapt.px(0.5),
              color: ThemeColor.color160,
            ),
            GestureDetector(
              child: Container(
                height: Adapt.px(79.5),
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Adapt.px(24), vertical: Adapt.px(16)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Adapt.px(12)),
                    gradient: LinearGradient(
                      colors: !widget.isSelected! ? [
                        ThemeColor.gradientMainEnd,
                        ThemeColor.gradientMainStart,
                      ]
                      :[
                        ThemeColor.color180,
                        ThemeColor.color180,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.isHad ? widget.isSelected! ? 'Selected' : 'Select' : 'Obtain',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Adapt.px(16),
                    ),
                  ),
                ),
              ),
              onTap: () {
                if (!widget.isHad) {
                  OXNavigator.pushPage(context, (context) => const DonatePage());
                }else{
                  if(widget.isSelected!){
                    CommonToast.instance.show(context, "Selected item");
                  }else{
                    OXNavigator.pop(context,widget.badgeModel);
                  }
                }
              },
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.refresh),
      //   onPressed: () {
      //     refreshKey.currentState!.show(
      //       notificationDragOffset: maxDragOffset,
      //     );
      //   },
      // ),
    );
  }

  Widget _getChildrenWidget() {
    if (widget.badgeModel.benefits!.isEmpty) {
      return Container();
    }
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: Adapt.px(9),
        mainAxisExtent: _imageWH + Adapt.px(8 + 34),
      ),
      itemBuilder: _benefitsBuilder,
      itemCount: widget.badgeModel.benefits?.length,
    );
  }

  Widget _benefitsBuilder(context, index) {
    String benefit = widget.badgeModel.benefits?[index] ?? '';
    String benefitsIcon = widget.badgeModel.benefitsIcon?[index] ?? '';
    return benefit.isEmpty
        ? Container()
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: _imageWH,
                  height: _imageWH,
                  // color: Colors.purple,
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: Adapt.px(36),
                    width: Adapt.px(36),
                    imageUrl: benefitsIcon,
                    placeholder: (context, url) => Container(
                      color: ThemeColor.gray5,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/icon_benefits_default.png',
                      fit: BoxFit.cover,
                      package: 'ox_usercenter',
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColor.color180,
                    border: Border.all(width: 0.3, color: ThemeColor.gray5),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                SizedBox(
                  height: Adapt.px(8),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    benefit,
                    style: TextStyle(
                      fontSize: Adapt.px(12),
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      color: ThemeColor.color70,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          );
  }

  Future<bool> onRefresh() {
    return Future<bool>.delayed(const Duration(seconds: 2), () {
      setState(() {
        listlength += 10;
      });
      return true;
    });
  }
}

class FollowButton extends StatefulWidget {
  const FollowButton(this.onBuildController, this.followButtonController);

  final StreamController<void> onBuildController;
  final StreamController<bool> followButtonController;

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool showFollowButton = false;

  @override
  void initState() {
    super.initState();
    widget.onBuildController.stream.listen((_) {
      if (mounted) {
        final double statusBarHeight = MediaQuery.of(context).padding.top;
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final Offset position = renderBox.localToGlobal(Offset.zero);
        final bool show = position.dy + renderBox.size.height <
            statusBarHeight + kToolbarHeight;
        if (showFollowButton != show) {
          showFollowButton = show;
          widget.followButtonController.sink.add(showFollowButton);
        }
        //print('${position.dy + renderBox.size.height} ----- ${statusBarHeight + kToolbarHeight}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      //MaterialTapTargetSize.padded min 48
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: OutlinedButton(
        child: const Text('Follow'),
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          side: MaterialStateProperty.all(
            const BorderSide(
              color: Colors.orange,
            ),
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
