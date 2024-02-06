
import 'package:flutter/material.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:chatcore/chat-core.dart';
import 'package:intl/intl.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/future_extension.dart';
import 'package:ox_common/utils/num_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_module_service/ox_module_service.dart';

import 'ecash_info.dart';

class EcashDetailPage extends StatefulWidget {

  const EcashDetailPage({
    super.key,
    required this.package,
  });

  final EcashPackage package;

  @override
  State<StatefulWidget> createState() => EcashDetailPageState();
}

class EcashDetailPageState extends State<EcashDetailPage> {

  String ownerName = '';

  IHistoryEntry? recordDetail;

  List<EcashTokenInfo> historyList = [];

  String get totalAmount => widget.package.totalAmount.formatWithCommas();
  String get description => widget.package.memo;

  String unit = 'sats';

  @override
  void initState() {
    super.initState();

    Account.sharedInstance.getUserInfo(widget.package.senderPubKey).handle((user) {
      setState(() {
        ownerName = user?.getUserShowName() ?? 'anonymity';
      });
    });

    historyList = widget.package.tokenInfoList
        .where((info) => info.redeemHistory != null).toList()
        .cast();

    final myHistory = historyList.where((info) => info.redeemHistory?.isMe == true).firstOrNull;
    if (myHistory != null) {
      Cashu.getHistory(value: [myHistory.token]).then((value) {
        setState(() {
          recordDetail = value.firstOrNull;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            ThemeColor.gradientMainEnd,
            ThemeColor.gradientMainStart,
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          CommonAppBar(
            backgroundColor: Colors.transparent,
            actions: [
              if (recordDetail != null)
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    OXModuleService.pushPage(
                      context,
                      OXWalletInterface.moduleName,
                      'WalletTransactionRecord',
                      {
                        'historyEntry': recordDetail,
                      },
                    );
                  },
                  child: CommonImage(
                    iconName: 'icon_more.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                    package: 'ox_chat',
                  ).setPaddingOnly(right: 24.px),
                ),
            ],
          ),
          _buildHeader(),
          Expanded(
            child: _buildHistoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 12.px),
        Text(
          'Sent by ${ownerName}',
          style: TextStyle(
            color: ThemeColor.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.px),
        Text(
          '$totalAmount $unit',
          style: TextStyle(
            color: ThemeColor.white,
            fontSize: 32.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.px),
        Text(
          description,
          style: TextStyle(
            color: ThemeColor.white,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 24.px),
      ],
    );
  }

  Widget _buildHistoryList() {
    final tokenCount = widget.package.tokenInfoList.length;
    final tokenReceiveCount = widget.package.tokenInfoList.where((info) => info.redeemHistory != null).length;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: ThemeColor.color190,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '$tokenReceiveCount out of $tokenCount cashu tokens have been redeemed',
              style: TextStyle(
                color: ThemeColor.color0,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ).setPaddingOnly(top: 24.px, left: 24.px,),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 16.px, left: 10.px, right: 10.px),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                return _buildHistoryItemWithEntry(historyList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItemWithEntry(EcashTokenInfo entry) {
    final user = entry.redeemHistory?.isMe == true ? Account.sharedInstance.me : null;
    return _buildHistoryItem(
      user,
      entry.redeemHistory?.timestamp,
      entry.amount,
      entry.unit,
    );
  }

  Widget _buildHistoryItem(UserDB? user, int? timestamp, int amount, String unit) {
    String formattedDate = '';
    if (timestamp != null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(dateTime);
    }
    return ListTile(
      leading: OXUserAvatar(
        user: user,
        isCircular: false,
      ),
      title: Text(
        user?.getUserShowName() ?? 'anonym',
        style: TextStyle(
          color: ThemeColor.color0,
          fontSize: 14.sp,
          height: 1.4,
        ),
      ),
      subtitle: Text(
        formattedDate,
        style: TextStyle(
          color: ThemeColor.color100,
          fontSize: 12.sp,
          height: 1.4,
        ),
      ),
      trailing: Text(
        '$amount $unit',
        style: TextStyle(
          color: ThemeColor.color0,
          fontSize: 14.sp,
          height: 1.4,
        ),
      ),
    );
  }
}