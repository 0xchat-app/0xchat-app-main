import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/zaps/zaps_user_info_Item.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'zaps_action_handler.dart';

class ZapsAssistedPage extends StatefulWidget {
  final UserDB userDB;
  final ZapsActionHandler handler;
  final String lnurl;
  final String? eventId;
  final bool privateZap;

  const ZapsAssistedPage({
    super.key,
    required this.userDB,
    required this.handler,
    required this.lnurl,
    this.eventId,
    bool? privateZap,
  }): privateZap = privateZap ?? false;

  @override
  State<ZapsAssistedPage> createState() => _ZapsAssistedPageState();
}

class _ZapsAssistedPageState extends State<ZapsAssistedPage> {

  double get sectionSpacing => 16.px;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String get zapAmountStr => _amountController.text.orDefault(defaultSatsValue);
  int get zapAmount => int.tryParse(zapAmountStr) ?? 0;
  String get zapDescription => _descriptionController.text.orDefault(defaultDescription);

  final defaultSatsValue = OXUserInfoManager.sharedInstance.defaultZapAmount.toString();
  final defaultDescription = Localized.text('ox_discovery.description_hint_text');

  IMint? mint;
  bool _isDefaultEcashWallet = false;
  bool _isDefaultThirdPartyWallet = false;
  String _defaultWalletName = '';

  @override
  void initState() {
    super.initState();
    _amountController.text = defaultSatsValue;
    mint = OXWalletInterface.getDefaultMint();
    _updateDefaultWallet();
  }

  void _updateDefaultWallet() async {
    Map<String, dynamic> defaultWalletInfo = await widget.handler.getDefaultWalletInfo();
    final isDefaultEcashWallet = defaultWalletInfo['isDefaultEcashWallet'];
    widget.handler.isDefaultEcashWallet = isDefaultEcashWallet;
    setState(() {
      _isDefaultEcashWallet = isDefaultEcashWallet;
      _isDefaultThirdPartyWallet = defaultWalletInfo['isDefaultThirdPartyWallet'];
      _defaultWalletName = defaultWalletInfo['defaultWalletName'];
    });
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
                          Localized.text('ox_discovery.zaps_destination_title'),
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ).setPadding(EdgeInsets.only(top: sectionSpacing)),
                        ZapsUserInfoItem(
                          userDB: widget.userDB,
                        ).setPaddingOnly(top: sectionSpacing),
                        _buildSectionView(
                          title: Localized.text('ox_discovery.zap_amount_label'),
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
                          title: Localized.text('ox_discovery.description_text'),
                          children: [
                            _buildInputRow(
                              placeholder: defaultDescription,
                              controller: _descriptionController,
                              maxLength: 50,
                            )
                          ],
                        ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        if (_isDefaultEcashWallet)
                          _buildSectionView(
                            title: 'Mint',
                            children: [_buildMintSelector()],
                          ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        if (_isDefaultThirdPartyWallet)
                          _buildSectionView(
                            title: Localized.text('ox_wallet.wallet_text'),
                            children: [_buildWalletItem()],
                          ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        CommonButton.themeButton(
                          text: Localized.text('ox_discovery.zaps'),
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
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              OXModuleService.pushPage(context, 'ox_usercenter', 'ZapsSettingPage', {'onChanged': _onChanged});
            },
            child: CommonImage(
              iconName: 'icon_more.png',
              package: 'ox_common',
              size: 24.px,
              useTheme: true,
            ).setPaddingOnly(right: 30.px),
          )
        ],
      );

  Widget _buildMintSelector() {
    return OXWalletInterface.buildMintIndicatorItem(
        mint: mint,
        selectedMintChange: (mint) {
          setState(() {
            this.mint = mint;
          });
        }
    );
  }

  void _onChanged(bool value) {
    _updateDefaultWallet();
  }

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

  Widget _buildWalletItem() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      height: 48.px,
      child: Text(_defaultWalletName),
    );
  }

  _zap() async {
    await widget.handler.handleZapChannel(
      context,
      lnurl: widget.lnurl,
      zapAmount: zapAmount,
      eventId: widget.eventId,
      description: zapDescription,
      showLoading: true,
    );
  }
}
