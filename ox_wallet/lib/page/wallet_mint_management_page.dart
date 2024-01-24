import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_common/widgets/common_toast.dart';
import 'package:ox_wallet/page/wallet_backup_funds_page.dart';
import 'package:ox_wallet/page/wallet_mint_info.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:ox_wallet/services/ecash_service.dart';
import 'package:ox_wallet/utils/wallet_utils.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:ox_wallet/utils/ecash_dialog_helper.dart';
import 'package:ox_wallet/widget/common_labeled_item.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/widget/common_modal_bottom_sheet_widget.dart';

class WalletMintManagementPage extends StatefulWidget {
  final IMint mint;
  const WalletMintManagementPage({super.key, required this.mint});

  @override
  State<WalletMintManagementPage> createState() => _WalletMintManagementPageState();
}

class _WalletMintManagementPageState extends State<WalletMintManagementPage> {

  List<StepItemModel> _generalList = [];
  List<StepItemModel> _dangerZoneList = [];
  final List<StepItemModel> _fundList = [];
  Map<String,List<StepItemModel>> _labelItems = {};
  late ValueNotifier<String> _mintQrCode;
  TextEditingController? _customNameEditController;
  late bool _isDefaultMint;

  @override
  void initState() {
    _isDefaultMint = EcashManager.shared.isDefaultMint(widget.mint);
    final mintURL = WalletUtils.formatString(widget.mint.mintURL, 40, 20, 10);
    _generalList = [
      StepItemModel(title: 'Mint',content: mintURL),
      StepItemModel(title: 'Balance',content: '${widget.mint.balance} Sats'),
      StepItemModel(title: 'Show QR code',onTap: (value) => EcashDialogHelper.showMintQrCode(context, _mintQrCode)),
      StepItemModel(title: 'Custom name',badge: widget.mint.name,onTap: _editMintName),
      StepItemModel(title: _isDefaultMint ? 'Remove from Default' : 'Set as default mint',onTap: _handleDefaultMint),
      StepItemModel(title: 'More Info', onTap: (value) => OXNavigator.pushPage(context, (context) => WalletMintInfo(mintInfo: widget.mint.info,))),
    ];
    _dangerZoneList = [
      StepItemModel(title: 'Check proofs',onTap: (value) => EcashDialogHelper.showCheckProofs(context,onConfirmTap: _checkProofs)),
      StepItemModel(title: 'Delete mint',onTap: (value) => ShowModalBottomSheet.showConfirmBottomSheet(context,title: 'Delete mint?',confirmCallback:_deleteMint)),
    ];
    if(widget.mint.balance > 0) _fundList.add(StepItemModel(title: 'Backup funds', onTap: (value) => OXNavigator.pushPage(context, (context) => WalletBackupFundsPage(mint: widget.mint,))));
    _labelItems = {
      'GENERAL' : _generalList,
      'Funds' : _fundList,
      'DANGER ZONE' : _dangerZoneList,
    };
    _labelItems.removeWhere((key, value) => value.isEmpty);
    _mintQrCode = ValueNotifier(widget.mint.mintURL);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: 'Mints',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) =>  _buildItemList(labelName: _labelItems.keys.toList()[index],items: _labelItems.values.toList()[index]),
        separatorBuilder: (context,index) => SizedBox(height: 24.px,),
        itemCount: _labelItems.length,
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
    );
  }

  Widget _buildItem(StepItemModel item){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      child: StepIndicatorItem(
        height: 52.px,
        title: item.title,
        content: item.content != null
            ? Expanded(
                child: Text(item.content!,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 14.px)))
            : null,
        badge: item.badge != null ? Flexible(child: Text(item.badge!, overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14.px))) : null,
        onTap: item.onTap != null ? () => item.onTap!(item) : null,
      ),
    );
  }

  Widget _buildItemList({required String labelName, required List<StepItemModel> items}){
    return CommonLabeledCard(
      label: labelName,
      child: CommonCard(
        radius: 12.px,
        verticalPadding: 0.px,
        horizontalPadding: 0.px,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) =>  _buildItem(items[index]),
          separatorBuilder: (context,index) => Container(height: 0.5.px,color: ThemeColor.color160,),
          itemCount: items.length,
        ),
      ),
    );
  }

  void _editMintName(StepItemModel stepItemModel) {
    _customNameEditController = TextEditingController();
    _customNameEditController!.text = widget.mint.name;
    EcashDialogHelper.showEditMintName(context,controller: _customNameEditController,onTap: (){
      EcashService.editMintName(widget.mint, _customNameEditController!.text).then((value) {
        OXNavigator.pop(context);
        setState(() {
          stepItemModel.badge =  _customNameEditController!.text;
        });
      }).onError((e, s) {
        LogUtil.e('Edit Mint Name Failed: $e\r\n$s');
        CommonToast.instance.show(context, 'Edit Mint Name Failed, Please Try again...');
      });
    });
  }

  Future<void> _handleDefaultMint(StepItemModel stepItemModel) async {
    if(_isDefaultMint){
      await EcashManager.shared.removeDefaultMint();
    }else{
      await EcashManager.shared.setDefaultMint(widget.mint);
    }
    setState(() {
      _isDefaultMint = !_isDefaultMint;
      stepItemModel.title =
      _isDefaultMint ? 'Remove from Default' : 'Set as default mint';
      if(context.mounted) CommonToast.instance.show(context, 'Updated the default mint');
    });
  }

  void _checkProofs() {
    OXLoading.show();
    EcashService.checkProofsAvailable(widget.mint).then((invalidProofCount){
      OXLoading.dismiss();
      if(invalidProofCount == null){
        CommonToast.instance.show(context, 'Request failed, Please try again later');
        return;
      }
      CommonToast.instance.show(context, 'Delete $invalidProofCount proofs');
    });
  }

  void _deleteMint(){
    final mint = widget.mint;
    OXNavigator.pop(context);
    if(mint.balance > 0){
      EcashDialogHelper.showDeleteMint(context);
      return;
    }
    EcashService.deleteMint(mint).then((value){
      if(value){
        EcashManager.shared.deleteMint(mint).then((value){
          CommonToast.instance.show(context, 'Delete Mint successful');
          OXNavigator.pop(context);
        });
      }
      CommonToast.instance.show(context, 'Delete Mint failed');
    });
  }

  @override
  void dispose() {
    _mintQrCode.dispose();
    _customNameEditController?.dispose();
    super.dispose();
  }
}