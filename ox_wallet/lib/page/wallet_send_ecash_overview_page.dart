import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/widgets.dart';
import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/utils/list_extension.dart';
import 'package:ox_common/widgets/avatar.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_wallet/page/wallet_send_ecash_coin_selection_page.dart';
import 'package:ox_wallet/page/wallet_send_ecash_new_token_page.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/send_p2pk_option_widget.dart';
import 'package:ox_wallet/widget/switch_widget.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_localizable/ox_localizable.dart';

class WalletSendEcashOverviewPage extends StatefulWidget {
  final int amount;
  final String? memo;
  final IMint mint;
  final SendP2PKOption? p2pkOption;
  const WalletSendEcashOverviewPage({super.key, required this.amount, this.memo, required this.mint, this.p2pkOption,});

  @override
  State<WalletSendEcashOverviewPage> createState() => _WalletSendEcashOverviewPageState();
}

class _WalletSendEcashOverviewPageState extends State<WalletSendEcashOverviewPage> {

  List<CardItemModel> _items = [];

  bool _isCoinSelection = false;
  List<Proof>? _selectedProofs;

  double get createTokenBtnBottomMargin => 12.px;
  double get createTokenBtnHeight => 44.px;

  @override
  void initState() {
    int balance = widget.mint.balance - widget.amount;
    _items = [
      CardItemModel(label: Localized.text('ox_wallet.payment_type'),content: Localized.text('ox_wallet.send_ecash'),),
      CardItemModel(label: 'Mint',content: widget.mint.name,),
      CardItemModel(label: Localized.text('ox_wallet.amount_title'),content: widget.amount.toString(),),
      CardItemModel(label: Localized.text('ox_wallet.ecash_balance_title'),content: '$balance Sats',),
      CardItemModel(
        label: 'Coin Selection',
        content: Localized.text('ox_wallet.coin_selection_instruction'),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final p2pkOption = widget.p2pkOption;
    final contentBottom = MediaQuery.of(context).padding.bottom +
        createTokenBtnBottomMargin +
        createTokenBtnHeight / 2;
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: Localized.text('ox_wallet.send_ecash'),
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: contentBottom,
            child: ListView(
              children: [
                CommonCard(
                  verticalPadding: 0,
                  horizontalPadding: 0,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (_, index) => _buildItem(_items[index]),
                    separatorBuilder: (context,index) => Divider(height: 1, color: ThemeColor.color160,),
                    itemCount: _items.length,
                  ),
                ).setPaddingOnly(top: 12.px),
                if (p2pkOption != null && p2pkOption.enable)
                  CommonCard(
                    verticalPadding: 0,
                    horizontalPadding: 0,
                    child: Column(
                      children: [
                        _buildItem(CardItemModel(label: 'Pubkey', content: p2pkOption.singer.length.toString())),
                        if (p2pkOption.singer.isNotEmpty)
                          _buildUserList(p2pkOption.singer),
                        _buildItem(CardItemModel(label: 'SigFlags', content: p2pkOption.sigFlagDesc)),
                        _buildItem(CardItemModel(label: 'N_sig', content: p2pkOption.sigNumDesc)),
                        _buildItem(CardItemModel(label: 'LockTime', content: p2pkOption.lockTimeDesc)),
                        _buildItem(CardItemModel(label: 'Refund', content: p2pkOption.refund.length.toString())),
                        if (p2pkOption.refund.isNotEmpty)
                          _buildUserList(p2pkOption.refund),
                      ].insertEveryN(1, Divider(height: 1, color: ThemeColor.color160,)),
                    ),
                  ).setPadding(EdgeInsets.symmetric(vertical: 24.px))
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: createTokenBtnBottomMargin,
            child: SafeArea(
              top: false,
              child: ThemeButton(
                text: Localized.text('ox_wallet.create_token'),
                height: createTokenBtnHeight,
                onTap: _createToken,
              ),
            ),
          ),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
    );
  }

  Widget _buildItem(CardItemModel item) {
    if(item.label == 'Coin Selection') {
      return CommonCardItem(
        label: item.label,
        content: item.content,
        action: SwitchWidget(
          value: _isCoinSelection,
          onChanged: (value) async {
            if (value) {
              List<Proof>? result = await OXNavigator.pushPage(context, (context) => WalletSendEcashCoinSelectionPage(amount: widget.amount,mint: widget.mint,));
              if(result != null){
                _selectedProofs = result;
                int totalAmount = result.fold(0, (pre, proof) => pre + proof.amountNum);
                _isCoinSelection = true;
                _items.addAll([
                  CardItemModel(label: 'Selected',content: '$totalAmount/${widget.amount} Sats',),
                  CardItemModel(label: 'Change',content: 'Sats',),
                ]);
              }else{
                _isCoinSelection = false;
              }
            }else{
              _items.removeWhere((element) => element.label == 'Selected' || element.label == 'Change');
              _isCoinSelection = false;
              _selectedProofs =  null;
            }
            setState(() {});
          },
        ),
      );
    }
    return CommonCardItem(label: item.label,content: item.content);
  }

  Widget _buildUserList(List<UserDB> userList) {
    return Column(
      children: userList.map((user) {
        return SizedBox(
          height: 44.px,
          child: Row(
            children: [
              OXUserAvatar(user: user, size: 24.px,).setPaddingOnly(right: 4.px),
              Expanded(
                child: Text(
                  user.getUserShowName(),
                  style: TextStyle(
                    color: ThemeColor.color0,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)),
        );

      }).toList(),
    );
  }

  Future<void> _createToken() async {
    await OXLoading.show();
    CashuResponse<String> response;
    final p2pkOption = widget.p2pkOption;
    if (p2pkOption != null) {
      response = await EcashService.sendEcashForP2PK(
        mint: widget.mint,
        amount: widget.amount,
        memo: widget.memo,
        singer: p2pkOption.singer,
        refund: p2pkOption.refund,
        locktime: p2pkOption.lockTime,
        signNumRequired: p2pkOption.sigNum,
        sigFlag: p2pkOption.sigFlag,
        proofs: _selectedProofs,
      );
    } else {
      response = await EcashService.sendEcash(
        mint: widget.mint,
        amount: widget.amount,
        memo: widget.memo,
        proofs: _selectedProofs,
      );
    }

    await OXLoading.dismiss();

    if (OXWalletInterface.checkAndShowDialog(context, response, widget.mint)) return ;
    if (response.isSuccess) {
      OXNavigator.pushPage(context, (context) => WalletSendEcashNewTokenPage(amount: widget.amount,token: response.data,));
      return;
    } else {
      CommonToast.instance.show(context, response.errorMsg);
    }
  }
}
