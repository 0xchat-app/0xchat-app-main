
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:ox_chat/manager/chat_data_cache.dart';
import 'package:ox_chat/manager/chat_message_helper.dart';
import 'package:ox_chat/manager/ecash_helper.dart';
import 'package:ox_chat/page/ecash/ecash_info.dart';
import 'package:ox_chat/utils/custom_message_utils.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/future_extension.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';

import 'ecash_detail_page.dart';

class EcashOpenDialog extends StatefulWidget {
  EcashOpenDialog({
    required this.package,
  });

  final EcashPackage package;

  @override
  State<StatefulWidget> createState() => EcashOpenDialogState();

  static Future<bool?> show(
    BuildContext context,
    EcashPackage package,
  ) {
    return OXNavigator.pushPage<bool>(
      context,
      (context) => EcashOpenDialog(package: package),
      type: OXPushPageType.transparent,
    );
  }
}

class EcashOpenDialogState extends State<EcashOpenDialog> with SingleTickerProviderStateMixin {

  String ownerName = '';
  bool isRedeemed = false;

  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    prepareAnimation();
    isRedeemed = widget.package.isRedeemed;
    Account.sharedInstance.getUserInfo(widget.package.senderPubKey).handle((user) {
      setState(() {
        ownerName = user?.getUserShowName() ?? 'anonymity';
      });
    });
    animationController.forward(from: 0);
  }

  prepareAnimation() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    scaleAnimation = CurvedAnimation(
      parent: animationController,
      curve: ElasticOutCurve(0.8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: popAction,
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: GestureDetector(
            onTap: () { },
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Card(
                color: Color(0xFF7F38CA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: 280.px,
                  padding: EdgeInsets.symmetric(horizontal: 20.px),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildTitle().setPaddingOnly(top: 60.px),
                      buildSubtitle().setPaddingOnly(top: 4.px),
                      buildIcon().setPaddingOnly(top: 40.px),
                      buildRedeemButton().setPaddingOnly(top: 47.px),
                      buildViewDetailButton().setPaddingOnly(top: 12.px),
                      buildBottomView().setPaddingOnly(top: 12.px),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      widget.package.memo,
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    );
  }

  Widget buildSubtitle() {
    return Text(
      '$ownerName\'s Ecash',
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        height: 1.4,
      ),
    );
  }

  Widget buildIcon() {
    return CommonImage(
      height: 100.px,
      width: 88.px,
      iconName: "icon_cashu_nut.png",
      package: 'ox_chat',
    );
  }

  Widget buildRedeemButton() {
    return Opacity(
      opacity: isRedeemed ? 0.4 : 1,
      child: GestureDetector(
        onTap: redeemPackage,
        child: Container(
          height: 44.px,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.px),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              isRedeemed ? 'Redeemed' : 'Redeem',
              style: TextStyle(
                color: ThemeColor.darkColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildViewDetailButton() {
    return GestureDetector(
      onTap: jumpToDetailPage,
      child: Text(
        'view detail',
        style: TextStyle(
          color: Colors.white,
          decoration: TextDecoration.underline,
          fontSize: 12.sp,
          height: 1.4,
        ),
      ),
    );
  }

  Widget buildBottomView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(height: 0.5, color: Colors.white.withOpacity(0.4),),
        Container(
          height: 33.px,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cashu Token',
                style: TextStyle(
                  color: ThemeColor.white,
                  fontSize: 12.sp,
                ),
              ),
              CommonImage(
                iconName: 'icon_zaps_0xchat.png',
                package: 'ox_chat',
                size: Adapt.px(16),
              ),
            ],
          ),
        )
      ],
    );
  }

  void popAction() {
    OXNavigator.pop(context);
  }

  void jumpToDetailPage() async {
    popAction();
    final isAllReceive = widget.package.tokenInfoList
        .every((info) => info.redeemHistory != null);
    if (!isAllReceive) {
      OXLoading.show();
      await EcashHelper.updateReceiptHistoryForPackage(widget.package);
      OXLoading.dismiss();
    } else {
      updateMessageToRedeemedState(widget.package.messageId);
    }
    OXNavigator.pushPage(null, (context) => EcashDetailPage(
      package: widget.package,
    ));
  }

  void redeemPackage() async {
    if (isRedeemed) return ;

    OXLoading.show();
    final success = await EcashHelper.tryRedeemTokenList(widget.package);
    OXLoading.dismiss();
    if (success == null) {
      CommonToast.instance.show(context, 'Redeem Failed, Please try again.');
      setState(() {
        isRedeemed = widget.package.isRedeemed;
      });
      return ;
    }
    if (success) {
      jumpToDetailPage();
    } else {
      CommonToast.instance.show(context, 'All tokens already spent.');
      setState(() {
        isRedeemed = widget.package.isRedeemed;
      });
    }

    updateMessageToRedeemedState(widget.package.messageId);
  }

  Future updateMessageToRedeemedState(String messageId) async {
    final messages = await Messages.loadMessagesFromDB(where: 'messageId = ?', whereArgs: [messageId]);
    final messageDB = (messages['messages'] as List<MessageDB>).firstOrNull;
    if (messageDB != null) {
      final chatKey = ChatDataCacheGeneralMethodEx.getChatTypeKeyWithMessage(messageDB);
      final uiMessage = await ChatDataCache.shared.getMessage(
        chatKey,
        null,
        messageId,
      );
      if (uiMessage is types.CustomMessage) {
        EcashMessageEx(uiMessage).isOpened = true;
        messageDB.decryptContent = jsonEncode(uiMessage.metadata);
        await DB.sharedInstance.update(messageDB);
        await ChatDataCache.shared.updateMessage(chatKey: chatKey, message: uiMessage);
      }
    }
  }

}
