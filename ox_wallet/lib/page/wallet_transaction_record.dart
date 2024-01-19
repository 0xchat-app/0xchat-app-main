import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';

class WalletTransactionRecord extends StatefulWidget {
  final IHistoryEntry entry;
  const WalletTransactionRecord({super.key, required this.entry});

  @override
  State<WalletTransactionRecord> createState() => _WalletTransactionRecordState();
}

class _WalletTransactionRecordState extends State<WalletTransactionRecord> {

  final List<StepItemModel> _items  = [];
  final String _tagItem = 'check_ecash';

  @override
  void initState() {
    _initData();
    _checkEcashTokenSpendable();
    super.initState();
  }

  _initData(){
    final record = widget.entry;
    String type = widget.entry.amount > 0 ? 'Receive' : 'Send';
    _items.add(StepItemModel(title: type,subTitle: '${record.amount.toInt().abs()} sats'));
    _items.add(StepItemModel(title: 'Memo',subTitle: record.memo));
    _items.add(StepItemModel(title: 'Mint',subTitle: record.mints.join('\r\n')),);
    _items.add(StepItemModel(title: 'Created Time',subTitle: WalletUtils.formatTimestamp(record.timestamp.toInt())));
    if (record.type == IHistoryType.eCash) {
      _items.add(StepItemModel(key: _tagItem , title: 'Check',subTitle: '-'));
      _items.add(StepItemModel(title: 'Token',subTitle: WalletUtils.formatString(record.value),onTap: (value) => TookKit.copyKey(context, record.value)));
    } else if (record.type == IHistoryType.lnInvoice) {
      _items.add(StepItemModel(title: 'Fee',subTitle: record.fee?.toInt().toString()));
      _items.add(StepItemModel(title: 'Invoice',subTitle: WalletUtils.formatString(record.value),onTap: (value) => TookKit.copyKey(context, record.value)));
      _items.add(StepItemModel(title: 'Payment hash',subTitle: record.paymentHash, onTap: (value) => TookKit.copyKey(context, record.paymentHash ?? '')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: widget.entry.type == IHistoryType.eCash ? 'Ecash Payment' : 'Lightning Invoice',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => _buildItem(_items[index]),
          separatorBuilder: (context, index) => SizedBox(height: 24.px,),
          itemCount: _items.length,).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px),)
    );
  }

  Widget _buildItem(StepItemModel itemModel){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => itemModel.onTap != null ? itemModel.onTap!(itemModel) : null,
      child: CommonCard(
        verticalPadding: 15.px,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(itemModel.title ?? '',style: TextStyle(fontSize: 14.px,height: 22.px / 14.px),),
            SizedBox(height: 4.px,),
            Row(
              children: [
                Expanded(child: Text('${(itemModel.subTitle?.isEmpty ?? true) ? '-' : itemModel.subTitle}',style: TextStyle(fontSize: 12.px,height: 17.px / 12.px,color: ThemeColor.color0),)),
                itemModel.badge != null ? Text(itemModel.badge!,style: TextStyle(fontSize: 14.px,color: ThemeColor.gradientMainStart),) : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkEcashTokenSpendable() async {
    bool? result = await EcashService.checkEcashTokenSpendable(entry: widget.entry);
    int index = _items.indexWhere((item) => item.key == _tagItem);
    if(result == null) _items[index] = StepItemModel(key: _tagItem, title: 'Check',subTitle: 'Check if token has been spent');
    if(result != null && result) {
      _items[index] = StepItemModel(key: _tagItem, title: 'Checked',subTitle: 'Token has been spent');
    } else {
      _items[index] = StepItemModel(key: _tagItem, title: 'Checked',subTitle: 'Token is pending',badge: 'Claim token',onTap: _redeemEcash);
    }
    setState(() {});
  }

  Future<void> _redeemEcash(StepItemModel stepItemModel) async {
    OXLoading.show();
    final result = await EcashService.redeemEcash(widget.entry.value);
    OXLoading.dismiss();
    if(result == null) {
      if(context.mounted) CommonToast.instance.show(context,'Redeem Cashu failed, Please try again');
      return;
    }
    if(context.mounted) CommonToast.instance.show(context,'Claim token successful');
    await _checkEcashTokenSpendable();
  }
}
