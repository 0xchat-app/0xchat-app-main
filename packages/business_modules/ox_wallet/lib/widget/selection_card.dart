import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_wallet/widget/common_card.dart';

class SelectionCard extends StatefulWidget {
  final List<CardItemModel> items;
  final bool enableSelection;
  final ValueChanged? onChanged;
  const SelectionCard({super.key, required this.items,bool ? enableSelection, this.onChanged}) : enableSelection = enableSelection ?? true;

  @override
  State<SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard> {

  final List<CardItemModel> _selectedItem = [];

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      verticalPadding: 0,
      horizontalPadding: 0,
      child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: _buildItem,
          separatorBuilder: (context,index) => Container(height: 0.5.px,color: ThemeColor.color160,),
          itemCount: widget.items.length),
    );
  }

  Widget _buildItem(context, index) {
    final item = widget.items[index];
    bool isSelected = _selectedItem.contains(item);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        if(_selectedItem.contains(item)){
          _selectedItem.remove(item);
        }else{
          _selectedItem.add(item);
        }
        if(widget.onChanged!=null){
          widget.onChanged!(_selectedItem);
        }
        setState(() {});
      },
      child: CommonCardItem(
        label: item.label,
        content: item.content,
        action: widget.enableSelection ? CommonImage(
          iconName: isSelected ? 'icon_item_selected.png' : 'icon_item_unselected.png',
          size: 24.px,
          package: 'ox_wallet',
        ) : Container(),
      ),
    );
  }
}

