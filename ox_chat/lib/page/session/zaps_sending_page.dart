import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';

class ZapsSendingPage extends StatefulWidget {
  @override
  _ZapsSendingPageState createState() => _ZapsSendingPageState();
}

class _ZapsSendingPageState extends State<ZapsSendingPage> {

  final TextEditingController amountController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final defaultSatsValue = '0';

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: ThemeColor.color190,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
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
                _buildInputRow('Amount', '0.00 Sats', amountController)
                    .setPadding(EdgeInsets.only(top: Adapt.px(24))),
                _buildInputRow('Description', 'Best wishes', descriptionController)
                    .setPadding(EdgeInsets.only(top: Adapt.px(24))),
                _buildSatsText()
                    .setPadding(EdgeInsets.only(top: Adapt.px(24))),
                CommonButton.themeButton('Send')
                    .setPadding(EdgeInsets.only(top: Adapt.px(24))),
              ],
            ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(30))),
          ],
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
        actions: [
          _buildSettingIcon(),
        ],
    );

  Widget _buildSettingIcon() =>
      GestureDetector(
        onTap: () {

        },
        child: CommonImage(
          iconName: 'icon_more.png',
          width: Adapt.px(24),
          height: Adapt.px(24),
          package: 'ox_chat',
        ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(24), vertical: Adapt.px(16))),
      );

  Widget _buildInputRow(
      String title, String placeholder, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
                isDense: true,
              ),
              onChanged: (_) {
                setState(() {}); // Update UI on input change
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSatsText() {
    var sats = amountController.text;
    if (sats.isEmpty) {
      sats = defaultSatsValue;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$sats',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        Text(
          'Sats',
          style: TextStyle(fontSize: 16),
        ).setPadding(EdgeInsets.only(top: 7, left: 4)),
      ],
    );
  }
}
