import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';
import 'package:cashu_dart/cashu_dart.dart';

class WalletBackupFundsPage extends StatefulWidget {
  final IMint? mint;
  const WalletBackupFundsPage({super.key, required this.mint});

  @override
  State<WalletBackupFundsPage> createState() => _WalletBackupFundsPageState();
}

class _WalletBackupFundsPageState extends State<WalletBackupFundsPage> {

  final content = 'The backup funds process automatically consolidates and calculates the smallest proofs for efficient storage while enhancing security. However, please be aware that once the recovery is completed, the old Cashu token becomes invalid, so ensure the process is carried out securely';
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
                if(widget.mint != null) _buildItem(title: 'Mint', content: widget.mint?.mintURL).setPaddingOnly(top: 24.px),
                _buildItem(title: 'How does it work?',content: content).setPaddingOnly(top: 24.px),
                if (widget.mint == null) _buildDownloadButton(),
              ],
            ),
          ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
        )
    );
  }

  Widget _buildCashuTokenItem() {
    return CommonCard(
      verticalPadding: 15.px,
      child: _cashuToken != null ? GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: !_isCopied ? () async {
          await TookKit.copyKey(context, _cashuToken ?? '');
          setState(() {
            _isCopied = true;
          });
        } : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Text(WalletUtils.formatString(_cashuToken!),style: TextStyle(fontSize: 16.px,height: 22.px / 16.px,color: ThemeColor.color40),)),
            SizedBox(width: 8.px,),
            CommonImage(
              iconName: _isCopied ? 'icon_item_selected.png' : 'icon_copy.png',
              size: 24.px,
              package: 'ox_wallet',
              useTheme: true,
            ),
          ],
        ),
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

  Widget _buildDownloadButton() {
    return ThemeButton(
      text: 'Download',
      height: 48.px,
      enable: _cashuToken != null,
      onTap: () => WalletUtils.exportToken(_cashuToken ?? ''),
    ).setPaddingOnly(top: 24.px,);
  }

  void _getCashuToken() async {
    List<IMint> mints = widget.mint == null ? EcashManager.shared.mintList : [widget.mint!];
    OXLoading.show();
    CashuResponse<String> response = await Cashu.getBackUpToken(mints);
    OXLoading.dismiss();
    if(!response.isSuccess) {
      if(context.mounted) CommonToast.instance.show(context, response.errorMsg);
      return;
    }
    setState(() {
      _cashuToken = response.data;
    });
  }
}