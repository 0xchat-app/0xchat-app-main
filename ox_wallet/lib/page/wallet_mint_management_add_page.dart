import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/file_utils.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';

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
  bool get isAddAction => widget.action == ImportAction.add;
  
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
        title: '',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 100.px,child: Center(child: _buildText(isAddAction ? 'Add a new mint' : 'Import wallet'),),),
          isAddAction ? CommonLabeledCard.textFieldAndScan(
            hintText: 'Mint URL',
            controller: _controller,
            onTap: () => WalletUtils.gotoScan(context, (result) => _controller.text = result),
          ) : CommonLabeledCard.textFieldAndImportFile(
            hintText: 'Enter Restore Public Key',
            controller: _controller,
            onTap: _importTokenFile,
          ),
          SizedBox(height: 30.px,),
          ThemeButton(text: isAddAction ? 'Add' : 'Import',height: 48.px,enable: _enable, onTap: isAddAction ? _addMint : _importWallet),
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
          height: 44.px / 32.px
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
        if(widget.action == ImportAction.add){
          OXNavigator.pop(context,true);
        }else{
          EcashManager.shared.setWalletAvailable();
          widget.callback?.call();
        }
      } else {
        CommonToast.instance.show(context, 'Add Mint Failed, Please try again.');
      }
    },onError: (e){
      OXLoading.dismiss();
      CommonToast.instance.show(context, 'invalid mint url');
    });
  }

  void _importTokenFile() async {
    try {
      final file = await FileUtils.importFile();
      if (file == null) return;
      final token = await file.readAsString();
      _controller.text = token;
    } catch (e) {
      _showToast('Please import the correct backup file.');
    }
  }

  Future<void> _importWallet() async {
    if(!EcashService.isCashuToken(_controller.text)){
      _showToast('Invalid Cashu Token');
      return;
    }
    OXLoading.show();
    final response = await EcashService.redeemEcash(_controller.text);
    OXLoading.dismiss();
    final message = response.isSuccess ? 'Import Wallet successful' : response.errorMsg;
    if (context.mounted) OXNavigator.pop(context,true);
    _showToast(message);
  }

  void _showToast(String message) {
    if (context.mounted) CommonToast.instance.show(context, message);
  }
}
