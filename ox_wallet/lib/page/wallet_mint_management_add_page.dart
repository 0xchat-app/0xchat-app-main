import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/page/wallet_mint_list_page.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/common_card.dart';

enum  ImportAction{
  import,
  add
}

class WalletMintManagementAddPage extends StatefulWidget {
  final ImportAction action;
  final VoidCallback? callback;
  const WalletMintManagementAddPage({super.key, ImportAction? action, this.callback}):action = action ?? ImportAction.add;

  @override
  State<WalletMintManagementAddPage> createState() => _WalletMintManagementAddPageState();
}

class _WalletMintManagementAddPageState extends State<WalletMintManagementAddPage> {

  final TextEditingController _controller = TextEditingController();
  bool _enable = false;
  
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _enable = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: widget.action == ImportAction.add ? 'Add a new mint' : '',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.action == ImportAction.add ? SizedBox(height: 12.px,) : SizedBox(height: 100.px,child: Center(child: _buildText('Add a new mint'),),),
          CommonCard(
            radius: 12.px,
            verticalPadding: 12.px,
            horizontalPadding: 16.px,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Mint URL',
                          hintStyle: TextStyle(fontSize: 16.px,height: 22.px / 16.px),
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        controller: _controller,
                        maxLines: 1,
                        showCursor: true,
                        style: TextStyle(fontSize: 16.px,height: 22.px / 16.px,color: ThemeColor.color0),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.px),
                GestureDetector(
                  onTap: (){
                    WalletUtils.gotoScan(context, (result) => _controller.text = result);
                  },
                  child: CommonImage(
                    iconName: 'icon_send_qrcode.png',
                    size: 24.px,
                    package: 'ox_wallet',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: widget.action == ImportAction.add ? 24.px : 30.px),
          ThemeButton(text: widget.action == ImportAction.add ? 'Add' : 'Import',height: 48.px,enable: _enable, onTap: _addMint),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px))
    );
  }

  Widget _buildText(String text){
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            ThemeColor.gradientMainEnd,
            ThemeColor.gradientMainStart,
          ],
        ).createShader(Offset.zero & bounds.size);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 32.px,
          fontWeight: FontWeight.w700,
          // color:
        ),
      ),
    );
  }

  void _addMint() {
    OXLoading.show();
    EcashService.addMint(_controller.text).then((mint) {
      OXLoading.dismiss();
      if (mint != null) {
        CommonToast.instance.show(context, 'Add Mint Successful');
        if(widget.callback != null) {
          widget.callback!.call();
          return;
        }
        OXNavigator.pushPage(context, (context) => const WalletMintListPage());
      } else {
        CommonToast.instance.show(context, 'Add Mint Failed, Please try again.');
      }
    },onError: (e){
      OXLoading.dismiss();
      CommonToast.instance.show(context, 'invalid mint url');
    });
  }
}
