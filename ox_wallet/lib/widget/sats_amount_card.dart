import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/widget/currency_sats_conversion.dart';
import 'package:ox_wallet/widget/sats_amount_textfield.dart';

class SatsAmountCard extends StatelessWidget {
  final TextEditingController controller;
  final bool enable;

  const SatsAmountCard({super.key, required this.controller, bool? enable}) : enable = enable ?? true;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      verticalPadding: 24.px,
      child: Column(
        children: [
          const Text('Sats Amount'),
          SizedBox(height: 16.px,),
          SatsAmountTextField(controller: controller,enable: enable,),
          // SizedBox(height: 8.px),
          // CurrencySatsConversion(controller: controller,),
        ],
      ),
    );
  }
}
