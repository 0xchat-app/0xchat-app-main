import 'package:flutter/material.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_wallet/page/wallet_mint_list_page.dart';
import 'package:ox_wallet/page/wallet_transaction_record.dart';
import 'package:ox_wallet/services/ecash_listener.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/ecash_navigation_bar.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:cashu_dart/cashu_dart.dart';

class WalletHomePage extends StatefulWidget {
  const WalletHomePage({super.key});

  @override
  State<WalletHomePage> createState() => _WalletHomePageState();
}

class _WalletHomePageState extends State<WalletHomePage> with CommonStateViewMixin{
  final double appBarHeight = 56.px;

  final ScrollController _scrollController = ScrollController();

  double _opacity = 0;

  List<IHistoryEntry> _recentTransaction = [];
  late final EcashListener _balanceChangedListener;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _getRecentTransaction();
    _balanceChangedListener = EcashListener(onEcashBalanceChanged: (value)=>_onBalanceChanged,onInvoicePaidChanged: (value)=>_onBalanceChanged());
    Cashu.addInvoiceListener(_balanceChangedListener);
    super.initState();
  }

  void _onBalanceChanged(){
    _getRecentTransaction();
  }

  void _scrollListener(){
    setState(() {
      //The height:36 ,represents the sum of font size and margins(18 + 12)
      if(_scrollController.offset < 36) {
        _opacity = 0;
        return;
      }
      _opacity = _scrollController.offset * 0.01;
      if(_opacity > 1) _opacity = 1;
      if(_opacity < 0) _opacity = 0;
    });
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          ThemeColor.gradientMainEnd,
          ThemeColor.gradientMainStart,
        ], begin: Alignment.topLeft, end: Alignment.topRight),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: _buildAppBar(),
          ),
          Positioned(
            right: 0,
            left: 0,
            top: statusBarHeight + appBarHeight,
            height: height - (statusBarHeight + appBarHeight),
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context,inner){
                return [
                    _buildInfoArea(),
                  ];
                },
              body: _buildTransactionList(),
            ),
          ),
          Positioned(
              left: 51.px,
              right: 51.px,
              bottom: 30.px,
              height: 68.px,
              child: const EcashNavigationBar(),
            ),
          ],
        )
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 100),
        child: const Text('Wallet'),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: CommonImage(
          iconName: "icon_back_left_arrow.png",
          width: 24.px,
          height: 24.px,
          useTheme: true,
        ),
        onPressed: () => OXNavigator.popToRoot(context),
      ),
      actions: [
        GestureDetector(
          child: CommonImage(
            iconName: 'icon_wallet_more.png',
            width: 24.px,
            height: 24.px,
            package: 'ox_wallet',
          ).setPadding(EdgeInsets.only(right: 24.px)),
          onTap: () => OXNavigator.pushPage(context, (context) => const WalletMintListPage()),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 12.px,left: 24.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Wallet",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400,height: 25.px / 18.px),
          ),
          SizedBox(
            height: 4.px,
          ),
          Text(
            "${WalletUtils.formatAmountNumber(EcashService.totalBalance())} sats",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600,height: 45.px / 32.px),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoArea(){
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      leading: Container(),
      toolbarHeight: 140.px - statusBarHeight,
      flexibleSpace: SizedBox(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: _buildTitle(),
            ),
            Positioned(
              right: -20.px,
              top: 12.px,
              child: CommonImage(
                iconName: 'icon_wallet_subtract.png',
                width: 160.px,
                height: 160.px,
                package: 'ox_wallet',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Container(
      padding: EdgeInsets.all(24.px),
      decoration: BoxDecoration(
          color: ThemeColor.color190,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12.px),topRight: Radius.circular(12.px))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transaction',
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: 16.px,
              fontWeight: FontWeight.w600,),
          ),
          SizedBox(height: 16.px,),
          Expanded(
            child: commonStateViewWidget(
              context,
              ListView.builder(
                itemExtent: 53.px,
                padding: EdgeInsets.only(bottom: 68.px + 10.px),
                itemBuilder: (BuildContext context, int index){
                  final record = _recentTransaction[index];
                  final amount = record.amount > 0 ? '+${record.amount.toInt()}' : '${record.amount.toInt()}';
                  final iconName = record.amount > 0 ? 'icon_transaction_receive.png' : 'icon_transaction_send.png';
                  return TransactionItem(
                    title: record.type.name,
                    subTitle: _getTransactionItemSubtitle(record),
                    info: '$amount sats',
                    iconName: iconName,
                    onTap: (){
                      if(record.type == IHistoryType.eCash || record.type == IHistoryType.lnInvoice){
                        OXNavigator.pushPage(context, (context) => WalletTransactionRecord(entry: record,));
                      }
                    },
                  );
                },
                itemCount: _recentTransaction.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTransactionItemSubtitle(IHistoryEntry entry){
    final time = WalletUtils.formatTimeAgo(entry.timestamp.toInt());
    final memo = entry.memo?.isEmpty ?? true ? '-' : entry.memo;
    return '$time · $memo';
  }

  _getRecentTransaction() async {
    _recentTransaction = await EcashService.getHistoryList();
    _recentTransaction.isEmpty ? updateStateView(CommonStateView.CommonStateView_NoData) : updateStateView(CommonStateView.CommonStateView_None);
    if(mounted){
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Cashu.removeInvoiceListener(_balanceChangedListener);
    super.dispose();
  }
}

class TransactionItem extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? info;
  final String? iconName;
  final VoidCallback? onTap;
  const TransactionItem({super.key, this.title, this.subTitle, this.info, this.onTap, this.iconName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.px),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonImage(
              iconName: iconName ?? 'icon_transaction_send.png',
              size: 24.px,
              package: 'ox_wallet',
            ),
            SizedBox(width: 8.px,),
            Expanded(
              child: _buildTile(title: title ?? '',subTitle: subTitle ?? '')
            ),
            SizedBox(width: 8.px,),
            _buildTile(title: info ?? '', subTitle: '',crossAxisAlignment: CrossAxisAlignment.end),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
      {required String title,
      required String subTitle,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.px,
            fontWeight: FontWeight.w400,
            color: ThemeColor.color0,
            height: 19.6.px / 14.px,
          ),
        ),
        Text(
          subTitle,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.px,
            fontWeight: FontWeight.w400,
            color: ThemeColor.color100,
            height: 16.8.px / 12.px,
          ),
        ),
      ],
    );
  }
}

extension IHistoryTypeEx on IHistoryType {
  String get name {
    switch (this) {
      case IHistoryType.unknown: return 'Unknown';
      case IHistoryType.eCash: return 'Ecash';
      case IHistoryType.lnInvoice: return 'Lightning';
      case IHistoryType.multiMintSwap: return 'Multi Mint Swap';
    }
  }
}

