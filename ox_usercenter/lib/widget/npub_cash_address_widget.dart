import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

class NpubCashAddressWidget extends StatelessWidget {
  final VoidCallback onClick;

  const NpubCashAddressWidget({Key? key, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.px,
            color: ThemeColor.color100,
            height: 17.px / 12.px,
          ),
          children: [
            TextSpan(text: Localized.text('ox_usercenter.str_npub_address_tips')),
            TextSpan(
                text: Localized.text('ox_usercenter.str_set_npub_address_tips'),
                style: TextStyle(
                  color: ThemeColor.purple2,
                ),
                recognizer: TapGestureRecognizer()..onTap = onClick)
          ]),
    );
  }
}
