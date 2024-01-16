import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_toast.dart';
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
  late ValueNotifier<String> _mintQrCode;
  TextEditingController? _customNameEditController;
  late bool _isDefaultMint;

  @override
  void initState() {
    _isDefaultMint = EcashManager.shared.defaultIMint.mintURL == widget.mint.mintURL;
    _generalList = [
      StepItemModel(title: 'Mint',content: widget.mint.mintURL),
      StepItemModel(title: 'Balance',content: '${widget.mint.balance} Sats'),
      StepItemModel(title: 'Show QR code',onTap: (value) => EcashDialogHelper.showMintQrCode(context, _mintQrCode)),
      StepItemModel(title: 'Custom name',badge: widget.mint.name,onTap: _editMintName),
      StepItemModel(title: _isDefaultMint ? 'Remove from Default' : 'Set as default mint',onTap: _setDefaultMint),
      StepItemModel(title: 'More Info', onTap: (value) => OXNavigator.pushPage(context, (context) => WalletMintInfo(mintInfo: widget.mint.info,))),
    ];
    _dangerZoneList = [
      StepItemModel(title: 'Check proofs',onTap: (value) => EcashDialogHelper.showCheckProofs(context)),
      StepItemModel(title: 'Delete mint',onTap: (value) => ShowModalBottomSheet.showConfirmBottomSheet(context,title: 'Delete mint?')),
    ];
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
      body: Column(
        children: [
          _buildItemList(labelName: 'GENERAL',items: _generalList),
          SizedBox(height: 24.px,),
          _buildItemList(labelName: 'DANGER ZONE',items: _dangerZoneList),
        ],
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
                child: Text(WalletUtils.formatString(item.content!, 40, 20, 10),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 14.px)))
            : null,
        badge: item.badge != null ? Text(item.badge!, style: TextStyle(fontSize: 14.px)) : null,
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

  void _setDefaultMint(StepItemModel stepItemModel) {
    _isDefaultMint = !_isDefaultMint;
    stepItemModel.title = _isDefaultMint ? 'Remove from Default' : 'Set as default mint';
    EcashManager.shared.updateMintList(widget.mint);
    setState(() {
    });
  }

  @override
  void dispose() {
    _mintQrCode.dispose();
    _customNameEditController?.dispose();
    super.dispose();
  }
}

