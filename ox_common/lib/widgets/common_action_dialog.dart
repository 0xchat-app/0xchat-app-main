import 'package:flutter/material.dart';

import 'package:ox_common/navigator/dialog_router.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/adapt.dart';

class OXActionModel<T> {
  static const CancelIdentify = 'ActionModelCancel';

  const OXActionModel({required this.identify,required this.text, this.iconName, this.package});
  final T identify;
  final String text;
  final String? iconName;
  final String? package;

  OXActionModel.fromJson(Map<String, dynamic> jsonMap)
      : identify = jsonMap['identify'],
        text = jsonMap['text'],
        iconName = jsonMap['iconName'],
        package = jsonMap['package'];

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'identify': identify, 'text': text, 'iconName': iconName, 'package': package};

  @override
  bool operator ==(dynamic value) {
    if (value is OXActionModel) {
      OXActionModel aValue = value;
      return identify == aValue.identify;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}

class OXActionDialog extends StatelessWidget {
  OXActionDialog({
    required this.data,
    this.selectedData,
    this.cancelData,
    this.showCancelButton = true,
    double? maxHeight,
    this.maxRow,
    backGroundColor,
    separatorColor,
    separatorCancelColor,
    textColor,
    required this.onPressCallback,
  })  : _maxHeight = maxHeight,
        this.backGroundColor = backGroundColor ?? ThemeColor.color180,
        this.separatorColor = separatorColor ?? ThemeColor.color160,
        this.separatorCancelColor = separatorCancelColor ?? ThemeColor.color190,
        this.textColor = textColor ?? ThemeColor.color10,
        super();


  double get actionHeight => 48.0;

  final List<OXActionModel> data;
  final OXActionModel? selectedData;
  final OXActionModel? cancelData;
  final bool showCancelButton;
  final double? _maxHeight;
  final int? maxRow;
  final void Function(OXActionModel) onPressCallback;
  final Color backGroundColor;
  final Color separatorColor;
  final Color separatorCancelColor;
  final Color textColor;

  double get maxHeight {
    if (_maxHeight != null && _maxHeight! > 0) return _maxHeight!;
    if (maxRow != null && maxRow! > 0) return maxRow! * actionHeight;
    return double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: this.backGroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Adapt.px(4.0)),
              topRight: Radius.circular(Adapt.px(4.0)),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[_buildActionButtonList(), _buildCancelButton()],
            ),
          ) 
        ),
      ),
    );
  }

  Widget _buildActionButtonList() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight), // Above a certain height, you need to roll
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: data.map((OXActionModel item) {
            bool needSeparator = item != data.last;
            bool selected = item == selectedData;
            return _buildActionButton(
              item,
              needSeparator,
              selected,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionButton(OXActionModel item, bool separator, bool selected) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Container(
            width: double.infinity,
            height: Adapt.px(actionHeight),
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                item.iconName == null
                    ? SizedBox()
                    : CommonImage(
                  iconName: item.iconName ?? '',
                  width: Adapt.px(20),
                  height: Adapt.px(20),
                  package: item.package ?? '',
                ),
                SizedBox(width: Adapt.px(6),),
                Text(
                  item.text,
                  style: TextStyle(
                    fontSize: Adapt.px(16.0),
                    fontWeight: selected ?
                    FontWeight.w500 : FontWeight.w400,
                    color: selected
                        ? ThemeColor.red
                        : this.textColor,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            onPressCallback(item);
          },
        ),
        Offstage(
          offstage: !separator,
          child: Container(
            height: Adapt.px(0.5),
            color: this.separatorColor,
          ),
        )
      ],
    );
  }

  Widget _buildCancelButton() {
    OXActionModel item = cancelData ??
        OXActionModel(
          identify: OXActionModel.CancelIdentify,
          text: Localized.text('ox_common.cancel'),
        );
    return Offstage(
      offstage: !showCancelButton,
      child: Column(
        children: <Widget>[
          Container(
            height: Adapt.px(4.0),
            color: separatorCancelColor,
          ),
          GestureDetector(
            child: Container(
              width: double.infinity,
              height: Adapt.px(actionHeight),
              color: Colors.transparent,
              child: Center(
                child: Text(
                  item.text,
                  style: TextStyle(
                    fontSize: Adapt.px(18.0),
                    fontWeight: FontWeight.w400,
                    color: this.textColor,
                  ),
                ),
              ),
            ),
            onTap: () {
              onPressCallback(item);
            },
          ),
        ],
      ),
    );
  }

  static Future<OXActionModel<T>?> show<T>(
    context, {
    required List<OXActionModel> data,
    OXActionModel? selectedData,
    OXActionModel? cancelData,
    bool showCancelButton = true,
    double? maxHeight,
    int? maxRow,
    Color? backGroundColor,
    Color? separatorColor,
    Color? separatorCancelColor,
  }) {
    return showYLEActionDialog<OXActionModel<T>?>(
      context: context,
      builder: (BuildContext context) => OXActionDialog(
        data: data,
        selectedData: selectedData,
        cancelData: cancelData,
        showCancelButton: showCancelButton,
        maxHeight: maxHeight,
        maxRow: maxRow,
        onPressCallback: (OXActionModel item) {
          OXNavigator.pop(
            context,
            item,
          );
        },
        backGroundColor:backGroundColor,
        separatorColor: separatorColor,
        separatorCancelColor: separatorCancelColor,
      )
    );
  }
}
