import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/manager/ecash_helper.dart';
import 'package:ox_chat/page/contacts/user_list_page.dart';
import 'package:ox_chat/utils/widget_tool.dart';

import 'package:ox_common/business_interface/ox_chat/utils.dart';
import 'package:ox_common/business_interface/ox_wallet/interface.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/num_utils.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
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

import 'ecash_condition.dart';

enum _PackageType {
  single,
  multipleRandom,
  multipleEqual,
  exclusive,
}

extension _PackageTypeEx on _PackageType {
  String get text {
    switch (this) {
      case _PackageType.single: return '';
      case _PackageType.multipleRandom: return 'ecash_random_amount'.localized();
      case _PackageType.multipleEqual: return 'ecash_identical_amount'.localized();
      case _PackageType.exclusive: return 'ecash_exclusive'.localized();
    }
  }

  String get amountInputTitle {
    switch (this) {
      case _PackageType.single: return 'zap_amount'.localized();
      case _PackageType.multipleRandom: return 'ecash_total'.localized();
      case _PackageType.multipleEqual: return 'ecash_amount_each'.localized();
      case _PackageType.exclusive: return 'zap_amount'.localized();
    }
  }
}

typedef EcashInfo = (
  List<String> tokenList,
  List<String> receiverPubkeys,
  List<String> signeePubkeys,
  String validityDate,
);

class EcashSendingPage extends StatefulWidget {

  const EcashSendingPage({
    required this.isGroupEcash,
    this.singleReceiver,
    required this.membersGetter,
    required this.ecashInfoCallback,
  });

  final bool isGroupEcash;
  final UserDBISAR? singleReceiver;
  final Future<List<UserDBISAR>?> Function() membersGetter;
  final Function(EcashInfo ecash) ecashInfoCallback;

  @override
  _EcashSendingPageState createState() => _EcashSendingPageState();
}

class _EcashSendingPageState extends State<EcashSendingPage> with
    TickerProviderStateMixin {

  _PackageType packageType = _PackageType.single;
  IMint? mint;

  final EcashCondition condition = EcashCondition();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final defaultSatsValue = '0';
  final defaultDescription = Localized.text('ox_chat.zap_default_description');

  String get ecashAmount => amountController.text.orDefault(defaultSatsValue);
  int get ecashCount => widget.isGroupEcash ? int.tryParse(quantityController.text) ?? 0 : 1;
  String get ecashDescription => descriptionController.text.orDefault(defaultDescription);

  double get sectionSpacing => 16.px;

  AnimationController? advancedController;

  @override
  void initState() {
    super.initState();
    packageType = widget.isGroupEcash ? _PackageType.multipleRandom : _PackageType.single;
    mint = OXWalletInterface.getDefaultMint();


    advancedController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
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
                          'ecash_text'.localized(),
                          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                        ).setPadding(EdgeInsets.only(top: sectionSpacing)),
                        _buildMintSelector().setPadding(EdgeInsets.only(top:sectionSpacing)),

                        if (widget.isGroupEcash)
                          _buildSectionView(
                            title: 'ecash_type'.localized(),
                            children: [
                              _buildSelectorRow(
                                value: packageType.text,
                                onTap: typeOnTap,
                              ),
                            ],
                          ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        if (packageType == _PackageType.exclusive)
                          _buildSectionView(
                            title: 'ecash_send_to'.localized(),
                            children: [
                              _buildSelectorRow(
                                value: receiverText.orDefault('ecash_send_to'.localized()),
                                isPlaceholder: receiverText.isEmpty,
                                onTap: receiverOnTap,
                              ),
                            ],
                          ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        if (widget.isGroupEcash && packageType != _PackageType.exclusive)
                          _buildSectionView(
                            title: 'ecash_quantity'.localized(),
                            children: [
                              _buildInputRow(
                                placeholder: 'ecash_enter_quantity'.localized(),
                                controller: quantityController,
                                maxLength: 3,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        _buildSectionView(
                          title: packageType.amountInputTitle,
                          children: [
                            _buildInputRow(
                              placeholder: defaultSatsValue,
                              controller: amountController,
                              suffix: 'ecash_sats'.localized(),
                              maxLength: 9,
                              keyboardType: TextInputType.number,
                            )
                          ],
                        ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        _buildSectionView(
                          title: Localized.text('ox_chat.description'),
                          children: [
                            _buildInputRow(
                              placeholder: defaultDescription,
                              controller: descriptionController,
                              maxLength: 50,
                            )
                          ],
                        ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        _buildSectionView(
                          title: 'ecash_advanced'.localized(),
                          children:_buildAdvanceItems(),
                          controller: advancedController,
                        ).setPadding(EdgeInsets.only(top: sectionSpacing)),

                        _buildSatsText().setPadding(EdgeInsets.only(top: sectionSpacing)),

                        CommonButton.themeButton(
                          text: Localized.text('ox_chat.send'),
                          onTap: _sendButtonOnPressed,
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
    AnimationController? controller,
  }) {

    Widget content = Column(
      children: [
        SizedBox(height: Adapt.px(12)),
        Container(
          decoration: BoxDecoration(
            color: ThemeColor.color180,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: children.length,
              itemBuilder: (_, int index) => children[index],
              separatorBuilder: (_, __) => Divider(height: 1,)
          ),
        ),
      ],
    );
    if (controller != null) {
      final foldHeightAnimation = Tween<double>(begin: 0.0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
      final foldOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.5, 1, curve: Curves.easeIn),
        ),
      );
      content = AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Opacity(
            opacity: foldOpacityAnimation.value,
            child: SizeTransition(
              axis: Axis.vertical,
              sizeFactor: foldHeightAnimation,
              child: child,
            ),
          );
        },
        child: content,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            if (controller != null)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => setState(() {
                  if (controller.isAnimating) {
                    controller.status == AnimationStatus.forward
                        ? controller.reverse()
                        : controller.forward();
                  } else if (controller.status == AnimationStatus.completed) {
                    controller.reverse();
                  } else {
                    controller.forward();
                  }
                }),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: controller.value * pi,
                      child: child,
                    );
                  },
                  child: CommonImage(
                    iconName: 'icon_badge_arrow_down.png',
                    size: 20.px,
                    package: 'ox_chat',
                  ),
                ).setPaddingOnly(left: 40.px),
              )
          ],
        ),
        content,
      ],
    );
  }

  Widget _buildSelectorRow({
    required String value,
    bool isPlaceholder = false,
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: Adapt.px(48),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isPlaceholder
                          ? ThemeColor.color140
                          : ThemeColor.color0,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                CommonImage(
                  iconName: 'icon_more.png',
                  size: 24.px,
                  package: 'ox_chat',
                  useTheme: true,
                  color: ThemeColor.color20,
                ),
              ],
            )
        ),
      ),
    );
  }

  Widget _buildSelectorOptionRow({
    required String title,
    required String value,
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: Adapt.px(64),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ThemeColor.color0,
                          fontSize: 14.sp,
                          height: 1.4,
                        ),
                      ),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ThemeColor.color100,
                          fontSize: 14.sp,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                CommonImage(
                  iconName: 'icon_more.png',
                  size: 24.px,
                  package: 'ox_chat',
                  useTheme: true,
                  color: ThemeColor.color100,
                ),
              ],
            )
        ),
      ),
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
    );
  }

  List<Widget> _buildAdvanceItems() {
    return [
      _buildSelectorOptionRow(
        title: 'ecash_validity'.localized(),
        value: condition.validDuration.text,
        onTap: validityOnTap,
      ),
      if (widget.isGroupEcash)
        _buildSelectorOptionRow(
          title: 'ecash_multi_signature'.localized(),
          value: signessText,
          onTap: signatureOnTap,
        ),
    ];
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
          'ecash_sats'.localized(),
          style: TextStyle(fontSize: 16.sp),
        ).setPadding(EdgeInsets.only(top: 7.px, left: 4.px)),
      ],
    );
  }

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

  Future typeOnTap() async {
    final result = await OXActionDialog.show<_PackageType>(
      context,
      data: [
        OXActionModel(identify: _PackageType.multipleRandom, text: _PackageType.multipleRandom.text),
        OXActionModel(identify: _PackageType.multipleEqual, text: _PackageType.multipleEqual.text),
        OXActionModel(identify: _PackageType.exclusive, text: _PackageType.exclusive.text),
      ],
      backGroundColor: ThemeColor.color180,
      separatorCancelColor: ThemeColor.color190,
    );
    if (result != null && result.identify != packageType) {
      setState(() {
        packageType = result.identify;
      });
    }
  }

  Future receiverOnTap() async {
    final members = await widget.membersGetter() ?? [];
    final selectedUser = await OXNavigator.presentPage<List<UserDBISAR>>(
      null, (context) => UserSelectionPage(
        title: 'group_member'.localized(),
        userList: members,
        defaultSelected: condition.receiver,
        isMultiSelect: true,
        shouldPop: (selectedUser) {
          UserDBISAR? duplicateUser = condition.signees.where((signee) =>
              selectedUser.contains(signee)).firstOrNull;

          if (duplicateUser != null) {
            CommonToast.instance.show(
              context,
              'ecash_recipient_error_hint'.localized({
                r'${userName}': duplicateUser.getUserShowName(),
              }),
            );
            return false;
          }

          return true;
        },
      ),
    );

    if (selectedUser == null) return ;

    setState(() {
      condition.receiver = selectedUser;
    });
  }

  Future validityOnTap() async {
    final result = await OXActionDialog.show<EcashValidDuration>(
      context,
      data: EcashValidDuration.values.map(
            (e) => OXActionModel(identify: e, text: e.text),
      ).toList(),
      backGroundColor: ThemeColor.color180,
      separatorCancelColor: ThemeColor.color190,
    );
    if (result != null && result.identify != condition.validDuration) {
      setState(() {
        condition.validDuration = result.identify;
      });
    }
  }

  Future signatureOnTap() async {
    final members = await widget.membersGetter() ?? [];
    final selectedUser = await OXNavigator.presentPage<List<UserDBISAR>>(
      null, (context) => UserSelectionPage(
        title: 'group_member'.localized(),
        userList: members,
        defaultSelected: condition.signees,
        isMultiSelect: true,
        shouldPop: (selectedUser) {
          UserDBISAR? duplicateUser = condition.receiver.where((signee) =>
              selectedUser.contains(signee)).firstOrNull;

          if (duplicateUser != null) {
            CommonToast.instance.show(
              context,
              'ecash_signer_error_hint'.localized({
                r'${userName}': duplicateUser.getUserShowName(),
              }),
            );
            return false;
          }

          return true;
        },
      ),
    );
    if (selectedUser == null) return ;

    setState(() {
      condition.signees = selectedUser;
    });
  }

  Future _sendButtonOnPressed() async {
    final amount = int.tryParse(ecashAmount) ?? 0;
    final ecashCount = this.ecashCount;
    final receiver = condition.receiver;
    final signees = condition.signees;
    final validityDate = condition.lockTimeFromNow;

    if (amount < 1) {
      CommonToast.instance.show(context, 'ecash_amount_empty_hint'.localized());
      return ;
    }
    if (packageType != _PackageType.exclusive && ecashCount < 1) {
      CommonToast.instance.show(context, 'ecash_quantity_empty_hint'.localized());
      return ;
    }

    final mint = this.mint;
    if (mint == null) {
      CommonToast.instance.show(context, 'ecash_mint_unselected_hint'.localized());
      return ;
    }

    if (amount > mint.balance) {
      CommonToast.instance.show(context, 'ecash_insufficient_balance_hint'.localized());
      return ;
    }

    if (packageType == _PackageType.multipleRandom && amount < ecashCount) {
      CommonToast.instance.show(context, 'ecash_quantity_exceed_amount_hint'.localized());
      return ;
    }

    switch (packageType) {
      case _PackageType.single:
        await createEcashForSingleType(
          mint,
          amount,
          validityDate,
        );
        break ;
      case _PackageType.multipleRandom:
        final amountList = randomAmount(amount, ecashCount);
        await createEcashForMultipleType(
          mint,
          amountList,
          signees,
          validityDate,
        );
        break ;
      case _PackageType.multipleEqual:
        final amountList = List.generate(ecashCount, (index) => amount);
        await createEcashForMultipleType(
          mint,
          amountList,
          signees,
          validityDate,
        );
      case _PackageType.exclusive:
        await createEcashForExclusiveType(
          mint,
          amount,
          receiver,
          signees,
          validityDate,
        );
        break ;
    }
  }

  Future createEcashForSingleType(
    IMint mint,
    int amount,
    int? lockTime,
  ) async {
    final refundPubkey = condition.refundPubkey ?? '';
    if (refundPubkey.isEmpty) return CashuResponse.fromErrorMsg('ecash_refund_pubkey_empty_hint'.localized());

    final singleReceiver = widget.singleReceiver;
    if (singleReceiver == null) return CashuResponse.fromErrorMsg('ecash_receiver_pubkey_empty_hint'.localized());

    final currentUser = OXUserInfoManager.sharedInstance.currentUserInfo;
    if (currentUser == null) return CashuResponse.fromErrorMsg('ecash_not_login_hint'.localized());

    OXLoading.show();
    final response = await Cashu.sendEcashToPublicKeys(
      mint: mint,
      amount: amount,
      publicKeys: [
        EcashCondition.pubkeyWithUser(singleReceiver),
        if (lockTime == null)
          EcashCondition.pubkeyWithUser(currentUser)
      ],
      refundPubKeys: [refundPubkey],
      memo: ecashDescription,
      locktime: lockTime,
    );
    OXLoading.dismiss();

    if (OXWalletInterface.checkAndShowDialog(context, response, mint)) return ;
    if (!response.isSuccess) {
      CommonToast.instance.show(context, response.errorMsg);
      return ;
    }

    widget.ecashInfoCallback((
      [response.data],
      [],
      [],
      lockTime.toString(),
    ));
  }

  Future createEcashForMultipleType(
    IMint mint,
    List<int> amountList,
    List<UserDBISAR> signee,
    int? lockTime,
  ) async {

    final signeePubkey = signee.map((user) => EcashCondition.pubkeyWithUser(user)).toList();

    final refundPubkey = condition.refundPubkey ?? '';
    if (signeePubkey.isNotEmpty && refundPubkey.isEmpty) return CashuResponse.fromErrorMsg('ecash_refund_pubkey_empty_hint'.localized());

    OXLoading.show();
    final response = await Cashu.sendEcashList(
      mint: mint,
      amountList: amountList,
      publicKeys: signeePubkey,
      refundPubKeys: [refundPubkey],
      locktime: lockTime,
      signNumRequired: signeePubkey.length,
      memo: ecashDescription,
    );
    OXLoading.dismiss();

    if (OXWalletInterface.checkAndShowDialog(context, response, mint)) return ;
    if (!response.isSuccess) {
      CommonToast.instance.show(context, response.errorMsg);
      return ;
    }

    widget.ecashInfoCallback((
      response.data,
      [],
      signee.map((user) => user.pubKey).toList(),
      lockTime.toString(),
    ));
  }

  Future createEcashForExclusiveType(
    IMint mint,
    int amount,
    List<UserDBISAR> receiver,
    List<UserDBISAR> signee,
    int? lockTime,
  ) async {
    final refundPubkey = condition.refundPubkey ?? '';
    if (refundPubkey.isEmpty) return CashuResponse.fromErrorMsg('ecash_refund_pubkey_empty_hint'.localized());

    final receiverPubkey = receiver.map((user) => EcashCondition.pubkeyWithUser(user)).toList();
    if (receiverPubkey.isEmpty) return CashuResponse.fromErrorMsg('ecash_recipient_unselected_hint'.localized());

    final signeePubkey = signee.map((user) => EcashCondition.pubkeyWithUser(user)).toList();

    OXLoading.show();
    final response = await Cashu.sendEcashToPublicKeys(
      mint: mint,
      amount: amount,
      publicKeys: [...receiverPubkey, ...signeePubkey],
      refundPubKeys: [refundPubkey],
      locktime: lockTime,
      signNumRequired: signeePubkey.length + 1,
      memo: ecashDescription,
    );
    OXLoading.dismiss();

    if (OXWalletInterface.checkAndShowDialog(context, response, mint)) return ;
    if (!response.isSuccess) {
      CommonToast.instance.show(context, response.errorMsg);
      return ;
    }

    widget.ecashInfoCallback((
      [response.data],
      receiver.map((user) => user.pubKey).toList(),
      signee.map((user) => user.pubKey).toList(),
      lockTime.toString(),
    ));
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

  String get receiverText => condition.receiver.abbrDesc();
  String get signessText => condition.signees.abbrDesc(noneText: Localized.text('ox_common.none'));
}
