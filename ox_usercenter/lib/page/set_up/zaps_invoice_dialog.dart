import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ox_common/model/wallet_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/took_kit.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/launch/launch_third_party_app.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: zaps_invoice_dialog
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/11 10:33
class ZapsInvoiceDialog extends StatefulWidget {

  final String invoice;
  final Future<bool> Function(WalletModel wallet)? walletOnPress;

  const ZapsInvoiceDialog({super.key, required this.invoice, this.walletOnPress});

  @override
  State<StatefulWidget> createState() {
    return _ZapsInvoiceDialogState();
  }
}

class _ZapsInvoiceDialogState extends State<ZapsInvoiceDialog> {

  final List<WalletModel> _itemList = WalletModel.wallets;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(12)),
          color: ThemeColor.color190,
        ),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(16)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _topView(),
              Text(
                Localized.text('ox_usercenter.select_wallet_title'),
                style: TextStyle(
                  fontSize: Adapt.px(16),
                  color: ThemeColor.color0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Adapt.px(12),),
              Container(
                decoration: BoxDecoration(
                  color: ThemeColor.color180,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _itemList.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      WalletModel tempItem = _itemList[index];
                      return ListTile(
                        title: Text(
                          tempItem.title,
                          style: TextStyle(
                            fontSize: Adapt.px(16),
                            color: ThemeColor.color0,
                          ),
                        ),
                        leading: CommonImage(
                          iconName: tempItem.image,
                          width: Adapt.px(32),
                          height: Adapt.px(32),
                          package: 'ox_usercenter',
                        ),
                        onTap: ()=> _onTap(tempItem),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  Localized.text('ox_usercenter.pay_invoice_title'),
                  style: TextStyle(
                    fontSize: Adapt.px(16),
                    color: ThemeColor.color0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                OXNavigator.pop(context);
              },
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      ThemeColor.gradientMainEnd,
                      ThemeColor.gradientMainStart,
                    ],
                  ).createShader(Offset.zero & bounds.size);
                },
                child: Text(
                  Localized.text('ox_common.complete'),
                  style: TextStyle(
                    fontSize: Adapt.px(16),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: Adapt.px(30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                Localized.text('ox_usercenter.copy_invoice_title'),
                style: TextStyle(
                  fontSize: Adapt.px(16),
                  color: ThemeColor.color0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: Adapt.px(12),
        ),
        Container(
          width: double.infinity,
          height: Adapt.px(68),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(16)),
            color: ThemeColor.color180,
          ),
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(16), vertical: Adapt.px(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: Adapt.px(100),
                  child: Text(
                    widget.invoice,
                    style: TextStyle(
                      color: ThemeColor.color40,
                      fontSize: Adapt.px(16),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await TookKit.copyKey(context, widget.invoice);
                },
                child: Container(
                  width: Adapt.px(48),
                  alignment: Alignment.center,
                  child: CommonImage(
                    iconName: 'icon_copy.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                    fit: BoxFit.fill,
                    useTheme: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ).setPadding(EdgeInsets.only(bottom: Adapt.px(42)));
  }

  void _onTap(WalletModel walletModel) async {

    final walletOnPress = widget.walletOnPress;

    bool canOpen = true;
    if (walletOnPress != null) {
      canOpen = await walletOnPress(walletModel);
    }

    if (!canOpen) return ;

    String url = '${walletModel.scheme}${widget.invoice}';
    if (Platform.isIOS) {

      LaunchThirdPartyApp.openWallet(url, walletModel.appStoreUrl ?? '', context: context);
    } else if (Platform.isAndroid) {
      LaunchThirdPartyApp.openWallet(url, walletModel.playStoreUrl ?? '', context: context);
    }
  }
}
