
import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:lottie/lottie.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/date_utils.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';

export 'package:pull_to_refresh/src/smart_refresher.dart';

class OXSmartRefresher extends StatelessWidget {

  OXSmartRefresher({
    Key? key,
    required this.controller,
    this.child,
    this.header,
    this.footer,
    this.enablePullDown,
    this.enablePullUp,
    this.enableTwoLevel,
    this.onRefresh,
    this.onLoading,
    this.onTwoLevel,
    this.scrollController,
  }) : super(key: key);

  final RefreshController controller;
  final Widget? child;
  final Widget? header;
  final Widget? footer;
  final bool? enablePullDown;
  final bool? enablePullUp;
  final bool? enableTwoLevel;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final OnTwoLevel? onTwoLevel;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        scrollController:scrollController,
        controller: this.controller,
        header: this.header ?? refresherHeader,
        footer: this.footer ?? refresherFooter,
        enablePullDown: this.enablePullDown ?? true,
        enablePullUp: this.enablePullUp ?? false,
        enableTwoLevel: this.enableTwoLevel ?? false,
        onRefresh: this.onRefresh,
        onLoading: this.onLoading,
        onTwoLevel: this.onTwoLevel,
        child: this.child
    );
  }

  Widget get refresherHeader {
    return LoadingHeader();
  }

  Widget get refresherFooter {
    return ClassicFooter(
        idleText: Localized.text('ox_common.pull_up_to_load_more'),
        loadingText: Localized.text('ox_common.pull_loading'),
        noDataText: '-------- ${Localized.text('ox_common.pull_down_to_bottom')} --------',
        failedText: Localized.text('ox_common.pull_failed'),
        canLoadingText: Localized.text('ox_common.release_and_load')
    );
  }

}

class LoadingHeader extends RefreshIndicator {

  @override
  State<StatefulWidget> createState() {
    
    // TODO: implement createState
    return LoadingHeaderState();
  }
}

class LoadingHeaderState extends RefreshIndicatorState<LoadingHeader>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  int? refreshTime;

  @override
  void initState() {
    // TODO: implement initState
    // init frame is 2
    super.initState();
    _controller = AnimationController(vsync: this,value: 0);
    _getUpdateTime();

  }

  @override
  Future<void> endRefresh() {
    // TODO: implement endRefresh
    _controller.value = 1;
    _controller.stop();
    return super.endRefresh();
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    // TODO: implement onModeChange
    if (mode == RefreshStatus.canRefresh) {
      _controller.repeat();
    }else if(mode == RefreshStatus.completed){
      OXCacheManager.defaultOXCacheManager.saveData("pull_refresh_time", DateTime.now().millisecondsSinceEpoch);
      setState(() {
        refreshTime = DateTime.now().millisecondsSinceEpoch;
      });

    }
    super.onModeChange(mode);
  }

  _getUpdateTime(){

    OXCacheManager.defaultOXCacheManager.getData("pull_refresh_time",defaultValue: null).then((value){

      if(value != null){

        setState(() {
          refreshTime = value;
        });
      }
    });

  }


  @override
  void resetValue() {
    // TODO: implement resetValue
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    // TODO: implement buildContent
    return Column(
      children: [
        Lottie.asset(
          "assets/${ThemeManager.images("ox_pull_loading.json")}",
          package: 'ox_common',
          width: Adapt.px(72),
          repeat: true,
          fit: BoxFit.fitWidth,
          controller: _controller,
          onLoaded: (composition) {
            _controller..duration = Duration(milliseconds: 1500);
          },
        ),
        Container(
          margin: EdgeInsets.only(top: Adapt.px(4)),
          child: Text(_getRefreshTimeString(),style: TextStyle(
            color: ThemeColor.dark06,
            fontSize: Adapt.px(12)
          ),),
        )
      ],
    );
  }


  _getRefreshTimeString(){

    if(refreshTime != null){
      String lastFresh = Localized.text('ox_common.last_update');
      if(DateUtils.isSameDay(DateTime.fromMillisecondsSinceEpoch(refreshTime!), DateTime.now())){

        lastFresh = lastFresh + Localized.text('ox_common.today') + OXDateUtils.formatTimestamp(refreshTime!,pattern: "HH:mm");

      }else{
        lastFresh = lastFresh + OXDateUtils.formatTimestamp(refreshTime!);
      }
      return lastFresh;
    }


    return "";

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
