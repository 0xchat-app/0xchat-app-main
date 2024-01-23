import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';

class CommonModalBottomSheetWidget extends StatelessWidget {
  final String? title;
  final Widget? content;
  final String? confirmContent;
  final Color? confirmContentColor;
  final VoidCallback? confirmCallback;
  const CommonModalBottomSheetWidget({super.key, this.title, this.content, this.confirmContent, this.confirmContentColor, this.confirmCallback});

  @override
  Widget build(BuildContext context) {
    final bottomHeight = MediaQuery.of(context).padding.bottom;
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
          SizedBox(height: 8.px,),
          Text(title ?? 'Tips',style: TextStyle(fontSize: 18.px,fontWeight: FontWeight.w600,color: ThemeColor.color100,height: 25.px / 18.px),),
          SizedBox(height: 8.px,),
          Container(width:double.infinity,height: 0.5.px,color: ThemeColor.color160,),
          content ?? _buildButton(label: confirmContent ?? 'Delete',color: confirmContentColor ?? Colors.red,onTap: confirmCallback),
          Container(width:double.infinity,height: 8.px,color: ThemeColor.color190,),
          _buildButton(label: 'Cancel',onTap: () => OXNavigator.pop(context)),
          SizedBox(height: Adapt.px(bottomHeight),),
        ],
      ),
    );
  }

  Widget _buildButton({required String label,Color? color, VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        height: 56.px,
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w400,color: color ?? ThemeColor.color0),),
      ),
    );
  }
}


class ShowModalBottomSheet {
  static void show(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (context) => child,
    );
  }

  static void showConfirmBottomSheet(BuildContext context,
      {String? title,
      String? confirmContent,
      Color? confirmContentColor,
      VoidCallback? confirmCallback}) {
    show(
      context,
      CommonModalBottomSheetWidget(
        title: title,
        confirmContent: confirmContent,
        confirmContentColor: confirmContentColor,
        confirmCallback: confirmCallback,
      ),
    );
  }

  static void showOptionsBottomSheet(BuildContext context,
      {String? title, required List<BottomSheetItem> options}) {
    show(
      context,
      CommonModalBottomSheetWidget(
        title: title,
        content: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (context, index) => BottomSheetItem(
            iconName: options[index].iconName,
            title: options[index].title,
            subTitle: options[index].subTitle,
            onTap: options[index].onTap,
            enable: options[index].enable,
          ),
          separatorBuilder: (context, index) => Container(height: 0.5.px, color: ThemeColor.color160,),
          itemCount: options.length,
        ),
      ),
    );
  }
}

class BottomSheetItem extends StatelessWidget {
  final String iconName;
  final String? title;
  final String? subTitle;
  final bool enable;
  final VoidCallback? onTap;
  const BottomSheetItem({super.key, required this.iconName, this.title, this.subTitle, bool? enable, this.onTap}) : enable = enable ?? true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.px),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonImage(
                  iconName: iconName,
                  size: 24.px,
                  package: 'ox_wallet',
                ),
                SizedBox(width: 8.px,),
                Text(title ?? '',style: TextStyle(color: ThemeColor.color0,fontSize: 16.px,fontWeight: FontWeight.w400),),
                const Spacer(),
                enable ? CommonImage(
                  iconName: 'icon_wallet_more_arrow.png',
                  size: 24.px,
                  package: 'ox_wallet',
                ) : Container(),
              ],
            ),
            SizedBox(height: 2.px,),
            Text(subTitle ?? '',style: TextStyle(color: ThemeColor.color100,fontSize: 14.px,fontWeight: FontWeight.w400))
          ],
        ),
      ),
    );
  }
}
