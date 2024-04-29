import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_localizable/ox_localizable.dart';

class BottomItemModel {
  final String title;
  final VoidCallback? onTap;

  BottomItemModel({required this.title, this.onTap});
}

class MomentBottomSheetDialog extends StatelessWidget {
  final List<BottomItemModel> items;
  const MomentBottomSheetDialog({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(12.px),right: Radius.circular(12.px)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) => _buildButton(context, title: items[index].title,onTap: items[index].onTap),
            separatorBuilder: (context, index) => Container(height: 0.5.px, color: ThemeColor.color160,),
            itemCount: items.length,
          ),
          Container(width:double.infinity,height: 8.px,color: ThemeColor.color190,),
          _buildButton(context, title: Localized.text('ox_wallet.cancel'),onTap: () => OXNavigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, {required String title, VoidCallback? onTap}) {
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
            color: ThemeColor.color0,
          ),
        ),
      ),
    );
  }

  static void showBottomSheet(BuildContext context, List<BottomItemModel> items) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MomentBottomSheetDialog(
        items: items,
      ),
    );
  }
}