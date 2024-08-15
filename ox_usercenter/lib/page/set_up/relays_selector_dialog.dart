import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:chatcore/chat-core.dart';

///Title: relays_selector_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/4 17:20
class RelaysSelectorPage extends StatefulWidget {
  const RelaysSelectorPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RelaysSelectorPageState();
  }
}

class RelaySelectorModule{
  RelayDBISAR relayDB;
  bool isSelected;
  RelaySelectorModule(this.relayDB, this.isSelected);
}

class _RelaysSelectorPageState extends State<RelaysSelectorPage> {
  late List<RelaySelectorModule> _relayList = [];

  @override
  void initState() {
    super.initState();
    _initDefault();
  }

  void _initDefault() async {
    for(var relay in Account.sharedInstance.getMyGeneralRelayList()){
      _relayList.add(RelaySelectorModule(relay, false));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(12)),
          color: ThemeColor.color190,
        ),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(16)),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: Adapt.px(56),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Relays',
                        style: TextStyle(
                          fontSize: Adapt.px(17),
                          color: ThemeColor.color0,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      // await OXLoading.show();
                      // await OXRelayManager.sharedInstance.saveRelayList(_relayList);
                      // await OXLoading.dismiss();
                      OXNavigator.pop(context);
                    },
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [
                            ThemeColor.gradientMainEnd,
                            ThemeColor.gradientMainStart,
                          ],
                        ).createShader(Offset.zero & bounds.size);
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: Adapt.px(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _body(),
          ],
        ));
  }

  Widget _body() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: Adapt.px(46),
            alignment: Alignment.centerLeft,
            child: Text(
              'Please choose relay from the list below to Filter the current feed:',
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: Adapt.px(16),
              ),
            ),
          ),
          SizedBox(
            height: Adapt.px(24),
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
              itemCount: _relayList.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    RelaySelectorModule _model = _relayList[index];
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: Adapt.px(52),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
            leading: CommonImage(
              iconName: 'icon_settings_relays.png',
              width: Adapt.px(32),
              height: Adapt.px(32),
              package: 'ox_usercenter',
            ),
            title: Container(
              child: Text(
                _model.relayDB.url,
                style: TextStyle(
                  color: ThemeColor.color0,
                  fontSize: Adapt.px(16),
                ),
              ),
            ),
            trailing: _relayStateImage(_model),
          ),
        ),
        _relayList.length > 1 && _relayList.length - 1 != index
            ? Divider(
                height: Adapt.px(0.5),
                color: ThemeColor.color160,
              )
            : Container(),
      ],
    );
  }

  Widget _relayStateImage(RelaySelectorModule relayModel) {
    return Switch(
      value: relayModel.isSelected,
      activeColor: Colors.white,
      activeTrackColor: ThemeColor.gradientMainStart,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: ThemeColor.color160,
      onChanged: (bool value) {
        LogUtil.e('Michael： value =$value');
        setState(() {
          relayModel.isSelected = value;
        });
      },
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}
