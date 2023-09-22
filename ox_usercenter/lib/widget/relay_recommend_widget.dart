import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/relay_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_usercenter/page/set_up/relay_detail_page.dart';

///Title: relay_recommend_widget
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/7/20 09:55
class RelayCommendWidget extends StatelessWidget {
  List<RelayModel> commendRelayList = [];
  Function(RelayModel) onTapCall;

  RelayCommendWidget(this.commendRelayList, this.onTapCall, {Key? key}) : super(key: key);

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
    RelayModel _model = commendRelayList[index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: (){
            OXNavigator.pushPage(context, (context) => RelayDetailPage(relayURL: _model.relayName,));
          },
          contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
          leading: CommonImage(
            iconName: 'icon_settings_relays.png',
            width: Adapt.px(32),
            height: Adapt.px(32),
            package: 'ox_usercenter',
          ),
          title: Container(
            margin: EdgeInsets.only(left: Adapt.px(12)),
            child: Text(
              _model.relayName,
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: Adapt.px(16),
              ),
            ),
          ),
          trailing: _relayStateImage(_model),
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

  Widget _relayStateImage(RelayModel relayModel) {
    return relayModel.isAddedCommend
        ? const SizedBox()
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              onTapCall(relayModel);
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
