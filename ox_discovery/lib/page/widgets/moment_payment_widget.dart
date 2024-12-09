import 'package:cashu_dart/api/cashu_api.dart';
import 'package:cashu_dart/model/cashu_token_info.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:intl/intl.dart';
import '../../enum/moment_enum.dart';

class MomentPaymentWidget extends StatefulWidget {
  final String invoice;
  final EPaymentType type;
  const MomentPaymentWidget({
    super.key,
    required this.invoice,
    required this.type,
  });

  @override
  _MomentPaymentWidgetState createState() => _MomentPaymentWidgetState();
}

class _MomentPaymentWidgetState extends State<MomentPaymentWidget> {
  String amount = '';

  String? lightingTime;
  // List<ZapRecordsDB>
  String? ecashTime;
  CashuTokenInfo? cashuTokenInfo;

  String get getInvoice {
    String invoice = widget.invoice;
    if (invoice.length < 20) return invoice;
    return invoice.substring(0, 11) +
        '...' +
        invoice.substring(widget.invoice.length - 7);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPre();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _initPre() async {
    String invoice = widget.invoice;

    if (widget.type == EPaymentType.lighting) {
      final getZapReceipt = await Zaps.getZapReceipt('', invoice: invoice);
      final getPaymentRequestInfo = Zaps.getPaymentRequestInfo(invoice);
      amount = Zaps.getPaymentRequestAmount(invoice).toString();
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          getPaymentRequestInfo.timestamp.toInt() * 1000);
      lightingTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    }

    if (widget.type == EPaymentType.ecash) {
      cashuTokenInfo = Cashu.infoOfToken(invoice);
      amount = cashuTokenInfo?.amount.toString() ?? '';
    }

    if (mounted) {
      setState(() {});
    }
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
          // _tradeUserInfo(),
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
            iconName: widget.type.getIcon,
            package: 'ox_discovery',
            size: 24.px,
          ).setPaddingOnly(
            right: 4.px,
          ),
          Text(
            widget.type.text,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.px,
              color: ThemeColor.white,
            ),
          ).setPaddingOnly(
            right: 4.px,
          ),
          Text(
            getInvoice,
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
          Expanded(
            child: CommonImage(
              iconName: 'right_yellow_arrow_icon.png',
              package: 'ox_discovery',
              size: 24.px,
            ),
          ),
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
    String? unit = widget.type == EPaymentType.lighting
        ? 'Sats'
        : cashuTokenInfo?.unit;
    if(unit == null) return const SizedBox();
    return Container(
      height: 33.px,
      child: Text(
        '$amount ${unit[0].toUpperCase()}${unit.substring(1)}',
        style: TextStyle(
          fontSize: 24.px,
          color: ThemeColor.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _tradeTimeWidget() {
    String? content =
        widget.type == EPaymentType.lighting ? lightingTime : ecashTime;
    if (content == null) return const SizedBox();
    return Container(
      child: Text(
        content,
        style: TextStyle(
          fontSize: 10.px,
          color: ThemeColor.color120,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
