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
import 'package:ox_localizable/ox_localizable.dart';

class WalletBackupFundsPage extends StatefulWidget {
  final IMintIsar? mint;
  const WalletBackupFundsPage({super.key, required this.mint});

  @override
  State<WalletBackupFundsPage> createState() => _WalletBackupFundsPageState();
}

class _WalletBackupFundsPageState extends State<WalletBackupFundsPage> {

  final content = Localized.text('ox_wallet.backup_funds_instruction');
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
          title: Localized.text('ox_wallet.backup_funds_title'),
          centerTitle: true,
          useLargeTitle: false,
        ),
        body: SingleChildScrollView(
          child: CommonLabeledCard(
            label: Localized.text('ox_wallet.cashu_token'),
            child: Column(
              children: [
                _buildCashuTokenItem(),
                if(widget.mint != null) _buildItem(title: Localized.text('ox_wallet.mint'), content: widget.mint?.mintURL).setPaddingOnly(top: 24.px),
                _buildItem(title: Localized.text('ox_wallet.how_to_operate'),content: content).setPaddingOnly(top: 24.px),
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
      text: Localized.text('ox_wallet.download_button'),
      height: 48.px,
      enable: _cashuToken != null,
      onTap: () => WalletUtils.exportToken(_cashuToken ?? ''),
    ).setPaddingOnly(top: 24.px,);
  }

  void _getCashuToken() async {
    List<IMintIsar> mints = widget.mint == null ? EcashManager.shared.mintList : [widget.mint!];
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