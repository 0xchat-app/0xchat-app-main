import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';
import 'package:cashu_dart/cashu_dart.dart';

class WalletBackupFundsPage extends StatefulWidget {
  final IMint mint;
  const WalletBackupFundsPage({super.key, required this.mint});

  @override
  State<WalletBackupFundsPage> createState() => _WalletBackupFundsPageState();
}

class _WalletBackupFundsPageState extends State<WalletBackupFundsPage> {

  final content = "The existing backup process represents a rudimentary implementation. It creates a Cashu token from mints and proofs which becomes invalid after new transactions. To restore the token on a new device, follow the familiar claiming process and the old balance becomes invalid. Avoid redeeming on top of the current balance to prevent errors. It's worth mentioning that we're actively engaged in developing a seed phrase backup solution for enhanced security and convenience. Note: You can also create a backup for a single mint under 'More Button at the top right of the Home Page' > 'Select mint' > 'Backup funds'.";
  String? _cashuToken;
  bool _isCopied = false;

  @override
  void initState() {
    _getCashuToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
          title: 'Backup funds',
          centerTitle: true,
          useLargeTitle: false,
        ),
        body: SingleChildScrollView(
          child: CommonLabeledCard(
            label: 'Cashu token',
            child: Column(
              children: [
                _buildCashuTokenItem(),
                SizedBox(height: 24.px,),
                _buildItem(title: 'Mint', content: widget.mint.mintURL),
                SizedBox(height: 24.px,),
                _buildItem(title: 'How does it work?',content: content),
              ],
            ),
          ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
        )
    );
  }

  Widget _buildCashuTokenItem() {
    return CommonCard(
      verticalPadding: 15.px,
      child: _cashuToken != null ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text(_cashuToken!,style: TextStyle(fontSize: 16.px,height: 22.px / 16.px,color: ThemeColor.color40),)),
          SizedBox(width: 8.px,),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: !_isCopied ? () async {
              await TookKit.copyKey(context, _cashuToken ?? '');
              setState(() {
                _isCopied = true;
              });
            } : null,
            child: CommonImage(
              iconName: _isCopied ? 'icon_item_selected.png' : 'icon_copy.png',
              size: 24.px,
              package: 'ox_wallet',
              useTheme: true,
            ),
          ),
        ],
      ) : const Text('-'),
    );
  }

  Widget _buildItem({String? title, String? content}){
    return CommonCard(
      verticalPadding: 15.px,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? '',style: TextStyle(fontSize: 16.px,height: 22.px / 16.px,color: ThemeColor.color0),),
          SizedBox(height: 4.px,),
          Text(content ?? '',style: TextStyle(fontSize: 12.px,height: 17.px / 12.px),),
        ],
      ),
    );
  }

  void _getCashuToken() async {
    CashuResponse<String> response = await Cashu.getBackUpToken([widget.mint]);
    if(response.isSuccess){
      setState(() {
        _cashuToken = WalletUtils.formatString(response.data);
      });
    }
  }
}