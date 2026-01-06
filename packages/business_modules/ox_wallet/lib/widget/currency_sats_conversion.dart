import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';

class CurrencySatsConversion extends StatelessWidget {

  final TextEditingController controller;
  final TextStyle? style;

  const CurrencySatsConversion({super.key, required this.controller, this.style});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        String satsAmountStr = controller.text;
        String usd = '';
        if (satsAmountStr.isNotEmpty) {
          double satsAmount = double.parse(satsAmountStr);
          usd = WalletUtils.satoshiToUSD(satsAmount);
        }
        return Text(
          '\$$usd',
          style: style ??
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: ThemeColor.color100,
              ),
        );
      },
    );
  }
}
