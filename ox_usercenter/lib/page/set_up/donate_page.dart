import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox_common/const/common_constant.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/platform_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';
import 'package:ox_usercenter/model/product_list_entity.dart';
import 'package:ox_usercenter/page/set_up/profile_set_up_page.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_usercenter/utils/purchase_util.dart';
import 'package:ox_usercenter/utils/zaps_helper.dart';
import 'package:ox_usercenter/widget/donate_selected_list.dart';
import 'package:ox_usercenter/widget/donate_item_widget.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:ox_common/utils/in_app_purchase_verification_ios.dart';

///Title: donate_page
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/5/11 16:14
class DonatePage extends StatefulWidget {
  const DonatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DonatePageState();
  }
}

class _DonatePageState extends State<DonatePage> {
  List<DonateItem> donateItems = [];

  UserDBISAR? _mCurrentUserInfo;
  String _invoice = '';
  int _selectIndex = 1;
  final TextEditingController _customStasTextController = TextEditingController();
  final FocusNode _customStasTextFocusNode = FocusNode();
  bool _isAppleOrGooglePay = false;
  List<ProductEntity>? _productList;
  ProductEntity? _clickProductEntity;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails>? _productDetails;

  final badgeIconNameList = {
    '00003f2b93a5a3888fff0d251d270ca82f757a0d5efd556070a036ca8be8e820': 'badge_level_1.png',
    '00000f0951248ace7d69be0ed136a069f1d1021443b03e81ffbabda4e53bda9e': 'badge_level_2.png',
    '00002295d1ef76eee9a8d8d04cb2009483acedb452814e040a949555210f928e': 'badge_level_3.png',
    '00001e93260c429660e39abd7cec733f9f3d9278bb7b2bbd8a3fff98d94a02bb': 'badge_level_4.png',
    '00000f7a835198691c5cd6f024fdfcf2ab82ef147160bf966ba5706271baa003': 'badge_level_5.png',
    '000001a0ec0e7908caed173a82f68e93f8d791f7a045da0bf622c7bee0b72dee': 'badge_level_6.png',
  };

  @override
  void initState() {
    super.initState();
    _customStasTextFocusNode.addListener(() {
      if (_customStasTextFocusNode.hasFocus) {
        setState(() {
          _selectIndex = -1;
        });
      }
    });
    if(Platform.isIOS || Platform.isMacOS) { // donate on Android do not through GPay
      final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
      _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        LogUtil.e('error: onDone');
        _subscription.cancel();
      }, onError: (Object error) {
        // handle error here.
        LogUtil.e('error: ${error.toString()}');
      });
    }
    _initData();
  }

  void _initData() async {
    _mCurrentUserInfo = OXUserInfoManager.sharedInstance.currentUserInfo;
    _isAppleOrGooglePay = Platform.isIOS || Platform.isMacOS;
    if (!_isAppleOrGooglePay) {
      _setSatsData();
    }
    if (Platform.isIOS || Platform.isMacOS) _requestData();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();

    if (!isAvailable) {
      CommonToast.instance.show(context, Localized.text("ox_usercenter.in_app_purchases_no_available"));
      LogUtil.e('IAPError ====== !isAvailable');
      return;
    }

    bool isVerification = await handleLocalValidation();
    if (isVerification) {
      OXCommonHintDialog.show(context, title: Localized.text('ox_usercenter.unfinished_order_sos'), actionList: [
        OXCommonHintAction.sure(
            text: Localized.text('ox_usercenter.next_step'),
            onTap: () async {
              OXNavigator.pop(context);
              final verificationData = await getLocalVerificationData();
              updateSats(verificationData!);
            }),
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context);
        }),
      ]);
    }

    if (Platform.isIOS || Platform.isMacOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }
    if (_productList != null && _productList!.isNotEmpty) {
      Set<String> _kIds = {};
      for (var element in _productList!) {
        if ((Platform.isIOS || Platform.isMacOS) && element.inPurchasingIdIos != null) {
          _kIds.add(element.inPurchasingIdIos!);
        } else if (Platform.isAndroid && element.inPurchasingIdAndroid != null) {
          _kIds.add(element.inPurchasingIdAndroid!);
        }
      }
      final ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_kIds);
      if(!mounted) return;
      if (productDetailResponse.error != null) {
        print('[IAP Error] ${productDetailResponse.error}');
        setState(() {});
        return;
      }
      if (productDetailResponse.productDetails.isEmpty) {
        setState(() {});
        return;
      }
      _productDetails = productDetailResponse.productDetails;
      print('[IAP Info] Product details: ${_productDetails?.map((e) => 'id: ${e.id}, title: ${e.title}').join(';')}');
      setState(() {});
    }
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (OXLoading.isShow){
          await OXLoading.dismiss();
        }
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          deliverProduct(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          //cancel purchase
          if (purchaseDetails.productID == _clickProductEntity?.inPurchasingIdIos) {
            await _inAppPurchase.completePurchase(purchaseDetails);
            CommonToast.instance.show(context, Localized.text("ox_usercenter.cancel_purchase"));
          }
        }
        if (Platform.isAndroid) {
          if (purchaseDetails.productID == _clickProductEntity?.inPurchasingIdAndroid) {
            final InAppPurchaseAndroidPlatformAddition androidAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void handleError(IAPError error) {
    LogUtil.e('Michael: error =${error.toString()}');
    setState(() {
      // _purchasePending = false;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _clickProductEntity?.inPurchasingIdIos) {
      saveVerificationData(purchaseDetails.verificationData.localVerificationData);
      updateSats(purchaseDetails.verificationData.localVerificationData);
      setState(() {});
    } else {
      setState(() {});
    }
  }

  ///Go to the sever and revalidate the purchase
  void updateSats(String receiptData) async {
    final donateProductId = Platform.isAndroid ? _clickProductEntity?.inPurchasingIdAndroid : _clickProductEntity?.inPurchasingIdIos;
    Map<String, dynamic> dataMap = {
      "receiptData":receiptData,
      "pubKey": OXUserInfoManager.sharedInstance.currentUserInfo?.pubKey,
      "osType": Platform.isAndroid ?  0 : 1,
      "donateProductId": donateProductId,
      "validationType": 2, //2:donate
    };
    final bool payResult = await PurchaseUtil.validationPay(context: context, dataMap: dataMap);
    if(payResult){
      removeVerificationData();
      CommonToast.instance.show(context, Localized.text("ox_usercenter.purchase_success"));
    } else {
      CommonToast.instance.show(context, Localized.text("ox_usercenter.purchase_successful"));
    }
  }

  void _setSatsData() {
    donateItems = [
      DonateItem('2.1k Sats', 'Unlock the Egg Badge', 2100, 'badge_level_1.png'),
      DonateItem('4.2k Sats', 'Unlock the Hatching Badge', 4200, 'badge_level_2.png', flag: true),
      DonateItem('21k Sats', 'Unlock the Chick Badge', 21000, 'badge_level_3.png'),
      DonateItem('42k Sats', 'Unlock the Adolescent Badge', 42000, 'badge_level_4.png'),
      DonateItem('210k Sats', 'Unlock the Mature Badge', 210000, 'badge_level_5.png'),
      DonateItem('420k Sats', 'Unlock the Geeky Badge', 420000, 'badge_level_6.png'),
    ];
    setState(() {});
  }

  Future<void> _requestData() async {
    if (_mCurrentUserInfo == null) return;
    _productList = await PurchaseUtil.getProductList(pubKey: _mCurrentUserInfo!.pubKey);
    LogUtil.e("Michael: server myProductListEntity :${_productList?.toString()}");
    initStoreInfo();
    if (_isAppleOrGooglePay) {
      _setThirdPay();
    }
  }

  void _setThirdPay() {
    if (_productList != null && _productList!.isNotEmpty) {
      donateItems.clear();
      _isAppleOrGooglePay = true;
      int index = 0;
      for (var element in _productList!) {
        final title = element.title ?? '';
        final iconName = badgeIconNameList[element.badgeId] ?? 'badge_level_1.png';
        final description = element.description ?? '';
        final price = element.price ?? 0;
        donateItems.add(
          DonateItem(title, description, price, iconName, flag: index == 1? true:false),
        );
        index++;
      }
      _selectIndex = 1;
      setState(() {});
    } else {
      CommonToast.instance.show(context, Localized.text('ox_usercenter.str_network_error_try_later'));
    }
  }

  void _switchPay() {
    if (_isAppleOrGooglePay) {
      _isAppleOrGooglePay = false;
      _setSatsData();
    } else {
      _setThirdPay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        centerTitle: true,
        useLargeTitle: false,
        titleTextColor: ThemeColor.color0,
        backgroundColor: ThemeColor.color200,
        actions: Platform.isAndroid || Platform.isMacOS ? null : [
           OXButton(
            highlightColor: Colors.transparent,
            color: Colors.transparent,
            disabledColor: Colors.transparent,
            child: CommonImage(
              iconName: _isAppleOrGooglePay ? 'icon_pay_channel_sats.png' : (Platform.isAndroid ? 'icon_pay_channel_google.png':'icon_pay_channel_apple.png'),
              width: Adapt.px(40),
              height: Adapt.px(26),
              fit: BoxFit.cover,
              package: 'ox_usercenter',
              useTheme: true,
            ),
            onPressed: () {
              _switchPay();
            },
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: PlatformUtils.listWidth,
                ),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CommonImage(
                      iconName: 'logo_icon.png',
                      width: Adapt.px(180),
                      height: Adapt.px(180),
                      useTheme: true,
                    ),
                    Text(
                      Localized.text('ox_usercenter.donate_tips'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Adapt.px(16),
                        fontWeight: FontWeight.w400,
                        color: ThemeColor.color0,
                      ),
                    ),
                    SizedBox(
                      height: Adapt.px(24),
                    ),
                    DonateSelectedList(
                      title: Localized.text('ox_usercenter.donate_title'),
                      customStasInputBox: Platform.isAndroid ? _buildCustomSatsItem() : null,
                      item: _buildDonateItem(),
                      currentIndex: _selectIndex,
                      onSelected: (index) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _customStasTextController.text = donateItems[index].sats.toString();
                        setState(() {
                          _selectIndex = index;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _buildBottomWidget(),
      ],
    );
  }

  List<Widget> _buildDonateItem() => donateItems
      .map(
        (element) => DonateItemWidget(
          title: element.title,
          subTitle: element.description,
          leading: CommonImage(
            iconName: element.imagePath,
            height: Adapt.px(44),
            width: Adapt.px(44),
            fit: BoxFit.contain,
            package: 'ox_usercenter',
          ),
          flagWidget: element.flag != null
              ? element.flag!
                  ? CommonImage(
                      iconName: 'icon_donate_most.png',
                      height: Adapt.px(17),
                      width: Adapt.px(36),
                      fit: BoxFit.contain,
                      package: 'ox_usercenter',
                    )
                  : null
              : null,
        ),
      )
      .toList();

  Widget _buildBottomWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(24.px),
      decoration: BoxDecoration(
          color: ThemeColor.color190,
          border: Border(
              top: BorderSide(
            width: Adapt.px(0.5),
            color: ThemeColor.color160,
          ))),
      child: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            try {
              if (_isAppleOrGooglePay) {
                _buyConsumable();
              } else {
                if (_selectIndex == -1 && _customStasTextController.text.isEmpty) {
                  CommonToast.instance.show(context, Localized.text('ox_usercenter.str_manual_donation_tip'));
                  return;
                } else if (_selectIndex == -1 && _customStasTextController.text.isNotEmpty) {
                  await _getInvoice(double.parse(_customStasTextController.text).toInt());
                } else {
                  await _getInvoice(donateItems[_selectIndex].sats);
                }
                await OXModuleService.pushPage(context, 'ox_usercenter', 'ZapsInvoiceDialog', {'invoice':_invoice});
              }
            } catch (error) {
              return;
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: Adapt.px(48),
            decoration: BoxDecoration(
                color: ThemeColor.color180,
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    ThemeColor.gradientMainEnd,
                    ThemeColor.gradientMainStart,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
            child: Text(
              Localized.text('ox_usercenter.donate'),
              style: TextStyle(fontSize: Adapt.px(16), fontWeight: FontWeight.w600, color: ThemeColor.color0),
            ),
          ),
        ),
      ),
    );
  }

  // 06/25 add new product requirements
  Widget _buildCustomSatsItem() {
    return Container(
      height: Adapt.px(60),
      width: MediaQuery.of(context).size.width - Adapt.px(24 * 2),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(16), vertical: Adapt.px(8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color: ThemeColor.color180,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CommonImage(
            iconName: 'icon_donate_custom_sats.png',
            height: Adapt.px(44),
            width: Adapt.px(44),
            fit: BoxFit.contain,
            package: 'ox_usercenter',
          ),
          SizedBox(
            width: Adapt.px(12),
          ),
          Expanded(
            child: TextField(
              controller: _customStasTextController,
              focusNode: _customStasTextFocusNode,
              decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(fontSize: Adapt.px(18), fontWeight: FontWeight.w600, color: ThemeColor.color100),
                  border: InputBorder.none),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          Text(
            'Sats',
            style: TextStyle(color: ThemeColor.color0, fontSize: Adapt.px(18)),
          ),
        ],
      ),
    );
  }

  Future<void> _getInvoice(num sats) async {

    String recipient = CommonConstant.serverPubkey;

    // String lnurl = _mCurrentUserInfo?.lnurl ?? '';
    // Test code
    String lnurl = '0xchat@getalby.com';

    if (lnurl.isEmpty) {
      // CommonToast.instance.show(context, 'Please set the LN Address or LNURL');
      OXCommonHintDialog.show(context,
          title: 'Tips',
          content: 'Please set the LN Address or LNURL',
          actionList: [
            OXCommonHintAction.cancel(onTap: () {
              OXNavigator.pop(context);
            }),
            OXCommonHintAction.sure(
                text: 'Go to Settings',
                onTap: () async {
                  OXNavigator.pop(context);
                  OXNavigator.pushPage(context, (context) => const ProfileSetUpPage());
                }),
          ],
          isRowAction: true);
      throw 'The LN Address or LNURL is not set';
    }

    OXLoading.show();
    final result = await ZapsHelper.getInvoice(
      sats: sats.toInt(),
      recipient: CommonConstant.serverPubkey,
      otherLnurl: '0xchat@getalby.com',
      zapType: ZapType.donate,
    );
    final invoice = result['invoice'] ?? '';
    final message = result['message'] ?? '';
    if (invoice.isNotEmpty) {
      _invoice = invoice;
    } else {
      CommonToast.instance.show(context, message);
    }
    OXLoading.dismiss();
  }

  void _buyConsumable() async {
    if (_productDetails == null) {
      CommonToast.instance.show(context, Localized.text('ox_usercenter.str_anomaly_retrieving_payment_bill'));
      return;
    }
    if (_productList == null || _productList!.length < _selectIndex) {
      CommonToast.instance.show(context, Localized.text('ox_usercenter.str_payment_anomaly_use_sats'));
      return;
    }
    _clickProductEntity = _productList![_selectIndex];
    String consumableId = '';
    if ((Platform.isIOS || Platform.isMacOS) && _clickProductEntity!.inPurchasingIdIos != null) {
      consumableId = _clickProductEntity!.inPurchasingIdIos!;
    } else if (Platform.isAndroid && _clickProductEntity!.inPurchasingIdAndroid != null) {
      consumableId = _clickProductEntity!.inPurchasingIdAndroid!;
    } else {
      CommonToast.instance.show(context, Localized.text('ox_usercenter.str_payment_anomaly_use_sats'));
      return;
    }
    await OXLoading.show(status: Localized.text('ox_usercenter.buy_not_leave'));
    if (_productList!.length > _selectIndex) {
      Set<String> _kIds = <String>{consumableId};
      final ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_kIds);
      if (productDetailResponse.error != null) {
        await OXLoading.dismiss();
        print('[IAP Error] error: ${productDetailResponse.error}');
        return;
      }
      if (productDetailResponse.notFoundIDs.isNotEmpty) {
        // Handle the error.
        await OXLoading.dismiss();
        print('[IAP Error] isNotEmpty: ${productDetailResponse.notFoundIDs}');
        return;
      }
      if (productDetailResponse.productDetails.isEmpty) {
        await OXLoading.dismiss();
        print('[IAP Error] Product details is empty');
        return;
      }
      _inAppPurchase.buyConsumable(purchaseParam: PurchaseParam(productDetails: productDetailResponse.productDetails.first));
    } else {
      ProductDetails? buyProductDetails = _productDetails![_selectIndex];
      _inAppPurchase.buyConsumable(purchaseParam: PurchaseParam(productDetails: buyProductDetails));
    }
  }
}

class DonateItem {
  final String title;
  final String description;
  final num sats;
  final String imagePath;
  final bool? flag;

  DonateItem(this.title, this.description, this.sats, this.imagePath, {this.flag});
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
