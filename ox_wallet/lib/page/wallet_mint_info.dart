import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/widget/common_card.dart';

class WalletMintInfo extends StatefulWidget {
  final MintInfo? mintInfo;
  const WalletMintInfo({super.key, this.mintInfo});

  @override
  State<WalletMintInfo> createState() => _WalletMintInfoState();
}

class _WalletMintInfoState extends State<WalletMintInfo> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: 'Mint Info',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: Column(
        children: [
          CommonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.mintInfo?.name ?? '',style: TextStyle(color: ThemeColor.color0,fontSize: 24.px,),),
                SizedBox(height: 4.px,),
                Text('Version: ${widget.mintInfo?.version ?? ''}',style: TextStyle(color: ThemeColor.color100,fontSize: 12.px,),),
                Text(widget.mintInfo?.description ?? '',style: TextStyle(color: ThemeColor.color100,fontSize: 12.px,),),
              ],
            ),
          ),
          _buildItem(title: 'Contact',content: '').setPaddingOnly(top: 24.px),
          _buildItem(title: 'Supported NUTs',content: widget.mintInfo?.nutsJson ?? '').setPaddingOnly(top: 24.px),
          _buildItem(title: 'Public Key',content: widget.mintInfo?.pubkey ?? '').setPaddingOnly(top: 24.px),
          _buildItem(title: 'Additional Information',content: widget.mintInfo?.descriptionLong ?? '').setPaddingOnly(top: 24.px),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
    );
  }

  Widget _buildItem({required String title,required String content}){
    return CommonCard(
      verticalPadding: 15.px,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: TextStyle(fontSize: 14.px,height: 22.px / 14.px),),
          SizedBox(height: 4.px,),
          Text(content,style: TextStyle(fontSize: 12.px,height: 17.px / 12.px,color: ThemeColor.color0),),
        ],
      ),
    );
  }
}
