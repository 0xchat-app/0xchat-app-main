import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_wallet/page/wallet_mint_choose_page.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_localizable/ox_localizable.dart';

class MintItem extends StatelessWidget {
  final IMint? mint;
  final double? height;
  final ValueChanged<IMint?>? onChanged;

  const MintItem({super.key, required this.mint, this.onChanged, this.height});

  @override
  Widget build(BuildContext context) {
    final isDefaultMint = mint != null ? EcashManager.shared.isDefaultMint(mint!) : false;
    return GestureDetector(
      onTap: _onChanged,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: height ?? 58.px,
        padding: EdgeInsets.symmetric(vertical: 8.px,horizontal: 16.px),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.px),
          gradient: LinearGradient(
              colors: [
                isDefaultMint ? ThemeColor.gradientMainEnd.withOpacity(0.24) : ThemeColor.color180,
                isDefaultMint ? ThemeColor.gradientMainStart.withOpacity(0.24) : ThemeColor.color180,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: 14.px,
            fontWeight: FontWeight.w400,
            color: ThemeColor.color100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              mint != null ? Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        isDefaultMint ? CommonImage(iconName: 'icon_default_mint.png',size: 22.px,package: 'ox_wallet',).setPaddingOnly(right: 4.px) : Container(),
                        Expanded(
                          child: Text(
                            _mintTitle(mint!),
                            style: TextStyle(
                                fontSize: 16.px,
                                color: ThemeColor.color0,
                                height: 22.px / 16.px,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                    Text('${mint!.balance} Sats',style: TextStyle(height: 20.px / 14.px),),
                  ],
                ),
              ) : Expanded(child: Text(Localized.text('ox_wallet.select_mint_text'))),
              CommonImage(
                iconName: 'icon_wallet_more_arrow.png',
                size: 24.px,
                package: 'ox_wallet',
              )
            ],
          ),
        ),
      ),
    );
  }

  String _mintTitle(IMint mint) => mint.name.isNotEmpty ? mint.name : mint.mintURL;

  void _onChanged() {
    if (onChanged != null) {
      onChanged!(mint);
    }
  }
}

class MintIndicatorItem extends StatelessWidget {
  final IMint? mint;
  final ValueChanged<IMint>? onChanged;

  const MintIndicatorItem({super.key, this.mint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return MintItem(
      mint: mint,
      onChanged: (mint) => _handleChanged(context, mint),
    );
  }

  Future<void> _handleChanged(context,mint) async => await OXNavigator.pushPage(context, (context) => WalletMintChoosePage(onChanged: onChanged,));
}