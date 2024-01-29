import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cashu_dart/cashu_dart.dart';

import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/num_utils.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_action_dialog.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_localizable/ox_localizable.dart';

enum _PackageType {
  single,
  multipleRandom,
  multipleEqual,
}

extension _PackageTypeEx on _PackageType {
  String get text {
    switch (this) {
      case _PackageType.single: return '';
      case _PackageType.multipleRandom: return 'Random Amount';
      case _PackageType.multipleEqual: return 'Indentical Amount';
    }
  }

  String get amountInputTitle {
    switch (this) {
      case _PackageType.single: return 'Amount';
      case _PackageType.multipleRandom: return 'Total Amount';
      case _PackageType.multipleEqual: return 'Amount Each';
    }
  }
}

class EcashSendingPage extends StatefulWidget {

  const EcashSendingPage({
    required this.isGroupEcash,
    required this.ecashInfoCallback,
  });

  final bool isGroupEcash;
  final Function(List<String> token) ecashInfoCallback;

  @override
  _EcashSendingPageState createState() => _EcashSendingPageState();
}

class _EcashSendingPageState extends State<EcashSendingPage> {

  _PackageType packageType = _PackageType.single;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final defaultSatsValue = '0';
  final defaultDescription = Localized.text('ox_chat.zap_default_description');

  String get ecashAmount => amountController.text.orDefault(defaultSatsValue);
  int get ecashCount => widget.isGroupEcash ? int.tryParse(quantityController.text) ?? 0 : 1;
  String get ecashDescription => descriptionController.text.orDefault(defaultDescription);

  @override
  void initState() {
    super.initState();
    packageType = widget.isGroupEcash ? _PackageType.multipleRandom : _PackageType.single;
  }

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
                        'Ecash',
                        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                      ).setPadding(EdgeInsets.only(top: 24.px)),
                      if (widget.isGroupEcash)
                        _buildTypeSelector(),
                      if (widget.isGroupEcash)
                        _buildInputRow(
                          title: 'Quantity',
                          placeholder: 'Enter quantity',
                          controller: quantityController,
                          maxLength: 3,
                        ).setPadding(EdgeInsets.only(top: 24.px)),
                      _buildInputRow(
                        title: packageType.amountInputTitle,
                        placeholder: defaultSatsValue,
                        controller: amountController,
                        suffix: 'Sats',
                        maxLength: 9,
                        keyboardType: TextInputType.number,
                      ).setPadding(EdgeInsets.only(top: 24.px)),
                      _buildInputRow(
                        title: Localized.text('ox_chat.description'),
                        placeholder: defaultDescription,
                        controller: descriptionController,
                        maxLength: 50,
                      ).setPadding(EdgeInsets.only(top: 24.px)),
                      _buildSatsText()
                          .setPadding(EdgeInsets.only(top: 24.px)),
                      CommonButton.themeButton(text: Localized.text('ox_chat.send'), onTap: _sendButtonOnPressed)
                          .setPadding(EdgeInsets.only(top: 24.px)),
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

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Adapt.px(12)),
        GestureDetector(
          onTap: () async {
            final result = await OXActionDialog.show<_PackageType>(
              context,
              data: [
                OXActionModel(identify: _PackageType.multipleRandom, text: _PackageType.multipleRandom.text),
                OXActionModel(identify: _PackageType.multipleEqual, text: _PackageType.multipleEqual.text),
              ],
              backGroundColor: ThemeColor.color180,
              separatorCancelColor: ThemeColor.color190,
            );
            if (result != null && result.identify != packageType) {
              setState(() {
                packageType = result.identify;
              });
            }
          },
          child: Container(
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
                      child: Text(packageType.text),
                    ),
                    CommonImage(
                      iconName: 'icon_more.png',
                      size: 24.px,
                      package: 'ox_chat',
                      useTheme: true,
                    ),
                  ],
                )
            ),
          ),
        ),
      ],
    );
  }

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
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
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
                      fontSize: 16.sp,
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
    final text = int.tryParse(ecashAmount)?.formatWithCommas() ?? defaultSatsValue;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          'Sats',
          style: TextStyle(fontSize: 16.sp),
        ).setPadding(EdgeInsets.only(top: 7.px, left: 4.px)),
      ],
    );
  }

  Future _sendButtonOnPressed() async {
    final amount = int.tryParse(ecashAmount) ?? 0;
    final ecashCount = this.ecashCount;
    final description = ecashDescription;
    if (amount < 1) {
      CommonToast.instance.show(context, 'Ecash amount cannot be 0');
      return ;
    }
    if (ecashCount < 1) {
      CommonToast.instance.show(context, 'Ecash quantity cannot be 0');
      return ;
    }
    
    final mint = OXWalletInterface.getDefaultMint();
    if (mint == null) {
      CommonToast.instance.show(context, 'Default mint not found');
      return ;
    }

    List<String> tokenList = [];
    
    OXLoading.show();
    List<int> amountList = [];
    switch (packageType) {
      case _PackageType.single:
        amountList = [amount];
        break ;
      case _PackageType.multipleRandom:
        amountList = randomAmount(amount, ecashCount);
        break ;
      case _PackageType.multipleEqual:
        amountList = List.generate(ecashCount, (index) => amount);
        break ;
    }

    var errorMsg = '';
    for (final amount in amountList) {
      final (token, error) = await getEcashToken(mint, amount, description);
      if (token.isEmpty) {
        errorMsg = error;
        break;
      }
      tokenList.add(token);
    }
    OXLoading.dismiss();

    if (errorMsg.isNotEmpty) {
      CommonToast.instance.show(context, errorMsg);
      return ;
    }

    widget.ecashInfoCallback(tokenList);
  }

  List<int> randomAmount(int totalAmount, int count) {

    final result = <int>[];
    var remainAmount = totalAmount;
    var remainCount = count;

    final random = Random();

    while (remainCount > 0) {
      if (remainCount == 1) {
        result.add(remainAmount);
        break ;
      }
      final minM = 1;
      var maxM = minM.toDouble();
      if (remainAmount != remainCount * minM) {
        maxM = remainAmount / remainCount * 2.0;
      }
      final amount = (random.nextDouble() * maxM).round().clamp(minM, maxM).toInt();
      result.add(amount);
      remainAmount -= amount;
      remainCount--;
    }

    return result;
  }

  Future<(String token, String errorMsg)> getEcashToken(IMint mint, int amount, String memo) async {
    final response = await Cashu.sendEcash(
      mint: mint,
      amount: amount,
      memo: memo,
    );
    if (response.isSuccess) {
      return (response.data, '');
    } else {
      return ('', response.errorMsg);
    }
  }
}
