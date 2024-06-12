import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_cache_manager/ox_cache_manager.dart';
import 'package:ox_common/business_interface/ox_usercenter/interface.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/model/wallet_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/utils/string_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_discovery/page/widgets/zap_user_info_Item.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:cashu_dart/cashu_dart.dart';

class MomentZapPage extends StatefulWidget {
  final UserDB userDB;
  final String? eventId;
  final bool privateZap;
  final Function(Map result)? zapsInfoCallback;

  const MomentZapPage({
    super.key,
    required this.userDB,
    this.eventId,
    bool? privateZap,
    this.zapsInfoCallback,
  }): privateZap = privateZap ?? false;

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
  final defaultDescription = Localized.text('ox_discovery.description_hint_text');

  IMint? mint;
  bool _isDefaultEcashWallet = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = defaultSatsValue;
    mint = OXWalletInterface.getDefaultMint();
    _updateDefaultWallet();
  }

  void _updateDefaultWallet() async {
    String? pubkey = Account.sharedInstance.me?.pubKey;
    bool isShowWalletSelector = await OXCacheManager.defaultOXCacheManager.getForeverData('$pubkey.isShowWalletSelector') ?? true;
    String defaultWalletName = await OXCacheManager.defaultOXCacheManager.getForeverData('$pubkey.defaultWallet') ?? '';
    bool isDefaultEcashWallet = !isShowWalletSelector && defaultWalletName == 'My Ecash Wallet';
    if(isDefaultEcashWallet) {
      setState(() {
        _isDefaultEcashWallet = isDefaultEcashWallet;
      });
    }
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
                        ZapUserInfoItem(
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
                          _buildMintSelector().setPadding(EdgeInsets.only(top: sectionSpacing)),

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
              OXModuleService.pushPage(context, 'ox_usercenter', 'ZapsSettingPage', {});
            },
            child: CommonImage(
              iconName: 'icon_dapp_more.png',
              package: 'ox_common',
              size: 24.px,
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
      await CommonToast.instance.show(context, Localized.text('ox_discovery.enter_amount_tips'));
      return ;
    }

    final mint = this.mint;
    if (_isDefaultEcashWallet) {
      if (mint == null) {
        CommonToast.instance.show(context, Localized.text('ox_discovery.mint_empty_tips'));
        return;
      }

      if (zapAmount > mint.balance) {
        CommonToast.instance.show(context, Localized.text('ox_discovery.insufficient_balance_tips'));
        return;
      }
    }

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
    final invokeResult = await OXUserCenterInterface.getInvoice(
      sats: zapAmount,
      otherLnurl: lnurl,
      recipient: recipient,
      eventId: widget.eventId,
      content: zapDescription,
      privateZap: widget.privateZap
    );
    final invoice = invokeResult['invoice'] ?? '';
    final zapper = invokeResult['zapper'] ?? '';

    final zapInfo = {
      'zapper': zapper,
      'invoice': invoice,
      'amount': zapAmount.toString(),
      'description': zapDescription,
    };

    if(_isDefaultEcashWallet) {
      final response = await Cashu.payingLightningInvoice(mint: mint!, pr: invoice);
      if (!response.isSuccess) {
        CommonToast.instance.show(context, response.errorMsg);
        return;
      }
      widget.zapsInfoCallback?.call(zapInfo);
      OXLoading.dismiss();
      OXNavigator.pop(context);
    } else {
      OXLoading.dismiss();
      final isTapOnWallet = await _jumpToWalletSelectionPage(zapInfo);
      if (isTapOnWallet) {
        OXNavigator.pop(context);
      }
    }
  }

  Future<bool> _jumpToWalletSelectionPage(Map result) async {
    var isConfirm = false;
    await OXModuleService.pushPage(
        context, 'ox_usercenter', 'ZapsInvoiceDialog', {
      'invoice': result['invoice'] ?? '',
      'walletOnPress': (WalletModel wallet) async {
        widget.zapsInfoCallback?.call(result);
        isConfirm = true;
        return true;
      },
    });
    return isConfirm;
  }
}
