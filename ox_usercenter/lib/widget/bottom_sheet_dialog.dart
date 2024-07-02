import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

class BottomSheetItem {
  final String title;
  final VoidCallback? onTap;

  BottomSheetItem({required this.title, this.onTap});
}

class BottomSheetDialog extends StatelessWidget {
  final List<BottomSheetItem> items;
  final String? title;
  final Color? color;
  const BottomSheetDialog({super.key, required this.items, this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(12.px),
          right: Radius.circular(12.px),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if(title != null)
            _buildTitle(title!),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) => _buildButton(context, title: items[index].title,onTap: items[index].onTap, color: color),
            separatorBuilder: (context, index) => Container(height: 0.5.px, color: ThemeColor.color160,),
            itemCount: items.length,
          ),
          Container(width:double.infinity,height: 8.px,color: ThemeColor.color190,),
          _buildButton(context, title: Localized.text('ox_common.cancel'), color: ThemeColor.color0),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required String title, VoidCallback? onTap, Color? color}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        OXNavigator.pop(context);
        onTap?.call();
      },
      child: Container(
        height: 56.px,
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.px,
            fontWeight: FontWeight.w400,
            color: color ?? ThemeColor.color0,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      alignment: Alignment.center,
      height: 36.px,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5.px,
            color: ThemeColor.color160
          )
        )
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.px,
          color: ThemeColor.color100,
        ),
      ),
    );
  }

  static void showBottomSheet(BuildContext context, List<BottomSheetItem> items,
      {String? title, Color? color}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetDialog(
        title: title,
        items: items,
        color: color,
      ),
    );
  }
}
