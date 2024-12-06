import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_wallet/widget/common_card.dart';
import 'package:cashu_dart/cashu_dart.dart';

class ProofSelectionCard extends StatefulWidget {
  final List<ProofIsar> items;
  final bool enableSelection;
  final ValueChanged<List<ProofIsar>>? onChanged;
  final ScrollPhysics? physics;
  const ProofSelectionCard({super.key, required this.items,bool ? enableSelection, this.onChanged, this.physics}) : enableSelection = enableSelection ?? true;

  @override
  State<ProofSelectionCard> createState() => _ProofSelectionCardState();
}

class _ProofSelectionCardState extends State<ProofSelectionCard> {
  final List<ProofIsar> _selectedItem = [];

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      verticalPadding: 0,
      horizontalPadding: 0,
      child: ListView.separated(
          physics: widget.physics,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: _buildItem,
          separatorBuilder: (context,index) => Container(height: 0.5.px,color: ThemeColor.color160,),
          itemCount: widget.items.length),
    );
  }

  Widget _buildItem(context, index) {
    final proof = widget.items[index];
    bool isSelected = _selectedItem.contains(proof);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        if(_selectedItem.contains(proof)){
          _selectedItem.remove(proof);
        }else{
          _selectedItem.add(proof);
        }
        if(widget.onChanged!=null){
          widget.onChanged!(_selectedItem);
        }
        setState(() {});
      },
      child: CommonCardItem(
        label: proof.amount,
        content: proof.keysetId,
        action: widget.enableSelection ? CommonImage(
          iconName: isSelected ? 'icon_item_selected.png' : 'icon_item_unselected.png',
          size: 24.px,
          package: 'ox_wallet',
          useTheme: true,
        ) : Container(),
      ),
    );
  }
}