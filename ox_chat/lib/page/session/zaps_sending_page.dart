import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/business_interface/ox_usercenter/interface.dart';
import 'package:ox_common/model/wallet_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/num_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

class ZapsSendingPage extends StatefulWidget {

  ZapsSendingPage(this.otherUser, this.zapsInfoCallback);

  final UserDBISAR otherUser;
  final Function(Map result) zapsInfoCallback;

  @override
  _ZapsSendingPageState createState() => _ZapsSendingPageState();
}

class _ZapsSendingPageState extends State<ZapsSendingPage> {

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final defaultSatsValue = '0';
  final defaultDescription = Localized.text('ox_chat.zap_default_description');

  String get zapsAmount => amountController.text.orDefault(defaultSatsValue);
  String get zapsDescription => descriptionController.text.orDefault(defaultDescription);

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());  // 移除焦点
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: ThemeColor.color190,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavBar(),
                  Column(
                    children: [
                      Text(
                        'Zaps',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ).setPadding(EdgeInsets.only(top: Adapt.px(24))),
                      _buildInputRow(
                        title: Localized.text('ox_chat.zap_amount'),
                        placeholder: defaultSatsValue,
                        controller: amountController,
                        suffix: 'Sats',
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                      ).setPadding(EdgeInsets.only(top: Adapt.px(24))),
                      _buildInputRow(
                        title: Localized.text('ox_chat.description'),
                        placeholder: defaultDescription,
                        controller: descriptionController,
                        maxLength: 50,
                      ).setPadding(EdgeInsets.only(top: Adapt.px(24))),
                      _buildSatsText()
                          .setPadding(EdgeInsets.only(top: Adapt.px(24))),
                      CommonButton.themeButton(text: Localized.text('ox_chat.send'), onTap: _sendButtonOnPressed)
                          .setPadding(EdgeInsets.only(top: Adapt.px(24))),
                    ],
                  ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(30))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavBar() =>
      CommonAppBar(
        backgroundColor: Colors.transparent,
        useLargeTitle: false,
        centerTitle: true,
        isClose: true,
    );

  Widget _buildSettingIcon() =>
      GestureDetector(
        onTap: () {

        },
        child: CommonImage(
          iconName: 'icon_more_gray.png',
          width: Adapt.px(24),
          height: Adapt.px(24),
          package: 'ox_chat',
        ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(16))),
      );

  Widget _buildInputRow({
    String title = '',
    String placeholder = '',
    required TextEditingController controller,
    String suffix = '',
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Adapt.px(12)),
        Container(
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.circular(8),
          ),
          height: Adapt.px(48),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: keyboardType,
                    maxLength: maxLength,
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: placeholder,
                      isDense: true,
                      counterText: '',
                    ),
                    onChanged: (_) {
                      setState(() {}); // Update UI on input change
                    },
                  ),
                ),
                if (suffix.isNotEmpty)
                  Text(
                    suffix,
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeColor.color0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            )
          ),
        ),
      ],
    );
  }

  Widget _buildSatsText() {
    final text = int.tryParse(zapsAmount)?.formatWithCommas() ?? defaultSatsValue;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        Text(
          'Sats',
          style: TextStyle(fontSize: 16),
        ).setPadding(EdgeInsets.only(top: 7, left: 4)),
      ],
    );
  }

  Future _sendButtonOnPressed() async {
    final amount = int.tryParse(zapsAmount) ?? 0;
    final description = zapsDescription;
    final lnurl = widget.otherUser.lnAddress ?? '';
    if (amount < 1) {
      CommonToast.instance.show(context, Localized.text('ox_chat.zap_illegal_toast'));
      return ;
    }

    OXLoading.show();

    final invokeResult = await OXUserCenterInterface.getInvoice(
      sats: amount,
      recipient: widget.otherUser.pubKey,
      otherLnurl: lnurl,
      content: description,
      privateZap: true,
    );
    final zapper = invokeResult['zapper'] ?? '';
    final invoice = invokeResult['invoice'] ?? '';
    final message = invokeResult['message'] ?? '';
    OXLoading.dismiss();

    if (invoice.isEmpty || zapper.isEmpty) {
      CommonToast.instance.show(context, message);
      return ;
    }

    final isTapOnWallet = await _jumpToWalletSelectionPage(
      zapper: zapper,
      invoice: invoice,
      amount: amount,
      description: description,
    );
    if (isTapOnWallet) {
      OXNavigator.pop(context);
    }
  }

  Future<bool> _jumpToWalletSelectionPage({
    required String zapper,
    required String invoice,
    required int amount,
    required String description,
  }) async {
    var isConfirm = false;
    await OXModuleService.pushPage(context, 'ox_usercenter', 'ZapsInvoiceDialog', {
      'invoice': invoice,
      'walletOnPress': (WalletModel wallet) async {
        widget.zapsInfoCallback({
          'zapper': zapper,
          'invoice': invoice,
          'amount': amount.toString(),
          'description': description,
        });
        isConfirm = true;
        return true;
      },
    });
    return isConfirm;
  }
}
