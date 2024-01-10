import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_hint_dialog.dart';
import 'package:ox_wallet/widget/ecash_qr_code.dart';

class EcashDialogHelper {
  static showMintQrCode(BuildContext context,ValueNotifier<String> data){
    OXCommonHintDialog.show(context, contentView:EcashQrCode(controller: data), actionList: []);
  }

  static showEditMintName(BuildContext context){
    OXCommonHintDialog.show(context,
      contentView: Column(
        children: [
          Text(
            'Edit mint name',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColor.color0,
              fontSize: 16.px,
              fontWeight: FontWeight.w400,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.px,),
            height: 42.px,
            decoration: BoxDecoration(
              color: ThemeColor.color190,
              borderRadius: BorderRadius.circular(12.px)
            ),
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: ThemeColor.color100,
                  fontSize: 15.px,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.px,horizontal: 16.px),
                border: InputBorder.none
              ),
            ),
          ),
        ],
      ),
      actionList: [
        OXCommonHintAction.cancel(onTap: () {
          OXNavigator.pop(context);
        }),
        OXCommonHintAction.sure(text: 'Send', onTap: ()=>{}),
      ],
      isRowAction: true,
    );
  }
}
