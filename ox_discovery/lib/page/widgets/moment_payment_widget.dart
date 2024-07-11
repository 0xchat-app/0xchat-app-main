import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

class MomentPaymentWidget extends StatefulWidget {
  const MomentPaymentWidget({
    super.key,
  });

  @override
  _MomentPaymentWidgetState createState() => _MomentPaymentWidgetState();
}

class _MomentPaymentWidgetState extends State<MomentPaymentWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 12.px,
      ),
      padding: EdgeInsets.symmetric(vertical: 16.px, horizontal: 12.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.px)),
        border: Border.all(
          width: 1.px,
          color: ThemeColor.color160,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _carTitleWidget(),
          _tradeUserInfo(),
          _priceWidget(),
          _tradeTimeWidget(),
        ],
      ),
    );
  }

  Widget _carTitleWidget() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 20.px,
      ),
      child: Row(
        children: [
          CommonImage(
            iconName: 'lighting_icon.png',
            package: 'ox_discovery',
            size: 24.px,
          ).setPaddingOnly(
            right: 4.px,
          ),
          Text(
            'ZAPS',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.px,
                color: ThemeColor.white),
          ).setPaddingOnly(
            right: 4.px,
          ),
          Text(
            'lnbtc xxxxxx...xxxxxx',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.px,
              color: ThemeColor.color120,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tradeUserInfo() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 16.px,
      ),
      child: Row(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonImage(
                  iconName: 'lighting_icon.png',
                  package: 'ox_discovery',
                  size: 24.px,
                ).setPaddingOnly(
                  right: 4.px,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Satoshi',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.px,
                        color: ThemeColor.color120,
                      ),
                    ),
                    Text(
                      'Satosh@0xchat.com',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.px,
                        color: ThemeColor.color120,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        Expanded(child:   CommonImage(
          iconName: 'right_yellow_arrow_icon.png',
          package: 'ox_discovery',
          size: 24.px,
        ),),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonImage(
                  iconName: 'lighting_icon.png',
                  package: 'ox_discovery',
                  size: 24.px,
                ).setPaddingOnly(
                  right: 4.px,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Satoshi',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.px,
                        color: ThemeColor.color120,
                      ),
                    ),
                    Text(
                      'Satosh@0xchat.com',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.px,
                        color: ThemeColor.color120,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    return Container(
      height: 33.px,
      child: Text(
        '100,000 Sats',
        style: TextStyle(
          fontSize: 24.px,
          color: ThemeColor.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _tradeTimeWidget() {
    return Container(
      child: Text(
        '2024.07.05 20:00:00',
        style: TextStyle(
          fontSize: 10.px,
          color: ThemeColor.color120,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
