import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/widget/common_card.dart';

class WalletMintInfo extends StatefulWidget {
  final IMintIsar mint;
  const WalletMintInfo({super.key, required this.mint});

  @override
  State<WalletMintInfo> createState() => _WalletMintInfoState();
}

class _WalletMintInfoState extends State<WalletMintInfo> {

  MintInfoIsar? mintInfo;

  @override
  void initState() {
    super.initState();
    mintInfo = widget.mint.info;
    EcashService.fetchMintInfo(widget.mint).then((success) {
      if (success) {
        setState(() {
          mintInfo = widget.mint.info;
        });
      }
    });
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            CommonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(mintInfo?.name ?? '',style: TextStyle(color: ThemeColor.color0,fontSize: 24.px,),),
                  SizedBox(height: 4.px,),
                  Text('Version: ${mintInfo?.version ?? ''}',style: TextStyle(color: ThemeColor.color100,fontSize: 12.px,),),
                  Text(mintInfo?.description ?? '',style: TextStyle(color: ThemeColor.color100,fontSize: 12.px,),),
                ],
              ),
            ),
            _buildItem(
              title: 'Contact',
              content: mintInfo?.contact
                  .map((entry) {
                    entry = entry.where((e) => e.isNotEmpty).toList();
                    if (entry.length < 2) return '';

                    final key = entry.removeAt(0);
                    return '$key: ${entry.join(', ')}';
                  })
                  .where((str) => str.isNotEmpty)
                  .join('\n'),
            ).setPaddingOnly(top: 24.px),
            _buildItem(
              title: 'Supported NUTs',
              content: mintInfo?.nutsInfo
                  .where((nutInfo) => !NutsSupportInfo.mandatoryNut.contains(nutInfo.nutNum))
                  .map((nutInfo) => 'NUT - ${nutInfo.nutNum.toString().padLeft(2, '0')}')
                  .join('\n'),
            ).setPaddingOnly(top: 24.px),
            _buildItem(title: 'Public Key',content: mintInfo?.pubkey).setPaddingOnly(top: 24.px),
            _buildItem(title: 'Additional Information',content: mintInfo?.description).setPaddingOnly(top: 24.px),
          ],
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
      ),
    );
  }

  Widget _buildItem({String? title, String? content}){
    return CommonCard(
      verticalPadding: 15.px,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? '',style: TextStyle(fontSize: 14.px,height: 22.px / 14.px),),
          SizedBox(height: 4.px,),
          Text(
            '${(content?.isEmpty ?? true) ? '-' : content}',
            style: TextStyle(
              fontSize: 12.px,
              height: 1.6,
              color: ThemeColor.color0,
            ),
          ),
        ],
      ),
    );
  }
}
