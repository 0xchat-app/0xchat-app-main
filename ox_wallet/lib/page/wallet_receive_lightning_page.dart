import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_wallet/page/sats_receive_page.dart';

class WalletReceiveLightningPage extends StatefulWidget {
  const WalletReceiveLightningPage({super.key});

  @override
  State<WalletReceiveLightningPage> createState() => _WalletReceiveLightningPageState();
}

class _WalletReceiveLightningPageState extends State<WalletReceiveLightningPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin{

  // late final TabController _controller;
  // final List<String> tabsName = const ['Sats', 'BTC'];
  final ValueNotifier<bool> _shareController = ValueNotifier(false);

  @override
  void initState() {
    // _controller = TabController(length: tabsName.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: ThemeColor.color190,
          appBar: CommonAppBar(
            title: 'Receive',
            centerTitle: true,
            useLargeTitle: false,
            actions: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _shareController.value = !_shareController.value,
                child:Text('Pay',style: TextStyle(fontSize: 18.sp,color: ThemeColor.color0)).setPaddingOnly(right: 15.px, top: 5.px),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // EcashTabBar(controller: _controller, tabsName: tabsName,),
              SizedBox(height: 12.px,),
              // Expanded(
              //   child: TabBarView(
              //     controller: _controller,
              //     children: [
              //       SatsReceivePage(shareController: _shareController,),
              //       BTCReceivePage(shareController: _shareController,),
              //     ],
              //   ),
              // ),
              Expanded(child: SatsReceivePage(shareController: _shareController,))
            ],
          ).setPaddingOnly(top: 12.px)
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


