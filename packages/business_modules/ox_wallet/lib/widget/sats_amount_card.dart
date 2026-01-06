import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/sats_amount_textfield.dart';
import 'package:ox_localizable/ox_localizable.dart';

class SatsAmountCard extends StatelessWidget {
  final TextEditingController controller;
  final bool enable;
  final int? maxBalance;
  final VoidCallback? onSendMax;

  const SatsAmountCard({
    super.key, 
    required this.controller, 
    bool? enable,
    this.maxBalance,
    this.onSendMax,
  }) : enable = enable ?? true;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      verticalPadding: 24.px,
      child: Column(
        children: [
          const Text('Sats Amount'),
          SizedBox(height: 16.px,),
          SatsAmountTextField(controller: controller,enable: enable,),
          if (maxBalance != null && maxBalance! > 0 && onSendMax != null)
            Padding(
              padding: EdgeInsets.only(top: 12.px),
              child: GestureDetector(
                onTap: onSendMax,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
                  decoration: BoxDecoration(
                    color: ThemeColor.color170,
                    borderRadius: BorderRadius.circular(8.px),
                    border: Border.all(color: ThemeColor.color160, width: 1),
                  ),
                  child: Text(
                    Localized.text('ox_wallet.send_max_button'),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: ThemeColor.color0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          // SizedBox(height: 8.px),
          // CurrencySatsConversion(controller: controller,),
        ],
      ),
    );
  }
}
