
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';

class OXRadioListTileItemModel {
  OXRadioListTileItemModel({required this.title, this.isSelected = false});
  String title;
  bool isSelected;
}

class OXRadioListTile extends StatefulWidget {

  final List<OXRadioListTileItemModel> modelList;

  final bool isMultiSelect;

  final bool Function(OXRadioListTileItemModel value)? onSelected;

  OXRadioListTile({
    Key? key,
    required this.modelList,
    this.isMultiSelect = false,
    this.onSelected,
  }) : super(key: key);

  @override
  State<OXRadioListTile> createState() => _OXRadioListTileState();
}

class _OXRadioListTileState extends State<OXRadioListTile> {

  List<OXRadioListTileItemModel> modelList = [];

  OXRadioListTileItemModel? selectedModel;

  @override
  void initState() {
    super.initState();

    modelList = widget.modelList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: modelList.length,
        itemBuilder: _itemBuild,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) {
          return Divider(height:1, color: ThemeColor.color150);
        },
      ),
    );
  }

  Widget _itemBuild(BuildContext context, int index) {
    OXRadioListTileItemModel _model = modelList[index];
    return GestureDetector(
      onTap: () {
        if (widget.onSelected != null && !widget.onSelected!(_model)) {
          return ;
        }
        setState(() {
          _model.isSelected = !_model.isSelected;
          if (!widget.isMultiSelect && _model.isSelected) {
            modelList.where((element) => element != _model).forEach((element) { element.isSelected = false; });
          }
        });
      },
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: Adapt.px(52),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
              title: Container(
                margin: EdgeInsets.only(left: Adapt.px(12)),
                child: Text(
                  _model.title,
                  style: TextStyle(
                    color: ThemeColor.color0,
                    fontSize: Adapt.px(16),
                  ),
                ),
              ),
              trailing: _relayStateImage(_model),
            ),
          ),
        ],
      ),
    );
  }

  Widget _relayStateImage(OXRadioListTileItemModel model) {
    if (model.isSelected) {
      return CommonImage(
        iconName: 'icon_pic_selected.png',
        width: Adapt.px(24),
        height: Adapt.px(24),
      );
    } else {
      return SizedBox(
        width: Adapt.px(24),
        height: Adapt.px(24),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          value: 0,
          backgroundColor: ThemeColor.color0.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(ThemeColor.color170),
        ),
      );
    }
  }
}
