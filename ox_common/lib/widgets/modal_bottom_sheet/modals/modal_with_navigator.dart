import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

class ModalWithNavigator extends StatelessWidget {
  final String? title;
  final Widget? child;
  final int? marginValue;

  const ModalWithNavigator({required this.title, required this.child, this.marginValue});

  @override
  Widget build(BuildContext rootContext) {
    return Material(
        child: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (context2) => Builder(
          builder: (context) => CupertinoPageScaffold(
            // navigationBar: CupertinoNavigationBar(
            //     leading: SizedBox(), middle: Text(title ?? '', style: TextStyle(color: ThemeColor.color10),),
            //   backgroundColor: ThemeColor.color190,
            // ),
            backgroundColor: ThemeColor.color10,
            child: SafeArea(
              bottom: false,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: Adapt.px(marginValue ?? 12), horizontal: Adapt.px(marginValue ?? 12)),
                child: child ?? SizedBox(),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
