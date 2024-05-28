import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_relay_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_module_service/ox_module_service.dart';

class MomentZapPage extends StatefulWidget {
  final UserDB userDB;
  final String eventId;

  const MomentZapPage({super.key, required this.userDB, required this.eventId});

  @override
  State<MomentZapPage> createState() => _MomentZapPageState();
}

class _MomentZapPageState extends State<MomentZapPage> {

  double get sectionSpacing => 16.px;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String get zapAmountStr => _amountController.text.orDefault(defaultSatsValue);
  int get zapAmount => int.tryParse(zapAmountStr) ?? 0;
  String get zapDescription => _descriptionController.text.orDefault(defaultDescription);

  final defaultSatsValue = OXUserInfoManager.sharedInstance.defaultZapAmount.toString();
  final defaultDescription = 'Zaps';

  @override
  void initState() {
    _amountController.text = defaultSatsValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: ThemeColor.color190,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.px),
              topRight: Radius.circular(16.px),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Text(
                          'Zaps',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        _buildSectionView(
                          title: 'Amount',
                          children: [
                            _buildInputRow(
                              placeholder: defaultSatsValue,
                              controller: _amountController,
                              suffix: 'Sats',
                              maxLength: 9,
                              keyboardType: TextInputType.number,
                            )
                          ],
                        ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        _buildSectionView(
                          title: 'Description',
                          children: [
                            _buildInputRow(
                              placeholder: defaultDescription,
                              controller: _descriptionController,
                              maxLength: 50,
                            )
                          ],
                        ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        CommonButton.themeButton(
                          text: 'Zap',
                          onTap: _zap,
                        ).setPadding(EdgeInsets.only(top: sectionSpacing)),
                      ],
                    ).setPadding(EdgeInsets.symmetric(horizontal: Adapt.px(30))),
                  ),
                ),
              ),
            ],
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

  Widget _buildSectionView({
    required String title,
    required List<Widget> children,
  }) {

    Widget content = Column(
      children: [
        SizedBox(height: Adapt.px(12)),
        Container(
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.circular(16.px),
          ),
          child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: children.length,
              itemBuilder: (_, int index) => children[index],
              separatorBuilder: (_, __) => Divider(height: 1.px,)
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        content,
      ],
    );
  }

  Widget _buildInputRow({
    String placeholder = '',
    required TextEditingController controller,
    String suffix = '',
    int? maxLength,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: Adapt.px(48),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.px),
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
    );
  }

  Future<void> _zap() async {
    if (zapAmount < 1) {
      await CommonToast.instance.show(context, 'Zap amount cannot be 0');
      return ;
    }

    final relays = OXRelayManager.sharedInstance.relayAddressList;
    final noteId = widget.eventId;
    final recipient = widget.userDB.pubKey;
    String lnurl = widget.userDB.lnurl ?? '';

    if (lnurl.contains('@')) {
      try {
        lnurl = await Zaps.getLnurlFromLnaddr(lnurl);
      } catch (error) {
        return;
      }
    }

    OXLoading.show();
    final invokeResult = await Moment.sharedInstance.getZapNoteInvoice(
      relays,
      zapAmount,
      lnurl,
      recipient,
      noteId,
      zapDescription,
      false,
    );
    final invoice = invokeResult['invoice'] ?? '';
    OXLoading.dismiss();

    OXNavigator.pop(context);
    await OXModuleService.pushPage(context, 'ox_usercenter', 'ZapsInvoiceDialog', {'invoice':invoice});
  }
}
