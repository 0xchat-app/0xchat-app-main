import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/page/set_up/relay_detail_page.dart';
import 'package:chatcore/chat-core.dart';

///Title: relay_recommend_widget
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/7/20 09:55

class RelayRecommendModule{
  RelayDBISAR relayDB;
  bool isAddedCommend;
  RelayRecommendModule(this.relayDB, this.isAddedCommend);
}

class RelayCommendWidget extends StatelessWidget {
  List<RelayDBISAR> relayList = [];
  List<RelayRecommendModule> commendRelayList = [];
  Function(RelayDBISAR) onTapCall;

  RelayCommendWidget(this.relayList, this.onTapCall, {Key? key}) : super(key: key){
    for(var relay in relayList){
      commendRelayList.add(RelayRecommendModule(relay, false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: Adapt.px(58),
          alignment: Alignment.centerLeft,
          child: Text(
            Localized.text('ox_usercenter.recommend_relay'),
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: Adapt.px(16),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: ThemeColor.color180,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: _itemBuild,
            itemCount: commendRelayList.length,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    RelayRecommendModule _model = commendRelayList[index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap:() {
            OXNavigator.pushPage(context, (context) => RelayDetailPage(relayURL: _model.relayDB.url,));
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 10.px),
            child: Row(
              children: [
                CommonImage(
                  iconName: 'icon_settings_relays.png',
                  width: Adapt.px(32),
                  height: Adapt.px(32),
                  package: 'ox_usercenter',
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.px),
                    child: Text(
                      _model.relayDB.url,
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: Adapt.px(16),
                      ),
                    ),
                  ),
                ),
                _relayStateImage(_model),
              ],
            ),
          ),
        ),
        commendRelayList.length > 1 && commendRelayList.length - 1 != index
            ? Divider(
                height: Adapt.px(0.5),
                color: ThemeColor.color160,
              )
            : SizedBox(width: Adapt.px(24)),
      ],
    );
  }

  Widget _relayStateImage(RelayRecommendModule relayModel) {
    return relayModel.isAddedCommend
        ? const SizedBox()
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              onTapCall(relayModel.relayDB);
            },
            child: CommonImage(
              iconName: 'icon_bar_add.png',
              width: Adapt.px(24),
              height: Adapt.px(24),
              package: 'ox_usercenter',
            ),
          );
  }
}
