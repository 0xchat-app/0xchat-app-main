
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/dialog_router.dart';

import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';


class OXMenuItem<T> {

  OXMenuItem({
    required this.identify,
    required this.text,
    this.iconName = '',
    this.package = 'ox_common',
  });

  final T identify;
  final String text;
  final String iconName;
  final String package;

  @override
  bool operator ==(dynamic value) {
    if (value is OXMenuItem) {
      OXMenuItem aValue = value;
      return identify == aValue.identify;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}

class OXMenuDialog extends StatelessWidget {
  OXMenuDialog({
    required this.data,
    required this.onPressCallback,
    this.selectedData,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
  });

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;

  double get actionHeight => Adapt.px(40);

  final List<OXMenuItem> data;
  final OXMenuItem? selectedData;
  final void Function(OXMenuItem) onPressCallback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          width: width,
          height: height,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: ThemeColor.dark03,
                borderRadius: BorderRadius.all(Radius.circular(Adapt.px(4.0))),
                boxShadow:[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, Adapt.px(5)),
                    blurRadius: Adapt.px(10),
                  ),
                ],
              ),
              child: _buildActionButtonList()
            ),
          ),
        )
      ],
    );
  }

  Widget _buildActionButtonList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: data.map((OXMenuItem item) {
        bool selected = item == selectedData;
        return _buildActionButton(item, selected,);
      }).toList(),
    );
  }

  Widget _buildActionButton(OXMenuItem item, bool selected) {
    return OXButton(
      radius: Adapt.px(4),
      color: ThemeColor.dark03,
      highlightColor: ThemeColor.dark02,
      onPressed: () {
        onPressCallback(item);
      },
      height: actionHeight,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: Adapt.px(10)),
            child:
            CommonImage(
              iconName: item.iconName,
              width: Adapt.px(16),
              height: Adapt.px(16),
              color: ThemeColor.gray02,
              package: item.package,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: Adapt.px(12)),
            child: Text(
              item.text,
              style: TextStyle(
                  color: ThemeColor.gray02,
                  fontSize: Adapt.px(14),
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<OXMenuItem?> show(
    context, {
    required List<OXMenuItem> data,
    OXMenuItem? selectedData,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return showYLEDialog(
      context: context,
      barrierColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: 200),
      builder: (BuildContext context) => OXMenuDialog(
        data: data,
        selectedData: selectedData,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        width: width ?? Adapt.px(170),
        height: height,
        onPressCallback: (OXMenuItem item) {
          OXNavigator.pop(
            context,
            item,
          );
        },
      ),
    );
  }
}
